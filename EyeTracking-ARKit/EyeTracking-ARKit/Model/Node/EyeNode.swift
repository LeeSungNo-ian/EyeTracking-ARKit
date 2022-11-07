//
//  EyeNode.swift
//  EyeTracking-ARKit
//
//  Created by 이성노 on 2022/08/30.
//

import UIKit
import SceneKit

final class EyeNode: SCNNode {
    let target = SCNNode()
    
    init(color: UIColor) {
        super.init()

        configureNode(color: color)
        configureTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNode(color: UIColor) {
        let cylinder = SCNCylinder(radius: 0.01, height: 0.15)
        cylinder.firstMaterial?.diffuse.contents = color
        
        let node = SCNNode(geometry: cylinder)
        node.eulerAngles.x = .pi/2
        node.position.z = Float(NodeDataStatus.positionZ.rawValue)
        node.opacity = NodeDataStatus.opacity.rawValue

        addChildNode(node)
    }
    
    private func configureTarget() {
        target.position.z = 1
        
        addChildNode(target)
    }
}

enum NodeDataStatus: CGFloat {
    case positionZ = 0.075
    case opacity = 0.4
}
