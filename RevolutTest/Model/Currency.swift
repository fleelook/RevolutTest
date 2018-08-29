//
//  Currency.swift
//  RevolutTest
//
//  Created by Daniil Smirnov on 28/08/2018.
//  Copyright © 2018 Daniil Smirnov. All rights reserved.
//

import Foundation


public struct Currency: Equatable {
    let code: String
    
    
    // MARK: Equatable
    
    static public func ==(rhs: Currency, lhs: Currency) -> Bool {
        return rhs.code == lhs.code
    }
}
