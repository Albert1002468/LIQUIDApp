//
//  ContentView.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection = 2
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color("AccentColor"), Color(UIColor.systemBackground)]), startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea()
            TabView(selection: $selection){
                JournalTab()
                    .tabItem {
                        Text("Journal")
                        Image(systemName: "book.fill")
                    }.tag(1)
                HomeTab()
                    .tabItem {
                        Text("Home")
                        Image(systemName: "house.fill")
                    }.tag(2)
                SettingsTab()
                    .tabItem {
                        Text("Settings")
                        Image(systemName: "gearshape.fill")
                    }.tag(3)
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
