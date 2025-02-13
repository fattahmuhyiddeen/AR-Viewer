//
//  AppDelegate.swift
//  ARKit-Sampler
//
//  Created by Shuichi Tsutsumi on 2017/09/20.
//  Copyright © 2017 Shuichi Tsutsumi. All rights reserved.
//

import UIKit

import ZIPFoundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let url  = "ofoar://open?model=https://ahadd-cdn.azureedge.net/ahadd-container/augmented/156-75254acf-fc2f-4588-bd03-439305eda0c5.zip"

    
    
    self.downloadAndExtractModel(URL.init(string: url)!);
    
    return true
    
    
  }  
  
  
  
  func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                   restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    //    handleDeepLinkUrl(userActivity.webpageURL)
    downloadAndExtractModel(userActivity.webpageURL!)
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool{
    //first launch after install
    //    handleDeepLinkUrl(url)
    downloadAndExtractModel(url)
    return true
  }
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool{
    //first launch after install for older iOS version
    //    handleDeepLinkUrl(url)
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
      
      let scnFilePath = extractedURL.appendingPathComponent("Oya_500k_2048x40 copy.scn").path
      DispatchQueue.main.async {
        //                self.loadModel(from: scnFilePath)
      }
    } catch {
      print("ZIP extraction error: \(error)")
    }
    
  }


  func downloadAndExtractModel(_ url: URL) {
    
    let fileManager = FileManager.default
    let extractedURL = fileManager.temporaryDirectory.appendingPathComponent("ExtractedModel")
    
    let dataSource = SampleDataSource()
    
    guard let arModelURL = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems?.first(where: { $0.name == "model" })?.value,
          let modelURL = URL(string: arModelURL) else {
      //        showError("Invalid deep link URL")
      print("invalid deep link URL")
      return
    }
    
    //        let modelURL = URL(string: "https://ahadd-cdn.azureedge.net/ahadd-container/augmented/156-75254acf-fc2f-4588-bd03-439305eda0c5.zip")!
    let destinationURL = fileManager.temporaryDirectory.appendingPathComponent("model.zip")
    print("downloading")
    let task = URLSession.shared.downloadTask(with: modelURL) { tempURL, response, error in
      guard let tempURL = tempURL, error == nil else {
        print("Download error: \(error!)")
        return
      }
      
      do {
        print("download success")
        if FileManager().fileExists(atPath: destinationURL.path) {
          print("File already exists [\(destinationURL.path)]")
          try! FileManager().removeItem(at: destinationURL)
          print("deleted file")
        }        
        
        print("moving")
        try fileManager.moveItem(at: tempURL, to: destinationURL)
        print("extracting")
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
          
          //                    navigationController?.pushViewController(dataSource.samples[2].controller(), animated: true)
        }
        catch {
          print("xxxx error listing",error.localizedDescription)
        }
        
        //                self.extractZIP(at: destinationURL)
      } catch {
        print("File move error: \(error)")
      }
    }
    task.resume()
    
  }

  func openARView(modelURL: URL) {
    DispatchQueue.main.async {
        let viewController = SimpleViewController()
        viewController.modelURL = modelURL
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }
  }

}

