class SPUIButtonBar extends UILabel
    native
    config(Input);

struct native UIButtonBindingInfo
{
    var name Name;
    var string Command;
    var const localized string Description;

    structdefaultproperties
    {
        Name="None"
        Command=""
        Description=""
    }
};

struct native UIButton2Font
{
    var string ButtonName;
    var string FontMarkup;

    structdefaultproperties
    {
        ButtonName=""
        FontMarkup=""
    }
};

var config array<config string> UIButtonAlias;
var config array<config UIButton2Font> PCUIButtonFonts;
var config array<config UIButton2Font> XboxUIButtonFonts;
var config array<config UIButton2Font> PS3UIButtonFonts;
var config array<config UIButton2Font> PS3CRUIButtonFonts;
var config array<config UIButtonBindingInfo> UIButtonMaps;
/** Platform specific markup string */
var(Platform) string PS3MarkupString;
var(Platform) string PCMarkupString;
