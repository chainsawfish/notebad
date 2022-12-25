
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttonPlus: UIButton!{
        didSet{
            buttonPlus.layer.shadowOffset = CGSize(width: 0, height: 3)
            buttonPlus.layer.shadowRadius = 3
            buttonPlus.layer.shadowOpacity = 0.5
        }
    }
    
    
    var notes : [NoteData]?
    var loadedTitle : String = ""
    var loadedText : String = ""
    
    // MARK: reload all cells after creating or editing notes
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        reloadDataAsync()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        fetchData()

        
    }
    
    @IBAction func newNoteAddPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "mainToNewNote", sender: self)
    }
    
    
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK: load tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? 0
    }
    
    // MARK: load tableView with custom cell via xib file
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomViewCell
        guard let singleNote = self.notes?[indexPath.row] else {return cell}
        cell.labelTitle.text = singleNote.title
        return cell
    }
    
    // MARK: delete note with swipe left functionality
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            let noteToRemove = self.notes![indexPath.row]
            Constants.context.delete(noteToRemove)
            do {
                try Constants.context.save()
            } catch {
                print("error deletion and saving after \(error)")
            }
            
            self.fetchData()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //MARK: select row to edit
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: load selected cell in edit mode and close it to save
        let currentNote = notes![indexPath.row]
        loadedText = currentNote.text!
        loadedTitle = currentNote.title!
        self.performSegue(withIdentifier: "mainToOldNote", sender: self)
    }
    
    
}

// MARK: here are functions for VC
extension ViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToOldNote" {
            if let dvc = segue.destination as? NewNoteController {
            dvc.tempTitle = loadedTitle
            dvc.tempText = loadedText
        }
    }
    }
    
    func fetchData() {
        do {
            self.notes = try Constants.context.fetch(NoteData.fetchRequest())
            reloadDataAsync()
            
        }
        catch {
            print("Error fetching data from NoteData \(error)")
        }
    }
    
    func reloadDataAsync(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}




