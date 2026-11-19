//=============================================================================
// SASPlayerController.uc
//=============================================================================

class SASPlayerController extends PlayerController
	native
	config(User)
	dependson(SASActionMenu);

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

#exec OBJ LOAD FILE=..\Textures\SFXTx.utx PACKAGE=SFXTx
#exec OBJ LOAD FILE=..\Sounds\GUI.uax PACKAGE=GUI


//-----------------------------------------------------------------------------
// Constants

const NUM_BREATH_SOUNDS				= 2;
const NUM_DISARM_COUNTDOWN_FRAMES	= 8;
const MOTIONBLUR_ALPHACHARGE		= 90;
const MOTIONBLUR_DECAYRATE			= 0.03;

const MAX_RECENTLY_THREATENED_ENEMIES = 4;

const BULLETCAM_OPTIMUM_SPEED		= 400.0;
const BULLETCAM_MAX_TIME			= 2.0;
const BULLETCAM_MIN_TIME			= 0.8;
const BULLETCAM_TIME_DILATION		= 0.2;
const BULLETCAM_MIN_ROT				= 500;
const BULLETCAM_MAX_ROT				= 800;
const BULLETCAM_ROT_SPEED			= 1400;
const BULLETCAM_ROT_ACCLN			= 10000;
const BULLETCAM_TRACKING_LAG_SCALE	= 1.2;

//-----------------------------------------------------------------------------
// Enums

enum eBreathState
{
	BSTATE_BreathIn,
	BSTATE_BreathOut,
};

enum eScreenFlashType
{
	SASSF_WHITEOUT,
	SASSF_DAMAGED
};

//-----------------------------------------------------------------------------
// Structs

struct native SASScreenFlash
{
	var eScreenFlashType Type;
	var float	MaxAlpha;
	var float	StartTime;
	var float	Duration;
	var float	FadeUpPct;		// Percentage of flash duration which is fading up to alpha
};

struct native SASScreenFade
{
	var bool	bActive;
	var Color	FadeColour;
	var float	FadeTime;
	var float	StartTime;
	var bool	bFadeUp;
};

struct native SASPlayerThreatInfo
{
	var SASPawn	Pawn;
	var float	FirstThreatenedTime;
	var float	LastThreatenedTime;
};

//-----------------------------------------------------------------------------
// Member Vars

var SASPawn					mSASPawn;
var float					mSecureCaptiveTime;

var string					mTempDemoFilename;
var bool					mbStoppedDemo;

var Sound					mBreathInSounds[NUM_BREATH_SOUNDS];
var Sound					mBreathOutSounds[NUM_BREATH_SOUNDS];
var float					mNextBreath;
var eBreathState			mBreathState;

var Rotator					mOldRotation;						// remembering how far the pawn's turned for the sake of rotation speed calc

var array<SASScreenFlash>	mScreenFlashes;
var SASScreenFade			mScreenFade;

var input byte						bNightVision;				// key input for night vision toggle
var bool							mbIsNightVision;			// true when night vision in use
var NightVision						mNightVisionEffect;			// Night Vision effect class
var FlashbangCameraEffect			mFlashbangCamEffect;		// Flashbang camera effect class
var bool							mbIsFlashbangCamEffectOn;			// true when night vision in use
var float							mfFlashbangCamEffectFadeoutTime;
var Sound					mTinnitusSound;
var float					mTinnitusLastTime;
var transient MotionBlur	mMotionBlurEffect;
var float					mMotionBlurDecayRate;
var bool					mbIsBloom;					// true when bloom in use
var transient Bloom			mBloomEffect;
var FadeOut					mFadeOutEffect;

var SASActionMenu.EActionButtonAction		meLatentActionButtonAction;
var SASBoobyTrapDevice		mBoobyTrapDevice;			// booby trap device currently 'in focus'

var bool					mbIsFreeView;

// Charging parameters
var bool					mbChargeDisabled;				// Allowed to charge or not.	
var float					mChargeAmount;					// Current 'charge' amount available
var bool					mbChargeAvailable;				// True if mChargeAmount > 0. This is used to reduce charge replication (mChargeAmount not replicated).
var float					mChargeDischargeRate;			// discharge rate
var float					mChargeRechargeRate;			// recharge rate modifier (non linear recharge rate)

var float					mMaxChargeTilt;
var float					mChargeTiltSpeed;
var float					mCurrentChargeTilt;

var float					mMaxStrafeTilt;
var float					mStrafeTiltSpeed;
var float					mCurrentStrafeTilt;
var float					mPrevStrafeTilt;
var float					mStrafeTiltTime;

var input byte				bPlayerTaunt;

var int						mMotionBlurDecayIndex;		// index of multitimer for motionblur

var actor					mTrackAct;

var	SASAssaultVolume		mLastAV;

var bool					mDoneGunLights;

var Rotator					mLastKnownRotation;

var bool					mPressedButtonToStart;
var bool					mDisplayingButtonPressToStartPrompt;
var bool					mMovieIntroStarted;
var bool					mMovieIntroDone;
var int						mMovieIntroCur;

var bool					mMovieScriptedStarted;
var bool					mMovieScriptedDone;

//var Actor					mHeldObject;

// Climbing params
var SASPlayerClimbVolume	mClimbVolume;				// Climb volume which defines climb to make.
var Vector					mClimbStartPoint;			// Location to move to before playing climb anim.
var bool					mbClimbCamActive;			// Should we be locking camera to pawn's head?
var Rotator					mClimbCamPrevRot;			// Previous frame camera rotation during climb (used for camera lag)
var Vector					mClimbCamOfsFromHeadBone;	// Difference in head bone location and view location when enterring climb cam mode.
var float					mClimbCamLastUpdateTime;	// Level time at which climb view was last updated.

var SASSquadManager			mSquadManager;
var SASPawn					mWingmanPawn;
var SASBoobyTrapMgr			mBoobyTrapManager;

// Targetting data
var Actor					mReticuleTarget;
var float					mReticuleTargeFirstHitTime;
var const SASPlayerThreatInfo mRecentlyThreatenedEnemies[MAX_RECENTLY_THREATENED_ENEMIES];	// Enemies who player has recently had LoF to.
var int						mNumRecentlyThreatenedEnemies;
var float					mRecentlyThreatenedEnemiesRefreshTime;

// State to return to after action
var name					mRestoreState;

// Mission end bullet cam
var bool					mbBulletCamActive;
var bool					mbBulletCamComplete;
var float					mBulletCamLastUpdateTime;
var float					mBulletCamTotDist;
var float					mBulletCamCurDist;
var float					mBulletCamTimer;
var float					mBulletCamSpeed;
var float					mBulletCamRotSpeed;
var float					mBulletCamRotTgt;
var int						mBulletCamRotDir;
var Vector					mBulletCamStart;
var Vector					mBulletCamInitDir;
var Rotator					mBulletCamCurRot;
var SASPawn					mBulletCamVictim;

//timers for player still playing game / map.
//to send it to the server.
var float                   mfElapsedTime;
var int                     mDeaths;

//------------------------------------------------------------------------------
//
//
replication
{
	// Variables the server should send to the client.
	reliable if ( bNetDirty && ( Role == ROLE_Authority ) )
		mSASPawn,
		mSquadManager,				// ??? - certainly shouldnt need SM in multiplayer but some code might need fixing up to remove it.
		mBoobyTrapManager,
		mbChargeAvailable;
		//mbBulletCamActive,			// Bullet cam vars should not be replicated - us a Client RPC instead.
		//mBulletCamStart,
		//mBulletCamInitDir,
		//mBulletCamCurRot,
		//mBulletCamSpeed,
		//mBulletCamTotDist,
		//mBulletCamVictim;

	// Replicated functions sent from server to owner client.
	reliable if ( Role == ROLE_Authority )
		ClientSetDisplayBSP,
		ClientRestartLevelTime,
		DoRestart,
		ClientEndMission,
		ClientStartMissionEndEffect,
		ClientEndLevel,
		ClientDoClimbing,
		ClientEndClimbing,
		ClientPlayScriptedMovie,
		ClientPlayBulletCam;

	// Reliable functions called on remote client.
	reliable if ( RemoteRole == ROLE_AutonomousProxy )
		ClientResetLevel;

	// Unreliable functions called on remote clients.
	unreliable if ( RemoteRole == ROLE_AutonomousProxy )
		ClientNotifyDamagableMeshStageChange;

	// Replicated functions sent to server by owned client.
	reliable if ( Role < ROLE_Authority )
		ServerPickupInventory,
		ServerMakeBoobyTrapSafe,
		ServerGotoLatentActionButtonState,
		ServerLeaveLatentActionButtonState,
		ServerToggleGunLight,
		ServerToggleGunLaser,
		ServerOrderHostagesDown,
		ServerDoClimbing,
		ServerCompleteSecondaryObjective,
		ServerPunchPawn,
		ServerHandcuffCaptiveStart,
		ServerHandcuffCaptiveStop,
		ServerHandcuffCaptiveComplete,
		ServerDisarmHostage,
		ServerOrderTerroristDown,
		ServerOrderHostageDown,
		ServerOrderRadiusHostagesDown,
		ServerOrderHostageFollow,
		ServerOrderRadiusHostagesFollow,
		ServerPlayPunch;
		//ServerToggleGodMode,
		//ServerTIA;
}


function SASMPPlayerBroadcastOnlineStatus(float DeltaTime)
{

	//Implented in SASMPlayerController.uc
}

/*
// Multiplayer god - shhhh - don't tell anyone...
exec function MPGod()
{
	ServerToggleGodMode();
}

function ServerToggleGodMode()
{
	local bool		bHasGodTag;
	local string	S,
					GodTag;

	bGodMode = !bGodMode;

	if ( bGodMode )
	{
		Level.Game.Broadcast( self, "I am cheating", 'Say' );
	}

	// Update player name (_[GOD} tag)
	GodTag = "_[GOD]";
	if ( PlayerReplicationInfo.PlayerName != GodTag )
	{
		S = Right( PlayerReplicationInfo.PlayerName, Len(GodTag) );
		if ( S == GodTag )
		{
			bHasGodTag = true;
		}
	}

	if ( bGodMode )
	{
		if ( !bHasGodTag )
		{
			S = PlayerReplicationInfo.PlayerName$GodTag;
			ChangeName( S );
		}
	}
	else
	{
		if ( bHasGodTag )
		{
			S = Left( PlayerReplicationInfo.PlayerName, Len( PlayerReplicationInfo.PlayerName )-Len(GodTag) );
			ChangeName( S );
		}
	}
}


exec function MPTIA()
{
	ServerTIA();
	SASPawn(Pawn).mInfiniteAmmoCheat = !SASPawn(Pawn).mInfiniteAmmoCheat;
	
}
function ServerTIA()
{
	SASPawn(Pawn).mInfiniteAmmoCheat = !SASPawn(Pawn).mInfiniteAmmoCheat;
}
*/

//-----------------------------------------------------------------------------
// Native Functions

native(810) final function CheckEnemyThreatened(
	SASPawn	aEnemy );

native function SetMoviePlayed( bool abPlayed );
native function bool HasMoviePlayed();

native(811) simulated  final function UpdateReticuleTarget();

exec cleannative final function TargetBreakpoint();

exec cleannative final function UnlockLevels();
exec cleannative final function Caption();

// Multiplayer map list API.
native final function int GetMPMapListLength();
native final function SetOpeningFrontEndPageToServer();
native final function string GetMPMapListName( int aMapListPos ); 
native final function string SetMPMapListPosition( int aNewMapListPos ); 
native final function string CycleMPMapList( optional bool bReturnToStart );
native final function SetProfileCampaignAndMissionFromMap( string filename );

native final function RenderLevelStartPrompt( Canvas aCanvas, string Message );


//-----------------------------------------------------------------------------
// Exec Functions

execrelease function Punch()
{
	SASFighter( mSASPawn ).PlayPunch( None );
	ServerPlayPunch();
}

function ServerPlayPunch()
{
	SASFighter( mSASPawn ).PlayPunch( None );
}

exec function BSP ( bool aState )
{
	if ( Level.NetMode == NM_Client )
	{
		ClientSetDisplayBSP ( aState );
	}
	else
	{
		ServerSetDisplayBSP ( aState );
	}
}

function ServerSetDisplayBSP ( bool aState )
{
	local SASPlayerController pc;

	ForEach DynamicActors ( class'SASPlayerController', pc )
	{
		pc.ClientSetDisplayBSP ( aState );
	}
}

simulated function ClientSetDisplayBSP ( bool aState )
{
	if ( aState )
	{
		ConsoleCommand ( "set client DisplayBSP 1" );
	}
	else
	{
		ConsoleCommand ( "set client DisplayBSP 0" );
	}
}

exec function ToggleSimplifyTraceCalls()
{
	Level.mbSimplifyTraceCalls = !Level.mbSimplifyTraceCalls;
}

exec function TogglePathfinding()
{
	Level.mbUseHierarchicalPathfinding = !Level.mbUseHierarchicalPathfinding;
}


// Allow/Prevent terrorists from using SeePlayer
exec function EnemySee (
	bool	abCanSee)
{
	local SASTerroristController tc;

	foreach AllActors (class'SASTerroristController', tc)
	{
		tc.mbCanSee = abCanSee;
	}
}

// Allow/Prevent terrorists from using HearNoise
exec function EnemyHear (
	bool	abCanHear)
{
	local SASTerroristController tc;

	foreach AllActors (class'SASTerroristController', tc)
	{
		tc.mbCanHear = abCanHear;
	}
}

