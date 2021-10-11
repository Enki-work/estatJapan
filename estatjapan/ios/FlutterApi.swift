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
        purchaseModel.isPurchase = false
        return purchaseModel
    }
    
    func requestPurchaseModelWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> NSNumber? {
        guard let flutterVC = self.flutterVC else {return NSNumber(booleanLiteral: false)}
        let purchaseModel = EJPurchaseModel()
        purchaseModel.isPurchase = true
        EJFlutterPurchaseModelApi(binaryMessenger: flutterVC.binaryMessenger).sendPurchaseModelPurchaseModel(purchaseModel) { error in
            debugPrint(error)
        }
        return NSNumber(booleanLiteral: true)
    }
}
