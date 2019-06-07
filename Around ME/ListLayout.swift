import UIKit

class ListLayout: UICollectionViewFlowLayout {

    var itemHeight :CGFloat = 180
    
    init(itemHeight :CGFloat) {
        super.init()
        minimumLineSpacing = 1
        minimumInteritemSpacing = 1
        self.itemHeight = itemHeight
        
    }
    required init(coder aDecoder :NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var itemSize: CGSize {
        
        get{
            
            if collectionView != nil{
                
                let itemwidth:CGFloat = (collectionView?.frame.width)!
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
