//
//  FilterButton.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/09.
//

import UIKit

class FilterButton: UIButton {
    
    var title: String
    
    init(title: String) {
        self.title = title
        
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        setTitle(self.title, for: .normal)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor
        layer.cornerRadius = 8
        
        setTitleColor(UIColor.lightGray, for: .normal)
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: 14)
                return outgoing
            }
            
            config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            self.configuration = config
        } else {
            titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }
    }
    
}
