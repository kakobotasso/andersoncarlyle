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
    var state : State!
    var smallImage : UIImage!
    
    // MARK: - Super methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        state = dataSource[pickerView.selectedRow(inComponent: 0)]
        tfState.text = state.name
        cancel()
    }
    
    func showErrorMessage(_ message: String){
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func validProduct(_ name: String?, _ price: String?, _ state: State?) -> Bool{
        if (name?.isEmpty)! {
            showErrorMessage("Nome do produto não pode estar em branco")
            return false
        }
        
        if state == nil {
            showErrorMessage("Selecione o estado onde comprou o produto")
            return false
        }
        
        if (price?.isEmpty)!{
            showErrorMessage("Preço não pode ficar em branco")
            return false
        }
        
        if Double(price!) == nil {
            showErrorMessage("Preço deve conter apenas números")
            return false
        }
        
        return true
    }
    
    // MARK: - Actions
    @IBAction func saveOrUpdateProduct(_ sender: UIButton) {
        
        let name = tfName.text
        let price = tfPrice.text
        let creditCard = swCard.isOn
        
        if validProduct(name, price, state){
            let product = Product(context: self.context)
            
            product.name = name
            product.price = Double(price!)!
            product.creditcard = creditCard
            product.state = state
            product.image = smallImage
        
            do {
                try self.context.save()
                navigationController?.popViewController(animated: true)
            } catch {
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    @IBAction func addImage(_ sender: UIButton) {
    
        let alert = UIAlertController(title: "Selecionar foto", message: "De onde você quer escolher a foto", preferredStyle: .actionSheet)
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
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
extension ProductRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //Como reduzir uma imagem
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        ivProd.image = smallImage
        
        dismiss(animated: true, completion: nil)
    }
}
