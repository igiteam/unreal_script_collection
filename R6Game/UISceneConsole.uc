class UISceneConsole extends UIScene
    transient
    hidecategories(Object);

var export editinline UILabel BufferText;
var export editinline UIImage BufferBackground;
var export editinline ConsoleEntry CommandRegion;

event Initialized()
{
    Initialized();
    InsertChild(BufferBackground);
    InsertChild(BufferText);
    InsertChild(CommandRegion);
    return;
}

event PostInitialize()
{
    PostInitialize();
    BufferBackground.SetDockTarget(3, CommandRegion, 1);
    BufferBackground.SetDockTarget(1, none, 1);
    BufferText.SetDockTarget(3, CommandRegion, 1);
    return;
}

defaultproperties
{
    // Reference: UILabel'Default__UISceneConsole.BufferTextTemplate'
    begin object name="BufferTextTemplate" class=Class'UILabel'
        WrapMode=2
        bAutoSizeVert=true
        WidgetTag="BufferText"
        DefaultStyleTag="ConsoleBufferTextStyle"
    end object
    BufferText=BufferTextTemplate
    // Reference: UIImage'Default__UISceneConsole.BufferBackgroundTemplate'
    begin object name="BufferBackgroundTemplate" class=Class'UIImage'
        WidgetTag="BufferBackground"
        DefaultStyleTag="ConsoleBufferImageStyle"
    end object
    BufferBackground=BufferBackgroundTemplate
    // Reference: ConsoleEntry'Default__UISceneConsole.CommandRegionTemplate'
    begin object name="CommandRegionTemplate" class=Class'ConsoleEntry'
    end object
    CommandRegion=CommandRegionTemplate
    SceneTag="ConsoleScene"
    Position=(Value[3]=0.7500000)
}