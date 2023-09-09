//
//  WishListRepository.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/10.
//

import Foundation
import RealmSwift

protocol WishListRepositoryProtocol: AnyObject {
    func addItem(_ item: WishList)
    
}

class WishListRepository: WishListRepositoryProtocol {
    
    private let realm = try! Realm()
    
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
