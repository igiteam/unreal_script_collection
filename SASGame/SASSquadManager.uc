//=============================================================================
// SASSquadManager.uc
//
// Squad management functions
//
//=============================================================================

class SASSquadManager extends ReplicationInfo
		native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

const MAX_SQUAD_MEMBERS				= 4;
const MAX_SQUAD_THREATS				= 8;

const STACKUPSLOT_Empty				= -1;
const STACKUPSLOT_FilledByPlayer	= -2;

const MAX_PLAYER_SEPARATION			= 7.0;
const MAX_PLAYER_SEPARATION_LV		= 2.0;			// Large volume distance

const MAX_WAIT_TIME_FOR_GRENADE		= 10.0;
const ASSAULT_TIMER_TICK			= 0.25;

//-----------------------------------------------------------------------------
// Enums

enum ESASAssaultTeamStatus
{
	ATSTATUS_UNKNOWN,			// Error
	ATSTATUS_STACKING_UP,		// En-route to stack-up point
	ATSTATUS_MOVETOFIRSTDP,		// Moving to first DP in room
	ATSTATUS_MOVETODP,			// Moving to any subsequent DP
	ATSTATUS_ENGAGING,			// Firing at enemy
	ATSTATUS_SWEEPING,			// Sweeping room for targets
	ATSTATUS_WAITING,			// Waiting for next instruction
	ATSTATUS_GUARDING			// Waiting at final DP (guarding other EPs)
};


enum ESASBackupSquadMode
{
	BSM_INTERIOR_FOLLOW,		// Following player waiting in previous AV
	BSM_INTERIOR_BACKUP,		// Backing up an assault
	BSM_INTERIOR_STACKUP,		// Stacking up ready for assault
	BSM_INTERIOR_ASSAULT,		// Assaulting a room as instructed by player
	BSM_INTERIOR_GUARD,			// Guarding DP after assault
	BSM_HOSTAGE_ESCORT,			// Escorting hostages
	BSM_EXTERIOR				// Exterior AV mode.
};

//-----------------------------------------------------------------------------
// Structs

struct native SquadThreatInfo
{
	var Actor	mTarget;
	var float	AcquireTime;

	var int		NextOrderedThreatIdx;
};

struct native sBackupSelection
{
	var SASSoldier mSoldier [2];
	var SASDominationPoint mDP [2];
	var float mRangeToPlayer [2];
	var float mRangeToSoldier [2];
};

struct native sSquadPointCache
{
	var bool mFoundForThisAV;			// Do we need to recalculate ?
	var SASSoldier mSoldier [2];		// Who points are for
	var SASDominationPoint mDP [2];		// DPs if available
	var Vector mPoints [2];				// Position
	var Vector mDir [2];				// Direction
	var int mStackPoint [2];			// Are these based on stackup points ?
};

struct native sAssaultSquadStatus
{
	var SASSoldier mSoldier;			// Who this is
	var ESASAssaultTeamStatus mStatus;	// What they are doing
	var SASDominationPoint mDP;			// Where they are going
};

//struct native sHeardNoise
//{
//	var Actor mSource;					// Who made the noise
//	var eNoiseType mType;				// Type (and thus priority) of noise
//	var float mLastHeardTime;			// Time we last heard this sound
//	var Vector mLocation;				// Where we heard the noise
//	var Vector mLookAtPoint;			// Where we should look at for this sound
//};
//-----------------------------------------------------------------------------
// Member Vars

var	int							mSquadID;							// Effectively == team number

var SASSoldier					mPlayers[MAX_SQUAD_MEMBERS];		// Players in the squad.
var int							mNumPlayers;						// Number of players in the squad.
var SASSoldier					mAISquadMembers[MAX_SQUAD_MEMBERS];	// AI members in the squad.
var int							mNumAISquadMembers;					// Number of AI members in the squad.
var int							mWingmanIndex;
var int							mStackUpOrder[MAX_SQUAD_MEMBERS];	// Squad member order when stacking up.

var SASHostage					mAssignedHostages [MAX_SQUAD_MEMBERS];	// Hostages being watched by squad
var float						mLastSquadShout;					// Last time squad member shouted at hostages
var float						mSquadShoutInterval;				// Time between shouting at hostages

// Threat info - to be removed - should use fighter controller threat info array.
var SquadThreatInfo				mSquadThreats[MAX_SQUAD_THREATS];
var int							mNumSquadThreats;			
var float						mLastThreatInfoFullRefreshTime;
var float						mLastThreatInfoPartialRefreshTime;

var SASEntryPoint				mAssaultEP;							// Current EP into room we are about to assault.
//var SASEntryPoint				mBackupSquadAssaultEP;
var SASDoorMover				mAssaultDoor;						// Current door we're about to assault
var float						mPlayerReachedAssaultEPTime;		// Level time that player arrived in range of assault EP.
var int							mAssaultEPStackUpSide;				// Side of assault EP (infront or behind) to stack up on.
var SASEntryPoint				mLastAssaultedEP;					// Last EP assaulted.
var int							mLastAssaultedEPStackUpSide;		// Stacking up side of last assaulted EP.
var int							mAssaultTimer;						// Used to kick off room assault
var int							mStackUpTimer;						// Used to update stack-up positions
var int							mMonitorPlayerTimer;				// Used to monitor player position

var Vector						mLastPlayerMonitorPosition;			// Last place we checked for player

var float						mLastHostageShoutDownTime;			// Level time when hostages were last shouted at by AI.
var () int						mHostageShoutDownMax;				// Limit number of shouts per volume
var bool						mbWingmanCalledClear;				// True if wingman has called clear in current room assault.
var bool						mbPlayerCalledClear;				// True if player has called clear in current room assault.

var sBackupSelection			mBackupSquadDPs;					// Domination points for the backup squad selected by squad manager

// Room assault data
var SASSoldier					mDoorOpener;						// Soldier assigned to open / breach the door
var SASSoldier					mAssaultTeam [2];					// Soldier assigned to go through the door
var sSquadPointCache			mStackUpPoints [2];					// Where assault squad should stack up
var bool						mbDoorIsOpen;						// Set once door is breached or open
var float						mAssaultTeamGoSent [2];				// Has go order been sent ?
var ESASAssaultTeamStatus		mAssaultTeamReady [2];				// Status of assault team during stackup
var bool						mbDoorOpenerIsReady;
var bool						mbPauseforGrenade;					// Do we wait for the player to throw a grenade ?
var bool						mbGrenadeThrown;						// Has grenade been thrown yet ?
var float						mAssaultCounter;					// Used to time out grenade assaults

// Backup squad monitoring
var ESASBackupSquadMode			mBackupSquadMode;					// What the backup squad is doing
var SASAssaultVolume			mPlayerVolume;						// Where the player is
var SASAssaultVolume			mPreviousPlayerVolume;				// Where the player was
var bool						mFoundFollowPointsForAV;			// Set each time follow points are calculated for an AV
var sSquadPointCache			mFollowPointsForAV;					// Cached follow points for current player AV
var SASAssaultVolume			mAssaultVolume;						// Volume being assaulted
var SASAssaultVolume			mAssaultFromVolume;					// Volume being assaulted from
var sAssaultSquadStatus			mAssaultSquadStatus [2];			// Progress during assault
var float						mPlayerSeparation;					// Maximum separation from player in external volumes
var int							mBackupTimer;						// 
var SASEntryPoint				mPlayerNearestEP;					// EP the player is close to.
var SASEntryPoint				mPlayerPreviousEP;					// Next to last EP the player was near to
var int							mFollowTimer;						// Timer used to update follow mode
var SASMoveTarget				mMoveTarget;						// General purpose move target

//var sHeardNoise					mNoises [MAX_SQUAD_MEMBERS];		// Who heard what and where ?
//var int							mNoiseUpdateTimer;					// Sound update tick

replication
{
	//reliable if ( bNetInitial && ( Role == Role_Authority ) )
	//	mSquadSize;

	reliable if ( bNetDirty && ( Role == Role_Authority ) )
		mNumPlayers,
		mNumAISquadMembers,
		mPlayers,
		mAISquadMembers;
}


//-----------------------------------------------------------------------------
// Native functions


native(790) final function UpdateSquadThreatInfo(
	Actor		aThreat,
	Controller	aDetectedBy );

native(791) final function Actor SelectTarget(
	SASSoldier		aSoldier,
	optional Actor	aIgnored );

///////////////////////////////////////////////////////////////////////////////
// GetClosestPlayerToOther
//
native(792) final function SASSoldier GetClosestPlayerToOther( 
	Actor aOther );


///////////////////////////////////////////////////////////////////////////////
// GetClosestAISquadMemberToOther
//
// Returns the closest squad member to actor aOther by index into the
// mAISquadMembers array. Returns -1 if none available.
native(793) final function int GetClosestAISquadMemberToOther( 
	Actor	aOther );


// Prepare for assault
native(794) final function CheckPrepareAssault();


///////////////////////////////////////////////////////////////////////////////
// UpdateSquadGuardingPoints
//
// Allocate focal points to face for all idle members of the squad.
// Currently allocates entry-points to guard.
native(795) final function UpdateSquadGuardingPoints();


///////////////////////////////////////////////////////////////////////////////
// IsBackupSquadEncroachingEP
//
native(796) final function bool IsBackupSquadEncroachingEP( 
	SASEntryPoint		aTestEP,
	SASAssaultVolume	aAV );


native(797) final function ReconfigureSquadForPlayerAssault();
native(798) final function ReconfigureSquadForBackupAssault();

native(799) final function UpdateBackupPairedAssaultDPs();

native(806) final function bool CheckCanPathThroughBackupAssaultVolume(
	SASSoldier	aRequester );

/*
// Select the next pair of DPs for room assault
native function SelectPairedAssaultDPs(
	SASAssaultVolume		aAssaultVol,
	SASEntryPoint			aAssaultEP,
	Actor					aSoldier1,
	Actor					aSoldier2,
	out	SASDominationPoint	aSelectedDP1,
	out SASDominationPoint	aSelectedDP2 );
*/

//-----------------------------------------------------------------------------
// Exec functions

// Kills all non-player squad members
function KillSquad ()
{
	local int i;

	for ( i = 0; i < mNumAISquadMembers; i++ )
	{
		if ( mAISquadMembers[i] != None)
		{
			mAISquadMembers[i].TakeDamage (10000, none, mAISquadMembers [i].Location, vect (0,0,0), class'Suicided');
		} // if
	} // for
} // KillSquad


//-----------------------------------------------------------------------------
// functions

///////////////////////////////////////////////////////////////////////////////
// PostBeginPlay
//
event PostBeginPlay()
{
	Super.PostBeginPlay();

	mAssaultTimer = AddMultiTimer ();
	mBackupTimer = AddMultiTimer ();
	mStackUpTimer = AddMultiTimer ();
	mMonitorPlayerTimer = AddMultiTimer ();
	mFollowTimer = AddMultiTimer ();
	//mNoiseUpdateTimer = AddMultiTimer ();

	setMultiTimer (mMonitorPlayerTimer, 1.5, true);
	setMultiTimer (mFollowTimer, 0.15, true);
	//setMultiTimer (mNoiseUpdateTimer, 1, true);
}

///////////////////////////////////////////////////////////////////////////////
// multiTimer
//
event multiTimer (int aIndex)
{
	switch (aIndex)
	{
		case mAssaultTimer :
			// ignore
			break;

		case mBackupTimer :
			updateBackupPoints ();
			break;

		case mFollowTimer :
			updateFollowWaitPoints ();
			break;

		//case mNoiseUpdateTimer :
		//	updateNoises ();
		//	break;

		case mMonitorPlayerTimer:
			monitorPlayer ();
			break;

		default :
			super.multiTimer (aIndex);
			break;
	} // switch
} // MultiTimer

///////////////////////////////////////////////////////////////////////////////
//
function string getModeString ()
{
	switch (mBackupSquadMode)
	{
		case BSM_INTERIOR_FOLLOW :
			return "Interior Follow";

		case BSM_INTERIOR_BACKUP :
			return "Interior Backup";

		case BSM_INTERIOR_STACKUP :
			return "Interior Stackup";

		case BSM_INTERIOR_ASSAULT :
			return "Interior Assault";

		case BSM_INTERIOR_GUARD :
			return "Interior Guard";

		case BSM_EXTERIOR :
			return "Exterior / large volume";
	} // switch
} // getModeString

///////////////////////////////////////////////////////////////////////////////
// DisplayDebug
//
simulated function DisplayDebug(
	Canvas		aCanvas, 
	out	float	aYL, 
	out float	aYPos )
{
	local int					i;
	local SASSoldierController	SC;

	aCanvas.SetDrawColor( 255, 255, 255 );

	// Member list

	aCanvas.DrawText( "  SquadMembers:" );
	aYPos += aYL;
	aCanvas.SetPos( 4, aYPos );

	aCanvas.DrawText( "Current State: " $getStateName ()$ " Mode: " $getModeString ());
	aYPos += aYL;
	aCanvas.SetPos( 4, aYPos);

	for ( i = 0; i < mNumAISquadMembers; i++ )
	{
		if ( mAISquadMembers[i] != None && mAISquadMembers[i].Controller != None )
		{
			SC = SASSoldierController( mAISquadMembers[i].Controller );
		}
		else
		{
			SC = None;
		}

		if ( mAISquadMembers[i] == None )
		{
			aCanvas.DrawText( "    AISquadMembers["$i$"] = None" );
		}
		else if ( i == mWingmanIndex )
		{
			aCanvas.DrawText( "    AISquadMembers["$i$"] = "$mAISquadMembers[i]$" (Wingman)" );
		}
		else
		{
			aCanvas.DrawText( "    AISquadMembers["$i$"] = "$mAISquadMembers[i] );
		}

		aYPos += aYL;
		aCanvas.SetPos( 4, aYPos );

		if ( SC != None )
		{
			if ( SC.mDominationPoint != None )
			{
				aCanvas.DrawText( "    State: "$SC.GetStateName()$"  DP: "$SC.mDominationPoint );
			}
			else
			{
				aCanvas.DrawText( "    State: "$SC.GetStateName()$"  No DP owned " );
			}
		}

		aYPos += aYL;
		aCanvas.SetPos( 4, aYPos );
	}

	// Squad threat list

	aCanvas.DrawText( "  Squad Threats:" );
	aYPos += aYL;
	aCanvas.SetPos( 4, aYPos );

	for ( i = 0; i < mNumSquadThreats; ++i)
	{
		aCanvas.DrawText( "    Threat["$i$"]="$mSquadThreats[i].mTarget );
		aYPos += aYL;
		aCanvas.SetPos( 4, aYPos );	
	}
}


///////////////////////////////////////////////////////////////////////////////
// AddPlayerMember
//
// Add a human player to the squad.
function AddPlayerMember( 
	SASSoldier	aNewPlayer )
{
	local int i;

	if ( Level.Netmode == NM_Standalone && mNumPlayers != 0 )
	{
		Warn( "Attempting to add player to SASSquadManager when one is already assigned." );
		return;
	}

	if ( aNewPlayer == None )
	{
		return;
	}

	if ( mNumPlayers >= MAX_SQUAD_MEMBERS )
	{
		return;
	}

	for ( i = 0; i < mNumPlayers; i++ )
	{
		if ( mPlayers[i] == aNewPlayer )
		{
			Warn( "Attempting to add player to SASSquadManager when already assigned." );
			return;
		}
	}

	mPlayers[mNumPlayers]			= aNewPlayer;
	mPlayers[mNumPlayers].mSquadIdx = mNumPlayers;

	mNumPlayers++;
}


///////////////////////////////////////////////////////////////////////////////
// PlayerDied
//
function PlayerDied(
	SASSoldier	aDeadPlayer )
{
	//if ( aDeadPlayer != None )
	//{
	//	Warn( "Attempting to remove player from SASSquadManager in a single player game." );
	//}
}

///////////////////////////////////////////////////////////////////////////////
//
// SetDefaultSquadMode
//
// Return squad to interior follow or large volume mode as appropriate
event SetDefaultSquadMode ()
{
	if (mPlayerVolume.mLargeVolume == true)
	{
		mFollowPointsForAV.mFoundForThisAV = false;
		mBackupSquadMode = BSM_EXTERIOR;
	} // if
	else
	{
		mFollowPointsForAV.mFoundForThisAV = false;
		mBackupSquadMode = BSM_INTERIOR_FOLLOW;
	} // else

	mAssaultEP = None;
	mAssaultVolume = None;
} // setDefaultSquadMode


///////////////////////////////////////////////////////////////////////////////
// notifyDoorDestroyed
//
// Called whenever a door is destroyed. Stub version, real version is in roomassault state
event notifyDoorDestroyed (SASDoorMover door);


