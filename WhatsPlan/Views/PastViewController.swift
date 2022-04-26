//
//  PastViewController.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/04/26.
//

import Foundation
import UIKit

class PastViewConrtoller:UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Did Load")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = .green
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
