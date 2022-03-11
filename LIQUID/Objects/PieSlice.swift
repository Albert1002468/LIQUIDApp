//
//  PieSlice.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 3/11/22.
//

import Foundation
import SwiftUI

struct PieSlice: Identifiable {
    var id = UUID()
    var startAngle: Angle
    var endAngle: Angle
    var text: String
    var color: Color
}

#if DEBUG
let testPieSlice = PieSlice(startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 220.0), text: "65%", color: Color.black)
#endif
