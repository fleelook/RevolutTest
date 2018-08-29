//
//  RatesDataTests.swift
//  RevolutTestTests
//
//  Created by Daniil Smirnov on 29/08/2018.
//  Copyright © 2018 Daniil Smirnov. All rights reserved.
//

import XCTest
import Foundation
@testable import RevolutTest


class RatesDataTests: XCTestCase {
    
    static func generateIdenticalRatesDataAndJSON() -> (taxData: RatesFeed, json: JSON) {
        let currencyCode = "EUR"
        let baseCurrency = Currency(code: currencyCode)
        
        var rates: [String : Double] = [
            "EUR" : 1,
            "RUB" : 100,
            "USD" : 50,
            "GBP" : 10
        ]
        
        let ratesFeed = RatesFeed(baseCurrency: baseCurrency,
                                  rates: rates)
        rates.removeValue(forKey: "EUR")
        
        let json: JSON = [
            "base": currencyCode,
            "rates": JSON(rates)
        ]
        
        return (ratesFeed, json)
    }
    
    func testJSONDecoding() {
        let (ratesData, json) = RatesDataTests.generateIdenticalRatesDataAndJSON()
        XCTAssertEqual(ratesData, RatesFeed(json: json)!)
    }
}
