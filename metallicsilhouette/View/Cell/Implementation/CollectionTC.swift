//
//  CollectionTC.swift
//  metallicsilhouette
//
//  Created by Julio Effgen on 19/05/18.
//  Copyright © 2018 Grupo Europa. All rights reserved.
//

import UIKit

class CollectionTC: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var possibilityLabel: UILabel!
    var dictionary = Dictionary<Int, Array<String>>()
    let cellCollectionSize = [CGSize(width: 104, height: 27), CGSize(width: 27, height: 27), CGSize(width: 27, height: 27), CGSize(width: 27, height: 27), CGSize(width: 27, height: 27), CGSize(width: 27, height: 27), CGSize(width: 50, height: 27), CGSize(width: 70, height: 27)]
    func builBoolean(value: Bool) -> String {
        if value == true {
            return "X"
        }
        return "O"
    }
    
    func setupCell(sessionName: String, modelType: String, sessionDate: String, score: String, targets: Array<TargetMO>) {
        var index = 1
        self.dictionary = Dictionary<Int, Array<String>>()
        self.dictionary[0] = ["Alvo", "1", "2", "3", "4", "5", "Total", "Tempo"]
        var possibility = 20
        for target in targets {
            let time = target.time == nil ? "00:00" : target.time
            self.dictionary[index] = [target.type, self.builBoolean(value: target.shotOneDropped), self.builBoolean(value: target.shotTwoDropped), self.builBoolean(value: target.shotThreeDropped), self.builBoolean(value: target.shotFourDropped), self.builBoolean(value: target.shotFiveDropped), "\(target.totalDropped)", time] as? [String]
            index = index + 1
            possibility = possibility - (5 - Int(target.totalDropped))
        }
        self.dateLabel.text = sessionDate
        self.nameLabel.text = sessionName
        self.typeLabel.text = modelType
        self.totalLabel.text = "\(score) pontos"
        self.possibilityLabel.text = "\(possibility) pontos"
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: targetNameIdentifier, bundle: nil), forCellWithReuseIdentifier: targetNameIdentifier)
        self.collectionView.reloadData()
    }

    // MARK: - UICollectionViewDataSource protocol
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dictionary.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.dictionary[section]?.count)!
    }

    func configureHeaderSection(source: Array<String>, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: targetNameIdentifier, for: indexPath as IndexPath) as! TargetNameCC
        cell.setupCell(value: source[indexPath.row], alignment: NSTextAlignment.center)
        cell.backgroundColor = UIColor.groupTableViewBackground
        cell.labelValue.font = UIFont.boldSystemFont(ofSize: 13)
        return cell
    }

    func configureLineSection(source: Array<String>, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: targetNameIdentifier, for: indexPath as IndexPath) as! TargetNameCC
        var alignment = NSTextAlignment.center
        if indexPath.row == 0 {
            alignment = NSTextAlignment.left
        }
        cell.setupCell(value: source[indexPath.row], alignment: alignment)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return self.configureHeaderSection(source: dictionary[indexPath.section]!, indexPath: indexPath)
        }
        return self.configureLineSection(source: dictionary[indexPath.section]!, indexPath: indexPath)
    }

    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.cellCollectionSize[indexPath.row]
    }

}
