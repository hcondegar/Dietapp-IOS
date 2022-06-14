//
//  UserInfo.swift
//  PRStuff
//
//  Created by Hans Capapey sierra on 8/6/22.
//

import SwiftUI
import Foundation


struct UserInfo: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    var users : FetchedResults<Usuario>

    @Binding var isUserEditShown : Bool
    
    
    
    var body: some View {
        let usuario = users[0]
        
        
        VStack {
            HStack {
                Text(usuario.name!)
                    .font(.title3.bold())
                
                Spacer()
                Button{
                    isUserEditShown.toggle()
                }label:{
                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.accentColor)
                        .symbolRenderingMode(.hierarchical)
                        .font(.title2)
                }.buttonStyle(.plain)
                
            }
            .padding(.bottom, 2)
            .padding(.horizontal)
            
            .sheet(isPresented: $isUserEditShown){
               EditUserSheet(isShown: $isUserEditShown)
            }
            
           
            VStack {
                HStack{
                    Image(systemName: "figure.arms.open")
                        .foregroundColor(.accentColor)
                    Text(usuario.genderName!)
                        .foregroundColor(.secondary)
                    Spacer()
                        Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(.accentColor)
                    Text("\(usuario.age) anys")
                            .foregroundColor(.secondary)
                    Rectangle()
                        .frame(width: 50)
                        .colorInvert()
                }
                .padding(.horizontal)
                .padding(.bottom, 1)

                HStack{
                    Image(systemName: "scalemass.fill")
                        .foregroundColor(.accentColor)
                    Text("\(usuario.weight) Kg")
                        .foregroundColor(.secondary)
                    Spacer()
                    Image(systemName: "arrow.up.and.down")
                        .foregroundColor(.accentColor)
                    Text("\(usuario.height) Cm")
                        .foregroundColor(.secondary)
                    Rectangle()
                        .frame(width: 50)
                        .colorInvert()
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 1)
                
                HStack{
                    Image(systemName: "flame.fill")
                        .foregroundColor(.accentColor)
                    Text(usuario.sportName!)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            .padding(.leading, 10)
        }
    }
    
    
    
    private func addItem() {
//
        let user = Usuario(context: viewContext)
            user.name = "Michelle"
            user.age = 30
            user.weight = 60
            user.height = 155
            user.gender = 0
            user.genderName = "dona"

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

    }
}

struct UserInfo_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
