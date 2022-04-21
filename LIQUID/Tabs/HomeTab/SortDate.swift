//
//  SortDate.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 4/9/22.
//

import SwiftUI

struct SortDate: View {
    @ObservedObject var transactionData: TransactionModel
    @Environment(\.dismiss) private var dismiss
    @State var months: [String] = []
    @State var years: [String] = []
    @Binding var type: String
    @State var currentMonth = ""
    @Binding var month: String
    @State var currentYear = ""
    @Binding var year: String
    @Binding var secondMonth: String
    @Binding var secondYear: String
    @State var monthIndex = 0
    @State var yearIndex = 0
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("Dark")
                    .resizable()
                    .ignoresSafeArea()
                List {
                    Picker(selection: $type, label: Text("type picker")) {
                        Text("Monthly").tag("Monthly")
                        Text("Annually").tag("Annually")
                        Text("Alltime").tag("Alltime")
                        Text("Custom").tag("Custom")
                    }.pickerStyle(.segmented)
                    
                    switch type {
                        
                    case "Monthly":
                        Picker(selection: $month, label: Text("Month")) {
                            ForEach(0..<months.count, id:\.self) {
                                Text(months[$0]).tag(months[$0])
                            }
                        }
                        Picker(selection: $year, label: Text("Year")) {
                            ForEach(0..<years.count, id:\.self) {
                                Text(years[$0]).tag(years[$0])
                            }
                        }
                        
                    case "Annually":
                        Picker(selection: $year, label: Text("Year")) {
                            ForEach(0..<years.count, id:\.self) {
                                Text(years[$0]).tag(years[$0])
                            }
                        }
                        
                    case "Alltime":
                        Text("AllTime Selected")
                        
                    case "Custom":
                        Text("From")
                        Picker(selection: $month, label: Text("Month")) {
                            ForEach(0..<months.count, id:\.self) {
                                Text(months[$0]).tag(months[$0])
                            }.onChange(of: month) { _ in
                                getMonthIndex()
                                secondMonth = month
                            }
                        }
                        Picker(selection: $year, label: Text("Year")) {
                            ForEach(0..<years.count, id:\.self) {
                                Text(years[$0]).tag(years[$0])
                            }.onChange(of: year) { _ in
                                getYearIndex()
                                secondYear = year
                                
                            }
                        }
                        
                        Text("To")
                        Picker(selection: $secondMonth, label: Text("Month")) {
                            ForEach(monthIndex..<months.count, id:\.self) {
                                Text(months[$0]).tag(months[$0])
                            }
                        }
                        Picker(selection: $secondYear, label: Text("Year")) {
                            ForEach(yearIndex..<years.count, id:\.self) {
                                Text(years[$0]).tag(years[$0])
                            }
                        }
                        
                    default:
                        Picker(selection: $month, label: Text("Month")) {
                            ForEach(0..<months.count, id:\.self) {
                                Text(months[$0]).tag(months[$0])
                            }
                        }
                        Picker(selection: $year, label: Text("Year")) {
                            ForEach(0..<years.count, id:\.self) {
                                Text(years[$0]).tag(years[$0])
                            }
                        }
                    }
                }
            }
            .navigationTitle("Sort")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        type = "Monthly"
                        month = currentMonth
                        secondMonth = currentMonth
                        year = currentYear
                        secondYear = currentYear
                        dismiss()
                    }) {
                        Text("Clear")
                    }.disabled(month == currentMonth && year == currentYear && secondMonth == currentMonth && secondYear == currentYear && type == "Monthly")
                }
                
            }
            .onAppear(perform: {
                let result = transactionData.formatDateBySpecific(date: Date.now)
                currentMonth = result.0
                currentYear = result.1
                years = transactionData.getYears()
                months = transactionData.allMonths
                getMonthIndex()
                getYearIndex()
            })
            .onDisappear(perform: {
                transactionData.updateCategoryValues(month: month, year: year, secondMonth: secondMonth, secondYear: secondYear, type: type)
                transactionData.getSlices()
            })
        }
    }
    
    func getMonthIndex() {
        var count = 0
        for month in months {
            if self.month == month {
                monthIndex = count
            } else {
                count+=1
            }
        }
    }
    
    func getYearIndex() {
        var count = 0
        for year in years {
            if self.year == year {
                yearIndex = count
            } else {
                count+=1
            }
        }
    }
}

struct SortDate_Previews: PreviewProvider {
    @State static var testType = "Monthly"
    @State static var testMonth = "January"
    @State static var testYear = "2022"
    
    static var previews: some View {
        SortDate(transactionData: TransactionModel(), type: $testType, month: $testMonth, year: $testYear, secondMonth: $testMonth, secondYear: $testYear)
    }
}
