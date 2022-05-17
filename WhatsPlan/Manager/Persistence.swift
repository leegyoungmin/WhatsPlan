//
//  PlanManger.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/05/11.
//

import Foundation
import CoreData

class PersistenceController{
    //MARK: - 컨트롤러
    static let shared = PersistenceController()
    
    //MARK: - 컨테이너
    let container:NSPersistentContainer
    
    init(inMemory:Bool = false){
        container = NSPersistentContainer(name: "WhatsPlan")
        
        if inMemory{
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                print(error.localizedDescription)
//                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    static var preview:PersistenceController = {
        let result = PersistenceController(inMemory: true)
        
        let viewcontext = result.container.viewContext
        for i in 0..<5{
            let newItem = Plan(context: viewcontext)
            newItem.name = "Sample task No. \(i)"
            newItem.time = Date()
            newItem.done = false
            newItem.id = UUID()
        }
        
        do{
            try viewcontext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError)")
        }
        return result
    }()
}
