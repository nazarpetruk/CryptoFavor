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
    private let chartHeight : CGFloat = 300

    override func viewDidLoad() {
        super.viewDidLoad()
        CoinData.shared.delegate = self
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = []
        chart.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: chartHeight)
        chart.yLabelsFormatter = { CoinData.shared.doubleToMoneyString(double: $1 ) }
        chart.xLabels = [30,25,20,15,10,5,0]
        chart.xLabelsFormatter = { String(Int(round(30 - $1))) + "d" }
        view.addSubview(chart)
        coin?.getHistoricalData()
        
    }
    func historyDataAppeared() {
        if let coin = coin {
            let series = ChartSeries(coin.historicalData)
            series.area = true
            chart.add(series)
        }
        
    }

}
