//
//  MultiDimensionalGDView.swift
//  GradientDescend
//
//  Created by Ryan D on 4/5/22.
//

import Foundation
import SwiftUI

struct Learn3DGDViewGDView: View {
    @State var slide = 0
    @Binding var geo: GeometryProxy?
    @Binding var zoomedOut: Bool
    @Binding var selectedView: MainView
    var body: some View {
        Simple3DGDSlide(slide: $slide)
    }
}
