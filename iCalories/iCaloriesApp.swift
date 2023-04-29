//
//  iCaloriesApp.swift
//  iCalories
//
//  Created by Hannah on 28/4/2023.
//

import SwiftUI

@main
struct iCaloriesApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext) // to inject it in environment
        }
    }
}
