import Cocoa
@testable import Utils

protocol ElasticSlidableScrollable3:Slidable3,ElasticScrollable3{}
extension ElasticSlidableScrollable3{
    /**
     * PARAM: value represents real contentContainer x/y value, not 0-1 val
     */
    func setProgress(_ value:CGFloat, _ dir:Dir) {
        //Swift.print("👻🏂📜ElasticSlidableScrollable3.setProgress() dir: \(dir) value: \(value)")
        let sliderProgress = ElasticUtils.progress(value,contentSize[dir],maskSize[dir])
        slider(dir).setProgressValue(sliderProgress)//temp fix
        disableAnim{contentContainer.layer?.position[dir] = value}/*using layer.position is alot smoother than frame.origin*/
    }
    func scroll(_ event:NSEvent) {
        //Swift.print("👻🏂📜 ElasticSlidableScrollable3.scroll()")
        (self as Scrollable3).scroll(event)//forward the event
        switch event.phase{
        case NSEvent.Phase.changed://Direct scroll, ⚠️️That you need a hock here is not that great
            let sliderProgress:CGPoint = ElasticUtils.progress(moverGroup!.result,contentSize,maskSize)
            (self as Slidable3).setProgress(sliderProgress)
        case NSEvent.Phase.mayBegin, NSEvent.Phase.began:/*same as onScrollWheelEnter()*/
            showSlider()
        case NSEvent.Phase.ended://same as onScrollWheelExit()
            hideSlider()
        default:break;
        }
        if(event.momentumPhase == NSEvent.Phase.began){//simulates: onScrollWheelMomentumBegan()
            showSlider()//cancels out the hide call when onScrollWheelExit is called when you release after pan gesture
        }
    }
    func onScrollWheelCancelled() {
        Swift.print("ElasticSlidableScrollable3.onScrollWheelCancelled")
        hideSlider()
    }
    func onInDirectScrollWheelChange(_ event:NSEvent) {}/*override to cancel out the event, put this more central*/
}
