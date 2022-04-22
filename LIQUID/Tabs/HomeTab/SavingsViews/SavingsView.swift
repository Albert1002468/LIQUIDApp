//
//  SavingsView.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 4/10/22.
//

import SwiftUI

struct SavingsView: View {
    @ObservedObject var transactionData: TransactionModel
    @State var addSavings = false
    @State var activeStatus = true
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            Color("CustomBlue")
                .ignoresSafeArea()
            VStack {
                Picker(selection: $activeStatus, label: Text("Active/Inactive")) {
                    Text("Active").tag(true)
                    Text("Inactive").tag(false)
                }.pickerStyle(.segmented)
                Spacer()
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack (spacing: UIScreen.main.bounds.width * 0.18) {
                        Spacer()
                        ForEach($transactionData.savingsArray) { $savings in
                            if savings.active == activeStatus && savings.active == true {
                                NavigationLink(destination: SavingsDetail(savings: $savings, transactionData: transactionData)) {
                                    SavingsTank(savings: $savings)
                                }
                            }
                            else if savings.active == activeStatus && savings.active == false {
                                SavingsTank(savings: $savings)
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .navigationTitle("Savings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    self.addSavings.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                }.sheet(isPresented: $addSavings, content: {
                    AddSavings(transactionData: transactionData)
                })
            }
        }
        .onDisappear(){
            dismiss()
        }
    }
}

struct SavingsView_Previews: PreviewProvider {
    static var previews: some View {
        SavingsView(transactionData: TransactionModel())
    }
}