// Allow/Prevent terrorists responding to damage
exec function EnemyFeelDamage (
	bool	abCanFeelDamage)
{
	local SASTerroristController tc;

	foreach AllActors (class'SASTerroristController', tc)
	{
		tc.mbCanFeelDamage = abCanFeelDamage;
	}
}

// Allow/Prevent terrorists from attacking
exec function EnemyDisableSenses (
	bool	abDisable)
{
	local SASTerroristController tc;

	foreach AllActors (class'SASTerroristController', tc)
	{
		tc.DisableAllSenses (abDisable);
	}
}

exec function godSquad ()
{
	local int i;

	if ( bGodMode )
	{
		bGodMode = false;
		ClientMessage("GodSquad off");
	} // if
	else
	{
		bGodMode = true; 
		ClientMessage("GodSquad on");
	} // else

	for (i = 0; i < mSquadManager.mNumAISquadMembers; i++)
	{
		if (mSquadManager.mAISquadMembers [i] != None)
		{
			mSquadManager.mAISquadMembers [i].Controller.bGodMode = bGodMode;
		} // if
	} // for
} // godSquad


exec function ChargeDischarge(
	float	aNewDischarge )
{
	mChargeDischargeRate = aNewDischarge;
}

exec function ChargeRecharge(
	float	aNewRecharge )
{
	mChargeRechargeRate = aNewRecharge;
}


execrelease function ToggleGunLight()
{
	local bool currentlyOn;

	currentlyOn = false;

	// This function happens on the computer where the human actually pressed the key

	// To make sure it happens for everyone, let's do it on the server
	if ((Pawn != None) && (SASWeapon(Pawn.Weapon) != None))
	{
		ServerToggleGunLight(!mSASPawn.mTorchShouldBeOn);
	}
}

// So this happens on the server only
function ServerToggleGunLight(bool onoff)
{
	if (mSASPawn != None)
	{
		mSASPawn.mMasterLightswitch = onoff;
		mSASPawn.SetGunLight(onoff);
	}

	// do everyone else's too
	//delayToggleAllSASGunLights(onoff);
}
/*
// JS We've ditched the laser... I'll only disable it at this level.
execrelease function ToggleGunLaser()
{
	local bool currentlyOn;

	currentlyOn = false;

	// This function happens on the computer where the human actually pressed the key

	// To make sure it happens for everyone, let's do it on the server
	if ((Pawn != None) && (SASWeapon(Pawn.Weapon) != None))
	{
		ServerToggleGunLaser(!mSASPawn.mLaserShouldBeOn);
	}
}
*/

// So this happens on the server only
function ServerToggleGunLaser(bool onoff)
{
	if (mSASPawn != None)
	{
		mSASPawn.SetGunLaser(onoff);
	}

	// do everyone else's too
	delayToggleAllSASGunLasers(onoff);
}

// Switch weapon light on/off
exec function AllGunLightsOn (
	bool	abOn)
{
	local SASSoldier tPawn;

	foreach SASGameInfo(Level.Game).AllSASPawns (class'SASSoldier', tPawn)
	{
		tPawn.SetGunLight(abOn);
	}
}

// Tell all other SAS characters to turn their weapons on / off - has a random delay built in so
// that it appears to be less mechanical
exec function delayToggleAllSASGunLights (
	bool	abOn)
{
	local SASSoldier tPawn;
	local SASPlayerController PC;
	local SASSoldierController SC;

	foreach SASGameInfo(Level.Game).AllSASPawns (class'SASSoldier', tPawn)
	{
		PC = SASPlayerController (tPawn.Controller);

		// Don't toggle other player characters (co-op multiplayer)
		if (PC == None)
		{
			SC = SASSoldierController (tPawn.Controller);

			if (SC != None)
			{
				SC.delayedTorchToggle (abOn);
			} // if
		} // if
	} // foreach
} // delayToggleAllSASGunLights
// Switch weapon Laser on/off
exec function AllGunLasersOn (
	bool	abOn)
{
	local SASSoldier tPawn;

	foreach SASGameInfo(Level.Game).AllSASPawns (class'SASSoldier', tPawn)
	{
		tPawn.SetGunLaser(abOn);
	}
}

// Tell all other SAS characters to turn their weapons on / off - has a random delay built in so
// that it appears to be less mechanical
exec function delayToggleAllSASGunLasers (
	bool	abOn)
{
	local SASSoldier tPawn;
	local SASPlayerController PC;
	local SASSoldierController SC;

	foreach SASGameInfo(Level.Game).AllSASPawns (class'SASSoldier', tPawn)
	{
		PC = SASPlayerController (tPawn.Controller);

		// Don't toggle other player characters (co-op multiplayer)
		if (PC == None)
		{
			SC = SASSoldierController (tPawn.Controller);

			if (SC != None)
			{
				SC.delayedLaserToggle (abOn);
			} // if
		} // if
	} // foreach
} // delayToggleAllSASGunLasers

event SASAssaultVolume GetAssaultVolume()
{
	if( mSASPawn != None )
	{
		return mSASPawn.GetAssaultVolume();
	}

	return None;
}


event EAvoidancePriority GetAvoidancePriority()
{
	return AVOIDPRIORITY_High;
}


// Cycle forward through weapon modes
execrelease function NextWeaponFunction ()
{
	local SASWeapon		myWeapon;

	if ((Pawn != None) && (Pawn.Weapon != None))
	{
		myWeapon = SASWeapon(Pawn.Weapon);
		if (myWeapon != None)
		{
			myWeapon.NextWeaponFunction();
		}
	}
}

execrelease function SwitchWeapon1()
{
	SwitchWeapon( 1 );
}
execrelease function SwitchWeapon2()
{
	SwitchWeapon( 2 );
}
execrelease function SwitchWeapon3()
{
	SwitchWeapon( 3 );
}
execrelease function SwitchWeapon4()
{
	SwitchWeapon( 4 );
}

// Selects weapon of category specified by aWpnCat.
// Overrides PlayerController function.
function SwitchWeapon(
	byte aWpnCatIdx)
{
	local EWeaponCategory	wpnCat;

	if ( mSASPawn != None )
	{
		switch( aWpnCatIdx )
		{
			case 1:
				wpnCat = WPNCAT_Primary;
				break;
			case 2:
				wpnCat = WPNCAT_Secondary;
				break;
			case 3:
				wpnCat = WPNCAT_Knife;
				break;
			case 4:
				wpnCat = WPNCAT_Special;
				break;
		}

		if ( wpnCat != WPNCAT_None )
		{
			mSASPawn.SelectWeapon( wpnCat );
		}
	}
}

// Cycle selected grenade type.
execrelease function CycleSelectGrenade()
{
	if ( mSASPawn != None )
	{
		mSASPawn.CycleGrenadeWeapon();
	}
}

// Select prev weapon in inventory chain.
execrelease function PrevWeapon()
{
	if ((Level.Pauser != None) || (mSASPawn == None))
	{
		return;
	}

	if (mSASPawn.Weapon == None)
	{
		SwitchToBestWeapon();
		return;
	}

	if (Pawn.PendingWeapon != None)
	{
		mSASPawn.PendingWeapon = mSASPawn.WeaponBefore(mSASPawn.PendingWeapon);
	}
	else
	{
		mSASPawn.PendingWeapon = mSASPawn.WeaponBefore(mSASPawn.Weapon);
	}

	if (mSASPawn.PendingWeapon != None)
	{
		mSASPawn.Weapon.PutDown();
	}
}

// Select next weapon in inventory chain.
execrelease function NextWeapon ()
{
	if ((Level.Pauser != None) || (mSASPawn == None))
	{
		return;
	}

	if (Pawn.Weapon == None)
	{
		SwitchToBestWeapon();
		return;
	}

	if (Pawn.PendingWeapon != None)
	{
		mSASPawn.PendingWeapon = mSASPawn.WeaponAfter(mSASPawn.PendingWeapon);
	}
	else
	{
		mSASPawn.PendingWeapon = mSASPawn.WeaponAfter(mSASPawn.Weapon);
	}

	if (mSASPawn.PendingWeapon != None)
	{
		mSASPawn.Weapon.PutDown();
	}
} // NextWeapon

execrelease function ForceReload ()
{
	local SASWeapon tWeapon;

	if ( Pawn == None )
	{
		return;
	} // if

	tWeapon = SASWeapon ( Pawn.Weapon );
	if ( tWeapon == None )
	{
		return;
	}

	// Don't do this if weapon is full or all remaining ammo is in the clip
	if (	tWeapon.HasFullMagazine () ||
			(tWeapon.mNumInMag >= tWeapon.AmmoType.AmmoAmount) )
	{
		return;
	} // if

	Super.ForceReload ();
} // ForceReload

exec function SwitchToBestWeapon()
{
	if ( mSASPawn != None )
	{
		mSASPawn.SelectBestWeapon();
	}
	else
	{
		Super.SwitchToBestWeapon();
	}
}

//------------------------------------------------------------------------------
//
//	EVENT ActivateActionMenu
event ActivateActionMenu ()
{
	if (IsInState ('ActionMenu') == false)
	{
		mRestoreState = GetStateName ();
		GotoState ('ActionMenu');
	} // if
} // ActivateActionMenu

//------------------------------------------------------------------------------
//
//	EVENT ExitActionMenu
event ExitActionMenu ()
{
	if (IsInState ('ActionMenu'))
	{
		Log ("Returning player to state " $mRestoreState);
		GotoState (mRestoreState);
	} // if
} // ExitActionMenu

//------------------------------------------------------------------------------
//
//
// Command captives (hostages and captured terrorists) down
execrelease function OrderHostagesDown()
{
	ServerOrderHostagesDown ();
}

//------------------------------------------------------------------------------
//
//
function ServerOrderHostagesDown ()
{
	if ( Pawn != None )
	{
		class'SASHostageController'.static.OrderHostagesDown ( mSASPawn );

		if ( mSquadManager != None )
		{
			mSquadManager.mLastHostageShoutDownTime = Level.TimeSeconds;
		}
	}
}



//------------------------------------------------------------------------------
// ActionButtonPress
//
execrelease function ActionButtonPress ()
{
	Log ("Action Button");
} // ActionButtonPress

////////////////////////////////////////////////////////////////////////////////
execrelease function OpenCloseDoor ( Mover aDoor )
{
	mSASPawn.ServerOpenCloseDoor (aDoor);
} // OpenCloseDoor


//------------------------------------------------------------------------------
//
//
execrelease function ToggleAiming ()
{
	local SASWeapon		w;

	if ( Pawn != None && Pawn.Weapon != None )
	{
		w = SASWeapon( Pawn.Weapon );
		if ( w != None )
		{
			w.ToggleMode ();
		}
	}
}


//-----------------------------------------------------------------------------
// Functions

function SetPawnClass(string inClass, string inCharacter)
{
    local class<Pawn> pClass;

    pClass = class<Pawn>(DynamicLoadObject(inClass, class'Class'));
	if ( inCharacter != "" )
	{
		pClass = class<Pawn>(DynamicLoadObject(inCharacter, class'Class'));
	}

    if ( pClass != None )
	{
        PawnClass = pClass;
	}
}



//------------------------------------------------------------------------------
//
//
function InitSquadManager ()
{
	// Find the SASSquadManager
	foreach AllActors ( class'SASSquadManager', mSquadManager )
	{
		break;
	}
}

//------------------------------------------------------------------------------
//
//
function InitBoobyTrapManager ()
{
	// Find the SASSquadManager
	foreach AllActors ( class'SASBoobyTrapMgr', mBoobyTrapManager )
	{
		break;
	}
}


//------------------------------------------------------------------------------
//
//
function Possess ( Pawn aPawn )
{
	local SceneManager sm;
	local bool has_sm;
	
	// Store ptr to SASPawn so no need to repeatedly cast from Pawn to SASPawn.
	mSASPawn = SASPawn( aPawn );
	
	if ( mSASPawn == None )
	{
		Warn( "SASPlayerController tried to possess non-SASPawn pawn." );
		return;
	}

	Super.Possess ( aPawn );

	// REMOVE!
	aPawn.PeripheralVision=0.766;	// ~cos(40)

	// Init sight flags to see terrorists only.
	SetSightFlags( SIGHT_Terrorists );

	// Don't listen to noises.
	SetHearingFlags( HEAR_None );

	// MOVE!
	InitSquadManager ();
	InitBoobyTrapManager ();

	// Tell squad manager where we are
	mSquadManager.PlayerChangedAssaultVolumes (SASSoldier (aPawn), None);

	// Add self to squad.
	mSquadManager.AddPlayerMember( SASSoldier( aPawn ) );

// TCR Demo stuff (Uncomment this line)
	// But only do it when we're not in multiplayer
	
	// JS for some reason I can't cast to SASMPGameInfo. So I've made a member variable of the game info to say whether we're multiplayer or not
	if ( SASGameInfo( Level.Game ) == None || (SASGameInfo( Level.Game ).mGameTypeId != 0) )
	{
		// We can't do recording of matinee levels, it kills the matinee.
		has_sm = false;
		
		ForEach DynamicActors( class 'SceneManager', sm )
		{
			// Oh, we have a scene manager, don't record then.
			has_sm = true;
			break;
		}
		
		// JS let's not do demo record on PS2 for now.
		// JS oh and indeed not at all. I've left it in as a monument to work hours lost at war.
		// if (!has_sm && !IsPs2())
		//	RecordDemo();
	}

	SetupPlayerCameraEffects ();
}



///////////////////////////////////////////////////////////////////////////////
// SpawnDefaultHUD
//
function SpawnDefaultHUD()
{
    // note that myHUD is a variable defined in PlayerController
    myHUD = Spawn(class<HUD>(DynamicLoadObject(Level.Game.HUDType, class'Class')), self);
}


