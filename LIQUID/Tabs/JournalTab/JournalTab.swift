//
//  JournalTab.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import SwiftUI

struct JournalTab: View {
    @ObservedObject var TransactionData = TransactionModel()
    @State private var openAddTransactions = false
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            List {
                ForEach (TransactionData.filteredSections) { section in
                    Section(header: Text(TransactionData.formatDate(date: section.date, type: ""))) {
                        ForEach(section.transactionsOfMonth) { transaction in
                            NavigationLink(destination: TransactionDetail(transaction: TransactionData.sections[getSectionIndex(sectID: section.id)].transactionsOfMonth[getTransactionIndex(sectID: section.id, transID: transaction.id)], transactionData: TransactionData, amount: Double(transaction.amount) ?? 0.0, type: transaction.type, date: transaction.date, cat: transaction.category, note: transaction.notes, desc: transaction.description, searchText: searchText, typeIndex: findTransactionType(type: transaction.type))) {
                                TransactionRow(transaction: transaction)
                            }
                        }
                    }
                }
            }.navigationBarTitle(Text("All Transactions"))
                .searchable(text: $searchText)
                .onChange(of: searchText) { searchText in
                    TransactionData.filterSections(searchText: searchText)
                }
                .navigationBarItems (trailing: Button(action: {
                    self.openAddTransactions.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                }.sheet(isPresented: $openAddTransactions, content: {
                    AddTransaction(transactionData: TransactionData)
                } ))
        }
    }
    func findTransactionType(type: String) -> Int {
        if type == "Income" {
            return 0
        }
        return 1
    }
    func getSectionIndex(sectID: String) -> Int {
        if let sectionIndex = TransactionData.sections.firstIndex(where: { $0.id.uuidString == sectID}) {
            return sectionIndex
        }
        return -1
    }
    
    func getTransactionIndex(sectID: String, transID: String) -> Int {
        if let transactionIndex = TransactionData.sections[getSectionIndex(sectID: sectID)].transactionsOfMonth.firstIndex(where: { $0.id.uuidString == transID}) {
            return transactionIndex
        }
        return -1
    }
    
}

struct JournalTab_Previews: PreviewProvider {
    static var previews: some View {
        JournalTab()
    }
}
