//
//  CurrencyConverterProtocols.swift
//  RevolutTest
//
//  Created by Daniil Smirnov on 28/08/2018.
//  Copyright © 2018 Daniil Smirnov. All rights reserved.
//

import Foundation
import IGListKit
import Moya
import Result


protocol CurrencyConverterViewControllerProtocol: class {
    var adapter: ListAdapter { get }
    
    func setSpinner(hidden: Bool)
    func scrollToTop() 
}

protocol CurrencyConverterPresenterProtocol: class {
    var items: [ListDiffable] { get }
    
    func didLoadView()
}

protocol CurrencyConverterInteractorProtocol: class {
    var delegate: CurrencyConverterInteractorDelegate? { get set }
    
    func getRates(for currency: Currency)
}

protocol CurrencyConverterInteractorDelegate: class {
    func didReceiveRates(with result: Result<RatesFeed, MoyaError>)
}
