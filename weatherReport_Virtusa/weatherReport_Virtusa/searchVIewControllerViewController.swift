//
//  searchVIewControllerViewController.swift
//  weatherReport
//
//  Created by Balasubramanian on 2/17/17.
//  Copyright © 2017 Balasubramanian. All rights reserved.
//

import UIKit

class searchVIewControllerViewController: UIViewController {
    
    @IBOutlet weak var searchBtn: UIButton?
    @IBOutlet weak var searchTxt: UITextField?
    
    
    @IBOutlet weak var viewLable: UILabel?
    @IBOutlet weak var gndLevelLable: UILabel?
    @IBOutlet weak var humidityLable: UILabel?
    @IBOutlet weak var pressureLable: UILabel?
    @IBOutlet weak var temperatureLable: UILabel?
    
    @IBOutlet weak var windDegLable: UILabel?
    @IBOutlet weak var windSpeedLable: UILabel?
    
    @IBOutlet weak var sysMsgLable: UILabel?
    @IBOutlet weak var sysSunRiseLable: UILabel?
    @IBOutlet weak var sysSunSetLable: UILabel?
    let preference = UserDefaults.standard



       
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        
        self.title = "Search Screen"
        //let preference = UserDefaults.standard

        if let myString = self.preference.value(forKey: "cityName") as? String{
            
            self.searchTxt?.text = myString
        }
        if let myString = self.preference.value(forKey: "name") as? String{
            
            self.viewLable?.text = myString
        }
        
        if let myString = self.preference.value(forKey: "temp") as? Double{
            
            self.temperatureLable?.text = String(format: "%1f",myString)
            
        }
        
        if let myString = self.preference.value(forKey: "humidity") as? Double{
            
            self.humidityLable?.text = String(format: "%1f",myString)
            
        }
        
       
        if let myString = self.preference.value(forKey: "deg") as? Double{
            
            self.windDegLable?.text = String(format: "%1f",myString)
        }
        if let myString = self.preference.value(forKey: "speed") as? Double{
            
            self.windSpeedLable?.text = String(format: "%1f",myString)
        }
        
        if let myString = self.preference.value(forKey: "message") as? Double{
            
            self.sysMsgLable?.text = String(format: "%1f",myString)
        }
        if let myString = self.preference.value(forKey: "sunrise") as? Double{
            
            self.sysSunRiseLable?.text = String(format: "%1f",myString)
        }
        if let myString = self.preference.value(forKey: "sunset") as? Double{
            
            self.sysSunSetLable?.text = String(format: "%1f",myString)
        }

    
        
      }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction  func searchAction(sender:UIButton!){
        
        
        
        
        // Set up the URL request
        var baseURL="http://api.openweathermap.org/data/2.5/weather?q="
        let searchString = self.searchTxt?.text
        let appID = "&APPID=789d25f2b8cfa2c3f5a045e1dec5a2a1"
        
        self.preference .set(searchString, forKey: "cityName")
        self.preference.synchronize()
        
        
        baseURL = baseURL.appending(searchString!)
        baseURL = baseURL.appending(appID)
        let url = NSURL(string: baseURL)
        
        
        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
            
            if error != nil {
                print("thers an error in the log")
            } else {
                
                DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    
                    let image = UIImage(data: data!)
                    self.setLabels(weatherData: data! as NSData)
                    
                    
                    //self.theImage.image = image
                    
                }
            }
            
        }
        }
        task.resume()
        
    
}

   
     func setLabels (weatherData: NSData){
        
        var jsonError: NSError?
        
        
        do {
        let json = try JSONSerialization.jsonObject(with: weatherData as Data, options: .allowFragments ) as! NSDictionary
            print("json : \(json)")

        if let name = json["name"] as? String{
            self.viewLable?.text = name
            self.preference .set(name, forKey: "name")
            self.preference.synchronize()

            
        }
           
        //main Dictionary
        if let main = json["main"] as? NSDictionary{
          if let temp = main["temp"] as? Double{
            self.temperatureLable?.text = String(format: "%1f",temp)
            self.preference .set(temp, forKey: "temp")
            self.preference.synchronize()
            }
            if let temp = main["humidity"] as? Double{
            self.humidityLable?.text = String(format: "%1f",temp)
            self.preference .set(temp, forKey: "humidity")
            self.preference.synchronize()
            }
            }
            
        
            
       //weather Dictionary
 
       if let weatherArray = json["weather"] as? NSArray{
        if let restult = weatherArray as? NSDictionary{
            print("its dic\(restult)")
        }
        
        
        }
            
        //Wind Dictionary
        if let weather = json["wind"] as? NSDictionary{
            //let tempDic = weather["description"] as? String
                //self.temperatureLable?.text = String(format: "%1f",temp!)
            if let temp = weather["deg"] as? Double{
                self.windDegLable?.text = String(format: "%1f",temp)
                self.preference .set(temp, forKey: "deg")
                self.preference.synchronize()
            }
            if let temp = weather["speed"] as? Double{
                self.windSpeedLable?.text = String(format: "%1f",temp)
                self.preference .set(temp, forKey: "speed")
                self.preference.synchronize()
            }
            }
            
        //sys Dictionary
        if let sys = json["sys"] as? NSDictionary{
            if let temp = sys["message"] as? Double{
                self.sysMsgLable?.text = String(format: "%1f",temp)
                self.preference .set(temp, forKey: "message")
                self.preference.synchronize()
                }
            if let temp = sys["sunrise"] as? Double{
                self.sysSunRiseLable?.text = String(format: "%1f",temp)
                self.preference .set(temp, forKey: "sunrise")
                self.preference.synchronize()
            }
            if let temp = sys["sunset"] as? Double{
                self.sysSunSetLable?.text = String(format: "%1f",temp)
                self.preference .set(temp, forKey: "sunset")
                self.preference.synchronize()
            }
            }
        }
        
        
        catch {
            print("json error: \(error)")
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
