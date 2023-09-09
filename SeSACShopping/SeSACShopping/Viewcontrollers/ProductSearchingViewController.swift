//
//  ShoppingSearchViewController.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/07.
//

import UIKit
import SnapKit

class ProductSearchingViewController: BaseViewController {
    
    var products: [Product] = []

    lazy var searchBar = {
        let view = UISearchBar()
        
        view.delegate = self
        
        view.searchBarStyle = .minimal
        view.setValue("취소", forKey: "cancelButtonText")
        view.showsCancelButton = true
        view.tintColor = .BaseColor.text
        
        view.placeholder = "어떤 상품을 찾고 계시나요?"
        
        return view
    }()
    
    let filterButtonStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.isHidden = true
        
        return stackView
    }()
    
    let accuracyButton = {
        let btn = FilterButton(title: "정확도")
        return btn
    }()
    
    let dateButton = {
        let btn = FilterButton(title: "날짜순")
        return btn
    }()
    
    let hpriceButton = {
        let btn = FilterButton(title: "가격높은순")
        return btn
    }()
    
    let lpriceButton = {
        let btn = FilterButton(title: "가격낮은순")
        return btn
    }()
    
    lazy var productCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: productCollectionViewLayout())
        
        view.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "상품 검색"
    }
    
    override func configureView() {
        super.configureView()
        
        [accuracyButton, dateButton, hpriceButton, lpriceButton].forEach { filterButtonStackView.addArrangedSubview($0) }
        [searchBar, filterButtonStackView, productCollectionView].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.size.height.equalTo(30)
        }
        
        filterButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.lessThanOrEqualToSuperview().inset(16)
        }
        
        productCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterButtonStackView.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension ProductSearchingViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        guard let productName = searchBar.text, !productName.isEmpty else { return }
        
        SearchAPIManager().fetchProduct(name: productName) { data in

            self.products = data.items

            DispatchQueue.main.async {
                self.filterButtonStackView.isHidden = false
                self.productCollectionView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.text = ""
        filterButtonStackView.isHidden = true
        products = []
        productCollectionView.reloadData()
    }
    
}

extension ProductSearchingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
        
        let product = products[indexPath.item]
        
        cell.image.load(from: product.image)
        cell.mallNameLabel.text = "[\(product.mallName)]"
        cell.titleLabel.text = product.title.removeTag()
        cell.lpriceLabel.text = product.lprice.setComma()
        
        return cell
    }
    
    func productCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let width = UIScreen.main.bounds.width - (spacing * 3)
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width / 2, height: (width / 2) * 1.47)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        
        return layout
    }
    
}
