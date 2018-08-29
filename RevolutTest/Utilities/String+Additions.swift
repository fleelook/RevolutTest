//
//  String+Additions.swift
//  RevolutTest
//
//  Created by Daniil Smirnov on 29/08/2018.
//  Copyright © 2018 Daniil Smirnov. All rights reserved.
//

import Foundation


extension String {
    var doubleValue: Double? {
        let nf = NumberFormatter()
        nf.decimalSeparator = "."
        if let result = nf.number(from: self) {
            return result.doubleValue
        } else {
            nf.decimalSeparator = ","
            if let result = nf.number(from: self) {
                return result.doubleValue
            }
        }
        return nil
    }
}
