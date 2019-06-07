import UIKit

class GridLayout: UICollectionViewFlowLayout {

    var numberofColumns : Int = 2
    init(numberofColumns :Int) {
        super.init()
        minimumLineSpacing = 1
        minimumInteritemSpacing = 1
        self.numberofColumns = numberofColumns
        
        
    }
    required init(coder aDecoder :NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var itemSize: CGSize {
        
        get{
            
            if collectionView != nil{
                
                let itemwidth:CGFloat = ((collectionView?.frame.width)!/CGFloat(self.numberofColumns)) - self.minimumInteritemSpacing
                
                let itemHeight : CGFloat = 100.0
                return CGSize(width: itemwidth, height: itemHeight)
            }
            return CGSize(width: 100, height: 100)
        }
        
        set{
            
            super.itemSize = newValue
        }
        
    }
    
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return proposedContentOffset
    }

    
    
}
