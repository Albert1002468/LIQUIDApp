//
//  Model.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import Foundation


class TransactionModel: ObservableObject {
    @Published var sections = [Day]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(sections) {
                UserDefaults.standard.set(encoded, forKey: "Sections")
            }
        }
    }
    
    init() {
        if let savedSections = UserDefaults.standard.data(forKey: "Sections") {
            if let decodedSections = try? JSONDecoder().decode([Day].self, from: savedSections) {
                sections = decodedSections
                return
            }
        }
        sections = []
    }
    func sortSections() {
        let sortedSections = sections.sorted {
            $0.date > $1.date
        }
        sections = sortedSections
        var sortedTransaction: [Transaction]
        for section in 0..<sections.count {
            sortedTransaction = sections[section].transactionsOfMonth.sorted {
                $0.date > $1.date
            }
            sections[section].transactionsOfMonth = sortedTransaction
        }
    }
}
