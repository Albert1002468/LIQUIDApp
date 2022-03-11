//
//  PieChartView.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/10/22.
//

import SwiftUI

struct PieChartView: View {
    @ObservedObject var transactionData: TransactionModel
    public var backgroundColor: Color
    public var innerRadiusFraction: CGFloat
    var body: some View {
        
        GeometryReader { geometry in
            HStack {
                Spacer()
                ZStack {
                    ForEach(transactionData.slices) { slice in
                        PieSliceView(pieSlice: slice)
                    }
                    .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                    
                    Circle()
                        .fill(self.backgroundColor)
                        .frame(width: geometry.size.width * 0.8 * innerRadiusFraction, height: geometry.size.width * 0.8 * innerRadiusFraction)
                    
                    VStack {
                        Text(transactionData.formatCurrency(amount: transactionData.categoryExpenseValues.reduce(0, +)) + " /")
                            .font(.title)
                        Text(transactionData.formatCurrency(amount: transactionData.categoryIncomeValues.reduce(0, +)))
                            .font(.title)
                    }
                }
                Spacer()
            }
            .onAppear(perform: {
                transactionData.updateCategoryValues()
                transactionData.getSlices()
            })
            .background(backgroundColor)
            .foregroundColor(Color.black)
        }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(transactionData: TransactionModel(), backgroundColor: Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 1.0), innerRadiusFraction: 0.6)
    }
}
