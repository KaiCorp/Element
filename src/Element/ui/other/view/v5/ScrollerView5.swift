import Cocoa
@testable import Utils

class ScrollerView5:ProgressableView5,Scrollable5{
    private var scrollHandler:ScrollHandler {return handler as! ScrollHandler}
    override lazy var handler:ProgressHandler = ScrollHandler(progressable:self)
    /**
     * TODO: ⚠️️ Try to override with generics ContainerView<VerticalScrollable>  etc, in swift 4 this could probably be done with where Self:... nopp wont work 🚫
     */
    override open func scrollWheel(with event: NSEvent) {
        scrollHandler.scroll(event)
        super.scrollWheel(with: event)
    }
}
