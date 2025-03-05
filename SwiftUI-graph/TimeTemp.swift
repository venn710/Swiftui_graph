//
//  TimeTemp.swift
//  SwiftUI-graph
//
//  Created by Venkatesham Boddula on 05/03/25.
//

import Foundation
struct TimeTemp: Identifiable {
    let id = UUID()
    let time: String
    let temperature: Double
    
    static func getStaticData() -> [Self] {
        [
            TimeTemp(time: "12 AM", temperature: 35),
            TimeTemp(time: "1 AM", temperature: 34),
            TimeTemp(time: "2 AM", temperature: 33),
            TimeTemp(time: "3 AM", temperature: 36),
            TimeTemp(time: "4 AM", temperature: 37),
            TimeTemp(time: "5 AM", temperature: 38),
            TimeTemp(time: "6 AM", temperature: 39),
            TimeTemp(time: "7 AM", temperature: 40),
            TimeTemp(time: "8 AM", temperature: 40),
            TimeTemp(time: "9 AM", temperature: 40),
            TimeTemp(time: "10 AM", temperature: 36),
            TimeTemp(time: "11 AM", temperature: 35),
            TimeTemp(time: "12 PM", temperature: 34)
        ]
    }
}
