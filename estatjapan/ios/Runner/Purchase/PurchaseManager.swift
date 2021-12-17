//
//  PurchaseManager.swift
//  Runner
//
//  Created by YanQi on 2021/10/11.
//

//
//  InAppPurchase.swift
//  ios_swift_in_app_purchases_sample
//
//  Created by Maxim Bilan on 7/27/15.
//  Copyright (c) 2015 Maxim Bilan. All rights reserved.
//

import Foundation
import StoreKit

class PurchaseManager: NSObject {
    
    static let sharedInstance = PurchaseManager()
    
#if DEBUG
    fileprivate let verifyReceiptURL = "https://sandbox.itunes.apple.com/verifyReceipt"
#else
    fileprivate let verifyReceiptURL = "https://buy.itunes.apple.com/verifyReceipt"
#endif
    
    fileprivate var deleteAdsProductId: String? {
        Bundle.main.infoDictionary?["DELETE_ADS_PRODUCT_ID"] as? String
    }
    
    fileprivate var sharedSecret: String? {
        Bundle.main.infoDictionary?["SHARED_SECRET"] as? String
    }
    
    fileprivate let productIdentifierKey = "productIdentifierKey"
    fileprivate let productIdentifierUsedTrialKey = "productIdentifierUsedTrialKey"
    
    var isPurchaseDeleteAds: Bool {
        guard let productIdentifier = UserDefaults.standard.string(forKey: productIdentifierKey),
              !productIdentifier.isEmpty else {
                  return false
              }
        return true
    }
    
    var isUsedTrialKey: Bool {
        return UserDefaults.standard.bool(forKey: productIdentifierUsedTrialKey)
    }
    
    fileprivate var task: URLSessionDataTask?
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    func deleteAds() {
        guard let productIdentifier = deleteAdsProductId else {
            purchaseError()
            return
        }
        if SKPaymentQueue.canMakePayments() {
            let productRequester = ProductRequester()
            productRequester.requestProducts(productIds: [productIdentifier]) { [weak self] result in
                switch result {
                case .success(let products):
                    guard let product = products.first else {
                        self?.purchaseError()
                        return
                    }
                    let payment = SKPayment(product: product)
                    SKPaymentQueue.default().add(payment)
                case .failure:
                    self?.purchaseError()
                }
                productRequester.completion = nil
            }
        }
        else {
            purchaseError(payingProductIdentifier: productIdentifier)
        }
    }
    
