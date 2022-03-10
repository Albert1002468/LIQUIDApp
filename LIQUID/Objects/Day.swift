//
//  Day.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import Foundation

struct Day: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var transactionsOfMonth: [Transaction]
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMM dd, yyyy")
        return dateFormatter.string(from: date)
    }
}

struct filteredDay: Identifiable, Codable {
    var id: String
    var date: Date
    var transactionsOfMonth: [filteredTransaction]
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMM dd, yyyy")
        return dateFormatter.string(from: date)
    }
}
