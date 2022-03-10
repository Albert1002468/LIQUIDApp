//
//  Model.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import Foundation


class TransactionModel: ObservableObject {
    @Published var filteredSections = [filteredDay]()
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
                filterSections(searchText: "")
                return
            }
        }
        sections = []
    }
    
    
    func filterTransactions(section: Int, searchText: String) -> [filteredTransaction]{
        var transactionsWithStringID = [filteredTransaction]()
        for transaction in  0..<sections[section].transactionsOfMonth.count {
            transactionsWithStringID.append(filteredTransaction(id: sections[section].transactionsOfMonth[transaction].id.uuidString, type: sections[section].transactionsOfMonth[transaction].type, date: sections[section].transactionsOfMonth[transaction].date, description: sections[section].transactionsOfMonth[transaction].description, category: sections[section].transactionsOfMonth[transaction].category, notes: sections[section].transactionsOfMonth[transaction].notes, amount: String(format: "%.2f", sections[section].transactionsOfMonth[transaction].amount)))
        }
        if !searchText.isEmpty {
            let filteredTransaction = transactionsWithStringID.filter {
                $0.description.localizedCaseInsensitiveContains(searchText)||$0.notes.localizedCaseInsensitiveContains(searchText)||$0.category.localizedCaseInsensitiveContains(searchText)||$0.amount.localizedCaseInsensitiveContains(searchText)||$0.type.localizedCaseInsensitiveContains(searchText)
            }
            return filteredTransaction
        }
        return transactionsWithStringID
    }
    
    func filterSections(searchText: String) {
        
        filteredSections = []
        for section in 0..<sections.count {
            let testingTransaction = filterTransactions(section:section, searchText: searchText)
            if !testingTransaction.isEmpty {
            filteredSections.append(filteredDay(id: sections[section].id.uuidString, date: sections[section].date, transactionsOfMonth: testingTransaction))
            }
        }
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
    
    func formatDate(date: Date, type: String) -> String {
        let dateFormatter = DateFormatter()
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMM dd, yyyy")
        return dateFormatter.string(from: date)
    }
}
