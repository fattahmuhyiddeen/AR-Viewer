//
//  RootViewController.swift
//  ARKit-Sampler
//
//  Created by Shuichi Tsutsumi on 2017/09/20.
//  Copyright © 2017 Shuichi Tsutsumi. All rights reserved.
//

import UIKit




class RootViewController: UITableViewController {

    private let dataSource = SampleDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO return dataSource.samples.count if want to display sample app
        return 0 //dataSource.samples.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? RootViewCell else {fatalError()}
        
        let sample = dataSource.samples[(indexPath as NSIndexPath).row]
        cell.showSample(sample)
        
        return cell
    }
    
    // MARK: UITableViewDelegate
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sample = dataSource.samples[(indexPath as NSIndexPath).row]
        
        navigationController?.pushViewController(sample.controller(), animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
