//
//  SmoothLine.swift
//  SwiftUI-graph
//
//  Created by Venkatesham Boddula on 05/03/25.
//

import SwiftUI

struct SmoothLine: Shape {
    var points: [CGPoint]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard points.count > 1 else { return path }
        
        path.move(to: points.first!)
        
        for i in 1..<points.count {
            let current = points[i]
            path.addLine(to: current)
        }
        
        return path
    }
}
