//
//  SeSACSearchBar.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/11.
//

import UIKit

class SeSACSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        searchBarStyle = .minimal
        setValue("취소", forKey: "cancelButtonText")
        showsCancelButton = true
        tintColor = .BaseColor.text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
