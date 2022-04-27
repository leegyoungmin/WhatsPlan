//
//  AddTodoViewController.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/04/27.
//

import Foundation
import UIKit
import SnapKit

class AddTodoViewController:UIViewController{
    
    lazy var titleView:UILabel = {
       let title = UILabel()
        title.text = "Example"
        return title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSheet()
        setUpViews()
        print("Example added")
    }
    
    func setUpSheet(){
        if let sheet = sheetPresentationController{
            sheet.detents = [.medium()]
            sheet.selectedDetentIdentifier = .large
            sheet.preferredCornerRadius = 20
        }
    }
    
    func setUpViews(){
        view.backgroundColor = .white
        view.addSubview(titleView)
        
        titleView.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
    
}
