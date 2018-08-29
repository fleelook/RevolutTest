//
//  CurrencyConverterPresenter.swift
//  RevolutTest
//
//  Created by Daniil Smirnov on 28/08/2018.
//  Copyright © 2018 Daniil Smirnov. All rights reserved.
//

import Foundation
import IGListKit
import Moya
import Result


class CurrencyConverterPresenter: CurrencyConverterPresenterProtocol,
                                  CurrencyConverterInteractorDelegate {
    
    init(view: CurrencyConverterViewControllerProtocol, interactor: CurrencyConverterInteractorProtocol) {
        self.interactor = interactor
        self.view = view
    }
    
    deinit {
        timer.invalidate()
    }
    
    var items: [ListDiffable] {
        return currencyItems
    }
    
    func didLoadView() {
        adapter.performUpdates(animated: false, completion: nil)
        
        timer.fire()
    }
    
    
    // MARK: CurrencyConverterInteractorDelegate
    
    func didReceiveRates(with result: Result<RatesFeed, MoyaError>) {
        switch result {
        case .failure(let error):
            print(error)
        case .success(let feed):
            guard !isUpdatingBaseCurrency else { return }
            
            self.rates = feed.rates
            adapter.performUpdates(animated: false, completion: nil)
        }
    }
    
    
    // MARK: fileprivate
    
    @objc fileprivate dynamic func oneSecondDidPass() {
        interactor.getRates(for: baseCurrency)
    }
    
    fileprivate func createItem(for currencyCode: String) -> CurrencyItem {
        
        func formattedValue(_ value: Double) -> Double {
            if value - floor(value) == 0 {
                return Double(Int(value))
            }
            return Double(round(100 * value) / 100)
        }
        
        let value = rates[currencyCode]! * multiplier
        let item = CurrencyItem(
            currency: Currency(code: currencyCode),
            value: formattedValue(value)
        )
        item.baseCurrencyGetter = { [weak self] in
            return self?.baseCurrency
        }
        item.didSelect = { [weak self] value in
            self?.baseCurrency = Currency(code: currencyCode)
            
            self?.timer.fire()
            self?.multiplier = value
        }
        item.didInput = { [weak self] value in
            guard let strongSelf = self else { return }
            
            if currencyCode == strongSelf.baseCurrency.code {
                item.value = formattedValue(value)
            }
            self?.multiplier = value
        }
        return item
    }
    
    fileprivate var currencyItems: [ListDiffable] {
        guard !rates.isEmpty else { return []  }
        var items: [CurrencyItem] = [createItem(for: baseCurrency.code)]
        items.append(contentsOf: rates.keys.flatMap { code in
            guard code != baseCurrency.code else { return nil }
            
            return createItem(for: code)
        })
        return items
    }
    
    fileprivate var baseCurrency: Currency = Currency(code: "EUR") {
        didSet {
            view.setSpinner(hidden: false)
            isUpdatingBaseCurrency = true
            adapter.performUpdates(animated: true) { [weak self] finished in
                self?.isUpdatingBaseCurrency = false
                self?.view.setSpinner(hidden: true)
                self?.view.scrollToTop()
                (self?.adapter.sectionController(forSection: 0) as? CurrencySectionController)?.setFirstResponder()
            }
        }
    }
    
    fileprivate var isUpdatingBaseCurrency: Bool = false
    
    fileprivate var rates: [String : Double] = [:]
    fileprivate var multiplier: Double = 100.0 {
        didSet {
            adapter.performUpdates(animated: false, completion: nil)
        }
    }
    
    fileprivate lazy var timer: Timer = {
        let timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.oneSecondDidPass),
            userInfo: nil,
            repeats: true
        )
        return timer
    }()
    
    fileprivate unowned let view: CurrencyConverterViewControllerProtocol
    fileprivate var interactor: CurrencyConverterInteractorProtocol
    
    fileprivate var adapter: ListAdapter {
        return view.adapter
    }
}
