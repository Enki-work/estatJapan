//
//  ProductRequester.swift
//  Runner
//
//  Created by YanQi on 2021/12/15.
//

import Foundation
import StoreKit

final class ProductRequester: NSObject {
    struct ProductRequesterError: Error{}
    typealias Completion = ((Result<[SKProduct], Error>) -> Void)
    var completion: Completion?
    private var productIds: [String]?
    private var stongSelf: ProductRequester?
    
    func requestProducts(productIds: [String],
                         completion: @escaping Completion) {
        guard self.completion == nil else {return}
        self.stongSelf = self
        self.completion = completion
        self.productIds = productIds
        let productReq = SKProductsRequest(productIdentifiers: Set(productIds))
        productReq.delegate = self
        productReq.start()
    }
}
extension ProductRequester: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard response.products.count == self.productIds?.count else {
            completion?(.failure(ProductRequesterError()))
            return
        }
        completion?(.success(response.products))
        self.stongSelf = nil
    }
}
