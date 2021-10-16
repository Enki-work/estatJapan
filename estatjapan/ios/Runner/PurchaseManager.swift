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
    fileprivate let productIdentifierKey = "productIdentifierKey"
    
    var isPurchaseDeleteAds: Bool {
        guard let productIdentifier = UserDefaults.standard.string(forKey: productIdentifierKey),
              !productIdentifier.isEmpty else {
                  return false
              }
        return true
    }
    
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
            let productID: NSSet = NSSet(object: productIdentifier)
            let productsRequest: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            productsRequest.delegate = self
            productsRequest.start()
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
        UserDefaults.standard.set(productIdentifier, forKey: productIdentifierKey)
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
    
    fileprivate func completePay(transaction: SKPaymentTransaction) {
        defer {
            SKPaymentQueue.default().finishTransaction(transaction)
        }
        guard let recepitUrl = Bundle.main.appStoreReceiptURL,
              let data = try? Data.init(contentsOf: recepitUrl) else {
                  purchaseError()
                  return
              }
        
        verify(data: data,transaction: transaction)
    }
    
    fileprivate func verify(data: Data, transaction: SKPaymentTransaction) {
        let base64Str = data.base64EncodedString(options: .endLineWithLineFeed)
        let params = NSMutableDictionary()
        params["receipt-data"] = base64Str
        let body = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        var request = URLRequest.init(url: URL.init(string: verifyReceiptURL)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
        request.httpMethod = "POST"
        request.httpBody = body
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            let dict = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
            SKPaymentQueue.default().finishTransaction(transaction)
            let status = dict["status"] as! Int
            DispatchQueue.main.async {
                switch(status){
                case 0:
                    self.savePurchasedProductIdentifier(productIdentifier: transaction.payment.productIdentifier)
                    break
                default:
                    self.purchaseError(payingProductIdentifier: transaction.payment.productIdentifier)
                    break
                }
            }
        }
        task.resume()
    }
}

extension PurchaseManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let count: Int = response.products.count
        if count > 0 {
            let validProduct = response.products.first!
            let payment = SKPayment(product: validProduct)
            SKPaymentQueue.default().add(payment)
        }
        else {
            purchaseError(payingProductIdentifier: response.invalidProductIdentifiers.first ?? "")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        purchaseError()
    }
    
    func requestDidFinish(_ request: SKRequest) {
        
    }
}

extension PurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction: AnyObject in transactions {
            if let trans: SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    completePay(transaction: trans)
                    break
                    
                case .failed:
                    purchaseError(payingProductIdentifier: trans.payment.productIdentifier)
                    SKPaymentQueue.default().finishTransaction(trans)
                    break
                    
                case .restored:
                    savePurchasedProductIdentifier(productIdentifier: trans.payment.productIdentifier)
                    SKPaymentQueue.default().finishTransaction(trans)
                    break
                    
                default:
                    break
                }
                
            } else {
                
            }
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
}

