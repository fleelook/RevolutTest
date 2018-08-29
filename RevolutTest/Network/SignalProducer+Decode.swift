//
//  SignalProducer+Decode.swift
//  RevolutTest
//
//  Created by Daniil Smirnov on 28/08/2018.
//  Copyright © 2018 Daniil Smirnov. All rights reserved.
//

import Foundation
import ReactiveSwift
import Moya
import Result


extension SignalProducerProtocol where Value == Response, Error == MoyaError  {
    func decode<T>(_ decoding: ((JSON) -> T?)?) -> SignalProducer<T, MoyaError> where T: JSONDecodable {
        return producer.flatMap(.latest) { response -> SignalProducer<T, MoyaError> in
            do {
                return SignalProducer(value: try response.decode(decoding))
            } catch {
                print(error.localizedDescription)
                if let error = error as? MoyaError {
                    return SignalProducer(error: error)
                } else {
                    // The cast above should never fail, but just in case.
                    return SignalProducer(error: MoyaError.underlying(error, response))
                }
            }
        }
    }
    
    func decode<T>(_ decoding: ((JSON) -> [String: T]?)?) -> SignalProducer<[String: T], MoyaError> where T: JSONDecodable {
        return producer.flatMap(.latest) { response -> SignalProducer<[String: T], MoyaError> in
            do {
                return SignalProducer(value: try response.decode(decoding))
            } catch {
                print(error.localizedDescription)
                if let error = error as? MoyaError {
                    return SignalProducer(error: error)
                } else {
                    // The cast above should never fail, but just in case.
                    return SignalProducer(error: MoyaError.underlying(error, response))
                }
            }
        }
    }
}
