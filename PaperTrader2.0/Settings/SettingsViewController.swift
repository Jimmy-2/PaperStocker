//
//  SettingsViewController.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 12/10/21.
//

import UIKit

class SettingsViewController: UITableViewController {
    @IBOutlet var changeBalanceButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goToChangeBalance() {
        performSegue(withIdentifier: "ChangeBalance", sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChangeBalance" {
            let tradeViewController = segue.destination as! ChangeBalanceViewController
            
        }
    }
}
