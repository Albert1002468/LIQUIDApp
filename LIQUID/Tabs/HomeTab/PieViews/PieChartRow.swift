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
    var percent: Double
    
    var body: some View {
        HStack {
            VStack (spacing: 1) {
                HStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(color)
                        .frame(width: 20, height: 20)
                    Text(name)
                        .font(.headline)
                        .lineLimit(1)
                    Spacer()
                    Text(value)
                        .font(.headline)
                        .lineLimit(1)
                        .frame(alignment: .trailing)
                }
                HStack {
                Text("")
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.7, height: 5)
                    .background(
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .foregroundColor(Color("TiffanyBlue"))
                                    .frame(width: geometry.size.width * percent * 0.01, height: geometry.size.height)
                                Capsule()
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            }
                        }
                    )
                    .clipShape(Capsule())

                Spacer()
                    Text("\(percent, specifier: "%.0f%%")")
                    .font(.footnote)
                    .lineLimit(1)
                    .frame(alignment: .trailing)
                }
            }
        }
    }
}

struct PieChartRow_Previews: PreviewProvider {
    static var previews: some View {
        PieChartRow(color: Color.blue, name: "Food", value: "$5.00", percent: 0.5)
    }
}
