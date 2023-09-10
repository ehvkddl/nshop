//
//  ShoppingSearchViewController.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/07.
//

import UIKit
import RealmSwift
import SnapKit

enum SortType: Int, CaseIterable {
    case sim
    case date
    case dsc
    case asc
    
    var text: String {
        switch self {
        case .sim: return "sim"
        case .date: return "date"
        case .dsc: return "dsc"
        case .asc: return "asc"
        }
    }
}

class ProductSearchingViewController: BaseViewController {
    
    let wishListRepository = WishListRepository()
    var wishList: Results<WishList>?
    
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
    
    let sortButtonStackView = {
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
        btn.tag = 0
        return btn
    }()
    
    let dateButton = {
        let btn = FilterButton(title: "날짜순")
        btn.tag = 1
        return btn
    }()
    
    let hpriceButton = {
        let btn = FilterButton(title: "가격높은순")
        btn.tag = 2
        return btn
    }()
    
    let lpriceButton = {
        let btn = FilterButton(title: "가격낮은순")
        btn.tag = 3
        return btn
    }()
    
    lazy var sortButtons: [FilterButton] = [accuracyButton, dateButton, hpriceButton, lpriceButton]
    
    lazy var productCollectionView = {
        let view = ProductCollectionView(frame: .zero, collectionViewLayout: productCollectionViewLayout())
        
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "상품 검색"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        productCollectionView.reloadData()
    }
    
    override func configureView() {
        super.configureView()
        
        sortButtons.forEach { $0.addTarget(self, action: #selector(sortButtonClicked), for: .touchUpInside)}
        
        sortButtons.forEach { sortButtonStackView.addArrangedSubview($0) }
        [searchBar, sortButtonStackView, productCollectionView].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        sortButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.lessThanOrEqualToSuperview().inset(16)
        }
        
        productCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sortButtonStackView.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension ProductSearchingViewController {
    @objc private func sortButtonClicked(_ sender: UIButton) {
        let sortType = SortType.allCases[sender.tag]
        
        sortButtons.forEach {
            if $0.tag == sender.tag {
                // 선택된 버튼 (색상 변경)
                $0.setSelectedUI()
            } else {
                // 기본 버튼
                $0.setBasicUI()
                print("| clicked", $0.currentTitleColor)
            }
        }
        print("-------------")
        SearchAPIManager().fetchProduct(name: searchBar.text!, sort: sortType.text) { data in
            self.products = data.items

            DispatchQueue.main.async {
                self.sortButtonStackView.isHidden = false
                self.productCollectionView.reloadData()
            }
        }
    }
}

extension ProductSearchingViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        guard let productName = searchBar.text, !productName.isEmpty else { return }
        
        SearchAPIManager().fetchProduct(name: productName, sort: SortType.sim.text) { data in

            self.products = data.items

            DispatchQueue.main.async {
                self.sortButtonStackView.isHidden = false
                self.accuracyButton.setSelectedUI()
                self.productCollectionView.reloadData()
            }
        }
        
        if wishList == nil {
            self.wishList = wishListRepository.fetch()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.text = ""
        sortButtonStackView.isHidden = true
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
        let (isWish, wishItem) = wishListRepository.checkItemExistence(by: product.productId)
        
        cell.setData(isWish: isWish,
                     imageUrl: product.image,
                     mallName: product.mallName,
                     title: product.title,
                     lprice: product.lprice)
        
        cell.wishListButtonClickedClosure = {
            if let item = wishItem {
                self.wishListRepository.deleteItem(item)
            } else {
                let item = WishList(
                    title: product.title,
                    link: product.link,
                    image: product.image,
                    lprice: product.lprice,
                    mallName: product.mallName,
                    productId: product.productId
                )
                
                self.wishListRepository.addItem(item)
            }
            
            collectionView.reloadItems(at: [indexPath])
        }
        
        return cell
    }
    
}
