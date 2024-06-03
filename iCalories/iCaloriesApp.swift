//
//  iCaloriesApp.swift
//  iCalories
//
//  Created by Christopher Mata on 8/26/22.
//

import SwiftUI

@main
struct iCaloriesApp: App {
    
    // Injecting the DB to be used by the project
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            
            // The .enviornment makes it so the DB can be used anywhere in the app
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
