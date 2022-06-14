 //
//  TabView.swift
//  PRStuff
//
//  Created by Hans Capapey sierra on 16/4/22.
//

import SwiftUI

struct Tab : Hashable {
    var name : String
    var icon : String
}

struct Tab_View: View {
    @Environment(\.colorScheme) var colorScheme
    
    let tabs : [Tab] = [Tab(name:"Nutrició", icon:"leaf.fill"), Tab(name: "Llistat", icon: "list.dash")]
    
    @State var selectedTab : String = "Nutrició"
 
    @State var addSheetShown = false
 
    
    var body: some View {
        ZStack {
            if selectedTab == "Nutrició"{
                DietPage()
            }else if selectedTab == "Llistat"{
                ListView()
            }
            
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .frame(height: 90)
                        .ignoresSafeArea()
                        .offset(y: 5)
                        .foregroundColor(.black)
                        
                    
                    RoundedRectangle(cornerRadius: 30)
                        .frame(height: 90)
                        .ignoresSafeArea()
                        .offset(y: 5)
                        .foregroundColor(colorScheme == .light ? .primary : .gray.opacity(0.5))
                        .colorInvert()
                        .shadow(color: Color.primary.opacity(0.3), radius: 30, x: 11, y: 10)
                    
                    HStack {
                        HStack{
                            Spacer()
                            TabButton(selectedTab: $selectedTab, tab: tabs[0])
                            
                            Spacer(minLength: 50)
                            TabButton(selectedTab: $selectedTab, tab: tabs[1])
                            
                            Spacer()
                            
                        }
                        .padding(.bottom, 10)
                        
                        
                        
                        .clipped()
                        .cornerRadius(30)
                        
                        
                        Spacer(minLength: 0)
                        
                    }
                    
                    Button{
                        addSheetShown.toggle()
                    }label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.title2.bold())
                        
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 30.0)
                    .padding(.vertical, 21.0)
                    
                    .background(Color.accentColor)
                    
                    .clipShape(Circle())
                    .offset(y: -26)
                    
                    .shadow(color: Color.primary.opacity(0.2), radius: 20, x: 0, y: 2)
                    
                    
                }
                
            }
        }.ignoresSafeArea()
            .sheet(isPresented: $addSheetShown){
                addSheet(isShown:$addSheetShown)
            }
        
    }
}

struct TabButton: View {
    @Binding var selectedTab : String
    var tab : Tab
    
    var body: some View {
            Spacer()
        
        ZStack {
            
            ZStack {
               
//                Circle()
//                    .background(Color.accentColor)
//                    .frame(width: 50.0, height: 50.0)
//                    .blur(radius: 30)
//                    .opacity( selectedTab == tab.name ? 0.4 : 0)
                
                Button {
                        selectedTab = tab.name
                    }label: {
                        Spacer()
                        VStack {
                            Image(systemName: tab.icon)
                                .padding(.bottom, -2.0)
                                .frame(width: 1.0, height: 21.0)
                            Text (tab.name)
                                .font(.caption.bold())
                            
                        }
                        .foregroundColor(selectedTab == tab.name ? Color.accentColor : Color.secondary)
                        //                        .foregroundStyle(Color.white)
                        .padding(.all, 12.0)
                        
                        
                        Spacer()
                    }
                    .buttonStyle(.plain)
            }
        }.padding(.bottom, 10.0)
            
    }
}

struct Tab_View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Tab_View()
        }
    }
}
