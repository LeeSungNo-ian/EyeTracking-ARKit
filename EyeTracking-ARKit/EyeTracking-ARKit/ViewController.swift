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
    let phonePlane = SCNNode(geometry: SCNPlane(width: 1, height: 1))
    
    var eyeGazeHistory = Array<CGPoint>()
    let numberOfSmoothUpdates = 25
    
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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        sceneView.delegate = self
        
        sceneView.scene.rootNode.addChildNode(face)
        face.addChildNode(leftEye)
        face.addChildNode(rightEye)
        
        sceneView.scene.rootNode.addChildNode(phonePlane)
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
    
    func eyeTracking(using anchor: ARFaceAnchor) {
        if let leftEyeBlink = anchor.blendShapes[.eyeBlinkLeft] as? Float,
           let rightEyeBlink = anchor.blendShapes[.eyeBlinkRight] as? Float {
            if leftEyeBlink > 0.2 && rightEyeBlink > 0.2 {
                print("깜빡임이 감지 됐습니다!")
                return
            }
        }
        
        leftEye.simdTransform = anchor.leftEyeTransform
        rightEye.simdTransform = anchor.rightEyeTransform
        
        let intersectPoints = [leftEye, rightEye].compactMap { eye -> CGPoint? in
            let hitTest = self.phonePlane.hitTestWithSegment(from: eye.target.worldPosition, to: eye.worldPosition)
            
            return hitTest.first?.screenPosition
        }
        
        guard let leftPoint = intersectPoints.first,
              let rightPoint = intersectPoints.last else { return }
        
        let centerPoint = CGPoint(x: (leftPoint.x + rightPoint.x)/2, y: -(leftPoint.y + rightPoint.y)/2)
        
        eyeGazeHistory.append(centerPoint)
        eyeGazeHistory = eyeGazeHistory.suffix(numberOfSmoothUpdates)
        
        aimImage.transform = eyeGazeHistory.averageAffineTransform
    }
}

// MARK: - ARSCNViewDelegate

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        DispatchQueue.main.async {
            self.face.simdTransform = node.simdTransform
            self.eyeTracking(using: faceAnchor)
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
