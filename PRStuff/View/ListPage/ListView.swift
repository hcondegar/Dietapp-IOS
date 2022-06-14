//
//  ListView.swift
//  PRStuff
//
//  Created by Hans Capapey sierra on 25/5/22.
//

import SwiftUI

struct ListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.nameOfType)])
     var favorites: FetchedResults<FavoriteType>
    
    var body: some View {
        
        NavigationView{
           
                List{
                    Section {
                        NavigationLink(destination: EverythingList())
                        {
                            HStack{
                                Image(systemName: "list.dash")
                                    .padding(.all, 10.0)
                                    .frame(width: 30)
                                    .foregroundColor(.indigo)
                                    .font(.title2)
                                Text("Tots els registres")
                                    .font(.body.bold())
                            }
                        }
                        NavigationLink(destination: FavoritesList())
                        {
                            HStack{
                                Image(systemName: "star.fill")
                                    .padding(.all, 7.0)
                                    .frame(width: 30)
                                    .foregroundColor(.yellow)
                                    .font(.title2)
                                Text("Preferits")
                                    .font(.body.bold())
                            }
                        }
                    }
                    Section {
                        ForEach(nutrients){ type in
                        NavigationLink(destination: registerList(type: type)) {
                            HStack{
                                Image(systemName: "staroflife.fill")
                                    .padding(.all, 7.0)
                                    .frame(width: 30)
                                    .foregroundColor(.accentColor)
                                    .font(.title2)
                                Text("\(type.name)")
                                    .font(.body.bold())
                            }
                            
                        }
//                            ----
                        .contextMenu{
                            if checkIfFavourite(favorites: favorites, name: type.name) {
                                Button(action: {deleteFavorite(nameOfTypeToNotFavorite: type.name)}) {
                                Label("Eliminar de preferits", systemImage: "star.slash.fill")
                            }
                            }else {
                                Button(action: { addToFavorites(nameOfTypeToFavorite: type.name)}) {
                                Label("Afegir a preferits", systemImage: "star")
                                }
                            }
                    
//                            ----
                        }
                            
                    
                }
                        
                        
                    }
                    
            }
                
                .navigationBarTitle("Registre")
           
            
        }
        .padding(.bottom, 70)
    }
    
    private func deleteFavorite(nameOfTypeToNotFavorite : String) {
        viewContext.delete(searchToDelete(name: nameOfTypeToNotFavorite))
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
    }
    
    private func searchToDelete (name: String) -> FavoriteType {
        for item in favorites {
            if item.nameOfType == name{
                return item
            }
        }
        return FavoriteType()
    }
    
   private func checkIfFavourite (favorites : FetchedResults<FavoriteType>, name: String) -> Bool{
        for favorite in favorites{
            if (favorite.nameOfType == name){
                return true
            }
        }
        return false
    }

    private func addToFavorites(nameOfTypeToFavorite : String) {
            let newFavorite = FavoriteType(context: viewContext)
            newFavorite.nameOfType = nameOfTypeToFavorite
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        
    }
    
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
