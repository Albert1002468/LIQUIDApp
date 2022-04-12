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
    @State var date = Date.now
    @State var note = ""
    @State var desc = ""
    @State var saving = "0"
    var body: some View {
        NavigationView {
            ZStack {
                 Image("Black")
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
                    
                    List {
                        HStack {
                            Text("Description")
                            TextField("Enter Description", text: $desc)
                                .keyboardType(.alphabet)
                                .disableAutocorrection(true)
                        }
                        
                        Picker(selection: $saving, label: Text("Saving Amount")) {
                            ForEach (0..<51, id:\.self) { percentage in
                                Text("\(percentage * 2)%").tag(String("\(percentage * 2)"))
                            }
                        }
                        
                        DatePicker("Completion Date", selection: $date, displayedComponents: .date)
                        
                        HStack {
                            Text("Notes")
                            TextField("Enter Note", text: $note)
                                .keyboardType(.alphabet)
                                .disableAutocorrection(true)
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
                }.disabled(desc.isEmpty || amount.isEmpty)
            }
        }
    }
    
    func AddNewSavings() {
        let singleSavings = Savings(amount: (Double(amount) ?? 0.0), desc: desc, date: date, note: note, saving: saving)
        transactionData.savingsArray.append(singleSavings)
    }
}

struct AddSavings_Previews: PreviewProvider {
    static var previews: some View {
        AddSavings()
    }
}
