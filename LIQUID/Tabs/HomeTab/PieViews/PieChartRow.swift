//
//  PieChartRow.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/10/22.
//

import SwiftUI

struct PieChartRow: View {
    var color: Color
    var name: String
    var value: String
    var percent: String
    
    var body: some View {
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(color)
                    .frame(width: 20, height: 20)
                Text(name)
                Spacer()
                VStack(alignment: .trailing) {
                    Text(value)
                    Text(percent)
                        .foregroundColor(Color.black)
                }
            }
        }
    }
}

struct PieChartRow_Previews: PreviewProvider {
    static var previews: some View {
        PieChartRow(color: Color.blue, name: "Food", value: "$5.00", percent: "5%")
    }
}
