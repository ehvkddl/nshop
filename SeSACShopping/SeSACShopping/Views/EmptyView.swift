//
//  EmptyView.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/11.
//

import UIKit

class EmptyView: BaseView {
    
    var emptyImage: UIImage?
    var emptyText: String
    
    lazy var image = {
        let img = UIImageView()
        img.image = emptyImage
        img.tintColor = .gray
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var label = {
        let lbl = UILabel()
        lbl.text = emptyText
        lbl.textColor = .gray
        lbl.numberOfLines = 0
        return lbl
    }()
    
    init(image: UIImage?, text: String) {
        self.emptyImage = image
        self.emptyText = text
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let stackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        return stackView
    }()
    
    override func configureView() {
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(label)
        
        addSubview(stackView)
    }
    
    override func setConstraints() {
        image.snp.makeConstraints { make in
            make.size.equalTo(120)
        }
        stackView.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
        }
    }
    
}
