
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
        closeButton.frame = CGRect(x: 20, y: 50, width: 30, height: 30)
//        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: UIControl.Event.touchUpInside)
        closeButton.layer.cornerRadius = 15
        closeButton.backgroundColor = UIColor(white: 0.9, alpha: 0.8) // Light gray bg
        closeButton.isHidden = true
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])



    }
    
            @objc func closeButtonTapped() {
                isCancelled=true
                // Close action
//                dismiss(animated: true, completion: nil)
                setInitialState()
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.task?.cancel()// ✅ Call successful
                       }
                
            }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
