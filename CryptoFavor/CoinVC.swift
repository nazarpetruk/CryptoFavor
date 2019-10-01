//
//  CoinVC.swift
//  CryptoFavor
//
//  Created by Nazar Petruk on 01/10/2019.
//  Copyright © 2019 Nazar Petruk. All rights reserved.
//

import UIKit
import SwiftChart

class CoinVC: UIViewController, CoinDataDelegate {
    
    //MARK: Vars & Const
    var coin : Coin?
    var chart = Chart()
    var userCoinLbl = UILabel()
    var totalValueLbl = UILabel()
    var priceLbl = UILabel()
    
    //MARK: Sizing Constants
    private let chartHeight : CGFloat = 500
    private let imageSize : CGFloat = 100
    private let standardLblHeight : CGFloat = 50
    private let spacingStndrd : CGFloat = 20

    override func viewDidLoad() {
        super.viewDidLoad()

        if let coin = coin {
            coin.getHistoricalData()
            CoinData.shared.delegate = self
            
            edgesForExtendedLayout = []
            view.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.2274509804, blue: 0.2784313725, alpha: 1)
            
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(editTapped))
            navigationItem.title = "\(coin.symbol)"
            
            
            //MARK: Chart
            chart.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: chartHeight)
            chart.labelColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            chart.yLabelsFormatter = { CoinData.shared.doubleToMoneyString(double: $1 ) }
            chart.xLabels = [30,25,20,15,10,5,0]
            chart.xLabelsFormatter = { String(Int(round(30 - $1))) + "d" }
            
            //MARK: Image
            let imageView = UIImageView(frame: CGRect(x: view.frame.size.width - imageSize * 4, y: chartHeight + spacingStndrd, width: imageSize, height: imageSize))
            imageView.image = coin.image
            
            //MARK: Labels config.
            priceLbl.frame = CGRect(x: 0, y: chartHeight + spacingStndrd - 10, width: view.frame.size.width + imageSize, height: standardLblHeight)
            userCoinLbl.frame = CGRect(x: 0, y: chartHeight + spacingStndrd - 20 + standardLblHeight, width: view.frame.size.width + imageSize, height: standardLblHeight)
            totalValueLbl.frame = CGRect(x: 0, y: chartHeight + spacingStndrd * 2 + standardLblHeight, width: view.frame.size.width + imageSize, height: standardLblHeight)
            
            labelReload()
            
            labelConfig(toConfig: totalValueLbl)
            labelConfig(toConfig: priceLbl)
            labelConfig(toConfig: userCoinLbl)
            
            //MARK: Subviews added
            view.addSubview(totalValueLbl)
            view.addSubview(chart)
            view.addSubview(userCoinLbl)
            view.addSubview(priceLbl)
            view.addSubview(imageView)
        }
    }
    func historyDataAppeared() {
        if let coin = coin {
            let series = ChartSeries(coin.historicalData)
            series.area = true
            chart.add(series)
        }
    }
    
    @objc func editTapped(){
        if let coin = coin {
            let alert = UIAlertController(title: "How much \(coin.symbol) coins you have?", message: nil, preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Coins"
                textField.keyboardType = .decimalPad
                if self.coin?.amount != 0.0{
                    textField.text = String(coin.amount)
                }
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                if let text = alert.textFields?[0].text{
                    if let enteredAmount = Double(text){
                        self.coin?.amount = enteredAmount
                        self.labelReload()
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Config view func
    func labelConfig(toConfig label: UILabel){
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = UIFont(name: "Futura-Medium", size: 20)
    }
    
    func imageConfig(toConfig imageView: UIImageView){
        imageView.layer.cornerRadius = 50
        imageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        imageView.layer.borderWidth = 0.75
    }
    
    func labelReload(){
        if let coin = coin{
            totalValueLbl.text = coin.amountAsString()
                       priceLbl.text = coin.priceAsString()
                       userCoinLbl.text = "\(coin.symbol) : \(coin.amount) "
        }
    }
}
