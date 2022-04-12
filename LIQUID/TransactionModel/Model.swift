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
    @Published var allMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    @Published var colors = [Color.blue, Color.yellow, Color.orange, Color.pink, Color.brown, Color.cyan, Color.mint, Color.purple]
    @Published var savingsArray = [Savings]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(savingsArray) {
                UserDefaults.standard.set(encoded, forKey: "savingsArray")
            }
        }
    }
    @Published var categoryExpenseArray = [String]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(categoryExpenseArray) {
                UserDefaults.standard.set(encoded, forKey: "categoryExpenseArray")
            }
        }
    }
    @Published var categoryIncomeArray = [String] () {
        didSet {
            if let encoded = try? JSONEncoder().encode(categoryIncomeArray) {
                UserDefaults.standard.set(encoded, forKey: "categoryIncomeArray")
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
                //updateCategoryValues()
                //getSlices()
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
        
        if let savedSections = UserDefaults.standard.data(forKey: "savingsArray") {
            if let decodedSections = try? JSONDecoder().decode([Savings].self, from: savedSections) {
                savingsArray = decodedSections
            }
        } else {
            savingsArray = []
        }
    }
    
    
    func filterTransactions(section: Int, searchText: String) -> [filteredTransaction]{
        var transactionsWithStringID = [filteredTransaction]()
        for transaction in  0..<sections[section].transactionsOfMonth.count {
            transactionsWithStringID.append(filteredTransaction(
                id: sections[section].transactionsOfMonth[transaction].id.uuidString,
                type: sections[section].transactionsOfMonth[transaction].type,
                date: sections[section].transactionsOfMonth[transaction].date,
                description: sections[section].transactionsOfMonth[transaction].description,
                category: sections[section].transactionsOfMonth[transaction].category,
                notes: sections[section].transactionsOfMonth[transaction].notes,
                amount: sections[section].transactionsOfMonth[transaction].amount,
                saving: sections[section].transactionsOfMonth[transaction].saving))
        }
        if !searchText.isEmpty {
            let filteredTransaction = transactionsWithStringID.filter {
                $0.description.localizedCaseInsensitiveContains(searchText)||$0.notes.localizedCaseInsensitiveContains(searchText)||$0.category.localizedCaseInsensitiveContains(searchText)||formatCurrency(amount: $0.amount).localizedCaseInsensitiveContains(searchText)||$0.type.localizedCaseInsensitiveContains(searchText)||formatDate(date: $0.date).localizedCaseInsensitiveContains(searchText)||formatDateByMonthYear(date: $0.date).localizedCaseInsensitiveContains(searchText)
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
        //  var sortedTransaction: [Transaction]
        // for section in 0..<sections.count {
        //     sortedTransaction = sections[section].transactionsOfMonth.sorted {
        //         $0.date > $1.date
        //     }
        //     sections[section].transactionsOfMonth = sortedTransaction
        // }
    }
    
    func updateValues(section: Day) {
        for transaction in section.transactionsOfMonth {
            if transaction.type == "Expense" {
                for categoryIndex in 0..<categoryExpenseArray.count {
                    let arrayIndexExists = categoryIndex <= categoryExpenseValues.count-1
                    if transaction.category == categoryExpenseArray[categoryIndex] {
                        var amount = 0.0
                        if arrayIndexExists {
                            amount = categoryExpenseValues[categoryIndex]
                            categoryExpenseValues.remove(at: categoryIndex)
                        }
                        categoryExpenseValues.insert(amount + transaction.amount, at: categoryIndex)
                    }
                    else {
                        if categoryIndex > categoryExpenseValues.count-1 {
                            categoryExpenseValues.insert(0, at: categoryIndex)
                        }
                    }
                }
            }
            else {
                for categoryIndex in 0..<categoryIncomeArray.count {
                    let arrayIndexExists = categoryIndex <= categoryIncomeValues.count-1
                    if transaction.category == categoryIncomeArray[categoryIndex] {
                        var amount = 0.0
                        if arrayIndexExists {
                            amount = categoryIncomeValues[categoryIndex]
                            categoryIncomeValues.remove(at: categoryIndex)
                        }
                        categoryIncomeValues.insert(amount + transaction.amount - transaction.saving, at: categoryIndex)
                    }
                    else {
                        if categoryIndex > categoryIncomeValues.count-1 {
                            categoryIncomeValues.insert(0, at: categoryIndex)
                        }
                    }
                }
            }
        }
    }
    func updateCategoryValues(month: String, year: String, secondMonth: String, secondYear: String, type: String) {
        categoryExpenseValues = []
        categoryIncomeValues = []
        if type == "Monthly" {
            for section in sections where formatDate(date: section.date).contains(month) && formatDate(date: section.date).contains(year)
            {
                updateValues(section: section)
            }
        } else
        if type == "Annually" {
            for section in sections where formatDate(date: section.date).contains(year)
            {
                updateValues(section: section)
            }
        } else
        if type == "Alltime" {
            for section in sections {
                updateValues(section: section)
            }
        } else
        if type == "Custom" {
            var monthArray: [String] = []
            var yearArray: [String] = []
            
            for yearIndex in 0..<(Int(secondYear) ?? 0) + 1 - (Int(year) ?? 0) {
                yearArray.append(String((Int(year) ?? 0) + yearIndex))
            }
            print(yearArray)
            var foundFirst = false
            
            for monthIndex in 0..<allMonths.count {
                if !foundFirst {
                    if month == allMonths[monthIndex] {
                        if month != secondMonth {
                            monthArray.append(allMonths[monthIndex])
                            foundFirst = true
                        } else {
                            monthArray.append(allMonths[monthIndex])
                            break
                        }
                    }
                } else {
                    if allMonths[monthIndex] == secondMonth {
                        monthArray.append(allMonths[monthIndex])
                        break
                    } else {
                        monthArray.append(allMonths[monthIndex])
                    }
                }
            }
            print(monthArray)
            var newYear = Int(year) ?? 0
            var filteredSectionsForHomeTab: [Day] = []
            for yearIndex in 0..<yearArray.count {
                if String(newYear) == secondYear {
                    for section in sections  {
                        for monthIndex in 0..<monthArray.count {
                            newYear = Int(year) ?? 0
                            if formatDate(date: section.date).contains(monthArray[monthIndex]) && formatDate(date: section.date).contains(yearArray[yearIndex]) {
                                filteredSectionsForHomeTab.append(section)
                            }
                        }
                    }
                } else {
                    for section in sections  {
                        if formatDate(date: section.date).contains(yearArray[yearIndex]) {
                            filteredSectionsForHomeTab.append(section)
                        }
                    }
                    newYear += 1
                }
            }
            print(filteredSectionsForHomeTab)
            
            for section in filteredSectionsForHomeTab {
                updateValues(section: section)
            }
        }
        getNewCategories()        
    }
    
    func getNewCategories() {
        filteredCategoryExpenseArray = []
        var skip = 0
        for value in 0..<categoryExpenseValues.count {
            if categoryExpenseValues[value - skip] == 0.0 {
                categoryExpenseValues.remove(at: value - skip)
                skip+=1
                continue
            }
            filteredCategoryExpenseArray.append(categoryExpenseArray[value])
        }
    }
    
    func getSlices() {
        slices = []
        var sum = 0.0
        if categoryIncomeValues.reduce(0, +) >= categoryExpenseValues.reduce(0, +) {
            sum = categoryIncomeValues.reduce(0, +)
        } else {
            sum = categoryExpenseValues.reduce(0, +)
        }
        var endDeg: Double = 0
        for (i, value) in categoryExpenseValues.enumerated() {
            let degrees: Double = value * 360 / sum
            slices.append(PieSlice(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), text: String(format: "%.0f%%", value * 100 / sum), color: colors[i]))
            endDeg += degrees
        }
    }
    
    func removeDuplicateDescriptions() -> [String] {
        var buffer: [String] = []
        for section in sections {
            for transaction in section.transactionsOfMonth {
                if !buffer.contains(transaction.description) {
                    buffer.append(transaction.description)
                }
            }
        }
        return buffer
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM dd, yyyy")
        return dateFormatter.string(from: date)
    }
    
    func formatDateByMonthYear(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")
        return dateFormatter.string(from: date)
    }
    
    func formatDateBySpecific(date: Date) -> (String, String) {
        let dateFormatterMonth = DateFormatter()
        dateFormatterMonth.setLocalizedDateFormatFromTemplate("MMMM")
        let dateFormatterYear = DateFormatter()
        dateFormatterYear.setLocalizedDateFormatFromTemplate("yyyy")
        
        return (dateFormatterMonth.string(from: date), dateFormatterYear.string(from: date))
    }
    
    func getYears() -> [String] {
        var buffer: [String] = []
        for section in sections {
            let results = formatDateBySpecific(date: section.date)
            let testDate = results.1
            if !buffer.contains(testDate) {
                buffer.insert(testDate, at: 0)
            }
            
        }
        return buffer
    }
    
    func formatCurrency(amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter.string(from: amount as NSNumber)!
    }
    
    func allocateSavings(amount: Double) -> Double {
        var fullSavings = 0.0
        for savings in 0..<savingsArray.count {
            if (Int(savingsArray[savings].saving) ?? 0) > 0 {
                fullSavings = fullSavings + (Double(savingsArray[savings].saving) ?? 0.0) * amount / 10000
                savingsArray[savings].completed = savingsArray[savings].completed + (Double(savingsArray[savings].saving) ?? 0.0) * amount / 10000
            }
        }
        return fullSavings
    }
}
