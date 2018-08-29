//
//  CurrencyDataService.swift
//  RevolutTest
//
//  Created by Daniil Smirnov on 28/08/2018.
//  Copyright © 2018 Daniil Smirnov. All rights reserved.
//

import Foundation
import ReactiveSwift
import Moya


protocol CurrencyDataServiceProtocol: class {
    func getRates(for currency: Currency) -> SignalProducer<RatesFeed, MoyaError>
}


class CurrencyDataService: CurrencyDataServiceProtocol {
    
    func getRates(for currency: Currency) -> SignalProducer<RatesFeed, MoyaError> {
        return provider
            .reactive
            .request(.getRates(base: currency))
            .decode ({ json in
                guard let feed: RatesFeed = json.decode() else {
                    return nil
                }
                
                return feed
            })
    }

    
    // MARK: fileprivate
    
    let provider = MoyaProvider<CurrencyAPI>()
}
