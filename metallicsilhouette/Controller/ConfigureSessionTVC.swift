//
//  ConfigureSessionTVC.swift
//  metallicsilhouette
//
//  Created by Julio Effgen on 16/05/18.
//  Copyright © 2018 Grupo Europa. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// MARK: CONTROLLER EXTENSIONS
let sectionsNumbers = 2

extension ConfigureSessionTVC {
    @objc func saveSession() {
        if self.isEditingMode {
            self.updateSession()
        } else {
            self.createSession()
        }
    }
    
    func createSession() {
        do {
            try self.context?.save()
            self.savedData = true
            self.navigationController?.popViewController(animated: true)
        } catch {
            let alert = UIAlertController(title: "Ops", message: "Ocorreu um erro ao salvar sua sessão.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.context!.rollback()
        }
    }
    
    func updateSession() {
        print("Mandando o update")
    }
}

class ConfigureSessionTVC: UITableViewController, TimerVCDelegate, OnlyDateTCDelegate, TextFieldTCDelegate, PickViewTCDelegate, TargetSilhouetteTCDelegate {
    var appDelegate: AppDelegate?
    var context: NSManagedObjectContext?
    var selectedTargetCell : TargetSilhouetteTC?
    var selectedTargetImageName : String?
    
    var cellDate: OnlyDateTC?
    var cellPicker: PickViewTC?
    var toolBar: UIToolbar?
    var sessionModel: SessionMO?
    var sessionNumber = 0
    var isEditingMode = false
    var tableRows = Dictionary<Int, String>()
    var savedData = false
    var navigatedToTimer = false
    
    var datePicker = UIDatePicker()
    var myPickerView : UIPickerView!
    var pickerData = ["", "Metal" , "Papel"]
    let shorFormatDate = DateFormatter()
    
    // MARK: VIEW START
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.datePickerMode = UIDatePickerMode.date
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.context = self.appDelegate?.persistentContainer.viewContext
        self.shorFormatDate.dateStyle = .medium
        self.shorFormatDate.timeStyle = .none
        self.shorFormatDate.locale = Locale(identifier: "pt_BR")
        self.shorFormatDate.dateFormat = "dd/MM/yyyy"
        self.setupButtonBar()
        self.setupNavigationBar()
        self.configureCells()
        self.toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(ConfigureSessionTVC.dismissPicker))
        self.tableView.register(UINib(nibName: "OnlyDateTC", bundle: nil), forCellReuseIdentifier: "OnlyDateTC");
        self.tableView.register(UINib(nibName: "TextFieldTC", bundle: nil), forCellReuseIdentifier: "TextFieldTC");
        self.tableView.register(UINib(nibName: "PickViewTC", bundle: nil), forCellReuseIdentifier: "PickViewTC");
        self.tableView.register(UINib(nibName: "TargetSilhouetteTC", bundle: nil), forCellReuseIdentifier: "TargetSilhouetteTC");
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.sessionModel == nil {
            self.sessionModel = SessionMO(context: self.context!)
            self.sessionModel?.sessionDate = Date()
            self.sessionModel?.type = "Metal"
            self.sessionModel?.sessionName = "Sessão \(self.sessionNumber)"
        } else {
            self.navigationItem.title = self.sessionModel?.sessionName
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !self.savedData && !self.navigatedToTimer {
            self.context!.rollback()
        }
    }
    
    func buildTarget(title: String) -> TargetMO {
        let target = TargetMO(context: self.context!)
        target.type = title;
        target.totalDropped = 0;
        return target
    }
    
    func configureCells() {
        self.tableRows[1] = "Data da Sessão"
        self.tableRows[2] = "Nome da Sessão"
        self.tableRows[3] = "Tipo de Alvo"
    }
    
