//
//  TemperatureGraphView.swift
//  SwiftUI-graph
//
//  Created by Venkatesham Boddula on 05/03/25.
//

import SwiftUI

struct TemperatureGraphView: View {
    let data: [TimeTemp]
    let backgroundColor: Color
    
    @State private var selectedIndex: Int? = nil
    @State private var dragLocation: CGPoint = .zero
    
    @State private var animateGraph = false
    
    private var cardHeight: Double {
        150
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            let maxTemp = data.max(by: { $0.temperature < $1.temperature })?.temperature ?? 1
            let minTemp = data.min(by: { $0.temperature < $1.temperature })?.temperature ?? 0

            let width = geometry.size.width
            let chartHeight: CGFloat = 100
            let spacing: CGFloat = width / CGFloat(data.count - 1)
            
            let points = data.enumerated().map { index, entry in
                let x = CGFloat(index) * spacing
                let y =  getVerticalPosition(for: entry.temperature, in: chartHeight, minTemp: minTemp, maxTemp: maxTemp)// Normalising the temp. value between the range 0 to height given.
                return CGPoint(x: x, y: animateGraph ? y : chartHeight)
            }
            
            VStack(alignment: .center, spacing: 10) {
                ZStack {

                    SmoothLine(points: points)
                        .trim(from: 0, to: animateGraph ? 1 : 0)
                    
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(
                                    colors:
                                        data.map { temperatureColor(for: $0.temperature, minTemp: minTemp, maxTemp: maxTemp)
                                        }),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 2
                        )
                        .animation(.linear(duration: 1.2), value: animateGraph)
                    
                    if let selectedIndex = selectedIndex {
                        let selectedPoint = points[selectedIndex]
                        
                        Circle()
                            .fill(backgroundColor)
                            .frame(width: 20, height: 20)
                            .position(selectedPoint)
                            .overlay {
                                Image(systemName: "dot.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                    .foregroundStyle(temperatureColor(for: data[selectedIndex].temperature, minTemp: minTemp, maxTemp: maxTemp))
                                    .position(selectedPoint)
                            }
                            .animation(.linear, value: dragLocation)
                        
                        
                        Text("\(Int(data[selectedIndex].temperature))°")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(1)
                            .background(RoundedRectangle(cornerRadius: 5).fill(Color.white.opacity(0.7)))
                            .position(x: selectedPoint.x, y: selectedPoint.y - 20)
                        
                        Rectangle()
                            .stroke(LinearGradient(colors: [.black, .black.opacity(0.5), .black.opacity(0.1)], startPoint: .top, endPoint: .bottom), lineWidth: 1)
                            .frame(width: 1, height: max(chartHeight - selectedPoint.y - 10, 0))
                            .position(
                                x: selectedPoint.x,
                                y: (selectedPoint.y + (chartHeight -  selectedPoint.y + 10) / 2))
                            .animation(.linear, value: dragLocation)
                        
                        
                        
                        VStack {
                            Text(data[selectedIndex].time)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(1)
                                .background(
                                    RoundedRectangle(cornerRadius: 5).fill(Color.white.opacity(0.7)))

                                .animation(.linear, value: dragLocation)
                        }
                        .position(x: selectedPoint.x, y: chartHeight + 20)
                    
                        
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let nearestIndex = Int((value.location.x / spacing).rounded())
                            if nearestIndex >= 0 && nearestIndex < data.count {
                                if selectedIndex != nearestIndex {
                                        selectedIndex = nearestIndex
                                        dragLocation = value.location

                                    let generator = UIImpactFeedbackGenerator(style: .light)
                                    generator.impactOccurred()
                                }
                            }
                        }
                )
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    animateGraph = true
                    selectedIndex = ((data.count) / 2)
                }
            }
        }
        .padding()
        .background(backgroundColor)
    }
}


func getVerticalPosition(for temperature: Double, in height: Double, minTemp: Double, maxTemp: Double) -> Double {
    let tempRange = maxTemp - minTemp
    return height - ((CGFloat(temperature - minTemp) / CGFloat(tempRange)) * height)
}


/// Normalize between 0-1 Where 0 represents minTemp and 1 represents the maxTemp
/// - Parameters:
///   - temp: Current temp.
///   - minTemp: Mininum temperature from the list.
///   - maxTemp: Maximum temperature from the list.
/// - Returns: Color corresponding to the temperature range. like
///
///  If the Normalised value of the temp falls in range 0 to 0.3 then it'll return the Blue
///  If the Normalised value of the temp falls in range 0.3 to 0.6 then it'll return the Orange
///  If the Normalised value of the temp falls in range 0.6 to 1 then it'll return the Red
func temperatureColor(for temp: Double, minTemp: Double, maxTemp: Double) -> Color {
    
    let normalized = (temp - minTemp) / (maxTemp - minTemp)
    
    if normalized < 0.3 { // Temp is closer to the minimum.
        return Color.blue
    } else if normalized < 0.6 { // Temp is in the middle range.
        return Color.orange
    } else {
        return Color.red // Temp is closer to the maximum.
    }
}
