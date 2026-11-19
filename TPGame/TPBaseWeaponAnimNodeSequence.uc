class TPBaseWeaponAnimNodeSequence extends AnimNodeSequence
	dependson(TPWeapon)
	abstract
	native;

//***********************************************************************
// Variable Declaration
//***********************************************************************

var transient name		CurSequenceName;	// made transient so SetAnim would not incorrectly think the anim was already loaded

var string prevStateName;

// Mirror of bLooping, to support bForceLoopingBurstRapidShotWeapon
var     bool            bIsLooping;
var()   bool            bForceLoopingBurstRapidShotWeapon;
var()   int				TestActiveWeapon;

var()	bool			LEGACY_treatSniperRiflesAsRifles;

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
