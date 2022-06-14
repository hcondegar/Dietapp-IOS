//
//  addFoodSheet.swift
//  PRStuff
//
//  Created by Hans Capapey sierra on 8/6/22.
//

import SwiftUI
import Foundation

struct addFoodSheet: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    var customFoods: FetchedResults <CustomFood>
    
    @State var proteines = ""
    @State var fibra = ""
    @State var calci = ""
    @State var ferro = ""
    @State var lipids = ""
    @State var hidratsdecar = ""
    @State var calories = ""
    @State var nom = ""
    
    @State var nameExistingWarningShown = false
    @State var noNameWarningShown = false
    
    @Binding var isShown : Bool

    var body: some View {
          
        
        NavigationView{
            Form{
                
                HStack {
                    Text("\(Image(systemName: "rectangle.and.pencil.and.ellipsis"))  Nom")
                    TextField("...", text: $nom)
                        .multilineTextAlignment(.trailing)
                    .keyboardType(.default)
                }
                
                Section(header: Text("per cada 100 g")) {
                    HStack {
                        Text("Proteïnes")
                        TextField("0", text: $proteines)
                            .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        Text("g")
                    }
                    
                    HStack {
                        Text("Fibra")
                        TextField("0", text: $fibra)
                            .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        Text("g")
                    }
                    
                    HStack {
                        Text("Calci")
                        TextField("0", text: $calci)
                            .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        Text("mg")
                    }
                    
                    HStack {
                        Text("Ferro")
                        TextField("0", text: $ferro)
                            .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        Text("mg")
                    }
                    
                    HStack {
                        Text("Lípids")
                        TextField("0", text: $lipids)
                            .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        Text("g")
                    }
                    
                    HStack {
                        Text("Hidrats de carboni")
                        TextField("0", text: $hidratsdecar)
                            .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        Text("g")
                    }
                    
                    HStack {
                        Text("Caloríes")
                        TextField("0", text: $calories)
                            .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        Text("kcal")
                    }
                }
                
                HStack{
                    Spacer()
                    Button{
                        let alimentsAmbElMateixNom = customFoods.filter{food in
                            return food.name! == nom
                        }
                        
                        if (nom != ""){
                            if (alimentsAmbElMateixNom.count == 0){
                                addItem()
                                isShown = false
                            }else{
                                nameExistingWarningShown = true
                            }
                        }else{
                            noNameWarningShown = true
                        }
                    }label:{
                        HStack {
                            
                            Text ("Crear aliment")
                            
                        }
                    }.buttonStyle(.plain)
                        .foregroundColor(.accentColor)
                        .padding(.all, 5)
                        .padding(.horizontal, 10)
                        .background(Color.accentColor.opacity(0.1))
                        .cornerRadius(15)
                       
                    Spacer()
                } .listRowBackground(Color.clear)
                    .alert(isPresented: $nameExistingWarningShown) { // 4
                                Alert(
                                    title: Text("Nom no vàlid"),
                                    message: Text("Ja existeix un aliment amb aquest nom."),
                                    dismissButton: .destructive(Text("D'acord"), action: {
                                        })
                                )
                            }
                }
                
           

            .alert(isPresented: $noNameWarningShown) { // 4

                        Alert(
                            title: Text("Nom no vàlid"),
                            message: Text("Introdueix un nom per a l'aliment."),
                            dismissButton: .destructive(Text("D'acord"), action: {
                                })
                        )
                    }

                
            .navigationTitle("Nou aliment")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func addItem() {
        
        let food = CustomFood(context: viewContext)
        food.name = nom
        food.proteines = Float(proteines) ?? 0
        food.fibra = Float(fibra) ?? 0
        food.calci = Float(calci) ?? 0
        food.ferro = Float(ferro) ?? 0
        food.lipids = Float(lipids) ?? 0
        food.hidrdecar = Float(hidratsdecar) ?? 0
        food.calories = Float(calories) ?? 0
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}




struct addFoodSheet_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(ModelData())
    }
}
