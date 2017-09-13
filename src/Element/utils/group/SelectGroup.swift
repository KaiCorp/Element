import Cocoa
@testable import Utils
/**
 * NOTE: this class also works great with RadioBullets
 * NOTE: Remember to add the selectGroup instance to the view so that the event works correctly // :TODO: this is a bug try to fix it
 * NOTE: Use the SelectGroupModifier and SelectGroupParser for Modifing and parsing the SelectGroup
 * TODO: ⚠️️ You could add a SelectGroupExtension class that adds Modifing and parsing methods to the SelectGroup instance!
 * EXAMPLE: See BasicView in Explorer
 */
class SelectGroup:EventSender{
    var selectables:[Selectable] = []
    var selected:Selectable?
    init(_ selectables:[Selectable], _ selected:Selectable? = nil){
        super.init()
        self.selected = selected
        addSelectables(selectables)
    }
    func addSelectables(_ selectables:[Selectable]){
        selectables.forEach{addSelectable($0)}
    }
    /**
     * NOTE: use a weak ref so that we dont have to remove the event if the selectable is removed from the SelectGroup or view
     */
    func addSelectable(_ selectable:Selectable) {
        if(selectable is EventSendable){ (selectable as! EventSendable).event = onEvent }
        selectables.append(selectable)
    }
    override func onEvent(_ event:Event){
        if(event.type == SelectEvent.select){
            self.event(SelectGroupEvent(SelectGroupEvent.select,selected,self))
            selected = event.immediate as? Selectable
            SelectModifier.unSelectAllExcept(selected!, selectables)
            super.onEvent(SelectGroupEvent(SelectGroupEvent.change,selected,self))
        }
        super.onEvent(event)/*We don't want to block any event being passed through, so we forward all events right through the SelectGroup*/
    }
}
