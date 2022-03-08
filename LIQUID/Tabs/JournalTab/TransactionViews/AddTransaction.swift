//
//  AddTransaction.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import SwiftUI

struct AddTransaction: View {
    @ObservedObject var transactionData: TransactionModel
    @Environment(\.dismiss) private var dismiss
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        
        return formatter
    }()
    @State var paymentTypeArray = ["Income", "Expense"]
    @State var amount = 0.0
    @State var type = 0
    @State var date = Date.now
    @State var cat = ""
    @State var note = ""
    @State var desc = ""
    var body: some View {
        NavigationView {
            Form {
                TextField("Enter amount", value: self.$amount, formatter: formatter)
                    .keyboardType(.numberPad)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(type == 0 ? .green : .black)
                
                Section {
                    Picker(selection: self.$type, label: Text("Select Transaction Type")) {
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
                
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Save") {
                    AddNewTransaction(transaction: transactionData)
                    transactionData.sortSections()
                    dismiss()
                }
            }
        }
    }
    
    func AddNewTransaction(transaction: TransactionModel) {

        var index = 0
        var found = false
        for arrayDate in transaction.sections
        {
            if arrayDate.formatDate(date: arrayDate.date, type: "monthyear") == arrayDate.formatDate(date: date, type: "monthyear") {
             found = true
        break
        }
        index += 1
        }
        let singleTransaction = Transaction(type: type, date: date, description: desc, category: cat, notes: note, amount: amount)
        if found == true {
        transaction.sections[index].transactionsOfMonth.append(singleTransaction)
        }
        else {
            transaction.sections.append(Day(date: date, transactionsOfMonth: [singleTransaction]))
        }
    }
}

struct AddTransaction_Previews: PreviewProvider {
    static var previews: some View {
        AddTransaction(transactionData: TransactionModel())
    }
}
