class SeqAct_StartLoadingMovie extends SequenceAction
    native
    hidecategories(Object);

var() string MovieName;
var() string LevelNameMarkup;
var() string GameTypeMarkup;
var() bool bIsSingleplayer;
var() bool bShowTips;
var() Font LevelNameFont;
var() Font TipFont;

defaultproperties
{
    MovieName="Default"
    LevelNameMarkup="Default"
    GameTypeMarkup="Default"
    bIsSingleplayer=true
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Movie File",LinkVar="None",PropertyName="MovieName",bWriteable=false,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Level Name Markup",LinkVar="None",PropertyName="LevelName",bWriteable=false,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Game Type Markup",LinkVar="None",PropertyName="GameType",bWriteable=false,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[3]=(ExpectedType=Class'Engine.SeqVar_Bool',LinkedVariables=none,LinkDesc="IsSingleplayer",LinkVar="None",PropertyName="bIsSingleplayer",bWriteable=false,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Start Loading Movie"
    ObjCategory="MoviePlayer"
}