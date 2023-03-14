//
//  ContentView.swift
//  Tyrannosaurus
//
//  Created by Nicky Taylor on 3/14/23.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    
    private let scene = TyrannosaurusScene()
    
    var camera: SCNNode {
        let result = SCNNode()
        result.camera = SCNCamera()
        result.position = SCNVector3(x: 0.0, y: 15.0, z: 55.0)
        return result
    }
    
    var body: some View {
        SceneView(scene: scene,
                  pointOfView: camera,
                  options: [.allowsCameraControl,
                            .rendersContinuously],
                  delegate: scene)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
