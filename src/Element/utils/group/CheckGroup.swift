import Foundation
@testable import Utils
/*
 * NOTE: remeber to add the group to the view or else the eventBubbling may make errors in other components
 * NOTE: this class would be more logical if it extended EventSender but it extends View so that the event bubbling on the ICheckable objects works
 * NOTE: the constructor checked parameter is just a reference no action is applied to that checked item.
 * TODO: In the future make a MultipleSelectionCheckGroup that can select many icheckable items with the use of shift key for instance (do not add this functionality in this class its not the correct abstraction level)
 * TODO: fix the bubbling stuff this should need to be added to the view or be a sprite.
 */
class CheckGroup:EventSender {
    var checkables:[Checkable] = []
    var checked:Checkable?
    init(_ checkables:[Checkable], _ checked:Checkable? = nil){
        super.init()
        addCheckables(checkables)
        self.checked = checked!
    }
    func addCheckables(_ checkables:[Checkable]) {
        for checkable:Checkable in checkables{ addCheckable(checkable)}
    }
    /**
     * NOTE: Use a weak ref so that we don't have to remove the event if the selectable is removed from the SelectGroup or view
     */
    func addCheckable(_ checkable:Checkable) {
        if(checkable is EventSendable){(checkable as! EventSendable).event = onEvent}
        checkables.append(checkable);
    }
    override func onEvent(_ event:Event) {// :TODO: make protected see SelectGroup
        if(event.type == CheckEvent.check){
            //Swift.print("CheckGroup.onEvent() immediate: " + "\(event.immediate)" + " type: " + "\(event.type)")
            self.event(CheckGroupEvent(CheckGroupEvent.check,checked,self))
            checked = event.immediate as? Checkable
            CheckModifier.unCheckAllExcept(checked!, checkables)
            super.onEvent(CheckGroupEvent(CheckGroupEvent.change,checked,self))
        }
    }
}
