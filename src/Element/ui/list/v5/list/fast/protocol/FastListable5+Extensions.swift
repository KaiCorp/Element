import Foundation
@testable import Utils

extension FastListable5 {
    /**
     * Returns the first item that visible within view. (item.bottom must cross top of view to count as visible)
     * NOTE: This is the offset index
     */
    var firstVisibleItem:Int{
        let a:CGFloat = abs(contentContainer.layer!.position[dir])//force positive value with abs
        let b:CGFloat = a/itemSize[dir]//how many items fit into "a"
        let c:CGFloat = floor(b)
        let firstVisibleItem:Int = c.int
        return firstVisibleItem
    }
    /**
     * Returns the last item that is visible within view (item top has not crossed bottom of view)
     * NOTE: the existens of item at this index is not garantued. Its the virtual idx of such an item
     * NOTE: This is the offset index
     */
    var lastVisibleItem:Int{
        let a:Int = firstVisibleItem
        let b = maskSize[dir]/itemSize[dir]
        let c = ceil(b)
        let d = c == 0 ? 0 : c + 1//add an extra item to cover the area. should be dealt with in the render method really
        let lastVisibleItem:Int = a + d.int
        return lastVisibleItem
    }
    /**
     * Returns number of items that can fit height
     */
    var numOfItemsThatCanFit:Int {
        return floor(maskSize[dir]/itemSize[dir]).int
    }
    /**
     * Alignes the contentContainer after it's content has been changed (add/remove of item)
     * NOTE: This method makes the Fast list look good when item sout of view vanish. Scroll is realigned and you can continue from where you are
     * NOTE: called by FastList.onDataProviderEvent
     */
    func alignContentContainer(_ event:DataProviderEvent){
        /*Pin to top if itemsHeight is less than height*/
        if contentSize[dir] < maskSize[dir] {//basically when itemsHeight is less than height was /*dp.count <= numOfItemsThatCanFit*/
            contentContainer.layer?.position[dir] = 0
        }
            /*Pin to bottom if (contentContainer.y + itemsHeight) is less than (height) and itemsHeight is more than height*/
        else if contentSize[dir] > maskSize[dir] {
            if (contentContainer.layer!.position[dir] + contentSize[dir]) < maskSize[dir] {
                contentContainer.layer?.position[dir] = -(contentSize[dir] - maskSize[dir])
            }
        }
            /*If an item is added / removed above the first visible item*/
        else if event.startIndex < firstVisibleItem {
            if event.type == DataProviderEvent.remove {
                contentContainer.layer!.position[dir] += itemSize[dir]
                //Swift.print("offset.y + 24")
            }else if event.type == DataProviderEvent.add {
                contentContainer.layer!.position[dir] -= itemSize[dir]
                //Swift.print("offset.y - 24")
            }
        }
    }
}
