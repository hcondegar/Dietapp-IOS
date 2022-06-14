//
//  deleteFoodSheet.swift
//  DietApp
//
//  Created by Hans Capapey sierra on 9/6/22.
//

import SwiftUI

struct deleteFoodSheet: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    var customFoods: FetchedResults <CustomFood>
    
    @Binding var isShown : Bool
    
    var body: some View {
        NavigationView {
            List {
            
                ForEach (customFoods){food in
                    HStack{
                        Text("\(Image(systemName: "carrot"))  \(food.name!)")
                        Spacer()
                        Button{
                                let foodToDelete = findFood(name: food.name!)
                            
                                if foodToDelete.count == 0
                            {}else{
                                    withAnimation(){
                                        deleteFood(foodToDelete: foodToDelete[0])
                                        checkIfAllDeleted()
                                    }
                                }
                            }label:{
                                Image(systemName: "minus.circle")
                            }
                            .buttonStyle(.plain)
                            .foregroundColor(.accentColor)
                        }
                    }
                
            }
            .transition(AnyTransition.scale)
                .navigationTitle("Eliminar aliment")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func checkIfAllDeleted (){
        if (customFoods.count == 0) {
            isShown = false
        }
    }
    
    private func deleteFood (foodToDelete : CustomFood){
         viewContext.delete(foodToDelete)
        
             do {
                 try viewContext.save()
             } catch {
                 let nsError = error as NSError
                 fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
             }
     }
    
    func findFood (name : String) -> [CustomFood]{
        return customFoods.filter{food in
            return food.name! == name
        }
    }
    
}

struct deleteFoodSheet_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(ModelData())
    }
}