//::function Vector GetTargetedPoint()
//::{
//::	local Vector aimPoint;
//::
//::	// fudge a point about 20 feet from player, in dirn they're looking
//::	//
//::	aimPoint = Normal( Vector( Pawn.Rotation ) );
//::	aimPoint *= (16*20);
//::	aimPoint += Pawn.Location;
//::
//::	return aimPOint;
//::}


event SeePlayer( Pawn aSeenPawn )
{
	local SASPawn seenSASPawn;

	seenSASPawn = SASPawn ( aSeenPawn );
	if ( ( seenSASPawn != None ) && ( seenSASPawn.Controller != None ) )
	{
		if ( (seenSASPawn.mPawnType == PAWN_Terrorist)
			&& SASPawn(Pawn).IsAThreat( seenSASPawn ) )
		{
			// Report seen terrorist to squad.
			mSquadManager.UpdateSquadThreatInfo( seenSASPawn, self );

			CheckEnemyThreatened( seenSASPawn );
		}

		seenSASPawn.Controller.SeenByPlayer( mSASPawn );
	}
}


//------------------------------------------------------------------------------
// PlayerHasWingman
//
//simulated function bool PlayerHasWingman ()
function bool PlayerHasWingman ()
{
	return ( mSquadManager.GetPlayersWingman( SASSoldier( Pawn ) ) != None );
}


//------------------------------------------------------------------------------
// ProcessReticule
//
simulated function ProcessReticule()
{
	UpdateReticuleTarget();
}


// Inform AI when I change volumes
simulated function ProcessAssaultVolume()
{
	local SASAssaultVolume	currentAV;

	currentAV = GetAssaultVolume();
	if ( mLastAV == None )
	{
		mLastAV = currentAV;
	}

	if ( mLastAV != currentAV )
	{
		// Inform AI that player has moved to a different volume.
		ChangedAssaultVolume( SASSoldier( Pawn ), mLastAV );
		mLastAV = currentAV;
	}
}



//------------------------------------------------------------------------------
//
//
function ProcessSquad ()
{
	local SASAssaultVolume		currentAV;
	local int i;
	local SASEntryPoint playerEP;
	local float dist, closest;

	if ( Level.NetMode != NM_Standalone )
	{
		return;
	}

	if ( mSquadManager != None )
	{
		if ( !PlayerHasWingman () )
		{
			// Request a new wingman.
			AllocateWingman ( SASSoldier ( Pawn ) );
		}
	}

	// Am I near to an EP ?
	currentAV = GetAssaultVolume ();
	if (currentAV == None)
	{
		// So, there's no assault volume. Let's cut down the number of human messages that turn up
		// on testbed levels.
		i = 0;
		
		foreach AllActors(class'SASAssaultVolume', currentAV)
		{
			i = 1;
		}
		
		if (i == 0)
		{
			// there's no assault volumes in the whole level. It's probably a testbed level.
			LogHuman("There are no assault volumes on this level");
		}
		else
		{
			// there are no assault volumes right here. Let's print the location.
			// This will cause millions of messages, which is why I've done the change above.
			LogHuman ("Player has no AV at " $mSASPawn.Location);
		}
	} // if
	else
	{
		for (i = 0; i < currentAV.mEntryPoints.Length; i++)
		{
			dist = VSizeSq (currentAV.mEntryPoints [i].Location - mSASPawn.Location);
			if (dist < Square (currentAV.mEntryPoints [i].mAssaultRadius))
			{
				closest = dist;
				playerEP = currentAV.mEntryPoints [i];
				break;
			} // if
		} // for
	} // else

	if ( mSquadManager != None )
	{
		mSquadManager.playerNearEP (playerEP);
	}
} // ProcessSquad

