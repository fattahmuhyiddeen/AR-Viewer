
import UIKit

class RootViewController: UITableViewController {
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var label: UILabel!
    private let dataSource = SampleDataSource()
    
    func startLoadingState(l: String){
        DispatchQueue.main.async {
            self.label.text = "Downloading from: "+l
            self.loading.isHidden = false
        }
    }
    
    func showError(l: String){
        DispatchQueue.main.async {
            self.label.text = "Downloading from: "+l
            self.loading.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? RootViewCell else {fatalError()}
        
        let sample = dataSource.samples[(indexPath as NSIndexPath).row]
        cell.showSample(sample)
        
        return cell
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sample = dataSource.samples[(indexPath as NSIndexPath).row]
        
        navigationController?.pushViewController(sample.controller(), animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
