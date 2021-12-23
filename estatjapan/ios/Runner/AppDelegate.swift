import UIKit
import Flutter
import GoogleMobileAds
import Firebase
import UserNotifications
import AppTrackingTransparency
import AdSupport

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, GADFullScreenContentDelegate {
    var appOpenAd: GADAppOpenAd?
    var isLoadingAd = false
    var isShowingAd = false
    /// Keeps track of the time an app open ad is loaded to ensure you don't show an expired ad.
    var loadTime = Date()
    let gcmMessageIDKey = "gcm.message_id"
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if !PurchaseManager.sharedInstance.isPurchaseDeleteAds {
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        }
        FirebaseApp.configure()
        GeneratedPluginRegistrant.register(with: self)
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        initFlutterApi()
        application.registerForRemoteNotifications()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func applicationDidBecomeActive(_ application: UIApplication) {
        if let currentVC = application.keyWindow?.rootViewController {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: {   [weak self] status in
                    self?.showAdIfAvailable(viewController: currentVC)
                })
            } else {
                showAdIfAvailable(viewController: currentVC)
            }
        }
    }
    
    func loadAd() {
        // Do not load ad if there is an unused ad or one is already loading.
        if isLoadingAd || isAdAvailable() {
            return
        }
        isLoadingAd = true
        let AD_UNIT_ID = Bundle.main.infoDictionary?["AD_UNIT_ID"] as? String ?? ""
        debugPrint("Start loading ad.")
        GADAppOpenAd.load(
            withAdUnitID: AD_UNIT_ID,
            request: GADRequest(),
            orientation: UIInterfaceOrientation.portrait
        ) { ad, error in
            if let error = error {
                self.isLoadingAd = false
                debugPrint("App open ad failed to load with error: \(error.localizedDescription).")
                return
            }
            
            self.appOpenAd = ad
            self.appOpenAd?.fullScreenContentDelegate = self
            self.isLoadingAd = false
            self.loadTime = Date()
            debugPrint("Loading Succeeded.")
        }
    }
    
    func wasLoadTimeLessThanNHoursAgo(numHours: Int) -> Bool {
        // Check if ad was loaded more than n hours ago.
        let timeIntervalBetweenNowAndLoadTime = Date().timeIntervalSince(loadTime)
        let secondsPerHour = 3600.0
        let intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour
        return intervalInHours < Double(numHours)
    }
    
    func isAdAvailable() -> Bool {
        // Check if ad exists and can be shown.
        // Ad references in the app open beta will time out after four hours, but this time limit
        // may change in future beta versions. For details, see:
        // https://support.google.com/admob/answer/9341964?hl=en
        return appOpenAd != nil && wasLoadTimeLessThanNHoursAgo(numHours: 4)
    }
    
    func showAdIfAvailable(viewController: UIViewController) {
        guard !PurchaseManager.sharedInstance.isPurchaseDeleteAds else { return }
        // If the app open ad is already showing, do not show the ad again.
        if isShowingAd {
            debugPrint("The app open ad is already showing.")
            return
        }
        // If the app open ad is not available yet, invoke the callback then load the ad.
        if !isAdAvailable() {
            debugPrint("The app open ad is not ready yet.")
            loadAd()
            return
        }
        if let ad = appOpenAd {
            debugPrint("Will show ad.")
            isShowingAd = true
            ad.present(fromRootViewController: viewController)
        }
    }
    
    // MARK: GADFullScreenContentDelegate
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        debugPrint("App open ad presented.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        appOpenAd = nil
        isShowingAd = false
        debugPrint("App open ad dismissed.")
        loadAd()
    }
    
    func ad(
        _ ad: GADFullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        appOpenAd = nil
        isShowingAd = false
        debugPrint("App open ad failed to present with error: \(error.localizedDescription).")
        loadAd()
    }
    
    override func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        debugPrint("Message ID: \(messageID)")
      }

      // Print full message.
      debugPrint(userInfo)
    }

    // [START receive_message]
    override func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                       -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        debugPrint("Message ID: \(messageID)")
      }

      // Print full message.
      debugPrint(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }

    // [END receive_message]
    override func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
      debugPrint("Unable to register for remote notifications: \(error.localizedDescription)")
    }

    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    override func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      debugPrint("APNs token retrieved: \(deviceToken)")

      // With swizzling disabled you must set the APNs token here.
      // Messaging.messaging().apnsToken = deviceToken
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate {
    // Receive displayed notifications for iOS 10 devices.
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                         willPresent notification: UNNotification,
                                         withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                         -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // [START_EXCLUDE]
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            debugPrint("Message ID: \(messageID)")
        }
        // [END_EXCLUDE]
        // Print full message.
        debugPrint(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([[.alert, .sound]])
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                         didReceive response: UNNotificationResponse,
                                         withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // [START_EXCLUDE]
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            debugPrint("Message ID: \(messageID)")
        }
        // [END_EXCLUDE]
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print full message.
        debugPrint(userInfo)
        
        completionHandler()
    }
}

// [END ios_10_message_handling]
extension AppDelegate: MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        debugPrint("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    // [END refresh_token]
}
