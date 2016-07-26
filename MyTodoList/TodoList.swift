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
    
    //var items: [String] = [] //aqui guarda en un arreglo de String
    
    var items: [TodoItem] = [] //aqui guarda en un arreglo de TodoItem, la clase que hemos creado para la persistencia con NS Coding, anteriormente era por un arreglo de String
    
    
    override init() {
        super.init()
        loadItems()
    }
    
    private let fileURL: NSURL = {
        //tipo que guarda urls
        /*let fileManager = NSFileManager.defaultManager()
        let documentDirectoryURLs = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
        let documentDirectoryURL = documentDirectoryURLs.first!
        
        
       // return documentDirectoryURL.URLByAppendigPathComponent("todolist.items")
        //return documentDirectoryURL.URLByAppendigPathComponent("todolsit")*/
        
        
        let documentDirectory = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .ShortStyle
        let date = dateFormatter.stringFromDate(NSDate())
        /*let saveURL = documentDirectory.URLByAppendingPathComponent("list.items") // now it's NSURL*/
        
        //cambiamos el formato, porque el mecanismo de serializacion que se utiliza nativamente en objetive-c y swift es property list
        let saveURL = documentDirectory.URLByAppendingPathComponent("todolist.plist") // now it's NSURL
        //mecanismo de serializacion que se utiliza en swift/xcode es PropertyList, por lo tanto utilizamos el 
        //formato plist
        
        print ("path de documents \(saveURL)")
        return saveURL
    }()
    
    
    /*func addItem(item: String){
    items.append(item)
        saveItems()
    }*/
    
    
    //ahora recibimos un TodoItem no un String
    func addItem(item: TodoItem){
        items.append(item)
        saveItems()
    }
    
    // codigo para guardar en disco
    //debemos obtener la ruta del directorio Documents
    //que es en donde podemos escribir.
    
    //clase de objetiveC NSFileManager
    
    func saveItems(){
       
        //guardar nuestros datos utilizando NSCoding
        //serializar es transformarse a bytes
        
       let itemsArray = items as NSArray
        
        
        /*if itemsArray.writeToURL(self.fileURL, atomically: true){
        print ("guardado")
        
        }else {
        print ("no guardado")
        }*/
        
       // NSKeyedArchiver -> tomar objetos que implementen el protocolo NSCoding y serializarlos a disco
        
  //archiveRootObject -> le pasamos el objeto raiz
       
        if NSKeyedArchiver.archiveRootObject(itemsArray, toFile: self.fileURL.path!){
            
        print("guardado")
        }else{
        print ("no guardado")
        }
        
    }
    
    /*Ya no se utiliza esta función porque se almacenará en disco, y esta era para arreglo de String
     
     func loadItems() {
        
        if let itemsArray = NSArray(contentsOfURL: self.fileURL) as? [String]{
            
            self.items = itemsArray
            
        }*/
    
        
        func loadItems() {
            //cargar nuestros datos utilizando NSCoding
            //con esto almacenamos en disco
            
            if let itemsArray = NSKeyedUnarchiver.unarchiveObjectWithFile(self.fileURL.path!){
                
                self.items = itemsArray as! [TodoItem]
                
            }
            
    }
    
    /*func getItem(index: Int) -> String {
    
        return items [index]
    }*/
    
    func getItem(index: Int) -> TodoItem { //ahora nos regresa el TodoItem
        
        return items [index]
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
        
        //cell.textLabel!.text = item
        cell.textLabel!.text = item.todo
        return cell
    }
    
    //Funciones para borrar elementos de una tabla.
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
            }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        items.removeAtIndex(indexPath.row)
        saveItems()
    //iniciar animacion
        tableView.beginUpdates()
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Middle)
        tableView.endUpdates()
        
    }
}
