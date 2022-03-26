//
//  Transaction.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import Foundation

struct Transaction: Identifiable, Codable {
    var id = UUID()
    var type: String
    var date: Date
    var description: String
    var category: String
    var notes: String
    var amount: Double
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMM dd, yyyy")
        return dateFormatter.string(from: date)
    }
}

struct filteredTransaction: Identifiable, Codable {
    var id: String
    var type: String
    var date: Date
    var description: String
    var category: String
    var notes: String
    var amount: Double
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMM dd, yyyy")
        return dateFormatter.string(from: date)
    }
    
    func formatCurrency(amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter.string(from: amount as NSNumber)!
    }
}

#if DEBUG
let testTransaction = Transaction(type: "Income", date: Date.now, description: "Porter's Paycheck", category: "Direct Deposit", notes: "First of the month", amount: 400)
let testFilteredTransaction = filteredTransaction(id: "0", type: "Income", date: Date.now, description: "Porter's Paycheck", category: "Direct Deposit", notes: "First of the month", amount: 400.09)
#endif
