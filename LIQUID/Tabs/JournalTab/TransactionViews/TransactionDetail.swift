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
    @State var categoryIndex: Int
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        
        return formatter
    }()
    var body: some View {
        ZStack {
            Color.blue
                .opacity(0.1)
                .ignoresSafeArea()
            
               // Rectangle()
               //     .fill(Color.clear)
                //    .frame(height: 10)
                //    .background(LinearGradient(colors: [.green.opacity(0.3), .blue.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                
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
                            categoryIndex = 0
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
                        NavigationLink(destination: Category(transactionData: transactionData, typeIndex: typeIndex, categoryIndex: $categoryIndex)) {
                            if (typeIndex == 0) {
                                HStack {
                                    Text("Select Income Category")
                                    Spacer()
                                    if (transactionData.categoryIncomeArray.indices.contains(categoryIndex )) {
                                        Text(transactionData.categoryIncomeArray[categoryIndex ])
                                            .foregroundColor(.gray)
                                    } else {
                                        Text(transactionData.categoryIncomeArray[0])
                                    }
                                }
                            } else {
                                HStack {
                                    Text("Select Expense Category")
                                    Spacer()
                                    if (transactionData.categoryExpenseArray.indices.contains(categoryIndex )) {
                                        Text(transactionData.categoryExpenseArray[categoryIndex ])
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
                    
                    Button("Permanently Delete") {
                        deleteTransaction()
                        transactionData.filterSections(searchText: searchText)
                        dismiss()
                    }
                    .navigationTitle("Transaction Details")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                UpdateTransaction()
                                transactionData.sortSections()
                                transactionData.filterSections(searchText: searchText)
                                dismiss()
                            }) {
                                HStack (spacing: 5){
                                    Image(systemName: "chevron.left")
                                        .font(Font.system(.body).bold())
                                    Text("Back")
                                }
                            }.disabled(desc.isEmpty)
                        }
                    }
                }
            
        }
    }
    func UpdateTransaction() {
        
        var index = 0
        var found = false
        
        type = paymentTypeArray[typeIndex]
        if typeIndex == 0 {
            if (transactionData.categoryIncomeArray.count > categoryIndex ) {
                cat = transactionData.categoryIncomeArray[categoryIndex ]
            } else {
                cat = transactionData.categoryIncomeArray[0]
            }
        }
        else {
            if (transactionData.categoryExpenseArray.count > categoryIndex ) {
                cat = transactionData.categoryExpenseArray[categoryIndex ]
            } else {
                cat = transactionData.categoryExpenseArray[0]
            }
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
        TransactionDetail(transaction: testTransaction, transactionData: TransactionModel(), amount: testTransaction.amount, type: testTransaction.type, date: testTransaction.date, cat: testTransaction.category, note: testTransaction.notes, desc: testTransaction.description, searchText: "", typeIndex: 0, categoryIndex: 0)
    }
}
