import Cocoa
@testable import Utils
/**
 * NOTE: Indentation is the width of the checkBoxButton
 */
class TreeList3:ElasticScrollFastList3,TreeListable3{//ElasticSlideScrollFastList3
    var treeDP:TreeDP {return dp as! TreeDP}
    /**
     * Recycles items rather than recrate them
     */
    override func reUse(_ listItem:FastListItem) {
        //Swift.print("🍊 \(listItem.idx)")
        let idx3d:[Int] = treeDP.hashList[listItem.idx]
        //Swift.print("idx3d: " + "\(idx3d)")
        listItem.item.id = idx3d.count.string/*The indentation level (from 1 and up), should use classID*/
        disableAnim{listItem.item.skinState = {listItem.item.skinState}()}/*Sets correct indent*/
        let isOpenStr = TreeDPParser.getProp(treeDP, idx3d, "isOpen")
        if let checkable = listItem.item as? CheckBoxButton{
            let isChecked = isOpenStr == "true"
            disableAnim{checkable.checkBox.setChecked(isChecked)}/*Sets correct open/close icon*/
        }
        disableAnim{(listItem.item as! TreeList3Item).checkBox.isHidden = !TreeDPAsserter.hasChildren(treeDP, idx3d)}/*Does item have children?,hides checkBox if item doesn't have children*/
        super.reUse(listItem)/*Sets text and position and select state*/
    }
    override func createItem(_ index:Int) -> Element {
        return createTreeListItem(itemSize,contentContainer)
    }
    /**
     * TODO: Use Switch
     */
    override func onEvent(_ event:Event) {
        if event.type == CheckEvent.check {onItemCheck(event as! CheckEvent) }
        else if event.type == SelectEvent.select {onItemSelect(event as! SelectEvent)}
        super.onEvent(event)
    }
    override func getClassType() -> String {
        return "\(TreeList3.self)"
    }
}
extension TreeList3{
    /**
     * NOTE: This method gets all CheckEvent's from all decending ICheckable instances
     */
    func onItemCheck(_ event:CheckEvent) {
        let idx2d:Int = FastList3Parser.idx(self, (event.origin as! NSView).superview!)!
        if(TreeList3Asserter.isOpen(self, idx2d)){
            Swift.print("close 🚫 idx2d: \(idx2d)")
            TreeDPModifier.close(treeDP, idx2d)
        }else{
            Swift.print("open ✅ idx2d: \(idx2d)")
            TreeDPModifier.open(treeDP, idx2d)
        }
        moverGroup!.yMover.contentFrame = (0,contentSize.height)/*updates mover group to avoid jumpiness*/
        moverGroup!.xMover.contentFrame = (0,contentSize.width)
        onEvent(TreeListEvent(TreeListEvent.change,self))
    }
    func onItemSelect(_ event:SelectEvent){
        Swift.print("TreeList3.onItemSelect")
        onEvent(TreeListEvent(TreeListEvent.change,self))
    }
    /*Create TreeItem*/
    func createTreeListItem(_ itemSize:CGSize, _ parent:Element) -> TreeList3Item{
        let item:TreeList3Item = TreeList3Item(itemSize.width, itemSize.height ,"", false, false, parent)
        return parent.addSubView(item)
    }
}

