//=============================================================================
class AnimNotify_ComboButton extends AnimNotify
	native;
	
	
	
enum ComboButtonID
{
	ComboButton_XBOX_A,
	ComboButton_XBOX_B,
	ComboButton_XBOX_X,
	ComboButton_XBOX_Y,
};
	
	
struct native ComboButtonInfo
{
	var() float fadeInTime;
	var() float solidTime;
	var() float fadeOutTime;
	var() ComboButtonID buttonID;
};
	
var() ComboButtonInfo ButtonInfo;	
	
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

