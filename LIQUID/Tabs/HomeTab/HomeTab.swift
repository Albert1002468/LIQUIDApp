//
//  HomeTab.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import SwiftUI

struct HomeTab: View {
    @ObservedObject var transactionData: TransactionModel
    @State var openSort = false
    var innerRadiusFraction = 0.6
    @State var sortType = "Monthly"
    @State var month = ""
    @State var year = ""
    @State var secondMonth = ""
    @State var secondYear = ""
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                     Image("Light Rain")
                         .resizable()
                         .ignoresSafeArea()
                    VStack {
                        HStack {
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Color("TiffanyBlue"))
                                    .frame(width: geometry.size.width * 1.3 * innerRadiusFraction, height: geometry.size.width * 1.3 * innerRadiusFraction)
                                    .shadow(color: transactionData.categoryExpenseValues.reduce(0, +) > transactionData.categoryIncomeValues.reduce(0, +) ? .red : Color("TiffanyBlue"), radius: 50)
                                
                                ForEach(transactionData.slices) { slice in
                                    PieSliceView(pieSlice: slice)
                                }
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                                
                                Circle()
                                    .fill(Color(UIColor.systemBackground))
                                    .frame(width: geometry.size.width * 0.8 * innerRadiusFraction, height: geometry.size.width * 0.8 * innerRadiusFraction)
                                //.shadow(color: .black, radius: 10)
                                
                                
                                Circle()
                                    .fill(.white)
                                    .frame(width: geometry.size.width * 0.8 * innerRadiusFraction, height: geometry.size.width * 0.8 * innerRadiusFraction)
                                //.shadow(color: .black, radius: 10)
                                
                                VStack {
                                    Text(transactionData.formatCurrency(amount: transactionData.categoryExpenseValues.reduce(0, +)) + " /")
                                        .font(.largeTitle)
                                    Text(transactionData.formatCurrency(amount: transactionData.categoryIncomeValues.reduce(0, +)))
                                        .font(.largeTitle)
                                }
                            }
                            Spacer()
                        }
                        //ScrollView (showsIndicators: false) {
                        List {
                            ForEach (0..<transactionData.filteredCategoryExpenseArray.count, id: \.self) { index in
                                PieChartRow(color: transactionData.colors[index], name: transactionData.filteredCategoryExpenseArray[index], value: transactionData.formatCurrency(amount: transactionData.categoryExpenseValues[index]), percent: transactionData.categoryExpenseValues[index] / getSum() * 100).listRowSeparator(.hidden)
                            }.listRowBackground(Color.white.opacity(0.8))

                       // }.padding()
                        }
                    }
                }
            }
            .navigationTitle("LIQUID")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.openSort.toggle()
                    }) {
                        Image(systemName: "list.bullet")
                        
                    }.sheet(isPresented: $openSort, content: {
                        SortDate(transactionData: transactionData, type: $sortType, month: $month, year: $year, secondMonth: $secondMonth, secondYear: $secondYear)
                    } )
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    NavigationLink(destination: SavingsView(transactionData: transactionData)) {
                            Text("Savings")
                    }
                }
            }
            .onAppear(perform: {
                let result = transactionData.formatDateBySpecific(date: Date.now)
                month = result.0
                year = result.1
                secondMonth = month
                secondYear = year
                transactionData.updateCategoryValues(month: month, year: year, secondMonth: secondMonth, secondYear: secondYear, type: sortType)
                //transactionData.updateCategoryValues()
                transactionData.getSlices()
            })
        }
    }
    
    func getSum() -> Double{
        var sum = 0.0
        if transactionData.categoryIncomeValues.reduce(0, +) >= transactionData.categoryExpenseValues.reduce(0, +) {
            sum = transactionData.categoryIncomeValues.reduce(0, +)
        } else {
            sum = transactionData.categoryExpenseValues.reduce(0, +)
        }
        return sum
    }
}


struct HomeTab_Previews: PreviewProvider {
    static var previews: some View {
        HomeTab(transactionData: TransactionModel())
    }
}
