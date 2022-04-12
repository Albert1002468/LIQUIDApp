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
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack (spacing: UIScreen.main.bounds.width * 0.18) {
                Spacer()
                ForEach(transactionData.savingsArray) { savings in
                    NavigationLink(destination: SavingsDetail(savings: savings, transactionData: transactionData)) {
                        SavingsTank(percentage: savings.amount != 0.0 ? savings.completed/savings.amount : 0 , name: savings.desc)
                    }
                }
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
    }
}

struct SavingsView_Previews: PreviewProvider {
    static var previews: some View {
        SavingsView(transactionData: TransactionModel())
    }
}

