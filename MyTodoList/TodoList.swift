//
//  TodoList.swift
//  MyTodoList
//
//  Created by Innovación y Desarrollo on 02-06-16.
//  Copyright © 2016 Innovación y Desarrollo. All rights reserved.
//

import UIKit

class TodoList: NSObject {
    
    //creando el modelo
    
    var items: [String] = []
    func addItem(item: String){
    items.append(item)
    }
}

extension TodoList: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count //funcion que necesita el tableview para saber que informacion va a desplegar
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //funcion que se llama cada ves q tableview estara preguntando por el siguiente elemento
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
   
        //vamos a recuperar una celda
        let item = items[indexPath.row]
        
        cell.textLabel!.text = item
        return cell
    }
}
