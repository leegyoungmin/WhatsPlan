//
//  PlanManger.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/05/11.
//

import Foundation
import CoreData

class PlanManger{
    static var shared:PlanManger = PlanManger()
    
    lazy var container : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WhatsPlan")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    var context : NSManagedObjectContext{
        return self.container.viewContext
    }
    
    func fetch<T:NSManagedObject>(request:NSFetchRequest<T>)->[T]{
        do{
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    var plans:[Plan] = []
    var dates:[String] = []
    
    
    @discardableResult
    func insertNewTask(plan:plan)->Bool{
        let entitiy = NSEntityDescription.entity(forEntityName: "Plan", in: self.context)
        
        if let entitiy = entitiy {
            let managerObject = NSManagedObject(entity: entitiy, insertInto: self.context)
            
            managerObject.setValue(plan.name, forKey: "name")
            managerObject.setValue(plan.time, forKey: "time")
            managerObject.setValue(plan.id, forKey: "id")
            managerObject.setValue(plan.done, forKey: "done")
            
            do{
                try self.context.save()
                return true
            } catch {
                print("Error in save context ::: \(error.localizedDescription)")
                return false
            }
        }else{
            return false
        }
    }
    
    @discardableResult
    func delete(object:NSManagedObject)->Bool{
        self.context.delete(object)
        
        do{
            try context.save()
            return true
        } catch {
            print("Error in delete ::: \(error.localizedDescription)")
            return false
        }
    }
    
    @discardableResult
    func update(object:NSManagedObject)->Bool{
        guard let isDone = object.value(forKey: "done") as? Bool else{return false}
        object.setValue(!isDone, forKey: "done")
        do{
            try context.save()
            return true
        } catch {
            print("Error in update ::: \(error.localizedDescription)")
            return false
        }
    }
}
