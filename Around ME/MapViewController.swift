import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps

class MapViewController: UIViewController {

    @IBOutlet weak var mapview: GMSMapView?
    
    var SelectedPlaceName = String()
    var SelectedPlaceAddress = String()
    var longitud = Double()
    var latitud = Double()
    var destinationLat = Double()
    var destinationLong = Double()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var lblTotalDistance: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
         drawRoute()
        calculateTotalDistance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculateTotalDistance()  {
        let coordinate0 = CLLocation(latitude: self.latitud, longitude: self.longitud)
        let coordinate1 = CLLocation(latitude: self.destinationLat, longitude: self.destinationLong)
        let distanceInMeters = coordinate0.distance(from: coordinate1)
        lblTotalDistance.text = "Total Distance : \((distanceInMeters/1000).roundTo(places: 4)) KM"
    }
    
    
    func drawRoute(){
        let userPosition = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
        let userMarker = GMSMarker(position: userPosition)
        userMarker.icon = GMSMarker.markerImage(with: UIColor.green)
        userMarker.title = "My Location"
        userMarker.map = mapview
        let destinationPosition = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)
        let destinationMarker = GMSMarker(position: destinationPosition)
        destinationMarker.title = SelectedPlaceName
        destinationMarker.snippet = SelectedPlaceAddress
        destinationMarker.map = mapview
        let origin = "\(latitud),\(longitud)"
        let destination = "\(destinationLat),\(destinationLong)"
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyBsQqFvJ7fmbTUARPIGZamy51waUzV7Y7E"
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let routes = json["routes"] as! NSArray
                    if(routes.count == 0){
                        let point = GMSCameraPosition.camera(withLatitude: self.latitud,
                                                              longitude: self.longitud,
                                                              zoom: 12)
                        self.mapview!.camera = point
                    }
                    OperationQueue.main.addOperation({
                        for route in routes
                        {
                            let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                            let points = routeOverviewPolyline.object(forKey: "points")
                            let path = GMSPath.init(fromEncodedPath: points! as! String)
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 3
                            let bounds = GMSCoordinateBounds(path: path!)
                            self.mapview!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 1.0))
                            polyline.map = self.mapview
                        }
                    })
                }catch let error as NSError{
                    print("error:\(error)")
                }
            }
        }).resume()
    }
}
extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
