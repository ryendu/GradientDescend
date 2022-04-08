//
//  File.swift
//  
//
//  Created by Ryan D on 4/7/22.
//

import Foundation
import SwiftUI

struct SimpleInteractiveGraph2DView: View {
    @Binding var cardIndex: Int
    var body: some View {
        ZStack {
            Grid(cardIndex: $cardIndex, config: GridConfig(xStepSize: 1, yStepSize: 1, xTotal: 10, yTotal: 10, yLabel: "Error", xLabel: "Model Parameter"), content: { help in
                ZStack {
                    Path { path in
                        //graphing x^2
                        path.move(to: CGPoint(x: 0, y: help.geo.size.height - 8 * help.yScale))
                        path.addQuadCurve(to: CGPoint(x: help.geo.size.width, y: help.geo.size.height -  8 * help.yScale), control: CGPoint(x: help.geo.size.width / 2, y: help.geo.size.height * 1.25))
                        
                    }.trim(from: 0, to: self.cardIndex > 0 ? 1 : 0)
                        
                        .stroke(Color("bg5"), lineWidth: 3)
                        
                        .animation(.easeIn(duration: 2), value: self.cardIndex)
                    
                    Circle()
                        .frame(width: 40, height: 40)
                        .opacity(self.cardIndex > 1 ? 1 : 0)
                        .animation(.default, value: self.cardIndex)
                }
            })
        }
    }
}

struct GridConfig: Hashable {
    var xStepSize: Double
    var yStepSize: Double
    var xTotal: Int
    var yTotal: Int
    var yLabel: String
    var xLabel: String
    
}

struct GridInfo {
    var xScale: Double
    var yScale: Double
    var origin: CGPoint
    var geo: GeometryProxy
}

struct Grid<Content:View>: View {
    
    @Binding var cardIndex: Int
    var config: GridConfig
    
    @ViewBuilder
    var content: (GridInfo) -> Content
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                Color("neutral100")
                
                // secondary lines
                Path { path in
                    let xStepLength = (geo.size.width) / CGFloat(config.xTotal)
                    let yStepLength = (geo.size.height) / CGFloat(config.yTotal)
                    
                    print(xStepLength)
                    print(yStepLength)
                    // x guide lines
                    for i in 0...config.xTotal {
                        path.move(to: CGPoint(x: CGFloat(0.0), y: geo.size.height - (yStepLength * CGFloat(i))))
                        path.addLine(to: CGPoint(x: geo.size.height, y: geo.size.height - (yStepLength * CGFloat(i))))
                    }
                    
                    // y guide lines
                    for i in 0...config.yTotal {
                        path.move(to: CGPoint(x: xStepLength * CGFloat(i), y: CGFloat(0.0)))
                        path.addLine(to: CGPoint(x: xStepLength * CGFloat(i), y: geo.size.height))
                        
                    }
                }
                .stroke(Color("neutral400"), lineWidth: 1)
                
                
                //main axises
                Path { path in
                    
                    // x axis
                    path.move(to: CGPoint(x: CGFloat(0), y: geo.size.height))
                    path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height))
                    
                    // y axis
                    path.move(to: CGPoint.zero)
                    path.addLine(to: CGPoint(x: 0, y: geo.size.height))
                    
                    
                }
                .stroke(.black, lineWidth: 2)
                
                //have the content
                content(GridInfo(xScale: Double(geo.size.width) / Double(config.xTotal), yScale:  Double(geo.size.height) / Double(config.yTotal), origin: CGPoint(x: 0.0, y: geo.size.height),geo:geo))
                
                
            }.onAppear {
                print("GRID SIZE: \(geo.size)")
            }
        }
    }
}
