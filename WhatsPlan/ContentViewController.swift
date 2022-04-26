//
//  ViewController.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/04/26.
//

import UIKit
import CoreData

class ContentViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        setUpViews()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(){
        let first = firstItemViewController()
        let second = secondItemViewController()
        
        
        let tabs = [first,second]
        
        self.setViewControllers(tabs, animated: true)
    }
    
}



class firstItemViewController:UIViewController{
    
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
        print("View Did Load")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = .orange
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func saveContext(){
        let context = Container.viewContext
        if context.hasChanges{
            do{
                try context.save()
                print(context)
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    func dummySave(){
        let context = Container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Plan", in: context)
        
        if let entity = entity {
            let plan = NSManagedObject(entity: entity, insertInto: context)
            plan.setValue("Example", forKey: "name")
            plan.setValue(UUID(), forKey: "id")
            
            do{
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchData(){
        let context = Container.viewContext
        do{
            let plan = try context.fetch(Plan.fetchRequest()) as! [Plan]
            plan.forEach { plan in
                print(plan.name)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

class secondItemViewController:UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Did Load")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = .orange
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
