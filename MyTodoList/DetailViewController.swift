//
//  DetailViewController.swift
//  MyTodoList
//
//  Created by Innovación y Desarrollo on 06-06-16.
//  Copyright © 2016 Innovación y Desarrollo. All rights reserved.
//

import UIKit

        //tenemos que implementar el ImagePickerControllerDelegate e implementar el NavigationCOntrollerDelegate
class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //var item: String? ->para arreglos
    
    var item: TodoItem?
    
    //son opcionales (?), porque al principio no va a existir y luego le voy a pasar el
    //valor
    
    var todoList: TodoList?
    

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func addnotification(sender: UIBarButtonItem) {
       
        if let dateString = self.dateLabel.text {
          if let date = parseDate(dateString){
            self.item?.dueDate = date //->se guarda en TodoItem
            self.todoList?.saveItems() //->Guardo en disco
            //scheduleNotification(self.item!, date: date)
            scheduleNotification(self.item!.todo!, date: date)
            
            API.save(item!, todoList: todoList!, responseBlock: { (error) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    //todo lo que se ejecuta en este bloque se va a ejecutar en el thread principal
                    if let err = error {
                        print(err)
                        self.showError()
                        
                    } else {
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                    
                })
            })
            
            }
        }
    }
    
    func showError() {
        let alert = UIAlertController(title: "Oops!", message:"No pudimos guardar tu tarea en este momento. Revisa tu conexión a internet e intenta más tarde", preferredStyle: .Alert)
        //cuando le den tap al boton de la alerta
        let action = UIAlertAction(title: "OK", style: .Default) {
            _ in
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func scheduleNotification(message: String, date: NSDate){
    let localNotification = UILocalNotification()
        localNotification.fireDate = date
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.alertBody = message
        localNotification.alertTitle = "Recuerda esta Tarea: "
        localNotification.applicationIconBadgeNumber = 1;
        
       UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    @IBAction func dateSelected(sender: UIDatePicker) {
       //se ejecuta cuando termina de elegir el usuario
        
        //imprime en consola
        print ("Fecha Seleccionada: \(sender.date)")
        
        //muestra en label la fecha seleccionada
       // self.dateLabel.text = sender.date.description
        
    // Muestra en el label la fecha seleccionada, pero con el formato establecido en la funcion formatDate
        
        self.dateLabel.text = formatDate(sender.date)
        self.datePicker.hidden = true
        toggleDatePicker()
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func addImage(sender: UIBarButtonItem) {
        
        let imagePickerController = UIImagePickerController ()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        
        imagePickerController.delegate = self //yo soy el delegado
        
        //presentar el viewcontroller
        self.presentViewController(imagePickerController, animated: true, completion:nil)
        
    }
    
    func formatDate (date: NSDate) -> String {
    let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        return formatter.stringFromDate(date)
    }
    
    func parseDate(string: String) -> NSDate? {
        
        let parser = NSDateFormatter()
        parser.dateFormat = "dd/MM/yyyy HH:mm"
        return parser.dateFromString(string)
       
    }
    
    
    override func viewDidLoad() //cuando se esta cargando mi pantalla
    {
        super.viewDidLoad()
       
        //solo para mostrar por consola lo que se imprime
        print ("Item \(item)")
        //self.descriptionLabel.text = item
        showItem()
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        
        tapGestureRecognizer.numberOfTapsRequired = 1 //detectar un toque
        tapGestureRecognizer.numberOfTouchesRequired = 1 //detectar cuantos dedos simultaneos habran en la pantalla -->se activa.
        
        tapGestureRecognizer.addTarget(self, action: "toggleDatePicker") //decir cuando detectes un toque invocas el self y a la accion metodo de su viewcontroller, mostrar y esconder datepicker
        
        self.dateLabel.addGestureRecognizer(tapGestureRecognizer)
        
        self.dateLabel.userInteractionEnabled = true
        
        self.addGestureRecognizerToImage()
        
        // Do any additional setup after loading the view.
    }
    
    
    func showItem() {
    self.descriptionLabel.text = item?.todo
        if let date = item?.dueDate {
        let formatter = NSDateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            self.dateLabel.text = formatter.stringFromDate(date)
                }
        
        if let img = item?.image
        {
            self.imageView.image = img
        
        }
    
    }
        
    func addGestureRecognizerToImage(){
    let gr = UITapGestureRecognizer()
        gr.numberOfTapsRequired = 1 //un solo toque
        gr.numberOfTouchesRequired = 1 //un solo dedo
        gr.addTarget(self, action: "rotate") //cuando detecte el toque ejecute el metodo rotate
        
        self.imageView.userInteractionEnabled = true //activar bandera userInteractionEnabled para activar los toques en vistas
        
        self.imageView.addGestureRecognizer (gr) //al imageview le pasamos nuestro recognizer con nuestro metodo addGestureRecongnizer
        
    }
    
    func rotate(){ //rotar imagen
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.toValue = M_PI * 2.0
        animation.duration = 1
       //ls animation.repeatCount = 5
        self.imageView.layer.addAnimation(animation, forKey: "rotateanimation")
    
    }
    
  
    
    func toggleDatePicker() {
        
       //asi llamamos a los bloques creados de CoreAnimation
        if self.datePicker.hidden {
                self.fadeInDatePicker()
            
        } else {
                self.fadeOutDatePicker()
        }
        
        
        
        //lo comentamos para mandar a llamar los bloques creados
          //fadeInDatePicker() y fadeOutDatePicker()
        
        //self.imageView.hidden = self.datePicker.hidden
        //self.datePicker.hidden = !self.datePicker.hidden
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //************************************//
    //MARK: Animaciones
    
    //mostrar el DatePicker
    
    func fadeInDatePicker() {
    
        //poner valor inicial del componente que voy animar
            self.datePicker.alpha = 0 // --> 0 totalmente transparente
        
            self.datePicker.hidden = false // --> que no este escondido
        
        UIView.animateWithDuration(1) { () -> Void in
            self.datePicker.alpha = 1
            self.imageView.alpha = 0
           
        }
    }
    
    //esconder el datePicker
    func fadeOutDatePicker() {
        self.datePicker.alpha = 1
        self.datePicker.hidden = false
        
        UIView.animateWithDuration(1, animations: { () -> Void in
        self.datePicker.alpha = 0
        self.imageView.alpha = 1
           
        
        }) { (completed) -> Void in//se ejecuta cuando la animacion ya termino
            if completed {
            self.datePicker.hidden = true
            }
            
        }
    }
    //************************************//
    
    
    //siempre que se crea un metodo de un delegado se debe de colocar un MARK para que sea facil encontrarlo
    
    //MARK: Image Picker Controller Metodo
        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            
            //aqui recuperamos la imagen
            if let image = info [UIImagePickerControllerOriginalImage] as? UIImage{
                self.item?.image = image
                self.todoList?.saveItems()
                self.imageView.image = image
                
            }
            self.dismissViewControllerAnimated(true, completion: nil)
            
    }

   
}
