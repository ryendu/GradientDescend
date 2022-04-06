//
//  File.swift
//  GradientDescend
//
//  Created by Ryan D on 4/5/22.
//

import Foundation
import SwiftUI
import IrregularGradient
import Neumorphic

enum MainView {
    case learnView
    case gameView
    case aboutView
}


struct TabView: View {
    @State var zoomedOut = false
    @State var offset = CGSize.zero
    @State var selectedView: MainView = .learnView
    @State var geo: GeometryProxy?
    
    @State var learnOffset = CGSize.zero
    @State var gameOffset = CGSize.zero
    @State var aboutOffset = CGSize.zero
    
    @State var learnFrame = CGSize.zero
    @State var gameFrame = CGSize.zero
    @State var aboutFrame = CGSize.zero
    
    @State var dragCurrentTranslation = CGSize.zero
    
    var body: some View {
        
        
            // stack the zoomed out background behind at all times
            ZStack (alignment: .center){
                
                //background
                Rectangle()
                    .irregularGradient(colors: [Color("bg1"),Color("bg2"),Color("bg5"),Color("bg3"),Color("bg4")], backgroundColor: Color("bg4"))
                    .scaledToFill()
                    .ignoresSafeArea()
                    .gesture(
                        DragGesture()
                            .onChanged { ges in
                                self.dragCurrentTranslation = ges.translation
                            }
                            .onEnded { ges in
                                
                            }
                    )
                
                
                GameView()
                    .displayContainerHelper(selectedView: self.$selectedView, zoomedOut: self.$zoomedOut, viewType: .gameView, geo: $geo, dragCurrentTranslation: self.$dragCurrentTranslation)
                
                AboutView()
                    .displayContainerHelper(selectedView: self.$selectedView, zoomedOut: self.$zoomedOut, viewType: .aboutView, geo: $geo, dragCurrentTranslation: self.$dragCurrentTranslation)

                LearnView()
                    .displayContainerHelper(selectedView: self.$selectedView, zoomedOut: self.$zoomedOut, viewType: .learnView, geo: $geo, dragCurrentTranslation: self.$dragCurrentTranslation)
         
                VStack {
                    //views do like a circle carousel
                    
                    //switcher
                    Spacer()
                    HStack {
                        Text("heres a switcher lol")
                    }
                }
            }.onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.zoomOut()
                })
            }
            .background(GeometryReader { geo in
                Text("")
                    .onAppear(perform: {
                        self.geo = geo
                    })
            })
        
        
    }
    func zoomIn() {
        self.zoomedOut = false
    }
    
    func zoomOut() {
        withAnimation(.spring()) {
            self.zoomedOut = true
        }
        
    }
}



/// helps display container correctly display and animate when zoomed out
struct DisplayContainerHelper: ViewModifier{
    @Binding var selectedView: MainView
    @Binding var zoomedOut: Bool
    var viewType: MainView
    @Binding var geo: GeometryProxy?
    @Binding var dragCurrentTranslation: CGSize
    // next position pos and next position neg are just the next default preset positions that the view will slide to on its right(pos) or left(neg) side
    @State var nextPositionPos = CGSize.zero
    @State var nextPositionNeg = CGSize.zero
    @State var currentDefaultOffset = CGSize.zero
    
    func body(content: Content) -> some View {
        ZStack (alignment:.center) {
            Color.white
            content
                .if(self.selectedView == viewType) { $0.zIndex(1) }
        }
        
        .frame(width: self.viewSize().width, height: self.viewSize().height)
        
        .cornerRadius(zoomedOut ? 18 : 0)
        .padding(11)
        .background(zoomedOut ? Color("deviceFrame") : Color.white.opacity(0))
        .softOuterShadow()
        .cornerRadius(zoomedOut ? 24 : 0)
        .offset(x: (self.zoomedOut && self.selectedView != viewType && (viewType == (self.selectedView == .gameView ? .learnView : .gameView))) ? -490 : 0, y: self.zoomedOut && self.selectedView != viewType ? -65 : 0 )
        .offset(x: (self.zoomedOut && self.selectedView != viewType && (viewType == (self.selectedView == .aboutView ? .learnView : .aboutView))) ? 490 : 0, y: self.zoomedOut && self.selectedView != viewType ? -65 : 0  )
        
        //now for the drag offsets
        .offset(x: self.zoomedOut ? getCurrentDragOffset().width : 0, y: self.zoomedOut ? getCurrentDragOffset().height : 0)
        .rotation3DEffect(Angle(degrees: 10), axis: (x: 0, y: 0, z: 0))
        // max scale from small to large is 1.7 and large to small is 0.58
        .onAppear {
            // get current default offset
            if self.selectedView == viewType {
                self.currentDefaultOffset = CGSize(width: 0,height: 0)
            } else if (viewType == (self.selectedView == .gameView ? .learnView : .gameView)) {
                self.currentDefaultOffset = CGSize(width: -490,height: -65)
            } else {
                self.currentDefaultOffset = CGSize(width: 490,height: -65)
            }
            
            // get next position
            if self.currentDefaultOffset == CGSize(width: 0,height: 0) {
                
                self.nextPositionPos = CGSize(width: 490,height: -65)
                self.nextPositionNeg = CGSize(width: -490,height: -65)
                
            } else if self.currentDefaultOffset == CGSize(width: -490,height: -65) {
                self.nextPositionPos = CGSize(width: 490,height: -65)
                self.nextPositionNeg = CGSize(width: 0,height: 0)
            } else {
                self.nextPositionPos = CGSize(width: 0,height: 0)
                self.nextPositionNeg = CGSize(width: 490,height: -65)
            }
        }
    }
    
    
    func getCurrentDragOffset () -> CGSize {
        var x = 0.0
        var y = 0.0
        if self.dragCurrentTranslation.width > 0 {
            x = (nextPositionPos.width  - currentDefaultOffset.width) * (self.dragCurrentTranslation.width / (nextPositionPos.width - currentDefaultOffset.width))
        } else if self.dragCurrentTranslation.width < 0 {
            x = (nextPositionNeg.width  - currentDefaultOffset.width) * (self.dragCurrentTranslation.width / (nextPositionNeg.width - currentDefaultOffset.width))
        }
        
//        if self.currentDefaultOffset.height > 0 {
//            y = (nextPositionPos.height  - currentDefaultOffset.height) * (self.dragCurrentTranslation.height / (nextPositionPos.height - currentDefaultOffset.height))
//        } else if self.currentDefaultOffset.height < 0 {
//            y = (nextPositionNeg.height  - currentDefaultOffset.height) * (self.dragCurrentTranslation.height / (nextPositionNeg.height - currentDefaultOffset.height))
//        }

        return CGSize(width: x, height: y)
    }
    
    func viewSize() -> CGSize {
        let isMain = selectedView == viewType
        if zoomedOut {
            return CGSize(width: isMain ? 640 : 480, height: isMain ? 436 : 327)
        } else {
            return self.geo?.size ?? CGSize(width: 500, height: 500)
        }
    }
}

extension View {
    
    
    func displayContainerHelper(selectedView: Binding<MainView>, zoomedOut: Binding<Bool>,viewType: MainView, geo:Binding<GeometryProxy?>, dragCurrentTranslation: Binding<CGSize>) -> some View{
        return modifier(DisplayContainerHelper(selectedView: selectedView, zoomedOut: zoomedOut, viewType: viewType, geo:geo, dragCurrentTranslation: dragCurrentTranslation))
    }
}
