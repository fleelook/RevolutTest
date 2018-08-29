//
//  ViewController.swift
//  RevolutTest
//
//  Created by Daniil Smirnov on 28/08/2018.
//  Copyright © 2018 Daniil Smirnov. All rights reserved.
//

import UIKit
import IGListKit


class CurrencyConverterViewController: UIViewController,
                                       UIScrollViewDelegate,
                                       CurrencyConverterViewControllerProtocol,
                                       ListAdapterDataSource {
    
    var presenter: CurrencyConverterPresenterProtocol!
    
    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
        adapter.collectionView = collectionView
        adapter.scrollViewDelegate = self
        adapter.dataSource = self
        return adapter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.keyboardDismissMode = .onDrag
        spinner.isHidden = true
        presenter.didLoadView()
    }
    
    func setSpinner(hidden: Bool) {
        spinner.isHidden = hidden
        collectionView.isUserInteractionEnabled = hidden
        if hidden {
            spinner.stopAnimating()
        } else {
            spinner.startAnimating()
        }
    }
    
    func scrollToTop() {
        if collectionView.contentOffset.y != 0 {
            isScrollingToTop = true
        }
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isScrollingToTop else { return }
        
        if collectionView.contentOffset.y == 0
        {
            isScrollingToTop = false
            (adapter.sectionController(forSection: 0) as? CurrencySectionController)?.setFirstResponder()
        }
    }
    
    
    // MARK: ListAdapterDataSource
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return presenter.items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        guard let item = object as? CurrencyItem else {
            fatalError("Unrecognized object")
        }
        
        return CurrencySectionController(item: item)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return CurrencyEmptyView()
    }
    
    
    // MARK: fileprivate
    
    fileprivate var isScrollingToTop: Bool = false
    
    @IBOutlet fileprivate weak var spinner: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
}

