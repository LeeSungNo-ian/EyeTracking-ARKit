//
//  SCNHitTestResult.swift
//  EyeTracking-ARKit
//
//  Created by 이성노 on 2022/08/30.
//

import UIKit
import SceneKit

// 출처: https://github.com/virakri/eye-tracking-ios-prototype/issues/3
extension SCNHitTestResult {
    var screenPosition: CGPoint {
        // Collition calculation
        var physicallIphoneSize = CGSize(width: 0.062/2, height: 0.135/2)
        let sizeResolution = UIScreen.main.bounds.size
        let screenX = CGFloat(localCoordinates.x) / physicallIphoneSize.width * sizeResolution.width
        let screenY = CGFloat(localCoordinates.y) / physicallIphoneSize.height * sizeResolution.height

        return CGPoint(x: screenX, y: screenY)
    }
}
