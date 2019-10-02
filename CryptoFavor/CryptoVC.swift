//
//  CryptoVC.swift
//  CryptoFavor
//
//  Created by Nazar Petruk on 30/09/2019.
//  Copyright © 2019 Nazar Petruk. All rights reserved.
//

import UIKit

class CryptoVC: UITableViewController, CoinDataDelegate {
    //MARK: Vars
    private let headerHeight : CGFloat = 120
    private let rowHeight : CGFloat = 80
    private let netWorthHeight : CGFloat = 45
   
    
    var amountLbl = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.6941176471, blue: 0.6235294118, alpha: 1)
        CoinData.shared.getPrices()
        navigationItem.title = "COINS"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CoinData.shared.delegate = self
        tableView.reloadData()
        displayNetWorth()
    }
    
    func newPrices() {
        tableView.reloadData()
        displayNetWorth()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return CoinData.shared.coins.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.2274509804, blue: 0.2784313725, alpha: 1)
        cell.layer.borderColor = #colorLiteral(red: 0.3450980392, green: 0.6941176471, blue: 0.6235294118, alpha: 1)
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        cell.selectionStyle = .none
        
        let coin = CoinData.shared.coins[indexPath.row]
        
        cell.textLabel?.font = UIFont(name: "Futura-Medium", size: 20)
        cell.textLabel?.textColor = UIColor.white
        
        if coin.amount != 0.0{
            cell.textLabel?.text = "\(coin.symbol) - \(coin.priceAsString()) (collected: \(coin.amount))"
        }else{
            cell.textLabel?.text = "\(coin.symbol) - \(coin.priceAsString())"
        }
       
        cell.imageView?.image = resizeImageWithAspect(image: coin.image, scaledToMaxWidth: 50, maxHeight: 50)
        
        cell.imageView?.contentMode = .scaleAspectFit

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coinVC = CoinVC()
        coinVC.coin = CoinData.shared.coins[indexPath.row]
        navigationController?.pushViewController(coinVC, animated: true)  
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerViewAdding()
    }

    
    //MARK: Resizing func
    func resizeImageWithAspect(image: UIImage,scaledToMaxWidth width:CGFloat,maxHeight height :CGFloat)->UIImage? {
        
        let oldWidth = image.size.width;
        let oldHeight = image.size.height;

        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;

        let newHeight = oldHeight * scaleFactor;
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContextWithOptions(newSize,false,UIScreen.main.scale);

        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage
    }
    
    //MARK: View config funcs
    func headerViewAdding() -> UIView{
        let headerView =  UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: headerHeight))
        headerView.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.6941176471, blue: 0.6235294118, alpha: 1)
        let netWorthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: netWorthHeight))
        headerView.addSubview(netWorthLabel)
        netWorthLabel.textAlignment = .center
        netWorthLabel.text = "Coins in wallet"
        netWorthLabel.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.6941176471, blue: 0.6235294118, alpha: 1)
        netWorthLabel.layer.cornerRadius = 10
        netWorthLabel.layer.borderColor = #colorLiteral(red: 0.1725490196, green: 0.2274509804, blue: 0.2784313725, alpha: 1)
        netWorthLabel.layer.borderWidth = 1
        netWorthLabel.font = UIFont(name: "Futura-Medium", size: 30)
        netWorthLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        amountLbl.frame = CGRect(x: 0, y: netWorthHeight, width: view.frame.size.width, height: headerHeight - netWorthHeight)
        amountLbl.textAlignment = .center
        amountLbl.font = UIFont(name: "Futura-Medium", size: 20)
        amountLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        amountLbl.layer.cornerRadius = 10
        amountLbl.layer.borderColor = #colorLiteral(red: 0.1725490196, green: 0.2274509804, blue: 0.2784313725, alpha: 1)
        amountLbl.layer.borderWidth = 1
        headerView.addSubview(amountLbl)
        displayNetWorth()
        return headerView
    }
    
    func displayNetWorth() {
        amountLbl.text = CoinData.shared.netWorthAsString()
    }
}
