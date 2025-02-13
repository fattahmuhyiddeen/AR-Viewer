//
//  SimpleViewController.swift
//  ARKit-Sampler
//
//  Created by Shuichi Tsutsumi on 2017/09/20.
//  Copyright © 2017 Shuichi Tsutsumi. All rights reserved.
//

import UIKit
import ARKit

class SimpleViewController: UIViewController {
  
  var modelURL: URL?
  
  var sceneView: ARSCNView!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    // Create and setup sceneView
    sceneView = ARSCNView(frame: view.bounds)
    view.addSubview(sceneView)
    
    // Load scene
    if let modelURL = modelURL {
      sceneView.allowsCameraControl = true
      sceneView.scene = SCNScene(named: modelURL.lastPathComponent, inDirectory: modelURL.deletingLastPathComponent().path)!
    } else {
      print("No model URL provided")
      
      let alert = UIAlertController(title: "Error", message: "No model URL provided", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      present(alert, animated: true)
      
    }
    
    // sceneView.scene = SCNScene(named: "ship.scn", inDirectory: "models.scnassets/ship")!
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    sceneView.session.run(ARWorldTrackingConfiguration())
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    sceneView.session.pause()
  }
}
