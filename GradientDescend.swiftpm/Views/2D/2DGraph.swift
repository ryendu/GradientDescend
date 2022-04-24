//
//  File.swift
//  
//
//  Created by Ryan D on 4/7/22.
//

import Foundation
import SwiftUI
//import IrregularGradient

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
                    
                    getStepPath(help: help)
                        .trim(from: 0, to: self.cardIndex > 6 ? 1 : 0)
                        .stroke(.purple, lineWidth: 3)
                        .animation(.easeIn(duration: 3), value: self.cardIndex)
                    
                    
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
                    if a == 6 {
                        self.xValue = 0
                    } else if a == 7 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.xValue = 5
                        }
                        
                    }
                })
            })
        }
    }
    func getStepPath(help: GridInfo) -> Path{
        // step size
        //        let stepSize = CGPoint(x: 1 * help.xScale, y: 1 * help.yScale)
        let stepSize = 1.0
        let steps = 5
        
        var path = Path()
        
        for i in 0..<steps {
            let xStart = stepSize * Double(i) * help.xScale
            let xNext = xStart + help.xScale
            
            path.move(to: CGPoint(x: xStart, y: yOf(xStart, help: help)))
            
            path.addQuadCurve(to: CGPoint(x: xNext, y: yOf(xNext, help: help)), control: CGPoint(x: xNext + 1 * help.xScale, y: (yOf(xNext, help: help) + yOf(xStart, help: help)) / 2.0))
            
            //            path.addArc(center: CGPoint(x: xNext, y: yOf(xNext, help: help)), radius: stepSize * help.xScale, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 180), clockwise: true)
            //            path.addLine(to: CGPoint(x: xNext, y: yOf(xNext, help: help)))
            print("s \(xStart), c \(xNext), i \(i)")
            
        }
        
        return path
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

struct ComplexInteractiveGraph2DView: View {
    @Binding var cardIndex: Int
    @Binding var xValue: Double
    @Binding var learningRateIndx: Double
    @State var circlePosition = CGPoint.zero
    var body: some View {
        ZStack {
            Grid(cardIndex: $cardIndex, config: GridConfig(xStepSize: 1, yStepSize: 1, xTotal: 10, yTotal: 10, yLabel: "Cost Function", xLabel: "Model Parameter"), content: { help in
                ZStack {
                    
                    
                    complexFunctionPath(rect: CGRect(x: 0, y: help.yScale, width: help.geo.size.width, height: help.geo.size.height))
                        .trim(from: 0, to: self.cardIndex > 0 ? 1 : 0)
                        .stroke(Color("bg5"), lineWidth: 3)
                        .animation(.easeIn(duration: 2), value: self.cardIndex)
                        .offset(x: 0, y: help.yScale)
                    
                    
                    gradientDescentPath1(rect: CGRect(x: 0, y: 0, width: help.geo.size.width, height: help.geo.size.height))
                        .trim(from: 0, to: self.cardIndex > 1 && self.cardIndex < 3 ? 1 : 0)
                        .stroke(Color.accentColor, lineWidth: 3)
                        .animation(.easeIn(duration: 2.5), value: self.cardIndex)
                        .offset(x: 0, y: help.yScale * 2)
                    
                    gradientDescentLR_0001(rect: CGRect(x: 0, y: 0, width: help.geo.size.width, height: help.geo.size.height))
                        .trim(from: 0, to: self.cardIndex > 2 && self.cardIndex < 5 && learningRateIndx == 1.0 ? 1 : 0)
                        .stroke(Color.yellow, lineWidth: 3)
                        .animation(.easeIn(duration: 2.5), value: self.cardIndex)
                        .offset(x: 0, y: help.yScale * 2)
                    
                    gradientDescentLR_0005(rect: CGRect(x: 0, y: 0, width: help.geo.size.width, height: help.geo.size.height))
                        .trim(from: 0, to: self.cardIndex  > 2 && self.cardIndex < 5 && learningRateIndx == 2.0 ? 1 : 0)
                        .stroke(Color.orange, lineWidth: 3)
                        .animation(.easeIn(duration: 2.5), value: self.cardIndex)
                        .offset(x: 0, y: help.yScale * 2)
                    
                    gradientDescentLR_001(rect: CGRect(x: 0, y: 0, width: help.geo.size.width, height: help.geo.size.height))
                        .trim(from: 0, to: self.cardIndex > 2 && self.cardIndex < 5 && learningRateIndx == 3.0 ? 1 : 0)
                        .stroke(Color.red, lineWidth: 3)
                        .animation(.easeIn(duration: 2.5), value: self.cardIndex)
                        .offset(x: 0, y: help.yScale * 2)
                    
                    gradientDescentLR_01(rect: CGRect(x: 0, y: 0, width: help.geo.size.width, height: help.geo.size.height))
                        .trim(from: 0, to: self.cardIndex > 2 && self.cardIndex < 5 && learningRateIndx == 4.0 ? 1 : 0)
                        .stroke(Color.pink, lineWidth: 3)
                        .animation(.easeIn(duration: 2.5), value: self.cardIndex)
                        .offset(x: 0, y: help.yScale * 2)
                    
                    gradientDescentLR_1(rect: CGRect(x: 0, y: 0, width: help.geo.size.width, height: help.geo.size.height))
                        .trim(from: 0, to: self.cardIndex > 2 && self.cardIndex < 5 && learningRateIndx == 5.0 ? 1 : 0)
                        .stroke(Color.green, lineWidth: 3)
                        .animation(.easeIn(duration: 2.5), value: self.cardIndex)
                        .offset(x: 0, y: help.yScale * 2)
                    
                    Circle()
                        .frame(width: 25, height: 25)
                        .irregularGradient(colors: [Color("bg5"),Color("bg3"),Color("bg4")], backgroundColor: Color("bg4"))
                        .opacity(self.cardIndex > 1 && self.cardIndex < 3 ? 1 : 0)
                        .animation(.default, value: self.cardIndex)
                        .position(x: circlePosition.x, y: circlePosition.y)
                    
                    
                    //
                    //card index 2 take steps
                }
                .onAppear {
                    circlePosition = CGPoint(x: 0, y: help.yScale * 2)
                }
                .onChange(of: cardIndex, perform: {a in
                    if a == 1 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.circlePosition = CGPoint(x: 2 * help.xScale, y: 5 * help.yScale)
                        }
                    }
                })
            })
        }
    }
    func complexFunctionPath(rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.00458*width, y: 0.10345*height))
        path.addCurve(to: CGPoint(x: 0.29977*width, y: 0.33699*height), control1: CGPoint(x: 0.03585*width, y: 0.23616*height), control2: CGPoint(x: 0.15203*width, y: 0.53135*height))
        path.addCurve(to: CGPoint(x: 0.79748*width, y: 0.33699*height), control1: CGPoint(x: 0.46933*width, y: 0.11393*height), control2: CGPoint(x: 0.51165*width, y: 1.0337*height))
        path.addCurve(to: CGPoint(x: 1.00114*width, y: 0.00313*height), control1: CGPoint(x: 0.85278*width, y: 0.20219*height), control2: CGPoint(x: 0.93936*width, y: -0.00235*height))
        return path
    }
    
    func gradientDescentPath1(rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.00343*width, y: 0.00157*height))
        path.addCurve(to: CGPoint(x: 0.04691*width, y: 0.12853*height), control1: CGPoint(x: 0.03242*width, y: 0.01019*height), control2: CGPoint(x: 0.08169*width, y: 0.04765*height))
        path.addCurve(to: CGPoint(x: 0.09153*width, y: 0.21787*height), control1: CGPoint(x: 0.07666*width, y: 0.13427*height), control2: CGPoint(x: 0.12723*width, y: 0.16019*height))
        path.addCurve(to: CGPoint(x: 0.12357*width, y: 0.25627*height), control1: CGPoint(x: 0.11289*width, y: 0.21447*height), control2: CGPoint(x: 0.1492*width, y: 0.2174*height))
        path.addCurve(to: CGPoint(x: 0.15217*width, y: 0.2837*height), control1: CGPoint(x: 0.14035*width, y: 0.25418*height), control2: CGPoint(x: 0.17231*width, y: 0.25549*height))
        path.addCurve(to: CGPoint(x: 0.18879*width, y: 0.29859*height), control1: CGPoint(x: 0.16629*width, y: 0.27952*height), control2: CGPoint(x: 0.19336*width, y: 0.27665*height))
        return path
    }
    
    func gradientDescentLR_0001(rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.00229*width, y: 0.00157*height))
        path.addCurve(to: CGPoint(x: 0.02517*width, y: 0.0815*height), control1: CGPoint(x: 0.03166*width, y: 0.01358*height), control2: CGPoint(x: 0.07735*width, y: 0.04639*height))
        path.addCurve(to: CGPoint(x: 0.04577*width, y: 0.13245*height), control1: CGPoint(x: 0.04996*width, y: 0.08333*height), control2: CGPoint(x: 0.08879*width, y: 0.09608*height))
        path.addCurve(to: CGPoint(x: 0.06064*width, y: 0.16458*height), control1: CGPoint(x: 0.0656*width, y: 0.13218*height), control2: CGPoint(x: 0.09634*width, y: 0.13824*height))
        path.addCurve(to: CGPoint(x: 0.07437*width, y: 0.19044*height), control1: CGPoint(x: 0.07857*width, y: 0.16432*height), control2: CGPoint(x: 0.10641*width, y: 0.16912*height))
        path.addCurve(to: CGPoint(x: 0.08352*width, y: 0.20846*height), control1: CGPoint(x: 0.09001*width, y: 0.18757*height), control2: CGPoint(x: 0.11373*width, y: 0.18715*height))
        path.addCurve(to: CGPoint(x: 0.09497*width, y: 0.22414*height), control1: CGPoint(x: 0.09878*width, y: 0.20585*height), control2: CGPoint(x: 0.12243*width, y: 0.20533*height))
        path.addCurve(to: CGPoint(x: 0.10526*width, y: 0.23824*height), control1: CGPoint(x: 0.10679*width, y: 0.22257*height), control2: CGPoint(x: 0.1254*width, y: 0.2232*height))
        path.addCurve(to: CGPoint(x: 0.11556*width, y: 0.25078*height), control1: CGPoint(x: 0.11556*width, y: 0.23772*height), control2: CGPoint(x: 0.13204*width, y: 0.2395*height))
        path.addCurve(to: CGPoint(x: 0.12243*width, y: 0.2594*height), control1: CGPoint(x: 0.12357*width, y: 0.24974*height), control2: CGPoint(x: 0.13616*width, y: 0.25*height))
        path.addCurve(to: CGPoint(x: 0.13043*width, y: 0.26881*height), control1: CGPoint(x: 0.13005*width, y: 0.25888*height), control2: CGPoint(x: 0.14233*width, y: 0.26003*height))
        path.addCurve(to: CGPoint(x: 0.14073*width, y: 0.27743*height), control1: CGPoint(x: 0.13844*width, y: 0.26829*height), control2: CGPoint(x: 0.15172*width, y: 0.26928*height))
        path.addCurve(to: CGPoint(x: 0.15103*width, y: 0.28448*height), control1: CGPoint(x: 0.1476*width, y: 0.27691*height), control2: CGPoint(x: 0.15927*width, y: 0.27759*height))
        path.addCurve(to: CGPoint(x: 0.16133*width, y: 0.28997*height), control1: CGPoint(x: 0.15637*width, y: 0.28292*height), control2: CGPoint(x: 0.1659*width, y: 0.28182*height))
        path.addCurve(to: CGPoint(x: 0.17277*width, y: 0.29467*height), control1: CGPoint(x: 0.16743*width, y: 0.2884*height), control2: CGPoint(x: 0.17826*width, y: 0.28715*height))
        path.addCurve(to: CGPoint(x: 0.18192*width, y: 0.29781*height), control1: CGPoint(x: 0.17696*width, y: 0.29258*height), control2: CGPoint(x: 0.18467*width, y: 0.29028*height))
        path.addCurve(to: CGPoint(x: 0.19222*width, y: 0.30016*height), control1: CGPoint(x: 0.18535*width, y: 0.29598*height), control2: CGPoint(x: 0.19222*width, y: 0.29389*height))
        path.addCurve(to: CGPoint(x: 0.20137*width, y: 0.30016*height), control1: CGPoint(x: 0.19451*width, y: 0.29754*height), control2: CGPoint(x: 0.19954*width, y: 0.29389*height))
        return path
    }
    
    func gradientDescentLR_0005(rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.00343*width, y: 0.00157*height))
        path.addCurve(to: CGPoint(x: 0.04691*width, y: 0.12853*height), control1: CGPoint(x: 0.03242*width, y: 0.01019*height), control2: CGPoint(x: 0.08169*width, y: 0.04765*height))
        path.addCurve(to: CGPoint(x: 0.09153*width, y: 0.21787*height), control1: CGPoint(x: 0.07666*width, y: 0.13427*height), control2: CGPoint(x: 0.12723*width, y: 0.16019*height))
        path.addCurve(to: CGPoint(x: 0.12357*width, y: 0.25627*height), control1: CGPoint(x: 0.11289*width, y: 0.21447*height), control2: CGPoint(x: 0.1492*width, y: 0.2174*height))
        path.addCurve(to: CGPoint(x: 0.15217*width, y: 0.2837*height), control1: CGPoint(x: 0.14035*width, y: 0.25418*height), control2: CGPoint(x: 0.17231*width, y: 0.25549*height))
        path.addCurve(to: CGPoint(x: 0.18879*width, y: 0.29859*height), control1: CGPoint(x: 0.16629*width, y: 0.27952*height), control2: CGPoint(x: 0.19336*width, y: 0.27665*height))
        return path
    }
    
    func gradientDescentLR_001(rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.00229*width, y: 0.00235*height))
        path.addCurve(to: CGPoint(x: 0.05492*width, y: 0.15596*height), control1: CGPoint(x: 0.04805*width, y: 0.02247*height), control2: CGPoint(x: 0.12265*width, y: 0.08135*height))
        path.addCurve(to: CGPoint(x: 0.11556*width, y: 0.25*height), control1: CGPoint(x: 0.08734*width, y: 0.157*height), control2: CGPoint(x: 0.16041*width, y: 0.19295*height))
        path.addCurve(to: CGPoint(x: 0.15904*width, y: 0.28997*height), control1: CGPoint(x: 0.14493*width, y: 0.2466*height), control2: CGPoint(x: 0.17391*width, y: 0.25*height))
        path.addCurve(to: CGPoint(x: 0.19908*width, y: 0.29859*height), control1: CGPoint(x: 0.17124*width, y: 0.28135*height), control2: CGPoint(x: 0.19634*width, y: 0.271*height))
        return path
    }
    
    func gradientDescentLR_01(rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.00343*width, y: 0.00235*height))
        path.addCurve(to: CGPoint(x: 0.74943*width, y: 0.33386*height), control1: CGPoint(x: 0.26049*width, y: 0.00078*height), control2: CGPoint(x: 0.76957*width, y: 0.06489*height))
        path.addCurve(to: CGPoint(x: 0.41076*width, y: 0.24216*height), control1: CGPoint(x: 0.72121*width, y: 0.27769*height), control2: CGPoint(x: 0.61396*width, y: 0.18072*height))
        path.addCurve(to: CGPoint(x: 0.71968*width, y: 0.38401*height), control1: CGPoint(x: 0.50725*width, y: 0.24895*height), control2: CGPoint(x: 0.70412*width, y: 0.28683*height))
        path.addCurve(to: CGPoint(x: 0.49542*width, y: 0.39655*height), control1: CGPoint(x: 0.68459*width, y: 0.34875*height), control2: CGPoint(x: 0.59062*width, y: 0.30188*height))
        path.addCurve(to: CGPoint(x: 0.67735*width, y: 0.44984*height), control1: CGPoint(x: 0.55416*width, y: 0.38819*height), control2: CGPoint(x: 0.67277*width, y: 0.38715*height))
        path.addCurve(to: CGPoint(x: 0.56407*width, y: 0.48589*height), control1: CGPoint(x: 0.64684*width, y: 0.43939*height), control2: CGPoint(x: 0.58146*width, y: 0.43197*height))
        return path
    }
    
    func gradientDescentLR_1(rect: CGRect) -> Path {
        var path = Path()
                let width = rect.size.width
                let height = rect.size.height
                path.move(to: CGPoint(x: 0.00343*width, y: 0.13323*height))
                path.addCurve(to: CGPoint(x: 0.93936*width, y: 0.06975*height), control1: CGPoint(x: 0.13654*width, y: 0.05068*height), control2: CGPoint(x: 0.51007*width, y: -0.07759*height))
                path.addCurve(to: CGPoint(x: 0.03318*width, y: 0.23041*height), control1: CGPoint(x: 0.71625*width, y: 0.03918*height), control2: CGPoint(x: 0.22265*width, y: 0.02853*height))
                path.addCurve(to: CGPoint(x: 0.81465*width, y: 0.30486*height), control1: CGPoint(x: 0.22922*width, y: 0.17085*height), control2: CGPoint(x: 0.65995*width, y: 0.10235*height))
                path.addCurve(to: CGPoint(x: 0.127*width, y: 0.38793*height), control1: CGPoint(x: 0.65522*width, y: 0.2662*height), control2: CGPoint(x: 0.29451*width, y: 0.22868*height))
                path.addCurve(to: CGPoint(x: 0.85584*width, y: 0.22179*height), control1: CGPoint(x: 0.22731*width, y: 0.24843*height), control2: CGPoint(x: 0.5135*width, y: 0.01991*height))
                path.addCurve(to: CGPoint(x: 0.42792*width, y: 0.3989*height), control1: CGPoint(x: 0.754*width, y: 0.21891*height), control2: CGPoint(x: 0.52586*width, y: 0.25031*height))
                path.addCurve(to: CGPoint(x: 0.74943*width, y: 0.45611*height), control1: CGPoint(x: 0.53509*width, y: 0.34613*height), control2: CGPoint(x: 0.74943*width, y: 0.2837*height))
                path.addCurve(to: CGPoint(x: 0.3524*width, y: 0.32994*height), control1: CGPoint(x: 0.71014*width, y: 0.3861*height), control2: CGPoint(x: 0.57574*width, y: 0.26285*height))
                path.addCurve(to: CGPoint(x: 0.83982*width, y: 0.25549*height), control1: CGPoint(x: 0.38291*width, y: 0.26541*height), control2: CGPoint(x: 0.52311*width, y: 0.16019*height))
                path.addCurve(to: CGPoint(x: 0.46911*width, y: 0.48119*height), control1: CGPoint(x: 0.76316*width, y: 0.25575*height), control2: CGPoint(x: 0.58169*width, y: 0.30125*height))
                return path
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
                        path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height - (yStepLength * CGFloat(i))))
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
