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

    private lazy var cryScleraImage: UIImageView = {
        let imageView = UIImageView()
        let cryScleraImage: UIImage = UIImage(named: "CrySclera")!
        imageView.image = cryScleraImage
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    private lazy var pupilImage: UIImageView = {
        let imageView = UIImageView()
        let pupilImage: UIImage = UIImage(named: "Pupil")!
        imageView.image = pupilImage
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.MainBackgroundColor
        UIApplication.shared.isIdleTimerDisabled = true
        
        configureUI()
    }
    
    //MARK: - Helpers

    func configureUI() {
        view.addSubview(cryScleraImage)
        cryScleraImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        cryScleraImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        cryScleraImage.addSubview(pupilImage)
        pupilImage.topAnchor.constraint(equalTo: cryScleraImage.topAnchor, constant: 32).isActive = true
        pupilImage.trailingAnchor.constraint(equalTo: cryScleraImage.trailingAnchor, constant: -25).isActive = true
    }
    
    // MARK: - Custom function

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "GamePageVC") {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
