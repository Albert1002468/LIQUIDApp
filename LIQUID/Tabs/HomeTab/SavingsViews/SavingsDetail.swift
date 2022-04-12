//
//  SavingsDetail.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 4/10/22.
//

import SwiftUI

struct SavingsDetail: View {
    @State var savings: Savings
    @ObservedObject var transactionData: TransactionModel
    @Environment(\.dismiss) private var dismiss
    @State var isShowingDeleteConfirmation = false
    @State var amount = ""
    @State var date = Date.now
    @State var note = ""
    @State var desc = ""
    @State var saving = ""
    var body: some View {
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
                    Section {
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
                    HStack {
                        Spacer()
                        Button("Permanently Delete") {
                            isShowingDeleteConfirmation = true
                        }.foregroundColor(.white)
                            .confirmationDialog("Are You Sure?", isPresented: $isShowingDeleteConfirmation, titleVisibility: .visible) {
                                Button("Delete", role: .destructive) {
                                    deleteSavings()
                                    dismiss()
                                }
                            }
                        Spacer()
                    }.listRowBackground(Color.red.opacity(0.9))
                }
            }
        }
        .navigationTitle("Edit Savings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            amount = String(Int(savings.amount))
            date = savings.date
            note = savings.note
            desc = savings.desc
            saving = savings.saving
        })
        .toolbar {
            Button(action: {
                updateSavings()
                dismiss()
            }) {
                Text("Save")
            }.disabled(desc.isEmpty || amount.isEmpty)
        }
        
    }
    func updateSavings() {
        
        let singleSavings = Savings(amount: (Double(amount) ?? 0.0), desc: desc, date: date, note: note, saving: saving)
        transactionData.savingsArray.append(singleSavings)
        deleteSavings()
    }
    
    func deleteSavings() {
        transactionData.savingsArray.remove(at: getSavingsIndex())
    }
    
    func getSavingsIndex() -> Int {
        if let savingsIndex = transactionData.savingsArray.firstIndex(where: { $0.id == savings.id}) {
            return savingsIndex
        }
        return -1
    }
}

struct SavingsDetail_Previews: PreviewProvider {
    static var previews: some View {
        SavingsDetail(savings: Savings(amount: 200000.0, desc: "Savings", date: Date.now, note: "", saving: "2%"), transactionData: TransactionModel())
    }
}
