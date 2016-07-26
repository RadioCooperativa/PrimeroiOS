//
//  API.swift
//  MyTodoList
//
//  Created by Innovación y Desarrollo on 26-07-16.
//  Copyright © 2016 Innovación y Desarrollo. All rights reserved.
//

import UIKit


class API {
    
    class func uniqueUsername() -> String {
        if let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as? String{
            return username
        } else {
            let newUsername = generateUsername()
            NSUserDefaults.standardUserDefaults().setObject(newUsername, forKey: "username")
            return newUsername
        }
    }
    
    class func generateUsername() -> String {
        let uuid = NSUUID().UUIDString
        return (uuid as NSString).substringToIndex(5)
    }
    
    class func save(item: TodoItem, todoList: TodoList, responseBlock: (NSError?)
        -> Void) {
        //recuperar nuestra URLSession
        let session = NSURLSession.sharedSession()
        //url que vamos a invocar
        let url = NSURL(string: "https://pendientesapp.herokuapp.com/todo")!
        
        //creamos una peticion http, recibe la url
        let request = NSMutableURLRequest(URL: url)
        
        //especificamos el metodo http que vamos a utilizar,POST para guardar, por defecto es GET
        request.HTTPMethod = "POST"
        
        //nuestro metodo recibe un JSON con los objetos a guardar
        //para hacer un JSON en swift primero tenemos que hacer un Diccionario
        //Swift sabe transformar diccionarios y array a objetos de tipo JSON
        var dictionary: Dictionary<String, AnyObject> =
            ["message": item.todo!, "user": self.uniqueUsername()]
        
        if let date = item.dueDate {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            dictionary["dueDate"] = formatter.stringFromDate(date)
        }
        if let identifier = item.id {
            dictionary["id"] = NSNumber(longLong: identifier)
        }
        
        //transformar a JSON
        let data = try! NSJSONSerialization.dataWithJSONObject(dictionary,
     options:  NSJSONWritingOptions.PrettyPrinted)
        
        let  datastring = NSString(data: data, encoding: NSUTF8StringEncoding)
        print("body \(datastring!)")
        request.HTTPBody = data
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            print("response \(response)")
            //si ubo un error
            if let err = error {
                responseBlock(err)
            } else {//si no, convertimos a un objeto de swift, deserializamos
                if let r = data {
                    let result = try! NSJSONSerialization
                        .JSONObjectWithData(r, options: NSJSONReadingOptions.AllowFragments)
                    //extraemos el id, result es un diccionario 
                    if let id = result["id"] as? Int64 {
                        item.id = id
                        print("id \(id)")
                        todoList.saveItems()
                    }
                }
                responseBlock(nil)
            }
            
        }
        task.resume()
    }
    
    class func get(todoList: TodoList, responseBlock: (NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: "https://pendientesapp.herokuapp.com/todo/\(self.uniqueUsername())")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            if let err = error {
                dispatch_async(dispatch_get_main_queue()) {
                    responseBlock(err)
                }
            } else {
                if let r = data {
                    let result = try! NSJSONSerialization.JSONObjectWithData(r, options: NSJSONReadingOptions.AllowFragments)
                    
                    if let r = result as? [Dictionary<String, AnyObject>] {
                        let items = TodoItem.parse(r)
                        todoList.items = items
                        todoList.saveItems()
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    responseBlock(nil)
                }
                
            }
            
        }
        task.resume()
    }
    
    
}