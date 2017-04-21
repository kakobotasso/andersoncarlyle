//
//  ProductRegisterViewController.swift
//  AndersonCarlyle
//
//  Created by Anderson Macedo on 14/04/17.
//  Copyright © 2017 Kako Botasso & Anderson Macedo. All rights reserved.
//

import UIKit
import CoreData

class ProductRegisterViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivProd: UIImageView!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var swCard: UISwitch!
    @IBOutlet weak var btRegister: UIButton!
    @IBOutlet weak var btImageProd: UIButton!
    
    // MARK: - Properties
    var pickerView : UIPickerView!
    var dataSource: [State] = []
    
    // MARK: - Super methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStates()
        loadPickerView()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    // MARK - Methods
    func loadStates(){
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            dataSource = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func loadPickerView(){
        pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        toolbar.items = [btCancel, btSpace, btDone]
        
        tfState.inputView = pickerView
        tfState.inputAccessoryView = toolbar
    }
    
    func cancel(){
        tfState.resignFirstResponder()
    }
    
    func done(){
        let state = dataSource[pickerView.selectedRow(inComponent: 0)]
        tfState.text = state.name
        cancel()
    }
    
    func showErrorMessage(_ message: String){
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @IBAction func saveOrUpdateProduct(_ sender: UIButton) {
    }
    
    @IBAction func addImage(_ sender: UIButton) {
    }
    
}

extension ProductRegisterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row].name
    }
}

extension ProductRegisterViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
}
