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
    @Environment(\.colorScheme) var colorScheme
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        
        return formatter
    }()
    @State var paymentTypeArray = ["Income", "Expense"]
    @State var amount = 0.0
    @State var type = "Income"
    @State var date = Date.now
    @State var cat = ""
    @State var note = ""
    @State var desc = ""
    @State var typeIndex = 0
    @State var category = ""
    var body: some View {
        NavigationView {
            ZStack {
                if colorScheme == .dark {
                    Color.black.ignoresSafeArea()
                }
                
                Form {
                    if (typeIndex == 0) {
                        TextField("Enter amount", value: $amount, formatter: formatter)
                            .keyboardType(.decimalPad)
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.green)
                    } else {
                        TextField("Enter amount", value: $amount, formatter: formatter)
                            .keyboardType(.decimalPad)
                            .font(.title)
                            .multilineTextAlignment(.center)
                    }
                    
                    Section {
                        Picker(selection: $typeIndex, label: Text("Select Transaction Type")) {
                            ForEach(0..<paymentTypeArray.count) {
                                Text(paymentTypeArray[$0])
                            }
                        }.onChange(of: typeIndex) { _ in
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
                        NavigationLink(destination: Category(transactionData: transactionData, typeIndex: typeIndex, category: $category)) {
                            if (typeIndex == 0) {
                                HStack {
                                    Text("Select Income Category")
                                    Spacer()
                                    if (transactionData.categoryIncomeArray.contains(category)) {
                                        Text(category)
                                            .foregroundColor(.gray)
                                    } else {
                                        Text(transactionData.categoryIncomeArray[0])
                                    }
                                }
                            } else {
                                HStack {
                                    Text("Select Expense Category")
                                    Spacer()
                                    if (transactionData.categoryExpenseArray.contains(category)) {
                                        Text(category)
                                            .foregroundColor(.gray)
                                    } else {
                                        Text(transactionData.categoryExpenseArray[0])
                                    }
                                }
                            }
                        }
                    }
                    
                    Section {
                        Text("Notes")
                        TextField("Enter Note", text: $note)
                    }
                    
                    
                }
                .navigationTitle("Add Transaction")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button(action: {
                        AddNewTransaction()
                        transactionData.sortSections()
                        transactionData.filterSections(searchText: "")
                        dismiss()
                    }) {
                        Text("Save")
                    }.disabled(desc.isEmpty)
                }
            }
        }
    }
    
    func AddNewTransaction() {
        
        var index = 0
        var found = false
        for arrayDate in transactionData.sections
        {
            if arrayDate.formatDate(date: arrayDate.date) == arrayDate.formatDate(date: date) {
                found = true
                break
            }
            index += 1
        }
        type = paymentTypeArray[typeIndex]
        if typeIndex == 0 {
            if (transactionData.categoryIncomeArray.contains(category)) {
                cat = category
            } else {
                cat = transactionData.categoryIncomeArray[0]
            }
        }
        else {
            if (transactionData.categoryExpenseArray.contains(category)) {
                cat = category
            } else {
                cat = transactionData.categoryExpenseArray[0]
            }
        }
        let singleTransaction = Transaction(type: type, date: date, description: desc, category: cat, notes: note, amount: amount)
        if found == true {
            transactionData.sections[index].transactionsOfMonth.append(singleTransaction)
        }
        else {
            transactionData.sections.append(Day(date: date, transactionsOfMonth: [singleTransaction]))
        }
    }
}

struct AddTransaction_Previews: PreviewProvider {
    static var previews: some View {
        AddTransaction(transactionData: TransactionModel())
    }
}
