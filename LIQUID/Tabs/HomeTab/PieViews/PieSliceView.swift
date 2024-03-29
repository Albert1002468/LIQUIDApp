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
                let width: CGFloat = min(geometry.size.width, geometry.size.height)
                let height = width
                
                let center = CGPoint(x: width * 0.5, y: height * 0.5)
                
                Path { path in
                    path.move(to: center)
                    
                    path.addArc(
                        center: center,
                        radius: width * 0.5,
                        startAngle: Angle(degrees: -90.0) + pieSlice.startAngle,
                        endAngle: Angle(degrees: -90.0) + pieSlice.endAngle,
                        clockwise: false)
                    
                }
                .fill(pieSlice.color)
                
                Path { path in
                    path.move(to: center)
                    
                    path.addArc(
                        center: center,
                        radius: width * 0.5,
                        startAngle: Angle(degrees: -90.0) + pieSlice.startAngle,
                        endAngle: Angle(degrees: -90.0) + pieSlice.endAngle,
                        clockwise: false)
                    
                }
                .stroke(Color(hue: 1.0, saturation: 0.0, brightness: 0.664), lineWidth: 1)

                if (pieSlice.endAngle-pieSlice.startAngle > Angle(degrees: 10.12)) {
                    Text(pieSlice.text)
                        .position (
                            x: geometry.size.width * 0.5 * CGFloat(1.0 + 0.78 * cos(self.midRadians)),
                            y: geometry.size.height * 0.5 * CGFloat(1.0 - 0.78 * sin(self.midRadians))
                        )
                        .font(Font.system(size: 12, weight: .semibold))
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)    }
}

struct PieSliceView_Previews: PreviewProvider {
    static var previews: some View {
        PieSliceView(pieSlice: testPieSlice)
    }
}
