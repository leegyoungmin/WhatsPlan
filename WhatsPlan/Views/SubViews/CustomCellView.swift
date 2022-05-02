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
    lazy var title:UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 20,weight: .heavy)
        return title
    }()
    
    lazy var toggleButton:ToggleButton = {
        let toggleButton = ToggleButton()
        toggleButton.addTarget(self, action: #selector(touchUpToggle), for: .touchUpInside)
        return toggleButton
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
        [title,toggleButton].forEach{
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
    }
    
    @objc func touchUpToggle(_ sender:ToggleButton){
        sender.isOn.toggle()
        changeText(sender)
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

extension CustomCellView{
    func changeText(_ sender:ToggleButton){
        if sender.isOn{
            self.title.attributedText = title.text?.strikeThrough(1)
            self.title.textColor = .secondaryLabel
        }else{
            self.title.attributedText = title.text?.strikeThrough(0)
            self.title.textColor = .black
        }
    }
}
