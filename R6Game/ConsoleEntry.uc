class ConsoleEntry extends UIObject
    native
    hidecategories(Object);

const ConsolePromptText = "(> ";

var export editinline UIImage ConsoleBackground;
var export editinline UIImage ConsoleBorder[2];
var export editinline UILabel InputText;
var transient int CursorPosition;

function InitChildren(UIObject CreatedWidget, UIScreenObject CreatorContainer)
{
    InsertChild(ConsoleBackground);
    InsertChild(InputText);
    InsertChild(ConsoleBorder[0]);
    InsertChild(ConsoleBorder[1]);
    return;
}

event PostInitialize()
{
    PostInitialize();
    ConsoleBackground.SetDockTarget(1, self, 1);
    ConsoleBackground.SetDockTarget(3, self, 3);
    ConsoleBorder[1].SetDockTarget(3, self, 3);
    InputText.SetDockTarget(0, self, 0);
    InputText.SetDockTarget(3, ConsoleBorder[1], 3, -3.0000000);
    InputText.SetDockTarget(2, self, 2);
    ConsoleBorder[0].SetDockTarget(3, InputText, 1, -2.0000000);
    SetDockTarget(1, ConsoleBorder[0], 1);
    SetDockTarget(3, GetOwner(), 3);
    SetValue("");
    return;
}

function SetValue(string NewValue)
{
    InputText.super(ConsoleEntry).SetValue("(> " $ NewValue);
    return;
}

defaultproperties
{
    // Reference: UIImage'Default__ConsoleEntry.ConsoleBackgroundTemplate'
    begin object name="ConsoleBackgroundTemplate" class=Class'UIImage'
        Coordinates=(UL=32,VL=32)
        WidgetTag="ConsoleBackground"
        DefaultStyleTag="ConsoleBufferImageStyle"
    end object
    ConsoleBackground=ConsoleBackgroundTemplate
    // Reference:[0] UIImage'Default__ConsoleEntry.UpperConsoleBorderTemplate'
    begin object name="UpperConsoleBorderTemplate" class=Class'UIImage'
        Coordinates=(UL=32,VL=32)
        WidgetTag="UpperConsoleBorder"
        DefaultStyleTag="ConsoleImageStyle"
        Position=(Value[3]=2.0000000)
    end object
    ConsoleBorder=UpperConsoleBorderTemplate
    // Reference: UIImage'Default__ConsoleEntry.LowerConsoleBorderTemplate'
    begin object name="LowerConsoleBorderTemplate" class=Class'UIImage'
        Coordinates=(UL=32,VL=32)
        WidgetTag="LowerConsoleBorder"
        DefaultStyleTag="ConsoleImageStyle"
        Position=(Value[3]=2.0000000)
    end object
    ConsoleBorder=LowerConsoleBorderTemplate
    // Reference: UILabel'Default__ConsoleEntry.InputTextTemplate'
    begin object name="InputTextTemplate" class=Class'UILabel'
        WrapMode=2
        bAutoSizeVert=true
        bIgnoreMarkup=true
        WidgetTag="ConsoleText"
        DefaultStyleTag="ConsoleTextStyle"
        Position=(Value[1]=450.0000000,Value[3]=22.0000000,ScaleType[1]=1)
    end object
    InputText=InputTextTemplate
    WidgetTag="ConsoleEntry"
    DefaultStyleTag="ConsoleStyle"
    OnCreate=InitChildren
    Position=(Value[3]=22.0000000,ScaleType[3]=3)
}