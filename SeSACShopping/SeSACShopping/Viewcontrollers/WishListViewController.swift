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
    var wishList: Results<WishList>!
    
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
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        wishListCollectionView.reloadData()
    }
    
    override func configureView() {
        super.configureView()
        
        [wishListCollectionView].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        wishListCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
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
        
        return cell
    }
    
}
