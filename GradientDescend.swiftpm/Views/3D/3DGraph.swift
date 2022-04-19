//
//  File.swift
//  
//
//  Created by Ryan D on 4/17/22.
//

import Foundation
import SwiftUI
import SceneKit

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//            .previewLayout(.fixed(width: 812, height: 375)) // 1
            .environment(\.horizontalSizeClass, .compact) // 2
            .environment(\.verticalSizeClass, .compact)
            .previewInterfaceOrientation(.landscapeLeft) // 3
    }
}


struct Simple3DView: View, Equatable {
    static func == (lhs: Simple3DView, rhs: Simple3DView) -> Bool {
        return true
    }
    
    @Binding var cardIndex: Int
    
    
    var scene = Simple3DScene(make: true)
    var body: some View {
        SceneView(scene: scene, options: [.autoenablesDefaultLighting, .allowsCameraControl])
            .ignoresSafeArea()
    }
    
}

class Simple3DScene: SCNScene {
    convenience init(make:Bool){
        self.init()
        
        background.contents = UIColor.black
        
//      MARK: Testing
//        let sphere = SCNNode(geometry: SCNSphere(radius: 20))
//        sphere.position = SCNVector3(x: 0, y: 0, z: 0)
//        rootNode.addChildNode(sphere)
        
//      MARK: Grid
        let stepSize = 1.0
        let xAxisTotal = 10
        let yAxisTotal = 10
        let zAxisTotal = 10
        let scale: CGFloat = 3.0
        
        let grid = createGrid(stepSize: stepSize, xAxisTotal: xAxisTotal, yAxisTotal: yAxisTotal, zAxisTotal: zAxisTotal, xLabel: "Param 1", yLabel: "Error", zLabel: "Param 2", scale: scale)
        grid.position = SCNVector3(x: 0, y: 0, z: 0)
        rootNode.addChildNode(grid)
        
        //create the graph
        
        var modelGraph = SCNScene(named: "simple3dgd.scn")!.rootNode
        modelGraph.scale = SCNVector3(x: 3.0 * Float(scale), y: 3.0 * Float(scale), z: 3.0 * Float(scale))
        modelGraph.position = SCNVector3(x: Float(xAxisTotal / 2) * Float(stepSize * scale), y: 0.0, z: Float(zAxisTotal / 2) * Float(stepSize * scale))
        
        rootNode.addChildNode(modelGraph)
        
    }
    
    // TODO: have a function that starts the gradient descent animation...
    
    
    func createGrid(stepSize: Double, xAxisTotal: Int, yAxisTotal: Int, zAxisTotal: Int, xLabel: String, yLabel: String, zLabel: String, scale: CGFloat) -> SCNNode {
        let mainNode = SCNNode()
        
        
        //AXISES
        //x
        let xAxis = SCNNode(geometry: SCNCylinder(radius: 0.1, height: CGFloat(xAxisTotal) * scale))
        xAxis.position = SCNVector3(x: 0.0, y: -1 * Float(CGFloat(yAxisTotal) * scale / 2), z: Float(CGFloat(zAxisTotal) * scale / 2))
        xAxis.rotation = SCNVector4(1, 0, 0, 1.5708)
        mainNode.addChildNode(xAxis)
        //y
        let yAxis = SCNNode(geometry: SCNCylinder(radius: 0.1, height: CGFloat(yAxisTotal) * scale))
        mainNode.addChildNode(yAxis)
        //z
        let zAxis = SCNNode(geometry: SCNCylinder(radius: 0.1, height: CGFloat(zAxisTotal) * scale))
        zAxis.position = SCNVector3(x: Float(CGFloat(xAxisTotal) * scale) / 2, y: -1 * Float(CGFloat(yAxisTotal) * scale / 2), z: 0.0)
        zAxis.rotation = SCNVector4(0, 0, 1, 1.5708)
        mainNode.addChildNode(zAxis)
        //XY
        for x in 0...xAxisTotal {
            let node = SCNNode(geometry: SCNCylinder(radius: 0.02, height: CGFloat(yAxisTotal) * scale))
            node.position = SCNVector3(x: Float(scale * CGFloat(x)), y: 0.0, z: 0.0)
            mainNode.addChildNode(node)
        }
        for y in 0...yAxisTotal {
            let node = SCNNode(geometry: SCNCylinder(radius: 0.02, height: CGFloat(xAxisTotal) * scale))
            node.rotation = SCNVector4(0, 0, 1, 1.5708)
            node.position = SCNVector3(x: Float(CGFloat(xAxisTotal) * scale) / 2, y: Float(CGFloat(y) * scale) - Float(CGFloat(yAxisTotal) * scale) / 2, z: 0.0)
            mainNode.addChildNode(node)
        }



        //YZ
        for z in 0...zAxisTotal {
            let node = SCNNode(geometry: SCNCylinder(radius: 0.02, height: CGFloat(yAxisTotal) * scale))
            node.position = SCNVector3(x: 0.0, y: 0.0, z: Float(scale * CGFloat(z)))
            mainNode.addChildNode(node)
        }
        for y in 0...yAxisTotal {
            let node = SCNNode(geometry: SCNCylinder(radius: 0.02, height: CGFloat(zAxisTotal) * scale))
            node.rotation = SCNVector4(1, 0, 0, 1.5708)
            node.position = SCNVector3(x: 0.0, y: Float(CGFloat(y) * scale) - Float(CGFloat(yAxisTotal) * scale) / 2, z: Float(CGFloat(zAxisTotal) * scale) / 2)
            mainNode.addChildNode(node)
        }
        
        
        
        //XZ
        for y in 0...yAxisTotal {
            let node = SCNNode(geometry: SCNCylinder(radius: 0.02, height: CGFloat(zAxisTotal) * scale))
            node.rotation = SCNVector4(1, 0, 0, 1.5708)
            node.position = SCNVector3(x: Float(CGFloat(y) * scale), y: -1 * Float(CGFloat(yAxisTotal) * scale) / 2, z: Float(CGFloat(zAxisTotal) * scale) / 2)
            mainNode.addChildNode(node)
        }
        for y in 0...yAxisTotal {
            let node = SCNNode(geometry: SCNCylinder(radius: 0.02, height: CGFloat(xAxisTotal) * scale))
            node.rotation = SCNVector4(0, 0, 1, 1.5708)
            node.position = SCNVector3(x: Float(CGFloat(xAxisTotal) * scale) / 2, y: -1 * Float(CGFloat(yAxisTotal) * scale) / 2, z: Float(CGFloat(y) * scale))
            mainNode.addChildNode(node)
        }
        
        return mainNode
    }
}
