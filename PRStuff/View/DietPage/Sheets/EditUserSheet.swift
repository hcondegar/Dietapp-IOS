//
//  EditUserSheet.swift
//  PRStuff
//
//  Created by Hans Capapey sierra on 8/6/22.
//

import SwiftUI

struct EditUserSheet: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    var users: FetchedResults <Usuario>
    
    
    @Binding var isShown : Bool
    
    @State var altura = ""
    @State var pes = ""
    @State var genere = 0
    @State var nom = ""
    @State var edat = ""
    @State var esport = 0
    @State var warningShown = false
    
    let genders = ["Dona", "Home"]
    let esports = ["Res","Poc", "Moderat", "Molt"]
    
    var body: some View {
        NavigationView {
            Form{
                
                Section(){
                    HStack{
                        Text("\(Image(systemName: "rectangle.and.pencil.and.ellipsis"))  Nom")
                        TextField("...", text: $nom)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                    Picker(selection: $genere, label:
                            Text("\(Image(systemName: "figure.arms.open"))  Gènere")) {
                        Text("Dona").tag(0)
                        Text("Home").tag(1)
                    }
                                
                
                
                Section() {
                    HStack{
                        Text("\(Image(systemName: "arrow.up.and.down"))  Altura")
                        TextField("0", text: $altura)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                        Text("cm")
                    }
                    
                    HStack{
                        Text("\(Image(systemName: "scalemass"))  Pes")
                        TextField("0", text: $pes)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                        Text("kg")
                    }
                }
                
                HStack{
                    Text("\(Image(systemName: "clock.arrow.circlepath"))  Edat")
                    TextField("0", text: $edat)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                    Text("anys")
                }
                
                Section {
                    Picker(selection: $esport, label:
                            Text("\(Image(systemName: "flame"))  Exercici")) {
                        Text("Res").tag(0)
                        Text("Poc").tag(1)
                        Text("Moderat").tag(2)
                        Text("Molt").tag(3)
                    }
                }
                
                Section{
                    HStack {
                        Spacer()
                        Button{
                            if (nom != ""){
                                addItem()
                                deleteRegister()
                                isShown = false
                            }else{
                                warningShown = true
                            }
                        }label: {
                            Text ("Guardar canvis")
                            
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
                
            }
            
            .alert(isPresented: $warningShown) { // 4

                        Alert(
                            title: Text("Nom no vàlid"),
                            message: Text("Afegeix un nom"),
                            dismissButton: .destructive(Text("D'acord"), action: {
                                })
                        )
                    }
            
            .navigationBarTitle("Editar dades personals")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
     private func deleteRegister (){
         viewContext.delete(users[1])
         
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func addItem() {
         let genderNom = genders[$genere.wrappedValue]
        let exerciciNom = esports[$esport.wrappedValue]
        
        let user = Usuario(context: viewContext)
            user.name = nom
        user.age = Int64(edat) ?? 0
            user.weight = Int64(pes) ?? 0
            user.height = Int64(altura) ?? 0
        user.gender = Int64(genere)
            user.genderName = genderNom
        user.sportName = exerciciNom
        user.sport = Int64(esport)

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

    }
}



struct EditUserSheet_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
