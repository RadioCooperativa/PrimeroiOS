//
//  TodoItem.swift
//  MyTodoList
//
//  Created by Innovación y Desarrollo on 13-06-16.
//  Copyright © 2016 Innovación y Desarrollo. All rights reserved.
//

import UIKit

class TodoItem: NSObject, NSCoding {
    
    var todo: String?
    
    var dueDate: NSDate?
    
    var image: UIImage?
    
    var id: Int64?
    
    //inicializador que no recibe argumentos
    //solo manda a llamar al de la superclase
    override init() {
        super.init()
    }
    
    
    //implementar metodos del protocolo
    
    required init(coder aDecoder: NSCoder){
        super.init()
        
        //con la clase coder podemos recuperar los objetos de disco
        
        //con required queremos que todas las subclases que hereden de TodoItem implementen este mismo inicializador,  porque queremos que todas las subclases puedan ir guardando en disco
        
        //llamamos al inicializador de la superclase
        
        
        if let message = aDecoder.decodeObjectForKey("todo") as? String{
            //recuperamos el texto o la descripcion
            self.todo = message
        }
        
        if let date = aDecoder.decodeObjectForKey("dueDate") as? NSDate{
            //recuperamos la fecha
            self.dueDate = date
        }
        
       
        
        if let img = aDecoder.decodeObjectForKey("image") as? UIImage{
            //recuperamos la imagen
            self.image = img
            
        }
        
        //nunca regresa un optional solo un 0 si es que no lo encuentra
        //por eso no va el if
        
        let identifier = aDecoder.decodeInt64ForKey("identifier")
        if identifier != 0 {
        self.id=identifier
        }
        
        
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        //metodo para guardar en disco
        
        
        if let message = self.todo{
            aCoder.encodeObject(message, forKey: "todo")
            //el nombre con el que se guarda es el mismo con el que se tiene que recuperar
            
        }
        
        
        if let date = self.todo{
            aCoder.encodeObject(date, forKey: "dueDate")
            //el nombre con el que se guarda es el mismo con el que se tiene que recuperar
            
        }
        
        
        if let img = self.todo{
            
            aCoder.encodeObject(img, forKey: "image")
            //el nombre con el que se guarda es el mismo con el que se tiene que recuperar
            
        }
        
        if let indentifier = self.id{
            aCoder.encodeInt64(indentifier, forKey: "identifier")
        }
        
    }
    
    class func parse(result: [Dictionary<String, AnyObject>]) -> [TodoItem] {
        var items = [TodoItem]()
        for dict in result {
            let item = TodoItem()
            if let message = dict["message"] as? String {
                item.todo = message
            }
            if let identifier = dict["id"] as? NSNumber {
                item.id = identifier.longLongValue
            }
            if let dateStr = dict["dueDate"] as? String {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                if let date = dateFormatter.dateFromString(dateStr) {
                    item.dueDate = date
                }
            }
            items.append(item)
        }
        return items
    }
    
}



