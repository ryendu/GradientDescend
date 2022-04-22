//
//  File.swift
//  GradientDescend
//
//  Created by Ryan D on 4/5/22.
//

import Foundation
import SwiftUI

struct Basic2DView: View {
    @Binding var geo: GeometryProxy?
    @Binding var zoomedOut: Bool
    @Binding var selectedView: MainView
    var body: some View {
//        InteractiveWindow(slide: $slide) {
            Basic2DGradientDescentSlide(zoomedOut: $zoomedOut, selectedView: $selectedView)
//            Text("")
//        }
    }
}
