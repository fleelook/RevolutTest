//
//  CurrencySectionController.swift
//  RevolutTest
//
//  Created by Daniil Smirnov on 28/08/2018.
//  Copyright © 2018 Daniil Smirnov. All rights reserved.
//

import Foundation
import IGListKit


class CurrencySectionController: ListSectionController {
    
    init(item: CurrencyItem) {
        self.item = item
        
        super.init()
        
        if let countryCode = CurrencyToRegionMapper.regionCode(for: item.currency.code) {
            imageUrl = imageDownloadUrl(for: countryCode)
        }
    }
    
    override func didUpdate(to object: Any) {
        guard let item = object as? CurrencyItem else { return }
        
        self.item = item
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let height = CurrencyCell.cellHeight
        return CGSize(width: cellWidth, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(withNibName: "CurrencyCell", bundle: nil, for: self, at: index) as? CurrencyCell else {
                fatalError("Could not dequeue CurrencyCell")
        }
        cell.configure(with: item, imageUrl: imageUrl)
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        let value = cell?.getInputValue() ?? 0.0
        
        item.didSelect?(value)
    }
    
    func setFirstResponder() {
        cell?.setFirstResponder(true)
    }
    
    
    // MARK: fileprivate
    
    fileprivate func imageDownloadUrl(for countryCode: String) -> URL? {
        return URL(string: "https://www.countryflags.io/\(countryCode.lowercased())/flat/64.png")
    }
    
    fileprivate var cellWidth: CGFloat {
        return collectionContext?.containerSize.width ?? 0
    }
    
    fileprivate var cell: CurrencyCell? {
        return collectionContext?.cellForItem(at: 0, sectionController: self) as? CurrencyCell
    }
    
    fileprivate var imageUrl: URL? {
        didSet {
            cell?.setImage(with: imageUrl)
        }
    }
    
    fileprivate var item: CurrencyItem
}
