//
//  HomeTab.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import SwiftUI

struct HomeTab: View {
    @ObservedObject var transactionData: TransactionModel
    var body: some View {
        NavigationView {
            VStack {
                PieChartView(transactionData: transactionData, backgroundColor: Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 1.0), innerRadiusFraction: 0.6)
                List {
                    ForEach (0..<transactionData.filteredCategoryExpenseArray.count, id: \.self) { index in
                        PieChartRow(color: transactionData.colors[index], name: transactionData.filteredCategoryExpenseArray[index], value: transactionData.formatCurrency(amount: transactionData.categoryExpenseValues[index]), percent: String(format: "%.0f%%", transactionData.categoryExpenseValues[index] / transactionData.categoryExpenseValues.reduce(0, +) * 100))
                    }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "pencil.circle.fill")
                    }
                }
            }
        }
        .onAppear(perform: {
            transactionData.updateCategoryValues()
            transactionData.getSlices()
        })
    }
}

struct HomeTab_Previews: PreviewProvider {
    static var previews: some View {
        HomeTab(transactionData: TransactionModel())
    }
}
