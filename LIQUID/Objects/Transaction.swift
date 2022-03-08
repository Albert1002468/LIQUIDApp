//
//  Transaction.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import Foundation

struct Transaction: Identifiable, Codable {
    var id = UUID()
    var type: Int
    var date: Date
    var description: String
    var category: String
    var notes: String
    var amount: Double
    
    func formatDate(date: Date, type: String) -> String {
        let dateFormatter = DateFormatter()
        if type == "monthyear" {
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")
        }
        else {
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMM dd, yyyy")
        }
        return dateFormatter.string(from: date)
    }
}

#if DEBUG
let testTransaction = Transaction(type: 0, date: Date.now, description: "Porter's Paycheck", category: "Direct Deposit", notes: "First of the month", amount: 400)
#endif
