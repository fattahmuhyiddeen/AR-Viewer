
import UIKit

class RootViewController: UITableViewController {
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var label: UILabel!
    
    func startLoadingState(l: String){
        DispatchQueue.main.async {
            self.label.text = "Downloading from: "+l
            self.loading.isHidden = false
        }
    }
    
    func showError(l: String){
        DispatchQueue.main.async {
            self.label.text = "Error: "+l
            self.loading.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
