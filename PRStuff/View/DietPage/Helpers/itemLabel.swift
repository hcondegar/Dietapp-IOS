//
//  itemLabel.swift
//  PRStuff
//
//  Created by Hans Capapey sierra on 19/5/22.
//

import SwiftUI

struct itemLabel: View {
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(sortDescriptors: [])
    var users: FetchedResults <Usuario>
    
    var nutrient : NutrientType
    var itemName : String
    var consumed : Int
    var metric : String
    
    func ratio () -> Float {
        return Float(consumed) * 100 / Float(getRecomended(nutrient: nutrient))
    }
    
    func offSetBar () -> Float{
        
        if (ratio() > 200) {
             return  200 * 120 / 100 - 120
        }else{
            return ratio() * 120 / 100 - 120
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 13)
                .foregroundColor(colorScheme == .light ? .primary : .gray.opacity(0.4))
                .colorInvert()
                .padding(.horizontal, 20.0)
                .frame(height: 100)
                .offset(y: -15)
                .padding(.top, 25.0)
            
            
                .shadow(color: colorScheme == .light ? Color.primary.opacity(0.2) : .primary.opacity(0) , radius: 40, x: 5, y: 0)
            
            
            VStack {
                HStack {
                    Image(systemName: ratio() < 90 ? "exclamationmark.triangle.fill" :  "checkmark.circle.fill")
                    
                        .padding(.leading, 23.0)
                        .offset(x: -10, y: -0.7)
                    
                    Spacer()
                    Text("\(itemName) ")
                        .padding(.bottom, 16.0)
                        .offset(x: -4, y: 7.5)
                    
                    Spacer()
                    
                    Image(systemName:  "chevron.forward")
                    
                        .padding(.trailing, 23.0)
                        .offset(x: 10, y: -0.7)
                    
                    
                    
                }   .font(.subheadline.bold())
                
                    .foregroundColor((ratio() < 90 ? .white : .white))
                    .background(ratio() < 90 ? .orange : .accentColor)
                    .offset(y: -5)
                
                    .frame( height: 45)
                    .cornerRadius(13)
                    .padding(.horizontal, 10.0)
                    .offset(y: -20)
                    .padding(.horizontal, 10.0)
                
                
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 250, height: 10)
                        .foregroundColor(ratio() < 90 ? .orange : .accentColor)
                        .opacity(0.4)
                    Circle()
                        .frame(width: 15, height: 15)
                        .foregroundColor(ratio() < 90 ? .orange : .accentColor)
                        .shadow(color: ratio() < 90 ? .orange.opacity(0.4) : .accentColor.opacity(0.4), radius: 10, x: 0, y: 0)
                        .offset(x: CGFloat(offSetBar()))
                    
                    Text("\(Image(systemName: "arrowtriangle.down.fill"))")
                        .foregroundColor(.primary)
                        .offset(y:-17)
                        .font(.caption)
                }
                .offset(y:-10)
                
                let recomendedText = String(format: "%.2f", getRecomended(nutrient: nutrient))
                
                Text("\(consumed) de \(recomendedText) \(metric)")
                    .foregroundColor(ratio() < 90 ? .orange : .accentColor)
                    .offset(y:-10)
            }
            
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

struct itemLabel_Previews: PreviewProvider {
    static var previews: some View {
        Tab_View()
        
    }
}