    func setupButtonBar() {
        let saveButtonBar = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSession))
        self.navigationItem.rightBarButtonItem = saveButtonBar
    }
    
    func setupNavigationBar() {
        if self.isEditingMode {
            self.navigationItem.title = "Atualizar Sessão"
        } else {
            self.navigationItem.title = "Nova Sessão"
        }
    }
    
    // MARK: TABLEVIEW FUNCTIONS
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.sessionModel?.removeFromTargets(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .middle)
            self.tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }
        let frame: CGRect = tableView.frame
        
        let titleSection: UILabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: 30))
        titleSection.font = UIFont.boldSystemFont(ofSize: 16)
        titleSection.text = "Alvos"
        let targetButton: UIButton = UIButton(frame: CGRect(x: frame.size.width - 40, y: 0, width: 30, height: 30))
        targetButton.setImage(UIImage(named: "ButtonAdd"), for: UIControlState.normal)
        targetButton.setImage(UIImage(named: "ButtonAdd"), for: UIControlState.highlighted)
        targetButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        targetButton.backgroundColor = UIColor.clear
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        headerView.backgroundColor = UIColor.groupTableViewBackground
        headerView.addSubview(targetButton)
        headerView.addSubview(titleSection)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 30
    }
    
    @objc func buttonTapped(sender: UIButton) {
        if (self.sessionModel?.targets?.array.count)! >= 4 {
            let alert = UIAlertController(title: "Ops", message: "Você não pode adicionar mais de 4 alvos na sessão.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "Galinha", style: .default) { action -> Void in
            self.sessionModel?.addToTargets(self.buildTarget(title: "Galinha"))
            self.insertRow(atIndex: (self.sessionModel?.targets?.array.count)!, inSection: 1)
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Porco", style: .default) { action -> Void in
            self.sessionModel?.addToTargets(self.buildTarget(title: "Porco"))
            self.insertRow(atIndex: (self.sessionModel?.targets?.array.count)!, inSection: 1)
        }
        
        let thirdAction: UIAlertAction = UIAlertAction(title: "Peru", style: .default) { action -> Void in
            self.sessionModel?.addToTargets(self.buildTarget(title: "Peru"))
            self.insertRow(atIndex: (self.sessionModel?.targets?.array.count)!, inSection: 1)
        }
        
        let fourthAction: UIAlertAction = UIAlertAction(title: "Carneiro", style: .default) { action -> Void in
            self.sessionModel?.addToTargets(self.buildTarget(title: "Carneiro"))
            self.insertRow(atIndex: (self.sessionModel?.targets?.array.count)!, inSection: 1)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(thirdAction)
        actionSheetController.addAction(fourthAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
    func insertRow(atIndex: Int, inSection: Int) {
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath(row: atIndex - 1, section: inSection)], with: UITableViewRowAnimation.top)
        self.tableView.endUpdates()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsNumbers
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.tableRows.count
        } else {
            return (self.sessionModel?.targets?.array.count)!
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 40
        } else {
            return 80
        }
    }
    
    @objc func showTimer() {
        self.performSegue(withIdentifier: "showTimer", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "OnlyDateTC", for: indexPath) as! OnlyDateTC;
                cell.setupCell(fieldTitle: self.tableRows[indexPath.row+1]!, dateValue: self.shorFormatDate.string(from: (self.sessionModel?.sessionDate)!), datePicker: self.datePicker, delegate: self, toolBar: self.toolBar!)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTC", for: indexPath) as! TextFieldTC;
                cell.setupCell(fieldTitle: self.tableRows[indexPath.row+1]!, fieldValue: (self.sessionModel?.sessionName)!, delegate: self)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PickViewTC", for: indexPath) as! PickViewTC;
                cell.setupCell(fieldTitle: self.tableRows[indexPath.row+1]!, fieldValue: (self.sessionModel?.type)!, delegate: self)
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TargetSilhouetteTC", for: indexPath) as! TargetSilhouetteTC;
            self.configureTargetCell(target: (self.sessionModel?.targets?.array[(indexPath.row)])! as! TargetMO, cell: cell)
            return cell
        }
    }
    
    func configureTargetCell(target: TargetMO, cell: TargetSilhouetteTC) {
        switch target.type {
        case "Galinha":
            cell.setupCell(target: target, imageName: "Chicken", imageDroppedName: "DroppedChicken", delegate: self)
        case "Porco":
            cell.setupCell(target: target, imageName: "Pork", imageDroppedName: "DroppedPork", delegate: self)
        case "Peru":
            cell.setupCell(target: target, imageName: "Turkey", imageDroppedName: "DroppedTurkey", delegate: self)
        default:
            cell.setupCell(target: target, imageName: "Muttun", imageDroppedName: "DroppedMuttun", delegate: self)
        }
    }
    
    // MARK: DELEGATE FUNCTIONS
    func save(time: String, sender: TimerVC) {
        let index = self.tableView.indexPath(for: self.selectedTargetCell!)
        (self.sessionModel?.targets?.array[(index?.row)!] as! TargetMO).time = time
        self.tableView.reloadRows(at: [index!], with: UITableViewRowAnimation.automatic)
    }
    
    func didOpenDatePicker(sender: OnlyDateTC) {
        self.cellDate = sender
        if self.datePicker.allTargets.count > 0 {
            self.datePicker.removeTarget(self, action: #selector(didSelectDate(datePicker: )), for: UIControlEvents.valueChanged)
        }
        self.datePicker.addTarget(self, action:#selector(didSelectDate(datePicker: )), for: UIControlEvents.valueChanged)
    }
    
    func didChangeValue(sender: TargetSilhouetteTC) {
        let indexPath = self.tableView.indexPath(for: sender)
        (self.sessionModel?.targets?.array[(indexPath?.row)!] as! TargetMO).shotOneDropped = sender.oneDropped
        (self.sessionModel?.targets?.array[(indexPath?.row)!] as! TargetMO).shotTwoDropped = sender.twoDropped
        (self.sessionModel?.targets?.array[(indexPath?.row)!] as! TargetMO).shotThreeDropped = sender.threeDropped
        (self.sessionModel?.targets?.array[(indexPath?.row)!] as! TargetMO).shotFourDropped = sender.fourDropped
        (self.sessionModel?.targets?.array[(indexPath?.row)!] as! TargetMO).shotFiveDropped = sender.fiveDropped
        (self.sessionModel?.targets?.array[(indexPath?.row)!] as! TargetMO).totalDropped = Int16(sender.total)
    }
    
    func didStartCountTime(sender: TargetSilhouetteTC) {
        self.selectedTargetCell = sender
        self.selectedTargetImageName = sender.imageName
        self.showTimer()
    }
    
    @objc func dismissPicker() {
        self.view.endEditing(true)
    }
    
    @objc func didSelectDate(datePicker: UIDatePicker) {
        self.cellDate?.fieldValue.text = self.shorFormatDate.string(from: datePicker.date)
        self.sessionModel?.sessionDate = datePicker.date
    }
    
    func didEndEditing(sender: TextFieldTC) {
        self.sessionModel?.sessionName = sender.fieldValue.text!
    }
    
    func didOpenPickView(sender: PickViewTC) {
        self.cellPicker = sender
        self.pickUp(sender.fieldValue)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTimer" {
            let destination = segue.destination as! TimerVC
            destination.delegate = self
            destination.targetImageName = self.selectedTargetImageName!
            self.navigatedToTimer = true
        }
    }

}
