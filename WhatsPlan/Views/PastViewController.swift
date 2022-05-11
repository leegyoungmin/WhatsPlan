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
import FSCalendar

class PastViewConrtoller:UIViewController{
    let manager = PlanManger.shared
    var dates:[String] = []
    var selectedDate:Date = Date()
    var plans:[Plan] = []

    lazy var pastTableView:UITableView = {
        let table = UITableView()
        table.register(PastCustomCell.classForCoder(), forCellReuseIdentifier: "cell")
        table.dataSource = self
        table.delegate = self
        return table
    }()
    lazy var calendar:FSCalendar = {
        let calendar = FSCalendar()
        //지역설정
        calendar.locale = Locale(identifier: "ko_KR")
        
        //CALENDAR VIEW SETTING
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.appearance.headerTitleColor = UIColor(named: "AccentColor")
        calendar.appearance.headerTitleFont = .systemFont(ofSize: 24,weight:.heavy)
        calendar.headerHeight = 0
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.selectionColor = UIColor(named: "AccentColor")
        calendar.appearance.eventDefaultColor = UIColor(named: "AccentColor")
        calendar.appearance.eventSelectionColor = UIColor.white
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -10)
        calendar.appearance.weekdayTextColor = UIColor(named: "AccentColor")
        calendar.appearance.titleFont = .systemFont(ofSize: 15)
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.titleWeekendColor = .lightGray
        calendar.today = nil
        calendar.scrollEnabled = true
        
        //DELEGATE 설정
        calendar.dataSource = self
        calendar.delegate = self
        
        //layer 설정
        calendar.layer.cornerRadius = 20
        
        return calendar
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
        calendar.reloadData()
//        self.fetchData()
        pastTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingNavigationBar()
        setUpViews()
    }
    
    func settingNavigationBar(){
        self.navigationItem.title = settingNavigationMonthDate(self.selectedDate)
        
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(didTappedNext))
        self.navigationItem.rightBarButtonItem = rightButton
        
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTappedPrevious))
        self.navigationItem.leftBarButtonItem = leftButton
        
        self.calendar.select(selectedDate)
    }
    
    @objc func didTappedNext(){
        moveToCalendarPage(true)
    }
    @objc func didTappedPrevious(){
        moveToCalendarPage(false)
    }
    
    func moveToCalendarPage(_ isNext:Bool){
        let _calendar = Calendar.current
        var dateComponent = DateComponents()

        if isNext{
            dateComponent.month = 1
        }else{
            dateComponent.month = -1
        }
        self.calendar.currentPage = _calendar.date(byAdding: dateComponent, to: self.calendar.currentPage)!
        self.calendar.setCurrentPage(self.calendar.currentPage, animated: true)
    }
    
    func setUpViews(){
        self.view.backgroundColor = .white

        [calendar,pastTableView].forEach{
            view.addSubview($0)
        }
        
        calendar.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaInsets.top).offset(100)
            $0.leading.equalTo(view.safeAreaInsets.left).offset(10)
            $0.trailing.equalTo(view.safeAreaInsets.right).offset(-10)
            $0.height.equalTo(320)
        }

        pastTableView.snp.makeConstraints{
            $0.leading.equalTo(calendar.snp.leading)
            $0.bottom.equalTo(view.safeAreaInsets.bottom)
            $0.top.equalTo(calendar.snp.bottom)
            $0.trailing.equalTo(view.safeAreaInsets.right).offset(-10)
        }
    }
}

extension PastViewConrtoller:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
extension PastViewConrtoller:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = manager.plans.filter{
            getStringDate($0.time!) == getStringDate(self.selectedDate)
        }
        return data.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let data = manager.plans.filter{
            getStringDate($0.time!) == getStringDate(self.selectedDate)
        }
        return "\(data.filter{$0.done == true}.count)/\(data.count)"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? PastCustomCell else{return UITableViewCell()}
        let data = manager.plans.filter{ getStringDate($0.time!) == getStringDate(selectedDate) }

        cell.selectionStyle = .none
        cell.title.text = data[indexPath.row].name
        
        if data[indexPath.row].done{
            cell.image.image = UIImage(systemName: "checkmark.circle.fill")
        }else{
            cell.image.image = UIImage(systemName: "circle")
        }
        
        return cell
    }
}

extension PastViewConrtoller:FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if manager.dates.contains(getStringDate(date)){
            return 1
        }else{
            return 0
        }
    }
}

extension PastViewConrtoller:FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date
        self.pastTableView.reloadData()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.navigationItem.title = settingNavigationMonthDate(calendar.currentPage)
    }

}

extension PastViewConrtoller{
    func getStringDate(_ time:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: time)
    }
    
    func settingNavigationMonthDate(_ date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        return formatter.string(from: date)
    }
    
    func isWeekDay(_ date:Date)->Bool{
        let calendar = Calendar(identifier: .gregorian)
        let comps = calendar.dateComponents([.weekday], from: date)
        
        return comps.weekday! == 6
    }
}
