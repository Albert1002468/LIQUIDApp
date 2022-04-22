//
//  SavingsDetail.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 4/10/22.
//

import SwiftUI

struct SavingsDetail: View {
    @Binding var savings: Savings
    @ObservedObject var transactionData: TransactionModel
    @Environment(\.dismiss) private var dismiss
    @State var isShowingDiscontinueConfirmation = false
    @State var amount = ""
    @State var desc = ""
    @State var active = true
    var body: some View {
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
                
                    List {
                        Section {
                            HStack {
                                Text("Description")
                                TextField("Enter Description", text: $desc)
                                    .keyboardType(.alphabet)
                                    .disableAutocorrection(true)
                                    .multilineTextAlignment(.trailing)

                            }
                            
                            HStack {
                                Text("Completed")
                                Spacer()
                                Text(transactionData.formatCurrency(amount: savings.completed))
                            }
                            
                            HStack {
                                Text("Savings Amount")
                                Spacer()
                                Text("\(savings.saving, specifier: "%.0f")%")
                            }
                        }
                        HStack {
                            Spacer()
                            Button("Discontinue") {
                                isShowingDiscontinueConfirmation = true
                            }.foregroundColor(.white)
                                .confirmationDialog("Are You Sure?", isPresented: $isShowingDiscontinueConfirmation, titleVisibility: .visible) {
                                    Button("Yes, Discontinue", role: .destructive) {
                                        savings.active = false
                                        savings.date = Date.now
                                        dismiss()
                                    }
                                }
                            
                            Spacer()
                        }.listRowBackground(Color.red.opacity(0.9))
                    }
                }
            }
        }
        .navigationTitle("Edit Savings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            amount = String(Int(savings.amount))
            desc = savings.desc
            active = savings.active
        })
        .toolbar {
            Button(action: {
                updateSavings()
                dismiss()
            }) {
                Text("Save")
            }.disabled(desc.isEmpty || amount.isEmpty || savings.completed > Double(amount) ?? 0.0)
        }
    }
    
    func updateSavings() {
        savings.amount = Double(amount) ?? 0.0
        if savings.completed == savings.amount {
            savings.active = false
        }
        savings.desc = desc
    }
}

struct SavingsDetail_Previews: PreviewProvider {
    @State static var saving = Savings(amount: 200000.0, completed: 0.0, desc: "Savings", date: Date.now, saving: 2.0, active: false, previousAmountAdded: 50.24)
    static var previews: some View {
        SavingsDetail(savings: $saving, transactionData: TransactionModel())
    }
}
