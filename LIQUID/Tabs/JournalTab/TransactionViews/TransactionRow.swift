//
//  TransactionRow.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text(transaction.description)
                    .font(.headline)
                Text(transaction.category)
                    .font(.footnote)
            }
            Spacer()
            VStack(alignment: .trailing) {
                HStack {
                    if transaction.type == 1 {
                        Text("-")
                    }
                    Text(transaction.amount, format: .currency(code: "USD"))
                        .foregroundColor(transaction.type == 0 ? .green : .black)
                }
                Text(transaction.formatDate(date: transaction.date, type: ""))
                    .font(.footnote)
                
            }
        }
    }
}

struct TransactionRow_Previews: PreviewProvider {
    static var previews: some View {
        TransactionRow(transaction: testTransaction)
    }
}
