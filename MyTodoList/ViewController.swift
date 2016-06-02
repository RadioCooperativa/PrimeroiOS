//
//  ViewController.swift
//  MyTodoList
//
//  Created by Innovación y Desarrollo on 27-05-16.
//  Copyright © 2016 Innovación y Desarrollo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let todoList = TodoList()
    
    
    @IBAction func addButtonPressed (sender: UIButton){
    print ("Agregando un elemento a la lista : \(itemTextField.text)")
        todoList.addItem(itemTextField.text!) //con el signo ! sacamos el valor de la caja de texto
        tableView.reloadData()//cada ves que agregue un elemento el tableview actualice la informacion
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    //cuando se esta inciiando la aplicacion se manda a llamar esta funcion
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell") //"Cell", debe estar escrito igual como quedo en el modelo, (let cell= tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath))
    tableView.dataSource=todoList //a este objeto se le pregunta cuantas celdas vamos a agregar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

