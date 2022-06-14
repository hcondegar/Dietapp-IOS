//
//  FavoriteButton.swift
//  PRStuff
//
//  Created by Hans Capapey sierra on 5/6/22.
//

import SwiftUI

struct FavoriteButton: View {
    var typeName : String
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.nameOfType)])
     var favorites: FetchedResults<FavoriteType>
    
    var body: some View {
        Button{
            if checkIfFavourite(favorites: favorites, name: typeName){
                deleteFavorite(nameOfTypeToNotFavorite: typeName)
            }else {
                addToFavorites(nameOfTypeToFavorite: typeName)
            }
            
        }label:{
            if checkIfFavourite(favorites: favorites, name: typeName){
                Image (systemName: "star.fill")
                    .foregroundColor(.yellow)
            }else{
                Image (systemName: "star")
            }
                
            }
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
    
    
    
    func searchToDelete (name: String) -> FavoriteType {
        for item in favorites {
            if item.nameOfType == name{
                return item
            }
        }
        return FavoriteType()
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


private func checkIfFavourite (favorites : FetchedResults<FavoriteType>, name: String) -> Bool{
    for favorite in favorites{
        if (favorite.nameOfType == name){
            return true
        }
    }
    return false
}



struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButton(typeName: "Hidratos De Azufre")
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
