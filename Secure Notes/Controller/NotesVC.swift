import UIKit
import LocalAuthentication

class NotesVC: UIViewController {

    @IBOutlet weak var notesTable: UITableView!
    var notesArray = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView(){
        notesTable.delegate = self
        notesTable.dataSource = self
        notesTable.estimatedRowHeight = 100
        notesTable.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        displayAllNote()
        notesTable.reloadData()
    }
    
    private func displayAllNote(){
        DataService.sharedInstance.fetchAllNotes { (success, notesArray) in
            if success {
                if let array = notesArray , array.count > 0{
                    self.notesArray = array
                    self.notesTable.isHidden = false
                }else{
                    self.notesArray = []
                    self.notesTable.isHidden = true
                }
            }
        }
    }
    
    @IBAction func addNewNote(_ sender: Any) {
        guard let createNoteVC = storyboard?.instantiateViewController(withIdentifier: CREATE_NOTE_VC_IDENTIFIER) as? CreateNoteVC else { return }
        navigationController?.pushViewController(createNoteVC, animated: true)
    }
    
    private func authenticateBiometrics(completion:@escaping CompletionHandler){
        let myContext = LAContext()
        let myLocalizedReasonString = "Secure Notes App use Touch ID / Face ID to secure your notes"
        var authError:NSError?
        if #available(iOS 8.0 , *){
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError){
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { (success, error) in
                    if success {
                        completion(true)
                    }else{
                        guard let errorMessage = error?.localizedDescription else { return }
                        self.showErrorMessage(message: errorMessage)
                        completion(false)
                    }
                }
            }else{
                guard let errorMessage = authError?.localizedDescription else { return }
                self.showErrorMessage(message: errorMessage)
                completion(false)
            }
        }else{
            completion(false)
        }
    }
    
    private func showErrorMessage(message:String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func prepareForNoteDetails(note:Note){
        guard let noteDetailsVC = storyboard?.instantiateViewController(withIdentifier: NOTE_DETAILS_VC_IDENTIFIER) as? NoteDetailsVC else { return }
        noteDetailsVC.initData(note: note)
        navigationController?.pushViewController(noteDetailsVC, animated: true)
    }
}

extension NotesVC: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NOTE_CELL, for: indexPath) as? NoteCell {
            let note = self.notesArray[indexPath.row]
            cell.configureCell(note: note)
            return cell
        }else{
            return NoteCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = self.notesArray[indexPath.row]
        if note.lock{
            authenticateBiometrics { (success) in
                if success {
                    DataService.sharedInstance.updateNote(note: note, isLocked: false, completion: { (success) in
                        if success {
                            DispatchQueue.main.async {
                                self.prepareForNoteDetails(note: note)
                            }
                        }
                    })
                }
            }
        }else{
            prepareForNoteDetails(note: note)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
            let note = self.notesArray[indexPath.row]
            DataService.sharedInstance.deleteNote(note: note, completion: { (success) in
                if success {
                    self.displayAllNote()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            })
        }
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        return [deleteAction]
    }
}
