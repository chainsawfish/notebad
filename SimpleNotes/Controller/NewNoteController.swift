import UIKit

class NewNoteController: UIViewController {
    var tempTitle = ""
    var tempText = ""
    var allNotes: [NoteData]?
    var currentIndex: Int = 0
    @IBOutlet weak var newNoteTitle: UITextField!
    @IBOutlet weak var noteTextField: UITextView!
    @IBOutlet weak var buttonSave: UIButton!{
        didSet{
            buttonSave.layer.shadowOffset = CGSize(width: 0, height: 4)
            buttonSave.layer.shadowRadius = 5
            buttonSave.layer.shadowOpacity = 0.5
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonSave(_ sender: Any) {
        saveNote()
    }
    
    // TODO: need to fix saving duplicates
    func saveNote() {
        let newNote = NoteData(context: Constants.context)
        newNote.title = newNoteTitle.text
        newNote.text = noteTextField.text
            do {
                try Constants.context.save()
            }
            catch {
                print("Error saving context data \(error)")
            }
    }
    
    // MARK: forming existing note after clicking at cell
    override func viewWillAppear(_ animated: Bool) {
        newNoteTitle.text = tempTitle
        noteTextField.text = tempText
    }
}


