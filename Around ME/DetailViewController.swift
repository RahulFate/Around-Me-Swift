import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import MapKit
import CoreLocation

class DetailViewController: UITableViewController {

    var passedValue = String(), nextPageToken = String(),SelectedPlace = String(),SelectedAddress = String()
    var longit = Double(),latit = Double(),destinationLat = Double(),destinationLong = Double()
    
    var arrDict :NSMutableArray = []

    //Mark:- View Life Cycle
    override func viewDidLoad() {
        jsonParsingFromURL()
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(arrDict.description)
    }
    
    //Mark:- Tableview Delegate and Datasouce Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   arrDict.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCustomCell = tableView.dequeueReusableCell(withIdentifier: "tableviewcustomcell") as! TableViewCustomCell
        cell.selectionStyle = .none
        let nm : NSString = (arrDict[indexPath.row] as AnyObject).value(forKey: "name") as! NSString
        let add : NSString = (arrDict[indexPath.row] as AnyObject).value(forKey: "vicinity") as! NSString
        destinationLat =  (arrDict[indexPath.row] as AnyObject).value(forKeyPath: "geometry.location.lat") as! Double
        destinationLong = (arrDict[indexPath.row] as AnyObject).value(forKeyPath: "geometry.location.lng") as! Double
        var rate = Float32()
        if let x = ((arrDict[indexPath.row] as AnyObject).value(forKey: "rating")) {
            rate = Float32(x as! NSNumber)
        }else{
            rate = 0.2
        }
        if ((rate >= 0) && (rate <= 0.5)){
            
            let image1: UIImage = UIImage(named: "half")!
            cell.rateimg?.image = image1
        }else if ((rate >= 0.6) && (rate <= 1.0)){
            let image2: UIImage = UIImage(named: "one")!
            cell.rateimg?.image = image2
        }else if((rate >= 1.1) && (rate <= 1.5)){
            let image3: UIImage = UIImage(named: "onehalf")!
            cell.rateimg?.image = image3
        }else if((rate >= 1.6) && (rate <= 2.0)){
            let image4: UIImage = UIImage(named: "two")!
            cell.rateimg?.image = image4
        }else if((rate >= 2.1) && (rate <= 2.5)){
            let image5: UIImage = UIImage(named: "twohalf")!
            cell.rateimg?.image = image5
        }else if((rate >= 2.6) && (rate <= 3.0)){
            let image6: UIImage = UIImage(named: "three")!
            cell.rateimg?.image = image6
        }else if((rate >= 3.1) && (rate <= 3.5)){
            let image7: UIImage = UIImage(named: "threehalf")!
            cell.rateimg?.image = image7
        }else if((rate >= 3.6) && (rate <= 4.0)){
            let image8: UIImage = UIImage(named: "four")!
            cell.rateimg?.image = image8
        }else if((rate >= 4.1) && (rate <= 4.5)){
            let image9: UIImage = UIImage(named: "fourhalf")!
            cell.rateimg?.image = image9
        }else if((rate >= 4.6) && (rate <= 5.0)){
            let image10: UIImage = UIImage(named: "five")!
            cell.rateimg?.image = image10
        }
        
        cell.name?.text = nm as String
        cell.address?.text = add as String
        return cell
    }
    
    //Mark:- Json parsing from GooglePlaces API Url
    func jsonParsingFromURL () {
        print("my passed value is" ,passedValue)
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latit),\(longit)&radius=15000&type=\(passedValue)&key=AIzaSyBsQqFvJ7fmbTUARPIGZamy51waUzV7Y7E")
        let request = NSURLRequest(url: url! as URL)
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {(response, data, error) in
                print("getting data \(String(describing: response))")
                self.startParsing(data: data! as NSData)
            }
    }
    
    //Mark:- Start Parsing
    func startParsing(data :NSData)
    {
        let dict: NSDictionary!=(try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
        print("start parsing data \(String(describing: dict))")
        for i in 0  ..< (dict.value(forKey: "results") as! NSArray).count
        {
            arrDict.add((dict.value(forKey: "results") as! NSArray) .object(at: i))
        }
        
        tableView .reloadData()
    }
    
    //Mark:- SEgue to go on MapView Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "segue2") {
            if let indexpath = self.tableView.indexPathForSelectedRow{
                let cell = self.tableView.cellForRow(at:indexpath) as! TableViewCustomCell
                SelectedPlace = (cell.name?.text)!
                SelectedAddress = (cell.address?.text)!
        
                let mapviewController = segue.destination as! MapViewController
                mapviewController.SelectedPlaceName = SelectedPlace
                mapviewController.SelectedPlaceAddress = SelectedAddress
                mapviewController.longitud = SharedVariable.sharedinstance.longi
                mapviewController.latitud = SharedVariable.sharedinstance.lati
                mapviewController.destinationLong = destinationLong
                mapviewController.destinationLat = destinationLat
                
            }
        }
    }
}

