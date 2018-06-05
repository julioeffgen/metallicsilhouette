//
//  TimerVC.swift
//  metallicsilhouette
//
//  Created by Julio Effgen on 24/05/18.
//  Copyright © 2018 Grupo Europa. All rights reserved.
//

import UIKit

protocol TimerVCDelegate : class {
    func save(time: String, sender: TimerVC)
}

extension Date {
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}

class TimerVC: UIViewController {
    var timer = Timer()
    let calendar = Calendar.current
    weak var delegate: TimerVCDelegate?
    let formatTime = DateFormatter()
    let maxSeconds = 120
    let oneMinute = 60
    
    @IBOutlet weak var stop: UIBarButtonItem!
    @IBOutlet weak var play: UIBarButtonItem!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var manualTime: UITextField!
    @IBOutlet weak var targetImage: UIImageView!
    var targetImageName: String = "Clock"
    var secondsRemaining: Int!
    var secondsSlapsed: Int!
    var secondsSaved: Int!
    var dateSlapsed: Date!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.formatTime.dateStyle = .none
        self.formatTime.timeStyle = .short
        self.formatTime.locale = Locale(identifier: "pt_BR")
        self.formatTime.dateFormat = "HH:mm"
        self.stop.isEnabled = false
        self.secondsSaved = 0
        self.timeLabel.text = "02:00"
        self.manualTime.text = "00:00"
        let addButtonBar = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save(_:)))
        self.navigationItem.rightBarButtonItem = addButtonBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.targetImage.image = UIImage(named: self.targetImageName)
    }
    
    @IBAction func start(_ sender: Any) {
        self.secondsRemaining = self.maxSeconds - self.secondsSaved
        self.secondsSlapsed = self.secondsSaved
        self.dateSlapsed = Date()
        self.timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,      selector: #selector(timerRunning), userInfo: nil, repeats: true)
        self.play.isEnabled = false
        self.stop.isEnabled = true
    }
    
    @IBAction func stop(_ sender: Any) {
        self.secondsSaved = self.secondsSlapsed
        self.timer.invalidate()
        self.play.isEnabled = true
        self.stop.isEnabled = false
    }
    
    @IBAction func reset(_ sender: Any) {
        self.stop(sender)
        self.timeLabel.text = "02:00"
        self.manualTime.text = "00:00"
        self.secondsRemaining = self.maxSeconds
        self.secondsSlapsed = 0
        self.play.isEnabled = true
        self.stop.isEnabled = false
    }
    
    @IBAction func save(_ sender: Any) {
        self.delegate?.save(time: self.manualTime.text!, sender: self)
    self.navigationController?.popViewController(animated: true)
    }
    
    func time(seconds: Int) -> String {
        let minutes = Int(seconds) / self.oneMinute % self.oneMinute
        let seconds = Int(seconds) % self.oneMinute
        var minutesPad = "\(minutes)"
        if minutes < 10 {
            minutesPad = "0\(minutesPad)"
        }
        var secondsPad = "\(seconds)"
        if seconds < 10 {
            secondsPad = "0\(secondsPad)"
        }
        return ("\(minutesPad):\(secondsPad)")
    }
    
    func slapsedTime() {
        self.manualTime.text = self.time(seconds: self.secondsSlapsed)
    }
    
    @objc func timerRunning() {
        self.secondsSlapsed = Date().interval(ofComponent: .second, fromDate: self.dateSlapsed) + self.secondsSaved
        self.secondsRemaining = self.maxSeconds - self.secondsSlapsed
        self.timeLabel.text = self.time(seconds: self.secondsRemaining)
        self.slapsedTime()
        if self.secondsSlapsed >= 120 {
            self.stop(self)
        }
    }
}
