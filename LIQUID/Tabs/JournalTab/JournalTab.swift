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
            ZStack {
                Color.blue
                    .opacity(0.1)
                    .ignoresSafeArea()
                
                VStack {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 10)
                        .background(LinearGradient(colors: [.green.opacity(0.3), .blue.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    List {
                        ForEach (transactionData.filteredSections) { section in
                            Section(header: Text(transactionData.formatDate(date: section.date, type: ""))) {
                                ForEach(section.transactionsOfMonth) { transaction in
                                    NavigationLink(destination: TransactionDetail(transaction: transactionData.sections[getSectionIndex(sectID: section.id)].transactionsOfMonth[getTransactionIndex(sectID: section.id, transID: transaction.id)], transactionData: transactionData, amount: Double(transaction.amount) ?? 0.0, type: transaction.type, date: transaction.date, cat: transaction.category, note: transaction.notes, desc: transaction.description, searchText: searchText, typeIndex: findTransactionType(type: transaction.type), categoryIndex: findCategory(type: transaction.type, category: transaction.category))) {
                                        TransactionRow(transaction: transaction)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationViewStyle(.automatic)
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
        }
    }
    
    func findTransactionType(type: String) -> Int {
        if type == "Income" {
            return 0
        }
        return 1
    }
    
    func findCategory(type: String, category: String) -> Int {
        var currentIndex = 0
        if type == "Income" {
            for incomeCategory in transactionData.categoryIncomeArray
            {
                if incomeCategory == category {
                    return currentIndex
                }
                currentIndex += 1
            }
            return 0
        }
        
        else {
            for expenseCategory in transactionData.categoryExpenseArray
            {
                if expenseCategory == category {
                    return currentIndex
                }
                currentIndex += 1
            }
            return 0
        }
        
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
