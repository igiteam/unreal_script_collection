class TurokUIEditBox extends UIEditBox
    native
    hidecategories(Object,UIRoot,Object);

defaultproperties
{
    // Reference: UIComp_DrawStringEditbox'Default__TurokUIEditBox.EditboxStringRenderer'
    begin object name=EditboxStringRenderer
    end object
    StringRenderComponent=EditboxStringRenderer
    // Reference: UIComp_Event'Default__TurokUIEditBox.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}