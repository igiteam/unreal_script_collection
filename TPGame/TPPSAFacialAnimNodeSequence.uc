class TPPSAFacialAnimNodeSequence extends AnimNodeSequence
	native;

//***********************************************************************
// Variable Declaration
//***********************************************************************

var transient name		CurSequenceName;	// made transient so SetAnim would not incorrectly think the anim was already loaded

struct native AnimLabelPair
{
	var()	Name	Label;
	var()	bool	OverrideFaceFX;
	var()	Name	PSAAnim;

	structdefaultproperties
	{
		OverrideFaceFX=false
	}
};

var()	Name					DefaultAnim;
var()	array<AnimLabelPair>	AnimLabelPairs;

//***********************************************************************
// CPP Text
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

//***********************************************************************
// Default Properties
//***********************************************************************
