////
//ZMLRender - Handles the rendering of strings marked in Zombie Markup Language
////

//class ZMLRender extends Object within BasicHud;
class ZMLRender extends Object
	native;

var const string START_TAG;
var const string STOP_TAG;

var BasicHUD HUDOwner;

var array<ZMLCommand> CommandList; 

native function RenderMarkupString(string s, canvas c, float x, float y, BasicHud.ETextJustify just, int xWrap);
native event bool SplitString(string toSplit, out string text1, out string text2, out string markup);

event InitCommandList()
{
	CommandList[0]=new class'ZombieGame.ZMLCmdAction';
	CommandList[1]=new class'ZombieGame.ZMLCmdFont';
}
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

// Decompiled with UE Explorer.
defaultproperties
{
    START_TAG="<"
    STOP_TAG=">"
}