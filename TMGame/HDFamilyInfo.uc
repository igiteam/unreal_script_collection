//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDFamilyInfo extends TMFamilyInfo
	native(HDGame)
    abstract;

/** Structure containing information about a specific Animation */
struct native CustomAnimInfo
{
	/** Category to which this emote belongs. */
	var name		CategoryName;
	/** This is a unique tag used to look up this emote */
	var name		TagName;
	/** Name of animation to play. Should be in AnimSets above. */
	// custom animations matching with pawn posture
	// 0: stand
	// 1: crouch
	// 2: prone
	// transition category alawys has only one sequences
	var array<name>	AnimNames;
	/** Emote should only be played on top half of body. */
	var bool		bTopHalf;
	// loop flag
	var bool        bLoopFlag;
	// override flag
	var bool        bOverrideFlag;
	// rate scale
	var float       RateScale;
	// blend in time
	var float       BlendInTime;
	// blend out time
	var float       BlendOutTime;
    // IK flag
    var bool        bStopIKFlag;
	StructDefaultProperties
	{
		bLoopFlag=False
		bOverrideFlag=True
		RateScale=1.0f
		BlendInTime=0.2f
		BlendOutTime=0.2f
		bStopIKFlag=True
	}
};

/** Set of all emotes for this family. */
var array<CustomAnimInfo>	CustomAnimInfos;


/**
 * Finds the index of the emote given a tag
 */
function static int GetCustomAnimIndex(name TagName)
{
	local int i;
	for (i=0;i<default.CustomAnimInfos.length;i++)
	{
		if ( default.CustomAnimInfos[i].TagName == TagName )
		{
			return i;
		}
	}
	return -1;
}



