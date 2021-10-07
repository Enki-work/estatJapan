//
//  FlutterApi.swift
//  Runner
//
//  Created by YanQi on 2021/10/07.
//

import Foundation
import Flutter
extension AppDelegate: EJPurchaseModelApi {
    
    var flutterVC: FlutterViewController? {
        window.rootViewController as? FlutterViewController
    }
    
    func initFlutterApi() {
        guard let flutterVC = self.flutterVC else {return}
        EJPurchaseModelApiSetup(flutterVC.binaryMessenger, self)
    }
    
    public func getPurchaseModelWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> EJPurchaseModel? {
        let purchaseModel = EJPurchaseModel()
        purchaseModel.isPurchase = true
        return purchaseModel
    }
}
