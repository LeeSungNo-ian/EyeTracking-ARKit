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
    
    private lazy var aimImage: UIImageView = {
        let imageView = UIImageView()
        let aimImage: UIImage = UIImage(named: "AimImage")!
        imageView.image = aimImage
        imageView.contentMode = .scaleAspectFill
        imageView.layer.opacity = 0.4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

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
    
    func eyeEffect(using anchor: ARFaceAnchor) {
        leftEye.simdTransform = anchor.leftEyeTransform
        rightEye.simdTransform = anchor.rightEyeTransform
    }
}

// MARK: - ARSCNViewDelegate

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        DispatchQueue.main.async {
            self.face.simdTransform = node.simdTransform
            self.eyeEffect(using: faceAnchor)
        }
    }
}

// MARK: - extension
private extension ViewController {
    func setupLayout() {
        view.addSubview(aimImage)
        aimImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        aimImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
}
