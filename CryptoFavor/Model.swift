//
//  Model.swift
//  CryptoFavor
//
//  Created by Nazar Petruk on 30/09/2019.
//  Copyright © 2019 Nazar Petruk. All rights reserved.
//

import UIKit
import Alamofire

class CoinData {
    static let shared = CoinData()
    var coins = [Coin]()
    weak var delegate : CoinDataDelegate?
    
    private init() {
        let symbols = ["BTC","ETH","LTC", "ZEC", "DASH", "XRP", "XMR", "BCH", "NEO", "ADA", "EOS", "TRX", "BNB", "USDT", "NULS"]
        
        for symbol in symbols {
            let coin = Coin(symbol: symbol)
            coins.append(coin)
            
        }
    }
    func getPrices() {
        var listOfCryptoSmbls = ""
        for coin in coins {
            listOfCryptoSmbls += coin.symbol
            if coin.symbol != coins.last?.symbol {
                listOfCryptoSmbls += ","
            }
        }
        Alamofire.request("https://min-api.cryptocompare.com/data/pricemulti?fsyms=\(listOfCryptoSmbls)&tsyms=USD").responseJSON { (response) in
            if let json = response.result.value as? [String:Any] {
                for coin in self.coins{
                    if let coinJSON = json[coin.symbol] as? [String : Double]{
                        if let price = coinJSON["USD"]{
                            coin.price = price
                        }
                    }
                }
                self.delegate?.newPrices?()
            }
        }
    }
    func doubleToMoneyString(double: Double) -> String{
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        if let refactPrice = formatter.string(from: NSNumber(floatLiteral: double)){
            return refactPrice
        }else{
            return "Error"
        }
    }
}

@objc protocol CoinDataDelegate: class {
    @objc optional func newPrices()
    @objc optional func historyDataAppeared()
}

class Coin {
    var symbol = ""
    var image = UIImage()
    var price = 0.0
    var amount = 0.0
    var historicalData = [Double]()
    
    init(symbol: String) {
        self.symbol = symbol
        if let image = UIImage(named: symbol.lowercased()){
            self.image = image
        }
    }
    
    func getHistoricalData() {
        Alamofire.request("https://min-api.cryptocompare.com/data/histoday?fsym=\(symbol)&tsym=USD&limit=30").responseJSON { (response) in
            if let json = response.result.value as? [String : Any]{
                if let pricesJSON = json["Data"] as? [[String : Double]] {
                    self.historicalData = []
                    for priceJSON in pricesJSON {
                        if let closePrice = priceJSON["close"]{
                            self.historicalData.append(closePrice)
                        }
                    }
                    CoinData.shared.delegate?.historyDataAppeared?()
                }
            }
        }
    }
    
    func priceAsString() -> String{
        if price == 0.0{
             return "On the way..."
        }
        return CoinData.shared.doubleToMoneyString(double: price)
    }
    
    func amountAsString() -> String{
        return CoinData.shared.doubleToMoneyString(double: amount * price)
    }
}

