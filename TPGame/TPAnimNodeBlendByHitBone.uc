class TPAnimNodeBlendByHitBone extends AnimNodeBlendList
		native;


struct native AnimProp
{
	var()		float			Probability;	// probability weight
	var()		Name			AnimName;		// animation name to play (None means instant ragdoll)
	var()		float			ForceScale;	// scale of force (0-1) to be applied to ragdoll after anim
	
	structdefaultproperties
	{
		AnimName=None
		Probability=1.0f
		ForceScale=1.0f
	}
};

// groups a list of hit bone names with a group name
struct native HitBoneList
{
	var()		Name				GroupName;			// for Sunil to name his list of HitBoneNames
	var()		Array<Name>		HitBoneNames;		// (empty means any bone)
};

// groups a list of anim props with a group name
struct native AnimPropList
{
	var()		Name				GroupName;			// for Sunil to name his list of AnimProps
	var()		Array<AnimProp>	AnimProps;			// (empty means instant ragdoll 100% force)
};

// groups a hit bone list with a anim prop list
// hit bone must match one of the bones in the HitBones array to pick from the anims in AnimProps array
struct native AnimChoice
{
	var()		HitBoneList	HitBoneList;
	var()		AnimPropList	AnimPropList;
};



/** 
 * Array of AnimChoices.
 */
var(OLDHitZones) Array<AnimChoice>	Front;	// (empty means instant ragdoll 100% force)
var(OLDHitZones) Array<AnimChoice>	Back;	// (empty means instant ragdoll 100% force)
var(OLDHitZones) Array<AnimChoice>	Left;	// (empty means instant ragdoll 100% force)
var(OLDHitZones) Array<AnimChoice>	Right;	// (empty means instant ragdoll 100% force)










struct native GroupProperties
{
	var()	const	Name			Group;		// Name of the group we take from the tune data.
	var()	const	Array<AnimProp>	AnimProps;	// List of animations to play and probabilities of them.
};



var(HitZones) Array<GroupProperties>		HitFromFront;
var(HitZones) Array<GroupProperties>		HitFromBack;
var(HitZones) Array<GroupProperties>		HitFromLeft;
var(HitZones) Array<GroupProperties>		HitFromRight;


var()		Name			DefaultAnimName;		// animation to play when we find no bone name matches
var()		bool			bEnableLogging; //enable debug logging for this node


//-----------------------------------------------------------------------
// Event:  OnInit
//-----------------------------------------------------------------------
function SetDefaultChild(const int DefaultChild)
{
	local int i;
		
	ActiveChildIndex = DefaultChild;
	for (i = 0; i < Children.Length; i++)
	{
		if (i != DefaultChild)
			Children[i].Weight = 0;
		else
			Children[i].Weight = 1;
	}
}

event OnInit()
{
	SetDefaultChild(0); // Dummy
	//log('OnInit');

	super.OnInit();
}


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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


