//
//  ShoppingSearchViewController.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/07.
//

import UIKit
import SnapKit

class ProductSearchingViewController: BaseViewController {

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
        
        [searchBar, productCollectionView].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.size.height.equalTo(30)
        }
        
        productCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension ProductSearchingViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}

extension ProductSearchingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
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
