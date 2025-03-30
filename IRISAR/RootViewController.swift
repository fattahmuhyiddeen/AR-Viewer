
import UIKit

class RootViewController: UITableViewController {
    @IBOutlet weak var loading: UIActivityIndicatorView!
    var closeButton: UIButton = UIButton(type: .system)
    var isCancelled = false
    
    @IBOutlet weak var label: UILabel!
    
    func startLoadingState(l: String){
        isCancelled=false
        DispatchQueue.main.async {
            self.label.text = "Downloading from: "+l
            self.loading.isHidden = false
            self.closeButton.isHidden = false
        }
    }
    
    func showError(l: String){
        if(!isCancelled) {
            DispatchQueue.main.async {
                self.label.text = "Error: "+l
                self.loading.isHidden = true
            }
        }
    }
    
    func setInitialState(){
        DispatchQueue.main.async {
            self.label.text = "Tap on any deeplink in another app to open AR model"
            self.loading.isHidden = true
            self.closeButton.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialState()
        view.backgroundColor = .black
        
        closeButton.setTitle("", for: UIControl.State.normal)
        closeButton.setImage(UIImage(systemName: "xmark"), for: UIControl.State.normal)
        closeButton.tintColor = UIColor.black
        closeButton.frame = CGRect(x: UIScreen.main.bounds.width-40, y: 0, width: 30, height: 30)
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: UIControl.Event.touchUpInside)
        closeButton.layer.cornerRadius = 15
        closeButton.backgroundColor = UIColor(white: 0.9, alpha: 0.8) // Light gray bg
        closeButton.isHidden = true
        view.addSubview(closeButton)
    }
    
    @objc func closeButtonTapped() {
                isCancelled=true
                setInitialState()
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.task?.cancel()
                       }
                
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
