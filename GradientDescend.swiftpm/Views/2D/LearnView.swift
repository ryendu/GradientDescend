//
//  File.swift
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
        InteractiveWindow(slide: $slide) {
            
            TitleSlide(slide: $slide, geo:$geo)
            
            WhatIsGradientDescentSlide(slide: $slide, geoSize: geo?.size)
            
            Basic2DGradientDescentSlide(slide: $slide)
            
            MoreComplex2DGDSlide(slide: $slide, zoomedOut: self.$zoomedOut, selectedView: $selectedView)
            
        }
    }
}