    func restoreTransactions() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    fileprivate func purchaseError(payingProductIdentifier: String? = nil, msg: String? = nil) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let alertView = UIAlertController.init(title: msg ?? "課金失敗しました", message: nil, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
        }
        alertView.addAction(action)
        appDelegate.window.rootViewController?.present(alertView, animated: true, completion: nil)
    }
    
    fileprivate func savePurchasedProductIdentifier(productIdentifier: String, msg: String? = nil) {
        guard !isPurchaseDeleteAds else {return}
        UserDefaults.standard.set(productIdentifier, forKey: productIdentifierKey)
        UserDefaults.standard.set(true, forKey: self.productIdentifierUsedTrialKey)
        UserDefaults.standard.synchronize()
        deleleFlutterAds()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let alertView = UIAlertController.init(title: msg ?? "課金成功しました", message: nil, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
        }
        alertView.addAction(action)
        appDelegate.window.rootViewController?.present(alertView, animated: true, completion: nil)
    }
    
    fileprivate func deleleFlutterAds() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        guard let flutterVC = appDelegate.flutterVC else {return}
        let purchaseModel = EJPurchaseModel()
        purchaseModel.isPurchase = true
        EJFlutterPurchaseModelApi(binaryMessenger: flutterVC.binaryMessenger).sendPurchaseModelPurchaseModel(purchaseModel) { error in
            guard let error = error else {return}
            debugPrint(error)
        }
    }
    
    fileprivate func completePay(transactions: [SKPaymentTransaction]) {
        let transaction: SKPaymentTransaction
        if transactions.count > 1 {
            transaction = transactions.max(by: {($0.transactionDate ?? Date()) <= ($1.transactionDate ?? Date())}) ?? transactions.last!
            transactions.filter({$0.transactionIdentifier != transaction.transactionIdentifier}).forEach({SKPaymentQueue.default().finishTransaction($0)})
        } else {
            transaction = transactions[0]
        }
        
        guard let recepitUrl = Bundle.main.appStoreReceiptURL,
              FileManager.default.fileExists(atPath: recepitUrl.path),
              let data = try? Data(contentsOf: recepitUrl, options: .alwaysMapped) else {
                  purchaseError()
                  return
              }
        debugPrint("\(String(describing: String.init(data: data, encoding: .utf8)))")
        verify(data: data, transaction: transaction)
    }
    
    fileprivate func verify(data: Data, transaction: SKPaymentTransaction) {
        
        let base64Str = data.base64EncodedString(options: [])
        let params = NSMutableDictionary()
        params["receipt-data"] = base64Str
        params["password"] = sharedSecret ?? ""
        let body = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        var request = URLRequest.init(url: URL.init(string: verifyReceiptURL)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
        request.httpMethod = "POST"
        request.httpBody = body
        let session = URLSession.shared
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil,
                    let data = data,
                  let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary else {
                      return
                  }
            SKPaymentQueue.default().finishTransaction(transaction)
            let status = dict["status"] as! Int
            DispatchQueue.main.async {
                switch(status){
                case 0:
                    self.savePurchasedProductIdentifier(productIdentifier: transaction.payment.productIdentifier)
                    break
                default:
                    //                    self.purchaseError(payingProductIdentifier: transaction.payment.productIdentifier)
                    UserDefaults.standard.removeObject(forKey: self.productIdentifierKey)
                    UserDefaults.standard.synchronize()
                    break
                }
            }
        }
        task?.resume()
    }
    
    func isTrialEnabled(completion: @escaping (Bool) -> Void) {
        guard !isUsedTrialKey else {
            completion(false)
            return
        }
        
#if DEBUG
    completion(true)
#else
        if let deleteAdsProductId = deleteAdsProductId, !deleteAdsProductId.isEmpty {
           let productRequester = ProductRequester()
            productRequester.requestProducts(productIds: [deleteAdsProductId]) { result in
                switch result {
                case .success(let products):
                    let isTrialTarget = products.contains(where: {$0.introductoryPrice != nil})
                    completion(isTrialTarget)
                case .failure:
                    completion(false)
                }
            }
        } else {
            completion(false)
        }
#endif
    }
}

extension PurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        var paymentTransactions: [SKPaymentTransaction] = []
        for transaction: AnyObject in transactions {
            if let trans: SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased, .restored:
                    debugPrint("課金済み")
                case .failed:
                    UserDefaults.standard.removeObject(forKey: productIdentifierKey)
                    UserDefaults.standard.synchronize()
                    SKPaymentQueue.default().finishTransaction(trans)
                    purchaseError(payingProductIdentifier: trans.payment.productIdentifier)
                    continue
                    
                default:
                    continue
                }
                paymentTransactions.append(trans)
            }
        }
        
        if paymentTransactions.count > 0 {
            completePay(transactions: paymentTransactions)
        } else {
            UserDefaults.standard.removeObject(forKey: productIdentifierKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        purchaseError(msg: "課金復元失敗しました")
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        guard queue.transactions.count > 0 else {
            purchaseError(msg: "課金復元失敗しました")
            return
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, didRevokeEntitlementsForProductIdentifiers productIdentifiers: [String]) {
        
        UserDefaults.standard.removeObject(forKey: self.productIdentifierKey)
        UserDefaults.standard.removeObject(forKey: self.productIdentifierUsedTrialKey)
        isTrialEnabled { isEnabled in
            UserDefaults.standard.set(isEnabled, forKey: self.productIdentifierUsedTrialKey)
            UserDefaults.standard.synchronize()
        }
    }
}

