//
//  TyrannosaurusScene.swift
//  Tyrannosaurus
//
//  Created by Nicky Taylor on 3/14/23.
//

import Foundation
import SceneKit

final class TyrannosaurusScene: SCNScene, SCNSceneRendererDelegate {

    let tyrannosaurusNode = TyrannosaurusNode()

    override init() {
        super.init()
        background.contents = UIColor.black
        rootNode.addChildNode(tyrannosaurusNode)
        applyLighting()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        tyrannosaurusNode.update()
    }
    
    private func applyLighting() {
        let lightNodeSun = SCNNode()
        lightNodeSun.position = SCNVector3Make(10.0, 30.0, 15.0)
        let lightSun = SCNLight()
        lightSun.type = .omni
        lightSun.intensity = 650.0
        lightNodeSun.light = lightSun
        
        let lightNodeScatter = SCNNode()
        lightNodeScatter.position = SCNVector3Make(-10.0, -40.0, -10.0)
        let lightScatter = SCNLight()
        lightScatter.type = .omni
        lightScatter.intensity = 50.0
        lightNodeScatter.light = lightScatter
        
        let lightNodeAtmosphere = SCNNode()
        lightNodeAtmosphere.position = SCNVector3Make(-10.0, 30.0, -10.0)
        let lightAtmosphere = SCNLight()
        lightAtmosphere.type = .area
        lightAtmosphere.intensity = 200.0
        lightNodeAtmosphere.light = lightScatter
        
        let lightNodeAmbient = SCNNode()
        let lightAmbient = SCNLight()
        lightAmbient.type = .ambient
        lightAmbient.intensity = 50.0
        lightNodeAmbient.light = lightAmbient
        
        rootNode.addChildNode(lightNodeSun)
        rootNode.addChildNode(lightNodeScatter)
        rootNode.addChildNode(lightNodeAtmosphere)
        rootNode.addChildNode(lightNodeAmbient)
    }

}
