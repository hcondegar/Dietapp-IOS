//
//  DietPage.swift
//  PRStuff
//
//  Created by Hans Capapey sierra on 18/5/22.
//

import SwiftUI

struct DietPage: View {
    @Environment(\.colorScheme) var colorScheme
    
    
    
    @State var isUserEditShown = false
    
    enum ordenarPer: String, CaseIterable, Identifiable {
        case nom, majorAMenor, menorAMajor
        var id: Self { self }
    }

    @State public var ordenatPer: ordenarPer = .nom
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Registro.time, ascending: true)],
        animation: .default)
    private var registers: FetchedResults<Registro>
    
    
    var body: some View {
        NavigationView {
            ScrollView{
                Divider()
                    .padding(.horizontal)
                UserInfo(isUserEditShown: $isUserEditShown)
                    .padding(.bottom, 5)
                Divider()
                    .padding(.horizontal)
                HStack {
                    Text("Seguiment diari")
                        .font(.title3.bold())
                    Spacer()
                }
                .padding([.leading, .bottom])
                
                VStack{
                    ForEach (nutrients) {nutrient in
                        let registrosForThatType = registers.filter{registro in
                            return registro.type == nutrient.name
                        }
                        
                        let registrosForThatTypeAndDay = registrosForThatType.filter{registro in
                            return Calendar.current.component(.day, from : registro.time!) == Calendar.current.component(.day, from : Date())
                        }
                        
                        NavigationLink (destination: registerList(type: nutrient)) {
                        
                            itemLabel(nutrient: nutrient, itemName: nutrient.name, consumed: Int(calculateTotalOfDay(registros: registrosForThatTypeAndDay)), metric: nutrient.mesurementType)
                            
                            
                                .frame(width: 400, height: 150)
                                .padding(.top, 10)
                                .padding(.bottom, -9.0)
                                .padding(.bottom, 9.0)
                            .padding(.top, -20)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    
                }

                
                Spacer(minLength: 60)
            }
            .navigationTitle("La meva nutrició")
         
        }
    }
}

struct heading: View {
    var text : String
    var body: some View{
        Divider()
            .padding(.horizontal)
            .padding(.top, -35.0)
        HStack {
            Text(text)
                .font(.title3.bold())
            Spacer()
        }
        .padding(.leading)
        .padding(.top, -25.0)
    }
}



struct DietPage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DietPage()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            Text("\(DietPage().ordenatPer.rawValue)")
        }
        
    }
}
