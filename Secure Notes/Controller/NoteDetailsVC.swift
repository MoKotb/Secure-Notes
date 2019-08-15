import UIKit

class NoteDetailsVC: UIViewController {

    @IBOutlet weak var noteText: UILabel!
    @IBOutlet weak var lockButton: UIButton!
    
    var note:Note!
    var isLocked = false
    
    func initData(note:Note){
        self.note = note
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        navigationController?.topViewController?.title = "Note Details"
        lockButton.bindToKeyboard()
        setNoteData()
    }
    
    private func setNoteData(){
        noteText.text = note.message
        if note.lock{
            lockButton.setTitle("Unlock Note", for: .normal)
        }else{
            lockButton.setTitle("Lock Note", for: .normal)
        }
        isLocked = note.lock == true ? false : true
    }
    
    @IBAction func onLockPressed(_ sender: Any) {
        lockButton.isEnabled = false
        DataService.sharedInstance.updateNote(note: note, isLocked: isLocked) { (success) in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
            self.lockButton.isEnabled = true
        }
    }
}
