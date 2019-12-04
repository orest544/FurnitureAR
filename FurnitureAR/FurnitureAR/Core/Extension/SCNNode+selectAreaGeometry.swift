//
//  SCNNode+selectAreaGeometry.swift
//  soInterior
//
//  Created by Nazar on 23/02/2019.
//  Copyright © 2019 Nazar. All rights reserved.
//

import SceneKit

extension SCNNode {
    // TODO: investigate if all object need that size
    var selectAreaGeometry: SCNGeometry {
        return SCNPlane(width: width, height: width)
    }
}

