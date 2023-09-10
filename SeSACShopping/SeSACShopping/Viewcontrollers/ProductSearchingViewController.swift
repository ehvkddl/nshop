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
    
    let searchManager = SearchAPIManager()
    
    let wishListRepository = WishListRepository()
    
    var products: [Product] = []
    
    var page = 1
    var isEnd: Bool {
        page > total / display
    }
    var total = 0
    var start: Int {
        return display * (page - 1) + 1
    }
    let display = 30
    var sort: SortType = .sim

    lazy var searchBar = {
        let view = SeSACSearchBar()
        view.delegate = self
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
        view.prefetchDataSource = self
        
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
    
    func firstFetch() {
        guard let productName = searchBar.text, !productName.isEmpty else { return }
        
        searchManager.fetchProduct(name: productName, display: display, start: start, sort: sort.text) { data in
            self.total = data.total
            self.products = data.items

            DispatchQueue.main.async {
                self.productCollectionView.reloadData()
                
                if !self.products.isEmpty {
                    self.sortButtonStackView.isHidden = false
                    self.productCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                }
            }
        }
    }
    
    @objc private func sortButtonClicked(_ sender: UIButton) {
        page = 1
        sort = SortType.allCases[sender.tag]
        
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

        firstFetch()
    }
    
}

extension ProductSearchingViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        page = 1
        sort = .sim
        
        sortButtonStackView.isHidden = true
        self.accuracyButton.setSelectedUI()

        firstFetch()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.text = ""
        sortButtonStackView.isHidden = true
        products = []
        productCollectionView.reloadData()
    }
    
}

extension ProductSearchingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
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
                let item = self.wishListRepository.convertToWishList(from: product)
                
                self.wishListRepository.addItem(item)
            }
            
            collectionView.reloadItems(at: [indexPath])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.item]
        
        let vc = ProductDetailViewController()
        
        vc.index = indexPath.item
        vc.productTitle = product.title
        vc.productId = product.productId
        
        vc.wishListButtonClickedClosure = { index in
            let item = self.wishListRepository.convertToWishList(from: product)
            
            self.wishListRepository.addItem(item)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if products.count - 1 == indexPath.item && page <= (total / display) && isEnd == false {
                page += 1
                
                guard let productName = searchBar.text, !productName.isEmpty else { return }
                
                searchManager.fetchProduct(name: productName, display: display, start: start, sort: sort.text) { data in
                    self.total = data.total
                    self.products.append(contentsOf: data.items)
                    
                    print("[total]", data.total, "  [start]", data.start, "  [display]", data.display)
                    
                    DispatchQueue.main.async {
                        self.productCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
}
