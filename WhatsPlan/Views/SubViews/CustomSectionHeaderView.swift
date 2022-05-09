//
//  CustomSectionHeaderView.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/04/28.
//

import Foundation
import SnapKit
import UIKit

class SectionHeaderView:UITableViewHeaderFooterView{
    lazy var title:UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 25, weight: .heavy)
        title.textColor = UIColor(named: "AccentColor")
        return title
    }()
    
    let subTitle:UILabel = {
        let subTitle = UILabel()
        subTitle.font = .systemFont(ofSize: 15, weight: .bold)
        subTitle.textColor = UIColor(named: "AccentColor")
        return subTitle
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents(){
        [title,subTitle].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        title.snp.makeConstraints{
            $0.top.equalTo(contentView.safeAreaInsets.top).offset(5)
            $0.leading.equalTo(contentView.safeAreaInsets.left).inset(20)
            $0.bottom.equalTo(contentView.safeAreaInsets.bottom).offset(-5)
        }
        
        subTitle.snp.makeConstraints{
            $0.top.equalTo(contentView.safeAreaInsets.top)
            $0.bottom.equalTo(contentView.safeAreaInsets.bottom)
            $0.trailing.equalTo(contentView.safeAreaInsets.right).inset(20)
        }
    }
}
