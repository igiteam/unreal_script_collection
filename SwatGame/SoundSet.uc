class SoundSet extends Core.Object
	native;

//=============================================================================
//  SoundSet.
// 
//  A SoundSet is a group of related sounds (usually variations of the same sound),
//  any of which can be marked as 'Available' for use or 'Used' (not available). 
//  A sound is chosen randomly for the list of available sounds.  It maintains a 
//  list of SoundRefs that handle the actual sound specific data like the 
//  USound object or the streaming sound data.  
//
//==============================================================================

import class Engine.Sound;

enum ESoundStatus 
{
    SS_Available,
    SS_Used
};

// Variables
var private array<SoundRef>		            AllSounds;              // List of SoundRefs in this soundset
var private array<ESoundStatus>	            StatusArray;            // List of Statuses that refer the AllSounds array
var private SoundRef               			LastSoundUsed;          // Last valid sound that this soundset chose

// Public UnrealScript Interface
native final function AddSoundRef (SoundRef inRef);

// Native c++ .h interface
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
