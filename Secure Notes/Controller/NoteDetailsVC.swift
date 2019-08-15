import UIKit

class NoteDetailsVC: UIViewController {

    @IBOutlet weak var noteText: UILabel!
    @IBOutlet weak var lockButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        navigationController?.topViewController?.title = "Note Details"
        lockButton.bindToKeyboard()
    }
    
    @IBAction func onLockPressed(_ sender: Any) {
        
    }
}
