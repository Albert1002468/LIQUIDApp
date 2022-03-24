//
//  JournalTab.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import SwiftUI

struct JournalTab: View {
    @ObservedObject var transactionData: TransactionModel
    @State private var openAddTransactions = false
    @State private var searchText = ""
    @State var paymentTypeArray = ["Income", "Expense"]
    
    var body: some View {
        NavigationView {
            List (transactionData.filteredSections) { section in
                Section(header: Text(transactionData.formatDate(date: section.date, type: ""))) {
                    ForEach(section.transactionsOfMonth) { transaction in
                        NavigationLink(destination: TransactionDetail(transaction: transactionData.sections[getSectionIndex(sectID: section.id)].transactionsOfMonth[getTransactionIndex(sectID: section.id, transID: transaction.id)], transactionData: transactionData, amount: Double(transaction.amount) ?? 0.0, type: transaction.type, date: transaction.date, cat: transaction.category, note: transaction.notes, desc: transaction.description, searchText: searchText, typeIndex: findTransactionType(type: transaction.type), category: transaction.category)
                        ) {
                            TransactionRow(transaction: transaction)
                        }
                        //  .listRowInsets(.init(top: 5, leading: 25, bottom: 5, trailing: 0))
                        // .padding(.horizontal, 40)
                        
                        //.listRowSeparator(.hidden)
                    }
                    .listRowBackground(Color.white.opacity(0.9))
                }
            }
            .background (
            Image("Light Rain")
                .resizable()
                .ignoresSafeArea())
            .navigationTitle("All Transactions")
            .searchable(text: $searchText)
            .onChange(of: searchText) { searchText in
                transactionData.filterSections(searchText: searchText)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.openAddTransactions.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }.sheet(isPresented: $openAddTransactions, content: {
                        AddTransaction(transactionData: transactionData)
                    } )
                }
            }
        }
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = UIColor(Color.clear.opacity(0.2))
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance

        }
    }
    
    func findTransactionType(type: String) -> Int {
        if type == "Income" {
            return 0
        }
        return 1
    }
    
    func getSectionIndex(sectID: String) -> Int {
        if let sectionIndex = transactionData.sections.firstIndex(where: { $0.id.uuidString == sectID}) {
            return sectionIndex
        }
        return -1
    }
    
    func getTransactionIndex(sectID: String, transID: String) -> Int {
        if let transactionIndex = transactionData.sections[getSectionIndex(sectID: sectID)].transactionsOfMonth.firstIndex(where: { $0.id.uuidString == transID}) {
            return transactionIndex
        }
        return -1
    }
    
}

struct JournalTab_Previews: PreviewProvider {
    static var previews: some View {
        JournalTab(transactionData: TransactionModel())
    }
}
