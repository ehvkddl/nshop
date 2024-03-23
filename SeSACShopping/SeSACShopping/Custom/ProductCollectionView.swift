//
//  ProductCollectionView.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/10.
//

import UIKit

class ProductCollectionView: UICollectionView {
    
    enum CellType {
        case search
        case wishList
    }
    
    init(_ type: CellType = .search, frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        switch type {
        case .search:
            register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        case .wishList:
            register(WishListCollectionViewCell.self, forCellWithReuseIdentifier: WishListCollectionViewCell.identifier)
        }
        
        if #available(iOS 15.0, *) { }
        else {
            backgroundColor = .systemBackground
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
