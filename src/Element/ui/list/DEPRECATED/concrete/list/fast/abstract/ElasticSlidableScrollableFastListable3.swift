import Cocoa
@testable import Utils

protocol ElasticSlidableScrollableFastListable3:Slidable3,ElasticScrollableFastListable3 {}
extension ElasticSlidableScrollableFastListable3{
    func setProgressValue(_ value:CGFloat, _ dir:Dir) {/*Gets calls from MoverGroup*/
        //Swift.print("ElasticSlidableScrollableFastListable3.setProgressValue(val,dir)")
        setProgressVal(value, dir)//forward
        let sliderProgress = ElasticUtils.progress(value,contentSize[dir],maskSize[dir])//doing some double calculations here
        slider(dir).setProgressValue(sliderProgress)//temp fix
     }
    func scroll(_ event: NSEvent) {
        //Swift.print("ElasticSlidableScrollableFastListable3.scroll")
        (self as Scrollable3).scroll(event)//forward the event
        switch event.phase{
        case NSEvent.Phase.changed://Direct scroll, ⚠️️That you need a hock here is not that great
                let sliderProgress:CGPoint = ElasticUtils.progress(moverGroup!.result,contentSize,maskSize)
                (self as Slidable3).setProgress(sliderProgress)/*moves the sliders*/
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
}
