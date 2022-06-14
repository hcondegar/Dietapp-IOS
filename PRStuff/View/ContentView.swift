//
//  ContentView.swift
//  PRStuff
//
//  Created by Hugo Contreras Garcia on 14/4/22.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        WelcomeView()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(ModelData())
    }
}
