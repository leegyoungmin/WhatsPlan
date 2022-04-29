//
//  AddTodoViewController.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/04/27.
//

import Foundation
import UIKit
import CoreData
import SnapKit

class AddTodoViewController:UIViewController{
    let dummySelection:[String] = ["A","B","C"]
    lazy var Container:NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WhatsPlan")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                print("Error in read container ::: \(error)")
            }else{
                print(container.name)
            }
        }
        
        return container
    }()
    
    let pickerView = UIPickerView()
    
    lazy var pickerTextView:UIStackView = {
        let pickerTextField = UITextField()
        pickerTextField.textColor = .black
        pickerTextField.placeholder = "그룹을 선택해주세요."
        pickerTextField.inputView = pickerView
        return UIStackView().addViewStackView("그룹선택", content: pickerTextField)
    }()
    lazy var titleTextView:UIStackView = {
        let titleTextField = UITextField()
        titleTextField.textColor = .black
        titleTextField.placeholder = "할일 이름을 작성해주세요."
        return UIStackView().addViewStackView("할일이름", content: titleTextField)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolBar()
        fetch()
        setUpViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        selectedPickerViewUiCustom()
    }
    
    func fetch(){
        let context = Container.viewContext
        
        do{
            let todos = try context.fetch(Todos.fetchRequest()) as! [Todos]
            print(todos)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func save(title:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let object = NSEntityDescription.insertNewObject(forEntityName: "Plan", into: context)
        object.setValue(title, forKey: "title")
        object.setValue(false, forKey: "done")
        object.setValue(Date(), forKey: "time")
        object.setValue(UUID(), forKey: "id")
        
        print(object)
    }
    
    func setUpViews(){
        view.backgroundColor = .white
    }
    
    func setToolBar(){
        self.navigationItem.title = "내일 할일"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let button = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(didTapDoneButton))
        
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func didTapDoneButton(){
        dismiss(animated: true)
    }
}

extension AddTodoViewController:UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        label.text = dummySelection[row]
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        
        view.addSubview(label)
        return view
    }
    
}

extension AddTodoViewController:UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dummySelection.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "그룹선택"
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
