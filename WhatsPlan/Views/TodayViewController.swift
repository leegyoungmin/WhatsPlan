//
//  Views.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/04/26.
//

import Foundation
import UIKit
import CoreData
import RxCocoa
import RxSwift
import SnapKit

class TodayViewController:UIViewController{
    let disposeBag = DisposeBag()
    var plans:[Plan] = []
    
    lazy var inputTodoView:TextFieldWithPadding = {
        let textfield = TextFieldWithPadding()
        textfield.backgroundColor = .secondarySystemBackground
        textfield.layer.cornerRadius = 10
        textfield.placeholder = "할일 입력"
        return textfield
    }()
    lazy var addButton:UIButton = {
        let addButton = UIButton()
        addButton.setTitle("추가하기", for: .normal)
        addButton.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        addButton.backgroundColor = .secondarySystemBackground
        addButton.layer.cornerRadius = 10
        return addButton
    }()
    
    lazy var tableView:UITableView = {
        let table = UITableView()
        table.register(CustomCellView.classForCoder(), forCellReuseIdentifier: "cell")
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .clear
        return table
    }()
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setUpViews()
        fetchData()
        addButton.rx.tap
            .bind{
                self.defaultAlert()
            }
            .disposed(by: disposeBag)
    }
    
    func defaultAlert(){
        let alert = UIAlertController(title: "일정추가", message: nil, preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "일정을 작성해주세요."
        }
        
        alert.addAction(UIAlertAction(title: "추가", style: .default, handler: { action in
            guard let textfield = alert.textFields?.first as? UITextField,
            let todo = textfield.text else{return}
            self.saveTask(name: todo)
            self.fetchData()
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    func setUpNavigationBar(){
        self.navigationItem.title = "오늘할일"
        navigationController?.navigationBar.prefersLargeTitles = true
        let rightButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(didtapEditMode))
        navigationItem.rightBarButtonItem = rightButton
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = .white
        coloredAppearance.titleTextAttributes = [.foregroundColor:UIColor(named: "AccentColor") ?? .black]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor:UIColor(named: "AccentColor") ?? .black]
        
        navigationController?.navigationBar.standardAppearance = coloredAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = coloredAppearance
    }
    
    @objc func didtapEditMode(){
        if isEditing{
            self.navigationItem.rightBarButtonItem?.title = "편집"
            self.tableView.setEditing(false, animated: true)
        }else{
            self.navigationItem.rightBarButtonItem?.title = "완료"
            self.tableView.setEditing(true, animated: true)
        }
        self.isEditing.toggle()
    }
    
    func setUpViews(){
        view.backgroundColor = .systemBackground
        
        [
            tableView,
            addButton
        ].forEach {
            view.addSubview($0)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaInsets.top)
            $0.leading.equalTo(view.safeAreaInsets.left)
            $0.trailing.equalTo(view.safeAreaInsets.right)
        }
        
        addButton.snp.makeConstraints{
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.equalTo(tableView.snp.leading).inset(20)
            $0.trailing.equalTo(tableView.snp.trailing).inset(20)
            $0.bottom.equalTo(view.safeAreaInsets.bottom).offset(-100)
        }
    }
}

extension TodayViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}

extension TodayViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if plans.isEmpty{
            self.tableView.setEmptyMessage("예정된 일정이 없습니다.")
        }else{
            self.tableView.reStore()
        }
        
        return plans.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CustomCellView else{return UITableViewCell()}
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.delegate = self
        cell.id = plans[indexPath.row].id
        cell.title.text = plans[indexPath.row].name
        cell.title.isOn = plans[indexPath.row].done
        cell.toggleButton.isOn = plans[indexPath.row].done
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if editingStyle == .delete{
            if deleteObject(object: plans[indexPath.row]){
                tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
}

extension UITableView{
    func setEmptyMessage(_ message:String){
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func reStore(){
        self.backgroundView = nil
        self.separatorStyle = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
extension TodayViewController:CustomCellDelegate{
    func customCell(_ customCell: CustomCellView, didTapButton button: UIButton) {
        guard let indexPath = plans.firstIndex(where: {$0.id == customCell.id}) else{return}
        let object = self.plans[indexPath]
        object.done.toggle()
        print(object.done)
        if updateDone(object: object){
            self.tableView.reloadData()
        }
    }
}

extension TodayViewController{
    
    // 새로운 일정 저장 메소드
    func saveTask(name:String){
        let context = Container.viewContext
        let task = NSEntityDescription.entity(forEntityName: "Plan", in: context)
        
        if let task = task {
            let task = NSManagedObject(entity: task, insertInto: context)
            task.setValue(UUID(), forKey: "id")
            task.setValue(false, forKey: "done")
            task.setValue(name, forKey: "name")
            task.setValue(Date(), forKey: "time")
            
            do{
                try context.save()
            } catch {
                print("Error in save Method ::: \(error.localizedDescription)")
            }
        }
    }
    
    // 저장된 데이터 불러오기 메소드
    func fetchData(){
        let context = Container.viewContext
        do{
            let plan = try context.fetch(Plan.fetchRequest()) as! [Plan]
            self.plans = plan.filter({getStringDate($0.time!) == getStringDate(Date())})
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //TODO: - 개별 삭제 메소드
    func deleteObject(object:NSManagedObject)->Bool{
        let context = Container.viewContext
        context.delete(object)
        
        do{
            try context.save()
            self.fetchData()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
    
    //TODO: - 완료 버튼 클릭 시 데이터 변경 메소드
    func updateDone(object:NSManagedObject)->Bool{
        let context = Container.viewContext
        do{
            try context.save()
            print(context.object(with: object.objectID))
            return true
        } catch {
            print("Error update done ::: \(error.localizedDescription)")
            context.rollback()
            return false
        }
    }
    
    
    func getStringDate(_ time:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: time)
    }
}
