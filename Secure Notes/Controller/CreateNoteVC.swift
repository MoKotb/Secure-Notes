import UIKit

class CreateNoteVC: UIViewController {

    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var lockButton: RoundedButton!
    @IBOutlet weak var unlockButton: RoundedButton!
    @IBOutlet weak var createNoteButton: UIButton!
    
    var noteType:NoteType = .Lock
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        navigationController?.topViewController?.title = "Create Note"
        noteTextView.delegate = self
        configureLockButton(noteType: noteType)
        handleOnTap()
        createNoteButton.bindToKeyboard()
    }
    
    private func handleOnTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func closeKeyboard(){
        self.view.endEditing(true)
    }
    
    @IBAction func lockNotePressed(_ sender: Any) {
        noteType = .Lock
        configureLockButton(noteType: noteType)
    }
    
    @IBAction func unlockNotePressed(_ sender: Any) {
        noteType = .Unlock
        configureLockButton(noteType: noteType)
    }
    
    private func configureLockButton(noteType:NoteType){
        if noteType == .Lock{
            lockButton.setSelectedColor()
            unlockButton.setDeselectedColor()
        }else{
            lockButton.setDeselectedColor()
            unlockButton.setSelectedColor()
        }
    }
    
    @IBAction func createNewNote(_ sender: Any) {
        createNoteButton.isEnabled = false
        addNote()
    }
    
    private func addNote(){
        guard let noteText = noteTextView.text else { return }
        let isLocked = noteType == .Lock ? true : false
        DataService.sharedInstance.saveNote(message: noteText, isLocked: isLocked) { (success) in
            if success{
                self.navigationController?.popViewController(animated: true)
            }
            self.createNoteButton.isEnabled = true
        }
    }
}

extension CreateNoteVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let noteText = noteTextView.text else { return }
        if noteText != "" , noteText != "What's on your mind?" {
            noteTextView.text = noteText
        }else{
            noteTextView.text = ""
        }
        noteTextView.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
