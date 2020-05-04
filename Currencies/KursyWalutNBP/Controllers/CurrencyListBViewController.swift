//
//  CurrencyListViewController.swift
//  KursyWalutNBP
//
//  Tested on iphone 11
//  Created by xxx on 12/01/2020.
//  Copyright © 2020 xxx. All rights reserved.
//

// Do poprawy refresh, zaktualizować ControllerB, Posprzątać



import UIKit


// MARK: - Currency List View Controller
class CurrencyListBViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var effectiveDateLabel: UILabel!
    
    // MARK: - Variables
    var searchedCurrency = [Rate]()
    var searching = false
    var event = Event()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView(event: event)
        tableView.refreshControl = refresher
        tableView.reloadData()
        
    }
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        return refreshControl
    }()
    
    
    private func setView(event: Event) -> Void {
        // Custom Navigation Bar
        navigationController!.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        // Custom Tab Bar
        tabBarController!.tabBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        // Refresh Table View
        tableView.refreshControl = refresher
        
        // Set text for effective date label
        effectiveDateLabel.text = event.currenciesB.first?.effectiveDate
        
    }
    
    private func downloadData() -> Void {
        WebServices.loadData() { (result) in
            switch result {
            case.failure(let error):
                print(error)
            case.success(let event):
                self.event = event
            }
        }
    }
    
    // Available to Objective-C
    @objc func refresh() {
        downloadData()
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    // MARK: - Pass Data to Detail View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if
            segue.identifier == "ShowDetails",
            let detailViewController = segue.destination as? DetailViewController,
            let currencyCell = sender as? UITableViewCell,
            let row = tableView.indexPath(for: currencyCell)?.row
        {
            detailViewController.code = event.currenciesB.first!.rates[row].code
            detailViewController.table = "B"
        }
    }
}

// MARK: - Table View Data Source
extension CurrencyListBViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currencyCell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell") as! CurrencyCell
        if searching {
            currencyCell.currencyCodeLabel.text = searchedCurrency[indexPath.row].code
            currencyCell.averageCurrencyRateValueLabel.text = "\(searchedCurrency[indexPath.row].mid)"
            currencyCell.currencyNameLabel.text = searchedCurrency[indexPath.row].currency
        } else {
            currencyCell.currencyCodeLabel.text = event.currenciesB.first!.rates[indexPath.row].code
            currencyCell.averageCurrencyRateValueLabel.text = "\(String(event.currenciesB.first!.rates[indexPath.row].mid))"
            currencyCell.currencyNameLabel.text = event.currenciesB.first!.rates[indexPath.row].currency
        }
        return currencyCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedCurrency.count
        } else {
            return event.currenciesB.first?.rates.count ?? 0
        }
    }
}

// MARK: - Table View Delegate
extension CurrencyListBViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CurrencyListBViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedCurrency = event.currenciesB.first!.rates.filter({$0.code.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}



