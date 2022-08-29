//
//  EyeNode.swift
//  EyeTracking-ARKit
//
//  Created by 이성노 on 2022/08/30.
//

import UIKit
import SceneKit

class EyeNode: SCNNode {
    let target = SCNNode()
    
    init(color: UIColor) {
        super.init()

        let cylinder = SCNCylinder(radius: 0.01, height: 0.15)
        cylinder.firstMaterial?.diffuse.contents = color

        let node = SCNNode(geometry: cylinder)
        node.eulerAngles.x = .pi/2
        node.position.z = 0.075
        node.opacity = 0.4

        target.position.z = 1

        addChildNode(node)
        addChildNode(target)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
