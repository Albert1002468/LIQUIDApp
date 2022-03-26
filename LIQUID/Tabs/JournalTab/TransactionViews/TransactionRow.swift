//
//  TransactionRow.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import SwiftUI

struct TransactionRow: View {
    let transaction: filteredTransaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.description)
                    .font(.headline)
                    .lineLimit(1)
                Text(transaction.category)
                    .font(.footnote)
                    .lineLimit(1)
            }
            Spacer()
            HStack {
                if transaction.type != "Income" {
                    Text("-")
                    Text(transaction.formatCurrency(amount: (Double(transaction.amount) ?? 0.0)))
                } else {
                    Text(transaction.formatCurrency(amount: (Double(transaction.amount) ?? 0.0)))
                        .foregroundColor(.green)
                }
            }
        }
    }
}

struct TransactionRow_Previews: PreviewProvider {
    static var previews: some View {
        TransactionRow(transaction: testFilteredTransaction)
    }
}
