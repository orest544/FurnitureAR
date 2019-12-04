//
//  ARPlaneAnchor+position.swift
//  soInterior
//
//  Created by Nazar on 23/02/2019.
//  Copyright © 2019 Nazar. All rights reserved.
//

import ARKit

extension ARPlaneAnchor {
    var position: SCNVector3 {
        return SCNVector3(center.x, center.y, center.z)
    }
}
