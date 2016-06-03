//
//  ViewController.swift
//  MyTodoList
//
//  Created by Innovación y Desarrollo on 27-05-16.
//  Copyright © 2016 Innovación y Desarrollo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let todoList = TodoList()
    static let MAX_TEXT_SIZE = 5
    
    @IBAction func addButtonPressed (sender: UIButton){
    print ("Agregando un elemento a la lista : \(itemTextField.text)")
        todoList.addItem(itemTextField.text!) //con el signo ! sacamos el valor de la caja de texto
        tableView.reloadData()//cada ves que agregue un elemento el tableview actualice la informacion
        self.itemTextField?.text = nil //borar campo de texto
        self.itemTextField?.resignFirstResponder()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    //cuando se esta inciiando la aplicacion se manda a llamar esta funcion
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell") //"Cell", debe estar escrito igual como quedo en el modelo, (let cell= tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath))
        tableView.dataSource=todoList //a este objeto se le pregunta cuantas celdas vamos a agregar
        tableView.delegate = self //indicamos al tableview que somos su delegado o ayudante con su metodo
        itemTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Escondemos el teclado
    //MARK: Metodos del table view delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.itemTextField?.resignFirstResponder()
    }
    
    //MARK: Metodos de text field delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
    
        if let tareaString = textField.text as? NSString {
            let updatedString = tareaString.stringByReplacingCharactersInRange(range, withString: string)
            return updatedString.characters.count <= ViewController.MAX_TEXT_SIZE //regresa un booleano true
        }else {
        
        return true
        }
    }


}

