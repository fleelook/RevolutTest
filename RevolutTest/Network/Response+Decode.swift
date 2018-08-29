//
//  Response+Decode.swift
//  RevolutTest
//
//  Created by Daniil Smirnov on 28/08/2018.
//  Copyright © 2018 Daniil Smirnov. All rights reserved.
//

import Foundation
import ReactiveSwift
import Moya


public extension Response {
    func decode<T>(_ decoding: ((JSON) -> T?)?) throws -> T where T: JSONDecodable {
        do {
            let jsonAsAny = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            guard
                let json = JSON(jsonObject: jsonAsAny) else {
                    throw MoyaError.jsonMapping(self)
            }
            
            if let decodedData: T = decoding?(json) {
                return decodedData
            } else { throw MoyaError.jsonMapping(self) }
            
        } catch let error {
            throw error
        }
    }
    
    func decode<T>(_ decoding: ((JSON) -> [String: T]?)?) throws -> [String: T] where T: JSONDecodable {
        do {
            let jsonAsAny = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            guard
                let json = JSON(jsonObject: jsonAsAny) else {
                    throw MoyaError.jsonMapping(self)
            }
            
            if let decodedData: [String: T] = decoding?(json) {
                return decodedData
            } else { throw MoyaError.jsonMapping(self) }
            
        } catch let error {
            throw error
        }
    }
}
