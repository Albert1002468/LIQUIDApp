//
//  Day.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import Foundation

struct Day: Identifiable, Codable {
    var id = UUID()
    let date: Date
    var transactionsOfMonth: [Transaction]
    
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
