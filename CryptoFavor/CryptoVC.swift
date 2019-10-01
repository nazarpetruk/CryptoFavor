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
        tableView.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.6941176471, blue: 0.6235294118, alpha: 1)
        CoinData.shared.getPrices()
        navigationItem.title = "COINS"
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
        cell.layer.borderColor = #colorLiteral(red: 0.3450980392, green: 0.6941176471, blue: 0.6235294118, alpha: 1)
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        
        let coin = CoinData.shared.coins[indexPath.row]
        
        cell.textLabel?.font = UIFont(name: "Futura-Medium", size: 20)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = "\(coin.symbol) - \(coin.priceAsString())"
        
        cell.imageView?.image = resizeImageWithAspect(image: coin.image, scaledToMaxWidth: 50, maxHeight: 50)
        
        cell.imageView?.contentMode = .scaleAspectFit

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coinVC = CoinVC()
        coinVC.coin = CoinData.shared.coins[indexPath.row]
        navigationController?.pushViewController(coinVC, animated: true)  
    }
    
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
}
