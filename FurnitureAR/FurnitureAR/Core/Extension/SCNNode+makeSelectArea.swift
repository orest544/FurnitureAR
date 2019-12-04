//
//  SCNNode+makeSelectArea.swift
//  soInterior
//
//  Created by Nazar on 23/02/2019.
//  Copyright © 2019 Nazar. All rights reserved.
//

import SceneKit

extension SCNNode {
    static func makeSelectArea(for node: SCNNode) -> SCNNode {
        let selectArea = SCNNode(geometry: node.selectAreaGeometry)
        selectArea.geometry?.firstMaterial?.diffuse.contents = DefaultImage.select_area.image
        selectArea.position = node.presentation.position
        selectArea.eulerAngles.x = -.pi / 2
        selectArea.name = "selectArea"
        
        return selectArea
    }
}
