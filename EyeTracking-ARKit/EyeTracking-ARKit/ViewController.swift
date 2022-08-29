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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
