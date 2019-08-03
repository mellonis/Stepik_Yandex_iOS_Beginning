//
//  NoteListViewController.swift
//  Notes
//
//  Created by Ruslan Gilmullin on 21/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit

class NoteListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let reuseIdentifier = "NoteCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        
        let leftButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditModeOnTableView))
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Storage.updateTable {
            Storage.updateTable = false
            
            if Storage.noteUid != nil {
                Storage.noteUid = nil
                tableView.beginUpdates()
                tableView.reloadRows(at: [IndexPath(row: Storage.noteIx!, section: 0)], with: .automatic)
                tableView.endUpdates()
            } else {
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath(row: Storage.noteBook.notes.count - 1, section: 0)], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
    
    @objc private func toggleEditModeOnTableView() {
        tableView.isEditing = !tableView.isEditing
    }
    
    @objc private func addNote() {
        Storage.noteUid = nil
        Storage.noteIx = nil
        performSegue(withIdentifier: "Note", sender: self)
    }
}

extension NoteListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Storage.noteBook.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoteTableViewCell
        let note = Storage.noteBook.notes[indexPath.row]
        
        cell.noteTitleLabel.text = note.title
        cell.noteBodyLabel.text = note.content
        cell.noteTagView.layer.backgroundColor = note.color.cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Storage.noteUid = Storage.noteBook.notes[indexPath.row].uid;
        Storage.noteIx = Storage.noteBook.notes.firstIndex(where: { (note) -> Bool in
            note.uid == Storage.noteUid
        })
        performSegue(withIdentifier: "Note", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Storage.noteBook.remove(with: Storage.noteBook.notes[indexPath.row].uid)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
