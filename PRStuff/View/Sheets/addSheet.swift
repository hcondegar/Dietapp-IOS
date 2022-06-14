//
//  addSheet.swift
//  PRStuff
//
//  Created by Hans Capapey sierra on 7/6/22.
//

import SwiftUI



struct addSheet: View {
    
    
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var modelData : ModelData
    
    @State var dayPicked = Date()
    @State var foodPicked = 0
    @State var quantitat = ""
    
    @State var quantityWarningisShown = false
    
    @Binding var isShown: Bool
    
    @State var addFoodIsShown = false
    @State var deleteFoodIsShown = false
    
    @FetchRequest(sortDescriptors: [])
    var customFoods: FetchedResults <CustomFood>
    var body: some View {
        
        
        
        var everyFood : [Food] = modelData.foods
        
        NavigationView {
            VStack {
                Form {
                    DatePicker("\(Image(systemName: "calendar"))  Data", selection: $dayPicked, displayedComponents: .date)
                    
                    Section {
                       
                        
                        Picker(selection: $foodPicked, label:
                               
                                Text("\(Image(systemName: "carrot"))  Aliment")) {
                                
                                ForEach(0 ..< everyFood.count) { index in
                                    Text(everyFood[index].name).tag(index)
                                }
                                ForEach(customFoods){ customFood in
                                    var indice = 0
                                    let finalindex = indice + 10 + customFoods.firstIndex(where: {$0.name == customFood.name!})!
                                    Text("\(customFood.name!)").tag(finalindex)
                                }
                            
                        }
                               
                                
                                
                        HStack{
                            Text("\(Image(systemName: "plus.forwardslash.minus"))  Quantitat")
                            
                            TextField("0", text: $quantitat)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(/*@START_MENU_TOKEN@*/.decimalPad/*@END_MENU_TOKEN@*/)
                            Text("g")
                        }
                    }
                    
                    Section {
                        Button{
                            addFoodIsShown.toggle()
                        }label: {
                            Text ("\(Image(systemName: "plus.circle"))  Crear nou aliment...")
                                .foregroundColor(.primary)
                        }
                        
                            Button{
                                if (customFoods.count != 0){
                                    deleteFoodIsShown.toggle()
                                }
                        }label: {
                            Text ("\(Image(systemName: "trash.circle"))  Eliminar aliment...")
                                .foregroundColor(.primary)
                        }
                            
                    }
                            
                            HStack {
                                Spacer()
                                Button{
                                    if (quantitat != ""){
                                        addItem(everyFood: everyFood)
                                        isShown = false
                                    }else{
                                            quantityWarningisShown = true
                                        
                                        
                                    }
                                }label: {
                                    Text ("Crear registre")
                                    
                                }
                                .buttonStyle(.plain)
                                .foregroundColor(.accentColor)
                                .padding(.all, 5)
                                .padding(.horizontal, 10)
                                .background(Color.accentColor.opacity(0.1))
                                .cornerRadius(15)
                                Spacer()
                            }
                            .listRowBackground(Color.clear)
                        }
                
                .alert(isPresented: $quantityWarningisShown) { // 4

                            Alert(
                                title: Text("Quantitat no vàlida"),
                                message: Text("Afegeix un valor a la quantitat."),
                                dismissButton: .destructive(Text("D'acord"), action: {
                                    })
                            )
                        }
               
                
                
                   
                    
                
                .navigationBarTitle("Nou registre")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $addFoodIsShown){
                    addFoodSheet(isShown: $addFoodIsShown)}
                .sheet(isPresented: $deleteFoodIsShown){
                    deleteFoodSheet(isShown: $deleteFoodIsShown)
                    
                }

            }
            
        }
        
    }
    
    
    private func addItem(everyFood : [Food]) {
        let floatQuantity = Float($quantitat.wrappedValue) ?? 0
        
        withAnimation {
            for nutrient in nutrients{
                if ($foodPicked.wrappedValue < 10){
                    
                    if (getOfThatNutrient(nutrient: nutrient, everyFood: everyFood) == 0){
                    }else {
                        let register = Registro(context: viewContext)
                        register.food = everyFood[$foodPicked.wrappedValue].name
                        register.time = $dayPicked.wrappedValue
                        register.quantity = floatQuantity * getOfThatNutrient(nutrient: nutrient, everyFood: everyFood) / 100
                        register.type = nutrient.name
                        
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                }else{
                    
                    if(getOfThatNutrientCustom(nutrient: nutrient, everyCustomFood: customFoods) != 0){
                        let register = Registro(context: viewContext)
                        register.food = customFoods[$foodPicked.wrappedValue - 10].name
                        register.time = $dayPicked.wrappedValue
                        register.quantity = floatQuantity * getOfThatNutrientCustom(nutrient: nutrient, everyCustomFood: customFoods) / 100
                        register.type = nutrient.name
                        
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                    
                }
                
                
            }
            
        }
    }
    
    func getOfThatNutrient (nutrient: NutrientType, everyFood : [Food]) -> Float{
        let foodPickedInList = everyFood [$foodPicked.wrappedValue]
        let values = foodPickedInList.values
        return values[nutrient.name] ?? 0
    }
    
    func getOfThatNutrientCustom (nutrient: NutrientType, everyCustomFood : FetchedResults<CustomFood>) -> Float{
        let foodPickedInList = everyCustomFood [$foodPicked.wrappedValue - 10]
        if (nutrient.name == "Proteïnes"){
            return foodPickedInList.proteines
        }else if (nutrient.name == "Fibra"){
            return foodPickedInList.fibra
        }else if (nutrient.name == "Hidrats de carboni"){
            return foodPickedInList.hidrdecar
        }else if (nutrient.name == "Calci"){
            return foodPickedInList.calci
        }else if (nutrient.name == "Ferro"){
            return foodPickedInList.ferro
        }else if (nutrient.name == "Lípids"){
            return foodPickedInList.lipids
        }else if (nutrient.name == "Caloríes"){
            return foodPickedInList.calories
        }
        
        return 0
    }

    
}


struct addSheet_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
