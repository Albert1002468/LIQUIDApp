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
    let paymentTypeArray = ["Income", "Expense"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("Light Rain")
                    .resizable()
                    .ignoresSafeArea()
                
                List (transactionData.filteredSections) { section in
                    Section(header: Text(transactionData.formatDate(date: section.date))
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.black)
                                .textCase(nil)) {
                        ForEach(section.transactionsOfMonth) { transaction in
                            NavigationLink(destination: TransactionDetail(transaction: transactionData.sections[getSectionIndex(sectID: section.id)].transactionsOfMonth[getTransactionIndex(sectID: section.id, transID: transaction.id)], transactionData: transactionData, amount: String(Int(transaction.amount*100)), type: transaction.type, date: section.date, cat: transaction.category, note: transaction.notes, desc: transaction.description, searchText: searchText, savings: transaction.saving, typeIndex: findTransactionType(type: transaction.type), category: transaction.category)
                            ) {
                                TransactionRow(transaction: transaction)
                            }
                            //  .listRowInsets(.init(top: 5, leading: 25, bottom: 5, trailing: 0))
                            // .padding(.horizontal, 40)
                            
                        }
                        .listRowBackground(Color.white.opacity(0.8))
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("All Transactions")
            .navigationBarTitleDisplayMode(.inline)
            .keyboardType(.alphabet)
            .disableAutocorrection(true)
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
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationViewStyle(.stack)
        .onChange(of: searchText) { searchText in
            transactionData.filterSections(searchText: searchText)
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
