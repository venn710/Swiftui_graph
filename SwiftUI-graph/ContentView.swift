//
//  ContentView.swift
//  SwiftUI-graph
//
//  Created by Venkatesham Boddula on 05/03/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TemperatureGraphView(data: TimeTemp.getStaticData(), backgroundColor: .white)
    }
}

#Preview {
    ContentView()
}
