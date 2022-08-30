//
//  Collection.swift
//  EyeTracking-ARKit
//
//  Created by 이성노 on 2022/08/30.
//

import UIKit
import SceneKit

extension Collection where Element == CGPoint {
    var averageAffineTransform: CGAffineTransform {
        var x: CGFloat = 0
        var y: CGFloat = 0

        for item in self {
            x += item.x
            y += item.y
        }

        let elementCount = CGFloat(self.count)
        return CGAffineTransform(translationX: x / elementCount, y: y / elementCount)
    }
}
