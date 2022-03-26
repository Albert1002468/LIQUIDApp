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
    @State var amount = ""
    @State var type = "Income"
    @State var date = Date.now
    @State var cat = ""
    @State var note = ""
    @State var desc = ""
    @State var typeIndex = 0
    @State var category = ""
    @State var hasOptions = false
    @State var descriptions: [String] = []
    @State var tempDesc = ""
    var body: some View {
        NavigationView {
            ZStack {
                Image("Light Rain")
                    .resizable()
                // .blur(radius: 10)
                //.aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Text(transactionData.formatCurrency(amount: (Double(amount) ?? 0.0)/100))
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                        .foregroundColor(typeIndex == 0 ? .green: .black)
                        .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.07)
                        .background(.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    KeyPad(string: $amount)
                        .frame(width: UIScreen.main.bounds.size.width * 0.9, height: UIScreen.main.bounds.size.height * 0.3)
                        .padding()
                    ZStack {
                        Color("DarkWater").opacity(0.6)
                        if !hasOptions {
                            List {
                                Picker(selection: $typeIndex, label: Text("Select Transaction Type")) {
                                    ForEach(0..<paymentTypeArray.count) {
                                        Text(paymentTypeArray[$0])
                                    }
                                }.pickerStyle(.segmented)
                                
                                HStack {
                                    Text("Description")
                                    TextField("Enter Description", text: $desc)
                                        .keyboardType(.alphabet)
                                        .disableAutocorrection(true)
                                    Button(action: {
                                        withAnimation(){
                                            self.hasOptions.toggle()
                                        }
                                    }) {
                                        Image(systemName: "magnifyingglass")
                                    }
                                }
                                
                                
                                DatePicker("Date", selection: $date, displayedComponents: .date)
                                
                                NavigationLink(destination: Category(transactionData: transactionData, typeIndex: typeIndex, category: $category)) {
                                    HStack {
                                        Text(typeIndex == 0 ? "Select Income Category" : "Select Expense Category")
                                        Spacer()
                                        if (typeIndex == 0 ? transactionData.categoryIncomeArray.contains(category) : transactionData.categoryExpenseArray.contains(category)) {
                                            Text(category)
                                                .foregroundColor(.gray)
                                        } else {
                                            Text(typeIndex == 0 ? transactionData.categoryIncomeArray[0] : transactionData.categoryExpenseArray[0])
                                        }
                                    }
                                    
                                }
                                HStack {
                                    Text("Notes")
                                    TextField("Enter Note", text: $note)
                                        .keyboardType(.alphabet)
                                        .disableAutocorrection(true)
                                }
                                
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
                                descriptions = transactionData.removeDuplicateDescriptions()
                            })
                            .transition(.move(edge: .trailing))
                        }
                    }
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
        
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = UIColor(.clear)
            
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            
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
        let singleTransaction = Transaction(type: type, date: date, description: desc, category: cat, notes: note, amount: (Double(amount) ?? 0.0)/100)
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
