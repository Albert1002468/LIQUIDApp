//
//  ContentView.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var transactionData = TransactionModel()
    @State private var selection = 2

    var body: some View {
            TabView(selection: $selection){
                JournalTab(transactionData: transactionData)
                    .tabItem {
                        Text("Journal")
                        Image(systemName: "book.fill")
                    }.tag(1)
                HomeTab(transactionData: transactionData)
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
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
                appearance.backgroundColor = UIColor(Color.clear.opacity(0.2))
                
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.portrait)
    }
}
