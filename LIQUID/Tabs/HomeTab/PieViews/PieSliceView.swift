//
//  PieSliceView.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/10/22.
//

import SwiftUI

struct PieSliceView: View {
    var pieSlice: PieSlice
    var midRadians: Double {
        return Double.pi / 2.0 - (pieSlice.startAngle + pieSlice.endAngle).radians / 2.0
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let width: CGFloat = min(geometry.size.width, geometry.size.height)
                    let height = width
                    
                    let center = CGPoint(x: width * 0.5, y: height * 0.5)
                    
                    path.move(to: center)
                    
                    path.addArc(
                        center: center,
                        radius: width * 0.5,
                        startAngle: Angle(degrees: -90.0) + pieSlice.startAngle,
                        endAngle: Angle(degrees: -90.0) + pieSlice.endAngle,
                        clockwise: false)
                    
                }
                .fill(pieSlice.color)
                
                Text(pieSlice.text)
                    .position(
                        x: geometry.size.width * 0.5 * CGFloat(1.0 + 0.78 * cos(self.midRadians)),
                        y: geometry.size.height * 0.5 * CGFloat(1.0 - 0.78 * sin(self.midRadians))
                    )
                    .foregroundColor(Color.black)
            }
        }
        .aspectRatio(1, contentMode: .fit)    }
}

struct PieSliceView_Previews: PreviewProvider {
    static var previews: some View {
        PieSliceView(pieSlice: testPieSlice)
    }
}
