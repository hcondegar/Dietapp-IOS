//
//  EveryRegisterSheet.swift
//  PRStuff
//
//  Created by Hans Capapey sierra on 5/6/22.
//

import SwiftUI

struct EveryRegisterSheet: View {
    var registros : [Registro]
    var type : NutrientType
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    func deleteRegister (registerToDelete : Registro){
       withAnimation{
       viewContext.delete(registerToDelete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
    }
   }

    var body: some View {
        
        
        let registers = registros.sorted {$0.time! > $1.time!}
        
        ScrollView {
            VStack{
                HStack {
                    Text("Totes les entrades")
                        .font(.title3.bold())
                        .padding(.leading)
                        .padding(.top,30)
                    Spacer()
                }
                Divider()
                    .padding(.horizontal)
                    .padding(.bottom)
            if (registers.count == 0 ){
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                        .frame(height: 95)
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
                ForEach (registers){ register in
                    
                    let quantityString : String = String(format: "%.2f", register.quantity)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .padding(.horizontal)
                            .padding(.bottom, 5)
                            .frame(height: 95)
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
                                    Text("\(quantityString) \(type.mesurementType)")
                                        .padding(.leading, 30.0)
                                    Spacer()
                                        
                                }
                                HStack {
                                    Spacer()

                                    Text("\(register.time!, formatter: timeFormatter)")
                                        .padding(.trailing, 30)
                                                                            
                                }
                                
                            }
                        Button{
                           deleteRegister(registerToDelete: register)
                        }label:
                        {
                            Image(systemName: "minus.circle")
                            
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(.accentColor)
                            .offset(x: 155, y: -25)
                }
                    .transition(AnyTransition.scale)
                    
                }
                Spacer(minLength: 0)
            }
                
        }
            
    }
        
}
    
}


private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

struct EveryRegisterSheet_Previews: PreviewProvider {
    static var previews: some View {
       ListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
