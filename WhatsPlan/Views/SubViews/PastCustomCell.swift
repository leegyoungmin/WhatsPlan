//
//  PastCustomCell.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/05/02.
//

import UIKit
import SnapKit

class PastCustomCell: UITableViewCell {

    lazy var title:UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 15, weight: .black)
        return title
    }()
    
    lazy var image:UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCell(){
        contentView.backgroundColor = .clear
        [title,image].forEach{
            contentView.addSubview($0)
        }
        
        title.snp.makeConstraints{
            $0.top.equalTo(contentView.safeAreaInsets.top)
            $0.leading.equalTo(contentView.safeAreaInsets.left).inset(20)
            $0.bottom.equalTo(contentView.safeAreaInsets.bottom)
        }
        
        image.snp.makeConstraints{
            $0.trailing.equalTo(contentView.safeAreaInsets.right).inset(20)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.height.width.equalTo(20)
        }
        
    }
    

}
