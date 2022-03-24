//
//  HomeTab.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/7/22.
//

import SwiftUI

struct HomeTab: View {
    @ObservedObject var transactionData: TransactionModel
    @Environment(\.colorScheme) var colorScheme
    var innerRadiusFraction = 0.6
    var body: some View {
            GeometryReader { geometry in
                ZStack {
                   // Image("Light Rain")
                   //     .resizable()
                   //     .ignoresSafeArea()
                VStack {
                    Text("LIQUID").font(.largeTitle)
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
                                .fill(colorScheme == .light ? Color.white : Color.black)
                                .frame(width: geometry.size.width * 0.8 * innerRadiusFraction, height: geometry.size.width * 0.8 * innerRadiusFraction)
                            //.shadow(color: .black, radius: 10)
                            
                            VStack {
                                Text(transactionData.formatCurrency(amount: transactionData.categoryExpenseValues.reduce(0, +)) + " /")
                                    .font(.largeTitle)
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                Text(transactionData.formatCurrency(amount: transactionData.categoryIncomeValues.reduce(0, +)))
                                    .font(.largeTitle)
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            }
                        }
                        Spacer()
                    }
                    ScrollView (showsIndicators: false) {
                        ForEach (0..<transactionData.filteredCategoryExpenseArray.count, id: \.self) { index in
                            PieChartRow(color: transactionData.colors[index], name: transactionData.filteredCategoryExpenseArray[index], value: transactionData.formatCurrency(amount: transactionData.categoryExpenseValues[index]), percent: transactionData.categoryExpenseValues[index] / getSum() * 100)
                        }.foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    }.padding()
                    
                }
                
                .onAppear(perform: {
                    transactionData.updateCategoryValues()
                    transactionData.getSlices()
                })
                .foregroundColor(Color.black)
            }
            }
            .navigationTitle("LIQUID")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "pencil.circle.fill")
                    }
                }
            }
        
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = UIColor.clear
            transactionData.updateCategoryValues()
            transactionData.getSlices()
        })
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
