//=============================================================================
// SASSoldier.uc
//
// The physical Pawn representation of any AI or Player SAS Squad Member
//
//=============================================================================

class SASSoldier extends SASFighter
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

#exec OBJ LOAD FILE=..\Sounds\blueone.uax PACKAGE=BlueOne

//-----------------------------------------------------------------------------
// Constants

const CHECK_RANGE_TO_PLAYER_SQ_1				= 22500;	// Roughly 3m squared - 150 x 150 units
const CHECK_RANGE_TO_PLAYER_SQ_2				= 2500;	// Roughly 1m squared - 50 x 50 units

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Member Vars

var (SpeechControl)	float				mMinimumTimeBetweenAvoidSounds;
var float								mLastAvoidSound;
var (SpeechControl)	float				mMinimumTimeBetweenBlueOnBlueSounds;
var float								mLastBlueOnBlueSound;

// Cheap and nasty assault volume change monitoring - used by terrorists to determine
// if soldier has just changed AV.
var SASAssaultVolume					mPrevAssaultVolume;
var float								mAssaultVolumeChangeTime;
var SASAssaultVolume					mAssaultVolAtLastCheck;
var float								mAssaultVolumeCheckTimer;

//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// PreBeginPlay
// 
event PreBeginPlay ()
{
	Super.PreBeginPlay();

	if ( mSide == SIDE_None )
	{
		mSide = SIDE_Squad;	
	}

	// Sanity check that mPawnType var is set correctly.
	if ( mPawnType != PAWN_Soldier )
	{
		Warn( "SASSoldier with pawn type != PAWN_Soldier!!!" );
		mPawnType = PAWN_Soldier;
	}
}


///////////////////////////////////////////////////////////////////////////////
// PossessedBy
//
function PossessedBy(
	Controller	C )
{
	local SASGRI gri;

	Super.PossessedBy( C );

	// Scale health as required by difficulty level.
	gri = SASGRI( Level.Game.GameReplicationInfo );
	if ( gri != None )
	{
		if ( Controller.mType == CONTROLLER_Player )
		{
			// Don't scale player health in sabre squad game.
			if ( Level.Game.mGameTypeId != 1 )
			{
				if ( gri.mDifficultySetting.PlyrHealthScalar <= 0.0 )
				{
					LogHuman( "Difficulty settings: PlyrHealthScalar <= 0" );
				}
				else
				{
					mInitialHealth *= gri.mDifficultySetting.PlyrHealthScalar;
					Health = mInitialHealth;
				}
			}
		}
		else
		{
			if ( gri.mDifficultySetting.SquadHealthScalar <= 0.0 )
			{
				LogHuman( "Difficulty settings: SquadHealthScalar <= 0" );
			}
			else
			{
				mInitialHealth *= gri.mDifficultySetting.SquadHealthScalar;
				Health = mInitialHealth;
			}
		}
	}

	// In multiplayer always play hit anims on human controlled soldiers
	if ( Level.NetMode != NM_Standalone && Controller.mType == CONTROLLER_Player )
	{
		mPlayHitAnimChance = 1.0;
	}
}


