//
//  FlutterApi.swift
//  Runner
//
//  Created by YanQi on 2021/10/07.
//

import Foundation
import Flutter
extension AppDelegate: EJHostPurchaseModelApi {
    
    var flutterVC: FlutterViewController? {
        window.rootViewController as? FlutterViewController
    }
    
    func initFlutterApi() {
        guard let flutterVC = self.flutterVC else {return}
        EJHostPurchaseModelApiSetup(flutterVC.binaryMessenger, self)
    }
    
    public func getPurchaseModelWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> EJPurchaseModel? {
        let purchaseModel = EJPurchaseModel()
        purchaseModel.isPurchase = NSNumber(booleanLiteral: PurchaseManager.sharedInstance.isPurchaseDeleteAds)
        purchaseModel.isUsedTrial = NSNumber(booleanLiteral: PurchaseManager.sharedInstance.isUsedTrial)
        
        return purchaseModel
    }
    
    func requestPurchaseModelWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> NSNumber? {
        PurchaseManager.sharedInstance.deleteAds()
        return NSNumber(booleanLiteral: true)
    }
    
    func restorePurchaseModelWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> NSNumber? {
        PurchaseManager.sharedInstance.restoreTransactions()
        return NSNumber(booleanLiteral: true)
    }
    
    
}
