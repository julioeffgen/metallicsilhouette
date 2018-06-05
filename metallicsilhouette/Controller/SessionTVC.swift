//
//  SessionTVC.swift
//  metallicsilhouette
//
//  Created by Julio Effgen on 16/05/18.
//  Copyright © 2018 Grupo Europa. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SessionTVC: UITableViewController {
    var items = Array<SessionMO>()
    var appDelegate: AppDelegate?
    var context: NSManagedObjectContext?
    var selectedIndexPath : IndexPath?
    let shorFormatDate = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.context = self.appDelegate?.persistentContainer.viewContext
        self.setupButtonBar()
        self.setupNavigationBar()
        self.tableView.register(UINib(nibName: collectionIdentifier, bundle: nil), forCellReuseIdentifier: collectionIdentifier);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.shorFormatDate.dateStyle = .medium
        self.shorFormatDate.timeStyle = .none
        self.shorFormatDate.locale = Locale(identifier: "pt_BR")
        self.shorFormatDate.dateFormat = "dd/MM/yyyy"
        self.items = Array<SessionMO>()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sessions")
        request.sortDescriptors = [NSSortDescriptor(key: "sessionDate", ascending: false)]
        request.returnsObjectsAsFaults = false
        do {
            self.items = try self.context!.fetch(request) as! [SessionMO]
        } catch {
            print("Failed")
        }
        self.tableView.reloadData()
    }
    
    // MARK: TABLEVIEW FUNCTIONS
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            do {
                let modelForRemove = self.items[indexPath.row]
                self.context!.delete(modelForRemove)
                try self.context!.save()
                self.items.remove(at: indexPath.row)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .middle)
                self.tableView.endUpdates()
            } catch {
                let alert = UIAlertController(title: "Ops", message: "Ocorreu um erro ao remover sessão.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.context!.rollback()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let totalTargets = ((self.items[indexPath.row]).targets?.array.count)!
        switch totalTargets {
        case 0:
            return CGFloat(110)
        case 1:
            return CGFloat(140)
        case 2:
            return CGFloat(165)
        default:
            return CGFloat(100 + (30 * ((self.items[indexPath.row]).targets?.array.count)!))
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: collectionIdentifier, for: indexPath) as! CollectionTC
        let model = self.items[indexPath.item]
        let sessionDateString = self.shorFormatDate.string(from: model.sessionDate!)
        var total = 0
        for target in model.targets?.array as! [TargetMO] {
            total = total + Int(target.totalDropped)
        }
        cell.setupCell(sessionName: model.sessionName!, modelType: model.type!, sessionDate: sessionDateString, score: "\(total)", targets: model.targets?.array as! [TargetMO])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "goConfigureSession", sender: self)
    }
    
    func setupButtonBar() {
        let addButtonBar = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSession))
        self.navigationItem.rightBarButtonItem = addButtonBar
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "Minhas Sessões"
    }
    
    @objc func addSession() {
        self.selectedIndexPath = nil
        self.performSegue(withIdentifier: "goConfigureSession", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goConfigureSession" {
            let destination = segue.destination as! ConfigureSessionTVC
            destination.sessionNumber = self.items.count + 1
            if self.selectedIndexPath != nil {
                destination.sessionModel = self.items[(self.selectedIndexPath?.row)!]
            }
        }
    }
}
