//
//  RatesFeed.swift
//  RevolutTest
//
//  Created by Daniil Smirnov on 28/08/2018.
//  Copyright © 2018 Daniil Smirnov. All rights reserved.
//

import Foundation


struct RatesFeed: JSONDecodable, Equatable {
    
    let baseCurrency: Currency
    let rates: [String: Double]
    
    public init(baseCurrency: Currency, rates: [String: Double]) {
        self.rates = rates
        self.baseCurrency = baseCurrency
    }
    
    
    // MARK: JSON
    
    private enum JSONKeys: String {
        case base
        case rates
    }
    
    public init?(json JSONValue: JSON) {
        guard
            let code: String = JSONValue[JSONKeys.base.rawValue]?.decode(),
            let ratesDict = JSONValue[JSONKeys.rates.rawValue]?.dictionaryValue
            else { return nil }
        
        let currency = Currency(code: code)
        var rates: [String: Double] = [code : 1.0]
        ratesDict.keys.forEach { key in
            guard let value: Double = ratesDict[key]??.decode() else { return }
            
            rates[key] = value
        }
        
        self.init(baseCurrency: currency,
                  rates: rates)
    }
    
    
    // MARK: Equatable
    
    static public func ==(rhs: RatesFeed, lhs: RatesFeed) -> Bool {
        return lhs.baseCurrency == rhs.baseCurrency && lhs.rates == rhs.rates
    }
}
