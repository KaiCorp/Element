import Cocoa
@testable import Utils
class ScrollerList5:ProgressableList5,Scrollable5{
    private var scrollHandler:ScrollHandler {return handler as! ScrollHandler}
    override lazy var handler:ProgressHandler = ScrollHandler(progressable:self)
    /**
     * Overrides the native scrollWheel and passes this call to the scrollHandler
     */
    override open func scrollWheel(with event: NSEvent) {
//        Swift.print("ScrollList5.scrollWheel")
        scrollHandler.scroll(event)
        super.scrollWheel(with: event)
    }
}

