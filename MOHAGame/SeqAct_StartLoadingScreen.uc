class SeqAct_StartLoadingScreen extends SequenceAction
    native
    hidecategories(Object);

struct native LoadingImageEntry
{
    var() Vector2D pos;
    var() Vector2D Size;
    var() Material Image;

    structdefaultproperties
    {
        pos=(X=0.0000000,Y=0.0000000)
        Size=(X=0.0000000,Y=0.0000000)
        Image=none
    }
};

struct native LoadingTextEntry
{
    var() Vector2D pos;
    var() string Text;
    var() string textFont;

    structdefaultproperties
    {
        pos=(X=0.0000000,Y=0.0000000)
        Text=""
        textFont="UI_Fonts.LucidaBr_14B"
    }
};

struct native LoadingScreenDefinition
{
    var() float LayoutWidth;
    var() float LayoutHeight;
    var() editinline array<editinline LoadingImageEntry> ImageList;
    var() editinline array<editinline LoadingTextEntry> TextList;

    structdefaultproperties
    {
        LayoutWidth=1280.0000000
        LayoutHeight=720.0000000
        ImageList=none
        TextList=none
    }
};

var() string LevelNameMarkup;
var() string GameTypeMarkup;
var() bool bIsSingleplayer;
var() bool bShowTips;
var() string LevelNameFont;
var() string TipFont;
var() editinline LoadingScreenDefinition loadingScreenHD;
var() editinline LoadingScreenDefinition loadingScreenSD;

// Export USeqAct_StartLoadingScreen::execScriptActivate(FFrame&, void* const)
native function ScriptActivate();

defaultproperties
{
    LevelNameMarkup="Default"
    GameTypeMarkup="Default"
    bIsSingleplayer=true
    LevelNameFont="MOHAUISkin.Fonts.Trajan30"
    TipFont="UI_Fonts.LucidaBr_14B"
    loadingScreenHD=(LayoutWidth=1280.0000000,LayoutHeight=720.0000000,ImageList=none,TextList=none)
    loadingScreenSD=(LayoutWidth=1280.0000000,LayoutHeight=720.0000000,ImageList=none,TextList=none)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Level Name Markup",LinkVar="None",PropertyName="LevelName",bWriteable=false,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Game Type Markup",LinkVar="None",PropertyName="GameType",bWriteable=false,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Bool',LinkedVariables=none,LinkDesc="IsSingleplayer",LinkVar="None",PropertyName="bIsSingleplayer",bWriteable=false,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Start Loading Screen"
    ObjCategory="Misc"
}