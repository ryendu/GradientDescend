//
//  File.swift
//  GradientDescend
//
//  Created by Ryan D on 4/5/22.
//

import Foundation
import SwiftUI
//import IrregularGradient

struct OnboardingView: View {
    
    @Binding var finishedOnboarding: Bool
    
    @State var geo: GeometryProxy?
    
    @State var bubbles: [Bubble] = []
    
    @State var expandOverlay = false
    @State var reshrinkOverlay = false
    @State var hideContent = false
    
    @State var animateOnScreen = false
    
    @State var animateGridX = false
    @State var animateGridY = false
    var body: some View {
        ZStack{
            //white background
            VStack{
                Spacer()
                HStack {
                    Spacer()
                    Color.white
                    Spacer()
                }
                Spacer()
            }
            //bubbles
            Group {
                if self.bubbles.count > 0 {
                    ForEach(self.bubbles, id:\.self) {bub in
                        Circle()
                            .fill(
                                LinearGradient(colors: [bub.color1, bub.color2], startPoint: .top, endPoint: .bottomTrailing)
                            )
                            .frame(width: bub.x, height: bub.y)
                            .offset(x:bub.offsetX, y:bub.offsetY)
                            .transition(.scale)
                    }
                }
            }
            
            Path { path in
                guard let geo = geo else { return }
                let stepLength = (geo.size.width) / 12
                let yTotal = Int(round(geo.size.width / stepLength))
               
                
                // y guide lines
                for i in 0...yTotal {
                    path.move(to: CGPoint(x: stepLength * CGFloat(i), y: CGFloat(0.0)))
                    path.addLine(to: CGPoint(x: stepLength * CGFloat(i), y: geo.size.height))
                    
                }
            }
            .trim(from: 0, to: self.animateGridY ? 1 : 0)
            .stroke(Color("neutral400"), lineWidth: 1)
            .animation(.easeInOut(duration: 4), value: self.animateGridY)
            
            Path { path in
                guard let geo = geo else { return }
                let stepLength = (geo.size.width) / 12
                let xTotal = Int(round(geo.size.height / stepLength))
                
                // x guide lines
                for i in 0...xTotal {
                    path.move(to: CGPoint(x: CGFloat(0.0), y: geo.size.height - (stepLength * CGFloat(i))))
                    path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height - (stepLength * CGFloat(i))))
                }
            }
            .trim(from: 0, to: self.animateGridX ? 1 : 0)
            .stroke(Color("neutral400"), lineWidth: 1)
            .animation(.easeOut(duration: 4), value: self.animateGridX)
           
            
            //content
            VStack {
                    VStack {
                        Spacer()
                        VStack {
                            
                            
                        Text("Gradient")
                                .font(.system(size: 80).bold().monospaced())
                            
                            .offset(x: self.animateOnScreen ? 0 : 300)
                            .opacity(self.animateOnScreen ? 1 : 0)
                            .animation(.easeInOut(duration: 1), value: self.animateOnScreen)
                            .irregularGradient(colors: [Color("gd1-1"), Color("gd1-2"), Color("gd1-3"), Color("gd1-4"), Color("gd1-5")], backgroundColor: .white, speed: 2)
                        
                        Text("Descent")
                                .font(.system(size: 80).bold().monospaced())
                            
                                .bold()
                                .offset(x: self.animateOnScreen ? 0 : 300)
                                .opacity(self.animateOnScreen ? 1 : 0)
                                .animation(.easeInOut(duration: 1), value: self.animateOnScreen)
                                .irregularGradient(colors: [Color("gd1-1"), Color("gd1-2"), Color("gd1-3"), Color("gd1-4"), Color("gd1-5")], backgroundColor: .white, speed: 2)
                        }
                        
                        
                        Text("(An algorithm for training and optimizing neural networks)")
                            .font(.system(size: 18).monospaced())
                            
                            .offset(x: self.animateOnScreen ? 0 : -300)
                            .opacity(self.animateOnScreen ? 1 : 0)
                            .animation(.easeInOut(duration: 1), value: self.animateOnScreen)
                            .padding(.top, 3)
                        
                        Spacer()
                    }
                    Spacer()
                
                Text("Tap Anywhere to Start")
                    .font(.system(size: 25).monospaced())
                    .offset(y: self.animateOnScreen ? 0 : -30)
                    .animation(.spring(), value: self.animateOnScreen)
                    .padding()
                    .padding()
                Spacer()
            }
            if self.hideContent {
                Color.white
            }
        }
        .background(GeometryReader { geo in
            Text("")
                .onAppear(perform: {
                    self.geo = geo
                })
        })
        .overlay(
            ZStack {
            Circle()
                .fill(
                    LinearGradient(colors: [Color("bg3"),Color("bg4")], startPoint: .top, endPoint: .bottomTrailing)
                )
                .opacity(self.reshrinkOverlay ? 0 : 1)
                .frame(width: self.expandOverlay ? 2000 : 0, height: self.expandOverlay ? 2000 : 0)
                .transition(.scale)
                .animation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 1), value: self.expandOverlay)
                .offset(x: 0, y: self.reshrinkOverlay ? (geo?.size.height ?? 100) / -2 + 100  : 0)
                .edgesIgnoringSafeArea(.all)
            
                Circle()
                    .frame(width: 1500, height: 1500)
                    .foregroundColor(.white)
                    .opacity(self.reshrinkOverlay ? 1 : 0)
                    .animation(.easeInOut(duration: 1), value: self.reshrinkOverlay)
                    .edgesIgnoringSafeArea(.all)
            }
            
        )
        .onTapGesture {
            if self.animateGridY {

                withAnimation(.spring()) {
                    for _ in 0...200 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.2...2)) {
                            addBubble()
                        }
                    }
                }
                //            expand a big gradient and then cool off into white and next slide!


                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.expandOverlay = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.bubbles = []
                    self.hideContent = true
                    self.reshrinkOverlay = true
                    self.expandOverlay = false
                }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        self.finishedOnboarding = true

                    }
            }

        }
        .onAppear {
            withAnimation() {
                self.animateOnScreen = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                withAnimation() {
                    self.animateGridX = true
                }
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                withAnimation() {
                    self.animateGridY = true
                }
            })
            
        }
    }
    func randomRainbowColor() -> Color {
        let colors: [Color] = [Color("bg2"),Color("bg3"),Color("bg4")]
        return colors.randomElement()!
    }
    func randomOffset() -> Double {
        return Double.random(in: -800...800)
    }
    func addBubble() {
        withAnimation(.spring(
            response: 0.7,
            dampingFraction: 0.5,
            blendDuration: 0.9
        )) {
            self.bubbles.append(Bubble(offsetX: randomOffset(), offsetY: randomOffset(), color1: randomRainbowColor(), color2: randomRainbowColor(),x:80*Double.random(in: 2...5),y:80*Double.random(in: 2...5)))
        }
    }
}
