class SkyUICredits extends SkyUI_Widget
    native
    config(UI);

struct native CreditStyle
{
    var() string StyleTag;
    var() UITextStyleOverride Style;
    var transient int LineHeight;

    structdefaultproperties
    {
        StyleTag=""
        Style=(DrawFont=none,TextAttributes=(Bold=false,Italic=false,Underline=false,Shadow=false,Strikethrough=false),TextAlignment=UIALIGN_Left,TextAlignment[1]=UIALIGN_Left,ClipMode=CLIP_None,ClipAlignment=UIALIGN_Left,AutoScaling=(MinScale=0.6000000,MaxScaleX=-1.0000000,MaxScaleY=-1.0000000,AutoScaleMode=UIAUTOSCALE_None),DrawScale=1.0000000,DrawScale[1]=1.0000000,SpacingAdjust=0.0000000,SpacingAdjust[1]=0.0000000,bOverrideDrawFont=false,bOverrideAttributes=false,bOverrideAlignment=false,bOverrideClipMode=false,bOverrideClipAlignment=false,bOverrideAutoScale=false,bOverrideScale=false,bOverrideSpacingAdjust=false,DrawColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=0.0000000),Opacity=0.0000000,Padding=0.0000000,Padding[1]=0.0000000,bOverrideDrawColor=false,bOverrideOpacity=false,bOverridePadding=false)
        LineHeight=0
    }
};

struct native CreditLine
{
    var() string Text;
    var() int StyleIndex;
    var() int LineOffset;
    var() int ColumnIndex;
    var() int ColumnCount;
    var transient int Height;

    structdefaultproperties
    {
        Text=""
        StyleIndex=0
        LineOffset=0
        ColumnIndex=0
        ColumnCount=0
        Height=0
    }
};

var() string Filename;
var() float LinesPerSecond;
var() Font DefaultFont;
var() array<CreditStyle> Styles;
var() float GlobalTextScale;
var() bool UseResolutionScaling;
var transient array<CreditLine> Lines;
var transient int TopLine;
var transient float DefaultLineHeight;
var transient float MaxLineHeight;
var transient float TotalHeight;
var transient float CurrentHeight;
