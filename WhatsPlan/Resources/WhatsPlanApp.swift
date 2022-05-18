//
//  WhatsPlanApp.swift
//  WhatsPlan
//
//  Created by 이경민 on 2022/05/17.
//

import SwiftUI

@main
struct WhatsPlanApp:App{
    let persistenceController = PersistenceController.shared
    
    @AppStorage("isDarkMode") var isDarkMode:Bool = false
    
    var body: some Scene{
        WindowGroup{
            ContentView()
                .environment(\.managedObjectContext,persistenceController.container.viewContext)
                .preferredColorScheme(.dark)
        }
    }
}
