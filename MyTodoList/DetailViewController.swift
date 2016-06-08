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
    
    var item: String?

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func addnotification(sender: UIBarButtonItem) {
        if let dateString = self.dateLabel.text {
          if let date = parseDate(dateString){
            scheduleNotification(self.item!, date: date)
                }
            }
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //solo para mostrar por consola lo que se imprime
        print ("Item \(item)")
        self.descriptionLabel.text = item
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        
        tapGestureRecognizer.numberOfTapsRequired = 1 //detectar un toque
        tapGestureRecognizer.numberOfTouchesRequired = 1 //detectar cuantos dedos simultaneos habran en la pantalla -->se activa.
        
        tapGestureRecognizer.addTarget(self, action: "toggleDatePicker") //decir cuando detectes un toque invocas el self y a la accion metodo de su viewcontroller, mostrar y esconder datepicker
        
        self.dateLabel.addGestureRecognizer(tapGestureRecognizer)
        
        self.dateLabel.userInteractionEnabled = true
        
        
        // Do any additional setup after loading the view.
    }
    
    func toggleDatePicker() {
        self.imageView.hidden = self.datePicker.hidden
        self.datePicker.hidden = !self.datePicker.hidden
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //siempre que se crea un metodo de un delegado se debe de colocar un MARK para que sea facil encontrarlo
    
    //MARK: Image Picker Controller Metodo
        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            
            //aqui recuperamos la imagen
            if let image = info [UIImagePickerControllerOriginalImage] as? UIImage{
            
                self.imageView.image = image
                
            }
            self.dismissViewControllerAnimated(true, completion: nil)
            
    }

   
}
