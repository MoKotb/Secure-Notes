import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var noteText: UILabel!
    @IBOutlet weak var lockImage: UIImageView!
    
    func configureCell(note:Note){
        if note.lock{
            lockImage.isHidden = false
            noteText.text = "This note is locked. Unlock to read."
        }else{
            lockImage.isHidden = true
            noteText.text = note.message
        }
    }
}
