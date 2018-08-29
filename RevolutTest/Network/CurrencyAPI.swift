//
//  CurrencyAPI.swift
//  RevolutTest
//
//  Created by Daniil Smirnov on 28/08/2018.
//  Copyright © 2018 Daniil Smirnov. All rights reserved.
//

import Foundation
import Moya


public enum CurrencyAPI: TargetType {
    
    case getRates(base: Currency)
    
    public var baseURL: URL {
        return URL(string: "https://revolut.duckdns.org/")!
    }
    
    public var path: String {
        switch self {
        case .getRates:
            return "latest"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getRates:
            return .get
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .getRates:
            return Data()
        }
    }
    
    public var task: Task {
        switch self {
        case .getRates(let base):
            let parameters: [String : JSON] = [
                "base" : base.code.json,
            ]

            guard let params = JSON.dictionaryValue(parameters).jsonObject as? [String: AnyObject] else { fatalError() }
            
            return .requestParameters(parameters: params,
                                      encoding: QueryURLParameterEncoding.standard)
        }
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

}



