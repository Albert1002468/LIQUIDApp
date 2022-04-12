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
    var completed = 0.0
    var desc: String
    var date: Date
    var note: String
    var saving: String

}
