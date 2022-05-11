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
    let manager = PlanManger.shared
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setUpViews()
        
        let request:NSFetchRequest<Plan> = Plan.fetchRequest()
        manager.plans = manager.fetch(request: request)
        self.manager.dates = self.manager.plans.map{self.getStringDate($0.time!)}
        
        
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
            let plan = plan(name: todo, done: false)
            
            if self.manager.insertNewTask(plan: plan){
                let request:NSFetchRequest<Plan> = Plan.fetchRequest()
                self.manager.plans = self.manager.fetch(request: request)
                self.manager.dates = self.manager.plans.map{self.getStringDate($0.time!)}
                self.tableView.reloadData()
            }
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
        let data = manager.plans.filter{getStringDate($0.time!) == getStringDate(Date())}
        if data.isEmpty{
            self.tableView.setEmptyMessage("오늘 일정이 없어요")
        } else{
            self.tableView.reStore()
        }
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CustomCellView else{return UITableViewCell()}
        let data = manager.plans.filter{getStringDate($0.time!) == getStringDate(Date())}
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.delegate = self
        
        cell.id = data[indexPath.row].id
        cell.title.text = data[indexPath.row].name
        cell.title.isOn = data[indexPath.row].done
        cell.toggleButton.isOn = data[indexPath.row].done
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let data = manager.plans.filter{ getStringDate($0.time!) == getStringDate(Date()) }
        if editingStyle == .delete{
            if manager.delete(object: data[indexPath.row]){
                let request:NSFetchRequest<Plan> = Plan.fetchRequest()
                manager.plans = manager.fetch(request: request)
                self.manager.dates = manager.plans.map{getStringDate($0.time!)}
                
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
        guard let indexPath = manager.plans.firstIndex(where: {$0.id == customCell.id}) else{return}
        let object = manager.plans[indexPath]
        
        if self.manager.update(object: object){
            self.manager.plans = manager.fetch(request: Plan.fetchRequest())
            self.manager.dates = manager.plans.map{getStringDate($0.time!)}
            tableView.reloadData()
        }
        
//        if updateDone(object: object, done: !object.done){
//            self.fetchData()
//            self.tableView.reloadData()
//        }
    }
}

extension TodayViewController{
    
//    // 새로운 일정 저장 메소드
//    func saveTask(name:String){
//        let context = Container.viewContext
//        let task = NSEntityDescription.entity(forEntityName: "Plan", in: context)
//
//        if let task = task {
//            let task = NSManagedObject(entity: task, insertInto: context)
//            task.setValue(UUID(), forKey: "id")
//            task.setValue(false, forKey: "done")
//            task.setValue(name, forKey: "name")
//            task.setValue(Date(), forKey: "time")
//
//            do{
//                try context.save()
//            } catch {
//                print("Error in save Method ::: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    // 저장된 데이터 불러오기 메소드
//    func fetchData(){
//        let context = Container.viewContext
//        do{
//            let plan = try context.fetch(Plan.fetchRequest()) as! [Plan]
//            self.plans = plan.filter({getStringDate($0.time!) == getStringDate(Date())})
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//
//    //TODO: - 개별 삭제 메소드
//    func deleteObject(object:NSManagedObject)->Bool{
//        let context = Container.viewContext
//        context.delete(object)
//
//        do{
//            try context.save()
//            self.fetchData()
//            return true
//        } catch {
//            context.rollback()
//            return false
//        }
//    }
//
//    //TODO: - 완료 버튼 클릭 시 데이터 변경 메소드
//    func updateDone(object:NSManagedObject,done:Bool)->Bool{
//        let context = Container.viewContext
//        object.setValue(done, forKey: "done")
//
//        do{
//            try context.save()
//            print("Context update success")
//            print(context.object(with: object.objectID))
//            return true
//        } catch {
//            print("Error update done ::: \(error.localizedDescription)")
//            context.rollback()
//            return false
//        }
//    }
    
    func getStringDate(_ time:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: time)
    }
}
