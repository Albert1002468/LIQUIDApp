//
//  TransactionDetail.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import SwiftUI

struct TransactionDetail: View {
    @State var transaction: Transaction
    @ObservedObject var transactionData: TransactionModel
    @Environment(\.dismiss) private var dismiss
    @State var paymentTypeArray = ["Income", "Expense"]
    @State var amount: Double
    @State var type: String
    @State var date: Date
    @State var cat: String
    @State var note: String
    @State var desc: String
    @State var searchText: String
    @State var typeIndex: Int
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        
        return formatter
    }()
    var body: some View {
        Form {
            TextField("Enter amount", value: $amount, formatter: formatter)
                .keyboardType(.numberPad)
                .font(.title)
                .multilineTextAlignment(.center)
                .foregroundColor(typeIndex == 0 ? .green : .black)
            
            Section {
                Picker(selection: $typeIndex, label: Text("Select Transaction Type")) {
                    ForEach(0..<paymentTypeArray.count) {
                        Text(paymentTypeArray[$0])
                    }
                }
            }
            
            Section {
                Text("Description")
                TextField("Enter Description", text: $desc)
            }
            
            Section {
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            
            Section {
                Text("Category")
                TextField("Enter Category", text: $cat)
            }
            
            Section {
                Text("Notes")
                TextField("Enter Note", text: $note)
            }
            
            Button("Permanently Delete") {
                deleteTransaction()
                //added this
                transactionData.filterSections(searchText: searchText)
                dismiss()
            }
            
            
        }
        .navigationTitle("Transaction Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            UpdateTransaction()
            transactionData.sortSections()
                //added this
            transactionData.filterSections(searchText: searchText)
            dismiss()
        }){
            HStack (spacing: 5){
                Image(systemName: "chevron.left")
                Text("Back")
                    .font(.headline)
            }
        })
    }
    func UpdateTransaction() {
        
        var index = 0
        var found = false
        if (typeIndex != 0) {
            type = "Expense"
        }
        else {
            type = "Income"
        }
        let singleTransaction = Transaction(type: type, date: date, description: desc, category: cat, notes: note, amount: amount)
        if transaction.formatDate(date: date) != transaction.formatDate(date: transaction.date) {
            for arrayDate in transactionData.sections
            {
                if transaction.formatDate(date: arrayDate.date) == transaction.formatDate(date: date) {
                    found = true
                    break
                }
                index += 1
            }
            if found == true {
                transactionData.sections[index].transactionsOfMonth.append(singleTransaction)
                deleteTransaction()
            }
            else {
                transactionData.sections.append(Day(date: date, transactionsOfMonth: [singleTransaction]))
                deleteTransaction()
            }
        }
        else {
            transactionData.sections[getSectionIndex()].transactionsOfMonth.append(singleTransaction)
            deleteTransaction()
        }
    }
    
    func getSectionIndex() -> Int {
        if let sectionIndex = transactionData.sections.firstIndex(where: {transaction.formatDate(date: $0.date) == transaction.formatDate(date: transaction.date)}) {
            return sectionIndex
        }
        return -1
    }
    
    func getTransactionIndex() -> Int {
        if let transactionIndex = transactionData.sections[getSectionIndex()].transactionsOfMonth.firstIndex(where: { $0.id == transaction.id}) {
            return transactionIndex
        }
        return -1
    }
    
    func deleteTransaction() {
        if (transactionData.sections[getSectionIndex()].transactionsOfMonth.count == 1)
        {
            transactionData.sections.remove(at: getSectionIndex())
        }
        else {
            transactionData.sections[getSectionIndex()].transactionsOfMonth.remove(at: getTransactionIndex())
            
        }
    }
}

struct TransactionDetail_Previews: PreviewProvider {
    @State static var testTransaction = Transaction(type: "Income", date: Date.now, description: "Porter's Paycheck", category: "Direct Deposit", notes: "First of the month", amount: 400)
    static var previews: some View {
        TransactionDetail(transaction: testTransaction, transactionData: TransactionModel(), amount: testTransaction.amount, type: testTransaction.type, date: testTransaction.date, cat: testTransaction.category, note: testTransaction.notes, desc: testTransaction.description, searchText: "", typeIndex: 0)
    }
}
