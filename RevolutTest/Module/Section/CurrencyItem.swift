//
//  CurrencyItem.swift
//  RevolutTest
//
//  Created by Daniil Smirnov on 28/08/2018.
//  Copyright © 2018 Daniil Smirnov. All rights reserved.
//

import Foundation
import IGListKit


class CurrencyItem: ListDiffable, Equatable {
    
    var didInput: ((_ value: Double) -> Void)?
    var didSelect: ((_ value: Double) -> Void)?
    var baseCurrencyGetter: (() -> Currency?)?
    
    let currency: Currency
    var value: Double
    
    init(currency: Currency, value: Double) {
        self.currency = currency
        self.value = value
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return currency.code as NSObject
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let item = object as? CurrencyItem else { return false }

        if let currency = baseCurrencyGetter?(), currency.code == self.currency.code {
            return true
        }
        
        return item == self
    }
    
    
    static public func ==(rhs: CurrencyItem, lhs: CurrencyItem) -> Bool {
        return rhs.value == lhs.value
    }
}
