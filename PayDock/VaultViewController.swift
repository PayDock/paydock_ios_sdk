//
//  VaultViewController.swift
//  PayDock
//
//  Created by Oleksandr Omelchenko on 12.11.17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import UIKit

class VaultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- variable
    var paymentSource :[PaymentSource]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self as! UITableViewDelegate
        tableView.dataSource = self as! UITableViewDelegate as! UITableViewDataSource
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CustomCellTableViewCell") as! CustomCellTableViewCell
        var itemDictionary = paymentSource![indexPath.row].toDictionary()
            
            if itemDictionary != nil{
                var primary = itemDictionary["primary"] as! Bool
                print("primary \(primary)")
                if primary == true {
                    let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
                    let image = UIImage(named: "icTick", in: frameworkBundle , compatibleWith: nil)
                  cell.primaryImg.image = image
                }
                if itemDictionary["type"] as!String == "bsb"{
                    var accountNumber = itemDictionary["account_number"] as! String
                    print("Accountnumber\(accountNumber)")
                    cell.numberLabel.text = accountNumber
                    var accountName = itemDictionary["account_name"] as! String
                    print("accountname\(accountName)")
                    cell.nameLabel.text = accountName
                    
                    let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
                    let image = UIImage(named: "icBank" , in: frameworkBundle , compatibleWith: nil)
                    cell.typeImg.image = image
                }else{ //account
                    if let scheme = itemDictionary["card_scheme"] as? String
                    {
                        let cardName = ["visa","MasterCard","AMEX","Diners Club" ,"China Union Pay"]
                        let cardimg = ["icvisa","icmastercard","icamex","icdiners","iccup"]
                        print("scheme\(scheme)")
                        
                        let frameworkBundle = Bundle(identifier: "com.roundtableapps.PayDock")
                        for i in 0 ..< cardName.count{
                            if scheme == cardName[i]  {
                                let image = UIImage(named: cardimg[i], in: frameworkBundle , compatibleWith: nil)
                                cell.typeImg.image = image
                            }
                        }
                        
                    }
                    if let last4number = itemDictionary["card_number_last4"] as? String{
                        print("last4number\(last4number)")
                        cell.numberLabel.text = last4number
                    }
                    if let accountName = itemDictionary["card_name"] as? String{
                        print("accountname\(accountName)")
                        cell.nameLabel.text = accountName
                    }
                    
                    
                }
                print("&&&\(itemDictionary)")
            
            print("****************************")
        }
        
        
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (paymentSource?.count)!
    }
}
