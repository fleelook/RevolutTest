//
//  CountryCodesHolder.swift
//  RevolutTest
//
//  Created by Daniil Smirnov on 28/08/2018.
//  Copyright © 2018 Daniil Smirnov. All rights reserved.
//

import Foundation


struct CurrencyToRegionMapper {
    
    static func regionCode(for currencyCode: String) -> String? {
        return locales.first(where: { $0.currencyCode == currencyCode })?.regionCode
    }
    
    static let locales = Locale.availableIdentifiers.map(Locale.init)
}
