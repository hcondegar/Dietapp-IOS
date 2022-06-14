//
//  PRStuffApp.swift
//  PRStuff
//
//  Created by Hugo Contreras Garcia on 14/4/22.
//

import SwiftUI

@main
struct PRStuffApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(modelData)
        }
    }
}