///////////////////////////////////////////////////////////////////////////////
// PlayerNearEP
//
function PlayerNearEP(
	SASEntryPoint aNewEP )
{
	if ( aNewEP != None )
	{
		// Player moved from one EP to another.
		if ( (mPlayerNearestEP != None) && (aNewEP != mPlayerNearestEP) )
		{
			mPlayerPreviousEP = mPlayerNearestEP;
			mPlayerNearestEP = aNewEP;		// This _must_ be set before ReconfigureSquadForRoomAssault is called.
			ReconfigureSquadForPlayerAssault();
		} 
		// Player moved to new EP.
		else if ( mPlayerNearestEP == None )
		{
			mPlayerNearestEP = aNewEP;		// This _must_ be set before ReconfigureSquadForRoomAssault is called.
			ReconfigureSquadForPlayerAssault();
		}
	}
	else
	{
		// Player moved away from EP.
		if (mPlayerNearestEP != None)
		{
			mPlayerPreviousEP = mPlayerNearestEP;
			mPlayerNearestEP = None;
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
//
// Monitor the relative position of the player and squad, determining if we should
// reallocate a new wingman
//::function updateWingmanAssignment ()
//::{
//::	local int closest;
//::	local Vector stackupLocation;
//::
//::	// Don't do this in co-op mode (ie players > 1) or if we've lost all our live squad members
//::	if (mNumPlayers > 1 || mNumAISquadMembers == 0)
//::	{
//::		stopMultiTimer (mMonitorPlayerTimer);
//::		return;
//::	} // if
//::
//::	// Don't do this if the backup squad are in an action mode
//::	if (mBackupSquadMode == BSM_INTERIOR_STACKUP ||
//::		mBackupSquadMode == BSM_INTERIOR_ASSAULT)
//::	{
//::		return;
//::	} // if
//::
//::	// Don't do this if existing wingman is stacked up
//::	if (SASSoldierController (mAISquadMembers [mWingmanIndex].Controller).mStackupMode != SASSTACK_None)
//::	{
//::		return;
//::	} // if
//::
//::	// Don't do this if existing wingman is assaulting a volume
//::	if (SASSoldierController (mAISquadMembers [mWingmanIndex].Controller).mWingmanAssaultVolume != None)
//::	{
//::		return;
//::	} // if
//::
//::	// Don't do this if the player isn't near an EP (indoors, at any rate)
//::	if (mBackupSquadMode != BSM_EXTERIOR && (mPlayerNearestEP == None) )
//::	{
//::		return;
//::	} // if
//::
//::	// Don't do this if we're outdoors and wingman is reasonably close to player
//::	if (mBackupSquadMode == BSM_EXTERIOR && VSizeSq (mPlayers [0].Location - mAISquadMembers [mWingmanIndex].Location) < Square (Metres (5)))
//::	{
//::		return;
//::	} // if
//::
//::	//// Make sure player has moved since we last did this
//::	//if (VSizeSq (mPlayers [0].Location - mLastPlayerMonitorPosition) < Metres (0.25))
//::	//{
//::	//	return;
//::	//} // if
//::
//::	// Right, look to see who's closest to the player and allocate him as wingman
//::	//closest = -1;
//::	//for (i = 0; i < mNumAISquadMembers; i++)
//::	//{
//::	//	if (mAISquadMembers [i] != None &&
//::	//		!mAISquadMembers [i].isDead () &&
//::	//		!mAISquadMembers [i].mbIsIncapacitated)
//::	//	{
//::	//		dist = VSizeSq (mAISquadMembers [i].Location - mPlayers [0].Location);
//::
//::	//		// If not in this assault volume, add big bias
//::	//		if (mAISquadMembers [i].getAssaultVolume () != mPlayerVolume)
//::	//		{
//::	//			dist += Square (Metres (10));
//::	//		} // if
//::
//::	//		if (closest == -1 || dist < closestDist)
//::	//		{
//::	//			closest = i;
//::	//			closestDist = dist;
//::	//		} // if
//::	//	} // if
//::	//} // for
//::
//::	if ( (mPlayerNearestEP != None) && mPlayerNearestEP.hasValidStackUp ())
//::	{
//::		if (mPlayerNearestEP.mAssaultVolLinks [0] == mPlayerVolume)
//::		{
//::			stackupLocation = mPlayerNearestEP.mStackupParams [0].Positions [0];
//::		} // if
//::		else if (mPlayerNearestEP.mAssaultVolLinks [1] == mPlayerVolume)
//::		{
//::			stackupLocation = mPlayerNearestEP.mStackupParams [1].Positions [0];
//::		} // else
//::
//::		closest = selectBestWingman (stackupLocation);
//::	} // if
//::	else
//::	{
//::		closest = selectBestWingman ();
//::	} // else
//::
//::	// Only switch if wingman isn't same as current
//::	if (closest != -1 && closest != mWingmanIndex)
//::	{
//::		// We can only reassign the wingman if the new guy is currently not attacking a target
//::		if (mAISquadMembers [closest].Controller.isInState ('Attacking'))
//::		{
//::			return;
//::		} // if
//::
//::		// Remove our existing wingman
//::		UnallocateWingman (mPlayers [0]);
//::
//::		// Assign the new one and note in our array
//::		SASSoldierController (mAISquadMembers [closest].Controller).AssignWingman ();
//::		mWingmanIndex = closest;
//::
//::		// Wingman needs to be explicitly told where to go to
//::		SASSoldierController (mAISquadMembers [closest].Controller).mPlayerTracker.SetLocation (stackupLocation);
//::
//::		// Reset squad to default mode
//::		SetDefaultSquadMode ();
//::
//::		// Update last position
//::		mLastPlayerMonitorPosition = mPlayers [0].Location;
//::	} // if
//::} // updateWingmanAssignment

///////////////////////////////////////////////////////////////////////////////
//
// selectBestWingman
function int selectBestWingman (optional Vector allocationLocation)
{
	if (mMoveTarget == None)
	{
		mMoveTarget = Spawn (class'SASMoveTarget');
	} // if

	if (allocationLocation == Vect (0, 0, 0))
	{
		mMoveTarget.SetLocation (mPlayers [0].Location);
	} // if
	else
	{
		mMoveTarget.SetLocation (allocationLocation);
	} // else

	return GetClosestAISquadMemberToOther (mMoveTarget);
} // selectBestWingman



///////////////////////////////////////////////////////////////////////////////
//
// Moved from player controller so that all squad members can access it
exec function ClearedRoom (SASSoldier caller)
{
	local SASGRI			gri;
	local SASGameInfo		gi;
	local SASAssaultVolume	av;

	av = caller.GetAssaultVolume ();
	if ( av != None )
	{
		gri = SASGRI (Level.Game.GameReplicationInfo);
		if (gri != None)
		{
			gri.VolumeCleared (av);
		} // if

		gi = SASGameInfo (Level.Game);
		if (gi != None)
		{
			gi.VolumeCleared (av);
		} // if
	}
	else
	{
		LogHuman (caller$ " can't find assault volume at " $caller.Location);
	} // else
}
///////////////////////////////////////////////////////////////////////////////
// GrenadeExploded
//
// Detect grenade explosion
event GrenadeStartedExploding (SASGrenadeProjectile exploder)
{
	// If this grenade belonged to the player and we were waiting for it, note it
	if (mbPauseForGrenade && exploder.Instigator != None && (exploder.Instigator == mPlayers [0] || exploder.Instigator == mPlayers [1]))
	{
		mbGrenadeThrown = true;
	} // if
} // GrenadeStartedExploding


///////////////////////////////////////////////////////////////////////////////
// AddSquadMember
//
// Add an AI soldier to the squad.
function AddAISquadMember( 
	SASSoldier		aNewAIMember )
{
	local int i;

	if ( mNumAISquadMembers >= MAX_SQUAD_MEMBERS )
	{
		Warn( "Attempting to add squad member to SASSquadManager when all positions filled." );
		return;
	}

	// Check if this soldier is already in list.
	for ( i = 0; i < mNumAISquadMembers; i++ )
	{
		if ( mAISquadMembers[i] == aNewAIMember )
		{
			Warn( "Attempting to add AI soldier "$aNewAIMember$" to SASSquadManager more than once." );
			return;
		}
	}

	mAISquadMembers[mNumAISquadMembers]				= aNewAIMember;
	mAISquadMembers[mNumAISquadMembers].mSquadIdx	= mNumAISquadMembers;

	mNumAISquadMembers++;
}


///////////////////////////////////////////////////////////////////////////////
// AISquadMemberDied
//
function AISquadMemberDied( 
	SASSoldier aDeadSoldier )
{
	local int i;

	if ( aDeadSoldier == None )
	{
		return;
	}

	// If this soldier is the wingman, unassign it.
	if ( (mWingmanIndex != -1) && (aDeadSoldier == mAISquadMembers[mWingmanIndex]) )
	{
		mWingmanIndex = -1;
	}

	// Check if this soldier is in the list.
	for ( i = 0; i < mNumAISquadMembers; i++ )
	{
		if ( mAISquadMembers[i] == aDeadSoldier )
		{
			// Set ptr to None but don't decrement squad size - HUD treats None entries as 
			// dead soldiers.
			mAISquadMembers[i] = None;
			mAssignedHostages [i] = None;
			break;
		}
	}

	// If we're in the middle of a room assault, abandon and go to default backup mode
	if (mBackupSquadMode == BSM_INTERIOR_STACKUP ||
		mBackupSquadMode == BSM_INTERIOR_ASSAULT ||
		mBackupSquadMode == BSM_INTERIOR_GUARD)
	{
		abandonRoomAssault ();
	} // if
} // AISquadMemberDied


///////////////////////////////////////////////////////////////////////////////
// AISquadMemberIncapacitated
//
function AISquadMemberIncapacitated(
	SASSoldier	aIncapSoldier )
{
	local int i;

	if ( aIncapSoldier == None )
	{
		return;
	}

	// If this soldier is the wingman, unassign it.
	if ( (mWingmanIndex != -1) && (aIncapSoldier == mAISquadMembers[mWingmanIndex]) )
	{
		mWingmanIndex = -1;
		mAssignedHostages [i] = None;
	}

	// If we're in the middle of a room assault, abandon and go to default backup mode
	if (mBackupSquadMode == BSM_INTERIOR_STACKUP ||
		mBackupSquadMode == BSM_INTERIOR_ASSAULT ||
		mBackupSquadMode == BSM_INTERIOR_GUARD)
	{
		abandonRoomAssault ();
	} // if
}



///////////////////////////////////////////////////////////////////////////////
// GetWingmansPlayer
//
// Returns the player pawn which wingman 'aWingman' is assigned to. If not assigned
// as a wingman then returns None.
event SASSoldier GetWingmansPlayer( 
	SASSoldier aWingman )
{
	if ( aWingman == None )
	{
		return None;
	}

	// Check passed in wingman really is the wingman.
	if ( mWingmanIndex == -1 || mAISquadMembers[mWingmanIndex] != aWingman )
	{
		return None;
	}

	return mPlayers[0];
}


///////////////////////////////////////////////////////////////////////////////
// GetPlayersWingmanIdx
//
// Returns the wingman allocated to this player if any. If it doenst have one
// then returns None. 
simulated function SASSoldier GetPlayersWingman( 
	SASSoldier aPlayerPawn )
{
	if (	(aPlayerPawn == None) || 
			(aPlayerPawn != mPlayers[0]) ||
			(mWingmanIndex == -1) )
	{
		return None;
	}

	return mAISquadMembers[mWingmanIndex];
}


///////////////////////////////////////////////////////////////////////////////
// GetPlayerSlotIdx
//
// Returns the index in the mPlayers array for player 'aPlayerPawn'.
// Returns -1 if pawn is not in the players array.
simulated function int GetPlayerSlotIdx( 
	SASSoldier	aPlayerPawn )
{
	local int i;

	if ( aPlayerPawn == None )
	{
		return -1;
	}

	for ( i = 0; i < mNumPlayers; ++i )
	{
		if ( mPlayers[i] == aPlayerPawn )
		{
			return i;
		}
	}

	// Not found in the mPlayers array.
	return -1;
}


///////////////////////////////////////////////////////////////////////////////
// GetNumLiveSquadMembers
//
// Count the number of squad members still active (alive, not incapacitated)
function int GetNumLiveSquadMembers ()
{
	local int i;
	local int count;

	count = 0;

	for (i = 0; i < mNumPlayers; i++)
	{
		if (mPlayers [i] != None &&
			mPlayers [i].IsDead () == false &&
			mPlayers [i].mbIsIncapacitated == false)
		{
			count++;
		} // if
	} // for

	for (i = 0; i < mNumAISquadMembers; i++)
	{
		if (mAISquadMembers [i] != None &&
			mAISquadMembers [i].IsDead () == false &&
			mAISquadMembers [i].mbIsIncapacitated == false)
		{
			count++;
		} // if
	} // for

	return count;
} // GetNumLiveSquadMembers


///////////////////////////////////////////////////////////////////////////////
// InitSquad
//
// On StartMatch event, setup the other squad members.
function InitSquad()
{
	local SASSpawnPoint			sp;
	local Array<SASSpawnPoint>	spList;
	local int					i;
	local int					AIMembersNeeded;

	if ( DisableAI() )
	{
		return;
	}

	// How many AI members needed?
	AIMembersNeeded = MAX_SQUAD_MEMBERS - mNumPlayers;	// Make up the numbers with bots.

	// Find enough relevent spawn points for AI squad members.
	foreach AllActors ( class'SASSpawnPoint', sp )
	{
		if ( sp.bEnabled && sp.bCoopStart && !sp.IsOccupied () &&
			( sp.TeamNumber == mSquadId ) && ( sp.mSpawnPawnClass != None ) )
		{
			spList[spList.Length] = sp;
			if ( spList.Length == AIMembersNeeded )
			{
				break;
			}
		}
	}

	if ( spList.Length != AIMembersNeeded )
	{
		warn ( "Not enough spawn points (" $AIMembersNeeded$") found for squad! There will only be " $i $" AI squad members." );
	}

	// spawn the squaddies
	for ( i = 0; i < spList.Length; i++ )
	{
		SpawnAISquadMember( spList[i] );
	}
}


///////////////////////////////////////////////////////////////////////////////
// SpawnAISquadMember
//
// Spawn a new soldier at a specified spawn point. Soldier will add itself back
// into the squad.
// GPTODO: Would be perferable to do the squad joining bit here too.
function SpawnAISquadMember( 
	SASSpawnPoint aSpawnPoint )
{
	local SASPawn			p;
	local SASAIController	c;

	// Spawn new soldier at spawn point.
	p = SASPawn(Spawn( aSpawnPoint.mSpawnPawnClass,,, aSpawnPoint.Location, aSpawnPoint.Rotation ));

	// Copy AI scripts from the spawn point to the AI soldier.
	p.InitPawnScripts( aSpawnPoint.mScriptTriggers );

	// Create a controller for the soldier.
	c = SASAIController ( Spawn ( p.ControllerClass ) );
	c.Possess ( p );
	p.SetOwner ( c );

	c.ChangeTeam ( mSquadID, false );
	p.AddDefaultInventory ();
	p.SelectWeapon ( WPNCAT_Primary );
    Level.Game.ChangeName ( c, "Squaddie", true );
}


///////////////////////////////////////////////////////////////////////////////
// GetAISquadMemberByIdx
//
// Returns the AI soldier pawn at index aMemberIdx in the AI squad members array.
simulated function SASSoldier GetAISquadMemberByIdx( 
	int aMemberIdx )
{
	if ( aMemberIdx < 0 || aMemberIdx > mNumAISquadMembers )
	{
		return None;
	}
	return mAISquadMembers[aMemberIdx];
}


///////////////////////////////////////////////////////////////////////////////
// CanAllocateWingman
//
simulated function bool CanAllocateWingman (SASSoldier player)
{
	local int i;
	local bool validAV;
	local SASAssaultVolume playerAV;

	// If we're room assaulting, no can do
	if ((isInState ('RoomAssaultState') && mBackupSquadMode != BSM_INTERIOR_GUARD) ||
		isInState ('StackupState'))
	{
		return false;
	} // if

	// If we've finished a room assault, a wingman will be allocated if :
	//
	// the player is outside our AV and nears an EP not connected to this one
	// - or -
	// the player is inside our AV and and approaches and EP other than the last one he was close to
	if (isInState ('RoomAssaultState') && mBackupSquadMode == BSM_INTERIOR_GUARD)
	{
		// Can't be triggered if player isn't near to EP
		if ( mPlayerNearestEP == None )
		{
			return false;
		} // if
	
		playerAV = player.getAssaultVolume ();

		// If player isn't in this volume, Valid if player is near an EP that doesn't lead to this room (ie
		// he isn't just about to enter)
		if (playerAV != mAssaultVolume)
		{
			if (mPlayerNearestEP.IsLinkedToAssaultVolume (mAssaultVolume) == false)
			{
				validAV = true;
			} // if
		} // if

		// If he's in this room, valid if he's about to leave it again
		else
		{
			if (mPlayerNearestEP.IsLinkedToAssaultVolume (mAssaultVolume) == true &&
				mPlayerPreviousEP != None && mPlayerPreviousEP.IsLinkedToAssaultVolume (mAssaultVolume) == true)
			{
				validAV = true;
			} // if
		} // if

		if (validAV == false)
		{
			return false;
		} // if
	} // if

	// GPTODO: Surely this needs to check for AI squad members which are not already
	// wingmen.
	// KW: this is called when the assumption is that we don't have a wingman already,
	// therefore there aren't any assigned. However, the use of 'mNumAISquadMembers'
	// has changed so we must ascertain the number of living AI's first.
	// AF : look for non-dead, non-incapacitated squad member
	for ( i = 0; i < mNumAISquadMembers; i++ )
	{
		if (mAISquadMembers[i] != None &&
			mAISquadMembers[i].isDead () == false &&
			mAISquadMembers[i].mbIsIncapacitated == false)
		{
			return true;
		} // if
	} // for

	return false;
} // CanAllocateWingman


///////////////////////////////////////////////////////////////////////////////
// AllocateWingman
//
function AllocateWingman( 
	SASSoldier		aPlayerToAllocateTo )
{
	local int					AIMemberIdx;
	local SASSoldierController	SC;

	if (	(aPlayerToAllocateTo == None) ||
			(aPlayerToAllocateTo != mPlayers[0]) )
	{
		return;
	}

	// Do we already have a wingman?
	if ( mWingmanIndex != -1 )
	{
		return;
	}

	// Get closest non-wingman AI squad member to this player or allocation position
	AIMemberIdx = selectBestWingman();

	// Assign him.
	if ( AIMemberIdx != -1 )
	{
		SC = SASSoldierController( mAISquadMembers[AIMemberIdx].Controller );
		if ( SC != None )
		{
			SC.AssignWingman();
			mWingmanIndex = AIMemberIdx;
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// UnallocateWingman
//
event UnallocateWingman( 
	SASSoldier	aPlayerToUnallocFrom )
{
	local SASSoldierController	SC;

	if (	(aPlayerToUnallocFrom == None) ||
			(aPlayerToUnallocFrom != mPlayers[0]) )
	{
		return;
	}

	// Does player have a wingman to unallocate?
	if ( mWingmanIndex == -1  )
	{
		return;
	}

	SC = SASSoldierController( mAISquadMembers[mWingmanIndex].Controller );
	if ( SC != None )
	{
		SC.UnassignWingman();
	}
	
	mWingmanIndex = -1;
}


///////////////////////////////////////////////////////////////////////////////
// GetRandomSquadMember
//
// Returns a random squad member, including the player.
function SASSoldier GetRandomSquadMember()
{
	local int			i, randIdx;
	local SASSoldier	p, chosenSoldier;
	local int			numLivingPlayers;
	local int			numLivingAIs;
	local int			numTotalLiving;
	
	// Count living players.
	for ( i = 0; i < mNumPlayers; i++ )
	{
		p = mPlayers[i];
		if ( (p != None) && p.IsAlive() && !p.mbIsIncapacitated )
		{
			numLivingPlayers++;
		}
	}

	// Count living AIs.
	for ( i = 0; i < mNumAISquadMembers; i++ )
	{
		p = mAISquadMembers[i];
		if ( (p != None) && p.IsAlive() && !p.mbIsIncapacitated )
		{
			numLivingAIs++;
		}
	}

	numTotalLiving = numLivingPlayers + numLivingAIs;
	if ( numTotalLiving > 0 )
	{
		randIdx = Rand( numTotalLiving ); 

		if ( randIdx < numLivingPlayers )
		{
			// Go through player members array again to find the correct one.
			for ( i = 0; i < mNumPlayers; i++ )
			{
				p = mPlayers[i];
				if ( (p != None) && p.IsAlive() && !p.mbIsIncapacitated )
				{
					randIdx--;
					if ( randIdx < 0 )
					{
						chosenSoldier = p;
						break;
					}
				}
			}
		}
		else
		{
			randIdx -= numLivingPlayers;
			
			// Go through AI members array again to find the correct one.
			for ( i = 0; i < mNumAISquadMembers; i++ )
			{
				p = mAISquadMembers[i];
				if ( (p != None) && p.IsAlive() && !p.mbIsIncapacitated )
				{
					randIdx--;
					if ( randIdx < 0 )
					{
						chosenSoldier = p;
						break;
					}
				}
			}
		}
	}

	return chosenSoldier;
}


///////////////////////////////////////////////////////////////////////////////
// ReportXRaySighting
//
event ReportXRaySighting( 
	Controller	aSASMember, 
	Vector		aXRayLocation )
{
	local int	pointRelation;
	local		PlayerController PC;
	local SASSoldier soldier;

	// Only report if this is the first sighting and we have at least one live squad member remaining besides us
	if (mNumSquadThreats > 1 || GetNumLiveSquadMembers () < 2)
	{
		return;
	} // if

	PC = Level.GetLocalPlayerController();
	soldier = SASSoldier (aSASMember.Pawn);
	if ( PC != None && PC.Pawn != None)
	{
		// Only play if soldier isn't incapacitated or dead (pretty obvious, really ...)
		if (soldier.IsDead () == false && soldier.mbIsIncapacitated == false)
		{
			pointRelation = PointActorRelation( aXRayLocation, PC.Pawn );
			if ( (pointRelation & POINTREL_ActorRightOfPoint) != 0 )
			{
				// xrays to left of me
				soldier.PlaySpeech (SPEECH_SquadContactLeft);
			}
			else if ( (pointRelation & POINTREL_ActorLeftOfPoint) != 0 )
			{
				// xrays to right 
				soldier.PlaySpeech (SPEECH_SquadContactRight);
			}
			else if ( (pointRelation & POINTREL_ActorBehindPoint) != 0 )
			{
				// here i come
				soldier.PlaySpeech (SPEECH_SquadContactFront);
			}
			else if ( (pointRelation & POINTREL_ActorInFrontOfPoint) != 0 )
			{
				// here i come
				soldier.PlaySpeech (SPEECH_SquadContactRear);
			}
			else
			{
				soldier.PlaySpeech (SPEECH_SquadContact);
			} // else
		} // if
	} // if
}


///////////////////////////////////////////////////////////////////////////////
// hostagesFollowingPlayer
//
// Returns TRUE if any hostages are following the player
function bool hostagesFollowingPlayer ()
{
	local Controller	C;

	for ( C = Level.ControllerList; C != None; C = C.nextController )
	{
		if ( C.mType == CONTROLLER_AIHostage && C.Pawn != None )
		{
			if ( SASHostage( C.Pawn).mbIsFollowing )
			{
				return true;
			}
		}
	}

	return false;
} // hostagesFollowingPlayer

///////////////////////////////////////////////////////////////////////////////
// getAssignedHostage
//
// See if there is a hostage assigned to be watched by this soldier
function SASHostage getAssignedHostage (SASSoldier soldier)
{
	local int		i, idx;
	local SASHostage hostage;
	local bool use;
	local SASGameInfo	gi;

	for (i = 0; i < MAX_SQUAD_MEMBERS; i++)
	{
		if (soldier == mAISquadMembers [i])
		{
			hostage = mAssignedHostages [i];
			if ( hostage != None )
			{
				if (hostage.isDead () == false &&
					hostage.mbIsIncapacitated == false &&
					hostage.mbCaptured == false &&
					VSizeSq (soldier.Location - mAssignedHostages [i].Location) < Square (500.0))
				{
					return hostage;
				} // if
				else
				{
					mAssignedHostages [i] = None;
				} // else
			} // if

			idx = i;
			break;
		} // if
	} // if

	// If we haven't found a hostage assigned to this soldier, look for one.
	gi = SASGameInfo( Level.Game );
	foreach gi.RadiusSASPawns( class'SASHostage', hostage, soldier.Location, 500.0 )
	{
		use = true;

		// Pawn must be alive and kicking and unspoilt
		if (hostage.isDead () == true || hostage.mbIsIncapacitated == true || hostage.mbCaptured)
		{
			use = false;
		} // if

		if (use)
		{
			// Ensure hostage isn't assigned to anyone else
			for (i = 0; i < MAX_SQUAD_MEMBERS; i++)
			{
				if (hostage == mAssignedHostages [i])
				{
					use = false;
				} // if
			} // for

			if (use)
			{
				// Pawn must be visible to this soldier
				if (soldier.pawnIsVisible (hostage))
				{
					mAssignedHostages [idx] = hostage;
					return hostage;
				} // if
			} // if
		} // if
	} // foreach

	return None;
} // getAssignedHostage

///////////////////////////////////////////////////////////////////////////////
function bool getSquadShoutPermission ()
{
	local SASGRI gri;

	gri = SASGRI (Level.Game.GameReplicationInfo);

	if (gri.GetLevelTimer(0) - mLastSquadShout > mSquadShoutInterval)
	{
		mLastSquadShout = gri.GetLevelTimer(0);
		return true;
	} // if
	else
	{
		return false;
	} // else
} // getSquadShoutPermission

///////////////////////////////////////////////////////////////////////////////
function playerShoutAtHostage ()
{
	mLastSquadShout = GetLevelTime();
} // playerShoutAtHostage



///////////////////////////////////////////////////////////////////////////////
// SoldierIsPartOfRoomAssault
//
// function overriden in RoomAssaultState states.
function eRoomAssaultRole SoldierIsPartOfRoomAssault (
	SASSoldier	aSoldier )
{
	return ROOMASS_NONE;
}

///////////////////////////////////////////////////////////////////////////////
// getAssaultTrooperStatus
//
// function overriden in RoomAssaultState states.
function ESASAssaultTeamStatus getAssaultTrooperStatus (
	SASSoldier	aSoldier )
{
		return ATSTATUS_UNKNOWN;
} // getAssaultTrooperStatus

///////////////////////////////////////////////////////////////////////////////
//
// function overriden in RoomAssaultState states.
function float GoGoGoSent (
	SASSoldier	aSoldier )
{
	return 0;
} // getAssaultTrooperStatus

///////////////////////////////////////////////////////////////////////////////
// GetStackUpSlotFor
//
// Returns stacking up slot index allocated to 'aSoldier'. If none allocated 
// then returns STACKUPSLOT_Empty.
function int GetStackUpSlotFor(
	SASSoldier	aSoldier )
{
	local int slot;

	for ( slot = 0; slot < MAX_SQUAD_MEMBERS; ++slot )
	{
		if ( mStackUpOrder[slot] >= 0 )
		{
			if ( mAISquadMembers[mStackUpOrder[slot]] == aSoldier )
			{
				return slot;
			}
		}
	}

	return STACKUPSLOT_Empty;
}


///////////////////////////////////////////////////////////////////////////////
// GetStackUpLocation
//
// Get location for soldier 'aSoldier' to stack up at. Location passed out as parameter.
// Returns false if soldier does not have a stackup slot alloced.
function bool GetStackUpLocation( 
	SASSoldier	aSoldier,
	out Vector	aStackUpLoc )
{
	local int slot;

	aStackUpLoc = Vect(0,0,0);

	if ( mAssaultEP != None )
	{
		slot = GetStackUpSlotFor( aSoldier );
		if ( slot != STACKUPSLOT_Empty )
		{
			return mAssaultEP.GetStackUpLocation( 
						mAssaultEPStackUpSide, 
						slot, 
						aStackUpLoc );
		}	
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// GetStackUpRotation
//
// Get rotation for soldier 'aSoldier' to face when stacked up. Rotation 
// passed out as parameter.
// Returns false if soldier does not have a stackup slot alloced.
function bool GetStackUpRotation( 
	SASSoldier		aSoldier,
	out Rotator		aStackUpRot )
{
	local int slot;

	aStackUpRot = Rot(0,0,0);

	if ( mAssaultEP != None )
	{
		slot = GetStackUpSlotFor( aSoldier );
		if ( slot != STACKUPSLOT_Empty )
		{
			return mAssaultEP.GetStackUpRotation( 
						mAssaultEPStackUpSide, 
						slot, 
						aStackUpRot );
		}
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// SquadMemberChangedAssaultVolumes
//
// Called when a squad member changes AV (and monitoring AV changes is turned 
// on for this squad member).
function SquadMemberChangedAssaultVolumes(
	SASSoldier			aSoldier,
	SASAssaultVolume	aSoldiersPrevAV )
{
	mHostageShoutDownMax = Default.mHostageShoutDownMax;

	// Reset follow mode points
	mFollowPointsForAV.mFoundForThisAV = false;
} 

///////////////////////////////////////////////////////////////////////////////
//
// SquadCanSeePawn
//
// Returns the first AI member of the squad who can see the supplied pawn (uses fast
// trace from eye position to eye position so may not be super accurate)
//
// Will still work if supplied with a squad member as a parameter (just ignores
// that soldier in testing)
//
// Optional parameter can be used to exclude a particular squad member
function SASSoldier SquadCanSeePawn (Pawn P, optional SASSoldier exclude)
{
	local int i;

	if (P == None)
	{
		return None;
	} // if

	// Go through the members of the squad and work out if any can see the target pawn
	// Viewer must be alive and not incapacitated
	for (i = 0; i < MAX_SQUAD_MEMBERS; i++)
	{
		if (mAISquadMembers [i] != None &&
			mAISquadMembers [i] != exclude &&
			mAISquadMembers [i] != SASSoldier (P) &&
			mAISquadMembers [i].isDead () == false &&
			mAISquadMembers [i].mbIsIncapacitated == false)
		{
			if (mAISquadMembers [i].PawnIsVisible (P))
			{
				return mAISquadMembers [i];
			} // if
		} // if
	} // for

	// Can player(s) see P ?
	for (i = 0; i < MAX_SQUAD_MEMBERS; i++)
	{
		if (mPlayers [i] != None &&
			mPlayers [i] != exclude &&
			mPlayers [i] != SASSoldier (P) &&
			mPlayers [i].isDead () == false &&
			mPlayers [i].mbIsIncapacitated == false)
		{
			if (mPlayers [i].PawnIsVisible (P))
			{
				return mPlayers [i];
			} // if
		} // if
	} // for

	// If we get this far, no-one has seen our target
	return None;
} // SquadCanSeePawn


//-----------------------------------------------------------------------------
// States

function updateStackUpPoints ();
function startRoomAssault ();
function CheckSwapBackupAssaultOrder();
function bool checkAssaultStatus ();


/////////////////////////////////////////////////////////////////////////////////////
// New backup squad state and functions
/////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
function bool playerBlockingAssaultEP (SASEntryPoint EP, SASAssaultVolume AV, bool breach)
{
	local SASSoldier player;
	local int side;

	player = mPlayers [0];

	// Player within assault radius
	//if (VSizeHorizSq (player.Location - EP.Location) < Square (EP.mAssaultRadius))
	//{
	//	return true;
	//} // if

	if (EP.mAssaultVolLinks [0] == AV)
	{
		side = 0;
	} // if
	else
	{
		side = 1;
	} // else

	// Player blocking either stack up ?
	if (VSizeHorizSq (player.Location - EP.mStackUpParams [side].Positions [0]) < Square (24))
	{
		return true;
	} // if
	if (VSizeHorizSq (player.Location - EP.mStackUpParams [side].Positions [1]) < Square (24))
	{
		return true;
	} // if

	// Player blocking 
	if (breach && VSizeHorizSq (player.Location - EP.mBreachPosition [side]) < Square (24))
	{
		return true;
	} // if

	return false;
} // playerBlockingAssaultEP

///////////////////////////////////////////////////////////////////////////////
// STATE StackupState
//
// Base state for other room assault states.

// Initiate a door assault
function reachedGoal (SASSoldier soldier);
function failedGoal (SASSoldier soldier);
function requestNextAction (SASSoldier soldier);
function goAcknowledge (SASSoldier soldier);

function DoRoomAssault(
	SASEntryPoint	aNewAssaultEP,			// EP to assault through.
	bool			abBreach,					// Does door need to be breached with shotgun ?
	bool			abPauseForGrenade )		// Do we pause for a grenade ?
{
	local bool			bUseWingmanInAssault;
	local int			i, 
						idx[2],
						numLiveMembers;
	local SASSoldier	tempSoldier;

	if ( aNewAssaultEP == None )
	{
		return;
	}

	if (mNumPlayers > 1)
	{
		LogHuman ("Door assault not permitted in co-op mode");
		return;	
	}

	// If we already have an assault on this door on the go, ignore (ie don't reset everyone to start again)
	if (	(mAssaultEP == aNewAssaultEP) &&
			(	(mBackupSquadMode == BSM_INTERIOR_STACKUP) ||
				(mBackupSquadMode == BSM_INTERIOR_ASSAULT) ) )
	{
		return;
	} 

	// If squad are assaulting another door then abandon that assault.
	if (	(	(mBackupSquadMode == BSM_INTERIOR_STACKUP) ||
				(mBackupSquadMode == BSM_INTERIOR_ASSAULT)	) &&
			(mAssaultEP != aNewAssaultEP) &&
			(mAssaultEP != None) )		
	{
		AbandonRoomAssault();
	}

	// Assign new EP.
	mAssaultEP = aNewAssaultEP;
	
	// Does the assault EP belong to a door? (If we are not breaching a door then
	// it no longer matters if it doesn't - can now assault door-less EPs).
	if ( mAssaultEP.MyDoor != None )
	{
		mAssaultDoor = SASDoorMover( mAssaultEP.MyDoor );
	}

	if ( (mAssaultDoor == None) && abBreach )
	{	
		LogHuman( "Told to breach a door-less EP" );
		return;
	}

	mbPauseforGrenade = abPauseForGrenade;
	mbGrenadeThrown = false;

	numLiveMembers = GetNumLiveSquadMembers();

	// Can't assault with less than 3 live squaddies (including player).
	if ( numLiveMembers < 3 )
	{
		return;
	}
	// If only 3 (2 AI) then use wingman as second assault squad member.
	else if ( numLiveMembers == 3 )
	{
		bUseWingmanInAssault = true;
	}
	else
	{
		bUseWingmanInAssault = false;
	} 

	// This handy function finds the AV we're assaulting and decides which side to assault
	CheckPrepareAssault();

	// If player is blocking any of the room assault positions, abandon and audibly warn the player
	if ( PlayerBlockingAssaultEP( mAssaultEP, mAssaultFromVolume, abBreach ) )
	{
		tempSoldier = GetRandomSquadMember();
		if ( tempSoldier != None )
		{
			tempSoldier.PlaySpeech( SPEECH_SquadAvoid );
		} 
		AbandonRoomAssault();
		return;
	}

	// Decide who does what.
	// If this is a door breaching exercise, look first for the guy with the shotgun
	// Always give this job to our wingman.
	if ( abBreach )
	{
		mDoorOpener = mAISquadMembers[mWingmanIndex];
		if ( mDoorOpener == None )
		{
			return;
		}

		if ( !mDoorOpener.HasBreachingWeapon() )
		{
			return;
		}

		mbDoorOpenerIsReady = false;

		// Get player to call for door man
		mPlayers[0].PlaySpeech( SPEECH_SquadHattonRounds );
	}
	else
	{
		// No door opener if door isn't locked.
		mDoorOpener = None;
		mbDoorOpenerIsReady = true;

		// Need to configure who is backup and who is wingman based on distances from
		// stackup locationms.
		ReconfigureSquadForBackupAssault();

		// We need to tell the wingman to get out of the way
		if ( !bUseWingmanInAssault && mAISquadMembers[mWingmanIndex] != None )
		{
			SASSoldierController( mAISquadMembers[mWingmanIndex].Controller ).DoWingmanTrackPlayer( mAssaultEP );
		} 
	}

	// Pick first assault squad member - must be alive, not door opener and not wingman.
	for ( i = 0; i < mNumAISquadMembers; i++ )
	{
		if (	(mAISquadMembers[i] != None) &&
				mAISquadMembers[i].IsAlive() &&
				!mAISquadMembers[i].mbIsIncapacitated &&
				(mAISquadMembers [i] != mDoorOpener) &&
				(i != mWingmanIndex) )
		{
			mAssaultTeam[0] = mAISquadMembers[i];
			mStackUpOrder[0] = i;
			break;
		} 
	}

	// If the backup squad are already in this volume, don't assault it
	if ( mAssaultVolume == mAssaultTeam[0].GetAssaultVolume() )
	{
		tempSoldier = GetRandomSquadMember();
		if ( tempSoldier != None )
		{
			tempSoldier.PlaySpeech( SPEECH_SquadAcknowledgeNo );
		}
		AbandonRoomAssault();
		return;
	}

	// Finally, find the second member of the assault pair if we have enough squad members left.
	if ( numLiveMembers > 3 )
	{
		for ( i = 0; i < mNumAISquadMembers; i++ )
		{
			if (	(mAISquadMembers[i] != None) &&
					mAISquadMembers[i].IsAlive() &&
					!mAISquadMembers [i].mbIsIncapacitated &&
					(mAISquadMembers[i] != mDoorOpener) &&
					(mAISquadMembers[i] != mAssaultTeam[0]) &&
					(i != mWingmanIndex) )
			{
				mAssaultTeam[1] = mAISquadMembers [i];
				mStackUpOrder[1] = i;
				break;
			} 
		} 
	}
	// If not, we use the wingman. 
	// Unallocate him as a wingman (so the player will temporarily have no wingman).
	else
	{
		if ( mWingmanIndex >= 0 )
		{
			mAssaultTeam[1] = mAISquadMembers[mWingmanIndex];
			mStackUpOrder[1] = mWingmanIndex;
			UnallocateWingman( mPlayers[0] );
		} 
		else
		{
			for ( i = 0; i < mNumAISquadMembers; i++ )
			{
				if (	(mAISquadMembers[i] != None) &&
						mAISquadMembers[i].IsAlive() &&
						!mAISquadMembers[i].mbIsIncapacitated &&
						(mAISquadMembers[i] != mAssaultTeam[0]) )
				{
					mAssaultTeam[1] = mAISquadMembers [i];
					mStackUpOrder[1] = i;
					break;
				}
			} 
		} 
	} 

	// Look closely at what stackup points we're allocating.
	if ( mAssaultEP.mAssaultVolLinks[0] == mAssaultFromVolume )
	{
		// Ensure door has stackup points
		if ( mAssaultEP.mStackUpParams[0].Positions[0] == Vect(0,0,0) && (mAssaultEP.myDoor != None) )
		{
			LogHuman ("EP " $mAssaultEP$ " has invalid stack position 0/0 for volume " $mAssaultFromVolume$ " (1)");
		} 
		if ( mAssaultEP.mStackUpParams[0].Positions[1] == Vect(0,0,0) && (mAssaultEP.myDoor != None) )
		{
			LogHuman ("EP " $mAssaultEP$ " has invalid stack position 0/1 for volume " $mAssaultFromVolume$ " (2)");
		} 

		if ( mAssaultTeam[1] == mDoorOpener )
		{
			idx[0] = 0;
		}
		else
		{
			AssignPointsToBackupSquad(
				mAssaultTeam[0], 
				mAssaultTeam[1],		
				mAssaultEP.mStackUpParams[0].Positions[0], 
				mAssaultEP.mStackUpParams[0].Positions[1],
				idx[0], idx[1] );
		} 
	} 
	else
	{
		// Ensure door has stackup points
		if (mAssaultEP.mStackUpParams[1].Positions[0] == Vect(0,0,0) && (mAssaultEP.myDoor != None) )
		{
			LogHuman ("EP " $mAssaultEP$ " has invalid stack position 1/0 for volume " $mAssaultFromVolume$ " (3)");
		}
		if (mAssaultEP.mStackUpParams[1].Positions[1] == Vect(0,0,0) && (mAssaultEP.myDoor != None) )
		{
			LogHuman ("EP " $mAssaultEP$ " has invalid stack position 1/1 for volume " $mAssaultFromVolume$ " (4)");
		}

		if (mAssaultTeam [1] == mDoorOpener)
		{
			idx [0] = 0;
		} 
		else
		{
			AssignPointsToBackupSquad(
				mAssaultTeam[0], 
				mAssaultTeam[1],
				mAssaultEP.mStackUpParams[1].Positions[0], 
				mAssaultEP.mStackUpParams[1].Positions[1],
				idx[0],
				idx[1] );
		}
	}

	// Swap assault team if stack-up points don't match (otherwise they'll 'GoGoGo' in the wrong order)
	if ( idx[0] == 1 )
	{
		tempSoldier = mAssaultTeam[1];
		mAssaultTeam[1] = mAssaultTeam[0];
		mAssaultTeam[0] = tempSoldier;

		i = mStackUpOrder[1];
		mStackUpOrder[1] = mStackUpOrder[0];
		mStackUpOrder[0] = i;
	}

	// Well, that's all done then. Get everyone to do their thing. If anyone reports that they can't comply,
	// abandon the assault.
	if ( abBreach )
	{
		SASSoldierController(mDoorOpener.Controller).mOrderAcknowledged = false;
		if ( !SASSoldierController( mDoorOpener.Controller ).DoDoorBreach() )
		{
			AbandonRoomAssault();
			return;
		}
		mbDoorOpenerIsReady = false;
	} 
	// If we're not breaching, order the door opener (actually our wingman) to stay out of the way
	else if ( mDoorOpener != None )
	{
		SASSoldierController( mDoorOpener.Controller ).Stop();
		mDoorOpener = None;
	} 

	// Send assault troops to first two stack up points for EP. 
	// If either fails then we have to abandon the whole assault.
	for ( i = 0; i < 2; i++ )
	{
		if ( mAssaultTeam [i] != None && mAssaultTeam [i] != mDoorOpener )
		{
			SASSoldierController( mAssaultTeam[i].Controller ).mOrderAcknowledged = false;
			if ( !SASSoldierController( mAssaultTeam[i].Controller ).DoStackUp() )
			{
				AbandonRoomAssault ();
				return;
			} 
			SASSoldierController( mAssaultTeam [i].Controller ).mOrderAcknowledged = false;
		} 
	} 

	mbDoorIsOpen = false;
	mAssaultTeamReady[0] = ATSTATUS_STACKING_UP;
	mAssaultTeamReady[1] = ATSTATUS_STACKING_UP;
	mAssaultCounter = 0;			// Must reset this for grenade assaults to work
	GotoState ('StackupState');

	mBackupSquadMode = BSM_INTERIOR_STACKUP;
}

function AbandonRoomAssault()
{
	local SASWeapon wpn;

	if (mDoorOpener != None)
	{
		SASSoldierController (mDoorOpener.Controller).SetObjective (SASOBJ_Idle, None);

		// Tell door opener to put shotgun away.
		if ( mDoorOpener.PendingWeapon != None )
		{
			wpn = SASWeapon( mDoorOpener.PendingWeapon );
		}
		else if ( mDoorOpener.Weapon != None )
		{
			wpn = SASWeapon( mDoorOpener.Weapon );
		}

		if ( (wpn == None) || (wpn.mCategory == WPNCAT_Special) )
		{
			mDoorOpener.SelectWeapon (WPNCAT_Primary);
		}
	} // if

	if (mAssaultTeam [0] != None)
	{
		SASSoldierController (mAssaultTeam [0].Controller).SetObjective (SASOBJ_Idle, None);
	} // if

	if (mAssaultTeam [1] != None)
	{
		SASSoldierController (mAssaultTeam [1].Controller).SetObjective (SASOBJ_Idle, None);
	} // if

	// Since we abandoned the assault, the room isn't regarded as 'cleared'
	mAssaultVolume.resetClearFlags ();
	mAssaultVolume = None;
	mAssaultEP = None;
	SetDefaultSquadMode ();
	GotoState ('');
} // abandonRoomAssault

state StackupState
{
	function BeginState ()
	{
		stopMultiTimer (mAssaultTimer);
		setMultiTimer (mStackUpTimer, 0.5, true);
		mAssaultTeamGoSent [0] = 0;
		mAssaultTeamGoSent [1] = 0;
	} // BeginState

	function EndState ()
	{
		stopMultiTimer (mStackUpTimer);
		stopMultiTimer (mAssaultTimer);
	} // EndState

	event notifyDoorDestroyed (SASDoorMover door)
	{
		if ( door == None || door != mAssaultDoor )
		{
			return;
		} // if

		mbDoorIsOpen = true;

		// If both assault squad members are ready then start the assault
		if ((mAssaultTeamReady [0] == ATSTATUS_WAITING || mAssaultTeam [0] == None) &&
			(mAssaultTeamReady [1] == ATSTATUS_WAITING || mAssaultTeam [1] == None))
		{
			setMultiTimer (mAssaultTimer, ASSAULT_TIMER_TICK, true);
		} // if

		// Tell the door opener to go idle - after all, either he's done his job or the
		// player has done it and he's no longer required
		if (mDoorOpener != None && mDoorOpener != mAssaultTeam [1])
		{
			SASSoldierController (mDoorOpener.Controller).stop ();
		} // if
	} // notifyDoorDestroyed

	// Look at stack-up point assignment and reassign if possible
	function updateStackUpPoints ()
	{
		local SASSoldier tempSoldier;
		local int temp;
		local int idx [2];
		local int stackIndex;

		// Don't do this if wingman is acting as door opener
		if (mAssaultTeam [1] == mDoorOpener)
		{
			return;
		} // if

		// Decide which set of stack-up points we are using
		if (mAssaultEP.mAssaultVolLinks [0] == mAssaultFromVolume)
		{
			stackIndex = 0;
		} // if
		else
		{
			stackIndex = 1;
		} // else

		AssignPointsToBackupSquad (mAssaultTeam [0], mAssaultTeam [1],
					mAssaultEP.mStackUpParams [stackIndex].Positions [0], mAssaultEP.mStackUpParams [stackIndex].Positions [1],
					idx [0], idx [1]);

		// Swap assault team if stack-up points don't match
		if (idx [0] == 1)
		{
			tempSoldier = mAssaultTeam [1];
			mAssaultTeam [1] = mAssaultTeam [0];
			mAssaultTeam [0] = tempSoldier;

			temp = mStackUpOrder [1];
			mStackUpOrder [1] = mStackUpOrder [0];
			mStackUpOrder [0] = temp;

			mAssaultTeamReady [0] = ATSTATUS_STACKING_UP;
			mAssaultTeamReady [1] = ATSTATUS_STACKING_UP;

			for (temp = 0; temp < 2; temp++)
			{
				if (SASSoldierController (mAssaultTeam [temp].Controller).DoStackUp () == false)
				{
					abandonRoomAssault ();
					return;
				} // if
			} // for
		} // if
	} // updateStackUpPoints

	// Kick off the start of the room assault
	function startRoomAssault ()
	{
		mAssaultSquadStatus [0].mSoldier = mAssaultTeam [0];
		mAssaultSquadStatus [1].mSoldier = mAssaultTeam [1];

		mAssaultSquadStatus [0].mStatus = ATSTATUS_MOVETOFIRSTDP;
		mAssaultSquadStatus [1].mStatus = ATSTATUS_MOVETOFIRSTDP;

		mAssaultVolume.resetClearFlags ();

		// Tell both troopers to ignore enemy now to avoid the assault being broken
		// if they see an enemy through the door
		SASSoldierController (mAssaultTeam [0].Controller).ignoreEnemy (true);
		SASSoldierController (mAssaultTeam [1].Controller).ignoreEnemy (true);

		// Something might have caused our troopers to get out of position. Re-evaluate who
		// should go in first.
		if (	mAssaultTeam[0] != None && 
				mAssaultTeam[1] != None )
		{
			CheckSwapBackupAssaultOrder();
		}

		// Tell the assault team to go now the door is open
		if (mAssaultTeam [0] != None && mAssaultTeamReady [0] != ATSTATUS_MOVETOFIRSTDP)
		{
			mAssaultTeam [0].mVoice.PlaySpeech (mAssaultTeam [0], SPEECH_SquadGo);
			SASSoldierController (mAssaultTeam [0].Controller).GoGoGo (0.5);
			mAssaultTeamGoSent [0] = 0.5;
			mbDoorIsOpen = true;
		} // if

		if (mAssaultTeam [1] != None && mAssaultTeamReady [1] != ATSTATUS_MOVETOFIRSTDP)
		{
			// Play speech only if other assault member couldn't
			if (mAssaultTeam [0] == None)
			{
				mAssaultTeam [1].mVoice.PlaySpeech (mAssaultTeam [1], SPEECH_SquadGo);
			} // if
			SASSoldierController (mAssaultTeam [1].Controller).GoGoGo (0.75);
			mAssaultTeamGoSent [1] = 0.75;
		} // if
	} // startRoomAssault

	function CheckSwapBackupAssaultOrder()
	{
		local int				tmpStackOrder;
		local float				tmpGoSent;
		local SASSoldier		tmpSoldier;
		local ESASAssaultTeamStatus	tmpTeamReady;

		// Whoever is closest to the EP goes in first.
		if (	VSizeHorizSq( mAssaultTeam[1].Location - mAssaultEP.Location ) <
				VSizeHorizSq( mAssaultTeam[0].Location - mAssaultEP.Location ) )
		{
			tmpSoldier = mAssaultTeam[0];
			mAssaultTeam[0] = mAssaultTeam[1];
			mAssaultTeam[1] = tmpSoldier;

			tmpStackOrder = mStackUpOrder[1];
			mStackUpOrder[1] = mStackUpOrder[0];
			mStackUpOrder[0] = tmpStackOrder;

			tmpGoSent = mAssaultTeamGoSent[1];	
			mAssaultTeamGoSent[1] = mAssaultTeamGoSent[0];
			mAssaultTeamGoSent[0] = tmpGoSent;
		
			tmpTeamReady = mAssaultTeamReady[1];
			mAssaultTeamReady[1] = mAssaultTeamReady[0];
			mAssaultTeamReady[0] = tmpTeamReady;
		}
	}

	// Sent by assault team to acknowledge the GoGoGo order
	function goAcknowledge (SASSoldier soldier)
	{
		if (soldier == mAssaultTeam [0])
		{
			mAssaultTeamReady [0] = ATSTATUS_MOVETOFIRSTDP;
		} // if
		else if (soldier == mAssaultTeam [1])
		{
			mAssaultTeamReady [1] = ATSTATUS_MOVETOFIRSTDP;
		} // if

		if (mAssaultTeamReady [0] == ATSTATUS_MOVETOFIRSTDP && mAssaultTeamReady [1] == ATSTATUS_MOVETOFIRSTDP)
		{
			mBackupSquadMode = BSM_INTERIOR_ASSAULT;
			mFollowPointsForAV.mFoundForThisAV = false;
			stopMultiTimer (mAssaultTimer);
			GotoState ('RoomAssaultState');
		} // if
	} // goAcknowledge

	// Called by each soldier as he reaches his assigned point to start the assault
	function reachedGoal (SASSoldier soldier)
	{
		if (soldier == mDoorOpener)
		{
			if (!mbDoorOpenerIsReady)
			{
				mbDoorOpenerIsReady = true;
			} // if
			else
			{
				setMultiTimer (mAssaultTimer, ASSAULT_TIMER_TICK, true);
			} // else
		} // if

		if (soldier == mAssaultTeam [0])
		{
			mAssaultTeamReady [0] = ATSTATUS_WAITING;
		} // else if
		else if (soldier == mAssaultTeam [1])
		{
			mAssaultTeamReady [1] = ATSTATUS_WAITING;
		} // else if

		// Assault squad are ready and door already open, go straight away
		if ((mAssaultTeamReady [0] == ATSTATUS_WAITING || mAssaultTeam [0] == None) &&
			(mAssaultTeamReady [1] == ATSTATUS_WAITING || mAssaultTeam [1] == None) &&
			mbDoorIsOpen)
		{
			setMultiTimer (mAssaultTimer, ASSAULT_TIMER_TICK, true);

			// If door not locked and not open, open it.
			if ( mAssaultDoor != None )
			{
				if (mAssaultDoor.mbLocked == false && mAssaultDoor.IsOpen () == false)
				{
					mAssaultDoor.Trigger( soldier.Controller, soldier );
					if (mAssaultDoor.mDoubleDoorLink != None && mAssaultDoor.mDoubleDoorLink.IsOpen () == false)
					{
						mAssaultDoor.mDoubleDoorLink.Trigger( soldier.Controller, soldier );
					} // if
				} // if
			}
			return;
		} // if

		// If everyone is ready, tell the door opener to open / breach door
		if ((mbDoorOpenerIsReady || mDoorOpener == None) &&
			(mAssaultTeamReady [0] == ATSTATUS_WAITING || mAssaultTeam [0] == None) &&
			(mAssaultTeamReady [1] == ATSTATUS_WAITING || mAssaultTeam [1] == None) &&
			!mbDoorIsOpen)
		{
			if (mDoorOpener != None)
			{
				SASSoldierController (mDoorOpener.Controller).GoGoGo ();
			} // if

			// If no door opener, start the assault immediately
			else
			{
				setMultiTimer (mAssaultTimer, ASSAULT_TIMER_TICK, true);

				// If door not locked and not open, open it
				if ( mAssaultDoor != None )
				{
					if (mAssaultDoor.mbLocked == false && mAssaultDoor.IsOpen () == false)
					{
						mAssaultDoor.Trigger( soldier.Controller, soldier );
						if (mAssaultDoor.mDoubleDoorLink != None && mAssaultDoor.mDoubleDoorLink.IsOpen () == false)
						{
							mAssaultDoor.mDoubleDoorLink.Trigger( soldier.Controller, soldier );
						} // if
					} // if
				}
			} // else
		} // if
	} // reachedGoal

	// Called by each soldier if he can't reach his assigned point
	function failedGoal (SASSoldier soldier)
	{
		abandonRoomAssault ();

		GotoState( '' );
	} // failedGoal

	function requestNextAction (SASSoldier soldier)
	{
		local int thisSoldier;

		if (soldier == mAssaultTeam [0])
		{
			thisSoldier = 0;
		} // if
		else if (soldier == mAssaultTeam [1])
		{
			thisSoldier = 1;
		} // if

		if (mAssaultSquadStatus [thisSoldier].mDP == None)
		{
			selectSingleAssaultDP (thisSoldier);
			SASSoldierController (soldier.Controller).doMoveToDP (mAssaultSquadStatus [thisSoldier].mDP);
		} // if
		else
		{
			if (soldier.ReachedDestination (mAssaultSquadStatus [thisSoldier].mDP))
			{
				SASSoldierController (soldier.Controller).doGuard (1.0);
				mAssaultSquadStatus [thisSoldier].mStatus = ATSTATUS_WAITING;
			} // if
			else
			{
				SASSoldierController (soldier.Controller).doMoveToDP (mAssaultSquadStatus [thisSoldier].mDP);
			} // else
		} // else
	} // requestNextAction

	///////////////////////////////////////////////////////////////////////////////
	// SoldierIsPartOfRoomAssault
	//
	// Returns true if soldier 'aSoldier' has an assault stacking up slot 
	// allocated to it.
	function eRoomAssaultRole SoldierIsPartOfRoomAssault (
		SASSoldier	aSoldier )
	{
		if ( aSoldier == None )
		{
			return ROOMASS_NONE;
		} // if

		if (aSoldier == mDoorOpener && !mbDoorIsOpen)
		{
			return ROOMASS_DOORBREACH;
		} // if

		if (aSoldier == mAssaultTeam [0])
		{
			return ROOMASS_ASSAULT_PRIMARY;
		} // if

		if (aSoldier == mAssaultTeam [1])
		{
			return ROOMASS_ASSAULT_SECONDARY;
		} // if

		return ROOMASS_NONE;
	} // SoldierIsPartOfRoomAssault

	///////////////////////////////////////////////////////////////////////////////
	//
	function ESASAssaultTeamStatus getAssaultTrooperStatus (
		SASSoldier	aSoldier )
	{
		if (aSoldier == mAssaultTeam [0])
		{
			return mAssaultTeamReady [0];
		} // if

		if (aSoldier == mAssaultTeam [1])
		{
			return mAssaultTeamReady [1];
		} // if

		return ATSTATUS_UNKNOWN;
	} // getAssaultTrooperStatus

	///////////////////////////////////////////////////////////////////////////////
	//
	// Has gogogo been sent to this trooper ?
	function float GoGoGoSent (
		SASSoldier	aSoldier )
	{
		if (aSoldier == mAssaultTeam [0])
		{
			return mAssaultTeamGoSent [0];
		} // if

		if (aSoldier == mAssaultTeam [1])
		{
			return mAssaultTeamGoSent [1];
		} // if

		return 0;
	} // GoGoGoSent

	///////////////////////////////////////////////////////////////////////////////
	event MultiTimer (int aIndex)
	{
		switch (aIndex)
		{
			// Room assault is now delayed by a fraction of a second to allow controllers to get
			// into the correct state
			case mAssaultTimer :
				mAssaultCounter += ASSAULT_TIMER_TICK;
				if (mAssaultCounter > MAX_WAIT_TIME_FOR_GRENADE || !mbPauseForGrenade || mbGrenadeThrown)
				{
					startRoomAssault ();

					// Now this is over, we have done our task - go to room assault control state
					if (mAssaultTeamReady [0] == ATSTATUS_MOVETOFIRSTDP && mAssaultTeamReady [1] == ATSTATUS_MOVETOFIRSTDP)
					{
						mBackupSquadMode = BSM_INTERIOR_ASSAULT;
						mFollowPointsForAV.mFoundForThisAV = false;
						stopMultiTimer (mAssaultTimer);
						GotoState ('RoomAssaultState');
					} // if
					else
					{
						setMultiTimer (mAssaultTimer, ASSAULT_TIMER_TICK, true);
					} // else
				} // if
				break;

			case mStackUpTimer :
				updateStackUpPoints ();
				break;

			default :
				Super.MultiTimer (aIndex);
				break;
		} // switch
	} // MultiTimer
} // StackupState

function SwapStackupPoints()
{
	local int			tmp;
	local SASSoldier	tmpSoldier;

	if ( mAssaultTeam[0] != None && mAssaultTeam[1] != None )
	{
		tmpSoldier = mAssaultTeam[1];
		mAssaultTeam[1] = mAssaultTeam[0];
		mAssaultTeam[0] = tmpSoldier;

		tmp = mStackUpOrder[1];
		mStackUpOrder[1] = mStackUpOrder[0];
		mStackUpOrder[0] = tmp;

		mAssaultTeamReady[0] = ATSTATUS_STACKING_UP;
		mAssaultTeamReady[1] = ATSTATUS_STACKING_UP;

		for ( tmp = 0; tmp < 2; tmp++ )
		{
			if ( !SASSoldierController(mAssaultTeam[tmp].Controller ).DoStackUp() )
			{
				AbandonRoomAssault();
				return;
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// STATE RoomAssaultState
//
// Base state for other room assault states.

function notifyEngagingEnemy (SASSoldier soldier);

///////////////////////////////////////////////////////////////////////////////
//
// Soldier notifies squad manager of first DP in room assault
function notifyFirstDP (SASSoldier soldier, SASDominationPoint DP)
{
	if (soldier == mAssaultSquadStatus [0].mSoldier)
	{
		mAssaultSquadStatus [0].mStatus = ATSTATUS_MOVETOFIRSTDP;
		mAssaultSquadStatus [0].mDP = DP;
	} // if
	else
	{
		mAssaultSquadStatus [1].mStatus = ATSTATUS_MOVETOFIRSTDP;
		mAssaultSquadStatus [1].mDP = DP;
	} // else
} // notifyFirstDP

// Find the single nearest uncleared point to this soldier
function selectSingleAssaultDP (int soldier)
{
	local int i;
	local int closest;
	local float closestDist;
	local float d;
	local Vector v;

	closestDist = Square (Metres (1000));
	closest = -1;
	v = mAssaultSquadStatus [soldier].mSoldier.Location;

	for (i = 0; i < mAssaultVolume.mDominationPoints.Length; i++)
	{
		if (mAssaultVolume.mDominationPoints [i].mbCleared == false &&
			mAssaultVolume.mDominationPoints [i].FindFirstAttachedEP() == None &&
			(mAssaultVolume.mDominationPoints [i].mOwner == None || mAssaultVolume.mDominationPoints [i].mOwner == mAssaultSquadStatus [soldier].mSoldier))
		{
			d = VSizeSq (v - mAssaultVolume.mDominationPoints [i].Location);
			if (d < closestDist)
			{
				closest = i;
				closestDist = d;
			} // if
		} // if
	} // for

	if (closest >= 0)
	{
		mAssaultSquadStatus [soldier].mDP = mAssaultVolume.mDominationPoints [closest];
	} // if
	else
	{
		mAssaultSquadStatus [soldier].mDP = None;
	} // else
} // selectSingleAssaultDP


state RoomAssaultState
{
	function requestNextAction (SASSoldier soldier)
	{
		local int thisSoldier, otherSoldier;
		local int i;
		local SASDominationPoint lastPair [2];

		// Check to see if we've finished this assault
		if (checkAssaultStatus () == true)
		{
			return;
		} // if

		if (soldier == mAssaultSquadStatus [0].mSoldier)
		{
			thisSoldier = 0;
		} // if
		else
		{
			thisSoldier = 1;
		} // else
		otherSoldier = 1 - thisSoldier;

		// What were we doing ?
		switch (mAssaultSquadStatus [thisSoldier].mStatus)
		{
			// Assuming we've just arrived at a DP, stop and sweep the area for a brief period. If not, carry on
			case ATSTATUS_MOVETOFIRSTDP :
			case ATSTATUS_MOVETODP :
				if (mAssaultSquadStatus [thisSoldier].mDP == None)
				{
					selectSingleAssaultDP (thisSoldier);
					SASSoldierController (soldier.Controller).doMoveToDP (mAssaultSquadStatus [thisSoldier].mDP);
				} // if
				else
				{
					if (soldier.ReachedDestination (mAssaultSquadStatus [thisSoldier].mDP))
					{
						SASSoldierController (soldier.Controller).doSweepDP ();
						mAssaultSquadStatus [thisSoldier].mStatus = ATSTATUS_SWEEPING;
					} // if
					else
					{
						SASSoldierController (soldier.Controller).doMoveToDP (mAssaultSquadStatus [thisSoldier].mDP);
					} // else
				} // else
				break;

			// If we were engaging a target, continue our move to our DP
			case ATSTATUS_ENGAGING :
				SASSoldierController (soldier.Controller).doMoveToDP (mAssaultSquadStatus [thisSoldier].mDP);
				mAssaultSquadStatus [thisSoldier].mStatus = ATSTATUS_MOVETODP;
				break;

			// If we're waiting at our DP, 
			case ATSTATUS_SWEEPING :
				/* TBD - Need a short audio message here - 'Yep', 'Go' etc */
				// Note no break - we fall through to next clause
			case ATSTATUS_WAITING :
				switch (mAssaultSquadStatus [otherSoldier].mStatus)
				{
					// If he's still moving to his DP, we wait briefly until he's ready
					case ATSTATUS_MOVETOFIRSTDP :
					case ATSTATUS_MOVETODP :
					case ATSTATUS_SWEEPING :
						if (soldier.ReachedDestination (mAssaultSquadStatus [thisSoldier].mDP))
						{
							SASSoldierController (soldier.Controller).doGuard (1.0);
							mAssaultSquadStatus [thisSoldier].mStatus = ATSTATUS_WAITING;
						} // if
						else
						{
							SASSoldierController (soldier.Controller).doMoveToDP (mAssaultSquadStatus [thisSoldier].mDP);
//							mAssaultSquadStatus [thisSoldier].mStatus = ATSTATUS_MOVETODP;
						} // else
						break;

					// If he's engaging an enemy (which we can't see, otherwise we'd be engaging
					// it as well) then we move on to our next DP
					case ATSTATUS_ENGAGING :
						selectSingleAssaultDP (thisSoldier);
						if (mAssaultSquadStatus [thisSoldier].mDP != None)
						{
							SASSoldierController (soldier.Controller).doMoveToDP (mAssaultSquadStatus [thisSoldier].mDP);
							mAssaultSquadStatus [thisSoldier].mStatus = ATSTATUS_MOVETODP;
						} // if
						else
						{
							if (soldier.ReachedDestination (mAssaultSquadStatus [thisSoldier].mDP))
							{
								SASSoldierController (soldier.Controller).doGuard (1.0);
							} // if
							else
							{
								SASSoldierController (soldier.Controller).doMoveToDP (mAssaultSquadStatus [thisSoldier].mDP);
								mAssaultSquadStatus [thisSoldier].mStatus = ATSTATUS_MOVETODP;
							} // else
						} // else
						break;

					// If he's waiting as well it means that we can both move on to our next DPs.
					// There may not be enough uncleared DPs left, in which case only one of us
					// moves
					case ATSTATUS_WAITING :
						// Save the last pair of DPs in case we don't get any new ones
						lastPair [0] = mAssaultSquadStatus [0].mDP;
						lastPair [1] = mAssaultSquadStatus [1].mDP;

						// Select a new pair
						UpdateBackupPairedAssaultDPs();

						for (i = 0; i < 2; i++)
						{
							if (mAssaultSquadStatus [i].mDP != None)
							{
								SASSoldierController (mAssaultSquadStatus [i].mSoldier.Controller).doMoveToDP (mAssaultSquadStatus [i].mDP);
								mAssaultSquadStatus [i].mStatus = ATSTATUS_MOVETODP;
								SASSoldierController (mAssaultSquadStatus [i].mSoldier.Controller).mbIgnoreEnemy = false;
							} // if
							else
							{
								SASSoldierController (mAssaultSquadStatus [i].mSoldier.Controller).doGuard (1.0);
								mAssaultSquadStatus [thisSoldier].mStatus = ATSTATUS_WAITING;
							} // else
						} // for

						if (mAssaultSquadStatus [0].mDP == None && mAssaultSquadStatus [1].mDP == None)
						{
							// NO DPs left - switch to backup mode
							mBackupSquadMode = BSM_INTERIOR_GUARD;

							// Restore the last DPs so that we know where the players are. Then select appropriate
							// quarter points for the point
							mAssaultSquadStatus [0].mStatus = ATSTATUS_GUARDING;
							mAssaultSquadStatus [0].mDP = lastPair [0];
							SASSoldierController (mAssaultSquadStatus [0].mSoldier.Controller).doGuard (1.0);

							mAssaultSquadStatus [1].mStatus = ATSTATUS_GUARDING;
							mAssaultSquadStatus [1].mDP = lastPair [1];
							SASSoldierController (mAssaultSquadStatus [1].mSoldier.Controller).doGuard (1.0);

							// Get one or other soldier to call room clear
							i = Rand (1);
							SASSoldierController (mAssaultSquadStatus [i].mSoldier.Controller).callRoomClear ();

							if (Rand (3) == 0)
							{
								SASSoldierController (mAssaultSquadStatus [1 - i].mSoldier.Controller).callRoomClear (true);
							} // if

							// If the player is no longer in the correct volume for this mode, switch
							// to default interior follow mode
							if (mPlayerVolume != mAssaultFromVolume && mPlayerVolume != mAssaultVolume)
							{
								SetDefaultSquadMode ();
								GotoState ('');
							} // if
						} // if
						break;
				} // switch
				break;

			case ATSTATUS_GUARDING :
				if (mAssaultSquadStatus [thisSoldier].mDP == None)
				{
					LogHuman ("Error - ATSTATUS_GUARDING soldier " $soldier$ " has no DP");
				} // if

				if (soldier.ReachedDestination (mAssaultSquadStatus [thisSoldier].mDP))
				{
					SASSoldierController (soldier.Controller).doGuard (1.0);
				} // if
				else
				{
					SASSoldierController (soldier.Controller).doMoveToDP (mAssaultSquadStatus [thisSoldier].mDP);
				} // else
				break;
		} // switch
	} // requestNextAction

	function notifyEngagingEnemy (SASSoldier soldier)
	{
		if (soldier == mAssaultSquadStatus [0].mSoldier)
		{
			mAssaultSquadStatus [0].mStatus = ATSTATUS_ENGAGING;
		} // if
		else
		{
			mAssaultSquadStatus [1].mStatus = ATSTATUS_ENGAGING;
		} // else
	} // notifyEngagingEnemy

	function bool checkAssaultStatus ()
	{
		local int i;

		if (mAssaultVolume == None)
		{
			LogHuman ("ERROR - mAssaultVolume is None in checkAssaultStatus");
		} // if

		// Fix the unused DPs (ones attached to other EPs) by marking them as cleared
		for (i = 0; i < mAssaultVolume.mEntryPoints.Length; i++)
		{
			if (mAssaultVolume.mEntryPoints [i] != mAssaultEP)
			{
				if (mAssaultVolume.mEntryPoints [i].mAssaultVolLinks [0] == mAssaultVolume)
				{
					mAssaultVolume.mEntryPoints [i].mDPLinks [0].mbCleared = true;
					mAssaultVolume.mEntryPoints [i].mDPLinks [1].mbCleared = true;
				} // if
				else
				{
					mAssaultVolume.mEntryPoints [i].mDPLinks [2].mbCleared = true;
					mAssaultVolume.mEntryPoints [i].mDPLinks [3].mbCleared = true;
				} // else
			} // if
		} // for

		// Go through all of the DPs in the assault volume and see if it's been cleared (except for DPs
		// attached to the other doors)
		// AF - AAAGH - this won't work because the squad doesn't clear the odd DPs attached to the other
		// EPs in the volume - hence fix to set clear DPs attached to other doors above
		for (i = 0; i < mAssaultVolume.mDominationPoints.Length; i++)
		{
			if (mAssaultVolume.mDominationPoints [i].mbCleared == false)
			{
				return false;
			} // if
		} // if

		// If we get here then the entire volume has been cleared. Tell both soldiers to stop and revert to
		// default behaviour
		if (mPlayerVolume != mAssaultFromVolume && mPlayerVolume != mAssaultVolume)
		{
			SetDefaultSquadMode ();
			GotoState ('');
		} // if
		else
		{
			mBackupSquadMode = BSM_INTERIOR_GUARD;
		} // else
		SASSoldierController (mAssaultSquadStatus [0].mSoldier.Controller).doGuard (1.0);
		SASSoldierController (mAssaultSquadStatus [1].mSoldier.Controller).doGuard (1.0);
//		mAssaultVolume = None;

		// Get one or other soldier to call room clear
		i = Rand (1);
		SASSoldierController (mAssaultSquadStatus [i].mSoldier.Controller).callRoomClear ();

		if (Rand (3) == 0)
		{
			SASSoldierController (mAssaultSquadStatus [1 - i].mSoldier.Controller).callRoomClear (true);
		} // if


		return true;
	} // checkAssaultStatus
} // RoomAssaultState


//-----------------------------------------------------------------------------------
//
// Called by wingman to get backup squad clear of his stack-up points
//::function squadClearStackupPoints (SASAssaultVolume AV, SASEntryPoint EP)
//::{
//::	local int s, i, j;
//::	local float threshold;
//::	local SASDominationPoint DP;
//::
//::	// Put squad into follow mode
//::	SetDefaultSquadMode ();
//::
//::	// Decide who the two backup squad members are
//::	for (i = 0; i < mNumAISquadMembers; i++)
//::	{
//::		if (i != mWingmanIndex && !mAISquadMembers [i].isDead () && !mAISquadMembers [i].mbIsIncapacitated)
//::		{
//::			mFollowPointsForAV.mSoldier [s] = mAISquadMembers [i];
//::			s++;
//::		} // if
//::	} // for
//::
//::	for (s = 0; s < 2; s++)
//::	{
//::		if (mFollowPointsForAV.mSoldier [s] != None)
//::		{
//::			threshold = square (mFollowPointsForAV.mSoldier [s].default.CollisionRadius);
//::			for (i = 0; i < 2; i++)
//::			{
//::				for (j = 0; j < 2; j++)
//::				{
//::					if (EP.hasValidStackup ())
//::					{
//::						if (VSizeHorizSq (mFollowPointsForAV.mSoldier [s].Location - EP.mStackupParams [i].Positions [j]) < threshold)
//::						{
//::							// If too close then move to nearest unoccupied DP
//::							DP = AV.GetClosestDominationPointToActor (mFollowPointsForAV.mSoldier [s], DPCF_OCCUPIED);
//::							if (DP != None)
//::							{
//::								mFollowPointsForAV.mDP [s] = DP;
//::								mFollowPointsForAV.mPoints [s] = DP.Location;
//::								mFollowPointsForAV.mDir [s] = Vector (DP.Rotation);
//::							} // if
//::						} // if
//::					} // if
//::				} // for
//::			} // for
//::		} // if
//::	} // for
//::} // squadClearStackupPoints


native final function AssignPointsToBackupSquad(
	SASSoldier	aSoldier1,
	SASSoldier	aSoldier2,
	Vector		aPoint1,
	Vector		aPoint2,
	out int		aAssignedIdx1,
	out int		aAssignedIdx2 );


//-----------------------------------------------------------------------------------
//
// function setFollowPositionsToCurrent
//
// Set backup squad's positions to remain where they are UNLESS the squaddie owns a DP, in which
// case retain it
event SetFollowPositionsToCurrent()
{
	local int i;
	local SASSoldier soldier;
	local SASSoldierController sc;
	local SASDominationPoint DP;

	for (i = 0; i < 2; i++)
	{
		if (mFollowPointsForAV.mSoldier [i] != None)
		{
			soldier = mFollowPointsForAV.mSoldier [i];
			sc = SASSoldierController (soldier.Controller);

			// If we don't own a DP, look for one very close to us and occupy it if possible
			if (sc.mDominationPoint == None)
			{
				DP = soldier.getAssaultVolume ().GetClosestDominationPointToActor (soldier, DPCF_OCCUPIED);
				if (DP != None && VSizeHorizSq (DP.Location - soldier.Location) < Square (soldier.default.CollisionRadius))
				{
					sc.AcquireDominationPoint (DP);
					mFollowPointsForAV.mDP [i] = DP;
					mFollowPointsForAV.mPoints [i] = DP.Location;
					mFollowPointsForAV.mDir [i] = Vector (DP.Rotation);
				} // if

				// Otherwise stay where we are
				else
				{
					mFollowPointsForAV.mDP [i] = None;
					mFollowPointsForAV.mPoints [i] = soldier.Location;
					sc.CalculateUnObstructedFacing ();
					mFollowPointsForAV.mDir [i] = sc.mLastFacing;
				} // else
			} // if

			// If we own a DP, retain it
			else
			{
				mFollowPointsForAV.mDP [i] = sc.mDominationPoint;
				mFollowPointsForAV.mPoints [i] = sc.mDominationPoint.Location;
				mFollowPointsForAV.mDir [i] = Vector (sc.mDominationPoint.Rotation);
			} // else
		} // if
	} // for
} // setFollowPositionsToCurrent

//-----------------------------------------------------------------------------------
//
// function setFollowPositionsToAttachedDP
//
// Set backup squad's positions to the DPs in AV attached to EP
event SetFollowPositionsToAttachedDP (SASAssaultVolume AV, SASEntryPoint EP)
{
	local SASDominationPoint DP [2];
	local int idx [2];
	local int i;

	if (EP == None || AV == None)
	{
		return;
	} // if

	// Decide which pair of DPs to use
	if (EP.mAssaultVolLinks [0] == AV)
	{
		DP [0] = EP.mDPLinks [0];
		DP [1] = EP.mDPLinks [1];
	} // if
	else
	{
		DP [0] = EP.mDPLinks [2];
		DP [1] = EP.mDPLinks [3];
	} // else

	if (DP [0] == None || DP [1] == None)
	{
		LogHuman ("EP " $EP$ " has no attached DPs in volume " $AV);
	} // if

	// If we have two squad members, assign nearest DPs
	if (mFollowPointsForAV.mSoldier [1] != None)
	{
		AssignPointsToBackupSquad (
			mFollowPointsForAV.mSoldier[0], 
			mFollowPointsForAV.mSoldier[1],
			DP[0].Location, DP[1].Location,
			idx [0], 
			idx [1] );

		for ( i = 0; i < 2; i++ )
		{
			mFollowPointsForAV.mStackPoint[i] = -1;
			mFollowPointsForAV.mPoints[i] = DP [idx [i]].Location;
			mFollowPointsForAV.mDir [i] = Vector (DP [idx [i]].Rotation);
			mFollowPointsForAV.mDP [i] = DP [idx [i]];
		} // for
	} // if

	// If only one squad member left, let him choose his closest
	else
	{
		mFollowPointsForAv.mStackPoint [0] = -1;
		if (VSizeSq (mFollowPointsForAV.mSoldier [0].Location - DP [0].Location) < 
			VSizeSq (mFollowPointsForAV.mSoldier [0].Location - DP [1].Location))
		{
			mFollowPointsForAV.mPoints [0] = DP [0].Location;
			mFollowPointsForAV.mDir [0] = Vector (DP [0].Rotation);
			mFollowPointsForAV.mDP [i] = DP [0];
		} // if
		else
		{
			mFollowPointsForAV.mPoints [0] = DP [1].Location;
			mFollowPointsForAV.mDir [0] = Vector (DP [1].Rotation);
			mFollowPointsForAV.mDP [i] = DP [1];
		} // else
	} // else
} // setFollowPositionsToAttachedDP

//-----------------------------------------------------------------------------------
//
// function setFollowPositionsToStackup
//
// Set backup squad's positions to the EP stackup in volume AV
function setFollowPositionsToStackup (SASAssaultVolume AV, SASEntryPoint EP)
{
	local int idx [2];
	local int i;

	if (EP.mAssaultVolLinks [0] == AV)
	{
		if (mFollowPointsForAV.mSoldier [1] != None)
		{
			AssignPointsToBackupSquad (mFollowPointsForAV.mSoldier [0], mFollowPointsForAV.mSoldier [1],
							EP.mStackUpParams [0].Positions [0], EP.mStackUpParams [0].Positions [1], idx [0], idx [1]);

			for (i = 0; i < 2; i++)
			{
				mFollowPointsForAV.mPoints [i] = EP.mStackUpParams [0].Positions [idx [i]];
				mFollowPointsForAV.mDir [i] = RotateZ (Vect (1, 0, 0), Unreal2Rad (EP.mStackUpParams [0].FacingAngles [idx [i]]));
				mFollowPointsForAv.mStackPoint [i] = i;
				mFollowPointsForAv.mDP [i] = None;
			} // for
		} // if
		else
		{
			mFollowPointsForAV.mPoints [0] = EP.mStackUpParams [0].Positions [0];
			mFollowPointsForAV.mDir [0] = RotateZ (Vect (1, 0, 0), Unreal2Rad (EP.mStackUpParams [0].FacingAngles [0]));
			mFollowPointsForAv.mStackPoint [0] = 0;
			mFollowPointsForAv.mDP [0] = None;
		} // else
	} // if
	else
	{
		if (mFollowPointsForAV.mSoldier [1] != None)
		{
			AssignPointsToBackupSquad (mFollowPointsForAV.mSoldier [0], mFollowPointsForAV.mSoldier [1],
							EP.mStackUpParams [1].Positions [0], EP.mStackUpParams [1].Positions [1], idx [0], idx [1]);

			for (i = 0; i < 2; i++)
			{
				mFollowPointsForAV.mPoints [i] = EP.mStackUpParams [1].Positions [idx [i]];
				mFollowPointsForAV.mDir [i] = RotateZ (Vect (1, 0, 0), Unreal2Rad (EP.mStackUpParams [1].FacingAngles [idx [i]]));
				mFollowPointsForAv.mStackPoint [i] = i;
				mFollowPointsForAv.mDP [i] = None;
			} // for
		} // if
		else
		{
			mFollowPointsForAV.mPoints [0] = EP.mStackUpParams [1].Positions [0];
			mFollowPointsForAV.mDir [0] = RotateZ (Vect (1, 0, 0), Unreal2Rad (EP.mStackUpParams [1].FacingAngles [0]));
			mFollowPointsForAv.mStackPoint [0] = 0;
			mFollowPointsForAv.mDP [0] = None;
		} // else
	} // else
} // setFollowPositionsToStackup

//-----------------------------------------------------------------------------------
//
// function calculateFollowWaitPoints
//
// Tell the requesting soldier where he should currently be waiting (if he's not at the
// point yet then he will go there). Point depends on his AV and the player's
function calculateFollowWaitPoints (SASSoldier soldier)
{
	local SASAssaultVolume soldierAV [2], followAV;
	local SASEntryPoint EP;
	local int i, c;
	local SASSoldier wingman;
	local bool encroachingEP;
	local bool hostages;
	local int thisSoldier;

	// Decide who the two backup squad members are
	mFollowPointsForAV.mSoldier [0] = None;
	mFollowPointsForAV.mSoldier [1] = None;
	for (i = 0; i < mNumAISquadMembers; i++)
	{
		if (i != mWingmanIndex && mAISquadMembers [i] != None && !mAISquadMembers [i].isDead () && !mAISquadMembers [i].mbIsIncapacitated)
		{
			mFollowPointsForAV.mSoldier [c] = mAISquadMembers [i];
			if (mFollowPointsForAV.mSoldier [c] == soldier)
			{
				thisSoldier = c;
			} // if
			c++;
		} // if
	} // for

	if (c > 2)
	{
		Warn ("WARNING - found " $c$ " backup soldiers in calculateFollowWaitPoints");
	} // if

	if (c == 0)
	{
		Warn ("No backup squad active - exiting");
		return;
	} // if

	soldierAV [0] = mFollowPointsForAV.mSoldier [0].getAssaultVolume ();
	soldierAV [1] = mFollowPointsForAV.mSoldier [1].getAssaultVolume ();

	// If either backup squad member is in the same AV as the player ...
	if (soldierAV [0] == mPlayerVolume || soldierAV [1] == mPlayerVolume)
	{
		// Is player near an EP ready for an assault ?
		if ( mPlayerNearestEP != None )
		{
			encroachingEP = isBackupSquadEncroachingEP (mPlayerNearestEP, mPlayerVolume);

			// If we're too near to the EP, get out of the way
			if (encroachingEP)
			{
				setFollowPositionsToAttachedDP (mPlayerVolume, mPlayerNearestEP);
				return;
			} // if
		} // if

		// If we're not both in this volume, move to the nearest EP to us
		if (soldierAV [thisSoldier] != mPlayerVolume)
		{
			EP = mPlayerVolume.GetClosestEntryPointToPawn (soldier);
			setFollowPositionsToAttachedDP (mPlayerVolume, EP);
		} // if

		// Otherwise we're already here, so stay where we are
		else
		{
			setFollowPositionsToCurrent ();
		} // else
	} // if

	// Otherwise we should be finding a point within the players previous AV, just outside the
	// connecting door to the previous volume
	else
	{
		// Do we have to deal with hostages ?
		hostages = hostagesFollowingPlayer ();

		// If there is a hostage in this volume, stay still
		if ( hostages && soldierAV [thisSoldier].IsPawnTypeInVolume( PAWN_Hostage ) )
		{
			setFollowPositionsToCurrent ();
			return;
		} // if

		else
		{
			// Decide what AV we should be in. If we're in the previous player volume, use that.
			if (soldierAV [thisSoldier] == mPreviousPlayerVolume)
			{
				followAV = mPreviousPlayerVolume;
			} // if

			// Otherwise, if we're in a connected volume, stay there. If our volume isn't connected, use the previous player volume.
			else
			{
				EP = mPlayerVolume.GetClosestSharedEntryPoint (mFollowPointsForAV.mSoldier [0], soldierAV [thisSoldier]);
				if (EP != None)
				{
					followAV = soldierAV [thisSoldier];
				} // if
				else
				{
					followAV = mPreviousPlayerVolume;
				} // else
			} // else

			// Find the EP connecting the player's AV with our selected one
			EP = mPlayerVolume.GetClosestSharedEntryPoint (mFollowPointsForAV.mSoldier [0], followAV);

			if (hostages && followAV.IsPawnTypeInVolume( PAWN_Hostage ) )
			{
				LogHuman ("Following hostages in next volume - moving to door DPs");
				setFollowPositionsToAttachedDP (followAV, EP);
				return;
			} // if

			if (EP != None)
			{
				// If player and wingman are within the EP's assault radius, go to the attached DPs so that
				// we stay out of the way of the stackup area
				wingman = GetPlayersWingman (mPlayers [0]);
				if (VSizeSq (mPlayers [0].Location - EP.Location) < Square (EP.mAssaultRadius) ||
					VSizeSq (wingman.Location - EP.Location) < Square (EP.mAssaultRadius))
				{
					setFollowPositionsToAttachedDP (followAV, EP);
					return;
				} // if

				if (EP.hasValidStackup ())
				{
					setFollowPositionsToStackup (followAV, EP);
				} // if

				// If no stack-up points, use nearest DPs instead
				else
				{
					setFollowPositionsToAttachedDP (followAV, EP);
				} // if
			} // if
			else
			{
                Warn ("WARNING - can't find connection between current and previous player volumes - using current");

				// Find the closest EP in the player's volume to us and stack up outside it
				EP = mPlayerVolume.GetClosestEntryPointToPawn (mFollowPointsForAV.mSoldier [0]);

				if (EP == None)
				{
					LogHuman ("WARNING - real trouble - can't find nearest EP in volume " $mPlayerVolume$ " to " $mFollowPointsForAV.mSoldier [0]);
					setFollowPositionsToCurrent (); 
				} // if
				else
				{
					if (EP.hasValidStackup ())
					{
						setFollowPositionsToStackup (EP.GetOtherAssaultVolume (mPlayerVolume), EP);
					} // if

					// If no stack-up points, use nearest DPs instead
					else
					{
						setFollowPositionsToAttachedDP (EP.GetOtherAssaultVolume (mPlayerVolume), EP);
					} // if
				} // else
			} // else
		} // else
	} // else

	mFollowPointsForAV.mFoundForThisAV = true;
} // calculateFollowWaitPoints

//-----------------------------------------------------------------------------------
//
// function getFollowWaitPoint
//
// Fetch last calculated wait points - calculate if not available
function getFollowWaitPoint (SASSoldier soldier, out Vector point)
{
	// This should never happen !!
	if (mBackupSquadMode != BSM_INTERIOR_FOLLOW)
	{
		LogHuman ("WARNING - getFollowWaitPoint called when squad not in Follow mode");
		point = soldier.Location;
		return;
	} // if

	// If we've already found follow points for this AV, return the cached ones
	if (mFollowPointsForAV.mFoundForThisAV == false)
	{
		calculateFollowWaitPoints (soldier);
	} // if

	// Assign appropriate point to this soldier
	if (soldier == mFollowPointsForAV.mSoldier [0])
	{
		point = mFollowPointsForAV.mPoints [0];
	} // if
	else if (soldier == mFollowPointsForAV.mSoldier [1])
	{
		point = mFollowPointsForAV.mPoints [1];
	} // else
	else
	{
		Warn ("WARNING - unknown soldier (" $soldier$ ") in getFollowWaitPoint - [0] " $mFollowPointsForAV.mSoldier [0]$ " [1] " $mFollowPointsForAV.mSoldier [1]);
		point = soldier.Location;
	} // else
} // getFollowWaitPoint

//-----------------------------------------------------------------------------------
//
// function getFollowWaitDirection
//
// Returns facing volume for backup follow points
//
function getFollowWaitDirection (SASSoldier soldier, out vector dir)
{
	local Vector location;
	
	// If not already calculated, do so now
	if (!mFollowPointsForAV.mFoundForThisAV)
	{
		getFollowWaitPoint (soldier, location);
	} // if

	if (soldier == mFollowPointsForAV.mSoldier [0])
	{
		dir = mFollowPointsForAV.mDir [0];
	} // if
	else if (soldier == mFollowPointsForAV.mSoldier [1])
	{
		dir = mFollowPointsForAV.mDir [1];
	} // else
} // getFollowWaitDirection

//-----------------------------------------------------------------------------------
//
// function getFollowWaitDP
//
// Returns any DP for backup follow points
//
function SASDominationPoint getFollowWaitDP (SASSoldier soldier)
{
	local Vector location;
	
	// If not already calculated, do so now
	if (!mFollowPointsForAV.mFoundForThisAV)
	{
		getFollowWaitPoint (soldier, location);
	} // if

	if (soldier == mFollowPointsForAV.mSoldier [0])
	{
		return mFollowPointsForAV.mDP [0];
	} // if
	else if (soldier == mFollowPointsForAV.mSoldier [1])
	{
		return mFollowPointsForAV.mDP [1];
	} // else

	return None;
} // getFollowWaitDP



//-----------------------------------------------------------------------------------
//
// function checkLargeVolumeForDPs
//
// Checks a large volume for suitable DPs for the backup squad and put
// the results in DP (which may already have DPs from other volumes in).
//
// 17-12-04 - TF removed all logging since a) it appears to work and b) it's incredibly
// slow on large external volumes with lots of points
//
function checkLargeVolumeForDPs (SASSoldier soldiers [2], SASAssaultVolume AV, out sBackupSelection DP [2], bool ignoreCleared)
{
	local int i, j;
	local float range;
	local vector playerPosn;
	local float playerWeight;

	playerPosn = mPlayers [0].Location;

	for (i = 0; i < AV.mDominationPoints.Length; i++)
	{
		// Ignore points already cleared
		if (AV.mDominationPoints [i].mbCleared == false || ignoreCleared == false)
		{
			//playerWeight = MAX (0, (VSize (AV.mDominationPoints [i].Location - playerPosn) - Metres (mPlayerSeparation)));

			// Scale up vertical distance.
			playerWeight = VSizeHoriz( AV.mDominationPoints [i].Location - playerPosn ) + 
										(Abs( AV.mDominationPoints [i].Location.Z - playerPosn.Z ) * 10.0);
			playerWeight = Max( 0, playerWeight - Metres( mPlayerSeparation ) );

			// We do this for both soldiers at once to try and cut down the amount of calculations needed
			for (j = 0; j < 2; j++)
			{
				if (soldiers [j] != None)
				{
					// Only do the rest of the calcs if the playerWeight is less than one of our existing points
					if (DP [j].mDP [0] == None ||
						DP [j].mDP [1] == None ||
						DP [j].mRangeToPlayer [0] > playerWeight ||
						DP [j].mRangeToPlayer [1] > playerWeight)
					{
						// We're looking for the nearest point to us within a fixed radius (mPlayerSeparation)
						// of the player. If we can't find one, looking for the shortest combined distance
						range = VSize (AV.mDominationPoints [i].Location - soldiers [j].Location);

						// If fewer than two points, store result
						if (DP [j].mDP [0] == None)
						{
							DP [j].mDP [0] = AV.mDominationPoints [i];
							DP [j].mRangeToPlayer [0] = playerWeight;
							DP [j].mRangeToSoldier [0] = range;
						} // if
						else if (DP [j].mDP [1] == None)
						{
							DP [j].mDP [1] = AV.mDominationPoints [i];
							DP [j].mRangeToPlayer [1] = playerWeight;
							DP [j].mRangeToSoldier [1] = range;
						} // if

						// Otherwise replace the furthest of the two existing stored points
						// if this is closer, or if equal range to player then if closer to the soldier
						else
						{
							if (DP [j].mRangeToPlayer [0] < DP [j].mRangeToPlayer [1])
							{
								if (playerWeight < DP [j].mRangeToPlayer [1] ||
									(playerWeight == DP [j].mRangeToPlayer [1] && range < DP [j].mRangeToSoldier [1]))
								{
									DP [j].mDP [1] = AV.mDominationPoints [i];
									DP [j].mRangeToPlayer [1] = playerWeight;
									DP [j].mRangeToSoldier [1] = range;
								} // if
							} // if
							else
							{
								if (playerWeight < DP [j].mRangeToPlayer [0] ||
									(playerWeight == DP [j].mRangeToPlayer [0] && range < DP [j].mRangeToSoldier [0]))
								{
									DP [j].mDP [0] = AV.mDominationPoints [i];
									DP [j].mRangeToPlayer [0] = playerWeight;
									DP [j].mRangeToSoldier [0] = range;
								} // if
							} // else
						} // else
					} // if
				} // if
			} // for
		} // if
	} // for
} // checkLargeVolumeForDPs

//-----------------------------------------------------------------------------------
//
// function SelectBackupSquadDP
//
// Selects domination points for the two backup squad members based on their
// current positions. Tries to select a pair of points that involves the backup
// both getting into position as soon as possible
//
function SelectBackupSquadDP (optional bool ignoreCleared)		// If this is true we don't use DPs marked as cleared
{
	local int squadMembers;
	local SASSoldier soldiers [2];
	local int i, c, s, j;
	local sBackupSelection DP [2];		// 0,1 are soldier A, 2,3 are soldier B
	local sBackupSelection temp;
	local SASAssaultVolume AV, nextAV;
	local array<SASAssaultVolume> checked;
	local bool found;

	squadMembers = GetNumLiveSquadMembers ();

	// If there are no backup squad members left this becomes irrelevant
	if (squadMembers <= 2)
	{
		return;
	} // if

	// If we only have a single remaining backup trooper then simple range selection
	// will suffice
	if (squadMembers == 3)
	{
		/* TBD */
	} // if

	// Decide who the two backup squad members are
	for (i = 0; i < mNumAISquadMembers; i++)
	{
		if (i != mWingmanIndex)
		{
			soldiers [c] = mAISquadMembers [i];
			c++;
		} // if
	} // for

	if (c == 0)
	{
		return;
	} // if

	// Get both backup squad members to evaluate all of the valid DPs in the player's assault
	// volume and find the closest pair
	AV = mPlayers [0].GetAssaultVolume ();

	// Check our current AV for points
	checkLargeVolumeForDPs (soldiers, AV, DP, ignoreCleared);

	// Now check all neighbouring volumes (large volumes only)
	for (i = 0; i < AV.mEntryPoints.Length; i++)
	{
		// Check the other AV that this entry point links to ONLY if it is also a large volume
		nextAV = None;
		if (AV.mEntryPoints [i].mAssaultVolLinks [0] == AV)
		{
			if (AV.mEntryPoints [i].mAssaultVolLinks [1].mLargeVolume)
			{
				nextAV = AV.mEntryPoints [i].mAssaultVolLinks [1];
			} // if
		} // if
		else
		{
			if (AV.mEntryPoints [i].mAssaultVolLinks [0].mLargeVolume)
			{
				nextAV = AV.mEntryPoints [i].mAssaultVolLinks [0];
			} // if
		} // else

		if (NextAV != None)
		{
			found = false;
			for (j = 0; j < checked.length; j++)
			{
				if (nextAV == checked [j])
				{
					break;
				} // if
			} // if

			if (!found)
			{
				checkLargeVolumeForDPs (soldiers, nextAV, DP, ignoreCleared);
			} // if
		} // if
	} // for

	for (s = 0; s < 2; s++)
	{
		// Sort the best two points we've found into nearest / furthest
		if (DP [s].mDp [1] != None && 
			(DP [s].mRangeToPlayer [0] > DP [s].mRangeToPlayer [1] ||
			(DP [s].mRangeToPlayer [0] == DP [s].mRangeToPlayer [1] && DP [s].mRangeToSoldier [0] == DP [s].mRangeToSoldier [1])))
		{
			temp.mRangeToSoldier [0] = DP [s].mRangeToSoldier [0];
			DP [s].mRangeToSoldier [0] = DP [s].mRangeToSoldier [1];
			DP [s].mRangeToSoldier [1] = temp.mRangeToSoldier [0];

			temp.mRangeToPlayer [0] = DP [s].mRangeToPlayer [0];
			DP [s].mRangeToPlayer [0] = DP [s].mRangeToPlayer [1];
			DP [s].mRangeToPlayer [1] = temp.mRangeToPlayer [0];

			temp.mDP [0] = DP [s].mDP [0];
			DP [s].mDP [0] = DP [s].mDP [1];
			DP [s].mDP [1] = temp.mDP [0];
		} // if
	} // for

	// OK, so we've now got two pairs of points, one for each soldier. Pick the pair of points
	// the produces the shortest time to get both soldiers in position
	mBackupSquadDPs.mSoldier [0] = soldiers [0];
	mBackupSquadDPs.mSoldier [1] = soldiers [1];
	if (c == 1 || DP [0].mDP [0] != DP [1].mDP [0])
	{
		mBackupSquadDPs.mDP [0] = DP [0].mDP [0];
		mBackupSquadDPs.mDP [1] = DP [1].mDP [0];
	} // if
	else
	{
		if (Max (DP [0].mRangeToSoldier [0], DP [1].mRangeToSoldier [1]) < Max (DP [0].mRangeToSoldier [1], DP [0].mRangeToSoldier [1]))
		{
			mBackupSquadDPs.mDP [0] = DP [0].mDP [0];
			mBackupSquadDPs.mDP [1] = DP [1].mDP [1];
		} // if
		else
		{
			mBackupSquadDPs.mDP [0] = DP [1].mDP [0];
			mBackupSquadDPs.mDP [1] = DP [0].mDP [1];
		} // else
	} // else
} // SelectBackupSquadDP

//-----------------------------------------------------------------------------------
//
//	function getBackupDP
//
function SASDominationPoint getBackupDP (SASSoldier soldier)
{
	if (soldier == mBackupSquadDPs.mSoldier [0])
	{
		return mBackupSquadDPs.mDP [0];
	} // if
	else if (soldier == mBackupSquadDPs.mSoldier [1])
	{
		return mBackupSquadDPs.mDP [1];
	} // else
} // getBackupDP

//-----------------------------------------------------------------------------------
//
//	function PlayerChangedAssaultVolumes
//
function PlayerChangedAssaultVolumes (
	SASSoldier			aPlayer,
	SASAssaultVolume	aPrevAV )
{
	local int i;
	local SASSoldierController sc;
	local SASAssaultVolume newAV;

	newAV = aPlayer.GetAssaultVolume ();
	
	// JS I've removed this message from the frontend
	if (newAV == None && Level.Title != "Frontend")
	{
		return;
	} // if

	mPreviousPlayerVolume = mPlayerVolume;
	mPlayerVolume = newAV;

	mFollowPointsForAV.mFoundForThisAV = false;

	// Check if should cancel backup action.
	if ( mBackupSquadMode == BSM_INTERIOR_STACKUP )
	{
		// If grenade assaulting and player has moved into the AV to assault then cancel backup assault
		if (	GetStateName() == 'StackupState' && 
				mPlayerVolume == mAssaultVolume && 
				mbPauseForGrenade )
		{
			AbandonRoomAssault();
		}
	}
	else if (mBackupSquadMode == BSM_INTERIOR_FOLLOW)
	{
		for (i = 0; i < mNumAISquadMembers; i++)
		{
			if (i != mWingmanIndex && mAISquadMembers [i] != None)
			{
				// Stop the backup squad's controllers from whatever they're doing -
				// this will cause them to re-evaluate and ask us what to do next
				sc = SASSoldierController (mAISquadMembers [i].Controller);
				sc.Stop ();
				sc.ignoreEnemy (false);
			} // if
		} // for
	} // if

	// Change out of guard mode when the player LEAVES the assault volume
	else if (mBackupSquadMode == BSM_INTERIOR_GUARD)
	{
		if ((mPreviousPlayerVolume == mAssaultFromVolume && mPlayerVolume != mAssaultVolume) ||
			(mPreviousPlayerVolume == mAssaultVolume && mPlayerVolume != mAssaultVolume))
		{
			mBackupSquadMode = BSM_INTERIOR_FOLLOW;
			GotoState ('');
		} // if
	} // else if

	mPlayerSeparation = MAX_PLAYER_SEPARATION;

	if (mPlayerVolume != None && mPlayerVolume.mLargeVolume)
	{
		mBackupSquadMode = BSM_EXTERIOR;
	} // if
	else
	{
		// If backup squad was backing-up an assault, revert them to follow behaviour. Also revert to
		// interior follow if we had been outside
		if (mBackupSquadMode == BSM_INTERIOR_BACKUP || mBackupSquadMode == BSM_EXTERIOR)
		{	
			mBackupSquadMode = BSM_INTERIOR_FOLLOW;
			gotoState ('');
			if (mBackupSquadDPs.mSoldier [0] != None && SASSoldierController (mBackupSquadDPs.mSoldier [0].controller) != None)
			{
				SASSoldierController (mBackupSquadDPs.mSoldier [0].controller).ignoreEnemy (false);
			} // if
			if (mBackupSquadDPs.mSoldier [1] != None && SASSoldierController (mBackupSquadDPs.mSoldier [1].controller) != None)
			{
				SASSoldierController (mBackupSquadDPs.mSoldier [1].controller).ignoreEnemy (false);
			} // if
		} // if
	} // else

	// Tell the wingman that player has moved into next assault volume (at this point the wingman should
	// have been stacking up or, at the very least, moving to a stackup point)
	for (i = 0; i < mNumAISquadMembers; i++)
	{
		sc = SASSoldierController (mAISquadMembers [i].Controller);
		if (sc.mbIsWingman)
		{
			sc.PlayerChangedAssaultVolumes (aPlayer, mPlayerVolume, aPrevAV );
		} // else
	} // for
} // PlayerChangedAssaultVolumes

//-----------------------------------------------------------------------------------
//
// function getBackupSupportPoint
//
// Fetch last calculated support points
function SASDominationPoint getBackupSupportPoint (SASSoldier soldier)
{
	// This should never happen !!
	if (mBackupSquadMode != BSM_INTERIOR_BACKUP)
	{
		LogHuman ("WARNING - getBackupSupportPoint called when squad not in Backup mode");
		return None;
	} // if

	// NEW METHOD - calculate follow wait points on the fly every time so that they are
	// updated for the new squad positions
	// If we haven't already found follow points for this AV, do so now
	//if (mFollowPointsForAV.mFoundForThisAV == false)
	//{
		calculateFollowWaitPoints (soldier);
//		LogHuman ("WARNING - getBackupSupportPoint called without points being calculated");
//		return None;
	//} // if

	// Assign appropriate point to this soldier
	if (soldier == mFollowPointsForAV.mSoldier [0])
	{
		return mFollowPointsForAV.mDP [0];
	} // if
	else if (soldier == mFollowPointsForAV.mSoldier [1])
	{
		return mFollowPointsForAV.mDP [1];
	} // else
	else
	{
		Warn ("WARNING - unknown soldier (" $soldier$ ") in getBackupSupportPoint");
	} // else

	return None;
} // getBackupSupportPoint

//-----------------------------------------------------------------------------------
//
// function callForBackup
//
// Player calls for support from his backup squad
//
// *TBD* - Doesn't check for locked doors - potential (but unlikely) problem
function callForBackup ()
{
	local SASSoldier tmp;
	local int i, c, idx [2];
	local SASDominationPoint DP [2],
							wingPrevDP;
	local SASEntryPoint EP;
	local SASSoldierController sc, wingController;
	local float doorPause;
	local bool moveWingman;

	// If squad is assaulting, abandon
	if (mBackupSquadMode == BSM_INTERIOR_ASSAULT ||
		mBackupSquadMode == BSM_INTERIOR_STACKUP ||
		mBackupSquadMode == BSM_INTERIOR_GUARD)
	{
		abandonRoomAssault ();
	} // if

	// Get the two support squad members
	mBackupSquadDPs.mSoldier [0] = None;
	mBackupSquadDPs.mSoldier [1] = None;

	for (i = 0; i < mNumAISquadMembers; i++)
	{
		if (mAISquadMembers [i] != None && i != mWingmanIndex && !mAISquadMembers [i].isDead () && !mAISquadMembers [i].mbIsIncapacitated)
		{
			mBackupSquadDPs.mSoldier [c] = mAISquadMembers [i];
			c++;
		} // if
	} // for

	if (c == 0)
	{
		return;
	} // if

	// If the player is in an external volume, cut the follow distance and recalculate
	// points
	if (mPlayerVolume.mLargeVolume == true)
	{
		mPlayerSeparation = MAX_PLAYER_SEPARATION_LV;
//		selectBackupSquadDP ();
		setMultiTimer (mBackupTimer, 5.0, false);
		return;
	} // if

	// If squad are in same volume as player, do nothing
	if (mPlayerVolume == mBackupSquadDPs.mSoldier [0].getAssaultVolume ())
	{
		return;
	} // if

	// Choose support points - these are the two closest DPs to the door that the
	// backup squad are waiting outside
	if (mPreviousPlayerVolume != None)
	{
		EP = mPlayerVolume.GetClosestSharedEntryPoint (mBackupSquadDPs.mSoldier [0], mBackupSquadDPs.mSoldier [0].getAssaultVolume ());
	} // if

	if (EP == None)
	{
		EP = mPlayerVolume.GetClosestSharedEntryPoint (mBackupSquadDPs.mSoldier [0], mPreviousPlayerVolume);
		if (EP == None)
		{
			if (mBackupSquadDPs.mSoldier [0] != None)
			{
				EP = mPlayerVolume.GetClosestEntryPointToPawn (mBackupSquadDPs.mSoldier [0]);
			} // if
			if (EP == None)
			{
				return;
			} // if
		} // if
	} // if
	
	// Make sure soldier 0 is the one nearest the door
	if (c == 2 && VSizeSq (mBackupSquadDPs.mSoldier [1].Location - EP.Location) < VSizeSq (mBackupSquadDPs.mSoldier [0].Location - EP.Location))
	{
		tmp = mBackupSquadDPs.mSoldier [1];
		mBackupSquadDPs.mSoldier [1] = mBackupSquadDPs.mSoldier [0];
		mBackupSquadDPs.mSoldier [0] = tmp;
	} // if

	if (EP.mAssaultVolLinks [0] == mPlayerVolume)
	{
		DP [0] = EP.mDPLinks [0];
		DP [1] = EP.mDPLinks [1];
		if (DP [0] == None)
		{
			LogHuman ("EntryPoint " $EP$ " missing DP 0");
		} // if
		if (DP [1] == None)
		{
			LogHuman ("EntryPoint " $EP$ " missing DP 1");
		} // if
	} // if
	else
	{
		DP [0] = EP.mDPLinks [2];
		DP [1] = EP.mDPLinks [3];
		if (DP [0] == None)
		{
			LogHuman ("EntryPoint " $EP$ " missing DP 2");
		} // if
		if (DP [1] == None)
		{
			LogHuman ("EntryPoint " $EP$ " missing DP 3");
		} // if
	} // else

	// Assign points to backup squad
	if (c == 2)
	{
		AssignPointsToBackupSquad (mBackupSquadDPs.mSoldier [0], mBackupSquadDPs.mSoldier [1],
									DP [0].Location, DP [1].Location,
									idx [0], idx [1]);
		mBackupSquadDPs.mDP [0] = DP [idx [0]];
		mBackupSquadDPs.mDP [1] = DP [idx [1]];
	} // if
	else
	{
		if (VSizeSq (mBackupSquadDPs.mSoldier [0].Location - DP [0].Location) < 
			VSizeSq (mBackupSquadDPs.mSoldier [0].Location - DP [1].Location))
		{
			mBackupSquadDPs.mDP [0] = DP [0];
		} // if
		else
		{
			mBackupSquadDPs.mDP [0] = DP [1];
		} // else
	} // else

	// If the wingman is currently on or owning either of the DPs that the backup squad want to use,
	// kick him so he gets away from them
	wingController = SASSoldierController (mAISquadMembers [mWingmanIndex].Controller);
	if (wingController.mDominationPoint == mBackupSquadDPs.mDP [0] ||
		wingController.mDominationPoint == mBackupSquadDPs.mDP [1])
	{
		// If he was assaulting, mark the DP (and the invisible friend one) as cleared

		if (wingController.mWingmanAssaultEP != None && wingController.mWingmanAssaultVolume != None)
		{
			wingController.mDominationPoint.mbCleared = true;
			if (wingController.mWingmanIFDP != None)
			{
				wingController.mWingmanIFDP.mbCleared = true;
			} // if
		} // if

		if (wingController.mWingmanAssaultEP != None && wingController.mWingmanAssaultVolume != None)
		{

		}

		moveWingman = true;
		wingPrevDP = wingController.mDominationPoint;
		wingController.RelinquishDominationPoint ();
	} // if

	// If there's a door and it's closed, open it
	if (SASDoorMover (EP.myDoor) != None && SASDoorMover (EP.myDoor).isOpen () == false)
	{
		EP.myDoor.Trigger( mBackupSquadDPs.mSoldier [0].Controller, mBackupSquadDPs.mSoldier [0] );
		doorPause = 0.5;
	} // if

	// Send backup squad to these points. Give a slight delay to soldier two so they don't end up fighting
	// for space in the doorway.
	if (mBackupSquadDPs.mSoldier [0] != None)
	{
		sc = SASSoldierController (mBackupSquadDPs.mSoldier [0].controller);
		sc.doMoveToDP (mBackupSquadDPs.mDP [0], doorPause);
		sc.ignoreEnemy (true);
	} // if
	if (mBackupSquadDPs.mSoldier [1] != None)
	{
		sc = SASSoldierController (mBackupSquadDPs.mSoldier [1].controller);
		sc.doMoveToDP (mBackupSquadDPs.mDP [1], 1.0 + doorPause);
		sc.ignoreEnemy (true);
	} // if

	mBackupSquadMode = BSM_INTERIOR_BACKUP;

	// Send the wingman to a new spot to get him away from the door
	if (moveWingman)
	{
		if (wingController.mWingmanAssaultEP != None && wingController.mWingmanAssaultVolume != None)
		{
			DP [0] = wingController.SelectWingmanNextDP( wingPrevDP );
			if (DP [0] != None && wingController.AcquireDominationPoint (DP [0]))
			{
				wingController.doMoveToDP (DP [0]);
			} // if
			else
			{
				// If we didn't find a new DP, end the assault
				DP [0] = wingController.mWingmanAssaultVolume.GetClosestDominationPointToActor (mAISquadMembers [mWingmanIndex], DPCF_OCCUPIED);

				if (DP [0] != None && wingController.AcquireDominationPoint (DP [0]))
				{
					wingController.doMoveToDP (DP [0]);
				} // if
				else
				{
					// What do we do now ?
					wingController.doWingmanTrackPlayer (mAssaultEP);
				} // else

				wingController.mWingmanAssaultEP = None;
				wingController.mWingmanAssaultVolume = None;
			} // else
		} // if
		else
		{
			DP [0] = wingController.mWingmanAssaultVolume.GetClosestDominationPointToActor (mAISquadMembers [mWingmanIndex], DPCF_OCCUPIED);

			if (DP [0] != None && wingController.AcquireDominationPoint (DP [0]))
			{
				wingController.doMoveToDP (DP [0]);
			} // if
			else
			{
				// What do we do now ?
				wingController.doWingmanTrackPlayer (mAssaultEP);
			} // else
		} // else

	} // if

	// Set timer to constantly update backup points. First update isn't until soldier 1 is moving
	setMultiTimer (mBackupTimer, 1.0 + doorPause, true);
} // callForBackup

/////////////////////////////////////////////////////////////////////////////////////
//
// updateBackupPoints
//
// Continually update backup points until both backup squad members are at their stations
function updateBackupPoints ()
{
	local int idx [2];
	local SASSoldierController sc [2];
	local SASDominationPoint dpTemp;

	if (mBackupSquadMode != BSM_INTERIOR_BACKUP)
	{
		return;
	} // if

	// No need to update if less than two backup squad members
	if (mBackupSquadDPs.mSoldier [1] == None)
	{
		stopMultiTimer (mBackupTimer);
		return;
	} // if

	// If both soldiers have arrived, cancel timer
	if (mBackupSquadDPs.mSoldier [0].ReachedDestination (mBackupSquadDPs.mDP [0]) &&
		mBackupSquadDPs.mSoldier [1].ReachedDestination (mBackupSquadDPs.mDP [1]))
	{
		stopMultiTimer (mBackupTimer);
		return;
	} // if

	// Set timer for more frequent updates
	setMultiTimer (mBackupTimer, 0.2, true);

	// Recheck assignment of points
	AssignPointsToBackupSquad (mBackupSquadDPs.mSoldier [0], mBackupSquadDPs.mSoldier [1],
								mBackupSquadDPs.mDP [0].Location, mBackupSquadDPs.mDP [1].Location,
								idx [0], idx [1]);

	// If assignment has changed then swap
	if (idx [0] != 0)
	{
		dpTemp = mBackupSquadDPs.mDP [0];
		mBackupSquadDPs.mDP [0] = mBackupSquadDPs.mDP [1];
		mBackupSquadDPs.mDP [1] = dpTemp;

		// Make both give up their
		// current DPs otherwise they won't allow the other to acquire the
		// new ones, then send them both to their new positions
		sc [0] = SASSoldierController (mBackupSquadDPs.mSoldier [0].controller);
		sc [1] = SASSoldierController (mBackupSquadDPs.mSoldier [1].controller);

		sc [0].RelinquishDominationPoint ();
		sc [1].RelinquishDominationPoint ();

		sc [0].doMoveToDP (mBackupSquadDPs.mDP [0]);
		sc [1].doMoveToDP (mBackupSquadDPs.mDP [1]);
	} // if
} // updateBackupPoints

/////////////////////////////////////////////////////////////////////////////////////
//
// updateFollowWaitPoints
//
// Continually Follow mode wait points until both backup squad members are at their stations
function updateFollowWaitPoints ()
{
	local int idx [2];
	local SASSoldierController sc [2];
	local Vector vTemp;
	local SASDominationPoint dpTemp;

	if (mBackupSquadMode != BSM_INTERIOR_BACKUP)
	{
		mPlayerSeparation = MAX_PLAYER_SEPARATION;
		return;
	} // if

	if (mMoveTarget == None)
	{
		mMoveTarget = Spawn (class'SASMoveTarget');
	} // if

	// If both soldiers have arrived, cancel timer
	mMoveTarget.setLocation (mFollowPointsForAV.mPoints [0]);
	if (mBackupSquadDPs.mSoldier [0].ReachedDestination (mMoveTarget))
	{
		mMoveTarget.setLocation (mFollowPointsForAV.mPoints [1]);
		if (mBackupSquadDPs.mSoldier [1].ReachedDestination (mMoveTarget))
		{
			return;
		} // if
	} // if

	// No need to update if less than two backup squad members
	if (mBackupSquadDPs.mSoldier [1] == None)
	{
		return;
	} // if

	// Recheck assignment of points
	AssignPointsToBackupSquad (mFollowPointsForAV.mSoldier [0], mFollowPointsForAV.mSoldier [1],
								mFollowPointsForAV.mPoints [0], mFollowPointsForAV.mPoints [1],
								idx [0], idx [1]);

	// If assignment has changed then swap
	if (idx [0] != 0)
	{
		// Have to swap all parts of the follow points
		vTemp = mFollowPointsForAV.mPoints [0];
		mFollowPointsForAV.mPoints [0] = mFollowPointsForAV.mPoints [1];
		mFollowPointsForAV.mPoints [1] = vTemp;

		vTemp = mFollowPointsForAV.mDir [0];
		mFollowPointsForAV.mDir [0] = mFollowPointsForAV.mDir [1];
		mFollowPointsForAV.mDir [1] = vTemp;

		// using idx [0] as a temporary int
		idx [0] = mFollowPointsForAV.mStackPoint [0];
		mFollowPointsForAV.mStackPoint [0] = mFollowPointsForAV.mStackPoint [1];
		mFollowPointsForAV.mStackPoint [1] = idx [0];

		dpTemp = mFollowPointsForAV.mDP [0];
		mFollowPointsForAV.mDP [0] = mFollowPointsForAV.mDP [1];
		mFollowPointsForAV.mDP [1] = dpTemp;

		// Set soldiers to idle (which is what stop () does) so they will
		// then re-evaluate and move to new point. Make both give up their
		// current DPs otherwise they won't allow the other to acquire the
		// new ones
		sc [0] = SASSoldierController (mBackupSquadDPs.mSoldier [0].controller);
		sc [1] = SASSoldierController (mBackupSquadDPs.mSoldier [1].controller);

		sc [0].RelinquishDominationPoint ();
		sc [1].RelinquishDominationPoint ();

		sc [0].AcquireDominationPoint (mFollowPointsForAV.mDP [0]);
		sc [1].AcquireDominationPoint (mFollowPointsForAV.mDP [1]);

		sc [0].stop ();
		sc [1].stop ();
	} // if
} // updateFollowWaitPoints

/////////////////////////////////////////////////////////////////////////////////////
//
// monitorPlayer
//
// Tracks player state
function monitorPlayer ()
{
	local SASSoldier tPawn;
	local SASPlayerController PC;
	local SASSoldierController SC;
	local SASSoldier player;

	player = mPlayers[0];

	foreach SASGameInfo(Level.Game).AllSASPawns(class'SASSoldier', tPawn)
	{
		PC = SASPlayerController(tPawn.Controller);

		// Don't toggle other player characters (co-op multiplayer)
		if (PC == None)
		{
			SC = SASSoldierController(tPawn.Controller);

			if (SC != None)
			{
				SC.delayedTorchToggle(player.mMasterLightswitch);
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////

// Default properties
//

// Decompiled with UE Explorer.
defaultproperties
{
    mWingmanIndex=-1
    mSquadShoutInterval=1.0000000
    mHostageShoutDownMax=2
    mFollowPointsForAV=(mFoundForThisAV=false,mSoldier=none,mSoldier[1]=none,mDP=none,mDP[1]=none,mPoints=(X=0.0000000,Y=0.0000000,Z=0.0000000),mPoints[1]=(X=0.0000000,Y=0.0000000,Z=0.0000000),mDir=(X=0.0000000,Y=0.0000000,Z=0.0000000),mDir[1]=(X=0.0000000,Y=0.0000000,Z=0.0000000),mStackPoint=-1,mStackPoint[1]=-1)
    mPlayerSeparation=7.0000000
    NetUpdateFrequency=5.0000000
    NetPriority=2.8000000
    RemoteRole=1
}