//
//  ProductDetailViewController.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/10.
//

import UIKit
import WebKit

class ProductDetailViewController: BaseViewController {

    var productTitle: String?
    var productId: String?
    
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
        navigationItem.rightBarButtonItem = wishButton
    }
    
    @objc func wishListButtonClicked() {
        print("wish!")
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
