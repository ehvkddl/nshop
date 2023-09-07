//
//  TabBarController.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/07.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        designTabBar()
    }
    
    private func configureTabBar() {
        let searchView = UINavigationController(rootViewController: ProductSearchingViewController())
        let wishListView = UINavigationController(rootViewController: WishListViewController())
        
        self.setViewControllers([searchView, wishListView], animated: true)
    }
    
    private func designTabBar() {
        self.tabBar.tintColor = UIColor.BaseColor.text
        
        if let items = self.tabBar.items {
            items[0].selectedImage = UIImage(systemName: "magnifyingglass")
            items[0].image = UIImage(systemName: "magnifyingglass")
            items[0].title = "검색"
            
            items[1].selectedImage = UIImage(systemName: "heart.fill")
            items[1].image = UIImage(systemName: "heart")
            items[1].title = "찜목록"
        }
    }

}
