//
//  ProductCollectionViewCell.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/08.
//

import UIKit
import SnapKit

class ProductCollectionViewCell: BaseCollectionViewCell {
    
    var wishListButtonClickedClosure: (() -> Void)?
    
    let image = {
        let img = UIImageView()
        
        img.image = UIImage(systemName: "cube.box")
        img.tintColor = .gray
        
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 10
        img.clipsToBounds = true
        
        return img
    }()
    
    let wishButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.tintColor = .gray
        btn.backgroundColor = .white
        btn.layer.cornerRadius = btn.frame.width / 2
        return btn
    }()
    
    let mallNameLabel = {
        let lbl = UILabel()
        lbl.text = "쇼핑몰명"
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = .systemGray
        return lbl
    }()
    
    let titleLabel = {
        let lbl = UILabel()
        lbl.text = "제품명"
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    let lpriceLabel = {
        let lbl = UILabel()
        lbl.text = "가격"
        lbl.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    
    let stackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        return stackView
    }()
    
    override func prepareForReuse() {
        image.image = nil
        wishButton.setImage(UIImage(systemName: "heart"), for: .normal)
        wishButton.tintColor = .gray
    }
    
    override func configureCell() {
        wishButton.addTarget(self, action: #selector(wishListButtonClicked), for: .touchUpInside)
        
        [mallNameLabel, titleLabel, lpriceLabel].forEach { stackView.addArrangedSubview($0) }
        [image, wishButton, stackView].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        image.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
            make.height.equalTo(contentView.snp.width).multipliedBy(1)
        }
        
        wishButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(image).inset(7)
            make.size.equalTo(35)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(7)
            make.horizontalEdges.equalTo(image).inset(3)
        }
    }
    
}

extension ProductCollectionViewCell {
    
    @objc func wishListButtonClicked() {
        wishListButtonClickedClosure?()
    }
    
    func setData(
        isWish: Bool,
        imageUrl: String,
        mallName: String,
        title: String,
        lprice: String
    ) {
        image.load(from: imageUrl)
        mallNameLabel.text = "[\(mallName)]"
        titleLabel.text = title.removeTag()
        lpriceLabel.text = lprice.setComma()
        
        if isWish {
            wishButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            wishButton.tintColor = .systemRed
        }
    }
    
}
