//
//  AddSavings.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 4/10/22.
//

import SwiftUI

struct AddSavings: View {
    @ObservedObject var transactionData = TransactionModel()
    @Environment(\.dismiss) private var dismiss
    
    @State var amount = ""
    @State var desc = ""
    @State var saving = 0.0
    var body: some View {
        NavigationView {
            ZStack {
                Image("Dark")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Text(transactionData.formatCurrency(amount: (Double(amount) ?? 0.0)))
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.size.width * 0.90, height: UIScreen.main.bounds.size.height * 0.07)
                        .background(.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    KeyPad(string: $amount)
                        .frame(width: UIScreen.main.bounds.size.width * 0.9, height: UIScreen.main.bounds.size.height * 0.3)
                        .padding()
                    ZStack {
                        Color("CustomBlue").opacity(0.6)
                            .ignoresSafeArea()
                        
                        List {
                            HStack {
                                Text("Description")
                                TextField("Enter Description", text: $desc)
                                    .keyboardType(.alphabet)
                                    .disableAutocorrection(true)
                                    .multilineTextAlignment(.trailing)
                            }
                            
                            HStack (spacing:3) {
                                Text("Savings Amount")
                                Spacer()
                                TextField("Enter Savings Amount", value: $saving, formatter: NumberFormatter())
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                Text("%")
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Savings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    AddNewSavings()
                    dismiss()
                }) {
                    Text("Save")
                }.disabled(desc.isEmpty || amount.isEmpty || saving > 100.0 || transactionData.getTotalSaving(addNewSavings: saving/100, previousSavings: 0.0, savingsUsed: transactionData.getSavingsIDs()) > 1.0)
            }
        }
    }
    
    func AddNewSavings() {
        let singleSavings = Savings(amount: (Double(amount) ?? 0.0), completed: 0.0, desc: desc, date: Date.now, saving: saving, active: true, previousAmountAdded: 0.0)
        transactionData.savingsArray.insert(singleSavings, at: 0)
    }
}

struct AddSavings_Previews: PreviewProvider {
    static var previews: some View {
        AddSavings()
    }
}
