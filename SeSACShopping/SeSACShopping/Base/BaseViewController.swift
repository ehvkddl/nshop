//
//  BaseViewController.swift
//  SeSACShopping
//
//  Created by do hee kim on 2023/09/07.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setConstraints()
        configureNavigationBar()
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    func setConstraints() { }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .BaseColor.text
    }

}
