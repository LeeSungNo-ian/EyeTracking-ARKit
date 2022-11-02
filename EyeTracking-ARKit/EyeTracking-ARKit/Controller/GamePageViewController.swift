//
//  GamePageViewController.swift
//  EyeTracking-ARKit
//
//  Created by 이성노 on 2022/08/30.
//

import UIKit
import SceneKit
import ARKit

final class GamePageViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet var sceneView: ARSCNView!
    
    private let face = SCNNode()
    private let leftEye = EyeNode(color: .green)
    private let rightEye = EyeNode(color: .red)
    private let phonePlane = SCNNode(geometry: SCNPlane(width: 1, height: 1))
    
    private var eyeGazeHistory = Array<CGPoint>()
    private var numberOfSmoothUpdates = 25
    
    private var targets = [UIImageView]()
    private let targetNames = ["EyeTarget1", "EyeTarget2", "EyeTarget3", "EyeTarget4"]
    private var currentTarget = 0
    
    private var startGameTime = CACurrentMediaTime()
    
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
        createEnemies()
        setupAddChildNode()
        sceneView.delegate = self
        perform(#selector(createTarget), with: nil, afterDelay: 0.1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ARFaceTrackingConfiguration.isSupported {
            let configuration = ARFaceTrackingConfiguration()
            sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        }
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Custom function
    
    private func setupAddChildNode() {
        sceneView.scene.rootNode.addChildNode(face)
        sceneView.scene.rootNode.addChildNode(phonePlane)
        face.addChildNode(leftEye)
        face.addChildNode(rightEye)
    }
    
    private func eyeTracking(using anchor: ARFaceAnchor) {
        if let leftEyeBlink = anchor.blendShapes[.eyeBlinkLeft] as? Float,
           let rightEyeBlink = anchor.blendShapes[.eyeBlinkRight] as? Float {
            if leftEyeBlink > 0.2 && rightEyeBlink > 0.2 {
                shooting()
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
    
    private func createEnemies() {
        let rowStackView = UIStackView()
        rowStackView.translatesAutoresizingMaskIntoConstraints = false
        rowStackView.distribution = .fillEqually
        rowStackView.axis = .vertical
        rowStackView.spacing = 20
        
        for _ in 1...8 {
            let colStackView = UIStackView()
            colStackView.translatesAutoresizingMaskIntoConstraints = false
            colStackView.distribution = .fillEqually
            colStackView.axis = .horizontal
            colStackView.spacing = 20
            
            rowStackView.addArrangedSubview(colStackView)
            
            for imageName in targetNames {
                let imageView = UIImageView(image: UIImage(named: imageName))
                imageView.contentMode = .scaleAspectFit
                imageView.alpha = 0
                targets.append(imageView)
                
                colStackView.addArrangedSubview(imageView)
            }
        }
        
        self.view.addSubview(rowStackView)
        
        NSLayoutConstraint.activate([
            rowStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            rowStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            rowStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            rowStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20)
        ])
        
        self.view.bringSubviewToFront(aimImage)
        targets.shuffle()
    }
    
    @objc private func createTarget() {
        guard currentTarget < targets.count else {
            endGame()
            return
        }
        
        let target = targets[currentTarget]
        target.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        
        UIView.animate(withDuration: 0.1) {
            target.transform = .identity
            target.alpha = 1
        }
        currentTarget += 1
    }
    
    private func shooting() {
        guard let aimFrame = aimImage.superview?.convert(aimImage.frame, to: nil) else { return }
        
        let hitTargets = self.targets.filter { target in
            if target.alpha == 0 { return false }
            let targetFrame = target.superview!.convert(target.frame, to: nil)
            return targetFrame.intersects(aimFrame)
        }
        
        guard let selectedTarget = hitTargets.first else { return }
        
        selectedTarget.alpha = 0
        
        perform(#selector(createTarget), with: nil, afterDelay: 0.1)
    }
    
    private func endGame() {
        let gameTime = (Int(CACurrentMediaTime() - startGameTime))
        let alertController = UIAlertController(title: "게임 끝!", message: "소요시간: \(gameTime)", preferredStyle: .alert)
        present(alertController, animated: true)
        perform(#selector(backToMainMenu), with: nil, afterDelay: 4.0)
    }
    
    @objc private func backToMainMenu() {
        dismiss(animated: true) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

// MARK: - ARSCNViewDelegate

extension GamePageViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        DispatchQueue.main.async {
            self.face.simdTransform = node.simdTransform
            self.eyeTracking(using: faceAnchor)
        }
    }
}

// MARK: - extension

private extension GamePageViewController {
    func setupLayout() {
        view.addSubview(aimImage)
        aimImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        aimImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
}
