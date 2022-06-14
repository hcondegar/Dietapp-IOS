//
//  totalLabel.swift
//  PRStuff
//
//  Created by Hans Capapey sierra on 4/6/22.
//

import SwiftUI
import Foundation


struct totalLabel: View {
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(sortDescriptors: [])
    var users: FetchedResults <Usuario>
    
    var consumed : Float
    var nutrient : NutrientType
    var typeOfMesurement : String
    
    func ratio () -> Float {
        return consumed * 100 / getRecomended(nutrient: nutrient)
    }
    
    func offSetBar () -> CGFloat{
        
        if (ratio() > 200) {
             return  200 * 120 / 100 - 120
        }else{
            return CGFloat(ratio() * 120 / 100 - 120)
        }
    }

    
    var body: some View {
        
        
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
           
                .foregroundColor(colorScheme == .light ? .primary : .gray.opacity(0.4))
                .colorInvert()
                .padding(.horizontal, 10.0)
                .frame(height: 100)
                .padding(.bottom, 5.0)
                
                
                .shadow(color: .primary.opacity(0.1), radius: 20, x: 0, y: 10)
                
                
            VStack {
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 250, height: 10)
                        .foregroundColor(ratio() < 90 ? .orange : .accentColor)
                        .opacity(0.4)
                    Circle()
                        .frame(width: 15, height: 15)
                        .foregroundColor(ratio() < 90 ? .orange : .accentColor)
                        .shadow(color: ratio() < 90 ? .orange.opacity(0.4) : .accentColor.opacity(0.4), radius: 10, x: 0, y: 0)
                        .offset(x: offSetBar())
                    
                    Text("\(Image(systemName: "arrowtriangle.down.fill"))")
                        .foregroundColor(.primary)
                        .offset(y:-17)
                        .font(.caption)
                }
                
                let recomendedText = String(format: "%.2f", getRecomended(nutrient: nutrient))
                let consumedText = String(format: "%.2f", consumed)
                
                
                Text("\(consumedText)  de  \(recomendedText) \(typeOfMesurement)")
                    .foregroundColor(ratio() < 90 ? .orange : .accentColor)
                    .padding(.top, 5.0)
            }
            .offset(y: 7)
            
        }.padding(.vertical, 3.0)
            .padding(.horizontal, 5.0)
    }
    
    func getRecomended (nutrient: NutrientType) -> Float{
        let user = users[0]
        var caloriesPerConsumir : Float = 0
        
        if user.gender == 0 {
            caloriesPerConsumir = 665 + (9.5 * Float(user.weight))
            caloriesPerConsumir = caloriesPerConsumir + (1.8 * Float(user.height))
            caloriesPerConsumir = caloriesPerConsumir - (4.6 * Float(user.age))
        }else {
            caloriesPerConsumir = 66.4 + (13.75 * Float(user.weight))
            caloriesPerConsumir = caloriesPerConsumir + (5 * Float(user.height))
            caloriesPerConsumir = caloriesPerConsumir - (6.7 * Float(user.age))
        }
        
        if (user.sport == 0) {
            caloriesPerConsumir = caloriesPerConsumir * 1.2
        }else if (user.sport == 1){
            caloriesPerConsumir = caloriesPerConsumir * 1.375
        }else if (user.sport == 2){
            caloriesPerConsumir = caloriesPerConsumir * 1.55
        }else if (user.sport == 3){
            caloriesPerConsumir = caloriesPerConsumir * 1.9
        }
        
        if (nutrient.name == "Proteïnes") {
            return caloriesPerConsumir * 0.9 / 4
        }else if (nutrient.name == "Hidrats de carboni"){
            return caloriesPerConsumir * 0.3 / 4
        }else if (nutrient.name == "Lípids"){
            return caloriesPerConsumir * 0.3 / 9
        }else if (nutrient.name == "Calci"){
            if (user.age > 13){
                if user.age > 18{
                    if user.age > 50{
                        if user.age > 70{
                            return 1200
                        }else{
                            if (user.gender == 0){
                                return 1200
                            }else{
                                return 1000
                            }
                        }

                    }else{
                        return 1000
                    }

                }else{
                    return 1300
                }

            }else{
                return 1300
            }
        }else if (nutrient.name == "Fibra"){
            return 30
        }else if (nutrient.name == "Ferro"){
            if (user.age > 13){
                if (user.age > 18){
                    if (user.age > 50){
                        return 8
                    }else{
                        if (user.gender == 0){
                            return 18
                        }else {
                            return 8
                        }
                    }
                }else{
                    if (user.gender == 0){
                        return 15
                    }else {
                        return 8
                    }
                }
            }else{
                return 8
            }
        }else {
            return caloriesPerConsumir
        }
    }
    
}



struct totalLabel_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
