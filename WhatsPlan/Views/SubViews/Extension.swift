//
//  Extension.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/04/28.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

extension UIStackView{
    func addViewStackView(_ title:String,content:UIView)->UIStackView{
        let titleView = UILabel()
        titleView.text = title
        let stackView = UIStackView(arrangedSubviews: [titleView,content])
        stackView.distribution = .equalSpacing
        return stackView
    }
}

class TextFieldWithPadding:UITextField{
    var textPadding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}

class ButtonWithPadding:UIButton{
    var padding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    
    override func alignmentRect(forFrame frame: CGRect) -> CGRect {
        let rect = super.alignmentRect(forFrame: frame)
        return rect.inset(by: padding)
    }
}

class RxTableViewController:UIViewController{
    weak var tableView:UITableView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func bindTableView(){
        let cities = ["London","Example1","Example2"]
        let observer : Observable<[String]> = Observable.of(cities)
        
        observer.bind(to: tableView.rx.items){ (tableView:UITableView,index:Int,element:String) -> UITableViewCell in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else{return UITableViewCell()}
            
            cell.textLabel?.text = element
            return cell
        }.disposed(by: disposeBag)
    }
}

class ToggleLabel:UILabel{
    var isOn:Bool = false{
        didSet{
            setting()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        setting()
    }
    func setting(){
        switch isOn{
        case true:
            self.attributedText = self.text?.strikeThrough(1)
            self.textColor = .secondaryLabel
        case false:
            self.attributedText = self.text?.strikeThrough(0)
            self.textColor = .label
        }
    }
}

class ToggleButton:UIButton{
    
    var isOn:Bool = false{
        didSet{
            setting()
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setting()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setting()
    }
    
    func setting(){
        switch isOn{
        case true:
            self.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            
        case false:
            self.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
}

class TodayCustomHeaderView:UITableViewHeaderFooterView{
    var isDone:Bool = false{
        didSet{
            convertTitle()
        }
    }
    lazy var title:UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        title.textColor = UIColor(named: "AccentColor")
        return title
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUpView()
        convertTitle()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        setUpView()
        convertTitle()
    }
    
    func setUpView(){
        contentView.addSubview(title)
        contentView.backgroundColor = .clear
        title.snp.makeConstraints{
            $0.leading.equalTo(contentView.snp.leading)
            $0.top.equalTo(contentView.snp.top)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    func convertTitle(){
        if isDone{
            title.text = "완료 일정"
        }else{
            title.text = "미완료 일정"
        }
    }
    
    
}
