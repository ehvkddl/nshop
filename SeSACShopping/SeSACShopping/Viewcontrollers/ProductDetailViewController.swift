//
//  ProductDetailViewController.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/10.
//

import UIKit
import WebKit

class ProductDetailViewController: BaseViewController {

    let wishListRepository = WishListRepository()
    
    var productTitle: String?
    var productId: String?
        
    var wishListButtonClickedClosure: (() -> Void)?
    
    var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = productTitle != nil ? productTitle!.removeTag() : "제품 상세"
        
        loadWebView(with: productId)
    }
    
    override func configureView() {
        super.configureView()
        
        [webView].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        let wishButton = UIBarButtonItem(image: UIImage(systemName: "heart"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(wishListButtonClicked))
        
        guard let id = self.productId else { return }
        let isWish = wishListRepository.checkItemExistence(by: id).isWish
        
        navigationItem.rightBarButtonItem = wishButton
        
        setWishButtonImage(isWish: isWish)
    }
    
    @objc func wishListButtonClicked() {
        guard let id = self.productId else { return }
        let (isWish, item) = wishListRepository.checkItemExistence(by: id)
        
        if let item = item {
            self.removeImageFromDocument(fileName: fileName(id: item.productId))
            wishListRepository.deleteItem(item)
        } else {
            wishListButtonClickedClosure?()
        }
        
        setWishButtonImage(isWish: !isWish)
    }
    
    func setWishButtonImage(isWish: Bool) {
        let image: UIImage?
        
        if isWish {
            image = UIImage(systemName: "heart.fill")
            navigationItem.rightBarButtonItem?.tintColor = .red
        } else {
            image = UIImage(systemName: "heart")
            navigationItem.rightBarButtonItem?.tintColor = .BaseColor.text
        }
        
        navigationItem.rightBarButtonItem?.image = image
    }
    
    func loadWebView(with id: String?) {
        let baseUrl = "https://msearch.shopping.naver.com/product/"
        guard let id = id, let url = URL(string: baseUrl + id) else {
            print("유효하지 않은 링크입니다.")
            return
        }
        let request = URLRequest(url: url)
        
        webView.load(request)
    }

}
