//
//  CryptoVC.swift
//  CryptoFavor
//
//  Created by Nazar Petruk on 30/09/2019.
//  Copyright © 2019 Nazar Petruk. All rights reserved.
//

import UIKit

class CryptoVC: UITableViewController, CoinDataDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        tableView.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.2274509804, blue: 0.2784313725, alpha: 1)
        CoinData.shared.getPrices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CoinData.shared.delegate = self
        tableView.reloadData()
    }
    
    func newPrices() {
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return CoinData.shared.coins.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.2274509804, blue: 0.2784313725, alpha: 1)
        let coin = CoinData.shared.coins[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Futura-Medium", size: 20)
        cell.layer.borderWidth = 5
        cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = "\(coin.symbol) - \(coin.priceAsString())"
        cell.imageView?.image = coin.image
    
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coinVC = CoinVC()
        coinVC.coin = CoinData.shared.coins[indexPath.row]
        navigationController?.pushViewController(coinVC, animated: true)  
    }
}
