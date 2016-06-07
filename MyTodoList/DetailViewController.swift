//
//  DetailViewController.swift
//  MyTodoList
//
//  Created by Innovación y Desarrollo on 06-06-16.
//  Copyright © 2016 Innovación y Desarrollo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
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
       //imprime en consola
        print ("Fecha Seleccionada: \(sender.date)")
        
        //muestra en label la fecha seleccionada
       // self.dateLabel.text = sender.date.description
        
    // Muestra en el label la fecha seleccionada, pero con el formato establecido en la funcion formatDate
        
        self.dateLabel.text = formatDate(sender.date)
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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