///////////////////////////////////////////////////////////////////////////////
// CanBePunched
//
// Check if pawn can be puched using action menu. 
simulated event bool CanBePunched()
{
	// Can never punch soldiers.
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// NotifyShotSomeone
//
// Feedback message that we hit someone with a non-grenade weapon.
function NotifyShotSomeone(
	SASPawn	aDamaged )
{
	if ( aDamaged.mPawnType == PAWN_Soldier )
	{
		// in multiplayer we're allowed to shoot soldiers of different teams
		if (aDamaged.Controller.PlayerReplicationInfo.Team == Controller.PlayerReplicationInfo.Team)
		{
			// same team, that's bad.
		
			// Just shot an ally!
			// Play blue-on-blue speech.
			if ( (Level.TimeSeconds - mLastBlueOnBlueSound) > mMinimumTimeBetweenBlueOnBlueSounds )
			{
				mLastBlueOnBlueSound = Level.TimeSeconds;
				PlaySpeech( SPEECH_SquadBlueOnBlue );
			}
		}
	}
}


//------------------------------------------------------------------------------
//
//
/*
function BroadcastShowMessage ( 
	EShoutType	aeShoutType )
{
	local SASGameInfo	gi;
	local SASGRI		gri;

	gi = SASGameInfo ( Level.Game );
	gri = SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo );

	if ( ( gi != None ) && ( gri != None ) )
	{
		gi.BroadcastShowMessage ( gri.mLevelData.mShoutedMessages[aeShoutType], 'SASSoldier', 5 );
	}
}
*/

///////////////////////////////////////////////////////////////////////////////
// CheckWeaponPointing
//
event CheckWeaponPointing()
{
	local SASWeapon myWpn;

	if (isDead () || mbIsIncapacitated )
	{
		return;
	} // if
	
	if ( Weapon == None )
	{
		return;
	}
	myWpn = SASWeapon( Weapon );
	if ( myWpn == None )
	{
		return;
	}

	// TF - only do this for player-owned weapons
	if (PlayerController (Controller) == None)
	{
		return;
	} // if
	
	myWpn.CheckPawnThreatened( PAWN_Soldier );
}

//-----------------------------------------------------------------------------
//
// Returns TRUE if the soldier is carrying a hatton round equipped shotgun in his
// special weapon slot
function bool hasBreachingWeapon ()
{
	local SASWeapon myWpn;

	myWpn = GetWeaponOfCategory (WPNCAT_Special);

	if (myWpn != None)
	{
		return myWpn.mBreachingWeapon;
	} // if
	else
	{
		return false;
	} // else
} // hasBreachingWeapon

///////////////////////////////////////////////////////////////////////////////
// AnimNotifyEvent
event FireShotgun ()
{
	SASSoldierController (Controller).FireShotgun ();
} // FireShotgun

///////////////////////////////////////////////////////////////////////////////
// playerIsBlocking
//
//	Returns TRUE if the (a) player is blocking our destination point
//
//	Checks to see if the player in question is within his collision radius plus
//	ours (plus 10% for luck) of our destination
//
function SASSoldier squadIsBlocking (Vector destination)
{
	local int i;
	local float d, r;
	local SASSoldierController sc;

	if ( mbIsIncapacitated || isDead ())
	{
		return None;
	} // if

	sc = SASSoldierController (Controller);

	for (i = 0; i < 4; i++)
	{
		if (sc.mSquadManager.mPlayers [i] != None)
		{
			d = VSizeSq (destination - sc.mSquadManager.mPlayers [i].Location);
			r = 1.5 * (Default.CollisionRadius + sc.mSquadManager.mPlayers [i].Default.CollisionRadius);
			r = Square (r);

			if (d < r)
			{
				return sc.mSquadManager.mPlayers [i];
			} // if
		} // if

		// Extend check for other AIs as well
		if (sc.mSquadManager.mAISquadMembers [i] != None)
		{
			d = VSizeSq (destination - sc.mSquadManager.mAISquadMembers [i].Location);
			r = Default.CollisionRadius + sc.mSquadManager.mAISquadMembers [i].Default.CollisionRadius;
			r = Square (r);

			if (d < r)
			{
				return sc.mSquadManager.mAISquadMembers [i];
			} // if
		} // if
	} // for
} // squadIsBlocking

///////////////////////////////////////////////////////////////////////////////
// reachedDestination
//
//	Returns TRUE if we have reached our destination or we're close to it and
//	the (a) player is blocking our way. Use for SAS instead of the Pawn
//	reachedDestination function
//
function bool reachedDestination (Actor destination, optional bool bPreciseMove)
{
	local float rangeToDest;
	local SASSoldier blocker;
	local float rangeToPlayer;

	// If the real reachedDestination says we're then we must be
	if (Super.reachedDestination (destination, bPreciseMove))
	{
		return true;
	} // if

	// See if a player is blocking us
	blocker = squadIsBlocking (destination.Location);

	// If no player on the destination then we have no excuse
	if (blocker == None)
	{
		return false;
	} // if

	rangeToDest = VSizeSq (Location - destination.Location);
	rangeToPlayer =  VSizeSq (blocker.Location - destination.Location);

	// If player is on or near the point but on the other side (ie he's further away from us than the destination)
	// we should be able to get fairly close
	if (rangeToDest < rangeToPlayer && rangeToDest < Square (Metres (1)))
	{
		return true;
	} // if

	// If he's nearer than us then he's probably blocking it from our side so gives ourselves some leeway
	else if (rangeToDest >= rangeToPlayer && rangeToDest < Square (Metres (2)))
	{
		return true;
	} // else if


	// No ? Not there then
	return false;
} // reachedDestination

///////////////////////////////////////////////////////////////////////////////
//
// getClosestEnemyInVolume
//
// Returns the nearest enemy pawn to us that is in our volume, regardless of
// whether or not that enemy is visible

function Actor GetClosestEnemyInVolume ()
{
	local SASTerrorist		terrorist, 
							closest;
	local float				dist, 
							closestDist;
	local SASAssaultVolume	ourVol;

	if ( SASSoldierController( Controller ).mDominationPoint != None )
	{
		ourVol = SASSoldierController( controller ).mDominationPoint.mAssaultVol;
	} // if

	if ( ourVol == None )
	{
		ourVol = GetAssaultVolume();
	} // if

	foreach GetGame().RadiusSASPawns( class'SASTerrorist', terrorist, Location, 500.0 )
	{
		if (	!terrorist.mbIsIncapacitated && 
				!terrorist.isDead () )
		{
			dist = VSizeSq( Location - terrorist.Location );
			if (dist < closestDist || closest == None)
			{
				if (ourVol == terrorist.getAssaultVolume ())
				{
					closestDist = dist;
					closest = terrorist;
				} // if
			} // if
		} // if
	} // foreach

	return closest;
} // getClosestEnemyInVolume

//-----------------------------------------------------------------------------
// States

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mMinimumTimeBetweenAvoidSounds=5.0000000
    mMinimumTimeBetweenBlueOnBlueSounds=2.0000000
    mSide=2
    mInventoryWeapons[0]="SASWeapons.HK_MP5_Wpn"
    mInventoryWeapons[1]="SASWeapons.Browning_BDA_Wpn"
    mInventoryWeapons[2]="SASWeapons.CombatKnife_Wpn"
    mInventoryGrenades[0]="SASWeapons.G60_Grenade_Wpn"
    mInventoryGrenades[1]="SASWeapons.L2A2_Grenade_Wpn"
    mInventoryGrenades[2]="SASWeapons.Molotov_Cocktail_Wpn"
    mHandSkin=Texture'WpTx.Hands.CS01_hands'
    mShooterSpreadAnglePenaltyDecayMod=3.7500000
    mWeaponPointNotifyTimer=0.3000000
    mPlayHitAnimChance=0.4000000
    mPawnType=1
    bSameZoneHearing=true
    bMuffledHearing=true
    GroundSpeed=255.0000000
    WalkingPct=0.8300000
    Health=150
    ControllerClass=Class'SASSoldierController'
    BaseMovementRate=240.0000000
    Mesh=SkeletalMesh'CSas.CS01'
    bAlwaysRelevant=true
}