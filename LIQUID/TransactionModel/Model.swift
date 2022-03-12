//
//  Model.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import Foundation
import SwiftUI


class TransactionModel: ObservableObject {
    @Published var slices: [PieSlice] = []
    @Published var colors = [Color.blue, Color.green, Color.orange, Color.pink, Color.brown, Color.cyan, Color.mint, Color.purple]
    @Published var categoryExpenseArray = [String]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(categoryExpenseArray) {
                UserDefaults.standard.set(encoded, forKey: "categoryExpenseArray")
            }
        }
    }
    @Published var categoryIncomeArray = [String] () {
        didSet {
            if let encoded = try? JSONEncoder().encode(categoryExpenseArray) {
                UserDefaults.standard.set(encoded, forKey: "categoryExpenseArray")
            }
        }
    }
    @Published var filteredCategoryExpenseArray: [String] = []
    @Published var categoryExpenseValues: [Double] = []
    @Published var categoryIncomeValues: [Double] = []
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
                updateCategoryValues()
                getSlices()
                filterSections(searchText: "")
            }
        } else {
        sections = []
        }
        
        if let savedSections = UserDefaults.standard.data(forKey: "categoryExpenseArray") {
            if let decodedSections = try? JSONDecoder().decode([String].self, from: savedSections) {
                categoryExpenseArray = decodedSections
            }
        } else {
        categoryExpenseArray = ["Food", "Fuel", "Apparel", "Other"]
        }
        
        if let savedSections = UserDefaults.standard.data(forKey: "categoryIncomeArray") {
            if let decodedSections = try? JSONDecoder().decode([String].self, from: savedSections) {
                categoryIncomeArray = decodedSections
            }
        } else {
        categoryIncomeArray = ["Direct Deposit", "Cash","Check"]
        }
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
    
    func updateCategoryValues() {
        categoryExpenseValues = []
        categoryIncomeValues = []
        for section in sections {
            //print("sectionIndex: ", section)
            for transaction in section.transactionsOfMonth {
                //print("transactionIndex: ", transaction)
                if transaction.type == "Expense" {
                    for categoryIndex in 0..<categoryExpenseArray.count {
                        //print("category: ", sections[section].transactionsOfMonth[transaction].category)
                        //print("category from expense array: ",categoryExpenseArray[categoryIndex])
                        let arrayIndexExists = categoryIndex <= categoryExpenseValues.count-1
                        //print("categoryIndex: ", categoryIndex)
                        //print("does array exist: ", arrayIndexExists)
                        if transaction.category == categoryExpenseArray[categoryIndex] {
                            var amount = 0.0
                            if arrayIndexExists {
                                //print("removing at: ", categoryIndex)
                                amount = categoryExpenseValues[categoryIndex]
                                categoryExpenseValues.remove(at: categoryIndex)
                            }
                            categoryExpenseValues.insert(amount + transaction.amount, at: categoryIndex)
                            //print(categoryValues)
                        }
                        else {
                            if categoryIndex > categoryExpenseValues.count-1 {
                                categoryExpenseValues.insert(0, at: categoryIndex)
                            }
                            //print(categoryValues)
                        }
                    }
                }
                else {
                    for categoryIndex in 0..<categoryIncomeArray.count {
                        //print("category: ", sections[section].transactionsOfMonth[transaction].category)
                        //print("category from expense array: ",categoryExpenseArray[categoryIndex])
                        let arrayIndexExists = categoryIndex <= categoryIncomeValues.count-1
                        //print("categoryIndex: ", categoryIndex)
                        //print("does array exist: ", arrayIndexExists)
                        if transaction.category == categoryIncomeArray[categoryIndex] {
                            var amount = 0.0
                            if arrayIndexExists {
                                //print("removing at: ", categoryIndex)
                                amount = categoryIncomeValues[categoryIndex]
                                categoryIncomeValues.remove(at: categoryIndex)
                            }
                            categoryIncomeValues.insert(amount + transaction.amount, at: categoryIndex)
                            //print(categoryValues)
                        }
                        else {
                            if categoryIndex > categoryIncomeValues.count-1 {
                                categoryIncomeValues.insert(0, at: categoryIndex)
                            }
                            //print(categoryValues)
                        }
                    }
                }
            }
        }
        getNewCategories()
    }
    
    func getNewCategories() {
        filteredCategoryExpenseArray = []
        //print(categoryValues.count)
        var skip = 0
        for value in 0..<categoryExpenseValues.count {
            //print(value)
            if categoryExpenseValues[value - skip] == 0.0 {
                //print("im in")
                //print("skip: ", skip)
                categoryExpenseValues.remove(at: value - skip)
                //print(categoryValues)
                skip+=1
                continue
            }
            filteredCategoryExpenseArray.append(categoryExpenseArray[value])
            //print(categoryValues)
            //print(filteredCategoryExpenseArray)
        }
    }
    
    func getSlices() {
        slices = []
        let sum = categoryExpenseValues.reduce(0, +)
        var endDeg: Double = 0
        for (i, value) in categoryExpenseValues.enumerated() {
            let degrees: Double = value * 360 / sum
            slices.append(PieSlice(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), text: String(format: "%.0f%%", value * 100 / sum), color: colors[i]))
            endDeg += degrees
        }
    }
    
    func formatDate(date: Date, type: String) -> String {
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
