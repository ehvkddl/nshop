//
//  ProductCollectionView.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/10.
//

import UIKit

class ProductCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        
        if #available(iOS 15.0, *) { }
        else {
            backgroundColor = .systemBackground
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
