//
//  CustomCellViewTableViewCell.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/04/26.
//

import SnapKit
import UIKit

class CustomCellView: UITableViewCell {
    lazy var title:UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 20,weight: .heavy)
        return title
    }()
    
    lazy var date:UILabel = {
        let date = UILabel()
        date.textColor = .secondaryLabel
        date.font = .systemFont(ofSize: 14, weight: .light)
        return date
    }()
    
    lazy var toggleButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.addTarget(self, action: #selector(touchUpToggle), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        setUpCell()
    }
    
    
    func setUpCell(){
        [title,date,toggleButton].forEach{
            contentView.addSubview($0)
        }
        
        title.snp.makeConstraints{
            $0.top.equalTo(contentView.safeAreaInsets.top)
            $0.leading.equalTo(contentView.safeAreaInsets.left).inset(20)
        }
        
        date.snp.makeConstraints{
            $0.top.equalTo(title.snp.bottom)
            $0.bottom.equalTo(contentView.safeAreaInsets.bottom).inset(20)
            $0.leading.equalTo(title.snp.leading)
        }
        toggleButton.snp.makeConstraints{
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc func touchUpToggle(_ sender:UIButton){
        if sender.isSelected{
            sender.isSelected = false
            sender.setImage(UIImage(systemName: "circle"), for: .normal)
        }else{
            sender.isSelected = true
            sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
    }
}
