//
//  TransactionDetail.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import SwiftUI

struct TransactionDetail: View {
    @Binding var transaction: Transaction
    @ObservedObject var transactionData: TransactionModel
    @Environment(\.dismiss) private var dismiss
    @State var paymentTypeArray = ["Income", "Expense"]
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        
        return formatter
    }()
    var body: some View {
        Form {
            TextField("Enter amount", value: self.$transaction.amount, formatter: formatter)
                .keyboardType(.numberPad)
                .font(.title)
                .multilineTextAlignment(.center)
                .foregroundColor(self.transaction.type == 0 ? .green : .black)
            
            Section {
                Picker(selection: self.$transaction.type, label: Text("Select Transaction Type")) {
                    ForEach(0..<paymentTypeArray.count) {
                        Text(paymentTypeArray[$0])
                    }
                }
            }
            
            Section {
                Text("Description")
                TextField("Enter Description", text: self.$transaction.description)
            }
            
            Section {
                DatePicker("Date", selection: self.$transaction.date, displayedComponents: .date)
            }
            
            Section {
                Text("Category")
                TextField("Enter Category", text: self.$transaction.category)
            }
            
            Section {
                Text("Notes")
                TextField("Enter Note", text: self.$transaction.notes)
            }
            
        }
        .navigationTitle("Transaction Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            transactionData.sortSections()
            dismiss()
        }){
            HStack (spacing: 5){
                Image(systemName: "chevron.left")
                Text("Back")
                    .font(.headline)
            }
        })
    }
}

struct TransactionDetail_Previews: PreviewProvider {
    @State static var testTransaction = Transaction(type: 0, date: Date.now, description: "Porter's Paycheck", category: "Direct Deposit", notes: "First of the month", amount: 400)
    static var previews: some View {
        TransactionDetail(transaction: $testTransaction, transactionData: TransactionModel())
    }
}
