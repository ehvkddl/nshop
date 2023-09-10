//
//  WishListRepository.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/10.
//

import Foundation
import RealmSwift

protocol WishListRepositoryProtocol: AnyObject {
    
    func fetch() -> Results<WishList>
    func addItem(_ item: WishList)
    func deleteItem(_ item: WishList)
    func checkItemExistence(by id: String) -> (isWish: Bool, item: WishList?)
    func checkItemExistence(by searchText: String) -> Results<WishList>
    func convertToWishList(from product: Product) -> WishList
    
}

class WishListRepository: WishListRepositoryProtocol {
    
    private let realm = try! Realm()
    
    private lazy var wishList: Results<WishList>! = self.fetch()
    
    func fetch() -> Results<WishList> {
        return realm.objects(WishList.self)
    }
    
    func addItem(_ item: WishList) {
        do {
            try realm.write {
                realm.add(item)
              }
        } catch {
            print(error)
        }
    }
    
    func deleteItem(_ item: WishList) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
    func checkItemExistence(by id: String) -> (isWish: Bool, item: WishList?) {
        let wish = wishList.where {
            $0.productId == id
        }
        
        guard let item = wish.first else { return (false, nil) }
        
        return (true, item)
    }
    
    func checkItemExistence(by searchText: String) -> Results<WishList> {
        let wish = wishList.where {
            $0.title.contains(searchText, options: .caseInsensitive)
        }

        return wish
    }
    
    func convertToWishList(from product: Product) -> WishList {
        let item = WishList(title: product.title,
                            link: product.link,
                            image: product.image,
                            lprice: product.lprice,
                            mallName: product.mallName,
                            productId: product.productId)
        return item
    }
}
