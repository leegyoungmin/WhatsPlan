//
//  Extension.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/04/28.
//

import Foundation
import UIKit
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
