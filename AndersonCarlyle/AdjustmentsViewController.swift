//
//  AdjustmentsViewController.swift
//  AndersonCarlyle
//
//  Created by Usuário Convidado on 05/04/17.
//  Copyright © 2017 Kako Botasso & Anderson Macedo. All rights reserved.
//

import UIKit
import CoreData

class AdjustmentsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tfCotacao: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var dataSource: [State] = []

    // MARK: - Super methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadStates()
        
        if let cotacao = UserDefaults.standard.string(forKey: "cotacao_dolar") {
            tfCotacao.text = cotacao
        }
        
        if let iof = UserDefaults.standard.string(forKey: "iof") {
            tfIOF.text = iof
        }
    }
    
    // MARK: - Methods
    func loadStates(){
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            dataSource = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    // MARK: - Actions
    @IBAction func addNewState(_ sender: UIButton) {
        showAlert()
    }
    
    // MARK: - Methods
    func showAlert(){
        let alert = UIAlertController(title: "Adicionar Estado", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome do estado"
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Imposto"
        }
        
        alert.addAction(UIAlertAction(title: "Adicionar", style: .default, handler: { (action: UIAlertAction) in
            
            let state = State(context: self.context)
            state.name = alert.textFields?.first?.text
            state.tax = Double((alert.textFields?[1].text)!)!
            
            do {
                try self.context.save()
                self.tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

extension AdjustmentsViewController: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension AdjustmentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let state = self.dataSource[indexPath.row]
        
        cell?.textLabel!.text = state.name
        cell?.detailTextLabel?.text = "\(state.tax)"
        cell?.detailTextLabel?.textColor = UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        return cell!
    }
}
