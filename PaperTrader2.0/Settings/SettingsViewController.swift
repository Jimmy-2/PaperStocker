//
//  SettingsViewController.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 12/10/21.
//

import UIKit

class SettingsViewController: UITableViewController {
    @IBOutlet var changeBalanceButton: UIButton!
    @IBOutlet var dailyBalanceButton: UIButton!
    @IBOutlet var summaryButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goToChangeBalance() {
        performSegue(withIdentifier: "ChangeBalance", sender: nil)
    }
    @IBAction func goToDailyBalance() {
        performSegue(withIdentifier: "DailyBalance", sender: nil)
    }
    @IBAction func goToSummary() {
        performSegue(withIdentifier: "Summary", sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
        if segue.identifier == "ChangeBalance" {
            let tradeViewController = segue.destination as! ChangeBalanceViewController
            
        } else if segue.identifier == "DailyBalance" {
            let tradeViewController = segue.destination as! DailyBalanceViewController
        } else if segue.identifier == "Summary" {
            let tradeViewController = segue.destination as! SummaryViewController
        }
        */
    }
}
