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
    
    override init() {
        super.init()
        loadItems()
    }
    
    private let fileURL: NSURL = { //tipo que guarda urls
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
        let saveURL = documentDirectory.URLByAppendingPathComponent("list.items") // now it's NSURL
        print ("path de documents \(saveURL)")
        return saveURL
    }()
    
    
    func addItem(item: String){
    items.append(item)
        saveItems()
    }
    
    // codigo para guardar en disco
    //debemos obtener la ruta del directorio Documents
    //que es en donde podemos escribir.
    
    //clase de objetiveC NSFileManager
    
    func saveItems(){
    //serializar es transformarse a bytes
        
        let itemsArray = items as NSArray
        if itemsArray.writeToURL(self.fileURL, atomically: true){
        print ("guardado")
        
        }else {
        print ("no guardado")
        }
    }
    func loadItems() {
        
        if let itemsArray = NSArray(contentsOfURL: self.fileURL) as? [String]{
            
            self.items = itemsArray
            
        }
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
