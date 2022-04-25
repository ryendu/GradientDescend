//
//  TabView.swift
//  GradientDescend
//
//  Created by Ryan D on 4/5/22.
//

import Foundation
import SwiftUI
import CoreMotion


enum MainView {
    case learn2DGDView
    case learn3DGDView
    case basic2dView
}


struct TabView: View {
    @State var zoomedOut = false
    @State var offset = CGSize.zero
    @State var selectedView: MainView = .basic2dView
    @State var geo: GeometryProxy?
    
    var body: some View {
        
        // stack the zoomed out background behind at all times
        ZStack (alignment: .center){
            
            //background
            
            
            Learn3DGDViewGDView(geo:$geo,zoomedOut: self.$zoomedOut, selectedView: $selectedView)
                .displayContainerHelper(moduleName: "3. 3D Gradient Descent", selectedView: self.$selectedView, zoomedOut: self.$zoomedOut, viewType: .learn3DGDView, geo: $geo)
                .gyroscope3DEffect(zoomedOut: $zoomedOut)
            
            Basic2DView(geo:$geo,zoomedOut: self.$zoomedOut, selectedView: $selectedView)
                .displayContainerHelper(moduleName: "1. How Does Gradient Descent Work", selectedView: self.$selectedView, zoomedOut: self.$zoomedOut, viewType: .basic2dView, geo: $geo)
                .gyroscope3DEffect(zoomedOut: $zoomedOut)
            
            Learn2DGDView(geo:$geo,zoomedOut: self.$zoomedOut, selectedView: $selectedView)
                .displayContainerHelper(moduleName: "2. Learning Rates & Local Minima", selectedView: self.$selectedView, zoomedOut: self.$zoomedOut, viewType: .learn2DGDView, geo: $geo)
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
                        .background(Circle().fill(LinearGradient(colors: [Color("neutral200"),Color("neutral400")], startPoint: .topLeading, endPoint: .bottomTrailing)))
                    
                })
            }.zIndex(2).offset(x: (geo?.size.width ?? 1000) / 2 - 70, y: (geo?.size.height ?? 1000) / 2 - 70)
            
            
            
            
        }.ignoresSafeArea(edges: .top)
            .background(
                Rectangle()
                    .irregularGradient(colors: [Color("bg1"),Color("bg2"),Color("bg5"),Color("bg3"),Color("bg4")], backgroundColor: Color("bg1"), speed: 12.0)
                    .scaledToFill()
                    .ignoresSafeArea()
                    .zIndex(-1)
                    .scaleEffect(3)
            )
        
            .background(GeometryReader { geo in
                Text("")
                    .onAppear(perform: {
                        self.geo = geo
                    })
            })
        
    }
}



/// helps display container correctly display and animate when zoomed out
struct DisplayContainerHelper: ViewModifier{
    var moduleName: String
    @Binding var selectedView: MainView
    @Binding var zoomedOut: Bool
    var viewType: MainView
    @Binding var geo: GeometryProxy?
    
    func body(content: Content) -> some View {
        VStack (alignment:.center) {
            ZStack{
                Color.white
                content
            }
            .disabled(self.zoomedOut)
            .frame(width: self.zoomedOut ? self.viewSize().width : nil, height: self.zoomedOut ? self.viewSize().height : nil)
            .cornerRadius(zoomedOut ? 18 : 0)
            .padding(self.zoomedOut ? 11 : 0)
            .background(zoomedOut ? Rectangle().foregroundColor(Color("deviceFrame")).opacity(1).shadow(radius: 5) : Rectangle().foregroundColor(.white).opacity(0).shadow(radius: 5))
            .cornerRadius(zoomedOut ? 24 : 0)
            
            if self.zoomedOut {
                Text(moduleName)
                    .font(.system(size: 26).monospaced().bold())
                    .foregroundColor(.white)
            }
        }
        .zIndex(self.selectedView == self.viewType ? 1 : 0)
        
        .offset(x: (self.zoomedOut && self.selectedView != viewType && (viewType == (self.selectedView == .learn2DGDView ? .learn3DGDView : .learn2DGDView))) ? -430 : 0, y: self.zoomedOut && self.selectedView != viewType ? -65 : 0 )
        .offset(x: (self.zoomedOut && self.selectedView != viewType && (viewType == (self.selectedView == .basic2dView ? .learn3DGDView : .basic2dView))) ? 430 : 0, y: self.zoomedOut && self.selectedView != viewType ? -65 : 0  )
        
        .onTapGesture {
            if self.zoomedOut {
                DispatchQueue.main.asyncAfter(deadline: .now()){
                    withAnimation(.spring()) {
                        self.selectedView = self.viewType
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                    withAnimation(.spring()) {
                        self.zoomedOut = false
                    }
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
    func displayContainerHelper(moduleName: String, selectedView: Binding<MainView>, zoomedOut: Binding<Bool>,viewType: MainView, geo:Binding<GeometryProxy?>) -> some View{
        return modifier(DisplayContainerHelper(moduleName: moduleName, selectedView: selectedView, zoomedOut: zoomedOut, viewType: viewType, geo:geo))
    }
    
    func gyroscope3DEffect(zoomedOut: Binding<Bool>) -> some View {
        return modifier(Gyroscope3DEffect(zoomedOut: zoomedOut))
    }
}
