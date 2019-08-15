import UIKit

class NotesVC: UIViewController {

    @IBOutlet weak var notesTable: UITableView!
    
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
    
    @IBAction func addNewNote(_ sender: Any) {
        guard let createNoteVC = storyboard?.instantiateViewController(withIdentifier: CREATE_NOTE_VC_IDENTIFIER) as? CreateNoteVC else { return }
        navigationController?.pushViewController(createNoteVC, animated: true)
    }
}

extension NotesVC: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NOTE_CELL, for: indexPath) as? NoteCell {
            return cell
        }else{
            return NoteCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let noteDetailsVC = storyboard?.instantiateViewController(withIdentifier: NOTE_DETAILS_VC_IDENTIFIER) as? NoteDetailsVC else { return }
        navigationController?.pushViewController(noteDetailsVC, animated: true)
    }
}
