//
//  CurrencyEmptyView.swift
//  RevolutTest
//
//  Created by Daniil Smirnov on 28/08/2018.
//  Copyright © 2018 Daniil Smirnov. All rights reserved.
//

import UIKit


class CurrencyEmptyView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        spinner.center = self.center
    }
    
    
    // MARK: fileprivate
    
    fileprivate lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        self.addSubview(spinner)
        return spinner
    }()
}
