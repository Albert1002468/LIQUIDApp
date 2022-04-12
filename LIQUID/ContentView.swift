//
//  ContentView.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import SwiftUI

enum Tabs: String {
    case journal
    case home
    case settings
}

struct ContentView: View {
    @ObservedObject var transactionData = TransactionModel()
    @State private var selection: Tabs = .home
    
    var body: some View {
        TabView(selection: $selection) {
            JournalTab(transactionData: transactionData)
                .tabItem {
                    Text("Journal")
                    Image(systemName: "book.fill")
                }.tag(Tabs.journal)
            HomeTab(transactionData: transactionData)
                .tabItem {
                    Text("Home")
                    Image(systemName: "house.fill")
                }.tag(Tabs.home)
            SettingsTab()
                .tabItem {
                    Text("Settings")
                    Image(systemName: "gearshape.fill")
                }.tag(Tabs.settings)
        }

        .onAppear {
            UITableView.appearance().backgroundColor = UIColor.clear

            let appearance = UINavigationBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = UIColor(Color.clear.opacity(0.2))
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().standardAppearance = appearance
            
            let tabAppearance = UITabBarAppearance()
            tabAppearance.backgroundEffect = UIBlurEffect(style: .systemThickMaterial)
            tabAppearance.backgroundColor = UIColor(Color.clear.opacity(0.2))
            UITabBar.appearance().standardAppearance = tabAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
