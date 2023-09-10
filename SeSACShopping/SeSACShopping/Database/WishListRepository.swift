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
    func checkItemExistence(by id: String) -> (Bool, WishList?)
    
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
    
    func checkItemExistence(by id: String) -> (Bool, WishList?) {
        let wish = wishList.where {
            $0.productId == id
        }
        
        guard let item = wish.first else { return (false, nil) }
        
        return (true, item)
    }
    
}
