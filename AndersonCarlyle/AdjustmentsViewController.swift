//
//  AdjustmentsViewController.swift
//  AndersonCarlyle
//
//  Created by Usuário Convidado on 05/04/17.
//  Copyright © 2017 Kako Botasso & Anderson Macedo. All rights reserved.
//

import UIKit

class AdjustmentsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tfCotacao: UITextField!
    @IBOutlet weak var tfIOF: UITextField!

    // MARK: - Super methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let cotacao = UserDefaults.standard.string(forKey: "cotacao_dolar") {
            tfCotacao.text = cotacao
        }
        
        if let iof = UserDefaults.standard.string(forKey: "iof") {
            tfIOF.text = iof
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
            //TODO: Criar lógica de insert
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
