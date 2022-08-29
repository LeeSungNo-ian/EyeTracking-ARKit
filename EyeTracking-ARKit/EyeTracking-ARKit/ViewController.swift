//
//  ViewController.swift
//  EyeTracking-ARKit
//
//  Created by 이성노 on 2022/08/30.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet var sceneView: ARSCNView!
    
    let face = SCNNode()
    let leftEye = EyeNode(color: .green)
    let rightEye = EyeNode(color: .red)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        sceneView.scene.rootNode.addChildNode(face)
        face.addChildNode(leftEye)
        face.addChildNode(rightEye)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard ARFaceTrackingConfiguration.isSupported else {
            print("지원하지 않는 디바이스 입니다.")
            return
        }
        
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    // MARK: - Custom function
    
}

// MARK: - ARSCNViewDelegate

extension ViewController: ARSCNViewDelegate {

}
