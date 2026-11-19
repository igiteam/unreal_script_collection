class UILabel extends UIObject
    native
    hidecategories(Object);

var() private string DataSource;
var private transient UIString Value;
var() private UIRoot.ETextClipMode WrapMode;
var() bool bAutoSizeHorz;
var() bool bAutoSizeVert;
var bool bReapplyFormatting;
var bool bIgnoreMarkup;

// Export UUILabel::execSetValue(FFrame&, void* const)
native final function SetValue(string NewText);

final function SetArrayValue(array<string> ValueArray)
{
    local string Str;

    JoinArray(ValueArray, Str, "\n", false);
    SetValue(Str);
    return;
}

function string GetValue()
{
    return Value.super(UILabel).GetValue();
    return;
}

defaultproperties
{
    DataSource="InitialLabelText"
    WrapMode=1
    DefaultStyleTag="DefaultTextStyle"
    Position=(Value[2]=100.0000000,Value[3]=40.0000000,ScaleType[2]=3,ScaleType[3]=3)
}