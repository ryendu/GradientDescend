//
//  LearnView.swift
//  GradientDescend
//
//  Created by Ryan D on 4/5/22.
//

import Foundation
import SwiftUI

struct Learn2DGDView: View {
    @State var slide = 0
    @Binding var geo: GeometryProxy?
    @Binding var zoomedOut: Bool
    @Binding var selectedView: MainView
    var body: some View {
        MoreComplex2DGDSlide(slide: $slide, zoomedOut: self.$zoomedOut, selectedView: $selectedView)
    }
}


