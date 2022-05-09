//
//  PastViewController.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/04/26.
//

import Foundation
import SnapKit
import UIKit
import CoreData

class PastViewConrtoller:UIViewController{
    var dates:[String] = []
    var plans:[Plan] = []

    lazy var pastTableView:UITableView = {
        let table = UITableView()
        table.register(SectionHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: "header")
        table.register(PastCustomCell.classForCoder(), forCellReuseIdentifier: "cell")
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    lazy var Container:NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WhatsPlan")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                print("Error in read Container ::: \(error)")
            }else{
                print(container.name)
            }
        }
        return container
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        fetchData()
        self.pastTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpViews()
    }
    func setUpNavigationBar(){
        self.navigationItem.title = "과거이력"
    }
    
    
    func setUpViews(){
        self.view.backgroundColor = .white

        [pastTableView].forEach{
            view.addSubview($0)
        }
        
        pastTableView.snp.makeConstraints{
            $0.leading.equalTo(view.snp.leading)
            $0.top.equalTo(view.safeAreaInsets.top)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.safeAreaInsets.bottom)
        }
    }
}

extension PastViewConrtoller:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dates.count
    }
    
}
extension PastViewConrtoller:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        plans.filter({getStringDate($0.time!) == dates[section]}).count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? SectionHeaderView else{return UITableViewHeaderFooterView()}
        let date = dates[section]
        let data = plans.filter({getStringDate($0.time!) == date})
        let subTitleText:String = "\(data.filter({$0.done == true}).count) / \(data.count)"
        headerView.title.text = date
        headerView.subTitle.text = subTitleText
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? PastCustomCell else{return UITableViewCell()}
        cell.selectionStyle = .none
        let data = plans.filter({getStringDate($0.time!) == dates[indexPath.section]})
        cell.title.text = data[indexPath.row].name
        
        if data[indexPath.row].done{
            cell.image.image = UIImage(systemName: "checkmark.circle.fill")
        }else{
            cell.image.image = UIImage(systemName: "circle")
        }
        
        return cell
    }
    
    
}

extension PastViewConrtoller{
    func fetchData(){
        self.plans.removeAll()
        let context = Container.viewContext
        do{
            let plans = try context.fetch(Plan.fetchRequest()) as! [Plan]
            settingDate(plans)
            self.plans = plans
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func settingDate(_ plans:[Plan]){
        plans.forEach{
            if !self.dates.contains(getStringDate($0.time!)){
                self.dates.append(getStringDate($0.time!))
            }
        }
    }
    
    func getStringDate(_ time:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: time)
    }
}
