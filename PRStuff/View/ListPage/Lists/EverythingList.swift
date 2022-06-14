//
//  EverythingList.swift
//  PRStuff
//
//  Created by Hans Capapey sierra on 4/6/22.
//

import SwiftUI

struct EverythingList: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Registro.time, ascending: true)],
        animation: .default)
    private var registers: FetchedResults<Registro>
    
    

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
    
    let registersFotThatType = registers
    
    let registersForThatTypeAndDate = registersFotThatType.filter {register in
        
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
                
                let colorUsed : Color = .indigo
                
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
                Text("Llistat d'entrades")
                    .padding(.top)
                    .padding(.leading)
                    .font(.headline)
                Spacer()
            }
            
            ForEach (nutrients){ nutrient in
                HStack{
                    Text (nutrient.name)
                        .foregroundColor(.secondary)
                        .padding(.leading)
                        .padding(.top, 5)
                    Spacer()
                }
                let registersfForNutrient = finRegistersFor(type: nutrient.name, registers: registersForThatTypeAndDate)
                
            if (registersfForNutrient.count == 0 ){
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
                ForEach (registersfForNutrient){ register in
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
                                    Text("\(quantityString) \(findMesurementType(registro:register))")
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
                        .foregroundColor(.indigo)
                        .buttonStyle(.plain)
                            .offset(x: 155, y: -15)
                    
                    }
                    
                    .transition(AnyTransition.scale)
                    .padding(.vertical)
                    .padding(.vertical, -15)
                       
                        }
                    
                    
                }
               
            
            }
        }.navigationBarTitle("Tots els registres")

            Spacer(minLength: 85)
        
    }
        
    }
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
    func finRegistersFor (type: String, registers : [Registro]) -> [Registro]{
        return registers.filter{register in
            return register.type! == type
        }
    }
    
func findMesurementType (registro : Registro) -> String {
    for nutrient in nutrients{
        if (nutrient.name == registro.type) {
            return nutrient.mesurementType
        }
    }
    return ""
}

struct EverythingList_Previews: PreviewProvider {
    static var previews: some View {
        EverythingList()
            .environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
    }
}