//------------------------------------------------------------------------------
//
//
function ProcessBreathing()
{
	local float		tHeartRate;
	local SASGRI	gri;

	gri = SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo );

	if ( ( mSASPawn != None ) && ( gri != None ) && ( Level.TimeSeconds > mNextBreath ) )
	{
		tHeartRate = ( mSASPawn.mHeartRate - mSASPawn.mHeartRateBase ) / ( mSASPawn.mHeartRateMax-mSASPawn.mHeartRateBase ); // 0.0 -> 1.0!

		mNextBreath = Level.TimeSeconds + 0.1 + (2 * (1.0 - tHeartRate));

		switch ( mBreathState )
		{
		case BSTATE_BreathIn:
			//Playsound(mBreathInSounds[rand(NUM_BREATH_SOUNDS)],SLOT_None,0.1 + tHeartRate * 0.6,TRUE,128,0.9+tHeartRate*0.2,TRUE);
			mBreathState = BSTATE_BreathOut;
			break;

		case BSTATE_BreathOut:
			//Playsound(mBreathOutSounds[rand(NUM_BREATH_SOUNDS)],SLOT_None,0.1 + tHeartRate * 0.6,TRUE,128,0.9+tHeartRate*0.2,TRUE);
			mBreathState = BSTATE_BreathIn;
			break;

		default:
			break;
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// DoClimbing
//
function ServerDoClimbing(
	SASPlayerClimbVolume	aClimbVol )
{
	if ( aClimbVol == None )
	{
		return;
	}
	
	if ( Role == ROLE_Authority )
	{
		LocalDoClimbing( aClimbVol );
		ClientDoClimbing( aClimbVol );
	}
}


///////////////////////////////////////////////////////////////////////////////
// ClientDoClimbing
//
function ClientDoClimbing(
	SASPlayerClimbVolume	aClimbVol )
{
	LocalDoClimbing( aClimbVol );
}


///////////////////////////////////////////////////////////////////////////////
// ClientDoClimbing
//
function ClientEndClimbing();


///////////////////////////////////////////////////////////////////////////////
// LocalDoClimbing
//
function LocalDoClimbing(
	SASPlayerClimbVolume aClimbVol )
{
	mClimbVolume = aClimbVol;
	GotoState( 'PlayerClimbingObstacle' );
}


///////////////////////////////////////////////////////////////////////////////
// ServerCompleteSecondaryObjective
//
function ServerCompleteSecondaryObjective(
	SASSecondaryObjective	aSecondaryObj )
{
	if ( (Role == ROLE_Authority) && (aSecondaryObj != None) )
	{
		aSecondaryObj.Complete();
	}
}


///////////////////////////////////////////////////////////////////////////////
// ServerPunchPawn
//
function ServerPunchPawn(
	SASPawn	aPunched )
{
	if ( (Role == ROLE_Authority) && (aPunched != None) )
	{
		aPunched.ServerDoPunchedByPlayer( mSASPawn );
	}
}


///////////////////////////////////////////////////////////////////////////////
// ServerHandcuffCaptiveStart
//
function ServerHandcuffCaptiveStart(
	SASPawn	aOther )
{
	if ( (Role == ROLE_Authority) && (aOther != None) )
	{
		aOther.NotifyStartedCuffing();
	}
}


///////////////////////////////////////////////////////////////////////////////
// ServerHandcuffCaptiveStop
//
function ServerHandcuffCaptiveStop(
	SASPawn	aOther )
{
	if ( (Role == ROLE_Authority) && (aOther != None) )
	{
		aOther.NotifyStoppedCuffing();
	}
}


///////////////////////////////////////////////////////////////////////////////
// ServerHandcuffCaptiveComplete
//
function ServerHandcuffCaptiveComplete(
	SASPawn	aHandcuffed )
{
	if ( (Role == ROLE_Authority) && (aHandcuffed != None) )
	{
		aHandcuffed.MakeCaptive( self );
	}
}


///////////////////////////////////////////////////////////////////////////////
// ServerDisarmHostage
//
function ServerDisarmHostage(
	SASHostage	aDisarmed )
{
	if ( (Role == ROLE_Authority) && (aDisarmed != None) )
	{
		aDisarmed.DisarmExplosive();
	}
}


///////////////////////////////////////////////////////////////////////////////
// ServerOrderTerroristDown
//
function ServerOrderTerroristDown(
	SASTerrorist	aOrdered )
{
	local SASTerroristController	TC;

	if ( (Role == ROLE_Authority) && (aOrdered != None) )
	{
		mSASPawn.PlaySpeech( SPEECH_SquadHostageGetDown );
		
		if ( aOrdered.Controller != None )
		{
			TC = SASTerroristController( aOrdered.Controller );
			if ( TC != None )
			{
				TC.DoOrderedDown();
			}
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// ServerOrderHostageDown
//
function ServerOrderHostageDown(
	SASHostage	aOrdered )
{
	OrderHostageDown( aOrdered );
}


function OrderHostageDown(
	SASHostage		aOrdered,
	optional int	aOrderInt )
{
	local SASHostageController	HC;

	if ( (Role == ROLE_Authority) && (aOrdered != None) )
	{
		if ( mSquadManager != None )
		{
			mSquadManager.playerShoutAtHostage();
		}

		mSASPawn.PlaySpeech( SPEECH_SquadHostageGetDown );

		if ( aOrdered.Controller != None )
		{
			HC = SASHostageController( aOrdered.Controller );
			if ( HC != None )
			{
				HC.PlayerOrder( HOSTAGEORDER_Follow, None );
				HC.PlayerOrder( HOSTAGEORDER_GetDown, mSASPawn, aOrderInt );
			}
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// ServerOrderRadiusHostagesDown
//
function ServerOrderRadiusHostagesDown()
{
	local SASHostage	hostage;

	if ( Role == ROLE_Authority ) 
	{
		foreach mSASPawn.GetGame().RadiusSASPawns( class'SASHostage', hostage, mSASPawn.Location, 500.0 )
		{
			OrderHostageDown( hostage, 1 );
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// ServerOrderHostageFollow
//
function ServerOrderHostageFollow(
	SASHostage	aOrdered,
	bool		abFollow )
{
	if ( (Role == ROLE_Authority) && (aOrdered != None) )
	{
		HostageFollowPlayer( aOrdered, abFollow );
	}
}


///////////////////////////////////////////////////////////////////////////////
// ServerOrderRadiusHostagesFollow
//
function ServerOrderRadiusHostagesFollow(
	bool	abFollow )
{
	local SASHostage			hostage;

	if ( Role == ROLE_Authority ) 
	{
		foreach mSASPawn.GetGame().RadiusSASPawns( class'SASHostage', hostage, mSASPawn.Location, 500.0 )
		{
			HostageFollowPlayer( hostage, abFollow, 1 );
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// HostageFollowPlayer
//
function HostageFollowPlayer(
	SASHostage		aHostage,
	bool			abFollow,
	optional int	aOrderInt )
{
	local SASHostageController	HC;

	if ( aHostage.Controller != None )
	{
		HC = SASHostageController( aHostage.Controller );
		if ( HC != None )
		{
			if ( abFollow )
			{
				HC.PlayerOrder( HOSTAGEORDER_Follow, mSASPawn, aOrderInt );
			}
			else
			{
				HC.PlayerOrder( HOSTAGEORDER_Follow, None, aOrderInt );
			}
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// PlayerTick
//
function PlayerTick (
	float	aDeltaTime)
{
	//local vector	tOffset;
	local SASHUD	hud;

	// if there's no pawn then quit now.
	if ( Pawn == None )
	{
		Super.PlayerTick (aDeltaTime);
		return;
	}

	// maybe play a movie
	if (Level.GetLocalPlayerController() == self)
	{
		// Check if button has been pressed to start the level.
		if ( !mPressedButtonToStart )
		{
			// Is button press required? (Not in multiplayer)
			if ( !Level.ShouldPressButtonToStart() )
			{
				// flag that button has been pressed if it's not required.
				mPressedButtonToStart = true;
			}
			else if ( !mDisplayingButtonPressToStartPrompt )
			{
				StartUpFrontEnd(2);
				mDisplayingButtonPressToStartPrompt = true;
			}
		}
		// we'll allow the level to warm up before playing the movie.
		// And don't play it in multiplayer
		if (	mPressedButtonToStart &&
				Level.TimeSeconds > 0.001 && 
				!mMovieIntroDone && Level.ShouldPlayStartupMovie() )
		{
			// there's a movie to be played.
			
			// Has one been started?
			if (mMovieIntroStarted)
			{
				if (!myHud.IsMoviePlaying())
				{
					// well, it must have finished.
					mMovieIntroDone = true;
				}
			}
			else
			{
				// let's start a movie.
				myHud.PlayMovieDirect(Level.StartupMovie$".bik", 0, 0, true, false);
				
				mMovieIntroStarted = true;
			}
		}

		if ( !mPressedButtonToStart )
		{
			SetPause( true );
		}
		else if (myHud.IsMoviePlaying())
		{
			SetPauseInternal( true );
		}
	}
	
	// JS in demo playback, go to behind view.
	if(DemoPlaying())
	{
		if(!bBehindView)
		{
			bBehindView=true;
		}
		hud=SASHUD ( myHUD );
		if ( hud != None )
		{
			hud.ShowHUD ( false );
		}
	}
	
	Super.PlayerTick (aDeltaTime);	
		
	/*
	   Send a packet to the server every 20secs
	   saying the player is playing "$"level..
		   
	*///NetCommuntiy Stats	
	
	SASMPPlayerBroadcastOnlineStatus(aDeltaTime);
		
	ProcessReticule();
	ProcessAssaultVolume();
	ProcessSquad ();
	ProcessBreathing();
	ProcessCharge( aDeltaTime );
	ProcessActionMenu( aDeltaTime );
	ProcessLeaning();
}


function PlayScriptedMovie( string videoName )
{
	local Controller			C;
	local SASPlayerController	otherPC;

	LocalPlayScriptedMovie( videoName );

	for ( C = Level.ControllerList; C != None; C = C.nextController )
	{
		if ( C != self && C.mType == CONTROLLER_Player )
		{
			otherPC = SASPlayerController( C );
			otherPC.ClientPlayScriptedMovie( videoName );
		}
	}
}


function ClientPlayScriptedMovie( 
	string videoName )
{
	LocalPlayScriptedMovie( videoName );
}


function LocalPlayScriptedMovie(
	string	videoName )
{
	if ( len(videoName) != 0 )
	{
		if( myHud == None )
		{
			SpawnDefaultHUD();
		}

		// Turn of night vision
		if ( mbIsNightVision )
		{
			NightVision();
		}

		myHud.PlayMovieDirect( videoName$".bik", 50,50, true,false);
		mMovieScriptedStarted	= true;
		mMovieScriptedDone		= false;
		SetPauseInternal ( true );
	}
}

function bool IsScriptedMoviePlaying()
{
	return myHud.IsMoviePlaying();
}

function GetOutOfMatineeIfStopped()
{
	if (!myHud.IsMoviePlaying())
	{
		// well, it must have finished.
		mMovieIntroDone = true;
		SetPause(false);
	}
}

event PausedTick(float deltatime)
{
	// do some stuff.
	if (bOutOfBodyCam)
	{
		PlayerTick(deltatime);
	}
	
	if (!mMovieIntroDone && mMovieIntroStarted)
	{
		// if he's pressed the action button...
		if (bAction != 0)
		{
			// let's kill the movie on that
			bAction = 0;
			
			myHUD.StopMovie();
		}
		
		// we need to get out of the matinee if he's pressed the button or if it's simply finished.
		GetOutOfMatineeIfStopped();
	}

	if (mMovieScriptedStarted && !mMovieScriptedDone )
	{
		if ( !myHud.IsMoviePlaying() )
		{
			mMovieScriptedDone = true;
			SetPauseInternal( false );
		}
	}
}


//------------------------------------------------------------------------------
// ChangedAssaultVolume
//
simulated function ChangedAssaultVolume(
	SASSoldier			aPlayerPawn,
	SASAssaultVolume	aPrevVolume )
{
	local SASSoldier			wingman;
	local SASSoldierController	sc;

	if ( (aPlayerPawn != None) && (aPrevVolume != None) )
	{
		// Tell squad that we've changed AV.
		if ( Level.Netmode == NM_StandAlone )
		{
			if ( mSquadManager != None && mSquadManager.mNumAISquadMembers > 0 )
			{
				mSquadManager.PlayerChangedAssaultVolumes ( aPlayerPawn, aPrevVolume );

				// If we're on an interior assault (ie our wingman has started an assault) then we might give him a
				// random generic order
				wingman = mSquadManager.GetPlayersWingman( SASSoldier( Pawn ) );
				if ( wingman != None )
				{
					sc = SASSoldierController( wingman.Controller );
					if ( sc != None && sc.mWingmanAssaultVolume != None )
					{
						SASSoldier( Pawn ).PlaySpeech(SPEECH_SquadOrderWingman);
					}
				}
			}
		}

		// Tell hostages we've changed AV (only server needs to do this).
		if ( Role == ROLE_Authority )
		{
			class'SASHostageController'.static.PlayerChangedAssaultVolumes( aPlayerPawn, aPrevVolume ); 
		}
	}
}


//------------------------------------------------------------------------------
// AllocateWingman
//
function AllocateWingman(
	SASSoldier	aPlayerPawn )
{
	if ( mSquadManager.CanAllocateWingman (aPlayerPawn) )
	{
		mSquadManager.AllocateWingman ( aPlayerPawn );
	}
}


//------------------------------------------------------------------------------
// ProcessCharge
//
simulated event ProcessCharge( 
	float	aDeltaTime )
{
	local float	recharge,
				tmp;
	local bool	bCanCharge;

	if (	(bRun == 1) && 
			(bDuck == 0) && 
			(Pawn.Acceleration.X != 0.0 || Pawn.Acceleration.Y != 0.0) )
	{
		if ( Role == ROLE_Authority )
		{
			bCanCharge = !mbChargeDisabled;
		}
		else
		{
			bCanCharge = mbChargeAvailable;
		}

		mChargeAmount -= mChargeDischargeRate * aDeltaTime;

		if ( mbChargeAvailable && mChargeAmount > 0.0 )
		{
			// Server sets charging pace.
			if ( Role == ROLE_Authority )
			{
				// Tell client owner that charge is available.
				mbChargeAvailable = true;

				Pawn.SetPace( PACE_Charging );
			}
			return;
		}
		mChargeAmount = 0.0;
	}
	else if ( mChargeAmount < 1.0 )
	{
		tmp = FMax( mChargeAmount, 0.5 );
		recharge = (mChargeRechargeRate * aDeltaTime) * Square( tmp );
		mChargeAmount += recharge;

		mChargeAmount = FMin( mChargeAmount, 1.0 );
	}

	// Server sets pace back to running when not charging.
	if ( Role == ROLE_Authority )
	{
		// Tell the client owner if charge is available or not.
		if ( !mbChargeDisabled && mChargeAmount > 0.0 )
		{
			mbChargeAvailable = true;
		}
		else
		{
			mbChargeAvailable = false;
		}

		if ( Pawn != None && Pawn.mePace == PACE_Charging )
		{
			Pawn.SetPace( PACE_Running );
		}
	}
}


simulated function ProcessLeaning()
{
	if ( aLeanDir < 0.0 && aOldLeanDir >= 0.0 )
	{
		mSASPawn.ServerSetLean( LEAN_Left );
	}
	else if ( aLeanDir > 0.0 && aOldLeanDir <= 0.0 )
	{
		mSASPawn.ServerSetLean( LEAN_Right );
	}
	else if ( aLeanDir == 0.0 && aOldLeanDir != 0.0 )
	{
		mSASPawn.ServerSetLean( LEAN_None );
	}
	aOldLeanDir = aLeanDir;
}


///////////////////////////////////////////////////////////////////////////////
// HandleWalking
//
function HandleWalking()
{
	if ( Pawn != None )
	{
		if ( bRun != 0 && mbChargeAvailable )
		{
			Pawn.SetPace( PACE_Charging );
		}
		else
		{
			Pawn.SetPace( PACE_Running );
		}
	}
}

 
///////////////////////////////////////////////////////////////////////////////
// ProcessActionMenu
//
simulated function ProcessActionMenu(
	float	aDeltaTime )
{
	local SASHUD	HUD;

	HUD = SASHUD (myHud);
	if (HUD != None)
	{
		HUD.UpdateActionMenu (aDeltaTime);
	} // if
}


///////////////////////////////////////////////////////////////////////////////
// RenderOverlays
//
simulated event RenderOverlays(
	Canvas aCanvas)
{
	local int				i;
	local SASScreenFlash	flash;
	local Color				flashCol;
	local float				timePct;
	local float				alpha;

	// Draw screen flashes
	if (mScreenFlashes.Length > 0)
	{
		for (i = 0; i < mScreenFlashes.Length; ++i)
		{
			flash = mScreenFlashes[i];

			timePct = FMax(((Level.TimeSeconds - flash.StartTime) / flash.Duration), 0.0);
			if (timePct >= 1.0)
			{
				mScreenFlashes.Remove(i,1);
				i--;
				continue;
			}

			switch(flash.Type)
			{
			case SASSF_WHITEOUT:
				flashCol = class'Canvas'.Static.MakeColor(255,255,255,flash.MaxAlpha);
				break;

			case SASSF_DAMAGED:
				flashCol = class'Canvas'.Static.MakeColor(255,0,0,flash.MaxAlpha);
				break;
			}

			if (timePct < flash.FadeUpPct)
			{
				alpha = flashCol.A * (timePct / flash.FadeUpPct);
			}
			else
			{
				if (flash.FadeUpPct == 1.0)
				{
					alpha = 0.0;
				}
				else
				{
					alpha = flashCol.A * (1.0 - ((timePct - flash.FadeUpPct) / (1.0 - flash.FadeUpPct)));
					alpha = FMax(alpha, 0.0);
				}
			}

			aCanvas.Style = ERenderStyle.STY_Alpha;
			aCanvas.DrawColor = flashCol;
			aCanvas.DrawColor.A = alpha;
			aCanvas.SetPos(0,0);
			aCanvas.DrawTile(Texture'SFXTx.WhiteTex', aCanvas.ClipX, aCanvas.ClipY, 0, 0, 128, 128);
		}
	}

	// Draw screen fade
	if (mScreenFade.bActive)
	{
		timePct = FMax(((Level.TimeSeconds - mScreenFade.StartTime) / mScreenFade.FadeTime), 0.0);
		if (timePct >= 1.0)
		{
			timePct = 1.0;

			if (mScreenFade.bFadeUp)
			{
				mScreenFade.bActive = false;
			}
		}

		if (mScreenFade.bFadeUp)
		{
			alpha = 255.0 * (1.0 - timePct);
		}
		else
		{
			alpha = 255.0 * timePct;
		}

		if (alpha > 0.0)
		{
			aCanvas.Style = ERenderStyle.STY_Alpha;
			aCanvas.DrawColor = mScreenFade.FadeColour;
			aCanvas.DrawColor.A = alpha;
			aCanvas.SetPos(0,0);
			aCanvas.DrawTile(Texture'SFXTx.WhiteTex', aCanvas.ClipX, aCanvas.ClipY, 0, 0, 128, 128);
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// FlashScreen
//
//::simulated function FlashScreen(
//::	eScreenFlashType	aFlashType,
//::	float				aFlashMaxAlpha,
//::	float				aFlashDuration,
//::	float				aFadeUpPct)
//::{
//::	local int				i;
//::	local int				existingFlashIdx;
//::	local SASScreenFlash	flash;
//::
//::	// Is there already a flash of this type in list?
//::	existingFlashIdx = -1;
//::	for (i = 0; i < mScreenFlashes.Length; ++i)
//::	{
//::		if (mScreenFlashes[i].Type == aFlashType)
//::		{
//::			existingFlashIdx = i;
//::			break;
//::		}
//::	}
//::
//::	// HACK: Replacing old flash with new one.
//::	// Need to do something to blend new flash with old one.
//::
//::	if (existingFlashIdx != -1)
//::	{
//::		mScreenFlashes[i].MaxAlpha		= aFlashMaxAlpha;
//::		mScreenFlashes[i].Duration		= aFlashDuration;
//::		mScreenFlashes[i].FadeUpPct		= aFadeUpPct;
//::		mScreenFlashes[i].StartTime		= Level.TimeSeconds;
//::	}
//::	else
//::	{
//::		flash.Type			= aFlashType;
//::		flash.MaxAlpha		= aFlashMaxAlpha;
//::		flash.Duration		= aFlashDuration;
//::		flash.FadeUpPct		= aFadeUpPct;
//::		flash.StartTime		= Level.TimeSeconds;
//::
//::		mScreenFlashes[mScreenFlashes.Length] = flash;
//::	}
//::}


///////////////////////////////////////////////////////////////////////////////
// DoScreenWhiteOut
//
//::simulated function DoScreenWhiteOut(
//::	float	aFlashIntensity)
//::{
//::	local float	flashDuration;
//::	local float fadeUpPct;
//::	local float flashMaxAlpha;
//::
//::	if (aFlashIntensity > 0.0)
//::	{
//::		aFlashIntensity = FMin(aFlashIntensity, 1.0);
//::		flashDuration = Lerp(aFlashIntensity, 1.0, 3.0);
//::		fadeUpPct = 0.0;
//::		flashMaxAlpha = aFlashIntensity * 200.0;
//::
//::		FlashScreen(SASSF_WHITEOUT, flashMaxAlpha, flashDuration, fadeUpPct);
//::	}
//::}


///////////////////////////////////////////////////////////////////////////////
// FadeScreen
//
simulated function FadeScreen(
	Color	aFadeCol,
	float	aFadeTime,
	bool	abFadeUp)
{
	mScreenFade.FadeColour	= aFadeCol;
	mScreenFade.FadeTime	= aFadeTime;
	mScreenFade.bFadeUp		= abFadeUp;
	mScreenFade.StartTime	= Level.TimeSeconds;
	mScreenFade.bActive		= true;
}

//------------------------------------------------------------------------------
//
//
function Rotator CameraRotationModify ( float aDeltaTime, Rotator aCurRot )
{
	////////////////////////////////////////////////////////////////////////////////
	// strafe tilt
	if ( aStrafe == 0 )
	{
		mCurrentStrafeTilt *= mStrafeTiltSpeed * aDeltaTime * 0.2;
	}
	else
	{
		mCurrentStrafeTilt += mStrafeTiltSpeed * aDeltaTime * aStrafe;
	}

	if ( mCurrentStrafeTilt >= mMaxStrafeTilt )
	{
		mCurrentStrafeTilt = mMaxStrafeTilt;
	}
	else if ( mCurrentStrafeTilt <= -mMaxStrafeTilt )
	{
		mCurrentStrafeTilt = -mMaxStrafeTilt;
	}

	aCurRot.Roll += mCurrentStrafeTilt - mPrevStrafeTilt;
	mPrevStrafeTilt = mCurrentStrafeTilt;

	if ( mSASPawn != None )
	{
		aCurRot.Roll = mSASPawn.mCurrentLeanTilt;
	}
	else
	{
		aCurRot.Roll = 0;
	}


	////////////////////////////////////////////////////////////////////////////////
	// attitude change on charge
	if ( Pawn != None && Pawn.mePace == PACE_Charging )
	{
		if ( mCurrentChargeTilt < mMaxChargeTilt )
		{
			mCurrentChargeTilt += mChargeTiltSpeed * aDeltaTime * 100.0;
			mCurrentChargeTilt = FClamp ( mCurrentChargeTilt, 0.0, mMaxChargeTilt );
			aCurRot.Pitch += mCurrentChargeTilt;
		}
	}
	else if ( mCurrentChargeTilt > 0 )
	{
		mCurrentChargeTilt -= mChargeTiltSpeed * aDeltaTime * 100.0;
		mCurrentChargeTilt = FClamp ( mCurrentChargeTilt, 0.0, mMaxChargeTilt );
		aCurRot.Pitch -= mCurrentChargeTilt;
	}

	if ( mbIsFreeView )
	{
		UpdateFreeView ( aDeltaTime );
	}

	return aCurRot;
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// RecordDemo
//
//::function RecordDemo()
//::{
//::	if(!Level.HideFromMenus)
//::	{
//::		StopDemo();
//::		bDemoRecording=true;
//::		Log ("SASPlayerController: Recording demo");
//::		ConsoleCommand("demorec current");
//::	}
//::}


///////////////////////////////////////////////////////////////////////////////
// PlayDemo
//
//::function PlayDemo()
//::{
//::	StopDemo();
//::	Log("SASPlayerController: Playing demo");
//::	ConsoleCommand("demoplay current loop");
//::}

execrelease function DoFlashbangCamEffect()
{
	if (Pawn == None)
	{
		return;
	}
	mfFlashbangCamEffectFadeoutTime = 3.0;
	TakeSnapShotAndFadeOut( true );	
	if ( mFlashbangCamEffect != None )
		mFlashbangCamEffect.fFadeTime = 3.0;
}

//-----------------------------------------------------------------------------
// Take Snapshot and fade of slowly
//
// 
function TakeSnapShotAndFadeOut ( bool onoff )
{
	// ensure we have the effect handy
	if ( mFlashbangCamEffect == None )
	{
		mFlashbangCamEffect = new class'FlashbangCameraEffect';
	}
	
	// But we might have removed the effect from the list of camera effects, to stop it constantly taking framerate.
	// So let's add it back in.
	AddCameraEffect ( mFlashbangCamEffect, false, false );

	if ( ( mFlashbangCamEffect != None ) && ( Pawn != None ) )
	{
		// toggle off
		if ( mbIsFlashbangCamEffectOn && !onoff )
		{
			mbIsFlashbangCamEffectOn= false;

			Pawn.LightType			= LT_None;
			Pawn.LightCone			= 0;

			Pawn.bDynamicLight		= false;

			Pawn.LightHue			= 0;
			Pawn.LightBrightness	= 0;
			Pawn.LightSaturation	= 0;
			Pawn.LightRadius		= 0;

			RemoveCameraEffect ( mFlashbangCamEffect );
		}
		// toggle on
		if( onoff )
		{
			mbIsFlashbangCamEffectOn= true;

			Pawn.LightType			= LT_Steady;
			Pawn.LightCone			= 128;

			Pawn.bDynamicLight		= true;

			mFlashbangCamEffect.SetSnapShotMode(1);
			mFlashbangCamEffect.TakeScreenGrab();
			//AddCameraEffect ( mFlashbangCamEffect, false, false );
		}
	}
}


//-----------------------------------------------------------------------------
// PlayTinnitusSound
//
simulated function PlayTinnitusSound(
	Vector	aExplosionLocation )
{
	local float distSq,
				volume;

	if ( mTinnitusSound == None || Level.TimeSeconds - mTinnitusLastTime < 5.0 )
	{
		return;
	}

	distSq = VSizeSq( aExplosionLocation - Pawn.Location );
	if ( distSq > Square( 500.0 ) )
	{
		return;
	}

	volume = 1.0 - (distSq / Square( 500.0 ));

	mTinnitusLastTime = Level.TimeSeconds;
	Pawn.PlaySound( mTinnitusSound, SLOT_Misc, volume );
}


//-----------------------------------------------------------------------------
// NightVision
//
// The player wants to toggle night vision goggles
execrelease function NightVision ()
{
	local PlayerController P;
	P = Level.GetLocalPlayerController();

	// Not when scripted move is playing.
	if ( mMovieScriptedStarted	&& !mMovieScriptedDone )
	{
		return;
	}
	
	// ensure we have the effect handy
	if ( mNightVisionEffect == None )
	{
		mNightVisionEffect = new class'NightVision';
	}

	if ( ( mNightVisionEffect != None ) && ( Pawn != None ) )
	{
		// toggle off
		if ( mbIsNightVision )
		{
			mbIsNightVision	= false;

			Pawn.LightType			= LT_None;
			Pawn.LightCone			= 0;

			Pawn.bDynamicLight		= false;

			Pawn.LightHue			= 0;
			Pawn.LightBrightness	= 0;
			Pawn.LightSaturation	= 0;
			Pawn.LightRadius		= 0;
			
			P.fPercentageFogReduction = 1.0;

			RemoveCameraEffect ( mNightVisionEffect );
		}
		// toggle on
		else
		{
			mbIsNightVision	= true;

			Pawn.LightType			= LT_Steady;
			Pawn.LightCone			= 128;

			Pawn.bDynamicLight		= true;

			Pawn.LightHue			= mNightVisionEffect.Hue;
			Pawn.LightBrightness	= mNightVisionEffect.Brightness;
			Pawn.LightSaturation	= mNightVisionEffect.Saturation;
			Pawn.LightRadius		= mNightVisionEffect.Radius;

			//mNightVisionEffect.SetSnapShotMode(1);
			//mNightVisionEffect.TakeScreenGrab();
			P.fPercentageFogReduction = 0.8;
			
			AddCameraEffect ( mNightVisionEffect, false, false );
		}
	}
}

//------------------------------------------------------------------------------
// motion blur
//
execrelease function MotionBlur ( bool aState )
{
	SetMotionBlur ( aState );
}
simulated function SetMotionBlur ( bool aState )
{
	// ensure we have the effect handy
	if ( mMotionBlurEffect == None )
	{
		mMotionBlurEffect = new class'MotionBlur';

		if ( mMotionBlurEffect != None )
		{
			mMotionBlurDecayIndex = AddMultiTimer ();
		}
	}

	if ( mMotionBlurEffect != None )
	{
		if ( aState )
		{
			AddCameraEffect ( mMotionBlurEffect, false, false );
			SetMultiTimer ( mMotionBlurDecayIndex, MOTIONBLUR_DECAYRATE, true );
		}
		else
		{
			RemoveCameraEffect ( mMotionBlurEffect );
			StopMultiTimer ( mMotionBlurDecayIndex );
		}
		mMotionBlurEffect.BlurAlpha = MOTIONBLUR_ALPHALIMIT;
	}
}

function ClientStartMissionEndEffect()
{
	StartMissionEndEffect();
}

simulated function StartMissionEndEffect()
{
	SetMotionBlur ( true );
	StopMultiTimer ( mMotionBlurDecayIndex );
	if ( mMotionBlurEffect != None )
	{
		mMotionBlurEffect.BlurAlpha = 30;
	}

	// get failed mission texture up
	myHud.GotoState ( 'StatsScreen' );

	// add fade
	FadeScreen ( class'Canvas'.Static.MakeColor(0,0,0), 3, false );
}


//------------------------------------------------------------------------------
// bloom
//
exec function Bloom ( bool aState )
{
	SetBloom ( aState );
}
simulated function SetBloom ( bool aState )
{
	// ensure we have the effect handy
	if ( mBloomEffect == None)
	{
		mBloomEffect = new class'Bloom';
	}

	if ( mBloomEffect != None)
	{
		if ( aState && !mbIsBloom )
		{
			AddCameraEffect ( mBloomEffect, true, false );
			mbIsBloom = true;
		}
		else if ( !aState && mbIsBloom )
		{
			RemoveCameraEffect ( mBloomEffect );
			mbIsBloom = false;
		}
	}
}

execrelease function Fade ( bool aState)
{
	SetFade ( aState );
}
simulated function SetFade ( bool aState )
{
	if ( mFadeOutEffect == None )
	{
		mFadeOutEffect = new class'FadeOut';
	}
	if ( mFadeOutEffect != None )
	{
		if ( aState )
		{
			AddCameraEffect ( mFadeOutEffect, false, false );
		}
		else
		{
			RemoveCameraEffect ( mFadeOutEffect );
		}
	}
}

//------------------------------------------------------------------------------
// SASPause
//
// function triggered by mapped pause button (e.g. <ESC> ...)
// passes through objectives string & radio log string to pause menu
execrelease event SASPause ()
{
	local String			strObjectives;
	local String			strRadioLog;
	local SASGRI			gri;

	if (mMovieIntroStarted)
	{
		mMovieIntroDone = True;
		mMovieIntroStarted = False;
		myHUD.StopMovie();
	}
	
	if (bOutOfBodyCam)
	{
		// don't set up the menu and such, just pause the game
	}
	else
	{
		gri = SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo );
		if ( ( gri != None ) && ( gri.mObjectiveManager != None ) )
		{
			// build objectives string
			strObjectives = gri.mObjectiveManager.GetObjectiveMessages ();

			// build radio log string
			strRadioLog = gri.GetRadioLogMessages ();
		}
	}

	// Pause if not already
	if ( Level.Pauser == None )
	{
		SetPause ( true );
	}

	StopForceFeedback ();  // jdf - no way to pause feedback

	if (!bOutOfBodyCam)
	{
		// Open menu
		ClientOpenMenu ( "SASGUI.SASPauseMenu", false, strObjectives, strRadioLog );
	}
}

execrelease function SoundSelect ()
{
	Pawn.PlaySound ( Sound'GUI.Base.GUISelect', SLOT_Interface, 1, true );
}
execrelease function SoundMove ()
{
	Pawn.PlaySound ( Sound'GUI.Base.GUIMove', SLOT_Interface, 1, true );
}
execrelease function SoundBack ()
{
	Pawn.PlaySound ( Sound'GUI.Base.GUIBack', SLOT_Interface, 1, true );
}
// fscommand("SoundBack", "");

simulated event InitBulletCam(
	Vector			aBulletStart,
	Vector			aBulletEnd,
	SASPawn			aInstigator,
	SASPawn			aKilled,
	optional bool	abKnifed )
{
	local float		time; 
	local vector	camEndPos;
	local Controller	C;

	if ( mbBulletCamActive )
	{
		return;
	}

	mBulletCamVictim			= aKilled;

	// Hide instigator pawn.
	aInstigator.bHidden = true;

	// Setup motion blur.
	SetMotionBlur( true );
	StopMultiTimer( mMotionBlurDecayIndex );
	if ( mMotionBlurEffect != None )
	{
		mMotionBlurEffect.BlurAlpha = 30;
	}

	mBulletCamInitDir = aBulletEnd - aBulletStart;
	mBulletCamTotDist = VSize( mBulletCamInitDir );
	if ( mBulletCamTotDist > 0.0 )
	{
		mBulletCamInitDir = mBulletCamInitDir / mBulletCamTotDist;
	}

	// If starting off close to the end point. Don't move, just play the 'hit' slomo.
	if ( abKnifed || mBulletCamTotDist < 48.0 )
	{
		mBulletCamTotDist = 0.0;
	}
	else
	{
		// Stop bullet cam in front of hit point.
		mBulletCamTotDist -= 16.0;
	}
	
	// Push bullet start loc forward a bit.
	// TODO: Change to push bullet fwd if instigator is not player, else do bullet cam in 1st person mode.
	mBulletCamStart = aBulletStart;// + (dir * 8.0);
	//mBulletCamTotDist -= 8.0;

	// Calc bullet speed.
	if ( mBulletCamTotDist > 0.0 )
	{
		mBulletCamSpeed = BULLETCAM_OPTIMUM_SPEED;
		time = mBulletCamTotDist / mBulletCamSpeed;
		if ( time > BULLETCAM_MAX_TIME )
		{
			mBulletCamSpeed = mBulletCamTotDist / BULLETCAM_MAX_TIME;
		}
		else if ( time < BULLETCAM_MIN_TIME )
		{
			mBulletCamSpeed = mBulletCamTotDist / BULLETCAM_MIN_TIME;
		}
	}

	LocalInitBulletCam();

	// Tell clients to play bulletcam.
	if ( Level.NetMode != NM_Standalone )
	{
		camEndPos = mBulletCamStart + (mBulletCamInitDir * mBulletCamTotDist);

		for ( C = Level.ControllerList; C != None; C = C.nextController )
		{
			if ( C != self && C.mType == CONTROLLER_Player )
			{
				SASPlayerController( C ).ClientPlayBulletCam( 
					mBulletCamVictim,
					mBulletCamStart,
					camEndPos,
					mBulletCamSpeed );
			}
		}
	}
}

function ClientPlayBulletCam(
	SASPawn	camVictim,
	Vector	camStartPos,
	Vector	camEndPos,
	float	camSpeed )
{
	mBulletCamVictim = camVictim;
	mBulletCamStart = camStartPos;
	mBulletCamSpeed = camSpeed;

	mBulletCamInitDir = camEndPos - camStartPos;
	mBulletCamTotDist = NormalizeAndGetLength( mBulletCamInitDir );

	LocalInitBulletCam();
}	


simulated function LocalInitBulletCam()
{
	mbBulletCamActive			= true;
	mbBulletCamComplete			= false;
	mBulletCamTimer				= 0.0;
	mBulletCamLastUpdateTime	= 0.0;
	mBulletCamCurDist			= 0.0;
	mBulletCamCurRot			= Rotator( mBulletCamInitDir );

	// Stop stats screen activating until cam has completed. 
	SASHUD(myHud).mbStatsScreenActivated = false;

	// Don't show pause message while paused.
	myHud.PausedMessage = "";
	SetPauseInternal( true );

	// Setup motion blur.
	SetMotionBlur( true );
	StopMultiTimer( mMotionBlurDecayIndex );
	if ( mMotionBlurEffect != None )
	{
		mMotionBlurEffect.BlurAlpha = 30;
	}

	// Init roll rotation data.
	mBulletCamRotSpeed = 0.0;
	mBulletCamRotDir = 1;
	if ( FRand() < 0.5 )
	{
		mBulletCamRotDir *= -1;
	}
	UpdateBulletCamRotTarget();
}

	

simulated function UpdateBulletCamRotTarget()
{
	mBulletCamRotDir *= -1;
	mBulletCamRotTgt = RandRange( BULLETCAM_MIN_ROT, BULLETCAM_MAX_ROT ) * mBulletCamRotDir;
}

function ClientRestartLevelTime()
{
	if ( GameReplicationInfo != None && SASGRI( GameReplicationInfo ) != None )
	{
		SASGRI( GameReplicationInfo ).TimeRestart();
	}
}

function ClientResetLevel()
{
	local SASPawn				tPawn;
	local SASProjectedDecal		tDecal;
	local SASBulletHit			tBulletHit;
	local SASExpandingProjector	tProjector;
	local SASGenericExplosion	tExplo;
	local SASDoorMover			tDoor;
	local KActor				tKActor;
	local SASDamageableMesh		tDamageableMesh;

	mChargeAmount = 1.0;
	mbChargeAvailable = true;

	// Destroy all simulated pawns.
	foreach AllActors( class 'SASPawn', tPawn )
	{
		if ( tPawn.bTearOff || tPawn.Role == ROLE_Authority )
		{
			tPawn.Destroy();
		}
	}

	// Destroy simulated effects.
	foreach AllActors( class'SASProjectedDecal', tDecal )
	{
		tDecal.Destroy();
	}
	foreach AllActors( class'SASBulletHit', tBulletHit )
	{
		tBulletHit.Destroy();
	}
	foreach AllActors( class'SASExpandingProjector', tProjector )
	{
		tProjector.Destroy();
	}
	foreach AllActors( class'SASGenericExplosion', tExplo )
	{
		tExplo.Destroy();
	}

	// Reset doors.
	foreach AllActors( class'SASDoorMover', tDoor )
	{
		tDoor.Reset();
	}
	// And karma objects.
	foreach AllActors( class'KActor', tKActor )
	{
		tKActor.Reset();
	}
	// And damagable meshes.
	foreach Allactors( class'SASDamageableMesh', tDamageableMesh )
	{
		tDamageableMesh.Reset();
	}

	if ( myHud != None )
	{
		// Reset scoreboard.
		if ( myHud.Scoreboard != None )
		{
			myHud.ScoreBoard.Reset();
		}

		// Reset action menu
		if ( SASHUD( myHUD ) != None && SASHUD( myHUD ).mActionMenu != None )
		{
			SASHUD( myHUD ).mActionMenu.Reset();
		}
	}
}


function ClientEndMission ()
{
	local SASHUD	h;

	// toggle night vision before the pawn is lost
	if ( mbIsNightVision )
	{
		NightVision ();
	}

	h = SASHUD(myHud);
	if ( h != None )
	{
		h.EndMission ();
	}

	GotoState( 'MissionEnd' );
}

//------------------------------------------------------------------------------
// ClientEndLevel
//
function ClientEndLevel ()
{
	if ( Level.Pauser != None )
	{
		SetPauseInternal ( false );
	}

	// toggle night vision before the pawn is lost
	if ( mbIsNightVision )
	{
		NightVision ();
	}
}

function DoRestart ()
{
// TCR Demo stuff (Uncomment this line)
	StopDemo();
	SwitchLevel("?restart");
}

//------------------------------------------------------------------------------
// ServerGoToMPMap
//
// Jump to map at a specified index in the map list. Sets new position in list
// for future map cycling.
function ServerGoToMPMap(
	int aMapListIndex )
{
	local string	NextMap;

	NextMap = SetMPMapListPosition( aMapListIndex );
	if ( NextMap != "" )
	{
		if ( Level.Game.mGameTypeId == 2 )
		{
			// Update the profile's campaign and mission index.
			SetProfileCampaignAndMissionFromMap( NextMap );
		}
		SwitchLevel( NextMap );
	}
}


function GoBackToFrontend()
{
	ConsoleCommand ( "start frontend" );
}

//::function MenuEndLevel ()
//::{
//::	local SASGameInfo	gi;
//::
//::	// if SASGameInfo object exists here then, implicitly, we're on the server,
//::	// otherwise we're on a client
//::	gi = SASGameInfo ( Level.Game );
//::	if ( gi != None )
//::	{
//::		// SASGameInfo only valid on the server, so control end from there ...
//::		gi.MenuEndLevel ();
//::	}
//::	else
//::	{
//::		// else must be a client!
//::		ConsoleCommand ( "start frontend" );
//::	}
//::}

function MenuAbortLevel ()
{
	ConsoleCommand ( "start frontend" );
}

function MenuQuit ()
{
	local SASGameInfo	gi;

	// if SASGameInfo object exists here then, implicitly, we're on the server,
	// otherwise we're on a client
	gi = SASGameInfo ( Level.Game );
	if ( gi != None )
	{
		// SASGameInfo only valid on the server, so control end from there ...
		gi.MenuEndLevel ();
	}
	// we actually *want* to quit but:
	// make everybody else return to frontend menu
	ConsoleCommand ( "exit" );
}

//::function MenuRestart ()
//::{
//::	local SASGameInfo	gi;
//::
//::// TCR Demo stuff (Uncomment this line)
//::	StopDemo();
//::
//::	// if SASGameInfo object exists here then, implicitly, we're on the server,
//::	// otherwise we're on a client
//::	gi = SASGameInfo ( Level.Game );
//::	if ( gi != None )
//::	{
//::		// SASGameInfo only valid on the server, so control end from there ...
//::		gi.MenuRestart ();
//::	}
//::	ConsoleCommand ( "restartlevel" );
//::}


simulated function ClientNotifyDamagableMeshStageChange(
	SASDamageableMesh	aDM,
	int					aNewStage,
	Vector				aEmitterDir )
{
	if ( aDM != None )
	{
		aDM.ClientStateChange( aNewStage, aEmitterDir );
	}
}

//------------------------------------------------------------------------------
// FindCameraEffect
//
simulated function int FindCameraEffect ( CameraEffect aEffect )
{
	local int	EffectIndex;

	for ( EffectIndex = 0; EffectIndex < CameraEffects.Length; EffectIndex++ )
	{
		if ( CameraEffects[EffectIndex] == aEffect )
		{
			return EffectIndex;
		}
	}
	return -1;
}

//------------------------------------------------------------------------------
// MultiTimerMotionBlurDecay
//
function MultiTimerMotionBlurDecay ()
{
	local float		tValue;
//	local vector	tVect;

	tValue = mMotionBlurEffect.BlurAlpha;
	tValue = tValue + 1;
	if ( tValue >= MOTIONBLUR_ALPHALIMIT )
	{
		tValue = MOTIONBLUR_ALPHALIMIT;
		StopMultiTimer ( mMotionBlurDecayIndex );
	}
	mMotionBlurEffect.BlurAlpha = tValue;

	//tVect = Player.Console.WorldToScreen(mTrackAct.Location);
	//MotionBlurEffect.ModgeScreenX = tVect.X;
	//MotionBlurEffect.ModgeScreenY = tVect.Y;
}

//------------------------------------------------------------------------------
// MultiTimer
//
// handle multi timer events by index
event MultiTimer ( int aIndex )
{
	switch ( aIndex )
	{
		case mMotionBlurDecayIndex:
			MultiTimerMotionBlurDecay ();
			break;

		default:
			Warn ( self $".illegal MultiTimer event #" $aIndex $" called!" );
			break;
	}
}

//------------------------------------------------------------------------------
// DecayMotionBlur
//
simulated function DecayMotionBlur ( float aNewAlpha )
{
	if ( ( mMotionBlurEffect != None ) && ( mMotionBlurEffect.BlurAlpha > aNewAlpha ) )
	{
		SetMultiTimer ( mMotionBlurDecayIndex, MOTIONBLUR_DECAYRATE, true );
		mMotionBlurEffect.BlurAlpha = aNewAlpha;
	}
}

//------------------------------------------------------------------------------
//
//
execrelease function SetModgeActor(Actor aTrackAct)
{
	mTrackAct = aTrackAct;
}

//------------------------------------------------------------------------------
//
//
event PostBeginPlay()
{
	Super.PostBeginPlay();

	SetupPlayerCameraEffects ();

	mbBulletCamActive = false;
}

//------------------------------------------------------------------------------
//
//
simulated event PostNetBeginPlay ()
{
	Super.PostNetBeginPlay ();

	SetupPlayerCameraEffects ();
}

//------------------------------------------------------------------------------
//
//
simulated function SetupPlayerCameraEffects ()
{
/*
	local SASPlayerController pc;

	pc = SASPlayerController ( Level.GetLocalPlayerController () );

	if ( pc == self )
	//if ( Role == ROLE_Authority )
	//if ( bIsPlayer )
	{
		Log ( self $".SetupPlayerCameraEffects: started here" );

		Bloom ( true );
		MotionBlur ( true );
		Log ( "MultiTimers: " @mMultiTimers.Length );
	}
*/
	SetMotionBlur ( true );
	SetBloom ( true );
}

//------------------------------------------------------------------------------
// PawnDied
//
function PawnDied ( Pawn aPawn )
{
	if ( aPawn == None || aPawn != Pawn )
	{
		return;
	}

	StopScreenEffects();

	Super.PawnDied ( aPawn );

	// I'm not going to issue the player died message here, but rather in player controller's dead state
}

function ClientDying(class<DamageType> DamageType, vector HitLocation)
{
	StopScreenEffects();
}

function StopScreenEffects()
{
	if ( Pawn != None && Pawn.Weapon != None )
	{
		Pawn.Weapon.DisplayFOV = 70;
	}

	// Turn off night vision.
	if ( mbIsNightVision )
	{
		NightVision();
	}
}
	

simulated event Destroyed()
{
	Super.Destroyed();

	ClientCloseMenu( true, true );
}

//------------------------------------------------------------------------------
//
//
exec function FreeView ()
{
	local SASHUD	hud;

	hud	= SASHUD ( myHUD );

	if ( mSASPawn == None )
	{
		return;
	}

	if ( mbIsFreeView )
	{
		bBehindView = false;
		mSASPawn.bSpecialCalcView = false;

		if ( hud != None )
		{
			hud.ShowHUD ( true );
		}
		mbIsFreeView = false;
	}
	else
	{
		bBehindView = true;
		mSASPawn.StartSpecialView ();
		mSASPawn.bSpecialCalcView = true;

		if ( hud != None )
		{
			hud.ShowHUD ( false );
		}
		mbIsFreeView = true;
	}
}

execrelease function Fire( optional float F )
{
	local bool bHandled;

	// Ignore fire until button has been pressed to start game.
	if ( !mPressedButtonToStart )
	{
		return;
	}
	
	if (myHud.IsMoviePlaying() && !mMovieIntroDone)
	{
		myHUD.StopMovie();
		GetOutOfMatineeIfStopped();
		bHandled = true;
	}
	
	if ( Level.Pauser == PlayerReplicationInfo )
	{
		SetPause(false);
		return;
	}

	if ( bHandled )
	{
		return;
	}

	if( bDemoOwner || (Pawn == None) )
		return;
    Pawn.Fire(F);
}

//------------------------------------------------------------------------------
//
//
simulated function UpdateFreeView ( float aDeltaTime )
{
	local vector	loc;
	local vector	X, Y, Z;
	local int		pitch,
					yaw;

	if ( mSASPawn != None )
	{
		pitch = ( mSASPawn.mSpecialRotation.Pitch + int ( aFreeRotY * aDeltaTime ) ) & MAX_ANGLE;
		if ( pitch > DEGREES_180 )
		{
			pitch -= DEGREES_360;
		}
		mSASPawn.mSpecialRotation.Pitch = pitch;

		yaw = ( mSASPawn.mSpecialRotation.Yaw + int ( aFreeRotX * aDeltaTime ) ) & MAX_ANGLE;
		if ( yaw > DEGREES_180 )
		{
			yaw -= DEGREES_360;
		}
		mSASPawn.mSpecialRotation.Yaw = yaw;

		GetAxes ( mSASPawn.mSpecialRotation, X, Y, Z );

		loc = mSASPawn.mSpecialLocation;

		loc += X * ( aFreeViewY * aDeltaTime );
		loc += Y * ( aFreeViewX * aDeltaTime );
		loc += Vect ( 0.0, 0.0, 1.0 ) * ( aFreeViewZ * aDeltaTime );

		mSASPawn.mSpecialLocation = loc;
	}
}


///////////////////////////////////////////////////////////////////////////////
// StopMoving
//
simulated function StopMoving ()
{
//	ServerStopMoving ();
//}
//function ServerStopMoving()
//{
	MoveTarget= None;

	if ( Pawn != None )
	{
		Pawn.Acceleration	= vect(0,0,0);
		Pawn.Velocity		= vect(0,0,0);
		Pawn.ChangeAnimation();
	}
}

//-----------------------------------------------------------------------------
// States
//

function EndClimbing();
simulated function InitClimbCam();
simulated function SetVaultWallEndPosition();
exec function ActionSelectLeft();
exec function ActionSelectRight();
exec function ActionSelectUp();
exec function ActionSelectDown();


state simulated PlayerClimbingObstacle
{
	ignores SeePlayer, 
			HearNoise, 
			NotifyBump,
			ActivateActionMenu,
			ProcessActionMenu,
			NextWeapon, 
			PrevWeapon, 
			Fire,
			AltFire,
			ToggleAiming,
			ForceReload,
			ProcessMove,
			PerfectlyNormalPlayerMove;

	// GPTODO: Prevent keyboard/mouse input (for everything except pause?)
	// How??

	simulated function ProcessReticule()
	{
		mReticuleTarget = None;
	}

	event BeginState()
	{
		bReplicateMovement = false;
		mbClimbCamActive = false;
		
		// the root motion physics won't work because physics is off for autonomous proxies
		bTurnPhysicsOnEvenThoughItsAnAutonomousProxy = true;
		Pawn.bTurnPhysicsOnEvenThoughItsAnAutonomousProxy = true;
	}

	event EndState()
	{
		bReplicateMovement = true;
		mClimbVolume		= None;
		mbClimbCamActive	= false;
		bRotateToDesired	= false;
		bTurnPhysicsOnEvenThoughItsAnAutonomousProxy = false;
		Pawn.bTurnPhysicsOnEvenThoughItsAnAutonomousProxy = false;

		// End RootMotionPhysics and climb animation.
		mSASPawn.EndPlayClimbing();
		
		// Bring up weapon.
		if ( (Pawn.Weapon != None) && (SASWeapon( Pawn.Weapon ) != None) )
		{
			SASWeapon( Pawn.Weapon ).MoveIntoView();
		}
	}

	simulated function EndClimbing()
	{
		GotoState( 'PlayerWalking' );
		if ( Level.NetMode != NM_StandAlone && Role == ROLE_Authority )
		{
			ClientEndClimbing();
		}
	}

	function ClientEndClimbing()
	{
		EndClimbing();
	}

	simulated function InitClimbCam()
	{
		local Coords headCoords;

		headCoords = Pawn.GetBoneCoords( HEAD_BONE );

		mClimbCamPrevRot = Rotator( -headCoords.YAxis );
		mClimbCamPrevRot.Yaw	= mClimbCamPrevRot.Yaw & 65535;
		mClimbCamPrevRot.Pitch	= mClimbCamPrevRot.Pitch & 65535;
		mClimbCamPrevRot.Roll	= mClimbCamPrevRot.Roll & 65535;

		mClimbCamOfsFromHeadBone = headCoords.Origin - (Pawn.Location + Pawn.EyePosition());

		mClimbCamLastUpdateTime = Level.TimeSeconds;
		mbClimbCamActive = true;
	}

	simulated function SetVaultWallEndPosition()
	{
		local float		distMovedInWallDir,
						desiredDist;
		local Vector	offset,
						wallDir,
						endPos;

		// Need to ensure player doesnt end up intersecting with wall.
		// This can occur due to inaccuracy of where pawn starts the vault
		// and in the root motion physics.
		
		// See if pawn has ended up farenough away from the wall.
		offset = Pawn.Location - mClimbStartPoint;
		wallDir = Vector(mClimbVolume.mWallDir);
		distMovedInWallDir = offset Dot wallDir;
		desiredDist = (Abs(mClimbVolume.CLIMBOFFSET_OverWall) * 2) + mClimbVolume.CLIMB_OVER_WALL_THICKNESS;

		if ( distMovedInWallDir < desiredDist )
		{
			endPos = Pawn.Location + (wallDir * (desiredDist - distMovedInWallDir));
			Pawn.SetLocation( endPos );
		}
	}

Begin:

	if ( mClimbVolume == None )
	{
		EndClimbing();
		Stop;
	}

	StopMoving();
	Pawn.RequestStance( STANCE_Standing );

	// Put weapon down if need hands to climb (any climb type except CLIMB_UpSmall)
	if ( (mClimbVolume.meClimbType != CLIMB_UpSmall) &&
		 (Pawn.Weapon != None) && (SASWeapon( Pawn.Weapon ) != None) )
	{
		SASWeapon( Pawn.Weapon ).MoveOutOfView();
	}

	// Get correct offset from wall.
	mClimbStartPoint = mClimbVolume.GetClimbStartPoint( mSASPawn );

	
		
	// Begin rotation to face wall.
	if (Level.NetMode == NM_StandAlone)
	{
		DesiredRotation = mClimbVolume.mWallDir;
		bRotateToDesired = true;

		MoveTo( mClimbStartPoint,,, PACE_Walking, true );
		StopMoving();

		// Wait for rotation to finish.
		FinishRotation();
		bRotateToDesired = false;

		// If failed to reach climb point (tends to happen with poor framerate) then try to teleport
		// to correct position.
		if ( !Pawn.ReachedPoint( mClimbStartPoint, true ) )
		{
			// Check there is nobody in the way of the point to teleport to first.
			// For clients just assume its clear, server does the test and if it fails tells the client to 
			// stop climbing.
			if ( Level.Game == None || !SASGameInfo( Level.Game ).IsPointBlockedByAPawn( mClimbStartPoint, mSASPawn ) )
			{
				Pawn.SetLocation( mClimbStartPoint );
			}
		}
	}
	else
	{
		// in the network game we're much less elegant

		// Check there is nobody in the way of the point to teleport to first.
		// For clients just assume its clear, server does the test and if it fails tells the client to 
		// stop climbing.
		if ( !Pawn.ReachedPoint( mClimbStartPoint, true ) )
		{
			if ( Level.Game == None || !SASGameInfo( Level.Game ).IsPointBlockedByAPawn( mClimbStartPoint, mSASPawn ) )
			{
				Pawn.SetLocation( mClimbStartPoint );
			}
		}
		Pawn.SetRotation( mClimbVolume.mWallDir );
	}

	if ( !Pawn.ReachedPoint( mClimbStartPoint, true ) )
	{
		EndClimbing();
		Stop;
	}
	
	InitClimbCam();

	// Do the climb using RootMotionPhysics.
	mSASPawn.PlayClimbing( mClimbVolume.meClimbType );
	FinishAnim( ANIMCHANNEL_ACTION );

	// Make sure pawn is in correct position after vaulting wall.
	if ( mClimbVolume.meClimbType == CLIMB_OverWall )
	{
		// Move to correct end position. Do this just incase errors in root motion
		// physics leave pawn slightly inside the wall
		SetVaultWallEndPosition();
	}

	EndClimbing();
}

//------------------------------------------------------------------------------
//
//
state MissionEnd
{
	ignores	Tick,
			GotoState,
			Fire,
			AltFire,
			ToggleAiming,
			Jump,
			PlayerMove,
			ToggleBehindView,
			PrevWeapon,
			NextWeapon,
			NextWeaponFunction,
			SwitchWeapon,
			CycleSelectGrenade;

	function BeginState ()
	{
		StopMoving ();

		// remove nightvision
		if ( FindCameraEffect ( mNightVisionEffect ) != -1 )
		{
			if ( mbIsNightVision )
			{
				NightVision ();
			}
		}

		if ( SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo ).mbMissionFailed )
		{
			SetTimer ( 6.0 );
		}
		else
		{
			// remove motion blur
			if ( FindCameraEffect ( mMotionBlurEffect ) != -1 )
			{
				RemoveCameraEffect ( mMotionBlurEffect );
			}
		}
	}

	function Timer ()
	{
		// remove motion blur
		if ( FindCameraEffect ( mMotionBlurEffect ) != -1 )
		{
			RemoveCameraEffect ( mMotionBlurEffect );
		}
		// don't go to menu - it's done by the HUD, who's organising the end sequence effect
	}

	function PlayerTick(
		float	aDeltaTime )
	{
		Super.PlayerTick( aDeltaTime );
		if ( mbBulletCamActive )
		{
			mBulletCamTimer += (aDeltaTime / FMax( Level.TimeDilation, 0.01 ));
			bBehindView = true;
		}
	}

	event CalcBehindView(
		out vector	aCameraLocation, 
		out rotator aCameraRotation, 
		float		aDist )
	{
		local float		deltaTime,
						diff;
		local vector	focusPoint;
		local rotator	desiredRot,
						curRot;

		if ( !mbBulletCamActive )
		{
			Super.CalcBehindView( aCameraLocation, aCameraRotation, aDist );
			return;
		}

		// Get time since last update by storing the bullet cam timer each frame.
		deltaTime = mBulletCamTimer - mBulletCamLastUpdateTime;
		mBulletCamLastUpdateTime = mBulletCamTimer;

		if ( !mbBulletCamComplete )
		{
			if ( mBulletCamCurDist < mBulletCamTotDist )
			{
				mBulletCamCurDist = (mBulletCamSpeed * mBulletCamTimer);

				// Update rotation.
				mBulletCamRotSpeed += BULLETCAM_ROT_ACCLN * mBulletCamRotDir * deltaTime;
				mBulletCamRotSpeed = Clamp( mBulletCamRotSpeed, -BULLETCAM_ROT_SPEED, BULLETCAM_ROT_SPEED );

				mBulletCamCurRot.Roll += mBulletCamRotSpeed * deltaTime;

				if (	((mBulletCamCurRot.Roll / mBulletCamRotTgt) > 1.0) &&
						((mBulletCamRotDir * mBulletCamRotTgt) > 0.0) )
				{
					UpdateBulletCamRotTarget();
				}
			}
		}
		else
		{
			mBulletCamCurDist = mBulletCamTotDist;
		}

		// Has bullet just reached target? 
		if ( !mbBulletCamComplete && (mBulletCamCurDist >= mBulletCamTotDist) )
		{
			mbBulletCamComplete = true;
			mBulletCamCurDist = mBulletCamTotDist;

			// Unpause and go into slomo.
			myHud.PausedMessage = myHud.Default.PausedMessage;
			SetPauseInternal( false );
			Level.TimeDilation	= BULLETCAM_TIME_DILATION;

			// Play death sound.
			mBulletCamVictim.PlaySpeech( SPEECH_GenDeath, true );

			// Reset timer which is now used for slomo effects.
			mBulletCamTimer				= 0.0;
			mBulletCamLastUpdateTime	= 0.0;
		}

		// Set camera location.
		aCameraLocation = mBulletCamStart + (mBulletCamInitDir * mBulletCamCurDist);

		if ( mbBulletCamComplete )
		{
			// Interpolate cam to chest of ragdoll focus.

			// Get desired camera rotation.
			focusPoint = mBulletCamVictim.GetBoneLocation( CHEST_BONE );
			desiredRot = Rotator( focusPoint - aCameraLocation );
			if ( desiredRot.Pitch > 32767 )
			{
				desiredRot.Pitch -= 65535;
			}
			if ( desiredRot.Yaw > 32767 )
			{
				desiredRot.Yaw -= 65535;
			}
			if ( desiredRot.Roll > 32767 )
			{
				desiredRot.Roll -= 65535;
			}

			// Also get current cam rotation in -Pi -> +Pi range.
			curRot = mBulletCamCurRot;
			if ( curRot.Pitch > 32767 )
			{
				curRot.Pitch -= 65535;
			}
			if ( curRot.Yaw > 32767 )
			{
				curRot.Yaw -= 65535;
			}
			if ( curRot.Roll > 32767 )
			{
				curRot.Roll -= 65535;
			}

			diff = desiredRot.Yaw - curRot.Yaw;
			if ( Abs( diff ) > 32767 )
			{
				if ( diff < 0 )
				{
					diff += 65535;
				}
				else
				{
					diff -= 65535;
				}
			}
			curRot.Yaw += (diff * BULLETCAM_TRACKING_LAG_SCALE * deltaTime);

			diff = desiredRot.Pitch - curRot.Pitch;
			if ( Abs( diff ) > 32767 )
			{
				if ( diff < 0 )
				{
					diff += 65535;
				}
				else
				{
					diff -= 65535;
				}
			}
			curRot.Pitch += (diff * BULLETCAM_TRACKING_LAG_SCALE * deltaTime);

			diff = desiredRot.Roll - curRot.Roll;
			if ( Abs( diff ) > 32767 )
			{
				if ( diff < 0 )
				{
					diff += 65535;
				}
				else
				{
					diff -= 65535;
				}
			}
			curRot.Roll += (diff * BULLETCAM_TRACKING_LAG_SCALE * deltaTime);

			mBulletCamCurRot = curRot;

			// TODO: Pull back if chest is too close.

			// Is it time to activate the stats screen?
			if ( mBulletCamTimer > 2.5 )
			{
				// Ramp up slomo to normal speed.
				diff = mBulletCamTimer - 2.5;
				if ( diff > 1.0 )
				{
					// Fully ramped up, end slomo and activate stats.
					Level.TimeDilation = 1.0;
					SASHUD(myHud).ActivateStatsScreen();
				}
				else
				{
					Level.TimeDilation = Lerp( diff, BULLETCAM_TIME_DILATION, 1.0 );
				}
			}
			else
			{
				Level.TimeDilation = BULLETCAM_TIME_DILATION;
			}
		}

		aCameraRotation = mBulletCamCurRot;
	}
}

//Net Community Stats
//no of times the player died
//in multiplayer mode
function int GetDeaths()
{
	//overrided in SASMPPlayerController.uc
	return 0;
}
state Dead
{
	ignores SwitchWeapon,
			Fire,
			AltFire,
			ToggleAiming,
			ProcessLeaning;

	function BeginState()
	{
		local int deathcount;
		
		// tell the game that the player has died. This may decide to finish the whole level.
		deathcount = GetDeaths();

		if ( Level.Game != None )
		{
			Level.Game.PlayerDied(self);
		}
		//NetCommunityLog("Player Died "$deathcount,'Net Community Stats');			
		
		if ( (Pawn != None) && (Pawn.Controller == self) )
		{
			if ( Pawn.Controller != None )
			{
				Pawn.OldController = Pawn.Controller;
			}
			Pawn.Controller = None;			
		}		
		
		EndZoom();
		FovAngleDegs = DesiredFOV;
		Pawn = None;
		Enemy = None;
		if ( Level.NetMode != NM_Standalone )
		{
			bBehindView = true;
		}
		bFrozen = true;
		bJumpStatus = false;
		bPressedJump = false;
		bBlockCloseCamera = true;
////		bBlockCloseCamera = false;
//		bValidBehindCamera = false;
//		FindGoodView();
		SetTimer(1.0, false); 
		StopForceFeedback();
		ClientPlayForceFeedback("Damage");  // jdf
		CleanOutSavedMoves();
	}

Begin:
	Sleep ( 1.0 );
}


//------------------------------------------------------------------------------
//
//
simulated function GotoLatentActionButtonState(
	SASActionMenu.EActionButtonAction aeAction )
{
	ServerGotoLatentActionButtonState( aeAction );

	if ( Role < ROLE_Authority )
	{
		DoLatentActionButtonAction( aeAction );
	}
}


//------------------------------------------------------------------------------
//
//
function ServerGotoLatentActionButtonState(
	SASActionMenu.EActionButtonAction aeAction )
{
	DoLatentActionButtonAction( aeAction );
}

//------------------------------------------------------------------------------
//
//
simulated function DoLatentActionButtonAction(
	SASActionMenu.EActionButtonAction aeAction )
{
	// Check action is valid before going to latent action button state.
	switch ( aeAction )
	{
	case ACTION_BoobyTrap:
		meLatentActionButtonAction = ACTION_BoobyTrap;
		GotoState( 'DisarmBoobyTrap' );
		break;

	case ACTION_SecondaryObjective:
	case ACTION_ExplosiveHostage:
	case ACTION_HandcuffCaptive:
		meLatentActionButtonAction = aeAction;
		GotoState( 'LatentActionButtonState' );
		break;

	default:
		LogHuman( "Invalid action type <"$aeAction$"> sent to DoLatentActionButtonAction." );
	}
}


//------------------------------------------------------------------------------
//
//
simulated function LeaveLatentActionButtonState()
{
	ServerLeaveLatentActionButtonState();
	
	if ( Role < ROLE_Authority )
	{
		GotoState ( 'PlayerWalking' );
	}
}


//------------------------------------------------------------------------------
//
//
function ServerLeaveLatentActionButtonState()
{
	GotoState( 'PlayerWalking' );
}

//------------------------------------------------------------------------------
//
//
function BoobyTrapDisarmed()
{
	Warn( "BoobyTrapDisarmed fn called outside of DisarmBoobyTrap state!" );
}


//------------------------------------------------------------------------------
//
//
function ServerMakeBoobyTrapSafe (
	SASBoobyTrapDevice	aDevice )
{
	log( "SERVER: Disarm: Device = "$aDevice );
	if ( aDevice != None )
	{
		aDevice.MakeSafe( Pawn );
	}
}


state LatentActionButtonState
{
	ignores GotoLatentActionButtonState,
			NextWeapon, 
			PrevWeapon, 
			Fire,
			AltFire,
			ToggleAiming,
			ForceReload;

	event BeginState()
	{
		// Move weapon out of view.
		if ( (Pawn.Weapon != None) && ( SASWeapon( Pawn.Weapon ) != None) )
		{
			SASWeapon( Pawn.Weapon ).MoveOutOfView();
		}

		// Don't allow charging in this state.
		mbChargeDisabled = true;
	}

	event EndState()
	{
		if ( bDuck == 0 )
		{
			Pawn.RequestStance (STANCE_Standing);
		}
		else
		{
			Pawn.RequestStance (STANCE_Crouched);
		}

		// Bring weapon back up.
		if ( (Pawn.Weapon != None) && ( SASWeapon( Pawn.Weapon ) != None) )
		{
			SASWeapon( Pawn.Weapon ).MoveIntoView();
		}

		// Reenable charging.
		mbChargeDisabled = false;
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)	
	{
		// JS I can't bear the duplicated code.
		PerfectlyNormalProcessMove(DeltaTime, NewAccel, DoubleClickMove, DeltaRot);
	}

	function PlayerMove( float DeltaTime )
	{
		// JS I can't bear the duplicated code.
		PerfectlyNormalPlayerMove(DeltaTime);
	}

	
	function PlayerTick(
		float	aDeltaTime )
	{
		Global.PlayerTick( aDeltaTime );

		// Check the current latent action is still active.
		if ( !SASHUD( myHUD ).mActionMenu.IsTimedActionActive( meLatentActionButtonAction ) )
		{
			LeaveLatentActionButtonState();
		}
	}
	
	function ProcessSquad();
}


state DisarmBoobyTrap extends LatentActionButtonState
{
	event BeginState()
	{
		Super.BeginState();

		mSASPawn.mHeartRate = mSASPawn.mHeartRateStressed;
	}

	event EndState()
	{	
		Super.EndState();

		mBoobyTrapDevice = None;
		mSASPawn.mHeartRate = mSASPawn.mHeartRateBase;
	}

	/*function PlayerTick (
		float	aDeltaTime)
	{
		Global.PlayerTick( aDeltaTime );

		if ( mBoobyTrapDevice == None )
		{
			LeaveLatentActionButtonState();
		}
	}*/	

	function BoobyTrapDisarmed()
	{
		log( "CLIENT: Disarm: mBoobyTrapDevice = "$mBoobyTrapDevice );
		ServerMakeBoobyTrapSafe( mBoobyTrapDevice );
		mSASPawn.PlaySpeech( SPEECH_SquadDefusingBomb );
		mBoobyTrapDevice = None;
		LeaveLatentActionButtonState();
	}
}


//------------------------------------------------------------------------------
//
//	STATE ActionMenu
state ActionMenu
{
	event BeginState()
	{
		bIgnoreMouseFOVScaling = true;
	}

	event EndState()
	{
		bIgnoreMouseFOVScaling = false;
	}

	execrelease function ActionSelectLeft ()
	{
		SASHUD (myHUD).ActionSelect (1);					// ACTION_LEFT
	} // ActionSelectLeft

	execrelease function ActionSelectRight ()
	{
		SASHUD (myHUD).ActionSelect (2);					// ACTION_RIGHT
	}  // ActionSelectRight

	execrelease function ActionSelectUp ()
	{
		SASHUD (myHUD).ActionSelect (0);					// ACTION_DEFAULT
	} // ActionSelectUp

	execrelease function ActionSelectDown ()
	{
		SASHUD (myHUD).ActionSelect (3);					// ACTION_CANCEL
	} // ActionSelectDown

	function PlayerMove (float deltaTime)
	{
		local Vector			X,
								Y,
								Z, 
								newAccel;
		local eDoubleClickDir	DoubleClickMove;

		if (aMouseX < -1000 && Abs (aMouseY) < 500)
		{
			SASHUD (myHUD).ActionSelect (1);					// ACTION_LEFT
		} // if
		else if (aMouseX > 1000 && Abs (aMouseY) < 500)
		{
			SASHUD (myHUD).ActionSelect (2);					// ACTION_RIGHT
		} // if
		else if (aMouseY < -1000 && Abs (aMouseX) < 500)
		{
			SASHUD (myHUD).ActionSelect (3);					// ACTION_CANCEL
		} // if
		else if (aMouseY > 1000 && Abs (aMouseX) < 500)
		{
			SASHUD (myHUD).ActionSelect (0);					// ACTION_DEFAULT
		} // if

		// Still deal with translational movement as normal

		GetAxes( Pawn.Rotation, X, Y, Z );

		// Update acceleration.
		newAccel = aForward * X + aStrafe * Y; 
		newAccel.Z = 0;
		if ( VSize(newAccel) < 1.0 )
		{
			newAccel = vect(0,0,0);
		}
		//DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime);

		Pawn.CheckBob( deltaTime, Y );

		if ( Role < ROLE_Authority ) // then save this move and replicate it
		{
			ReplicateMove(deltaTime, newAccel, DoubleClickMove, rot(0,0,0));
		}
		else
		{
			ProcessMove(deltaTime, newAccel, DoubleClickMove, rot(0,0,0));
		}
	} // PlayerMove
} // ActionMenu


////////////////////////////////////////////////////////////////////////////////
// PickupWeapon 
//
simulated function PickupWeapon ( SASPickup aPickup )
{
	ServerPickupInventory ( aPickup );
}

////////////////////////////////////////////////////////////////////////////////
// ServerPickupInventory
//
// this code ripped from SASActionMenu for MP ...
function ServerPickupInventory ( SASPickup aPickup )
{
	local SASWeapon		pickupWeapon;
	local SASAmmo		pickupAmmo;
	local SASWeapon		currentWeapon;
	local vector		TossVel;
	local Vector		Y;
	local Vector		dropPoint;

	if ( SASWeapon( aPickup.Inventory ) != None )
	{
		// Pickup is a weapon
		pickupWeapon = SASWeapon ( aPickup.Inventory );

		// If this is a weapon we don't have, swap our equivalent weapon (and ammo) with it
		currentWeapon = mSASPawn.GetWeaponOfCategory ( pickupWeapon.mCategory, pickupWeapon.mGrenadeCategory );

		if ( ( currentWeapon != None ) && ( pickupWeapon.Class != currentWeapon.Class ) )
		{
			// Drop current weapon of this category
			Y = Vector ( mSASPawn.GetViewRotation () );
			Y.Z = 0;
			Y = Normal ( Y );		// Get rid of vertical component
			TossVel = Y * Metres ( 1.0 );
			currentWeapon.Velocity = TossVel;

			dropPoint = mSASPawn.Weapon.Location + Metres ( 0.75 ) * Y;	// current weapon might not be visible
			dropPoint.Z -= Metres ( 0.3 );

			// drop replaced weapon
			currentWeapon.DropFrom ( dropPoint ); 

			// swap with this weapon
			aPickup.doPickup ( mSASPawn );
		} // if
		else if ( currentWeapon != None )
		{
			// If we already have this weapon, pickup any spare ammo and also
			// any ammo in the weapon if it has more than our currentWeapon one
			pickupWeapon.stripAmmo ( currentWeapon );

			if ( pickupWeapon.PickUpAmmoCount == 0 )
			{
				aPickup.Destroy ();
			}
		} // else if
		else
		{
			// Nothing to swap with, just pickup new weapon
			aPickup.doPickup ( mSASPawn );
		} // else
	} // if
	else if ( SASAmmo ( aPickup.Inventory ) != None )
	{
		// Pickup is ammo
		pickupAmmo = SASAmmo ( aPickup.Inventory );
	} // else if
	else
	{
		Warn ( "WARNING - ServerPickupInventory - unknown type:" @aPickup.Inventory );
	} // else
}


state BaseSpectating
{
	ignores ProcessLeaning;

	simulated event BeginState()
	{
		Super.BeginState();

		// Turn off night vision.
		if ( mbIsNightVision )
		{
			NightVision ();
		}
	}
}

state SpectatingStationary
{
ignores SeePlayer, HearNoise, KilledBy, SwitchWeapon;
	simulated function ProcessLeaning();
}

state GameEnded
{
ignores SeePlayer, HearNoise, KilledBy, NotifyBump, HitWall, NotifyHeadVolumeChange, NotifyPhysicsVolumeChange, Falling, TakeDamage, Suicide;

	simulated function ProcessLeaning();

	simulated event BeginState()
	{
		Super.BeginState();

		// Turn off night vision.
		if ( mbIsNightVision )
		{
			NightVision ();
		}
	}
}

//------------------------------------------------------------------------------
//
//
simulated function DisplayDebug(
	Canvas		aCanvas,
	out float	aYL,
	out float	aYPos )
{
	Super.DisplayDebug( aCanvas, aYL, aYPos );

	aCanvas.SetDrawColor( 255, 255, 255 );

	aCanvas.DrawText( "SASPlayerController:" );
	aYPos +=aYL;
	aCanvas.SetPos( 4, aYPos );

//	aCanvas.DrawText( "Num active terrorists:"$SASGameInfo( Level.Game ).mNumActiveTerrorists );
	aCanvas.DrawText( "Num active terrorists:"$SASGRI ( Level.GetLocalPlayerController ().GameReplicationInfo ).mNumActiveTerrorists );
	aYPos +=aYL;
	aCanvas.SetPos( 4, aYPos );
}

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mSecureCaptiveTime=3.0000000
    mBreathInSounds[0]=Sound'SASSounds.Base.breathin1'
    mBreathInSounds[1]=Sound'SASSounds.Base.breathin2'
    mBreathOutSounds[0]=Sound'SASSounds.Base.breathout1'
    mBreathOutSounds[1]=Sound'SASSounds.Base.breathout2'
    mTinnitusSound=Sound'MM_Weapons.Grenades.WD_tinnitus'
    mChargeAmount=1.0000000
    mChargeDischargeRate=0.2000000
    mChargeRechargeRate=0.2500000
    mMaxChargeTilt=90.0000000
    mChargeTiltSpeed=5.0000000
    mMaxStrafeTilt=128.0000000
    mStrafeTiltSpeed=0.1000000
    CheatClass=Class'SASCheatManager'
    mType=1
    FovAngleDegs=70.0000000
    PlayerReplicationInfoClass=Class'SASPRI'
    bAlwaysTick=true
}