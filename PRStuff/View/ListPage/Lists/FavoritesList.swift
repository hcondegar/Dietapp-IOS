//
//  FavoritesList.swift
//  PRStuff
//
//  Created by Hans Capapey sierra on 4/6/22.
//

import SwiftUI

struct FavoritesList: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [], animation: .default)
    var registers: FetchedResults<Registro>
    
    @FetchRequest(sortDescriptors: [], animation: .default)
    var favorites: FetchedResults<FavoriteType>



@State var selectedDay : Int = Calendar.current.component(.weekday, from: Date())
@State var selectedDate = Date()

let daysOfWeek = [
    DayOfWeek(id: 001, abreviation: "DG", numberInWeek: 1),
    DayOfWeek(id: 002, abreviation: "DL", numberInWeek: 2),
    DayOfWeek(id: 003, abreviation: "DT", numberInWeek: 3),
    DayOfWeek(id: 004, abreviation: "DM", numberInWeek: 4),
    DayOfWeek(id: 005, abreviation: "DJ", numberInWeek: 5),
    DayOfWeek(id: 006, abreviation: "DV", numberInWeek: 6),
    DayOfWeek(id: 007, abreviation: "DS", numberInWeek: 7)
]

    

var body: some View {
    
    let registersForThatTypeAndDate = registers.filter {register in
        
        return Calendar.current.component(.day, from : register.time!) == Calendar.current.component(.day, from : selectedDate)
    }
  
    ScrollView {
        VStack{
            
            
            HStack {
                Text("\(Image(systemName: "calendar")) ULTIMS 7 DIES:")
                    .padding(.leading)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.bottom, -5.0)
                .padding(.top)
            
            Divider()
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 5)
        HStack{
            
            ForEach(0..<7){ i in
                let daysSubstracted = i - 6
                let correctedDay = substractDays(numberOfDays: -daysSubstracted)
                
                let day = Calendar.current.component(.day, from : correctedDay)
                
                let numberInWeekOfDay = Calendar.current.component(.weekday, from: correctedDay)
                
                let colorUsed : Color = .yellow
                
                VStack{
                    ForEach (daysOfWeek) { day in
                        if (day.numberInWeek == numberInWeekOfDay){
                            Text(day.abreviation)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Text ("\(day)")
                        .foregroundColor(numberInWeekOfDay == selectedDay ? colorUsed : .white)
                        .font(numberInWeekOfDay == selectedDay ? .title3.bold() : .title3.bold())
                        .frame(width: 40.0, height: 40.0)
                        .background(
                            Circle()
                                .frame(width: 40.0, height: 40.0)
                                .opacity(numberInWeekOfDay == selectedDay ? 1 : 1)
                                .foregroundColor(numberInWeekOfDay == selectedDay ? .gray.opacity(0.2) : colorUsed)
                                .shadow(color: numberInWeekOfDay == selectedDay ? .primary.opacity(0) :  .primary.opacity(0.15), radius: 10, x: 0, y: 0)
                               
                        )
                        .onTapGesture(perform: {
                            selectedDay = numberInWeekOfDay
                            selectedDate = correctedDay
                        })
                    
                    
                }
                .padding(.horizontal, 2.0)
            }
        }
       
        .padding(.bottom, 5)
        
        
        VStack{
            
            HStack {
                Text("Totals")
                    .padding(.top)
                    .padding(.leading)
                    .font(.headline)
                Spacer()
            }
            
            ForEach (favorites){ favorite in
                let registersForThatFavorite = finRegistersFor(type: favorite.nameOfType!, registers: registersForThatTypeAndDate)
                
                VStack {
                    HStack{
                        Text (favorite.nameOfType!)
                            .foregroundColor(.secondary)
                            .padding(.leading)
                            .padding(.top, 5)
                        Spacer()
                    }
                    
                    totalLabel(consumed: calculateTotalOfDay(registros: registersForThatFavorite), nutrient: findNutrient(favorite: favorite), typeOfMesurement: findNutrientMeasurementByFavorite(favorite: favorite))
                }
                
            }
                
            HStack {
                Text("Llistat d'entrades")
                    .padding(.top)
                    .padding(.leading)
                    .font(.headline)
                Spacer()
            }
            
            ForEach (favorites){ favorite in
                HStack{
                    Text (favorite.nameOfType!)
                        .foregroundColor(.secondary)
                        .padding(.leading)
                        .padding(.top, 5)
                    Spacer()
                }
                let registersForThatFavorite = finRegistersFor(type: favorite.nameOfType!, registers: registersForThatTypeAndDate)
                
                if (registersForThatFavorite.count == 0 ){
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .padding(.horizontal)
                            .padding(.bottom, 5)
                            .frame(height: 75)
                            .foregroundColor(colorScheme == .light ? .primary : .gray.opacity(0.4))
                            .colorInvert()
                            .shadow(color: .primary.opacity(0.08), radius: 20, x: 0, y: 10)
                 
                            VStack {
                                HStack {
                                    Text("\(Image(systemName: "exclamationmark.circle")) Cap entrada")
                                        .padding(.leading, 30.0)
                                        .font(.body.bold())
                                        .foregroundColor(.orange)
                                    Spacer()
                                }
                            }
                    }
                            
                }
                else {
                    ForEach (registersForThatFavorite){ register in
                        
                        let quantityString : String = String(format: "%.2f", register.quantity)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .padding(.horizontal)
                                .padding(.bottom, 5)
                                .frame(height: 75)
                                .foregroundColor(colorScheme == .light ? .primary : .gray.opacity(0.4))
                                .colorInvert()
                                .shadow(color: .primary.opacity(0.08), radius: 20, x: 0, y: 10)
                     
                                VStack {
                                    HStack {
                                        Text("\(register.food!)")
                                            .padding(.leading, 30.0)
                                            .font(.body.bold())
                                        Spacer()
                                            
                                    }
                                    HStack {
                                        Text("\(quantityString) \(findMesurementType(registro: register))")
                                            .padding(.leading, 30.0)
                                        Spacer()
                                            
                                    }
                                }
                            
                            Button{
                                let registersToDelete : [Registro] = registers.filter {registro in
                                    return registro.time == register.time
                                }
                                
                                deleteRegister(registersToDelete: registersToDelete)
                            }label:
                            {
                                Image(systemName: "minus.circle")
                                
                            }
                            .buttonStyle(.plain)
                                .offset(x: 155, y: -15)
                                .foregroundColor(.yellow)
                        
                        }
                        .transition(AnyTransition.scale)
                        .padding(.vertical)
                        .padding(.vertical, -15)
                        
                    }
                }
            }
            
            
        }.navigationBarTitle("Preferits")
            Spacer(minLength: 85)
        }
        
    }
        
    }
    
    func calculateTotalOfDay(registros : [Registro]) -> Float{
        var total : Float = 0
        for registro in registros{
            total += registro.quantity
        }
        return total
    }
    
    func favoritesNames () -> [String]{
        var favoritesNames : [String] = []
        
        for favorite in favorites{
            favoritesNames.append(favorite.nameOfType!)
        }
        
        return favoritesNames
    }
    
    func finRegistersFor (type: String, registers : [Registro]) -> [Registro]{
        return registers.filter{register in
            return register.type! == type
        }
    }
    
    func findNutrientMeasurementByFavorite (favorite: FavoriteType) -> String{
        
        for nutrient in nutrients {
            if nutrient.name == favorite.nameOfType{
                return nutrient.mesurementType
            }
        }
        return ""
    }
    
    func findNutrient (favorite : FavoriteType) -> NutrientType{
        for nutrient in nutrients{
            if nutrient.name == favorite.nameOfType{
                return nutrient
            }
        }
        return nutrients[0]
    }
    
    func findFavoriteRegisters () -> [Registro]{
        var favoriteregisters : [Registro] = []
        
        for registro in registers {
            if (favoritesNames().contains(registro.type!)){
                favoriteregisters.append(registro)
            }
        }
        
        return favoriteregisters
    }
    private func deleteRegister (registersToDelete : [Registro]){
        for registerToDelete in registersToDelete{
            viewContext.delete(registerToDelete)
        }
             do {
                 try viewContext.save()
             } catch {
                 let nsError = error as NSError
                 fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
             }
     }
}
    

struct FavoritesList_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesList()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

