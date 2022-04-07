//
//  SupportingViews.swift
//  
//
//  Created by Ryan D on 4/5/22.
//

import Foundation
import SwiftUI

// code from https://stackoverflow.com/questions/64238485/how-to-loop-over-viewbuilder-content-subviews-in-swiftui
// used to help with sorting through each view inside Interactive Window
extension TupleView {
    var getViews: [AnyView] {
        makeArray(from: value)
    }
    
    private struct GenericView {
        let body: Any
        
        var anyView: AnyView? {
            AnyView(_fromValue: body)
        }
    }
    
    private func makeArray<Tuple>(from tuple: Tuple) -> [AnyView] {
        func convert(child: Mirror.Child) -> AnyView? {
            withUnsafeBytes(of: child.value) { ptr -> AnyView? in
                let binded = ptr.bindMemory(to: GenericView.self)
                return binded.first?.anyView
            }
        }
        
        let tupleMirror = Mirror(reflecting: tuple)
        return tupleMirror.children.compactMap(convert)
    }
}

// code from https://www.fivestars.blog/articles/conditional-modifiers/
// I used this snippet because this simple extension to view makes it a lot more
// convenient to deal with modifying views conditionally and prevents duplicate code.
extension View {
@ViewBuilder
func `if`<TrueContent: View, FalseContent: View>(_ condition: Bool, if ifTransform: (Self) -> TrueContent, else elseTransform: (Self) -> FalseContent) -> some View {
    if condition {
        ifTransform(self)
    } else {
        elseTransform(self)
    }
}
@ViewBuilder
func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
    if condition {
        transform(self)
    } else {
        self
    }
}
}
