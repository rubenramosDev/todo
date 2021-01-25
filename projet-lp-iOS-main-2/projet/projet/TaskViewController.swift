
import UIKit
import MapKit
import Foundation

class TaskViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var boutonSave: UIBarButtonItem!
    @IBOutlet weak var boutonCancel: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var switchLocalisation: UISwitch!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var customIn: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    
    let dateFormater = DateFormatter()
  

    var task : ToDo?
    let locationMan = CLLocationManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let task = task {
            customIn.text = task.titre
            
            let today = task.derniereMod
            let formatter1 = DateFormatter()
            formatter1.dateStyle = .short
            labelDate.text = formatter1.string(from: today)
            
            if task.localisation != nil {
                switchLocalisation.setOn(false, animated: true)
            }
             mapView.centerToLocation(task.localisation!)
            imageView.image = UIImage(named: task.photo!)
        }
    }


    func textFieldDidChange(textField: UITextField) {
        if let text = customIn.text, text.isEmpty{
                boutonSave.isEnabled = false
             }else{
                boutonSave.isEnabled = true
             }
     }

    
    
    func getCenterLocation (for mapview: MKMapView) -> CLLocation {
        let coordinates = mapview.centerCoordinate
        return CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    

    @IBAction override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var toDo = ToDo(titre: customIn.text!, etat:true)
        
        locationMan.requestWhenInUseAuthorization()
        if switchLocalisation.isOn {
         
            locationMan.delegate = self;
            locationMan.desiredAccuracy = kCLLocationAccuracyBest
            locationMan.requestAlwaysAuthorization()
            locationMan.startUpdatingLocation()
            let locValue:CLLocationCoordinate2D = locationMan.location!.coordinate
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            
        }
        
        task = toDo
    }
    
}

    extension MKMapView {
       func centerToLocation (
           _ location: CLLocation,
           regionRadius: CLLocationDistance = 100){
           let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
       }
   }



