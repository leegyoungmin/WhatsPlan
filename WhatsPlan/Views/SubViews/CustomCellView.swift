//
//  CustomCellViewTableViewCell.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/04/26.
//

import SnapKit
import UIKit
import CoreData
import RxSwift
import RxCocoa

protocol CustomCellDelegate:TodayViewController{
    func customCell(_ customCell:CustomCellView,didTapButton button:UIButton)
}

class CustomCellView: UITableViewCell {
    weak var delegate:CustomCellDelegate?
    var id:UUID!
    lazy var title:ToggleLabel = {
        let title = ToggleLabel()
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 20,weight: .heavy)
        return title
    }()
    
    lazy var toggleButton:ToggleButton = {
        let toggleButton = ToggleButton()
        toggleButton.addTarget(self, action: #selector(touchUpToggle), for: .touchUpInside)
        return toggleButton
    }()
    lazy var seperator:UILabel = {
        let seperator = UILabel()
        seperator.backgroundColor = .secondarySystemBackground
        return seperator
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
        [title,toggleButton,seperator].forEach{
            contentView.addSubview($0)
        }
        
        title.snp.makeConstraints{
            $0.top.equalTo(contentView.safeAreaInsets.top)
            $0.leading.equalTo(contentView.safeAreaInsets.left).inset(20)
            $0.bottom.equalTo(contentView.safeAreaInsets.bottom)
        }
        
        toggleButton.snp.makeConstraints{
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
        seperator.snp.makeConstraints{
            $0.leading.equalTo(title.snp.leading)
            $0.trailing.equalTo(toggleButton.snp.trailing)
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.height.equalTo(1)
        }
    }
    
    @objc func touchUpToggle(_ sender:ToggleButton){
        sender.isOn.toggle()
        self.title.isOn = sender.isOn
        
        delegate?.customCell(self, didTapButton: sender)
    }
}

extension String{
    func strikeThrough(_ value:NSUnderlineStyle.RawValue) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: value, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
