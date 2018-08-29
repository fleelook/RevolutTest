//
//  QueryURLParameterEncoding.swift
//  PlayMate
//
//  Created by Daniil Smirnov on 31/07/2018.
//  Copyright © 2018 Daniil Smirnov. All rights reserved.
//

import Foundation
import Alamofire


struct QueryURLParameterEncoding: ParameterEncoding {
    
    static var standard: QueryURLParameterEncoding {
        return QueryURLParameterEncoding()
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        guard let parameters = parameters else { return urlRequest }
        
        guard let url = urlRequest.url else {
            throw AFError.parameterEncodingFailed(reason: .missingURL)
        }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
            urlComponents.percentEncodedQuery = percentEncodedQuery
            urlRequest.url = urlComponents.url
        }
        
        return urlRequest
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    private func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            //            for value in array {
            //                components += queryComponents(fromKey: "\(key)[]", value: value)
            //            }
            components.append(("\(key)", array.map {"\($0)"}
                .joined(separator: ",")))
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    private func escape(_ string: String) -> String {
        //        let generalDelimitersToEncode = "#[]@?:/"
        //        let subDelimitersToEncode = "!$&'()*+,;="
        let generalDelimitersToEncode = "#[]@?/"
        let subDelimitersToEncode = "!$&'()*,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }
}


// Have to dublicate var from Alamofire pod because fileprivate modification
extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}


