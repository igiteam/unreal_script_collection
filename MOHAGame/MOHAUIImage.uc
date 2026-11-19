class MOHAUIImage extends UIImage
    native
    hidecategories(Object,UIRoot,Object);

// Export UMOHAUIImage::execScriptRefreshPosition(FFrame&, void* const)
native function ScriptRefreshPosition();

function OnDSSetImage(UIAction_DSSetImage Action)
{
    SetValue(Action.NewTexture);
    ScriptRefreshPosition();
    //return;    
}

function OnDSSetImageSize(UIAction_DSSetImageSize Action)
{
    Position.Value[2] = Action.NewSize / 227.0000000;
    ScriptRefreshPosition();
    //return;    
}

event SetImageSize(float newImageSize)
{
    //return;    
}

defaultproperties
{
    // Reference: UIComp_DrawImage'Default__MOHAUIImage.ImageComponentTemplate'
    begin object name=ImageComponentTemplate
    end object
    ImageComponent=ImageComponentTemplate
    // Reference: UIComp_Event'Default__MOHAUIImage.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}