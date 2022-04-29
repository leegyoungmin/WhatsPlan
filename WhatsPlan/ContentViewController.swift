//
//  ViewController.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/04/26.
//

import UIKit

class ContentViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(){
        let first = UINavigationController(rootViewController: TodayViewController())
        let second = UINavigationController(rootViewController: PastViewConrtoller())
        
        let tabs = [first,second]
        
        self.tabBar.backgroundColor = .white
        self.setViewControllers(tabs, animated: true)
    }
    
}




