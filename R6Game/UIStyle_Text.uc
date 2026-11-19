class UIStyle_Text extends UIStyle
    native;

var() Font StyleFont;
var() UITextAttributes Attributes;
var() UIRoot.EUIAlignment Alignment[2];

defaultproperties
{
    Alignment[1]=1
    StyleName="Default Text Style"
}