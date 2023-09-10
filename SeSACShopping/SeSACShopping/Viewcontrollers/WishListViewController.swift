//
//  WishListViewController.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/07.
//

import UIKit
import RealmSwift

class WishListViewController: BaseViewController {

    let wishListRepository = WishListRepository()
    var wishList: Results<WishList>! {
        didSet {
            wishListCollectionView.reloadData()
        }
    }
    
    var notificationToken: NotificationToken?
    
    lazy var searchBar = {
        let view = SeSACSearchBar()
        view.delegate = self
        view.placeholder = "찜한 상품을 찾아보세요!"
        return view
    }()
    
    private lazy var wishListCollectionView = {
        let view = ProductCollectionView(frame: .zero, collectionViewLayout: productCollectionViewLayout())
        
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "찜목록"
        
        wishList = wishListRepository.fetch()
        
        notificationToken = wishList.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self?.wishListCollectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self?.wishListCollectionView.performBatchUpdates {
                    self?.wishListCollectionView.deleteItems(at: deletions.map { IndexPath(item: $0, section: 0)})
                    self?.wishListCollectionView.insertItems(at: insertions.map { IndexPath(item: $0, section: 0)})
                    self?.wishListCollectionView.reloadItems(at: modifications.map { IndexPath(item: $0, section: 0)})
                }
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    override func configureView() {
        super.configureView()
        
        [searchBar, wishListCollectionView].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        wishListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension WishListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            wishList = wishListRepository.fetch()
            return
        }
        wishList = wishListRepository.checkItemExistence(by: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.text = ""
        wishList = wishListRepository.fetch()
    }
    
}

extension WishListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
        
        let item = wishList[indexPath.item]
        
        cell.setData(isWish: true,
                     imageUrl: item.image,
                     mallName: item.mallName,
                     title: item.title,
                     lprice: item.lprice)
        
        cell.wishListButtonClickedClosure = {
            self.wishListRepository.deleteItem(item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = wishList[indexPath.item]
        
        let vc = ProductDetailViewController()
        
        vc.productTitle = item.title
        vc.productId = item.productId
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
