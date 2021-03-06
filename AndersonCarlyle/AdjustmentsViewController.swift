//
//  AdjustmentsViewController.swift
//  AndersonCarlyle
//
//  Created by Usuário Convidado on 05/04/17.
//  Copyright © 2017 Kako Botasso & Anderson Macedo. All rights reserved.
//

import UIKit
import CoreData

enum StateAlertType {
    case add
    case edit
}

class AdjustmentsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tfCotacao: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var dataSource: [State] = []
    var label: UILabel!

    // MARK: - Super methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupLabel()
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
        showAlert(type: .add, state: nil)
    }
    
    // MARK: - Methods
    func showAlert(type: StateAlertType, state: State?){
        let title = (type == .add) ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: "\(title) Estado", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome do estado"
            if let name = state?.name {
                textField.text = name
            }
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Imposto"
            if let tax = state?.tax {
                textField.text = "\(tax)"
            }
        }
        
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            let name = alert.textFields?.first?.text
            let tax = (alert.textFields?[1].text)!
            
            if self.validState(name, tax) {
                let state = state ?? State(context: self.context)
                state.name = name
                state.tax = Double(tax.replacingOccurrences(of: ",", with: "."))!
                
                do {
                    try self.context.save()
                    self.tableView.reloadData()
                    self.loadStates()
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func validState(_ name: String?, _ tax: String?) -> Bool{
        if (name?.isEmpty)! {
            showErrorMessage("Nome do estado não pode estar em branco")
            return false
        }
        
        if (tax?.isEmpty)!{
            showErrorMessage("Imposto não pode ficar em branco")
            return false
        }
        
        if Double(tax!.replacingOccurrences(of: ",", with: ".")) == nil {
            showErrorMessage("Imposto deve conter apenas números")
            return false
        }
        
        return true
    }
    
    func showErrorMessage(_ message: String){
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setupLabel(){
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
        label.text = "Lista de estados vazia"
        label.textAlignment = .center
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

}

extension AdjustmentsViewController: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension AdjustmentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = (dataSource.count == 0) ? label : nil
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let state = self.dataSource[indexPath.row]
            self.context.delete(state)
            
            for product in state.products! {
                self.context.delete(product as! NSManagedObject)
            }
            
            do {
                try self.context.save()
                self.dataSource.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print(error.localizedDescription)
            }
        }

        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = self.dataSource[indexPath.row]
        tableView.setEditing(false, animated: true)
        self.showAlert(type: .edit, state: state)
    }
}
