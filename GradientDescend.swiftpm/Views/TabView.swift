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
import CoreMotion


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
    
    var body: some View {
        
        
            // stack the zoomed out background behind at all times
            ZStack (alignment: .center){
                
                //background
                
                
                GameView()
                    .displayContainerHelper(selectedView: self.$selectedView, zoomedOut: self.$zoomedOut, viewType: .gameView, geo: $geo)
                    .gyroscope3DEffect(zoomedOut: $zoomedOut)
                AboutView()
                    .displayContainerHelper(selectedView: self.$selectedView, zoomedOut: self.$zoomedOut, viewType: .aboutView, geo: $geo)
                    .gyroscope3DEffect(zoomedOut: $zoomedOut)
                LearnView(geo:$geo)
                    .displayContainerHelper(selectedView: self.$selectedView, zoomedOut: self.$zoomedOut, viewType: .learnView, geo: $geo)
                    .gyroscope3DEffect(zoomedOut: $zoomedOut)
                
                ZStack(alignment: .bottomTrailing) {
                    Button(action: {
                        withAnimation(.spring()) {
                            self.zoomedOut.toggle()
                        }
                    }, label: {

                        Image(systemName: "square.3.stack.3d")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .irregularGradient(colors: [Color("bg1"),Color("bg2"),Color("bg5"),Color("bg3"),Color("bg4")], backgroundColor: Color("bg4"))
                            .padding()
                            .background(Circle().foregroundColor(.white).softInnerShadow(Circle()))
                    })
                }.zIndex(2).offset(x: (self.geo?.size.width ?? 500) / 2 - 70, y: (self.geo?.size.width ?? 500) / 1.33 / 2 - 70)
            }.ignoresSafeArea(edges: .top)
            .background(
                Rectangle()
                    .irregularGradient(colors: [Color("bg1"),Color("bg2"),Color("bg5"),Color("bg3"),Color("bg4")], backgroundColor: Color("bg4"))
                    .scaledToFill()
                    .ignoresSafeArea()
                    .zIndex(-1)
                    .scaleEffect(3)
            )
            .background(GeometryReader { geo in
                Text("")
                    .onAppear(perform: {
                        self.geo = geo
                        print(geo.size)
                    })
            })
    }
}



/// helps display container correctly display and animate when zoomed out
struct DisplayContainerHelper: ViewModifier{
    @Binding var selectedView: MainView
    @Binding var zoomedOut: Bool
    var viewType: MainView
    @Binding var geo: GeometryProxy?
    
    func body(content: Content) -> some View {
        ZStack (alignment:.center) {
            Color.white
            content
                
        }
        .disabled(self.zoomedOut)
        .zIndex(self.selectedView == self.viewType ? 1 : 0)
        .frame(width: self.zoomedOut ? self.viewSize().width : nil, height: self.zoomedOut ? self.viewSize().height : nil)

        .cornerRadius(zoomedOut ? 18 : 0)
        .padding(self.zoomedOut ? 11 : 0)
        .background(zoomedOut ? Rectangle().foregroundColor(Color("deviceFrame")).opacity(1).softOuterShadow() : Rectangle().foregroundColor(.white).opacity(0).softOuterShadow() )

        .cornerRadius(zoomedOut ? 24 : 0)
        .offset(x: (self.zoomedOut && self.selectedView != viewType && (viewType == (self.selectedView == .gameView ? .learnView : .gameView))) ? -430 : 0, y: self.zoomedOut && self.selectedView != viewType ? -65 : 0 )
        .offset(x: (self.zoomedOut && self.selectedView != viewType && (viewType == (self.selectedView == .aboutView ? .learnView : .aboutView))) ? 430 : 0, y: self.zoomedOut && self.selectedView != viewType ? -65 : 0  )
        
        .onTapGesture {
            if self.zoomedOut {
            withAnimation(.spring()) {
                self.selectedView = self.viewType
                self.zoomedOut.toggle()
            }
            }
        }
    }
    
    func viewSize() -> CGSize {
        let isMain = false
        return CGSize(width: isMain ? 640 : 480, height: isMain ? 436 : 327)
    }
}

class MotionManager: ObservableObject {
    var motionManager: CMMotionManager
    @Published var x = 0.4
    @Published var y = 0.2
    @Published var z = 0.1
    
    init() {
        self.motionManager = CMMotionManager()
        self.motionManager.magnetometerUpdateInterval = 1/30
        self.motionManager.startDeviceMotionUpdates(to: .main) {data, error in
            if let error = error {
                print(error)
            }
            guard let data = data else { return }
            self.objectWillChange.send()
            self.x = data.rotationRate.x
            self.y = data.rotationRate.y
            self.z = data.rotationRate.z
            
        }
    }
}

struct Gyroscope3DEffect: ViewModifier {
    @ObservedObject var motionManager = MotionManager()
    @Binding var zoomedOut: Bool
    let magnitude = 2.0
    func body(content: Content) -> some View {
        
        content
            .rotation3DEffect(Angle(degrees: self.zoomedOut ? motionManager.y * magnitude : 0), axis: (x: 1, y: 0, z: 0))
            .rotation3DEffect(Angle(degrees: self.zoomedOut ? motionManager.x * magnitude : 0), axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(Angle(degrees: self.zoomedOut ? motionManager.z * magnitude : 0), axis: (x: 0, y: 0, z: 1))
    }
}

extension View {
    func displayContainerHelper(selectedView: Binding<MainView>, zoomedOut: Binding<Bool>,viewType: MainView, geo:Binding<GeometryProxy?>) -> some View{
        return modifier(DisplayContainerHelper(selectedView: selectedView, zoomedOut: zoomedOut, viewType: viewType, geo:geo))
    }
    
    func gyroscope3DEffect(zoomedOut: Binding<Bool>) -> some View {
        return modifier(Gyroscope3DEffect(zoomedOut: zoomedOut))
    }
}
