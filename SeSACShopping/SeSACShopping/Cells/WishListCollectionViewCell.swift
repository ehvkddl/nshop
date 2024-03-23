//
//  WishListCollectionViewCell.swift
//  SeSACShopping
//
//  Created by do hee kim on 2024/03/23.
//

import UIKit
import SnapKit

class WishListCollectionViewCell: BaseCollectionViewCell {
    
    var wishListButtonClickedClosure: (() -> Void)?
    
    let productImage = {
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
        productImage.image = nil
        wishButton.setImage(UIImage(systemName: "heart"), for: .normal)
        wishButton.tintColor = .gray
    }
    
    override func configureCell() {
        wishButton.addTarget(self, action: #selector(wishListButtonClicked), for: .touchUpInside)
        
        [titleLabel, lpriceLabel, mallNameLabel].forEach { stackView.addArrangedSubview($0) }
        [productImage, wishButton, stackView].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        productImage.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(15)
            make.verticalEdges.equalTo(contentView).inset(10)
            make.width.equalTo(productImage.snp.height).multipliedBy(1)
        }
        
        stackView.setContentCompressionResistancePriority(.init(rawValue: 750), for: .horizontal)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(productImage.snp.top).inset(5)
            make.leading.equalTo(productImage.snp.trailing).offset(15)
        }
        
        wishButton.setContentCompressionResistancePriority(.init(rawValue: 751), for: .horizontal)
        wishButton.snp.makeConstraints { make in
            make.top.equalTo(stackView)
            make.leading.equalTo(stackView.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(10)
            make.size.equalTo(35)
        }
        
    }
    
}

extension WishListCollectionViewCell {
    
    @objc func wishListButtonClicked() {
        wishListButtonClickedClosure?()
    }
    
    func setData(
        isWish: Bool,
        image: UIImage?,
        imageUrl: String,
        mallName: String,
        title: String,
        lprice: String
    ) {
        if let image = image {
            self.productImage.image = image
        } else {
            productImage.load(from: imageUrl)
        }
        mallNameLabel.text = "\(mallName)"
        titleLabel.text = title.removeTag()
        lpriceLabel.text = lprice.setComma()
        
        if isWish {
            wishButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            wishButton.tintColor = .systemRed
        }
    }
    
}
