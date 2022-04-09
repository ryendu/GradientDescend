//
//  File.swift
//  
//
//  Created by Ryan D on 4/7/22.
//

import Foundation
import SwiftUI
import IrregularGradient

struct SimpleInteractiveGraph2DView: View {
    @Binding var cardIndex: Int
    @Binding var xValue: Double
    var body: some View {
        ZStack {
            Grid(cardIndex: $cardIndex, config: GridConfig(xStepSize: 1, yStepSize: 1, xTotal: 10, yTotal: 10, yLabel: "Cost Function", xLabel: "Model Parameter"), content: { help in
                ZStack {
                    Path { path in
                        //graphing x^2
                        path.move(to: CGPoint(x: 0, y: 0))
//                        path.addQuadCurve(to: CGPoint(x: help.geo.size.width, y: help.geo.size.height -  8 * help.yScale), control: CGPoint(x: help.geo.size.width / 2, y: help.geo.size.height * 1.25))
                        path.addCurve(to: CGPoint(x: help.geo.size.width, y: 0), control1: CGPoint(x: help.geo.size.width / 4, y: help.geo.size.height * 1.25), control2: CGPoint(x: help.geo.size.width - help.geo.size.width / 4, y: help.geo.size.height * 1.25))
                        
                        
                    }.trim(from: 0, to: self.cardIndex > 0 ? 1 : 0)
                        
                        .stroke(Color("bg5"), lineWidth: 3)
                        
                        .animation(.easeIn(duration: 2), value: self.cardIndex)
                    
                    // at card index 1 get arbitrary starting point
                    Circle()
                        .frame(width: 25, height: 25)
                        .irregularGradient(colors: [Color("bg5"),Color("bg3"),Color("bg4")], backgroundColor: Color("bg4"))
                        .opacity(self.cardIndex > 1 ? 1 : 0)
                        .animation(.default, value: self.cardIndex)
                        .position(x: xValue * help.xScale, y: yOf(xValue * help.xScale, help: help))
                    
                    
//
                    //card index 2 take steps
                }
                .onChange(of: cardIndex, perform: {a in
                    
                })
            })
        }
    }
    func yOf(_ x: CGFloat, help: GridInfo) -> CGFloat {
        // p0 and p2 are end points of line
        // p1 is the control point
        // adapted from https://stackoverflow.com/a/16756481/13770657
        // equation for getting y point of an x point on a beizer cubic curve
        let control1 = CGPoint(x: help.geo.size.width / 4, y: help.geo.size.height * 1.25)
        let control2 = CGPoint(x: help.geo.size.width - help.geo.size.width / 4, y: help.geo.size.height * 1.25)
        let start = CGPoint(x: 0, y: 0)
        let end = CGPoint(x: 10 * help.xScale, y: 0)
        
        let T = x / help.geo.size.width
        let y0 = start.y
        let y1 = control1.y
        let y2 = control2.y
        let y3 = end.y
        
        let y_1 = (1-T) * (1-T) * (1-T) * y0
        let y_2 = 3 * T * (1-T) * (1-T) * y1
        let y_3 = 3 * T * T * (1-T)
        let y_4 = y2 + T * T * T * y3
        
        let y = y_1 + y_2 + y_3 * y_4
        
        print("y: \(y)")
        return y
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
                
                //labels
                
                ForEach(0...config.yTotal, id: \.self) { i in
                    Text(String(config.yStepSize * CGFloat(i)))
                        .font(.system(size:12))
                        .foregroundColor(Color("neutral300"))
                        .position(x: (geo.size.width) / CGFloat(config.xTotal) * CGFloat(i), y: geo.size.height + 13)
                }
                
                ForEach(0...config.xTotal, id: \.self) { i in
                    Text(String(config.xStepSize * CGFloat(i)))
                        .font(.system(size:12))
                        .foregroundColor(Color("neutral300"))
                        .position(x: -16, y: geo.size.height - ((geo.size.height) / CGFloat(config.yTotal) * CGFloat(i)))
                }
                
                //axis labels
                
                Text(config.xLabel)
                    .font(.system(size:14))
                    .foregroundColor(Color("neutral500"))
                    .position(x: (geo.size.width) / 2, y: geo.size.height + 29)
                
                Text(config.yLabel)
                    .font(.system(size:14))
                    .foregroundColor(Color("neutral500"))
                    .rotationEffect(Angle(degrees: 270))
                    .position(x: -33, y: geo.size.height / 2 )
                
                //have the content
                content(GridInfo(xScale: Double(geo.size.width) / Double(config.xTotal), yScale:  Double(geo.size.height) / Double(config.yTotal), origin: CGPoint(x: 0.0, y: geo.size.height),geo:geo))
                
                
            }
            .onAppear {
                print("GRID SIZE: \(geo.size)")
            }
        }
        .padding()
        .padding(.bottom)
    }
}
