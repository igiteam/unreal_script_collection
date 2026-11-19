//***********************************************************************
// Class:		SPDestructibleProperties
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************
class SPDestructibleProperties extends Object
	editinlinenew
	NotPlaceable
	dependson(SPDOnBreakActionList)
	native
	hidecategories(Object);
	

//***********************************************************************
// INCLUDES
//***********************************************************************

//***********************************************************************
// MACROS
//***********************************************************************

//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************
struct native FireParamsInfo
{
	var () float FireFlammability;	// Defaults to be zero to indicate its not flammable.
	var () float FireStrength;
	var () float FireSpreadSpeed;
	var () float FireBurnTime;
	var () float FireDamage;
	var () float FireDamagedByScale;		// How much fire damages me.
	var () float FireDamagedByChildScale;	// How much fire attached to me damages me.
	var () float FireCylRadiusOverride;
	var () float FireCylHeightOverride;
	var () float FireScale;
	var	bool	 FireIsTempFire;
	structdefaultproperties
	{
		FireDamagedByScale=1;
		FireDamagedByChildScale=1;
		FireScale=1;
		FireIsTempFire=false;
	}
};

struct native OverriddenLightingParams
{
	var()	bool		bOverrideLighting;
	var()	bool		bDisableInheritBaseLighting;	// If bOverrideLighting == false, don't inherit lighting settings from base actor (if it exists).

	var()	bool						CastShadow;
	var()	const bool					bForceDirectLightMap;
	var()	bool						bCastDynamicShadow;
	var()	const bool					bAcceptsLights;
	var()	const bool					bAcceptsDynamicLights;
	var()	const bool					bUsePrecomputedShadows;
	var()	const LightingChannelContainer	LightingChannels;
	structdefaultproperties
	{
		bDisableInheritBaseLighting = false;
	}
};

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************


var (InitialState)	int					HitPoints;
var (InitialState)	float				MinCollisionVelocity;
var (InitialState)	float				MaxCollisionVelocity;
var (InitialState)	StaticMesh			StaticMesh;
var (InitialState)  float				Sharpness;
var (InitialState)	vector				DrawScale3D;
var (InitialState)	SkeletalMesh		SkeletalMesh;
var (InitialState)	PhysicsAsset		PhysicsAsset;
var( SPDAction) 	float				PhysicsWeight;
var (InitialState)	AnimSet				AnimSet;
var (InitialState)	name				AnimSequenceName;
var (InitialState)	bool				bStartAwake;
var (InitialState)	bool				bDamageAppliesImpulse;
var (InitialState)  bool				bEnableCommands;
var (InitialState)	float				Scale;
var (InitialState)	OverriddenLightingParams	Lighting;

var (FireParamsInfo) FireParamsInfo						FireParams;
var (CollisionSounds) SoundCue CollisionSound[2];

var (OnBreak) 	export editinline array<SPDOnBreakActionList> 	OnBreakActionLists;
var (OnSpawn) 	export editinline array<SPDGenericActionList> 	OnSpawnActionList;
/* problem? don't need
var export editinline array<SPAITag> 	OATStags;
var (OATStags) 	export editinline array<SPAITag2> 	OATStags2;
*/




//***********************************************************************
// CPP TEXT
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


//***********************************************************************
// NATIVE FUNCTION DECLARATIONS
//***********************************************************************

//***********************************************************************
// FUNCTION DECLARATIONS
//***********************************************************************

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------


//***********************************************************************
// Default Properties
//***********************************************************************
				  
