//
//  CurrencyConverterInteractor.swift
//  RevolutTest
//
//  Created by Daniil Smirnov on 28/08/2018.
//  Copyright © 2018 Daniil Smirnov. All rights reserved.
//

import Foundation
import ReactiveSwift


class CurrencyConverterInteractor: CurrencyConverterInteractorProtocol {
    
    weak var delegate: CurrencyConverterInteractorDelegate?
    
    init(currencyDataService: CurrencyDataServiceProtocol) {
        self.currencyDataService = currencyDataService
    }
    
    func getRates(for currency: Currency) {
        currencyDataService.getRates(for: currency)
            .take(during: lifetime)
            .observe(on: UIScheduler())
            .on(
                failed: { [weak self] error in
                    self?.delegate?.didReceiveRates(with: .failure(error))
                },
                value: { [weak self] feed in
                    self?.delegate?.didReceiveRates(with: .success(feed))
            })
            .start()
    }
    
    
    // MARK: fileprivate

    fileprivate let (lifetime, token) = Lifetime.make()
    fileprivate let currencyDataService: CurrencyDataServiceProtocol
}
