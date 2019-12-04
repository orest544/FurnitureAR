//
//  SCNNode+makePlane.swift
//  soInterior
//
//  Created by Nazar on 23/02/2019.
//  Copyright © 2019 Nazar. All rights reserved.
//

import SceneKit
import ARKit

extension SCNNode {
    static func makePlane(withName name: String, for planeAnchor: ARPlaneAnchor) -> SCNNode? {
        guard let device = MTLCreateSystemDefaultDevice() else { return nil }
        let planeGeometry = ARSCNPlaneGeometry(device: device)
        
        let plane = SCNNode(geometry: planeGeometry)
        plane.name = name
        plane.position = planeAnchor.position
        
        
        // TODO: Need to separate to other method for Decoration plane
        let scaleX = (Float(planeAnchor.extent.x)  / 0.02).rounded()
        let scaleY = (Float(planeAnchor.extent.z) / 0.02).rounded()
        
        plane.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray.withAlphaComponent(0.3)
//        let image = UIImage(named: "plane_cross")
//        plane.geometry?.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(0.3)
        plane.geometry?.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(scaleX, scaleY, 0)
        plane.geometry?.firstMaterial?.diffuse.wrapS = .repeat
        plane.geometry?.firstMaterial?.diffuse.wrapT = .repeat
        plane.geometry?.firstMaterial?.transparency = 0.4
        
        return plane
    }
}
