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
    let paymentTypeArray = ["Income", "Expense"]
    @State var amount = ""
    @State var type = ""
    @State var date = Date.now
    @State var cat = ""
    @State var note = ""
    @State var desc = ""
    @State var searchText: String
    @State var savings = 0.0
    @State var typeIndex: Int
    @State var category: String
    @State var isShowingDeleteConfirmation = false
    @State var hasOptions = false
    @State var descriptions: [String] = []
    @State var tempDesc = ""
    @State var previousAmount = 0.0
    @State var appendSavings: Bool
    var body: some View {
        ZStack {
            Image("Dark")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text(transactionData.formatCurrency(amount: (Double(amount) ?? 0.0)/100))
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .foregroundColor(typeIndex == 0 ? .green: .black)
                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.07)
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                KeyPad(string: $amount)
                    .frame(width: UIScreen.main.bounds.size.width * 0.85, height: UIScreen.main.bounds.size.height * 0.3)
                    .padding()
                
                ZStack {
                    Color("CustomBlue").opacity(0.6)
                    
                    if !hasOptions {
                        List {
                            Section {
                                Picker(selection: $typeIndex, label: Text("Select Transaction Type")) {
                                    ForEach(0..<paymentTypeArray.count, id:\.self) {
                                        Text(paymentTypeArray[$0])
                                    }
                                }.pickerStyle(.segmented)
                                
                                HStack {
                                    Text("Description")
                                    Button(action: {
                                        withAnimation(){
                                            self.hasOptions.toggle()
                                        }
                                    }) {
                                        Image(systemName: "magnifyingglass")
                                    }
                                    TextField("Enter Description", text: $desc)
                                        .keyboardType(.alphabet)
                                        .disableAutocorrection(true)
                                        .multilineTextAlignment(.trailing)
                                }
                                
                                DatePicker("Date", selection: $date, displayedComponents: .date)
                                
                                NavigationLink(destination: Category(transactionData: transactionData, typeIndex: typeIndex, category: $category)) {
                                    HStack {
                                        Text(typeIndex == 0 ? "Select Income Category" : "Select Expense Category").foregroundColor(.black).multilineTextAlignment(.leading)
                                        Spacer()
                                        if (typeIndex == 0 ? transactionData.categoryIncomeArray.contains(category) : transactionData.categoryExpenseArray.contains(category)) {
                                            Text(category)
                                                .foregroundColor(.gray)
                                            
                                        } else {
                                            Text(typeIndex == 0 ? transactionData.categoryIncomeArray[0] : transactionData.categoryExpenseArray[0])
                                            
                                        }
                                    }
                                }
                                if (typeIndex == 0) {
                                    Toggle("Apply Savings?",isOn: $appendSavings)
                                        .onChange(of: appendSavings) { _ in
                                            savings = transactionData.getSavingsPercent(amount: appendSavings ? Double(amount) ?? 0.0 : 0.0, savingsUsed: transaction.appliedSavingsTo)
                                        }
                                }
                                
                                HStack {
                                    Text("Applied to Savings:")
                                    Spacer()
                                    Text(transactionData.formatCurrency(amount: savings))
                                        .multilineTextAlignment(.trailing)
                                        .onChange(of: amount) { _ in
                                            if appendSavings {
                                                savings = transactionData.getSavingsPercent(amount: Double(amount) ?? 0.0, savingsUsed: transaction.appliedSavingsTo)
                                            }
                                        }
                                }
                                
                                HStack {
                                    Text("Notes")
                                    TextField("Enter Note", text: $note)
                                        .keyboardType(.alphabet)
                                        .disableAutocorrection(true)
                                        .multilineTextAlignment(.trailing)

                                }
                            }
                            
                            HStack {
                                Spacer()
                                Button("Permanently Delete") {
                                    isShowingDeleteConfirmation = true
                                }.foregroundColor(.white)
                                    .confirmationDialog("Are You Sure?", isPresented: $isShowingDeleteConfirmation, titleVisibility: .visible) {
                                        Button("Delete", role: .destructive) {
                                            if appendSavings {
                                                transactionData.changeSavings( amount: 0.0, savingsUsed: transaction.appliedSavingsTo)
                                            }
                                            deleteTransaction()
                                            transactionData.filterSections(searchText: searchText)
                                            dismiss()
                                        }
                                    }
                                Spacer()
                            }.listRowBackground(Color.red.opacity(0.9))
                        }.transition(.move(edge: .leading))
                    }
                    if hasOptions {
                        List {
                            HStack {
                                TextField("Enter Description", text: $tempDesc)
                                    .keyboardType(.alphabet)
                                    .disableAutocorrection(true)
                                Button(action: {
                                    withAnimation(){
                                        self.hasOptions.toggle()
                                    }
                                }) {
                                    HStack {
                                        Image(systemName:"chevron.left")
                                        Text("Back")
                                        
                                    }
                                }
                            }
                            
                            ForEach(descriptions.filter {
                                tempDesc.isEmpty ? true : $0.localizedCaseInsensitiveContains(tempDesc)
                            }, id: \.self) { description in
                                HStack {
                                    Text(description)
                                    Spacer()
                                }.contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation(){
                                            desc = description
                                            self.hasOptions = false
                                        }
                                    }
                            }
                        }.onAppear(perform: {
                            tempDesc = ""
                        })
                        .transition(.move(edge: .trailing))
                    }
                }
            }
        }
        .navigationTitle("Transaction Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    transactionData.changeSavings(amount: appendSavings ? Double(amount) ?? 0.0 : 0.0, savingsUsed: transaction.appliedSavingsTo)
                    UpdateTransaction()
                    transactionData.sortSections()
                    transactionData.filterSections(searchText: searchText)
                    dismiss()
                }) {
                    HStack (spacing: 5){
                        Text("Save")
                    }
                }.disabled(desc.isEmpty || amount.isEmpty)
            }
        }
        .onAppear(perform: {
            descriptions = transactionData.removeDuplicateDescriptions()
            amount = String(Int(transaction.amount*100))
            type = transaction.type
            date = transaction.date
            cat = transaction.category
            note = transaction.notes
            desc = transaction.description
            savings = transaction.saving
            previousAmount = savings
        })
    }
    
    func UpdateTransaction() {
        
        var index = 0
        var found = false
        
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
        let singleTransaction = Transaction(type: type, date: date, description: desc, category: cat, notes: note, amount: (Double(amount) ?? 0.0)/100, saving: savings, appliedSavingsTo: transaction.appliedSavingsTo)
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
                transactionData.sections[index].transactionsOfMonth.insert(singleTransaction, at: 0)
            }
            else {
                transactionData.sections.append(Day(date: date, transactionsOfMonth: [singleTransaction]))
            }
        }
        else {
            transactionData.sections[getSectionIndex()].transactionsOfMonth.insert(singleTransaction, at: getTransactionIndex())
        }
        deleteTransaction()
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
    @State static var testTransaction = Transaction(type: "Income", date: Date.now, description: "Porter's Paycheck", category: "Direct Deposit", notes: "First of the month", amount: 400, saving: 12.3, appliedSavingsTo: [UUID()])
    static var previews: some View {
        TransactionDetail(transaction: testTransaction, transactionData: TransactionModel(), amount: "400", type: testTransaction.type, date: testTransaction.date, cat: testTransaction.category, note: testTransaction.notes, desc: testTransaction.description, searchText: "", savings: 2.32, typeIndex: 0, category: "Direct Deposit", appendSavings: false)
    }
}
