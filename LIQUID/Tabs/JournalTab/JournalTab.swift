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
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<TransactionData.sections.count, id:\.self) { sectionIndex in
                    Section(header: Text(TransactionData.sections[sectionIndex].formatDate(date: TransactionData.sections[sectionIndex].date, type: "monthyear"))) {
                        ForEach($TransactionData.sections[sectionIndex].transactionsOfMonth) { $transaction in
                            NavigationLink(destination: TransactionDetail(transaction: $transaction, transactionData: TransactionData)) {
                                TransactionRow(transaction: transaction)
                            }
                        }.onDelete { row in
                            self.removeRows(section: sectionIndex, row: row)
                        }
                    }
                }
            }.listStyle(.automatic)
                .navigationBarTitle(Text("All Transactions"))
                .navigationBarItems (leading: Button(action: {}) {
                    Image(systemName: "list.bullet")
                }, trailing: Button(action: {
                    self.openAddTransactions.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                }.sheet(isPresented: $openAddTransactions, content: {
                    AddTransaction(transactionData: TransactionData)
                } ))
            
        }
    }
    func removeRows(section: Int, row: IndexSet) {
        if TransactionData.sections[section].transactionsOfMonth.count == 1
        {
            TransactionData.sections.remove(at: section)
        }
        else {
            TransactionData.sections[section].transactionsOfMonth.remove(atOffsets: row)
        }
    }
}

struct JournalTab_Previews: PreviewProvider {
    static var previews: some View {
        JournalTab()
    }
}
