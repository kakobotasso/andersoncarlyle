//
//  TotalPriceViewController.swift
//  AndersonCarlyle
//
//  Created by Usuário Convidado on 05/04/17.
//  Copyright © 2017 Kako Botasso & Anderson Macedo. All rights reserved.
//

import UIKit
import CoreData

class TotalPriceViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var lblUsaPrice: UILabel!
    @IBOutlet weak var lblBraPrice: UILabel!
    
    // MARK: - Properties
    var dataSource: [Product] = []
    
    // MARK: - Super methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProducts()
        totalPriceUS()
        totalPriceBra()
    }
    
    // MARK: - Methods
    func loadProducts(){
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            dataSource = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func totalPriceUS(){
        var total = 0.0
        
        if dataSource.count > 0 {
            for product in dataSource {
                let price = product.price
                let percentual = percentualState(price: price, tax: (product.state?.tax)!)
                total = total + price + percentual
            }
            
        }
        lblUsaPrice.text = "\(total)"
    }
    
    func totalPriceBra(){
        var total = 0.0
        
        if dataSource.count > 0 {
            for product in dataSource {
                var price = product.price
                let percentual = percentualState(price: price, tax: (product.state?.tax)!)
                
                price = price + percentual
                let currency = currencyPrice(price: price)
                
                let finalPrice = price + percentual + currency
                
                if product.creditcard {
                    total = total + finalPrice
                } else {
                    total = total + finalPrice + iofTax(price: finalPrice)
                }
            }
            
        }
        lblBraPrice.text = "\(total)"
    }
    
    func percentualState(price: Double, tax: Double) -> Double {
        return (price * (tax/100))
    }
    
    func iofTax(price: Double) -> Double{
        let iof = UserDefaults.standard.double(forKey: "iof")
        return (price * (iof/100))
    }
    
    func currencyPrice(price: Double) -> Double{
        let currency = UserDefaults.standard.double(forKey: "cotacao_dolar")
        return (price * currency)
    }

}
