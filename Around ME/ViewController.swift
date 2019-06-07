import UIKit
import GooglePlaces
import  GooglePlacePicker
import GoogleMaps
import CoreLocation
import MapKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var tapButton: UIBarButtonItem?
    
    @IBOutlet weak var SearchBar: UISearchBar?
    
    @IBOutlet weak var collectionview: UICollectionView?
    

    var valueTopass = String()
    var searchActive : Bool = false
    
    //Mark: -  list to show in tableview
    var list = ["Airport","ATM","Banks","Bar","Book Store","Bus Station","Cafe","Church","Clothing Stores","Florist","Gym","Hindu Temple","Hospitals","Library","Movie Theatre","Museum","Night Club","Park","Pharmacy","Police","Post Office","Restaurant","Shopping Mall","Shoe","Spa","Train Station","Zoo"]
    
    ////MARK:- Data which is passed as a parameter to google  near by places api
    var data = ["airport","atm","bank","bar","book_store","bus_station","cafe","church","clothing_store","florist","gym","hindu_temple","hospital","library","movie_theater","museum","night_club","park","pharmacy","police","post_office","restaurant","shopping_mall","shoe","spa","train_station","zoo"]
    
    //MARK:- Data after filtered to pass in google places api
    var filtered:[String] = []
    //Mark:- List after filtered in tableview
    var filteredList:[String] = []
    
    //MARK:- Data Icon image which shown in tableview
    var DataIcon = ["Airport","ATM","Banks","Bar","Book Store","Bus Station","Cafe","Church","Clothing Stores","Florist","Gym","Hindu Temple","Hospitals","Library","Movie Theatre","Museum","Night Club","Park","Pharmacy","Police","Post Office","Restaurant","Shopping Mall","Shoe","Spa","Train Station","Zoo"]
    
    //MARK:- Data Icon after filteration of tableview
    var filteredIcon :[String] = []
    
    let locationManager = CLLocationManager()
    
    var gridLayout :GridLayout!
    
    lazy var listlayout : ListLayout = {
        
        var listlayout = ListLayout(itemHeight : 100)
        
        return listlayout
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        SearchBar?.delegate=self
        SearchBar?.sizeToFit()
        SearchBar?.placeholder = "Search Here "
        SearchBar?.showsSearchResultsButton = true
        navigationController?.navigationBar.barTintColor = UIColor.red
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        // Mark:- Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // Mark:- For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
       
        gridLayout = GridLayout(numberofColumns :2)
        collectionview?.collectionViewLayout = gridLayout!
        collectionview?.reloadData()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        searchActive = false
        SearchBar?.resignFirstResponder()
        collectionview?.delegate=self
        collectionview?.dataSource=self
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark:- Location Manager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = (locations.last?.coordinate)!
        SharedVariable.sharedinstance.longi = Double(locValue.longitude)
        SharedVariable.sharedinstance.lati = Double(locValue.latitude)
        
    }
    
    //MARK:- SearchBar Delegate Methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        SearchBar?.text = nil
        SearchBar?.showsCancelButton = false
        SearchBar?.resignFirstResponder()
        searchActive = false
        self.collectionview?.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        SearchBar?.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = searchText.isEmpty ? data : data.filter { (item: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        filteredList = searchText.isEmpty ? list : list.filter { (item: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        filteredIcon = searchText.isEmpty ? DataIcon : DataIcon.filter { (item: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        self.collectionview?.reloadData()
    }
    //Mark:- Collectionview Delegate and DataSource Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        else {
            return data.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell :CustomCell = collectionview?.dequeueReusableCell(withReuseIdentifier: "collectionviewcustomcell",for:indexPath) as! CustomCell
        if(searchActive){
            
            cell.category?.text = filteredList[indexPath.row]
            cell.iconimg?.image = UIImage(named:filteredIcon[indexPath.row] )
        } else {
            cell.category?.text = list[indexPath.row]
            cell.iconimg?.image = UIImage(named:DataIcon[indexPath.row])
        }
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let view: DetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        if (searchActive) {
            view.passedValue = filtered[indexPath.row]
        }else{
            view.passedValue = data[indexPath.row]
        }
        view.longit = SharedVariable.sharedinstance.longi
        view.latit = SharedVariable.sharedinstance.lati
        self.navigationController?.pushViewController(view, animated: true)
    }
 
    
    /*
    //Mark:- Segue to go on DetailView Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "segue1") {
            for item in self.collectionview!.visibleCells as [UICollectionViewCell] {
                let indexpath : NSIndexPath = self.collectionview!.indexPath(for: item as! CustomCell)! as NSIndexPath
                let cell : CustomCell = self.collectionview!.cellForItem(at: indexpath as IndexPath) as! CustomCell
                valueTopass = (cell.category?.text)!
                print("passed value \(valueTopass)")
                let viewController = segue.destination as! DetailViewController
                viewController.passedValue = valueTopass
                viewController.longit = SharedVariable.sharedinstance.longi
                viewController.latit = SharedVariable.sharedinstance.lati
                
            }
        }
    }
    */
    //Mark :- Change Layout Button Action for list to grid and vice-versa
    @IBAction func btnChangeLayout(_ sender: Any) {
        if collectionview?.collectionViewLayout == gridLayout{
            UIView.animate(withDuration: 0.1, animations: {
                self.collectionview?.collectionViewLayout.invalidateLayout()
                self.collectionview?.setCollectionViewLayout(self.listlayout, animated: false)
                self.tapButton?.image = UIImage(named: "grid_view.png")
            })
        } else  {
            UIView.animate(withDuration: 0.1, animations: {
                self.collectionview?.collectionViewLayout.invalidateLayout()
                self.collectionview?.setCollectionViewLayout(self.gridLayout, animated: false)
                self.tapButton?.image = UIImage(named: "list_view.png")
            })
        }
    }
}

