//
//  WelcomeView.swift
//  PRStuff
//
//  Created by Hans Capapey sierra on 8/6/22.
//

import SwiftUI
import LocalAuthentication

struct WelcomeView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(sortDescriptors: [])
    var users: FetchedResults <Usuario>
    
    @State public var isUnlocked = false
    
    var body: some View {
        
        if (users.count == 0){
            
            NavigationView() {
                VStack() {
                    Image("Icon")
                        .resizable()
                        .frame(width: 90, height: 90)
                        .cornerRadius(21)
                        .padding(.bottom)
                    
                    HStack(){
                        Text("Benvingut a")
                            .font(.largeTitle.bold())
                        Text("Dietapp!")
                            .font(.largeTitle.bold())
                            .foregroundColor(.accentColor)
                    }
                    
                    Item(title: "Registre semanal", description: "Segueix la teva alimentació diària i compara-la amb la resta dels dies.", icon: "square.text.square.fill")
                        .padding(.top)
                    Item(title: "Privacitat", description: "Almacenatge i processament de dades On-device. Res surt del teu dispositiu.", icon: "person.badge.shield.checkmark.fill")
                    
                    Item(title: "Adaptat a tu", description: "Valors recomanats basats en el teu estat físic.", icon: "face.smiling.fill")
                    
                    
                        .padding(.bottom, 60)
                    
                    NavigationLink(destination: SetupView()){
                        Text("Configurar")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 30)
                            .font(.body.bold())
                        
                    }
                    .buttonStyle(.borderedProminent)
                }
                
            }
            
            
        }else{
            if isUnlocked {
                Tab_View()
            } else {
                Button {
                    authenticate()
                }label:{
                    Text("\(Image(systemName: "lock.fill")) Desbloquejar")
                }
                .buttonStyle(.plain)
                .foregroundColor(.accentColor)
                .padding(.all, 5)
                .padding(.horizontal, 10)
                .background(Color.accentColor.opacity(0.1))
                .cornerRadius(15)
                
            }
        }
        
    }
    
    func authenticate () {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Autentica't per accedir a DietApp"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){ success,
                authenticationError in
                if success {
                    Task {@MainActor in
                            self.isUnlocked = true
                    }
                    
                }else{
                    //error
                }
            }
        }else{
            //no biometrics
        }
    }
    
        
}



struct Item : View {
    let title : String
    let description : String
    let icon : String
    
    var body: some View{
        HStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 40, height: 40)
                .padding(.leading, 30)
                .padding(.top)
                .padding(.trailing)
                .foregroundColor(.accentColor)
            
            
            VStack {
                Text(title)
                    .font(.title3.bold())
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        
       
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(ModelData())
    }
}
