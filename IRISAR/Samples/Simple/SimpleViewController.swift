import UIKit
import ARKit

class SimpleViewController: UIViewController {
  
  var modelURL: URL?
  
  var sceneView: ARSCNView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
      
      sceneView = ARSCNView(frame: view.bounds)
      view.addSubview(sceneView)
      
      
      
      // let closeButton = UIButton(type: .system)
      //         closeButton.setTitle("✕", for: .normal)
      //         closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
      //         closeButton.tintColor = .white
      //         closeButton.backgroundColor = .red
      //         closeButton.layer.cornerRadius = 20
      //         closeButton.translatesAutoresizingMaskIntoConstraints = false
      //         closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

      //         view.addSubview(closeButton)

      //         NSLayoutConstraint.activate([
      //             closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      //             closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      //             closeButton.widthAnchor.constraint(equalToConstant: 40),
      //             closeButton.heightAnchor.constraint(equalToConstant: 40)
      //         ])
      
  }
    
    
    @objc func closeTapped() {
        DispatchQueue.main.async {
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {

                window.rootViewController = RootViewController()
                window.makeKeyAndVisible()
            }
        }
    }
    
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if let modelURL = modelURL {
      print("modelURL", modelURL)
      
      // sceneView.allowsCameraControl = true
      do {
        let scene = try SCNScene(url: modelURL, options: nil)
        sceneView.scene = scene
      } catch {
        print("Failed to load scene from:", modelURL)
        let alert = UIAlertController(title: "Error", 
                                    message: "Failed to load 3D model", 
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
      }
    }
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
