import UIKit

import ZIPFoundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var task: URLSessionDownloadTask? = nil
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
//    let url  = "ofoar://open?model=https://ahadd-cdn.azureedge.net/ahadd-container/augmented/156-75254acf-fc2f-4588-bd03-439305eda0c5.zip"
    
    return true
  }  
  
  
  
  func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                   restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    downloadAndExtractModel(userActivity.webpageURL!)
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool{
    //first launch after install
    downloadAndExtractModel(url)
    return true
  }
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool{
    //first launch after install for older iOS version
    downloadAndExtractModel(url)
    return true
  }
  


  func extractZIP(at url: URL) {
    
    let fileManager = FileManager.default
    let extractedURL = fileManager.temporaryDirectory.appendingPathComponent("ExtractedModel")
    
    do {
      print("unzipping")
      try fileManager.createDirectory(at: extractedURL, withIntermediateDirectories: true, attributes: nil)
      try fileManager.unzipItem(at: url, to: extractedURL)
      print("success unzip")
    } catch {
      print("ZIP extraction error: \(error)")
    }
    
  }


  func downloadAndExtractModel(_ url: URL) {
    let fileManager = FileManager.default
    let extractedURL = fileManager.temporaryDirectory.appendingPathComponent("ExtractedModel")
    
    guard let arModelURL = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems?.first(where: { $0.name == "model" })?.value,
          let modelURL = URL(string: arModelURL) else {
    
        if let r = window?.rootViewController as? UINavigationController,
            let r1 = r.viewControllers.first as? RootViewController {
            print("r: \(type(of: r))") // Print the class name
            print("r1: \(type(of: r1))") // Print the class name
            r1.showError(l:"invalid deep link URL")
           }
      return
    }
    
    //        let modelURL = URL(string: "https://ahadd-cdn.azureedge.net/ahadd-container/augmented/156-75254acf-fc2f-4588-bd03-439305eda0c5.zip")!
    let destinationURL = fileManager.temporaryDirectory.appendingPathComponent("model.zip")
      
      if let r = window?.rootViewController as? UINavigationController,
          let r1 = r.viewControllers.first as? RootViewController {
          r1.startLoadingState(l:arModelURL)
         }
      

    task = URLSession.shared.downloadTask(with: modelURL) { tempURL, response, error in
      guard let tempURL = tempURL, error == nil else {
          if let r = self.window?.rootViewController as? UINavigationController,
              let r1 = r.viewControllers.first as? RootViewController {
              r1.showError(l:"Download error: \(error!)")
             }
        return
      }
      
      do {
          if let r = self.window?.rootViewController as? UINavigationController,
              let r1 = r.viewControllers.first as? RootViewController {
              r1.startLoadingState(l:"download success")
             }
        if FileManager().fileExists(atPath: destinationURL.path) {
          print("File already exists [\(destinationURL.path)]")
          try! FileManager().removeItem(at: destinationURL)
          print("deleted file")
        }        
        
        print("moving")
        try fileManager.moveItem(at: tempURL, to: destinationURL)

          if let r = self.window?.rootViewController as? UINavigationController,
              let r1 = r.viewControllers.first as? RootViewController {
              r1.startLoadingState(l:"extracting")
             }
          
        self.extractZIP(at: destinationURL)
        print("extracted")
        
        do {
          let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
          //                    let Path = documentURL.appendingPathComponent(fileManager.temporaryDirectory.path).absoluteURL
          let directoryContents = try fileManager.contentsOfDirectory(at: extractedURL, includingPropertiesForKeys: nil, options: [])
          
          print("contentsssss",directoryContents)

          // get the scn file
          let scnFilePath = directoryContents.first(where: { $0.pathExtension == "scn" })
          print("scnFilePath",scnFilePath)

          // open the ARView
          self.openARView(modelURL: scnFilePath!)
        }
        catch {
            if let r = self.window?.rootViewController as? UINavigationController,
                let r1 = r.viewControllers.first as? RootViewController {
                r1.showError(l:"error listing: "+error.localizedDescription)
               }
        }
        
        //                self.extractZIP(at: destinationURL)
      } catch {
          if let r = self.window?.rootViewController as? UINavigationController,
              let r1 = r.viewControllers.first as? RootViewController {
              r1.showError(l:"Error cannot move file: \(error)")
             }
      }
    }
      task?.resume()
    
  }




  func pushToNewViewController(modelURL: URL) {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first,
       let navController = window.rootViewController as? UINavigationController {

        let newVC = SimpleViewController()
        newVC.modelURL = modelURL
        navController.pushViewController(newVC, animated: true)
    }
}


  func openARView(modelURL: URL) {
//    DispatchQueue.main.async {
//        let viewController = SimpleViewController()
//        viewController.modelURL = modelURL
//        
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        self.window?.rootViewController = viewController
//        self.window?.makeKeyAndVisible()
//    }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          (UIApplication.shared.delegate as? AppDelegate)?.pushToNewViewController(modelURL: modelURL)
      }
      
      
      if let r = self.window?.rootViewController as? UINavigationController,
          let r1 = r.viewControllers.first as? RootViewController {
          r1.setInitialState()
         }
      
     
  }

}

