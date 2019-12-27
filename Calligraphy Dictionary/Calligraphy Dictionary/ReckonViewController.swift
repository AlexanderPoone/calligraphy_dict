//
//  ReckonViewController.swift
//  Calligraphy Dictionary
//
//  Created by Victor Poon on 25/11/2019.
//  Copyright © 2019 SoftFeta. All rights reserved.
//

import UIKit
import ARKit

class ReckonViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {


    @IBOutlet weak var mSceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        mSceneView.delegate = self
//        mSceneView.session.delegate = self
//
//        let scene = SCNScene()
//        mSceneView.scene = scene
//        mSceneView.allowsCameraControl = true
//        mSceneView.showsStatistics = true
//        mSceneView.backgroundColor = .systemGreen
//
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
//        scene.rootNode.addChildNode(cameraNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let alert = UIAlertController(title: nil, message: "Your hardware does not support this feature.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { (alert: UIAlertAction!) in
            self.performSegue(withIdentifier: "backHome", sender: nil)
        }))
        self.present(alert, animated: false, completion: nil)

                let configuration = ARWorldTrackingConfiguration()
        mSceneView.session.run(configuration)
                mSceneView.delegate = self
                mSceneView.session.delegate = self
        
                let scene = SCNScene()
                mSceneView.scene = scene
                mSceneView.allowsCameraControl = true
                mSceneView.showsStatistics = true
                mSceneView.backgroundColor = .systemGreen
        
                let cameraNode = SCNNode()
                cameraNode.camera = SCNCamera()
                cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
                scene.rootNode.addChildNode(cameraNode)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
