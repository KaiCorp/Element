import Foundation
@testable import Utils
/**
 * TODO: ⚠️️ Impliment IDisableable also and extend DisableTextButton
 * TODO:
 */
class RadioButton:TextButton,Selectable{
    lazy var radioBullet:RadioBullet = self.createRadioBullet()
    fileprivate var isSelected:Bool
    init(text:String = "defaultText",isSelected:Bool = false,size:CGSize = CGSize(0,0),id:String? = nil){
        self.isSelected = isSelected
        super.init(text:text, size: size, id: id)
    }
    /**
     * NOTE: When added to stage and if RadioBullet dispatches selct event it will bubble up and through this class (so no need for extra eventlistners and dispatchers in this class)
     * NOTE: The radioBullet has an id of "radioBullet" (this may be usefull if you extend CheckBoxButton and that subclass has children that are of type Button and you want to identify this button and noth the others)
     */
    override func resolveSkin() {
        super.resolveSkin()
        _ = radioBullet/*Init the UI*/
    }
    func setSelected(_ isSelected:Bool) {
        radioBullet.setSelected(isSelected)
    }
    /**
     * NOTE: This method represents something that should be handled by a method named getSelected, but since this class impliments ISelectable it has to implment selected and selectable
     */
    func getSelected()->Bool {
        return radioBullet.getSelected()
    }
    required init(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    //DEPRECATED
    init(_ width:CGFloat, _ height:CGFloat, _ text:String = "defaultText", _ isSelected:Bool = false, _ parent:ElementKind? = nil, _ id:String? = nil) {
        self.isSelected = isSelected
        super.init(width,height,text,parent,id)
    }
}
class RadioBullet:SelectButton{}/*RadioBullet is targeted in CSS, but is essentially the same as a SelectButton*/
extension RadioButton{
    /**
     * Makes lazy var more organized
     */
    func createRadioBullet()->RadioBullet{
        return self.addSubView(RadioBullet.init(isSelected: self.isSelected))
    }
}
