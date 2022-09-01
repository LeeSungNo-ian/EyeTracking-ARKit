//
//  MainPageViewController.swift
//  EyeTracking-ARKit
//
//  Created by 이성노 on 2022/09/01.
//

import UIKit
import SceneKit
import ARKit

class MainPageViewController: UIViewController {
    
    // MARK: - Properties

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.MainBackgroundColor
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    // MARK: - Custom function

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "GamePageVC") {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
