//
//  ARHitTestResult+position.swift
//  soInterior
//
//  Created by Nazar on 23/02/2019.
//  Copyright © 2019 Nazar. All rights reserved.
//

import ARKit

extension ARHitTestResult {
    var position: SCNVector3 {
        let translation = worldTransform.columns.3
        return SCNVector3Make(translation.x, translation.y, translation.z)
    }
}
