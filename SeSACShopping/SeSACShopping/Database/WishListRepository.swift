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
    
}

class WishListRepository: WishListRepositoryProtocol {
    
    private let realm = try! Realm()
    
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
    
}
