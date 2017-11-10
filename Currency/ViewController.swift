//
//  ViewController.swift
//  Currency
//
//  Created by Robert O'Connor on 18/10/2017.
//  Copyright © 2017 WIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK Model holders
    var currencyDict:Dictionary = [String:Currency]()
    var currencyArray = [Currency]()
    var baseCurrency:Currency = Currency.init(name:"EUR", rate:1, flag:"🇪🇺", symbol:"€")!
    var lastUpdatedDate:Date = Date()
    
    var convertValue:Double = 0
    
    //MARK Outlets
    //@IBOutlet weak var convertedLabel: UILabel!
    
    @IBOutlet weak var baseSymbol: UILabel!
    @IBOutlet weak var baseTextField: UITextField!
    @IBOutlet weak var baseFlag: UILabel!
    @IBOutlet weak var lastUpdatedDateLabel: UILabel!
    
    @IBOutlet weak var gbpSymbolLabel: UILabel!
    @IBOutlet weak var gbpValueLabel: UILabel!
    @IBOutlet weak var gbpFlagLabel: UILabel!
    
    @IBOutlet weak var usdSymbolLabel: UILabel!
    @IBOutlet weak var usdValueLabel: UILabel!
    @IBOutlet weak var usdFlagLabel: UILabel!
    
    
    //sweden krone
    
    @IBOutlet weak var sekSymbolLabel: UILabel!
    @IBOutlet weak var sekValueLabel: UILabel!
    @IBOutlet weak var sekFlagLabel: UILabel!
    
    
    // turkish lira
    
    @IBOutlet weak var trySymbolLabel: UILabel!
    @IBOutlet weak var tryValueLabel: UILabel!
    @IBOutlet weak var tryFlagLabel: UILabel!
    
    
    // canadian dolar
    
    @IBOutlet weak var cadSymbolLabel: UILabel!
    @IBOutlet weak var cadValueLabel: UILabel!
    @IBOutlet weak var cadFlagLabel: UILabel!
    
    //russian ruble
    
    @IBOutlet weak var rubSymbolLabel: UILabel!
    @IBOutlet weak var rubValueLabel: UILabel!
    @IBOutlet weak var rubFlagLabel: UILabel!
    
    
    // func touchesBegan
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // print("currencyDict has \(self.currencyDict.count) entries")
        
        // create currency dictionary
        self.createCurrencyDictionary()
        
        // get latest currency values
        getConversionTable()
        convertValue = 1
        
        // set up base currency screen items
        baseTextField.text = String(format: "%.02f", baseCurrency.rate)
        baseSymbol.text = baseCurrency.symbol
        baseFlag.text = baseCurrency.flag
        
        // set up last updated date
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy hh:mm a"
        lastUpdatedDateLabel.text = dateformatter.string(from: lastUpdatedDate)
        
        // display currency info
        self.displayCurrencyInfo()
        
        
        // setup view mover
        baseTextField.delegate = self
        
        self.convert(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createCurrencyDictionary(){
        //let c:Currency = Currency(name: name, rate: rate!, flag: flag, symbol: symbol)!
        //self.currencyDict[name] = c
        currencyDict["GBP"] = Currency(name:"GBP", rate:1, flag:"🇬🇧", symbol: "£")
        currencyDict["USD"] = Currency(name:"USD", rate:1, flag:"🇺🇸", symbol: "$")
        currencyDict["TRY"] = Currency(name:"TRY", rate:1 , flag: "🇹🇷",symbol: "₺")
        currencyDict["KR"] = Currency(name:"KR", rate:1 , flag: "🇸🇪",symbol: "kr")
        currencyDict["CAD"] = Currency(name:"CAD", rate:1 , flag: "🇨🇦",symbol: "$")
        currencyDict["RUB"] = Currency(name:"RUB", rate:1 , flag: "🇷🇺",symbol: "₽")
        
    }
    
    func displayCurrencyInfo() {
        // GBP
        if let c = currencyDict["GBP"]{
            gbpSymbolLabel.text = c.symbol
            gbpValueLabel.text = String(format: "%.02f", c.rate)
            gbpFlagLabel.text = c.flag
        }
        if let c = currencyDict["USD"]{
            usdSymbolLabel.text = c.symbol
            usdValueLabel.text = String(format: "%.02f", c.rate)
            usdFlagLabel.text = c.flag
        }
        //CAD
        
        if let c = currencyDict["CAD"]{
            cadSymbolLabel.text = c.symbol
            cadValueLabel.text = String(format: "%.02f", c.rate)
            cadFlagLabel.text = c.flag
        }
        
        //TRY
        
        if let c = currencyDict["TRY"]{
            trySymbolLabel.text = c.symbol
            tryValueLabel.text = String(format: "%.02f", c.rate)
            tryFlagLabel.text = c.flag
        }
        
        
        //RUB
        
        if let c = currencyDict["RUB"]{
            rubSymbolLabel.text = c.symbol
            rubValueLabel.text = String(format: "%.02f", c.rate)
            rubFlagLabel.text = c.flag
        }
        
        //KR
        
        if let c = currencyDict["KR"]{
            sekSymbolLabel.text = c.symbol
            sekValueLabel.text = String(format: "%.02f", c.rate)
            sekFlagLabel.text = c.flag
        }
    }
    
    
    func getConversionTable() {
        //var result = "<NOTHING>"
        
        let urlStr:String = "https://api.fixer.io/latest"
        
        var request = URLRequest(url: URL(string: urlStr)!)
        
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data,response,error) -> Void in
        
      
           
            if error == nil{
                print(response!)
                
                
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                    print(jsonDict)
                    
                    if let ratesData = jsonDict["rates"] as? NSDictionary {
                        print(ratesData)
                        for rate in ratesData{
                            print("#####")
                            let name = String(describing: rate.key)
                            let rate = (rate.value as? NSNumber)?.doubleValue
                            
                            var flag = " "
                            var symbol = " "
                            
                            switch(name){
                            case "USD":
                                //symbol = "$"
                                //flag = "🇺🇸"
                                let c:Currency  = self.currencyDict["USD"]!
                                c.rate = rate!
                                self.currencyDict["USD"] = c
                            case "GBP":
                                //symbol = "£"
                                //flag = "🇬🇧"
                                let c:Currency  = self.currencyDict["GBP"]!
                                c.rate = rate!
                                self.currencyDict["GBP"] = c
                            case "TRY":
                                let c:Currency  = self.currencyDict["TRY"]!
                                c.rate = rate!
                                self.currencyDict["TRY"] = c
                            case "KR":
                                let c:Currency  = self.currencyDict["KR"]!
                                c.rate = rate!
                                self.currencyDict["KR"] = c
                            case "RUB":
                                let c:Currency  = self.currencyDict["RUB"]!
                                c.rate = rate!
                                self.currencyDict["RUB"] = c
                            case "CAD":
                                let c:Currency  = self.currencyDict["CAD"]!
                                c.rate = rate!
                                self.currencyDict["CAD"] = c
                            default:
                                print("Ignoring currency: \(String(describing: rate))")
                            }
                            
                            
                             let c:Currency = Currency(name: name, rate: rate!, flag: flag, symbol: symbol)!
                             self.currencyDict[name] = c
 
                        }
                        self.lastUpdatedDate = Date()
                    }
                }
                catch let error as NSError{
                    print(error)
                }
            }
            else{
                print("Error")
            }
            
        }
        task.resume()
    }
    
    @IBAction func convert(_ sender: Any) {
       refresh()
        
    }
    
    @IBAction func refreshCurrencies(_ sender: UIButton) {
        
        getConversionTable()
        
        var resultGBP = 0.0
        var resultUSD = 0.0
        var resultCAD = 0.0
        var resultTRY = 0.0
        var resultKR = 0.0
        var resultRUB = 0.0
        
        
        
            convertValue = 1
            if let gbp = self.currencyDict["GBP"] {
                resultGBP = convertValue * gbp.rate
            }
            if let usd = self.currencyDict["USD"] {
                resultUSD = convertValue * usd.rate
            }
            if let cad = self.currencyDict["CAD"] {
                resultCAD = convertValue * cad.rate
            }
            if let TRY = self.currencyDict["TRY"] {
                resultTRY = convertValue * TRY.rate
            }
            if let kr = self.currencyDict["KR"] {
                resultKR = convertValue * kr.rate
            }
            if let rub = self.currencyDict["RUB"] {
                resultRUB = convertValue * rub.rate
            }
            
        
        //GBP
        
        //convertedLabel.text = String(describing: resultGBP)
        
        gbpValueLabel.text = String(format: "%.02f", resultGBP)
        usdValueLabel.text = String(format: "%.02f", resultUSD)
        tryValueLabel.text = String(format: "%.02f", resultTRY)
        cadValueLabel.text = String(format: "%.02f", resultCAD)
        rubValueLabel.text = String(format: "%.02f", resultRUB)
        sekValueLabel.text = String(format: "%.02f", resultKR)
        baseTextField.text = String("1.00")
        
    }
    
    func refresh()
    {
        
        var resultGBP = 0.0
        var resultUSD = 0.0
        var resultCAD = 0.0
        var resultTRY = 0.0
        var resultKR = 0.0
        var resultRUB = 0.0
        
        
        if let euro = Double(baseTextField.text!) {
            convertValue = euro
            if let gbp = self.currencyDict["GBP"] {
                resultGBP = convertValue * gbp.rate
            }
            if let usd = self.currencyDict["USD"] {
                resultUSD = convertValue * usd.rate
            }
            if let cad = self.currencyDict["CAD"] {
                resultCAD = convertValue * cad.rate
            }
            if let TRY = self.currencyDict["TRY"] {
                resultTRY = convertValue * TRY.rate
            }
            if let kr = self.currencyDict["KR"] {
                resultKR = convertValue * kr.rate
            }
            if let rub = self.currencyDict["RUB"] {
                resultRUB = convertValue * rub.rate
            }
            
        }
        //GBP
        
        //convertedLabel.text = String(describing: resultGBP)
        
        gbpValueLabel.text = String(format: "%.02f", resultGBP)
        usdValueLabel.text = String(format: "%.02f", resultUSD)
        tryValueLabel.text = String(format: "%.02f", resultTRY)
        cadValueLabel.text = String(format: "%.02f", resultCAD)
        rubValueLabel.text = String(format: "%.02f", resultRUB)
        sekValueLabel.text = String(format: "%.02f", resultKR)
    }
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     
     }
     */
    
    
}

