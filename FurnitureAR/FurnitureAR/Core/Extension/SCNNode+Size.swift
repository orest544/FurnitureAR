//
//  SCNNode+Size.swift
//  soInterior
//
//  Created by Nazar on 23/02/2019.
//  Copyright © 2019 Nazar. All rights reserved.
//

import SceneKit

extension SCNNode {
    var width: CGFloat {
        let boundsMin = boundingBox.min
        let boundsMax = boundingBox.max
        
        return CGFloat(boundsMax.x - boundsMin.x)
    }
    
    var height: CGFloat {
        let boundsMin = boundingBox.min
        let boundsMax = boundingBox.max
        
        return CGFloat(boundsMax.y - boundsMin.y)
    }
}

