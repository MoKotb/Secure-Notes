import UIKit
import CoreData

class DataService {
    
    static let sharedInstance = DataService()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func saveNote(message:String,isLocked:Bool,completion:@escaping CompletionHandler){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let note = Note(context: managedContext)
        note.message = message
        note.lock = isLocked
        do{
            try managedContext.save()
            completion(true)
        }catch{
            debugPrint("DataService.saveNote() \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func fetchAllNotes(completion:@escaping (_ Success:Bool,_ notesArray:[Note]?) -> ()){
        var notesArray = [Note]()
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        do{
            notesArray = try managedContext.fetch(fetchRequest)
            completion(true,notesArray)
        }catch{
            debugPrint("DataService.fetchAllNotes() \(error.localizedDescription)")
            completion(false,nil)
        }
    }
    
    func updateNote(note:Note,isLocked:Bool,completion:@escaping CompletionHandler){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        note.lock = isLocked
        do{
            try managedContext.save()
            completion(true)
        }catch{
            debugPrint("DataService.updateNote() \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func deleteNote(note:Note,completion:@escaping CompletionHandler){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        managedContext.delete(note)
        do{
            try managedContext.save()
            completion(true)
        }catch{
            debugPrint("DataService.deleteNote() \(error.localizedDescription)")
            completion(false)
        }
    }
}
