//
//  TyrannosaurusNode.swift
//  Tyrannosaurus
//
//  Created by Nicky Taylor on 3/14/23.
//

import Foundation
import SceneKit

class TyrannosaurusNode: SCNNode {
    
    private let sliceBody = TyrannosaurusSliceNode(name: "rex_body_")
    private let sliceEyeLeft = TyrannosaurusSliceNode(name: "rex_eye_left_")
    private let sliceEyeRight = TyrannosaurusSliceNode(name: "rex_eye_right_")
    private let sliceSpikes = TyrannosaurusSliceNode(name: "rex_spikes_")
    
    private let textureBodyDiffuse = UIImage(named: "rex_body_diffuse")
    private let textureBodyNormal = UIImage(named: "rex_body_normal")
    private let textureBodyDisplacement = UIImage(named: "rex_body_displacement")
    private let textureBodySpecular = UIImage(named: "rex_body_specular")
    
    private let textureEyeDiffuse = UIImage(named: "rex_eyes_diffuse")
    private let textureEyeNormal = UIImage(named: "rex_eyes_normal")
    
    var animationFrame: Float = 0.0
    let animationFrameCount: Int
    let animationFrameCountFloat: Float
    
    override init() {
        
        var _animationFrameCount = sliceBody.geometries.count
        if sliceEyeLeft.geometries.count < _animationFrameCount { _animationFrameCount = sliceEyeLeft.geometries.count }
        if sliceEyeRight.geometries.count < _animationFrameCount { _animationFrameCount = sliceEyeRight.geometries.count }
        if sliceSpikes.geometries.count < _animationFrameCount { _animationFrameCount = sliceSpikes.geometries.count }
        
        animationFrameCount = _animationFrameCount
        animationFrameCountFloat = Float(animationFrameCount)
        
        if let textureBodyDiffuse = textureBodyDiffuse {
            sliceBody.setDiffuse(image: textureBodyDiffuse)
            sliceSpikes.setDiffuse(image: textureBodyDiffuse)
        }
        
        if let textureBodyNormal = textureBodyNormal {
            sliceBody.setNormal(image: textureBodyNormal)
            sliceSpikes.setNormal(image: textureBodyNormal)
        }
        
        if let textureBodySpecular = textureBodySpecular {
            sliceBody.setSpecular(image: textureBodySpecular)
            sliceSpikes.setSpecular(image: textureBodySpecular)
        }
        
        if let textureEyeDiffuse = textureEyeDiffuse {
            sliceEyeLeft.setDiffuse(image: textureEyeDiffuse)
            sliceEyeRight.setDiffuse(image: textureEyeDiffuse)
        }
        
        if let textureEyeNormal = textureEyeDiffuse {
            sliceEyeLeft.setDiffuse(image: textureEyeNormal)
            sliceEyeRight.setDiffuse(image: textureEyeNormal)
        }
        
        super.init()
        
        addChildNode(sliceBody)
        addChildNode(sliceEyeLeft)
        addChildNode(sliceEyeRight)
        addChildNode(sliceSpikes)
    }
    
    required init?(coder: NSCoder) {
        
        animationFrameCount = 0
        animationFrameCountFloat = 0.0
        
        super.init(coder: coder)
    }
    
    func update() {
        if animationFrameCountFloat > 0.0 {
            animationFrame += 0.64
            if animationFrame > animationFrameCountFloat {
                animationFrame -= animationFrameCountFloat
            }
            sliceBody.set(frame: animationFrame)
            sliceSpikes.set(frame: animationFrame)
            sliceEyeLeft.set(frame: animationFrame)
            sliceEyeRight.set(frame: animationFrame)
        }
    }
}

fileprivate class TyrannosaurusSliceNode: SCNNode {
    
    let geometries: [SCNGeometry]
    
    required init(name: String) {
        
        var baseSources = [SCNGeometrySource]()
        
        let texcoordData = Self.load(name: name + "texcoords") ?? Data()
        if texcoordData.count > 0 {
            let textureCoordsSource = SCNGeometrySource(data: texcoordData,
                                                        semantic: .texcoord,
                                                        vectorCount: texcoordData.count / 12,
                                                        usesFloatComponents: true,
                                                        componentsPerVector: 3,
                                                        bytesPerComponent: MemoryLayout<Float32>.size,
                                                        dataOffset: 0,
                                                        dataStride: MemoryLayout<Float32>.size * 3)
            baseSources.append(textureCoordsSource)
        }
        
        var _geometries = [SCNGeometry]()
        
        for index in 0...40 {
            var sources = baseSources
            
            let vertexData = Self.load(name: name + "frame_\(index)_vertices") ?? Data()
            if vertexData.count > 0 {
                let positionsSource = SCNGeometrySource(data: vertexData,
                                                        semantic: .vertex,
                                                        vectorCount: vertexData.count / 12,
                                                        usesFloatComponents: true,
                                                        componentsPerVector: 3,
                                                        bytesPerComponent: MemoryLayout<Float32>.size,
                                                        dataOffset: 0,
                                                        dataStride: MemoryLayout<Float32>.size * 3)
                sources.append(positionsSource)
            }
            
            let normalData = Self.load(name: name + "frame_\(index)_normals") ?? Data()
            if normalData.count > 0 {
                let normalsSource = SCNGeometrySource(data: normalData,
                                                        semantic: .normal,
                                                        vectorCount: normalData.count / 12,
                                                        usesFloatComponents: true,
                                                        componentsPerVector: 3,
                                                        bytesPerComponent: MemoryLayout<Float32>.size,
                                                        dataOffset: 0,
                                                        dataStride: MemoryLayout<Float32>.size * 3)
                sources.append(normalsSource)
            }
            
            let indexData = Self.load(name: name + "indices") ?? Data()
            let indexElement = SCNGeometryElement(data: indexData,
                                                  primitiveType: .triangles,
                                                  primitiveCount: indexData.count / 6,
                                                  bytesPerIndex: 2)
            
            let geometry = SCNGeometry(sources: sources,
                                       elements: [indexElement])
            _geometries.append(geometry)
        }
        
        self.geometries = _geometries
        
        super.init()
        
        set(frame: 0.0)
    }
    
    required init?(coder: NSCoder) {
        geometries = []
        super.init(coder: coder)
    }
    
    func setDiffuse(image: UIImage) {
        for geometry in geometries {
            if let firstMaterial = geometry.firstMaterial {
                firstMaterial.diffuse.contents = image
            }
        }
    }
    
    func setSpecular(image: UIImage) {
        for geometry in geometries {
            if let firstMaterial = geometry.firstMaterial {
                firstMaterial.specular.contents = image
            }
        }
    }
    
    func setNormal(image: UIImage) {
        for geometry in geometries {
            if let firstMaterial = geometry.firstMaterial {
                firstMaterial.normal.contents = image
                firstMaterial.normal.intensity = 0.25
            }
        }
    }
    
    func set(frame: Float) {
        self.geometry = geometry(at: frame)
    }
    
    private func geometry(at frame: Float) -> SCNGeometry? {
        if geometries.count > 0 {
            var index = Int(frame)
            if index >= (geometries.count) { index = geometries.count - 1 }
            if index < 0 { index = 0 }
            return geometries[index]
        }
        return nil
    }
    
    static func load(name: String) -> Data? {
        let bundle = Bundle.main
        guard let url = bundle.url(forResource: name, withExtension: "dat") else {
            print("Could not find URL for \(name) of type .dat")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch let error {
            print("Error Loading: \(name) of type .dat")
            print("\(error.localizedDescription)")
            return nil
        }
    }
}
