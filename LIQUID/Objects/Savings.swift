//
//  Ssvings.swift
//  LIQUID
//
//  Created by Alberto Dominguez Fernandez on 4/10/22.
//

import Foundation

struct Savings: Identifiable, Codable {
    var id = UUID()
    var amount: Double
    var completed: Double
    var desc: String
    var date: Date
    var saving: Double
    var active: Bool
    var previousAmountAdded: Double

}
