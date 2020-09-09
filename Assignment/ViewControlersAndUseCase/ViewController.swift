//
//  ViewController.swift
//  Assignment
//
//  Created by Ayan Chakraborty on 07/09/20.
//  Copyright © 2020 Assignment Ayan Chakraborty. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {
    
    @IBOutlet weak var cardView: CustomCardView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var infoLabel1: UILabel!
    @IBOutlet weak var infoLabel2: UILabel!
    @IBOutlet weak var infoLabel3: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        img.layer.cornerRadius = 8
        infoLabel1.layer.cornerRadius = 4
        infoLabel1.layer.masksToBounds = true
        infoLabel2.layer.cornerRadius = 4
        infoLabel2.layer.masksToBounds = true
        
    }
    
    var data: Item? {
        didSet{
            name.text = StrAny(data?.itemName)
            img.downloadFromURL(url: data?.image ?? "N/A")
            let amount = "\(StrAny(data?.currency)) \(StrAny(data?.price))"
            infoLabel2.text = " \(StrAny(data?.currency)) \(StrAny(String(format: "%.2f", data?.offerPrice ?? 0))) "
            infoLabel1.attributedText =  amount.strikeThrough()
            infoLabel3.text = "Category: \(StrAny(data?.category)) Type: \(StrAny(data?.foodType))"
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    
    var itemList: [Item] = []
    
    lazy var useCase: ViewControllerUseCase = {
        let use = ViewControllerUseCase()
        use.delegate = self
        return use
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let _ = useCase
    }
    
    
}

extension ViewController: ViewControllerDelegate{
    
    func updateItems(list: [Item]) {
        if itemList.isEmpty {
            self.itemList = list
            self.tableView?.reloadData()
        }else{
            list.forEach { (itm) in
                self.itemList.append(itm)
            }
            self.tableView?.reloadData()
        }
    }
    
    func showError(str: String) {
        let alert = UIAlertController(title: "Error", message: str, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        cell.data = itemList[indexPath.row]
        if indexPath.row == itemList.count - 1 {
            useCase.fetchData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }
    
    
}

