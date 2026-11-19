//=============================================================================
// SASHUD.uc
//=============================================================================

class SASHUD extends HUD
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

#exec OBJ LOAD FILE=..\Textures\Warfarefonts.utx PACKAGE=Warfarefonts

//-----------------------------------------------------------------------------
// Constants

// Some of these I'm turning to member variables so I can tweak them quicker.

const TIME_STRING_Y = 20;

const PLAYER_HEAD_WIDTH =60;
const PLAYER_HEAD_HEIGHT =81;
const PLAYER_HEAD_U =0;
const PLAYER_HEAD_V =0;

const PLAYER_DEAD_HEAD_V = 32;

const SQUAD_HEAD_WIDTH = 45;//42
const SQUAD_HEAD_HEIGHT = 62;//48

//----------------------------------------
// charge bar

const CHARGE_BAR_U = 69;

const FULL_CHARGE_BAR_V = 2;

const CHARGE_BAR_LEFTNESS = 60;

const CHARGE_BAR_Y = 10;
//----------------------------------------

const CURRENT_MAG_LEFTNESS = 180;
const CURRENT_MAG_UPNESS = 120;

const CURRENT_MAG_WIDTH = 41;
const CURRENT_MAG_HEIGHT = 104;

const EMPTY_MAG_U = 41;
const CURRENT_MAG_V = 0;
const FULL_MAG_U =0;

const EXTRA_MAGS_LEFTNESS = 140;
const EXTRA_MAG_RIGHT_STEP = 33;
const EXTRA_MAGS_UPNESS = 100;

const EXTRA_MAG_WIDTH = 43;
const EXTRA_MAG_HEIGHT =76;
const EXTRA_MAG_U = 86;
const EXTRA_MAG_V = 28;

const AMMO_COUNT_LEFTNESS = 227;
const BURST_LEFTNESS = 247;

//----------------------------------------


const SQUAD_HEAD_RIGHTNESS_STEP = 55;
const SQUAD_HEAD_RIGHTNESS_RES1 = 110;
const SQUAD_HEAD_RIGHTNESS_STEP_RES1 = 45;

const BURST_UPNESS = 68;
const FIRE_MODE_LEFTNESS = 65;

const MAP_X = 20;
const MAP_UPNESS = 20;
const MAP_OVERLAY_SIZE = 160;

const FIRE_MODE_AFTER_MAG_RIGHT = 15;
const WEAPON_LINEART_LEFT=350;
const WEAPON_LINEART_UP=300;
//Texture sizes for single, auto and burst fire mode
const FIRE_MODE = 64;
const DAMAGE_SPHERE = 128;

// Texture sizes (important so PS2 textures don't go wrong)
const ORANGESTUFF_TEXTURE_WIDTH = 256;
const ORANGESTUFF_TEXTURE_HEIGHT = 256;
const ORANGEWEAPONS_TEXTURE_WIDTH = 512;
const ORANGEWEAPONS_TEXTURE_HEIGHT = 512;

const WEAPON_ICON_SCALE_FACTOR = 0.5;

//-----------------------------------------------------------------------------
// Enums

enum eFAVType
{
	SASFAV_FLASHBANG
};

enum eEndingSounds
{
	ENDINGSOUNDS_Objectives,
	ENDINGSOUNDS_Casualty,
	ENDINGSOUNDS_Grade,
	ENDINGSOUNDS_Pause,
	ENDINGSOUNDS_Done
};

//-----------------------------------------------------------------------------
// Structs
struct native sAfterImage
{
	var float	StartTime;
	var float	ColourspotFadeDuration;
	var float	DarkspotFadeDuration;
	var vector	ScreenPos;
	var float	xSize;
	var float	ySize;
};

// will's very proud of this word, he even told me how to pronounce it
struct native sFlashAndVignette
{
	var eFAVType			Type;
	var float				StartTime;
	var array<float>		FlashDurations;
	var array<float>		FlashIntensities;
	var array<float>		VignetteDurations;
	var array<float>		VignetteIntensities;
	var array<float>		BrightnessIntensities;
	var array<float>		BrightnessDurations;
	
	var int					NumBrightnessKeys;
	var int					NumFlashKeys;
	var int					NumVignetteKeys;
	var Actor				flasher;
};

struct native sFlashSettings
{
	var array<float>		FlashDurations;
	var array<float>		FlashIntensities;
	var array<float>		VignetteDurations;
	var array<float>		VignetteIntensities;
	var array<float>		BrightnessDurations;
	var array<float>		BrightnessIntensities;
	var int					NumFlashKeys;
	var int					NumBrightnessKeys;
	var int					NumVignetteKeys;
	
	var() Texture			VignetteTexture;
	var() Texture			FlashModulateTexture;
	var() int				FlashMaxAlpha;
	var() int				VignetteMaxAlpha;
};

//-----------------------------------------------------------------------------
// Member variables

//------------
// hijacked constants. I've turned them into member variables so I can iterate them on the fly in the game
var float CHARGE_BAR_HEIGHT;
var float CHARGE_BAR_HEIGHT_RES1;
var float PLAYER_HEAD_RIGHTNESS;
var float PLAYER_HEAD_RIGHTNESS_RES1;
var float HEAD_Y;
var float HEAD_Y_RES1;
var float PLAYER_HEAD_FADED_RES1;
var float CURRENT_MAG_LEFTNESS_RES1;
var float CURRENT_MAG_UPNESS_RES1;
var float CURRENT_MAG_WIDTH_RES1;
var float CURRENT_MAG_HEIGHT_RES1;
var float EMPTY_MAG_U_RES1;
var float CURRENT_MAG_V_RES1;
var float FULL_MAG_U_RES1;
var float EXTRA_MAGS_LEFTNESS_RES1;
var float EXTRA_MAG_RIGHT_STEP_RES1;
var float EXTRA_MAGS_UPNESS_RES1;
var float EXTRA_MAG_WIDTH_RES1;
var float EXTRA_MAG_HEIGHT_RES1;
var float EXTRA_MAG_U_RES1;
var float EXTRA_MAG_V_RES1;
var float CHARGE_BAR_WIDTH;
var float SQUAD_HEAD_RIGHTNESS;
var float CHARGE_BAR_WIDTH_RES1;
var float PLAYER_HEAD_FADED_U_RES1;
var float AMMO_COUNT_LEFTNESS_RES1;
var float BURST_LEFTNESS_RES1;
var float AMMO_COUNT_UPNESS;
var float AMMO_COUNT_UPNESS_RES1;

//------------

var Actor	mFirstPickup;

var float	mScaleX,
			mScaleY;
var int		mDrawPawnCollision;
var int		mDrawPawnLimbCollision;
var bool	mbDrawCoverPoints;
var bool	mbDrawDominationPoints;
var bool	mbDrawPaths;
var bool	mbDrawActorOverlays;
var bool	mbDrawAnimDebug;
var bool	mbDrawActorDebug;
var bool	mbDrawTerroristGroupDebug;
var bool    mbDrawSoldierDest;
var bool	mbDrawPickups;
var bool	mbDrawWeapons;
var bool	mbDrawDoorCollision;
var bool	mbDrawSightLines;
var int		mDrawEPs;
var bool	mbDrawShotDebug;
var bool	mbDrawObjectivesDebug;

var() SASRadarMapVolume mRadarVol;

// MessageHistory
//var Array<String>			mMessageHistory;
const MH_MAXMESSAGES		= 1;
//var int						mCurrentMessage;
var String					mFlashMessage;
var float					mFlashTime;
var Texture					mtester1;
var SASObjectiveMgr			mObjectiveManager;
var Array<eObjectiveStatus>	mObjectiveQueryStatus;
var float					mObjectiveDisplayStartTime;
var(Objectives) float		mObjectiveDisplayOnTime;
var(Objectives) float		mObjectiveDisplayFadeTime;

var() float					mEndQuitTime;					// how long to wait before quitting after stats screen

// which timer to show at the top of the screen
var byte						mWhichTimerToShow;

var(Scoring) Localized String	mLabelScoring;
var(Scoring) Localized String	mLabelTerroristsKilled;
var(Scoring) Localized String	mLabelSurrederedTerroristsKilled;
var(Scoring) Localized String	mLabelTerroristsCaptured;
var(Scoring) Localized String	mLabelTerroristsIncapacitated;
var(Scoring) Localized String	mLabelSASKilled;
var(Scoring) Localized String	mLabelSASIncapacitated;
var(Scoring) Localized String	mLabelHostagesKilled;
var(Scoring) Localized String	mLabelHostagesSaved;
var(Scoring) Localized String	mLabelHostagesIncapacitated;
var(Scoring) Localized String	mLabelTimeTaken;
var(Scoring) Localized String	mLabelShotsFired;
var(Scoring) Localized String	mLabelShotsHit;
var(Scoring) Localized String	mLabelHitPC;
var(Scoring) Localized String	mLabelHeadHits;
var(Scoring) Localized String	mLabelBodyHits;
var(Scoring) Localized String	mLabelLimbHits;
var(Scoring) Localized String	mLabelYES;
var(Scoring) Localized String	mLabelNO;
var(Scoring) Localized String	mLabelScorePC;
//var(Scoring) Localized String	mLabelScoreTarget;
var(Scoring) Localized String	mLabelGrade;
//var(Scoring) Localized String	mAwardNames [NUM_SPECIAL_AWARDS];

var Localized String mSingleFireModeLetter;
var Localized String mBurstFireModeLetter;
var Localized String mAutoFireModeLetter;

var(Scoring) Localized Array<String>	mLabelGradeClass;

//var	array<Texture>			mDisarmIcons;				// booby trap disarm icons array

var	array<Texture>			mSplatTexture;				// screen blood splat texture
var int						mCurSplatTex;
var float					mSplatStartTime;
var float					mSplatFadeLength;
var float					mInitialSplatNoFadeLength;
var bool					mSplatted;
var float					mTSU,
							mTSV;

var Texture					mOrangeStuff;
var Texture					mOrangeWeapons;
var Texture					mOrangeHeads;
var Texture					mOrangeHeadsRes1;
var Texture					mOrangeHeadsTerr;
var Texture					mFireModeSingle;
var Texture					mFireModeBurst;
var Texture					mFireModeAuto;  
var Texture					mOrangeChargeBar;
var Texture					mOrangeChargeBarRes1;
var Texture					mOrangeClips;
var Texture					mOrangeClipsRes1;
var Texture					mOrangeSpike;
var Texture					mDamageSphere;

var	Texture					mDripTexture;				// screen blood drip texture

// AfterImage
var(AfterImage)	Texture					mAfterImageColourspotTexture;	// texture overlayed on scene after looking at a bright flash
var(AfterImage)	Texture					mAfterImageDarkspotTexture;	// texture overlayed on mAfterImageColourspotTexture to darken it
var(AfterImage) Range					mAfterImageDarkspotFadeDurationRange;
var(AfterImage) Range					mAfterImageColourspotFadeDurationRange;
var(AfterImage) int						mMaxAfterImages;
var(AfterImage) float					mXPixSizeAtDist100;
var(AfterImage) float					mYPixSizeAtDist100;
var(AfterImage) Range					mMaxXPixSize;
var(AfterImage) Range					mMaxYPixSize;
var(AfterImage) int						mDarkSpotInsetAmount;
var				array<sAfterImage>		mActiveAfterImages;
//var				int						mIctesting;
//var				float					mLastTime;

// vignettes
var array<sFlashAndVignette>			mFlashVignettes;
var(vignettes) sFlashSettings			mFalshBangDefaults;

// Damage overlay
var Texture					mDamageOverlayTex;
var float					mDamageOverlayDuration;
var float					mDamageOverlayMaxAlpha;
var float					mDamageOverlayRampDownPhase1MinAlpha;
var float					mLastDamageOverlayAlpha;
var float					mDamageOverlayRampUpEnd;
var float					mDamageOverlayRampDownPhase1End;

const MAXDRIPS = 4;
var int						mNumDrips;
var float					mDripX[MAXDRIPS];
var float					mDripY[MAXDRIPS];
var float					mDripSize[MAXDRIPS];
var float					mDripTravel[MAXDRIPS];

const NUMDAMAGEDIRECTIONS	= 8;
const DAMAGEFADETIME		= 2;	// In seconds

const DAMAGEWIDTH			= 15;
const DAMAGERADIUS			= 150;
const DAMAGEOFFSET			= 50;

var float					mLastDamageTime[NUMDAMAGEDIRECTIONS];
var float					mLastDamageTimeAllDirections;
var Texture					mMapMask;
var	Texture					mMapCircler;

var Vector					mMapTopLeft;
var Vector					mMapBotRight;

// JS I've removed all references to fonts from the game as possible, leaving only the ones in Canvas

var int						mScoreFontIdx;

//var Actor					mFadePlayerActor;
//var Actor					mFadeTerroristActor;
//var float					mFadeDisplayFOV;
//var float					mFadeRotation;

var Texture					mMissionFailedTexture;
var float					mMissionFailedRate;
var float					mMissionFailedScale;
var bool					mbStatsScreenActivated;

var eEndingSounds			meEndingSounds;

// reticle vars
var() Color					mReticuleColourBorder;		// reticle colours
var() Color					mReticuleColourEnemy;		// enemy
var() Color					mReticuleColourHostage;		// hostage
var() Color					mReticuleColourAlly;		// ally
var() Color					mReticuleColourBoobyTrap;	// defusable booby trap
var() Color					mReticuleColourDoorMover;	// openable door
var() Color					mReticuleColourNoTarget;	// nowt

var() float					mReticleWidth,				// reticle width
							mReticleHeight,				// reticle height
							mReticleBorder,				// reticle border width
							mReticleGap;				// reticle centre gap

var Texture					mAutoTargetZoneTexture;
var Texture					mAutoTargetZoneLockTexture;

var SASSquadManager         mSquadManager;
var() Localized String		mLabelWingman;
var() Localized String		mLabelHuman;
var() Localized String		mLabelIncapacitated;
var() Localized String		mLabelDead;
var() Localized String		mLabelOK;
var() Localized String		mLabelCancel;

var SASGRI					mSASGRI;
var bool					mbScoreCalculated;

var Array<String>			mStanceNames;

var() Texture				mDefTexture;

var SASActionMenu			mActionMenu;
// DEBUG!! -AC
// Place DVD like controls on the screen for replay playback.
//var transient SASPLaybackWidget	mPlaybackControls;
// END DEBUG!!
var() Texture				mAwardIcons[NUM_SPECIAL_AWARDS];
var float					mTimeStringLength;

// Caching of squad members
//const	MAX_OTHER_SQUAD_MEMBERS = 3;
//var int						mNumOtherSquadMembers;		// Number of other troopes in our squad at mission start
//var SASPawn					mOtherSquadMembers [MAX_OTHER_SQUAD_MEMBERS];	// Who's in our squad

var int						mObjSoundCount;

//textures for lineart
var	array<Texture> mLineart;
var int		Ind;
var vector  TCords;
var String	CurrentWeapon;
var String	PrevWeapon;
var bool	isSlideStart;
var bool	isSlideController;
var	bool	isDisplayLienarArt;
var float	fSlideBeginTime;
var float	fSlideDrawRatio;
var String	CurrWeaponTrace;
var float	fAnimController;
var rotator	damageRot;

//ashray hack
var SASTriggerVolume mTree;
var bool bDisplayDamage;

//ashray hack to display rotating spike
var vector	DirOfAttack;
var vector  DirOfAttackBack;
var vector	DirTakeDamage;

var int		iStartLocX, iStartLocY, iDestLocX, iDestLocY, iCurrLocX, iCurrLocY;
var float	fSlideTime;
var float   fSlideAnimTimer;
var Vector	temp1;
var bool bDrawOtherHUDitems;

//::function StartSlideAnim( int srcX, int srcY, int destX, int destY, float fTime )
//::{
//::	iStartLocX = srcX;
//::	iStartLocY = srcY;
//::	iDestLocX  = destX;
//::	iDestLocY  = destY;
//::	iCurrLocX  = srcX;
//::	iCurrLocY  = srcY;
//::	fSlideTime = fTime;	
//::	fSlideAnimTimer = 0.0;
//::}

//::function SlideAnimFrameMove( float fDeltaTime )
//::{
//::	//fSlideAnimTimer += fDeltaTime;
//::	//iCurrLocX = iSrcLocX+((fSlideAnimTimer/fSlideTime)*(iDestLocX - iSrcLocX));
//::	//iCurrLocY = iSrcLocY+((fSlideAnimTimer/fSlideTime)*(iDestLocY - iSrcLocY));
//::}


//------------------------------------------------------------------------------
//
//
function PostBeginPlay ()
{
	Log ( "Level.Title: " $Level.Title );

	if ( Level.Title == "Entry" || Level.Title == "Frontend" )
	{
		mbDrawHUD = false;
	}

	InitSASGRI ();
	InitSquadManager ();
	InitObjectiveManager ();
	InitActionMenu ();

	Super.PostBeginPlay ();
}

//------------------------------------------------------------------------------
//
// Extended to include initialisation of squad members for HUD
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
function InitObjectiveManager ()
{
	// find the objective manager
	foreach Allactors ( class'SASObjectiveMgr', mObjectiveManager )
	{
		break;
	}
}

//------------------------------------------------------------------------------
//
//
simulated function InitSASGRI ()
{
	local PlayerController pc;

	pc = Level.GetLocalPlayerController ();

	if ( ( pc != None ) && ( pc.GameReplicationInfo != None ) )
	{
		mSASGRI = SASGRI ( pc.GameReplicationInfo );
	}
}

//------------------------------------------------------------------------------
//
// FUNCTION InitActionMenu
function InitActionMenu ()
{
	Log ("InitActionMenu");

	mActionMenu = Spawn( class'SASActionMenu', self );
	mActionMenu.mOwnerHUD = self;
// DEBUG!! -AC
// Place DVD like controls on the screen for replay playback.
//	mPlaybackControls = new (self) class'SASPlaybackWidget';
//	mPlaybackControls.mOwnerHUD = self;
// END DEBUG!!

} // InitActionMenu


/*
//------------------------------------------------------------------------------
//
//	We have to keep our own list of squad members since the squad managers list
//	changes are troopers are killed and incapacitated
//
simulated function InitSquadMembers ()
{
	local int i, c;

	// Find the rest of our squad
	mNumOtherSquadMembers = mSquadManager.mNumSquadMembers;
	if (mNumOtherSquadMembers > MAX_OTHER_SQUAD_MEMBERS)
	{
		Warn ("TOO MANY SQUAD MEMBERS FOR HUD");
	} // if
	if ( mSquadManager.mNumSquadMembers > 0 )
	{
		Log ("Squad manager has " $mSquadManager.mNumSquadMembers$ " pawns");
	}
	c = 0;
	for (i = 0; i < mSquadManager.mNumSquadMembers; i++)
	{
		mOtherSquadMembers [c++] = mSquadmanager.mSquadPawns [i];
	} // for
} // InitSquadMembers
*/

//------------------------------------------------------------------------------
//
//
simulated function DisplayTakeDamage ( Vector aDirection,Vector uDirection, bool isAttacked  ) // 1 = north, 2 = ne, 3 = E, etc.
{
	local int tDirNum;

	if ( aDirection.X > 0 )
	{
		tDirNum = 0;
	}
	else
	{
		tDirNum = 4;
	}

	if ( abs ( aDirection.X ) > 0.5 )
	{
		mLastDamageTime[tDirNum] = Owner.Level.TimeSeconds;
	}

	if ( aDirection.Y > 0 )
	{
		tDirNum = 2;
	}
	else
	{
		tDirNum = 6;
	}

	if ( abs ( aDirection.Y ) > 0.5 )
	{
		mLastDamageTime[tDirNum] = Owner.Level.TimeSeconds;
	}

	mLastDamageTimeAllDirections = Level.TimeSeconds;
	
	DirOfAttack = aDirection;
	DirTakeDamage = uDirection;
	bDisplayDamage = isAttacked;
	
	
	
}
//...........................................................................
//
//
simulated function DisplayWeaponLinearAart()
{
	local float SlideTime;
	
	if( CurrentWeapon=="")
		return;
	
	//if((isSlideController) && CurrentWeapon == PrevWeapon )
	//		{
	//			PrevWeapon = CurrWeaponTrace;
	//			isSlideController = false;
	//			fSlideDrawRatio = 0;
	//			isSlideStart =	false;
	//		}
		
	//if( (isSlideController)&& CurrentWeapon != PrevWeapon && isDisplayLienarArt == true && ( CurrWeaponTrace != CurrentWeapon ) )
	//{
				
	//			isSlideController = false;
	//			fSlideDrawRatio = 0;
	//			isSlideStart =	false;
	//			isDisplayLienarArt = false;
	//}
	
	
	if(isSlideController)
	{
		isDisplayLienarArt=true;
		if(!isSlideStart || fAnimController==0 )
		{
					
				fAnimController = 1.0;
				fSlideDrawRatio = 0;
				fSlideBeginTime=Level.TimeSeconds;
				isSlideStart=true;
				isSlideController = true;
			
			
		}
		
		isDisplayLienarArt=true;
		CurrWeaponTrace = CurrentWeapon;
		SlideTime=Level.TimeSeconds;
		if(	(SlideTime - fSlideBeginTime)< 0.5)
			{
				fSlideDrawRatio=(SlideTime - fSlideBeginTime)*2;
				if(fSlideDrawRatio < 0.001 )
					fSlideDrawRatio = 0;
				if(fSlideDrawRatio > 1.0 )
					fSlideDrawRatio = 1.0;
			}
			
		if(	(SlideTime - fSlideBeginTime) > 0.5 && (SlideTime - fSlideBeginTime) < 4.0)
				fSlideDrawRatio = 1.0;
		
		if(((SlideTime - fSlideBeginTime)>4.0) && (SlideTime - fSlideBeginTime) < 4.5 )
			{
				fSlideDrawRatio = ( 4.5 - (SlideTime - fSlideBeginTime))*(2.0);
				if(fSlideDrawRatio < 0.001 )
					fSlideDrawRatio = 0;
			}
		
		if((SlideTime - fSlideBeginTime) > 4.5)
			{
				isSlideStart=false;
				SlideTime=0.0;
				PrevWeapon = CurrentWeapon;
				isSlideController = false;
				isDisplayLienarArt = false;	
			}
	
	
	
	}
	
}


//------------------------------------------------------------------------------
//
//
//::simulated function ScreenBloodSplat()
//::{
//::	local int i;
//::
//::	if (!mSplatted)
//::	{
//::		mCurSplatTex = Rand(mSplatTexture.Length - 1);
//::		mSplatStartTime = Owner.Level.TimeSeconds;
//::		mSplatted = true;
//::		mTSU = rand(0.5);		// Choose point in top left quarter
//::		mTSV = rand(0.5);
//::		mNumDrips = rand(MAXDRIPS-2)+1;
//::
//::		for (i=0; i<mNumDrips; i++)
//::		{
//::			mDripX[i] = FRand();
//::			mDripY[i] = FRand();
//::			mDripSize[i] = Rand(10)+4;
//::			mDripTravel[i] = Rand(100);
//::		}
//::	}
//::}


//------------------------------------------------------------------------------
// Native Functions

//------------------------------------------------------------------------------
// Exec Functions

exec function DrawShots()
{
	mbDrawShotDebug = !mbDrawShotDebug;
}

// Turn on/off drawing of EP stack up params
exec function DEP ( int abDraw )
{
	mDrawEPs = abDraw;
} // DEP

exec function DrawEntryPoints ( int abDraw )
{
	mDrawEPs = abDraw;
} // DrawEntryPoints

// Turn on/off drawing of pawn collision cylinders
exec function DPC ( int abDraw )
{
	mDrawPawnCollision = abDraw;
}

exec function DrawPawnCollision( int abDraw )
{
	mDrawPawnCollision = abDraw;
}

// Turn on/off drawing of pawn limb collision cylinders
exec function DPLC ( int abDraw )
{
	mDrawPawnLimbCollision = abDraw;
}

exec function DrawPawnLimbCollision ( int abDraw )
{
	mDrawPawnLimbCollision = abDraw;
}

exec function RS ( float aScale )
{
	DoReticleScale ( aScale );
}

exec function ReticleScale ( float aScale )
{
	DoReticleScale ( aScale );
}

// Turn on/off drawing of door collision cylinders
exec function DDC (bool abDraw)
{
	mbDrawDoorCollision = abDraw;
}

// Draw pickups (temporary while
exec function DPU ()
{
	if (mbDrawPickups == true)
	{
		mbDrawPickups = false;
	} // if
	else
	{
		mbDrawPickups = true;
	} // else
}

exec function DrawWeaponDebug()
{
	if (mbDrawWeapons == true)
	{
		mbDrawWeapons = false;
	} // if
	else
	{
		mbDrawWeapons = true;
	} // else
}

simulated function DoReticleScale ( float aScale )
{
	if ( aScale == 0 )
	{
		mReticleWidth	= Default.mReticleWidth;
		mReticleHeight	= Default.mReticleHeight;
	}
	else
	{
		mReticleWidth	= Default.mReticleWidth  * aScale;
		mReticleHeight	= Default.mReticleHeight * aScale;
	}
}

exec function KillSquad ()
{
	mSquadManager.KillSquad ();
} // KillSquad


exec function sightLines ()
{
	mbDrawSightLines = !mbDrawSightLines;
}

exec function KT ()
{
	KillTerrorists ();
} // KT

exec function KillTerrorists()
{
	local SASTerrorist	terrorist;

	foreach AllActors( class'SASTerrorist', terrorist )
	{
		if ( !terrorist.IsDead() )
		{
			terrorist.TakeDamage( 10000, None, terrorist.Location, vect(0,0,0), class'Suicided' );
		}
	}
}

exec function KTX()
{
	local SASTerrorist	terrorist;

	foreach AllActors( class'SASTerrorist', terrorist )
	{
		if ( !terrorist.IsDead() && terrorist.mHostageTarget == None )
		{
			terrorist.TakeDamage( 10000, None, terrorist.Location, vect(0,0,0), class'Suicided' );
		}
	}
}

//------------------------------------------------------------------------------
// Turn on/off drawing of cover points
//
exec function DrawCoverPoints (
	bool	abDraw)
{
	mbDrawCoverPoints = abDraw;
}

// Turn on/off drawing of domination points
exec function DrawDominationPoints (
	bool	abDraw)
{
	mbDrawDominationPoints = abDraw;
}
exec function DDP( bool abDraw )
{
	mbDrawDominationPoints = abDraw;
}

// Turn on/off drawing of paths.
exec function ShowPaths(
	bool abShow )
{
	mbDrawPaths = abShow;
}

exec function ShowHUD (
	bool	abDraw)
{
	mbDrawHUD = abDraw;
}

//------------------------------------------------------------------------------
//
//
exec function ShowOverlays (
	bool	abDraw)
{
	mbDrawActorOverlays = abDraw;
}
exec function ToggleOverlays ()
{
	mbDrawActorOverlays = !mbDrawActorOverlays;
}
exec function AIdebug ()
{
	mbDrawAnimDebug = false;
	mbDrawActorOverlays = !mbDrawActorOverlays;
}
exec function AnimDebug()
{
	mbDrawActorOverlays = false;
	mbDrawAnimDebug = !mbDrawAnimDebug;
}
exec function SAD( bool abDraw )
{
	mbDrawActorDebug = abDraw;
}
exec function ShowActorDebug (
	bool	abDraw)
{
	mbDrawActorDebug = abDraw;
}

exec function ShowGroupDebug(
	bool	abShow )
{
	mbDrawTerroristGroupDebug = abShow;
}

exec function SSD( bool abDraw )
{
	mbDrawSoldierDest = abDraw;
}

exec function DoMenu(bool aMenu)
{
	Level.GetLocalPlayerController ().ClientOpenMenu ( "SASGUI.SASCommandMenu", false);
}

//------------------------------------------------------------------------------
//
//
exec function ToggleHUD()
{
	mbDrawHUD = !mbDrawHUD;
}

exec function HUDOff ()
{
	if ( mbDrawHUD )
	{
		ToggleHUD ();
	}
}

exec function HUDOn ()
{
	if ( !mbDrawHUD )
	{
		ToggleHUD ();
	}
}

exec function AIDump ()
{
	MemDump ();
} // AIDump

//-----------------------------------------------------------------------------
// Functions
//

///////////////////////////////////////////////////////////////////////////////
// RenderToScale
//
//::function RenderToScale (
//::	Canvas		aCanvas,	// Canvas to render to
//::	Texture		aTexture)	// Texture to render
//::{
//::    aCanvas.DrawTile(
//::		aTexture,
//::		aTexture.USize * mScaleX, aTexture.VSize * mScaleY,
//::		0, 0,
//::		aTexture.USize, aTexture.VSize);
//::
//::    return;
//::}

/*
//------------------------------------------------------------------------------
//
//
function FlashMessage(String aMessage, float aFlashTime)
{
	mFlashMessage = aMessage;
	mFlashTime = Owner.Level.TimeSeconds+aFlashTime;
}

//------------------------------------------------------------------------------
//
//
simulated function ShowMessage( String aMessage, optional float aFlashTime )
{
	mMessageHistory[mCurrentMessage] = aMessage;
	mCurrentMessage++;
	if ( mCurrentMessage == MH_MAXMESSAGES )
	{
		mCurrentMessage = 0;
	}

	if (aFlashTime > 0.1)
	{
		FlashMessage(aMessage,aFlashTime);
	}
}
*/

//------------------------------------------------------------------------------
//
//
simulated function DrawDamageDirections ( Canvas aCanvas )
{
	local int	i,
				tX,
				tY;
	local float	tAlpha;

	tX = aCanvas.SizeX / 2;
	tY = aCanvas.SizeY / 2;

	for ( i = 0; i < NUMDAMAGEDIRECTIONS; i++ )
	{
		tAlpha = 1.0f - ( ( Owner.Level.TimeSeconds - mLastDamageTime[i] ) / DAMAGEFADETIME );

		if ( tAlpha > 0.1f )
		{
			aCanvas.Style = ERenderStyle.STY_Alpha;
			aCanvas.SetDrawColor ( 221, 25, 36, 90 * tAlpha );

			switch ( i )
			{
			case 0: // N
				aCanvas.SetPos ( ( tX - DAMAGERADIUS ) + DAMAGEWIDTH, tY - DAMAGERADIUS );
				//aCanvas.DrawTile ( mDefTexture, ( DAMAGERADIUS * 2 ) - DAMAGEWIDTH, DAMAGEWIDTH, 0, 0, 1, 1 );
				break;
			case 1: // NE
				break;
			case 2: // E
				aCanvas.SetPos ( tX + DAMAGERADIUS, ( tY - DAMAGERADIUS ) + DAMAGEWIDTH );
				//aCanvas.DrawTile ( mDefTexture, DAMAGEWIDTH, ( DAMAGERADIUS * 2 ) - DAMAGEWIDTH, 0, 0, 1, 1 );
				break;
			case 3: // SE
				break;
			case 4: // S
				aCanvas.SetPos ( ( tX - DAMAGERADIUS ) + DAMAGEWIDTH, tY + DAMAGERADIUS );
				//aCanvas.DrawTile ( mDefTexture, ( DAMAGERADIUS * 2 ) - DAMAGEWIDTH, DAMAGEWIDTH, 0, 0, 1, 1 );
				break;
			case 5: // SW
				break;
			case 6: // W
				aCanvas.SetPos ( tX - DAMAGERADIUS, ( tY - DAMAGERADIUS ) + DAMAGEWIDTH );
				//aCanvas.DrawTile ( mDefTexture, DAMAGEWIDTH, ( DAMAGERADIUS * 2 ) - DAMAGEWIDTH, 0, 0, 1, 1 );
				break;
			case 7: // NW
				break;
			}
		}
	}
}


//------------------------------------------------------------------------------
// DrawDamageOverlay
//
simulated function DrawDamageOverlay(
	Canvas	aCanvas )
{
	local float	timeSinceLastDamaged;
	local float	fadeAlpha;
	local float	rampUpEnd;
	local float	rampDownPhase1End;
	
	
	
	
	
	if ( mDamageOverlayTex == None )
	{
		return;
	}

	timeSinceLastDamaged = Level.TimeSeconds - mLastDamageTimeAllDirections;

	// Have we exceeded duration of drawing damage overlay?
	if ( timeSinceLastDamaged > mDamageOverlayDuration )
	{
		mLastDamageOverlayAlpha = 0.0;
		return;
	}

	rampUpEnd = mDamageOverlayDuration * mDamageOverlayRampUpEnd;

	if ( timeSinceLastDamaged < rampUpEnd )
	{
		fadeAlpha = mDamageOverlayMaxAlpha * (timeSinceLastDamaged / rampUpEnd);

		// Prevent us from dropping to a lower alpha since last frame while ramping up.
		// (e.g. This would happen if repeatedly being hit before completely ramping up between each hit)
		fadeAlpha = FMax( fadeAlpha, mLastDamageOverlayAlpha );
	}
	else
	{
		rampDownPhase1End = mDamageOverlayDuration * mDamageOverlayRampDownPhase1End;

		if ( timeSinceLastDamaged < rampDownPhase1End )
		{
			fadeAlpha = mDamageOverlayMaxAlpha
				- ((mDamageOverlayMaxAlpha - mDamageOverlayRampDownPhase1MinAlpha)
					* ((timeSinceLastDamaged - rampUpEnd) / (rampDownPhase1End - rampUpEnd)));
		}
		else
		{
			fadeAlpha = mDamageOverlayRampDownPhase1MinAlpha
				* (1.0 - ((timeSinceLastDamaged - rampDownPhase1End) / (mDamageOverlayDuration - rampDownPhase1End)));
		}
	}

	fadeAlpha = FMin( fadeAlpha, mDamageOverlayMaxAlpha );

	mLastDamageOverlayAlpha = fadeAlpha;

	if ( fadeAlpha > 0 )
	{
		aCanvas.SetPos( 0, 0 );
		aCanvas.SetDrawColor( 255, 255, 255, fadeAlpha );
		aCanvas.DrawTile(
			mDamageOverlayTex,
			aCanvas.SizeX,
			aCanvas.SizeY,
			0,
			0,
			mDamageOverlayTex.VSize,
			mDamageOverlayTex.USize );
	}
}

//------------------------------------------------------------------------------
//
//
simulated function DrawAfterImage (Canvas aCanvas)
{
	local float tTime;
	local float fadeProp;
	local int alpha;
	local int aftImgIndex;
	local int posX,posY;

	// common canvas state
	aCanvas.bNoSmooth = false;
	aCanvas.Style = ERenderStyle.STY_Alpha;

	for(aftImgIndex=0;aftImgIndex<mActiveAfterImages.Length;aftImgIndex++)
	{
		tTime = Owner.Level.TimeSeconds - mActiveAfterImages[aftImgIndex].StartTime;

		// size checks for active resolution
		mActiveAfterImages[aftImgIndex].xSize = clamp(mActiveAfterImages[aftImgIndex].xSize, 0, aCanvas.SizeX*2);	// half afterimage viewable over max resolution width
		mActiveAfterImages[aftImgIndex].ySize = clamp(mActiveAfterImages[aftImgIndex].ySize, 0, aCanvas.SizeX*2);	// half afterimage viewable over max resolution height

		// first ColourspotFadeDuration, then DarkspotFadeDuration

		if (tTime < mActiveAfterImages[aftImgIndex].ColourspotFadeDuration)
		{
			// during ColourspotFadeDuration => fade colourspot out to 0%, fade darkspot in to 100%

			// colour spot
			fadeProp = 1 - (tTime / mActiveAfterImages[aftImgIndex].ColourspotFadeDuration);
			alpha = 255 * fadeProp;
			if(alpha == 0) alpha = 1;	// IC : DrawTile strangeness with alpha = 0
			aCanvas.SetDrawColor( 255, 255, 255, alpha);		// essentially a filter on individual chanels within the texture. think of like subtractive colours - eg if you apply a yellow DrawColor filter to Cyan, you'll get green?
			posX = mActiveAfterImages[aftImgIndex].ScreenPos.X - (mActiveAfterImages[aftImgIndex].xSize/2);
			posY = mActiveAfterImages[aftImgIndex].ScreenPos.Y - (mActiveAfterImages[aftImgIndex].ySize/2);
			aCanvas.SetPos(posX,posY);
			posX = (mActiveAfterImages[aftImgIndex].xSize);
			posY = (mActiveAfterImages[aftImgIndex].ySize);
			aCanvas.DrawTile( mAfterImageColourspotTexture, posX, posY, 0, 0, mAfterImageColourspotTexture.VSize/2, mAfterImageColourspotTexture.USize/2);

			// dark spot
			fadeProp = 1 - fadeProp;
			alpha = 255 * fadeProp;
			if(alpha == 0) alpha = 1;	// IC : DrawTile strangeness with alpha = 0
			aCanvas.SetDrawColor( 255, 255, 255, alpha);
			posX = mActiveAfterImages[aftImgIndex].ScreenPos.X - (mActiveAfterImages[aftImgIndex].xSize/2) + mDarkSpotInsetAmount;
			posY = mActiveAfterImages[aftImgIndex].ScreenPos.Y - (mActiveAfterImages[aftImgIndex].ySize/2) + mDarkSpotInsetAmount;
			aCanvas.SetPos(posX,posY);
			posX = (mActiveAfterImages[aftImgIndex].xSize) - mDarkSpotInsetAmount;
			posY = (mActiveAfterImages[aftImgIndex].ySize) - mDarkSpotInsetAmount;
			aCanvas.DrawTile( mAfterImageDarkspotTexture, posX, posY, 0, 0, mAfterImageDarkspotTexture.VSize/2, mAfterImageDarkspotTexture.USize/2);
		}
		else if (tTime < (mActiveAfterImages[aftImgIndex].ColourspotFadeDuration + mActiveAfterImages[aftImgIndex].DarkspotFadeDuration))
		{
			// during DarkspotFadeDuration => fade darkspot out to 0%

			// darkspot
			fadeProp = 1 - ((tTime - mActiveAfterImages[aftImgIndex].ColourspotFadeDuration) / mActiveAfterImages[aftImgIndex].DarkspotFadeDuration);
			alpha = 255 * fadeProp;
			if(alpha == 0) alpha = 1;	// IC : DrawTile strangeness with alpha = 0
			aCanvas.SetDrawColor( 255, 255, 255, alpha);
			posX = mActiveAfterImages[aftImgIndex].ScreenPos.X - (mActiveAfterImages[aftImgIndex].xSize/2) + mDarkSpotInsetAmount;
			posY = mActiveAfterImages[aftImgIndex].ScreenPos.Y - (mActiveAfterImages[aftImgIndex].ySize/2) + mDarkSpotInsetAmount;
			aCanvas.SetPos(posX,posY);
			posX = (mActiveAfterImages[aftImgIndex].xSize) - mDarkSpotInsetAmount;
			posY = (mActiveAfterImages[aftImgIndex].ySize) - mDarkSpotInsetAmount;
			aCanvas.DrawTile( mAfterImageDarkspotTexture, posX, posY, 0, 0, mAfterImageDarkspotTexture.VSize/2, mAfterImageDarkspotTexture.USize/2);
		}
		else
		{
			mActiveAfterImages.Remove(aftImgIndex,1);
			aftImgIndex--;	// NB list get's renumbered after Remove()
		}
	}

	// reset canvas state
	aCanvas.bNoSmooth = true;
}

//------------------------------------------------------------------------------
//
//
simulated function DrawVignettes (Canvas aCanvas)
{
	local float tTime;
	local int alpha;
	local int fvIndex;
	local int period;
	local sFlashAndVignette flashVignette;
	local Texture flashTex;
	local Texture brightnessTex;
	local float fFVTime;
	local float fTemp;
	local float fTemp2;
	local int iNumKeys;
	local float fPercentage;
	local int iLowerKey;
	local int iHigherKey;
	local float intensitydiff;
	local float finalIntensity;
	local int i;
	local int iIndex;
	local float fTotalEffectTime;
	local float fLightIntensity;

	flashTex = Texture'SfxTx.flashbang.FxScr_FlashAlpha';
	brightnessTex = Texture'BlackTexture';
	
	

	for(fvIndex=0;fvIndex<mFlashVignettes.Length;fvIndex++)
	{
		flashVignette = mFlashVignettes[fvIndex];		// NB flashVignette is a copy, not a reference!!
		tTime = Owner.Level.TimeSeconds - flashVignette.StartTime;

		// sequence is :-
		//		flash white texture for duration of first period.
		//			alpha ranges linearly from 1 -> FlashMaxAlpha -> 1
		//		OverlayDuration before end of first period start second period
		//			vignette fades in from 1 -> VignetteMaxAlpha -> 1

		// establish period - 1 = flash only, 2 = overlay both, 3 = vignette only
		period = 2;

		if( flashVignette.FlashDurations[flashVignette.NumFlashKeys-1] > flashVignette.VignetteDurations[flashVignette.NumVignetteKeys-1] )
		{
			fTemp = flashVignette.VignetteDurations[flashVignette.NumVignetteKeys-1];
			fFVTime = flashVignette.FlashDurations[flashVignette.NumFlashKeys-1];
			fTemp2 = flashVignette.FlashDurations[0];
		}
		else
		{
			fTemp = flashVignette.FlashDurations[flashVignette.NumFlashKeys-1];
			fFVTime = flashVignette.VignetteDurations[flashVignette.NumVignetteKeys-1];
			fTemp2 = flashVignette.VignetteDurations[0];
		}
		if( fFVTime > flashVignette.BrightnessDurations[flashVignette.NumBrightnessKeys-1] )
			fTotalEffectTime = fFVTime;
		else
			fTotalEffectTime = flashVignette.BrightnessDurations[flashVignette.NumBrightnessKeys-1];
		if(tTime > fTotalEffectTime )
		{
			mFlashVignettes.Remove(fvIndex,1);
			fvIndex--;	// NB list get's renumbered after Remove()
			continue;
		}
		else if(tTime > fTemp)
		{
			period = 3;
		}
		else if(tTime < fTemp2)
		{
			period = 1;
		}


		// common canvas state
		aCanvas.bNoSmooth = false;
		aCanvas.Style = ERenderStyle.STY_Translucent;
		if( tTime <= flashVignette.BrightnessDurations[flashVignette.NumBrightnessKeys-1] )
		{
			// do the brightness tweak here first
			// calculate the brightness intensity and render
			iNumKeys = flashVignette.NumBrightnessKeys;
			iLowerKey = 0;
			iHigherKey = 1;
			iIndex = iNumKeys-2;
			for( i=iNumKeys-2; i>=0; i-- )
			{
				if( tTime > flashVignette.BrightnessDurations[i] )
					break;
				iIndex--;
			}
			if( iIndex != 0 && iIndex<iNumKeys-1 )
			{
				iLowerKey = iIndex;
				iHigherKey = iIndex+1;
			}
			fPercentage = (tTime-flashVignette.BrightnessDurations[iLowerKey])/(flashVignette.BrightnessDurations[iHigherKey] - flashVignette.BrightnessDurations[iLowerKey]);
			intensitydiff = flashVignette.BrightnessIntensities[iHigherKey] - flashVignette.BrightnessIntensities[iLowerKey];
			finalIntensity = (fPercentage * intensitydiff) + flashVignette.BrightnessIntensities[iLowerKey];
			finalIntensity = 1.0 - finalIntensity;
			alpha = (finalIntensity * 255) + 1;
			aCanvas.SetPos(0,0);
			aCanvas.SetDrawColor( 255, 255, 255, alpha);
			aCanvas.DrawTile(brightnessTex, aCanvas.SizeX, aCanvas.SizeY, 0, 0, brightnessTex.VSize, brightnessTex.USize);
		}
	
		aCanvas.Style = ERenderStyle.STY_Alpha;

		if(period == 1 || period == 2)
		{
			// calculate the flash intensity and render
			iNumKeys = flashVignette.NumFlashKeys;
			iLowerKey = 0;
			iHigherKey = 1;
			iIndex = iNumKeys - 2;
			for( i=iNumKeys-2; i>=0; i-- )
			{
				if( tTime > flashVignette.FlashDurations[i] )
					break;
				iIndex--;
			}
			if( iIndex != 0 && iIndex<(iNumKeys-1) )
			{
				iLowerKey = iIndex;
				iHigherKey = iIndex+1;
			}

			fPercentage = (tTime-flashVignette.FlashDurations[iLowerKey])/(flashVignette.FlashDurations[iHigherKey] - flashVignette.FlashDurations[iLowerKey]);
			intensitydiff = flashVignette.FlashIntensities[iHigherKey] - flashVignette.FlashIntensities[iLowerKey];
			finalIntensity = (fPercentage * intensitydiff) + flashVignette.FlashIntensities[iLowerKey];
			
			
			// apply custom intensity based on flare overlay timeline to the dynamic light
			// light is of new type defined as LT_CustomLightIntensity where in u define the custom intensity
			fLightIntensity = finalIntensity;
			if( fLightIntensity > 1.0 )fLightIntensity = 1.0;
			if( fLightIntensity < 0.0 )fLightIntensity = 0.0;
			
			flashVignette.flasher.LightCustomIntensity = fLightIntensity;
			alpha = finalIntensity * 255;
			aCanvas.SetPos(0,0);
			aCanvas.SetDrawColor( 255, 255, 255, alpha);
			aCanvas.DrawTile(flashTex, aCanvas.SizeX, aCanvas.SizeY, 0, 0, flashTex.VSize, flashTex.USize);
			
			aCanvas.Style = ERenderStyle.STY_Modulated;
			aCanvas.SetPos(0,0);
			aCanvas.SetDrawColor( 255, 255, 255, alpha);
			aCanvas.DrawTile(mFalshBangDefaults.FlashModulateTexture, aCanvas.SizeX, aCanvas.SizeY, 0, 0, mFalshBangDefaults.FlashModulateTexture.VSize, mFalshBangDefaults.FlashModulateTexture.USize);
		}
		if(period == 2 || period == 3)
		{
			aCanvas.Style = ERenderStyle.STY_Subtractive;
			// now the vignette
			iNumKeys = flashVignette.NumVignetteKeys;
			iLowerKey = 0;
			iHigherKey = 1;
			iIndex = iNumKeys-2;
			for( i=iIndex; i>=0; i-- )
			{
				if( tTime > flashVignette.VignetteDurations[i] )
					break;
				iIndex--;
			}
			if( iIndex!=0 && iIndex<(iNumKeys-1) )
			{
				iLowerKey = iIndex;
				iHigherKey = iIndex+1;
			}
			
			fPercentage = (tTime-flashVignette.VignetteDurations[iLowerKey])/(flashVignette.VignetteDurations[iHigherKey] - flashVignette.VignetteDurations[iLowerKey]);
			intensitydiff = flashVignette.VignetteIntensities[iHigherKey] - flashVignette.VignetteIntensities[iLowerKey];
			finalIntensity = (fPercentage * intensitydiff) + flashVignette.VignetteIntensities[iLowerKey];
			alpha = finalIntensity * 255;
			aCanvas.SetPos(0,0);
			aCanvas.SetDrawColor( 255, 255, 255, alpha);
			aCanvas.DrawTile(mFalshBangDefaults.VignetteTexture, aCanvas.SizeX, aCanvas.SizeY, 0, 0, mFalshBangDefaults.VignetteTexture.VSize, mFalshBangDefaults.VignetteTexture.USize);
		}
		

		// restore canvas state
		aCanvas.bNoSmooth = true;
	}
}

//------------------------------------------------------------------------------
//
//
simulated function FlashBangWhiteOut(Actor flasher)
{
	// ICTODO : modify vignette effect, based on flasher's proximity
	local sFlashAndVignette flashVignette;
	local int i;

	flashVignette.Type = SASFAV_FLASHBANG;
	flashVignette.StartTime = Owner.Level.TimeSeconds;
	
	
	flashVignette.NumFlashKeys = mFalshBangDefaults.NumFlashKeys;
	flashVignette.NumVignetteKeys = mFalshBangDefaults.NumVignetteKeys;
	flashVignette.NumBrightnessKeys = mFalshBangDefaults.NumBrightnessKeys;
	
	for( i=0; i<mFalshBangDefaults.NumFlashKeys; i++ )
	{
		flashVignette.FlashDurations[i] = mFalshBangDefaults.FlashDurations[i];
		flashVignette.FlashIntensities[i] = mFalshBangDefaults.FlashIntensities[i];
	}
	
	for( i=0; i<mFalshBangDefaults.NumVignetteKeys; i++ )
	{
		flashVignette.VignetteDurations[i] = mFalshBangDefaults.VignetteDurations[i];
		flashVignette.VignetteIntensities[i] = mFalshBangDefaults.VignetteIntensities[i];
	}
	
	for( i=0; i<mFalshBangDefaults.NumBrightnessKeys; i++ )
	{
		flashVignette.BrightnessDurations[i] = mFalshBangDefaults.BrightnessDurations[i];
		flashVignette.BrightnessIntensities[i] = mFalshBangDefaults.BrightnessIntensities[i];
	}
	
	flashVignette.flasher = flasher;

	mFlashVignettes[mFlashVignettes.Length] = flashVignette;
	//if(mFlashVignettes.Length==0) // ICTESTING
		//mFlashVignettes[0] = flashVignette;		// IC - just one vignette, reset current one
}

//------------------------------------------------------------------------------
//
//
simulated function bool BlindingBrightFlash(Actor flasher)
{
	// ICTODO  : move this to player actor, pass in flash creating actor, and do visibility check

	local PlayerController	PC;
	local sAfterImage		aftImg;
	local float				szRatio;
	local vector			distToCamera;
	local vector			playerEyePos;
	local Actor				traceHitActor;
	local vector			traceHitLocation;
	local vector			traceHitNormal;
	local SASPlayerController	sasPC;

	if(mActiveAfterImages.Length == mMaxAfterImages)
	{
		return false;
	}

	PC = Level.GetLocalPlayerController();
	if ( PC == None )
	{
		return false;
	}

	distToCamera = flasher.Location - PC.Pawn.Location;
	playerEyePos = PC.Pawn.Location + PC.Pawn.EyePosition();

	// check if the flasher is occluded
	traceHitActor = PC.Pawn.Trace(traceHitLocation, traceHitNormal, flasher.Location, playerEyePos, true,,,true);	// ignore transparent
	if(traceHitActor!=none && traceHitActor!=PC.Pawn)
	{
		return FALSE;	// obscured from view
	}

	if ( (Vector(PC.Pawn.Rotation) Dot (distToCamera)) > -0.5)
	{
		aftImg.StartTime = Owner.Level.TimeSeconds;
		aftImg.DarkspotFadeDuration = mAfterImageDarkspotFadeDurationRange.Min + (FRand() * (mAfterImageDarkspotFadeDurationRange.Max - mAfterImageDarkspotFadeDurationRange.Min));
		aftImg.ColourspotFadeDuration = mAfterImageColourspotFadeDurationRange.Min + (FRand() * (mAfterImageColourspotFadeDurationRange.Max - mAfterImageColourspotFadeDurationRange.Min));
		aftImg.ScreenPos = PC.Player.Console.WorldToScreen(flasher.Location);
		szRatio = vsize(distToCamera / 100);
		//aftImg.xSize = clamp(mXPixSizeAtDist100 / szRatio, 0, 1600*2);	// half afterimage viewable over max resolution width
		//aftImg.ySize = clamp(mYPixSizeAtDist100 / szRatio, 0, 1200*2);	// half afterimage viewable over max resolution height
		aftImg.xSize = clamp(mXPixSizeAtDist100 / szRatio, mMaxXPixSize.Min, mMaxXPixSize.Max);
		aftImg.ySize = clamp(mYPixSizeAtDist100 / szRatio, mMaxYPixSize.Min, mMaxYPixSize.Max);

		mActiveAfterImages[mActiveAfterImages.Length] = aftImg;

		FlashBangWhiteOut(flasher);
		// start out flashbangcameffect
		sasPC = SASPlayerController( Level.GetLocalPlayerController() );
		sasPC.DoFlashbangCamEffect();
		
	}
	else
	{
		return FALSE;
	}

	return TRUE;
}

//------------------------------------------------------------------------------
//
//
simulated function DrawSplatTexture (Canvas aCanvas)
{
	local float tTime;
	local int i;

	tTime = Owner.Level.TimeSeconds-mSplatStartTime;

	if ((tTime < (mInitialSplatNoFadeLength + mSplatFadeLength)) && (mSplatted))
	{
		aCanvas.bNoSmooth = false;
		aCanvas.SetPos(0,0);

		//STY_None,
		//STY_Normal,
		//STY_Masked,
		//STY_Translucent,
		//STY_Modulated,
		//STY_Alpha,
		//STY_Additive,
		//STY_Subtractive,
		//STY_Particle,
		//STY_AlphaZ,

		aCanvas.Style = ERenderStyle.STY_Alpha;
		if (tTime > mInitialSplatNoFadeLength)
		{
			aCanvas.SetDrawColor( 121, 25, 36, 255 - (254 * ((tTime - mInitialSplatNoFadeLength) / mSplatFadeLength)));
		}
		else
		{
			aCanvas.SetDrawColor( 121, 25, 36, 255 );
		}
		aCanvas.DrawTile( mSplatTexture[mCurSplatTex], aCanvas.SizeX, aCanvas.SizeY,
						  mTSU*mSplatTexture[mCurSplatTex].USize, mTSV*mSplatTexture[mCurSplatTex].VSize, 0.5*mSplatTexture[mCurSplatTex].USize, 0.5*mSplatTexture[mCurSplatTex].VSize );

		for (i=0; i<mNumDrips; i++)
		{
			aCanvas.SetPos(mDripX[i] * aCanvas.SizeX, mDripY[i] * aCanvas.SizeY);
			aCanvas.DrawTile( mDripTexture, mDripSize[i] , mDripSize[i]  + ( mDripTravel[i]  * ((tTime) / (mInitialSplatNoFadeLength + mSplatFadeLength))), 0, 0, mDripTexture.USize, mDripTexture.VSize);
		}
		aCanvas.bNoSmooth = true;
	}
	else
	{
		mSplatted = false;
	}

}

/*
//------------------------------------------------------------------------------
//
//
simulated function DrawSASOutlineBox(canvas canvas, float width, float height)
{
	local float X, Y;

	X = canvas.CurX;
	Y = canvas.CurY;

	canvas.SetDrawColor( 200, 200, 250, 80 );

	canvas.DrawRect(mDefTexture, 1, height);
	canvas.DrawRect(mDefTexture, width, 1);
	canvas.SetPos(X + width, Y);
	canvas.DrawRect(mDefTexture, 1, height);
	canvas.SetPos(X, Y + height);
	canvas.DrawRect(mDefTexture, width+1, 1);
	canvas.SetPos(X, Y);
}
*/

/*
//------------------------------------------------------------------------------
//
//
simulated function DrawSASBox(canvas canvas, float width, float height)
{
	local float X, Y;

	X = canvas.CurX;
	Y = canvas.CurY;
	canvas.Style = ERenderStyle.STY_Alpha;

	canvas.SetDrawColor( 20, 20, 55, 80 );
	canvas.DrawRect( mDefTexture, width , height);
	canvas.SetPos(X,Y);
	DrawSASOutlineBox(canvas,width,height);

	canvas.SetDrawColor( 200, 200, 250, 255 );

	canvas.Style = ERenderStyle.STY_Normal;
}
*/

/*
//------------------------------------------------------------------------------
//
//
simulated function DrawSASColouredBoxAt ( Canvas aCanvas, float X, float Y, float width, float height, Color aColour )
{
	aCanvas.Style = ERenderStyle.STY_Alpha;

	aCanvas.DrawColor = aColour;
	aCanvas.SetPos ( X, Y );
	aCanvas.DrawRect( mDefTexture, width , height);

	aCanvas.Style = ERenderStyle.STY_Normal;
}
*/

//------------------------------------------------------------------------------
//
//
//::simulated function DrawSASTexItem ( canvas canvas, material aMat, float SizeX, float SizeY, float SizeU, float SizeV )
//::{
//::	local float X, Y;
//::	X = canvas.CurX;
//::	Y = canvas.CurY;
//::	canvas.Style = ERenderStyle.STY_Alpha;
//::
//::	canvas.SetDrawColor ( 255, 255, 255, 255 );
//::	canvas.DrawTile ( aMat, SizeX, SizeY, 0, 0, SizeU, SizeV );
//::
//::	canvas.Style = ERenderStyle.STY_Normal;
//::}

//------------------------------------------------------------------------------
// DrawTime
//
simulated function DrawTime( canvas aCanvas )
{
	local float	fy;
	local float time;

	// perhaps don't draw the time at all.
	// Not sure if bytes are signed...
	if (mWhichTimerToShow < 0 || mWhichTimerToShow >= 128)
		return;

	// GP: Big fat hack: Use the level timer if in single player game else
	// use the GRI Elapsed time var. Should make the ElpsedTime var work in
	// single player also.
	if ( Level.NetMode == NM_Standalone )
	{
		time = mSASGRI.GetLevelTimer(mWhichTimerToShow);
	}
	else
	{
		time = mSASGRI.ElapsedTime;
	}

	aCanvas.SetPos ( 5, 70 );

	if (aCanvas.ClipX < 1024)
	{
		aCanvas.Font = aCanvas.FontBig24;
	}
	else
	{
		aCanvas.Font = aCanvas.FontBig34;
	}

	if ( mTimeStringLength == 0 )
	{
		aCanvas.StrLen ( mSASGRI.GetTimeString (time), mTimeStringLength, fy );	// I'm just looking for the string length here ...
	}

	aCanvas.SetPos ( aCanvas.SizeX * 0.5 - mTimeStringLength / 2, TIME_STRING_Y );

	SetOrangeColour(aCanvas);
	aCanvas.DrawText ( mSASGRI.GetTimeString (time), TRUE );
}

//------------------------------------------------------------------------------
// DrawObjectives
//
simulated function bool QueryObjectiveStatusChanged ()
{
	local int i;
	local bool retval;

	// ensure we catch all status changes during each query
	retval = false;

	// first time through, ensure query array is big enough
	if ( mObjectiveQueryStatus.Length < mObjectiveManager.mNumObjectives )
	{
		mObjectiveQueryStatus.Length = mObjectiveManager.mNumObjectives;
	}
	// iterate through array looking for status changes
	for ( i = 0; i < mObjectiveManager.mNumObjectives; i++ )
	{
		if ( mObjectiveManager.mObjectiveStatus[i] != mObjectiveQueryStatus[i] )
		{
			// found one, update and flag
			mObjectiveQueryStatus[i] = mObjectiveManager.mObjectiveStatus[i];
			retval = true;
		}
	}
	// return status changed
	return retval;
}

simulated function DrawObjectives ( canvas aCanvas )
{
	local int	i;
	local float	fx,
				fy,
				fPos;
	local eObjectiveStatus	status;
	local float tAlpha;
	local float tTime;

	if ( mObjectiveManager == None )
	{
		return;
	}
	if ( QueryObjectiveStatusChanged () )
	{
		mObjectiveDisplayStartTime = Level.TimeSeconds;
	}
	if ( mObjectiveDisplayStartTime < 0.0001 )
	{
		return;
	}
	tTime = Level.TimeSeconds - mObjectiveDisplayStartTime;
	if ( tTime < mObjectiveDisplayOnTime )
	{
		tAlpha = 1.0f;
	}
	else
	{
		tAlpha = 1.0f - ( ( tTime - mObjectiveDisplayOnTime ) / mObjectiveDisplayFadeTime );
	}
	if ( tAlpha < 0.01 )
	{
		mObjectiveDisplayStartTime = 0.0;
		return;
	}

	SetOrangeColour(aCanvas);

	// Objectives smaller res
	if (aCanvas.ClipX < 1024)
	{
		aCanvas.Font = aCanvas.FontSmall10;
	}
	else
	{
		aCanvas.Font = aCanvas.FontBig16;
	}

	aCanvas.StrLen ( "Test", fx, fy );	// I'm just looking for the font height here ...

	fPos = 80;

	for ( i = 0; i < mObjectiveManager.mNumObjectives; i++ )
	{
		// the mObjectiveStatus array mirrors the SASObjective.mbEnabled flag
		// and is replicated around the network
		
		// We see all objectives, primary and secondary
		if ( ( mObjectiveManager.mObjectiveStatus[i] != OBJECTIVESTATUS_Disabled ) &&
				mObjectiveManager.mObjectives[i].mTextString != "" )
		{
			aCanvas.SetPos ( 28, fPos );
			status = mObjectiveManager.mObjectiveStatus[i];
			switch ( status )
			{
			case OBJECTIVESTATUS_Failed:
				aCanvas.SetDrawColor ( 255,   0,   0, 255 * tAlpha );
				break;
			case OBJECTIVESTATUS_InProgress:
				aCanvas.SetDrawColor ( 255, 255, 255, 255 * tAlpha );
				break;
			case OBJECTIVESTATUS_Succeeded:
				aCanvas.SetDrawColor ( 255, 255,   0, 255 * tAlpha );
				break;
			default:
				break;
			}
			
			aCanvas.DrawText ( mObjectiveManager.mStrObjective $mObjectiveManager.mObjectiveChars[i] $mObjectiveManager.mObjectives[i].mTextString $mObjectiveManager.mStatusStrings[status], true );
			fPos += fy;
			aCanvas.SetDrawColor( 255, 255, 255, 255 );
		}
	}
}

function SetDarkOrangeColour(Canvas aCanvas)
{
	aCanvas.SetDrawColor( OrangeColour.R / 2, OrangeColour.G / 2, OrangeColour.B / 2, OrangeColour.A / 2 );
}

function SetOrangeColour(Canvas aCanvas)
{
	aCanvas.SetDrawColor( OrangeColour.R, OrangeColour.G, OrangeColour.B, OrangeColour.A );
}

//------------------------------------------------------------------------------
// DrawPawnStats
//
simulated function DrawPawnStats ( Canvas aCanvas, SASPawn aPawn, float X, bool is_player, bool bIsTerrorist )
{
	local float head_width;
	local float head_height;
	local Texture headTex;

	local float healthfraction;
	local float uXFade;
	local float vXFade;
	local float UFull;
	local float VFull;
	local float Y;
	
	// the texture page is a different size if screen res different.
	local float texture_page_size;
	
	if (aCanvas.ClipX < 1024)
		Y = HEAD_Y_RES1;
	else
		Y = HEAD_Y;
	
	texture_page_size = 256;
	
	if (is_player)
	{
		head_width=PLAYER_HEAD_WIDTH;
		uXFade=62;
		vXFade=0;
		head_height = PLAYER_HEAD_HEIGHT;
		UFull=0;
		VFull=0;

		if ( !bIsTerrorist )
		{
			if (aCanvas.ClipX < 1024)
			{
				// Resolution 1 (640/480 and 800/600)
				head_width=PLAYER_HEAD_FADED_RES1;
				uXFade=PLAYER_HEAD_FADED_U_RES1;
				vXFade=0;
				head_height = 56;
				UFull=0;
				VFull=0;
				headTex = mOrangeHeadsRes1;
				texture_page_size = 128;
			}
			else
			{
				// Resolution 2 (1024/768 and higher)
				headTex = mOrangeHeads;
			}
		}
		else
		{
			headTex = mOrangeHeadsTerr;
		}
	}
	else
	{
		head_width=SQUAD_HEAD_WIDTH;
		uXFade=50;
		vXFade=PLAYER_HEAD_HEIGHT;
		head_height = SQUAD_HEAD_HEIGHT;
		UFull=0;
		VFull=PLAYER_HEAD_HEIGHT;

		if (aCanvas.ClipX < 1024)
		{
			// Resolution 1 (640/480 and 800/600)
			head_width=33;
			uXFade=37;
			vXFade=56;
			head_height = 46;
			UFull=0;
			VFull=56;
			headTex = mOrangeHeadsRes1;
			texture_page_size = 128;
		}
		else
		{
			// Resolution 2 (1024/768 and higher)
			headTex = mOrangeHeads;
		}
	}

	SetOrangeColour(aCanvas);

	if ( aPawn == None || aPawn.IsDead () || aPawn.mbIsIncapacitated )
		healthfraction = 0.0;
	else
	{
		// We split the dude up into healthy and unhealthy bits
		healthfraction = (aPawn.Health * 1000 / aPawn.mInitialHealth);
		healthfraction *= 1.0 / 1000.0;
	}
	
	if ( (aPawn != None && !aPawn.IsDead ()) && (healthfraction > 0.0001 || aPawn.mbIsIncapacitated) )
	{
		//write the Xcross fade in guy
		aCanvas.SetPos(X-2, Y - head_height); 
		aCanvas.DrawTileSafe ( headTex,
								head_width,	
								head_height * (1.f - healthfraction),
								uXFade,
								vXFade,
								head_width,
								head_height* (1.f - healthfraction),
								texture_page_size,
	 							texture_page_size );
	 							
		if ( healthfraction > 0.0 )
		{
			aCanvas.SetPos ( X-4,Y - head_height * healthfraction );
			aCanvas.DrawTileSafe ( headTex,
									head_width,
								head_height*healthfraction,
								UFull,
								VFull+ head_height * (1.f - healthfraction),
								head_width,
								head_height * (healthfraction),
								texture_page_size,
								texture_page_size );
		}
						
	}
	else if( healthfraction < 0.0001 )
	{
		aCanvas.SetPos(X-2, Y - head_height); 
		aCanvas.DrawTileSafe ( headTex,
								head_width,	
								head_height,
								uXFade+head_width,
								vXFade,
								head_width,
								head_height,
								texture_page_size,
	 							texture_page_size );
	 }
}

simulated function DrawIndicators ( Canvas aCanvas, SASPawn aPawn, float X, float Y )
{
	local SASSoldier	myPawn;
	local SASSoldier	myWingman;

	if (aCanvas.ClipX < 1024)
	{
		aCanvas.Font = aCanvas.FontBig24;
	}
	else
	{
		aCanvas.Font = aCanvas.FontBig34;
	}

	// if already dead
	if ( ( aPawn == None ) || ( aPawn.IsDead () ) )
	{
		aCanvas.SetPos ( X + 30, Y + 63 );
		aCanvas.SetDrawColor ( 255, 0, 0, 255 );
		aCanvas.DrawText ( mLabelDead );
	} // if
	else
	{
		// Human & Wingman indicators only on live pawns
		myPawn = SASSoldier( PlayerController ( Owner ).Pawn );
		if ( myPawn != None )
		{
			// wingman indication ...
			myWingman = mSquadManager.GetPlayersWingman( myPawn );
			if ( myWingman == aPawn )
			{
				aCanvas.SetPos ( X + 20, Y + 63 );
				aCanvas.SetDrawColor ( 0, 0, 255, 255 );
				aCanvas.DrawText ( mLabelWingman );
			} // if

			// human controller indication ... but not me!
			if ( ( aPawn != myPawn ) && ( mSquadManager.GetPlayerSlotIdx ( SASSoldier( aPawn ) ) != -1 ) )
			{
				aCanvas.SetPos ( X + 20, Y + 63 );
				aCanvas.SetDrawColor ( 255, 0, 0, 255 );
				aCanvas.DrawText ( mLabelHuman );
			} // if
		} // if

		if ( aPawn.mbIsIncapacitated )
		{
			aCanvas.SetPos ( X + 30, Y + 63 );
			aCanvas.SetDrawColor ( 255, 127, 0, 255 );
			aCanvas.DrawText ( mLabelIncapacitated );
		} // if
		else
		{
			aCanvas.SetPos ( X + 30, Y + 63 );
			aCanvas.SetDrawColor ( 0, 255, 0, 255 );
			aCanvas.DrawText ( mLabelOK );
		} // else

		//////////////////////////////////
		// AF Debug stuff
		// Pawn ammo status
		if (SASWeapon (aPawn.Weapon) != None)
		{
			aCanvas.SetDrawColor ( 200, 200, 250, 255 );
			aCanvas.SetPos ( X, Y );
			aCanvas.DrawText( SASWeapon ( aPawn.Weapon ).mNumInMag);
		} // if

		// Pawn health
		//aCanvas.SetDrawColor ( 255, 255, 100, 255 );
		//aCanvas.SetPos ( X, Y+10 );
		//aCanvas.DrawText(aPawn.mDamageSpeedMod);
		//////////////////////////////////
}	} // else


//------------------------------------------------------------------------------
//
//





simulated function DrawPlayerStats(
	Canvas				aCanvas,
	SASPlayerController	aPC )
{
	local SASPawn				tPawn;
	local SASWeapon				tWeapon;
	local float					mag_fullness;
	local int					i;
	
	
	local float					ChargePosX;
	local float					StartU;
	
	//temporary variables remove after use
	local float					WScaleFactor;
	local float					fWX,
								fWy;
	local int					iLen;
	local bool					bIsTerrist;
	local Texture				tex;
	
	// charge bar
	local float					mFractionCharge;
	local Texture				chargeBar;
	local float					chargeBarHeight;
	local float					chargeBarWidth;
	local float					playerHeadRightness;
	
	local float local_burst_leftness;
	local float local_ammo_count_leftness;
	
	local Texture				clips;
	
	// the mags vary in position with the two resolutions too
	local float local_CURRENT_MAG_LEFTNESS;
	local float local_CURRENT_MAG_UPNESS;
	local float local_CURRENT_MAG_WIDTH;
	local float local_CURRENT_MAG_HEIGHT;
	local float local_EMPTY_MAG_U;
	local float local_CURRENT_MAG_V;
	local float local_FULL_MAG_U;
	local float local_EXTRA_MAGS_LEFTNESS;
	local float local_EXTRA_MAG_RIGHT_STEP;
	local float local_EXTRA_MAGS_UPNESS;
	local float local_EXTRA_MAG_WIDTH;
	local float local_EXTRA_MAG_HEIGHT;
	local float local_EXTRA_MAG_U;
	local float local_EXTRA_MAG_V;

	local float local_ammo_count_upness;

	
	// lots of stuff depends on resolution
	if (aCanvas.ClipX < 1024)
	{
		// Resolution 1 (640/480 and 800/600)
		chargeBar = mOrangeChargeBarRes1;
		chargeBarHeight = CHARGE_BAR_HEIGHT_RES1;
		chargeBarWidth = CHARGE_BAR_WIDTH_RES1;
		clips = mOrangeClipsRes1;
		playerHeadRightness = PLAYER_HEAD_RIGHTNESS_RES1;
		
		local_CURRENT_MAG_LEFTNESS = CURRENT_MAG_LEFTNESS_RES1;
		local_CURRENT_MAG_UPNESS = CURRENT_MAG_UPNESS_RES1;
		local_CURRENT_MAG_WIDTH = CURRENT_MAG_WIDTH_RES1;
		local_CURRENT_MAG_HEIGHT = CURRENT_MAG_HEIGHT_RES1;
		local_EMPTY_MAG_U = EMPTY_MAG_U_RES1;
		local_CURRENT_MAG_V = CURRENT_MAG_V_RES1;
		local_FULL_MAG_U = FULL_MAG_U_RES1;
		local_EXTRA_MAGS_LEFTNESS = EXTRA_MAGS_LEFTNESS_RES1;
		local_EXTRA_MAG_RIGHT_STEP = EXTRA_MAG_RIGHT_STEP_RES1;
		local_EXTRA_MAGS_UPNESS = EXTRA_MAGS_UPNESS_RES1;
		local_EXTRA_MAG_WIDTH = EXTRA_MAG_WIDTH_RES1;
		local_EXTRA_MAG_HEIGHT = EXTRA_MAG_HEIGHT_RES1;
		local_EXTRA_MAG_U = EXTRA_MAG_U_RES1;
		local_EXTRA_MAG_V = EXTRA_MAG_V_RES1;
	}
	else
	{
		// Resolution 2 (1024/768 and higher)
		chargeBar = mOrangeChargeBar;
		chargeBarHeight = CHARGE_BAR_HEIGHT;
		chargeBarWidth = CHARGE_BAR_WIDTH;
		clips = mOrangeClips;
		playerHeadRightness = PLAYER_HEAD_RIGHTNESS;
		
		local_CURRENT_MAG_LEFTNESS = CURRENT_MAG_LEFTNESS;
		local_CURRENT_MAG_UPNESS = CURRENT_MAG_UPNESS;
		local_CURRENT_MAG_WIDTH = CURRENT_MAG_WIDTH;
		local_CURRENT_MAG_HEIGHT = CURRENT_MAG_HEIGHT;
		local_EMPTY_MAG_U = EMPTY_MAG_U;
		local_CURRENT_MAG_V = CURRENT_MAG_V;
		local_FULL_MAG_U = FULL_MAG_U;
		local_EXTRA_MAGS_LEFTNESS = EXTRA_MAGS_LEFTNESS;
		local_EXTRA_MAG_RIGHT_STEP = EXTRA_MAG_RIGHT_STEP;
		local_EXTRA_MAGS_UPNESS = EXTRA_MAGS_UPNESS;
		local_EXTRA_MAG_WIDTH = EXTRA_MAG_WIDTH;
		local_EXTRA_MAG_HEIGHT = EXTRA_MAG_HEIGHT;
		local_EXTRA_MAG_U = EXTRA_MAG_U;
		local_EXTRA_MAG_V = EXTRA_MAG_V;
	}
	
	WScaleFactor=WEAPON_ICON_SCALE_FACTOR;
	
	if ( aPC == None )
		return;

	if ( aPC.Pawn != None )
	{
		tPawn = SASPawn ( aPC.Pawn );
	}

	if ( tPawn == None )
		return;

	// the player's health
	if ( mSASGRI != None && mSASGRI.mDifficultySetting.ShowHealth == 1 )
	{
		if (	aPC.PlayerReplicationInfo != None && aPC.PlayerReplicationInfo.Team != None &&
				aPC.PlayerReplicationInfo.Team.TeamIndex == 1 )
		{
			bIsTerrist = true;
		}
		DrawPawnStats ( aCanvas, tPawn, aCanvas.SizeX * 0.5 + playerHeadRightness, true, bIsTerrist );
	}
	
	if ( mSASGRI != None && mSASGRI.mDifficultySetting.ShowCharge == 1 )
	{
		// do run charge bar
		mFractionCharge=aPC.mChargeAmount;
		if(mFractionCharge<0)
			mFractionCharge=0;
		if(mFractionCharge > 0.999)
		{
			ChargePosX=(aCanvas.SizeX * 0.5 - chargeBarWidth - CHARGE_BAR_LEFTNESS);
			aCanvas.SetPos( ChargePosX, CHARGE_BAR_Y );
			aCanvas.DrawTileSafe ( chargeBar,
							chargeBarWidth,
							chargeBarHeight,
							0,
							FULL_CHARGE_BAR_V+chargeBarHeight+chargeBarHeight,
							chargeBarWidth,
							chargeBarHeight,
							ORANGESTUFF_TEXTURE_WIDTH,
							ORANGESTUFF_TEXTURE_HEIGHT );
		}
		else
		{
			StartU=0;	
			ChargePosX=(aCanvas.SizeX * 0.5 - chargeBarWidth - CHARGE_BAR_LEFTNESS)+ chargeBarWidth*(mFractionCharge);
				//SetChargeBarPos(aCanvas);
			aCanvas.SetPos( ChargePosX, CHARGE_BAR_Y );
    		aCanvas.DrawTileSafe ( chargeBar,
								chargeBarWidth*(1-mFractionCharge),
								chargeBarHeight,
								StartU+ chargeBarWidth*(mFractionCharge),
								FULL_CHARGE_BAR_V+chargeBarHeight,
								chargeBarWidth*(1-mFractionCharge),
								chargeBarHeight,
								ORANGESTUFF_TEXTURE_WIDTH,
								ORANGESTUFF_TEXTURE_HEIGHT );

			
	
	
			ChargePosX=(aCanvas.SizeX * 0.5 - chargeBarWidth - CHARGE_BAR_LEFTNESS);//+ chargeBarWidth*(1-mFractionCharge);
		
			aCanvas.SetPos( ChargePosX, CHARGE_BAR_Y );
    		aCanvas.DrawTileSafe ( chargeBar,
								chargeBarWidth*mFractionCharge,
								chargeBarHeight,
								0,
								FULL_CHARGE_BAR_V,
								chargeBarWidth*mFractionCharge,
								chargeBarHeight,
								ORANGESTUFF_TEXTURE_WIDTH,
								ORANGESTUFF_TEXTURE_HEIGHT );
		
		}
	}

	// weapon stats
	if ( tPawn.Weapon != None && tPawn.Weapon.AmmoType != None )
	{
		tWeapon = SASWeapon ( tPawn.Weapon );
		if ( tWeapon != None && tWeapon.UsesAmmo )
		{
			// Grenade weapons use grenade icon for each round.
			if ( tWeapon.mCategory == WPNCAT_Grenade )
			{
				tex = tWeapon.mLineartWeapon;

				// Draw selected grenade.
				SetOrangeColour(aCanvas);
				aCanvas.SetPos (	
					aCanvas.SizeX - local_CURRENT_MAG_LEFTNESS-1,
					aCanvas.SizeY - local_CURRENT_MAG_UPNESS );
				aCanvas.DrawTileSafe ( 
					tex,
					local_CURRENT_MAG_WIDTH-8,
					local_CURRENT_MAG_HEIGHT,
					0,
					0,
					tex.USize,
					tex.VSize,
					tex.USize,
					tex.VSize );

				// Draw extra grenades.
				for (i = 0; i < tWeapon.AmmoType.AmmoAmount-1; i++ )
				{
					// indicate that you've got another mag available.
					aCanvas.SetPos ( aCanvas.SizeX - local_EXTRA_MAGS_LEFTNESS + local_EXTRA_MAG_RIGHT_STEP * i, aCanvas.SizeY - local_EXTRA_MAGS_UPNESS);
					aCanvas.DrawTileSafe ( 
						tex,
						local_EXTRA_MAG_WIDTH-8,
						local_EXTRA_MAG_HEIGHT,
						0,
						0,
						tex.USize,
						tex.VSize,
						tex.USize,
						tex.VSize );
				}
			}
			else
			{
				// how full is your current mag?
				if ( mSASGRI != None && mSASGRI.mDifficultySetting.ShowAmmo == 1 )
				{
					mag_fullness = ( tWeapon.mNumInMag * 1000) / tWeapon.mMagSize;
					mag_fullness *= (1.0 / 1000.0);
				
					//draw current mag
					aCanvas.SetPos ( aCanvas.SizeX - local_CURRENT_MAG_LEFTNESS-2, aCanvas.SizeY - local_CURRENT_MAG_UPNESS );
					aCanvas.DrawTileSafe ( clips,
										local_CURRENT_MAG_WIDTH-8,
										local_CURRENT_MAG_HEIGHT * (1.f - mag_fullness),
										local_EMPTY_MAG_U,
										local_CURRENT_MAG_V,
										local_CURRENT_MAG_WIDTH,
										local_CURRENT_MAG_HEIGHT * (1.f - mag_fullness),
										128,
										128 );
				}

				SetOrangeColour(aCanvas);
				aCanvas.SetPos ( aCanvas.SizeX - local_CURRENT_MAG_LEFTNESS-1,
								aCanvas.SizeY - local_CURRENT_MAG_UPNESS + local_CURRENT_MAG_HEIGHT * (1.f - mag_fullness) );
				aCanvas.DrawTileSafe ( clips,
									local_CURRENT_MAG_WIDTH-8,
									local_CURRENT_MAG_HEIGHT * mag_fullness,
									local_FULL_MAG_U,
									local_CURRENT_MAG_V + local_CURRENT_MAG_HEIGHT * (1.f - mag_fullness),
									local_CURRENT_MAG_WIDTH,
									local_CURRENT_MAG_HEIGHT * mag_fullness,
									128,
									128 );


				//draw other mags.
				for (i = 0; tWeapon.AmmoType.AmmoAmount - tWeapon.mNumInMag - i * tWeapon.mMagSize > 0; i++)
				{
					// indicate that you've got another mag available.
					aCanvas.SetPos ( aCanvas.SizeX - local_EXTRA_MAGS_LEFTNESS + local_EXTRA_MAG_RIGHT_STEP * i, aCanvas.SizeY - local_EXTRA_MAGS_UPNESS);
					aCanvas.DrawTileSafe ( clips,
										EXTRA_MAG_WIDTH-8,
										local_EXTRA_MAG_HEIGHT,
										local_EXTRA_MAG_U,
										local_EXTRA_MAG_V,
										local_EXTRA_MAG_WIDTH,
										local_EXTRA_MAG_HEIGHT,
										128,
										128 );
				}
				
				if ( mSASGRI != None && mSASGRI.mDifficultySetting.ShowAmmo == 1 )
				{
					if (aCanvas.ClipX < 1024)
					{
						aCanvas.Font = aCanvas.FontBig24;
						local_burst_leftness = BURST_LEFTNESS_RES1;
						local_ammo_count_leftness = AMMO_COUNT_LEFTNESS_RES1;
						local_ammo_count_upness = AMMO_COUNT_UPNESS_RES1;
					}
					else
					{
						aCanvas.Font = aCanvas.FontBig34;
						local_burst_leftness = BURST_LEFTNESS;
						local_ammo_count_leftness = AMMO_COUNT_LEFTNESS;
						local_ammo_count_upness = AMMO_COUNT_UPNESS;
					}

					// Adjust draw position left if more than 2 figure ammo count.  
					if ( tWeapon.mNumInMag > 99 )
					{
						aCanvas.StrLen( "A", fWX, fWY );
						local_ammo_count_leftness += fWX;
					}
					
					aCanvas.SetPos ( aCanvas.SizeX - local_ammo_count_leftness, aCanvas.SizeY - local_ammo_count_upness );

					if ( tWeapon.mNumInMag > 9 )
					{
						aCanvas.DrawText( tWeapon.mNumInMag);
					}
					else
					{
						aCanvas.DrawText( "0" $tWeapon.mNumInMag);
					}
				}

				aCanvas.SetPos (aCanvas.SizeX - local_burst_leftness, aCanvas.SizeY - BURST_UPNESS);

				// Only worth displaying if alternative fire modes are available
				if ((tWeapon.mAllowedFireModes & ~1) != 0)
				{
					if (tWeapon.mFireMode == 0)			// These values are defined as constants in SASWeapon.uc but aren't available here
						{
							
							aCanvas.DrawTileSafe ( mFireModeSingle,
										FIRE_MODE,
										FIRE_MODE,
										0,
										0,
										FIRE_MODE,
										FIRE_MODE,
										FIRE_MODE,
										FIRE_MODE );
								
						}
						
						
						
					else if (tWeapon.mFireMode == 1)
					{
						aCanvas.DrawTileSafe ( mFireModeBurst,
										FIRE_MODE,
										FIRE_MODE,
										0,
										0,
										FIRE_MODE,
										FIRE_MODE,
										FIRE_MODE,
										FIRE_MODE );
					}
					
					else if (tWeapon.mFireMode == 2)
						{
							aCanvas.DrawTileSafe ( mFireModeAuto,
										FIRE_MODE,
										FIRE_MODE,
										0,
										0,
										FIRE_MODE,
										FIRE_MODE,
										FIRE_MODE,
										FIRE_MODE );
						}
						
					else
						aCanvas.DrawText("("$tWeapon.mFireMode$")");
				}
			}

			if (aCanvas.ClipX < 1024)
			{
				aCanvas.Font = aCanvas.FontBig24;
			}
			else
			{
				aCanvas.Font = aCanvas.FontBig34;
			}
		}

		//polling for weapons 
		if ( tWeapon != None )
		{
			PrevWeapon=CurrentWeapon;
			CurrentWeapon=tWeapon.ItemName;
			if( CurrentWeapon != PrevWeapon)
			{
				fAnimController = 0;
				isSlideController = true;
			}
			
			//drawing weapon Lineart
			if( isDisplayLienarArt && bDrawOtherHUDitems)
			{
				if ( tWeapon.mLineartWeapon != None )
				{
					if( fSlideDrawRatio < 0.0 )
						fSlideDrawRatio = 0.0;
				
					aCanvas.SetPos ((((aCanvas.SizeX) -( tWeapon.mLineartWeapon.USize)*WScaleFactor*fSlideDrawRatio)*fAnimController) - 10, ((aCanvas.SizeY) - (CURRENT_MAG_UPNESS -10)-(tWeapon.mLineartWeapon.VSize)*WScaleFactor)*fAnimController);
					aCanvas.DrawTileSafe ( tWeapon.mLineartWeapon,
											(tWeapon.mLineartWeapon.USize)*WScaleFactor*fAnimController,
											(tWeapon.mLineartWeapon.VSize)*WScaleFactor*fAnimController,
											0,
											0,
											tWeapon.mLineartWeapon.USize,//*fSlideDrawRatio*fAnimController,
											tWeapon.mLineartWeapon.VSize,
											tWeapon.mLineartWeapon.USize,
											tWeapon.mLineartWeapon.VSize );	 

					if (aCanvas.ClipX < 1024)
					{
						aCanvas.Font = aCanvas.FontBig24;
					}
					else
					{
						aCanvas.Font = aCanvas.FontBig34;
					}
					aCanvas.StrLen ( tWeapon.ItemName , fWX, fWy );
					iLen = Len(tWeapon.ItemName);

					// normally we try to align the left of the text to the left of the art.
					// sometimes the text is longer than the art, so there's an FMax in here to make sure
					// that all text is on-screen.
					aCanvas.SetPos ((((aCanvas.SizeX) -( FMax(fWX, tWeapon.mLineartWeapon.USize * WScaleFactor)) * fSlideDrawRatio)*fAnimController) - 10 , ((aCanvas.SizeY) - (CURRENT_MAG_UPNESS -10)-(tWeapon.mLineartWeapon.VSize)*WScaleFactor)*fAnimController -  fWy - 10);
					
					aCanvas.DrawTextClipped(tWeapon.ItemName );
				}
			}
			
			//ind=mLineart[Ind].BitmapMaterial.RenderedMaterial.USize;
			//DirOfAttackBack =	Normal( DirOfAttack >> Rotation );
			//DirOfAttackBack =	Normal( DirOfAttack >> Rotation/2 );

			
			//aCanvas.SetPos ((aCanvas.SizeX)/2 + ( DirOfAttackBack.X * mOrangeSpike.VSize), (aCanvas.SizeY)/2 - (DirOfAttackBack.Y * mOrangeSpike.VSize) );
			//aCanvas.DrawTile( mMapMask, mOrangeSpike.VSize, mOrangeSpike.VSize, (32) * 0.5, (32) * 0.5, MAP_OVERLAY_SIZE, MAP_OVERLAY_SIZE );
			 
			// aCanvas.Style = ERenderStyle.STY_AlphaZ;
			//aCanvas.SetPos( (aCanvas.SizeX)/2 - ( DirOfAttackBack.X * mOrangeSpike.VSize),(aCanvas.SizeY)/2 - (DirOfAttackBack.Y * mOrangeSpike.VSize) );
				//aCanvas.SetDrawColor( 255, 255, 255);
				
				//aCanvas.DrawTile(
				//	mOrangeSpike,
				//	mOrangeSpike.USize,
				//	mOrangeSpike.USize,
				//	0,
				//	0,
				//	mOrangeSpike.VSize,
				//	mOrangeSpike.USize );
			
			//DrawRotoTile( aCanvas, mOrangeSpike, mOrangeSpike.VSize, mOrangeSpike.VSize, 0, 0,0.4, 0.4, (32768 + 16384 - tPawn.Rotation.Yaw & 65535) );
		}
	}
	if (IsDeveloper())
	{
		// Tony's debug stuff
		if ( tPawn.GetGRI () != None )
		{
			aCanvas.SetPos ( 0, aCanvas.SizeY-20);
			aCanvas.DrawText(tPawn.GetGRI ().mTerroristsKilled$ "/" $tPawn.GetGRI ().mTerroristsIncapacitated$"/"$tPawn.GetGRI ().mTerroristsCaptured);
		}

		// Memory usage of AI logging system
		if (getMemUsage () > 0)
		{
			aCanvas.SetDrawColor (100, 255, 150);
			aCanvas.SetPos (0, aCanvas.SizeY - 10);
			aCanvas.DrawText (getMemUsage ()$ " bytes");
		} // if
	}
}

//------------------------------------------------------------------------------
//
//
simulated function DrawSquadStats(
	Canvas aCanvas )
{
	local int			i;
	local int			posX;
	local SASPawn		p;

	posX = aCanvas.SizeX * 0.5;

	if (aCanvas.ClipX < 1024)
		posX += SQUAD_HEAD_RIGHTNESS_RES1;
	else
		posX += SQUAD_HEAD_RIGHTNESS;

	for ( i = 0; i < mSquadManager.mNumAISquadMembers; i++ )
	{
		p = mSquadManager.GetAISquadMemberByIdx( i );
		aCanvas.SetPos ( posX - 75, 10 );
		DrawPawnStats( aCanvas, p, posX, false, false );

		// Increment ready for next pawn
		if (aCanvas.ClipX < 1024)
			posx += SQUAD_HEAD_RIGHTNESS_STEP_RES1;
		else
			posx += SQUAD_HEAD_RIGHTNESS_STEP;
	}
}

//------------------------------------------------------------------------------
//
//
simulated function DrawRadarMap ( canvas aCanvas, SASPlayerController	aPC )
{
	local SASPawn		tPawn;
	local Vector		tMapPos;
	local Texture radar_map_texture;

	radar_map_texture =Level.GetMapToDisplayForAltitude();

	if (radar_map_texture == None)
	{
		// this level doesn't have a radar map, forget it.
		return;
	}
	

	mMapTopLeft			= Level.UtCoordsTL;//(X=-1320,Y=-8690,Z=0)
	mMapBotRight		= Level.UtCoordsBR;//(X=3295,Y=305,Z=0)
	
	
	
	// pjs: disable map on ps2 for now
	if(IsPS2())
		return;
	aCanvas.SetPos ( MAP_X, aCanvas.SizeY - MAP_UPNESS );

	SetOrangeColour(aCanvas);

	mtester1 = radar_map_texture;
	
	if ( aPC == None )
	{
		return;
	}
	tPawn = SASPawn ( aPC.Pawn );
	if ( tPawn == None )
	{
		return;
	}
	if( Level.NumberOfRadarMaps != 0)
	{
		 //x = Level.Floors(0).b.X;
	}
	
	
	//drawing the frame circle	
	aCanvas.SetPos ( MAP_X, aCanvas.SizeY - MAP_UPNESS - MAP_OVERLAY_SIZE );
	aCanvas.DrawTile( mMapCircler, MAP_OVERLAY_SIZE, MAP_OVERLAY_SIZE, (258 - MAP_OVERLAY_SIZE) * 0.5, (258 - MAP_OVERLAY_SIZE) * 0.5, MAP_OVERLAY_SIZE, MAP_OVERLAY_SIZE );	

	// Make a mask
	aCanvas.Style = ERenderStyle.STY_Invisible;
	aCanvas.Z = 0;
	aCanvas.SetPos ( MAP_X, aCanvas.SizeY - MAP_UPNESS - MAP_OVERLAY_SIZE );
	aCanvas.DrawTile( mMapMask, MAP_OVERLAY_SIZE, MAP_OVERLAY_SIZE, (256 - MAP_OVERLAY_SIZE) * 0.5, (256 - MAP_OVERLAY_SIZE) * 0.5, MAP_OVERLAY_SIZE, MAP_OVERLAY_SIZE );


	// Calculate parametric position in map of player
	tMapPos = tPawn.Location - mMapTopLeft;
	
	
	tMapPos.x=tMapPos.x/(mMapBotRight.x - mMapTopLeft.x);
	tMapPos.y=tMapPos.y/(mMapBotRight.y - mMapTopLeft.y);
	
	

	
	// Work out rotation of player.

	// Draw map that covers 10% of area around player
	aCanvas.Style = ERenderStyle.STY_AlphaZ;
	aCanvas.SetPos ( MAP_X + 2, aCanvas.SizeY - MAP_UPNESS - MAP_OVERLAY_SIZE + 2 );
	aCanvas.Z = 0.0001;
	//mMapTex
	DrawRotoTile( aCanvas, radar_map_texture, MAP_OVERLAY_SIZE - 4, MAP_OVERLAY_SIZE - 4, (tMapPos.x), (tMapPos.y), 0.4, 0.4, (32768 + 16384 - tPawn.Rotation.Yaw & 65535) );
;
//..........................function which calls rotation tile ............................
//DrawTileRotVert( canvas aCanvas, material Mat, float XL, float YL, float U, float V, float UL, float VL, int yaw, int TranslateX, int  TranslateY, int Flags);
		
}


simulated function DrawDamageIndicator(
	Canvas	aCanvas )
{
	local Vector	spherexpos; 
	local float		angleDamage;
	local float		angleControl;
	local float		angleToUt;
	local vector	TopLeft;
	local float		displayTillTime;

	displayTillTime = 1.0f - ( ( Owner.Level.TimeSeconds - mLastDamageTimeAllDirections ) / DAMAGEFADETIME );		
	displayTillTime = Level.TimeSeconds - mLastDamageTimeAllDirections;
	if( displayTillTime > 01.0 )
	{
		bDisplayDamage = false;
	}
			
			
	if( bDisplayDamage )
	{
		angleControl = 1.0;

		aCanvas.Style = ERenderStyle.STY_Alpha;
		aCanvas.SetDrawColor ( 255, 255, 255, 90 * (01.0 - displayTillTime) );
		if( DirTakeDamage.Y == 0 &&  DirTakeDamage.X > 0.0)
		{
			angleDamage = 1.5707;
			angleToUt = 65535 - 65535 * angleDamage/( (3.14159)*2 );
		}
		else if( DirTakeDamage.Y == 0 &&  DirTakeDamage.X < 0.0 )
		{
			angleDamage = 3.14159 + 1.5707;
			angleToUt = 65535 - 65535 * angleDamage/( (3.14159)*2 );		
		}
		else
		{	
			//angleDamage = DirTakeDamage.X/DirTakeDamage.Y;
			angleDamage =	Atan(DirOfAttack.X, DirOfAttack.Y);
			angleToUt = 65535 - 65535 * angleDamage/( (3.14159)*2 );
			if( (DirOfAttack.X > 0)&&( DirOfAttack.Y > 0) )
			{
				angleDamage = angleDamage;
				spherexpos.Y = (aCanvas.SizeY)/2  - (Sin ( angleDamage ) * mDamageSphere.USize/2) - 70;
				angleToUt = 65535 - 65535 *0.9* angleDamage/( (3.14159)*2 );
			}
			else if( (DirOfAttack.X > 0)&&( DirOfAttack.Y < 0) )
			{
				angleDamage = 3.14159 - Abs( angleDamage );
				angleControl = -1.0;
				angleToUt =  32767 + 65535 * angleDamage/( (3.14159)*2 );//65535 +
			}
			else if( (DirOfAttack.X < 0)&&( DirOfAttack.Y < 0) )
			{
				angleDamage = 3.14159 + Abs( angleDamage );
				angleControl = -1.0;
				angleToUt = 32767 + 65535 * angleDamage/( (3.14159)*2 );//65535 +
				
			}
			else if( (DirOfAttack.X < 0)&&( DirOfAttack.Y > 0) )
			{
				angleDamage = (3.14159)*2 - Abs( angleDamage );
				spherexpos.X = ((aCanvas.SizeX)/2 + ( Cos( angleDamage )* mDamageSphere.USize/ 2* angleControl) - 70);
				spherexpos.Y = (aCanvas.SizeY)/2  - (Sin ( angleDamage ) * mDamageSphere.USize/2) - 70;
				angleToUt = 65535 - 65535 * angleDamage/( (3.14159)*2 );
				
			}
		}							
			
		//spherexpos.X = (aCanvas.SizeX)/2 - mDamageSphere.USize + ( Cos( angleDamage )* mDamageSphere.USize* angleControl);
		//spherexpos.Y = (aCanvas.SizeY)/2 - mDamageSphere.USize  - (Sin ( angleDamage ) * mDamageSphere.USize);
		
		spherexpos.X = (aCanvas.SizeX)/2  + ( Cos( angleDamage )* mDamageSphere.USize*2 * angleControl);
		spherexpos.Y = (aCanvas.SizeY)/2  - (Sin ( angleDamage ) * mDamageSphere.USize*2);
		
		aCanvas.Style = ERenderStyle.STY_Alpha;
		aCanvas.SetPos( spherexpos.X,spherexpos.Y);
		aCanvas.Z = 0.0001;
		//DrawRotoTile( aCanvas, mOrangeSpike, mOrangeSpike.USize*2, mOrangeSpike.USize*2, 0.50, 0.50, 03.5, 03.5, (angleToUt) );	//(32768 + 16384 - tPawn.Rotation.Yaw & 65535)
		
		DrawTileRotVert( aCanvas,
					mOrangeSpike,
					128*2,
					32*2,
					0,
					0,
					1,
					1,
					(32768 + 16384 +16384 - angleToUt& 65535),//tPawn.Rotation.Yaw(angleToUt + 65535/2 ),//,//16384,
					spherexpos.X,
					spherexpos.Y,
					0);
		
		TopLeft = spherexpos;
			//TopRight,
			//BottomLeft,
			//BottomRight;
		
		/*xPosMyTile = spherexpos.X;
		yPosMyTile = spherexpos.Y;

		aCanvas.SetPos( xPosMyTile,yPosMyTile);
		DrawMyTile(aCanvas,
					mOrangeSpike,
					xPosMyTile + 128,
					yPosMyTile ,
					xPosMyTile,
					yPosMyTile +  32,
					xPosMyTile + 128,
					yPosMyTile + 32,
					0,
					0,
					1,
					0,
					0,
					1,
					1,
					1);*/
		
		
		//spherexpos.X = (aCanvas.SizeX)/2 - mDamageSphere.USize;// - DAMAGE_SPHERE;
		//spherexpos.Y = (aCanvas.SizeY)/2 - mDamageSphere.USize;// - DAMAGE_SPHERE;
		aCanvas.SetPos( spherexpos.X,spherexpos.Y);
		
		aCanvas.SetPos( ((aCanvas.SizeX/2)-mDamageSphere.USize*2), ((aCanvas.SizeY/2)-mDamageSphere.VSize*2) );
		DrawRotoTile( aCanvas, mDamageSphere, mDamageSphere.USize*4, mDamageSphere.VSize*4, 0.5, 0.5, 0.5, 0.5, (angleToUt) );
	}
}

//------------------------------------------------------------------------------
//
//
simulated function DrawActorDebug (
	Canvas				aCanvas )
{
	local SASPlayerController	tPC;
	local int					i;
	local vector				screenPos;
	local vector				screenPos2;
	local SASSoldier			soldier;
	local SASSoldierController	SC;

	tPC = SASPlayerController ( Level.GetLocalPlayerController () );
	if ( tPC == None || tPC.Pawn == None )
	{
		return;
	}

	screenPos.X = 20;
	screenPos.Y = 100;

	if ( mSquadManager != None )
	{
		for ( i = 0; i < mSquadManager.mNumAISquadMembers; i++ )
		{
			soldier = mSquadManager.mAISquadMembers[i];
			if ( soldier != None )
			{
				SC = SASSoldierController( soldier.Controller );
				if ( SC != None )
				{
					// draw name on soldier
					screenPos2 = tPC.Player.Console.WorldToScreen( soldier.Location );
					aCanvas.SetPos( screenPos2.x-40, screenPos2.y );

					if (	(mSquadManager.mWingmanIndex >= 0) &&
							(soldier == mSquadManager.mAISquadMembers[mSquadManager.mWingmanIndex]) )
					{
						aCanvas.SetDrawColor(255,0,0);
						aCanvas.DrawText( "Wingman" );
					}
					else
					{
						aCanvas.SetDrawColor(255,255,255);
						aCanvas.DrawText( soldier.Name );
					}

					// now do rest of debug
					aCanvas.SetPos( screenPos.X,screenPos.Y );
					if (	(mSquadManager.mWingmanIndex >= 0) &&
							(soldier == mSquadManager.mAISquadMembers[mSquadManager.mWingmanIndex]) )
					{
						aCanvas.DrawText( "Wingman: "$SC.Name );
					}
					else
					{
						aCanvas.DrawText( "Soldier: "$SC.Name );
					}

					screenPos.Y += 10;

					aCanvas.SetPos( screenPos.X,screenPos.Y );
					aCanvas.DrawText( "state: "$SC.GetStateName() );
					screenPos.Y += 10;

					aCanvas.SetPos(screenPos.X,screenPos.Y);
					aCanvas.DrawText( "objective:  "$SC.ObjectiveTypeToString(SC.mCurrentObjective.ObjectiveType) );
					screenPos.Y += 10;

					aCanvas.SetPos( screenPos.X,screenPos.Y );
					aCanvas.DrawText( "dst->plyr:  "$VSize( soldier.Location - tPC.Pawn.Location ) );
					screenPos.Y += 10;

					aCanvas.SetPos( screenPos.X,screenPos.Y );
					aCanvas.DrawText( "objctv:  "$SC.mCurrentObjective.TargetPoint.Name );
					screenPos.Y += 10;

					aCanvas.SetPos( screenPos.X,screenPos.Y );
					aCanvas.DrawText( "dst->objctv:  "$VSize( soldier.Location - SC.mCurrentObjective.TargetPoint.Location) );
					screenPos.Y += 10;

					aCanvas.SetPos( screenPos.X,screenPos.Y );
					aCanvas.DrawText( "MoveTarget:  "$SC.MoveTarget );
					screenPos.Y += 10;
				}
			}
			screenPos.Y += 10;
		}
	}
}

//------------------------------------------------------------------------------
//
//
simulated function DrawActorOverlays ( Canvas aCanvas )
{
	local SASPawn			tPawn;
	local vector			screenPos;
	local PlayerController	tPC;
//	local vector			dirn;
	local LogActor			tLogActor;
	local int				i;

	tPC = Level.GetLocalPlayerController();
	if ( tPC == None || tPC.Pawn == None )
	{
		return;
	}

	aCanvas.Font = aCanvas.FontSmall10;

	ForEach VisibleActors ( class'LogActor', tLogActor, 100000, tPC.Pawn.Location )
	{
		if (tLogActor != None)
		{
			screenPos = tPC.Player.Console.WorldToScreen ( tLogActor.Location );

			// Only draw if the actor in question is _in front_ of the camera!
			// JS - see UInteraction::execWorldToScreen for the reason for this >= 1.f test
			if (screenPos.Z >= 1.f)
			{
				aCanvas.SetDrawColor(128,255,128);

				for (i = 0; i < tLogActor.LogHistory.Length; i++)
				{
					aCanvas.SetPos(screenPos.x-40,screenPos.y-20 - tLogActor.LogHistory.Length * 10 + i * 10);
					aCanvas.DrawText(tLogActor.LogHistory[i]);
				}
			}
		}
	}

	ForEach RadiusActors ( class'SASPawn', tPawn, 100000, tPC.Pawn.Location )
	{
		if ( ( tPawn != None ) && tPawn.isDead () == false)
		{
			screenPos = tPC.Player.Console.WorldToScreen ( tPawn.Location );

			// Only draw if the actor in question is _in front_ of the camera!
			// JS - see UInteraction::execWorldToScreen for the reason for this >= 1.f test
			if (screenPos.Z >= 1.f)
			{
				// Pawns with controller objects
				if ( ( tPawn.Controller != None ) &&
					!tPawn.Controller.IsInState ('Dead') &&
					( tPawn.Controller.GetStateName () != '' ) )
				{
					aCanvas.SetDrawColor(255,255,255);

					aCanvas.SetPos(screenPos.x-40,screenPos.y-20);
					aCanvas.DrawText("Vel "$tPawn.Velocity);

					// turning stuff.
					aCanvas.SetPos(screenPos.x-40,screenPos.y-10);
					aCanvas.DrawText("Rotation "$tPawn.Rotation$" Desired "$tPawn.DesiredRotation$" spinetwist: "$tPawn.mSpineTwistTarget);

					aCanvas.SetPos(screenPos.x-40,screenPos.y);
					aCanvas.DrawText("ID:("$tPawn$")");
					//aCanvas.SetPos(screenPos.x-40,screenPos.y+10);
					//aCanvas.DrawText("state:("$tPawn.GetStateName()$")");
					aCanvas.SetPos(screenPos.x-40,screenPos.y+10);
					aCanvas.DrawText("Controller state:("$tPawn.Controller.GetStateName()$")");
					//aCanvas.SetPos(screenPos.x-40,screenPos.y+20);
					//aCanvas.DrawText("Healths:(H"$tPawn.mLimbHealths[0]$" B"$tPawn.mLimbHealths[1]$")");
					//aCanvas.SetPos(screenPos.x-40,screenPos.y+30);
					//aCanvas.DrawText("Healths:(LA"$tPawn.mLimbHealths[2]$" RA"$tPawn.mLimbHealths[3]$")");
					//aCanvas.SetPos(screenPos.x-40,screenPos.y+40);
					//aCanvas.DrawText("Healths:(LL"$tPawn.mLimbHealths[4]$" RL"$tPawn.mLimbHealths[5]$")");
					//aCanvas.SetPos(screenPos.x-40,screenPos.y+50);
					//aCanvas.DrawText("LastBone:("$tPawn.mLastBoneHit$")");
					aCanvas.SetPos(screenPos.x-40,screenPos.y+20);
					aCanvas.DrawText("Enemy: "$tPawn.Controller.Enemy);
					aCanvas.SetPos(screenPos.x-40,screenPos.y+30);
					aCanvas.DrawText("Target: "$tPawn.Controller.Target);
					aCanvas.SetPos(screenPos.x-40,screenPos.y+40);
					aCanvas.DrawText("Focus:("$tPawn.Controller.Focus$")");
					aCanvas.SetPos(screenPos.x-40,screenPos.y+50);
					if (SASSoldierController (tPawn.Controller) != None)
					{
						aCanvas.DrawText("IgnoreEnemies: "$SASSoldierController (tPawn.Controller).mbIgnoreEnemy);
					} // if
					else
					{
						aCanvas.DrawText("--");
					} // else
					//aCanvas.SetPos(screenPos.x-40,screenPos.y+40);
					//aCanvas.DrawText("Enemy:("$tPawn.Controller.Enemy$")");
					aCanvas.SetPos(screenPos.x-40,screenPos.y+60);
					aCanvas.DrawText("Anim "$tPawn.GetCurrentAnim ());
					aCanvas.SetPos(screenPos.x-40,screenPos.y+70);
					aCanvas.DrawText("Action: "$tPawn.GetCurrentAnim (ANIMCHANNEL_ACTION));
					aCanvas.SetPos(screenPos.x-40,screenPos.y+80);
					aCanvas.DrawText ("Stance: " $mStanceNames[ tPawn.meStance ] );
					if (SASSoldierController (tPawn.Controller) != None)
					{
						aCanvas.SetPos(screenPos.x-40,screenPos.y+90);
						aCanvas.DrawText ("Objective: " $SASSoldierController (tPawn.Controller).ObjectiveTypeToString (SASSoldierController (tPawn.Controller).mCurrentObjective.ObjectiveType));
						aCanvas.SetPos(screenPos.x-40,screenPos.y+100);
						aCanvas.DrawText ("DP: " $SASSoldierController (tPawn.Controller).mDominationPoint);
					} // if
					//aCanvas.SetPos(screenPos.x-40,screenPos.y+90);
					//aCanvas.DrawText("Follower: "$tPawn.getFollower ());
					//aCanvas.SetPos(screenPos.x-40,screenPos.y+100);
					//aCanvas.DrawText("Walking: "$tPawn.bIsWalking);
					//aCanvas.SetPos(screenPos.x-40,screenPos.y+70);
					//aCanvas.DrawText("PrePivot ("$tPawn.PrePivot.Z$")");
					//aCanvas.SetPos(screenPos.x-40,screenPos.y+80);
					//aCanvas.DrawText("IntAngle ("$tPawn.mInterestAngle$")");
					//aCanvas.SetPos(screenPos.x-40,screenPos.y+90);
					//aCanvas.DrawText("Neck ("$tPawn.mNeckTwistCurrent$")");
					//aCanvas.SetPos(screenPos.x-40,screenPos.y+100);
					//aCanvas.DrawText("Spine ("$tPawn.mSpineTwistCurrent$")");
					//aCanvas.SetPos(screenPos.x-40,screenPos.y+90);
					//aCanvas.DrawText( "Mesg: (" $tPawn.mDebugMessageHUD $")" );

					//dirn = tPawn.Controller.FocalPoint - tPawn.Location;
					//aCanvas.SetPos(screenPos.x-40,screenPos.y+80);
					//aCanvas.DrawText("Rotn:Actual("$tPawn.Rotation.Yaw$") Target ("$GetYaw (dirn)$")");
					//Log ("##"$tPawn.Rotation.Yaw$","$GetYaw (dirn)$","$Level.TimeSeconds);
					//aCanvas.SetPos(screenPos.x-40,screenPos.y+90);
					//aCanvas.DrawText("Interest ("$tPawn.mInterestItem$")");
				} // if
				else if ( tPawn.Controller == None )
				{
					screenPos = tPC.Player.Console.WorldToScreen ( tPawn.Location );
					aCanvas.SetDrawColor(255,255,255);
					aCanvas.SetPos(screenPos.x-40,screenPos.y);
					aCanvas.DrawText ( "ID:      (" $tPawn $")" );
					aCanvas.SetPos(screenPos.x-40,screenPos.y+10);
					aCanvas.DrawText ( "-- No controller --" );
					aCanvas.SetPos(screenPos.x-40,screenPos.y+20);
	//				aCanvas.DrawText ( "Anim:    (" $tPawn.GetCurrentAnim () $")" );
					aCanvas.DrawText ( "Action:  (" $tPawn.GetCurrentAnim ( ANIMCHANNEL_ACTION ) $")" );
					aCanvas.SetPos(screenPos.x-40,screenPos.y+30);
					aCanvas.DrawText ( "PState:  (" $tPawn.GetStateName() $")" );
					aCanvas.SetPos(screenPos.x-40,screenPos.y+40);
					aCanvas.DrawText ( "Stance:  (" $mStanceNames[ tPawn.meStance ] $")" );
					aCanvas.SetPos(screenPos.x-40,screenPos.y+50);
					aCanvas.DrawText ( "Mesg:    (" $tPawn.mDebugMessageHUD $")" );
					aCanvas.SetPos(screenPos.x-40,screenPos.y+60);
					aCanvas.DrawText( "Anim      (" $tPawn.GetCurrentAnim () $")" );
				} // else if
			} // if
		} // if
	} // ForEach
}


function DrawAnimDebug(
	Canvas	aCanvas )
{
	local int				lowestBlendChannel;
	local name				anim,
							upperBody,
							startBone;
	local float				blendAlpha;
	local SASPawn			visiblePawn;
	local PlayerController	PC;
	local vector			screenPos;

	PC = Level.GetLocalPlayerController();
	if ( PC == None || PC.Pawn == None )
	{
		return;
	}

	aCanvas.Font = aCanvas.FontSmall10;

	foreach VisibleActors( class'SASPawn', visiblePawn, 100000, PC.Pawn.Location )
	{
		screenPos = PC.Player.Console.WorldToScreen ( visiblePawn.Location );

		// Only draw if the actor in question is _in front_ of the camera!
		// JS - see UInteraction::execWorldToScreen for the reason for this >= 1.f test
		if (screenPos.Z >= 1.f)
		{
			lowestBlendChannel = visiblePawn.GetLowestBlendChannel();

			screenPos.X -= 80;

			aCanvas.SetPos( screenPos.X, screenPos.Y );
			aCanvas.SetDrawColor( 255, 255, 255 );
			aCanvas.DrawText( "Lowest blend channel:"$lowestBlendChannel );
			screenPos.Y += 10;

			// Base channel
			visiblePawn.GetAnimParamsAdvanced( 0, anim, startBone, blendAlpha );
			upperBody = visiblePawn.GetUpperBodyAnim( 0 );
			aCanvas.SetPos( screenPos.X, screenPos.Y );
			if ( lowestBlendChannel > 0 )
			{
				aCanvas.SetDrawColor( 255, 255, 255 );
			}
			else
			{
				aCanvas.SetDrawColor( 0, 255, 0 );
			}

			if ( upperBody != 'None' )
			{
				aCanvas.DrawText( "Base: [UPR] "$upperBody$", [LWR] "$anim );
			}
			else
			{
				aCanvas.DrawText( "Base: [ALL] "$anim );
			}

			// First movement channel
			visiblePawn.GetAnimParamsAdvanced( 4, anim, startBone, blendAlpha );
			upperBody = visiblePawn.GetUpperBodyAnim( 4 );
			screenPos.Y += 10;
			aCanvas.SetPos( screenPos.X,screenPos.Y );
			if ( (lowestBlendChannel > 4) || (blendAlpha == 0.0) )
			{
				aCanvas.SetDrawColor( 255, 255, 255 );
			}
			else
			{
				aCanvas.SetDrawColor( 0, 255, 0 );
			}
			if ( blendAlpha == 0.0 )
			{
				aCanvas.DrawText( "Fwd: [None]" );
			}
			else if ( startBone != 'None' )
			{
				aCanvas.DrawText( "Fwd: [UPR] "$anim );
			}
			else if ( upperBody != 'None' )
			{
				aCanvas.DrawText( "Fwd: [UPR] "$upperBody$", [LWR] "$anim );
			}
			else
			{
				aCanvas.DrawText( "Fwd: [ALL] "$anim );
			}

			// Firing channel
			visiblePawn.GetAnimParamsAdvanced( ANIMCHANNEL_FIRING, anim, startBone, blendAlpha );
			upperBody = visiblePawn.GetUpperBodyAnim( ANIMCHANNEL_FIRING );
			screenPos.Y += 10;
			aCanvas.SetPos( screenPos.X,screenPos.Y );
			if ( (lowestBlendChannel > ANIMCHANNEL_FIRING) || (blendAlpha == 0.0) )
			{
				aCanvas.SetDrawColor( 255, 255, 255 );
			}
			else
			{
				aCanvas.SetDrawColor( 0, 255, 0 );
			}
			if ( blendAlpha == 0.0 )
			{
				aCanvas.DrawText( "Fire: [None]" );
			}
			else if ( startBone != 'None' )
			{
				aCanvas.DrawText( "Fire: [UPR] "$anim );
			}
			else if ( upperBody != 'None' )
			{
				aCanvas.DrawText( "Fire: [UPR] "$upperBody$", [LWR] "$anim );
			}
			else
			{
				aCanvas.DrawText( "Fire: [ALL] "$anim );
			}

			// Aiming channel
			visiblePawn.GetAnimParamsAdvanced( ANIMCHANNEL_AIMING, anim, startBone, blendAlpha );
			upperBody = visiblePawn.GetUpperBodyAnim( ANIMCHANNEL_AIMING );
			screenPos.Y += 10;
			aCanvas.SetPos( screenPos.X,screenPos.Y );
			if ( (lowestBlendChannel > ANIMCHANNEL_AIMING) || (blendAlpha == 0.0) )
			{
				aCanvas.SetDrawColor( 255, 255, 255 );
			}
			else
			{
				aCanvas.SetDrawColor( 0, 255, 0 );
			}
			if ( blendAlpha == 0.0 )
			{
				aCanvas.DrawText( "Aim: [None]" );
			}
			else if ( startBone != 'None' )
			{
				aCanvas.DrawText( "Aim: [UPR] "$anim );
			}
			else if ( upperBody != 'None' )
			{
				aCanvas.DrawText( "Aim: [UPR] "$upperBody$", [LWR] "$anim );
			}
			else
			{
				aCanvas.DrawText( "Aim: [ALL] "$anim );
			}

			// Action channel
			visiblePawn.GetAnimParamsAdvanced( ANIMCHANNEL_ACTION, anim, startBone, blendAlpha );
			upperBody = visiblePawn.GetUpperBodyAnim( ANIMCHANNEL_ACTION );
			screenPos.Y += 10;
			aCanvas.SetPos( screenPos.X,screenPos.Y );
			if ( (lowestBlendChannel > ANIMCHANNEL_ACTION) || (blendAlpha == 0.0) )
			{
				aCanvas.SetDrawColor( 255, 255, 255 );
			}
			else
			{
				aCanvas.SetDrawColor( 0, 255, 0 );
			}
			if ( blendAlpha == 0.0 )
			{
				aCanvas.DrawText( "Action: [None]" );
			}
			else if ( startBone != 'None' )
			{
				aCanvas.DrawText( "Action: [UPR] "$anim );
			}
			else if ( upperBody != 'None' )
			{
				aCanvas.DrawText( "Action: [UPR] "$upperBody$", [LWR] "$anim );
			}
			else
			{
				aCanvas.DrawText( "Action: [ALL] "$anim );
			}

			// Spine twist.
			screenPos.Y += 10;
			aCanvas.SetPos( screenPos.X,screenPos.Y );
			aCanvas.DrawText( "Spine twist target: "$visiblePawn.mSpineTwistTarget );
			screenPos.Y += 10;
			aCanvas.SetPos( screenPos.X,screenPos.Y );
			aCanvas.DrawText( "Spine twist current: "$visiblePawn.mSpineTwistCurrent );
		}
	}
}


//------------------------------------------------------------------------------
// DrawReticleRect
//
//simulated function DrawReticleRect ( Canvas aCanvas, float X1, float Y1, float X2, float Y2, Color aColour )
simulated function DrawReticleRect ( Canvas aCanvas, int X1, int Y1, int width, int height, Color aColour )
{
	// Let's draw a border round the crosshair
//	aCanvas.DrawColor = mReticuleColourBorder;
	aCanvas.DrawColor = aColour * 0.4;
	aCanvas.SetPos ( X1 - mReticleBorder, Y1 - mReticleBorder );
	aCanvas.DrawRect ( mDefTexture, width + mReticleBorder * 2, height + mReticleBorder * 2 );

	// now the reticle in the appropriate colour
	aCanvas.DrawColor = aColour;
	aCanvas.SetPos ( X1, Y1 );
	aCanvas.DrawRect ( mDefTexture, width, height );
}

//------------------------------------------------------------------------------
// GetReticleColour
//
// return appropriate colour for the target
simulated function Color GetReticleColour ( SASPlayerController	aPC )
{
	local Actor		reticuleTarget;
	local SASPawn	reticulePawn;

	reticuleTarget = aPC.mReticuleTarget;

	if ( aPC.mSASPawn != None && (reticuleTarget != None) )
	{
		reticulePawn = SASPawn( reticuleTarget );
		if ( reticulePawn != None )
		{
			if ( reticulePawn.mSide == SIDE_None )
			{
				return mReticuleColourNoTarget;
			}
			if ( reticulePawn.mSide == SIDE_Hostage )
			{
				return mReticuleColourHostage;
			}

			if ( reticulePawn.mSide == aPC.mSASPawn.mSide )
			{
				return mReticuleColourAlly;
			}
			else
			{
				return mReticuleColourEnemy;
			}
		}
		else
		{
			if ( SASBoobyTrapDevice ( reticuleTarget ) != None )
			{
				return mReticuleColourBoobyTrap;
			}
			else if ( SASDoorMover ( reticuleTarget ) != None )
			{
				return mReticuleColourDoorMover;
			}
		}
	}
	// Default reticule colour.
	return mReticuleColourNoTarget;
}

//------------------------------------------------------------------------------
// DrawShotSpreadIndicator
//
simulated function DrawShotSpreadIndicator (
	Canvas	aCanvas,
	float	aCenterX,
	float	aCenterY,
	float	aSpreadGapX,
	float	aSpreadGapY,
	Color	aColour )
{
	local float	aMarkWidth;
	local float	aMarkHeight;

	aMarkWidth	= mReticleWidth;
	aMarkHeight	= mReticleHeight;

	// top
	DrawReticleRect ( aCanvas, aCenterX, aCenterY - aSpreadGapY - aMarkHeight,    aMarkWidth,  aMarkHeight, aColour );

	// right
	DrawReticleRect ( aCanvas, aCenterX + aSpreadGapX + 1, aCenterY,  aMarkHeight, aMarkWidth,  aColour );

	// bottom
	DrawReticleRect ( aCanvas, aCenterX, aCenterY + aSpreadGapY + 1, aMarkWidth,  aMarkHeight, aColour );

	// left
	DrawReticleRect ( aCanvas, aCenterX - aSpreadGapX - aMarkHeight,  aCenterY,  aMarkHeight, aMarkWidth,  aColour );
}


// DEBUG!! -AC
// Testing out the potential target indicator system.

//------------------------------------------------------------------------------
// DrawAutoLockCircleIndicator
//
simulated function DrawAutoLockCircleIndicator (
	Canvas	aCanvas,
	float	aCenterX,
	float	aCenterY,
	float	aWidth,
	float	aHeight,
	Texture	aTexture )
{
	aCanvas.SetPos ( aCenterX - (aWidth/2.0) + 1, aCenterY  - (aHeight/2.0) + 1 );
	aCanvas.Style = ERenderStyle.STY_Alpha;
	aCanvas.DrawTileClipped (
		aTexture,
		aWidth, aHeight,
		0, 0,
		aTexture.VSize, aTexture.USize
		);
	aCanvas.Style = ERenderStyle.STY_Normal;
}

//------------------------------------------------------------------------------
// DrawAutoLockCircle
//
simulated function DrawAutoLockCircle (
	Canvas					aCanvas,
	SASPlayerController		aPC )
{
	local SASWeapon	tMyWeapon;
	local Color		tColour;
	local float		posX,
					posY;

	local float		halfFovInRadians;
	local float		halfAutoLockSpreadInRadians;
	local float		projectonPixelDist;
	local float		spreadPixels;
	local float		tAutoTargetSpreadY;		// 0..1 (adjusted by fov)
	local float		tAutoTargetSpreadX;

	if (	aPC == None ||
			aPC.Pawn == None ||
			aPC.Pawn.Weapon == None ||
			!aPC.Pawn.IsFirstPerson () )
	{
		return;
	}

	// Make sure to only draw the auto lock circle when we are
	// holding guns.
	tMyWeapon = SASWeapon( aPC.Pawn.Weapon );
	if ( tMyWeapon == None || tMyWeapon.mCategory == WPNCAT_Knife )
	{
		return;
	}

	// Get the position of the center of the viewport.
	// and then move one to the left because that's how the gun
	// sights were placed in 3d.
	posX = aCanvas.SizeX * 0.5;
	posX -= 1;
	posY = aCanvas.SizeY * 0.5;

	// Determine the on screen size of auto lock circle.
	halfFovInRadians = ( aPC.FovAngleDegs * Pi / 360 );
	halfAutoLockSpreadInRadians = ( tMyWeapon.mShotAutoTargettingSpread / MAX_ANGLE ) * PI;
	projectonPixelDist = aCanvas.SizeX / Tan( halfFovInRadians );
	spreadPixels = projectonPixelDist * Tan( halfAutoLockSpreadInRadians );
	tAutoTargetSpreadY = spreadPixels;
	tAutoTargetSpreadX = spreadPixels;

	// Start the drawing of the circle.
	aCanvas.Style = ERenderStyle.STY_Alpha;

	// Set the drawing colour to use.
	tColour.R=255;
	tColour.G=128;
	tColour.B=0;
	tColour.A=128;
	aCanvas.DrawColor = tColour;
	if( aPC.TestAutoAim( tMyWeapon ) )
	{
		// Draw the indicator.
		DrawAutoLockCircleIndicator ( aCanvas,
			posX,
			posY,
			tAutoTargetSpreadX,
			tAutoTargetSpreadY,
			mAutoTargetZoneTexture );
	}
	else
	{
		// Draw the indicator.
		DrawAutoLockCircleIndicator ( aCanvas,
			posX,
			posY,
			tAutoTargetSpreadX,
			tAutoTargetSpreadY,
			mAutoTargetZoneLockTexture );
	}
	aCanvas.SetDrawColor( 255, 255, 255, 255 );

	// Return to normal drawing as we are done drawing the circle.
	aCanvas.Style = ERenderStyle.STY_Normal;
}
// END DEBUG!!

//------------------------------------------------------------------------------
// DrawReticle
//
simulated function DrawReticle (
	Canvas					aCanvas,
	SASPlayerController		aPC )
{
	local SASWeapon	tMyWeapon;
	local Color		tColour;
	local float		reticuleCenterX;
	local float		reticuleCenterY;
	local float		halfFovInRadians;
	local float		projectonPixelDist;
	local float		spreadPixels;
	local float		halfShotSpreadAngleInRadians;
	local int		tReticuleSpreadX;
	local int		tReticuleSpreadY;
	local float		halfShotSpreadMaxInRadians;
	local float		tReticuleSpreadMaxX;
	local float		tReticuleSpreadMaxY;

	if (	aPC == None ||
			aPC.Pawn == None ||
			aPC.Pawn.Weapon == None ||
			!aPC.Pawn.IsFirstPerson () )
	{
		return;
	}

	// Make sure to only draw the shot reticule when we are
	// holding guns.
	tMyWeapon = SASWeapon( aPC.Pawn.Weapon );
	if (	tMyWeapon == None || 
			tMyWeapon.mCategory == WPNCAT_Knife || 
			tMyWeapon.IsMovedOutOfView() )
	{
		return;
	}

	// Get the position of the center of the viewport.
	// and then move one to the left because that's how the gun
	// sights were placed in 3d.
	reticuleCenterX = aCanvas.SizeX * 0.5;
	reticuleCenterX -= 1;
	reticuleCenterY = aCanvas.SizeY * 0.5;

	// Get the indicator colour of what we are about to shoot.
	tColour = GetReticleColour ( aPC );

	// Determine the on screen size of the current shot spread.
	halfFovInRadians = ( aPC.FovAngleDegs * Pi / 360 );
	projectonPixelDist = aCanvas.SizeX / Tan( halfFovInRadians );

	halfShotSpreadAngleInRadians = ( tMyWeapon.mShotSpreadAngleCurrent / MAX_ANGLE ) * Pi;
	spreadPixels = projectonPixelDist * Tan( halfShotSpreadAngleInRadians );
	tReticuleSpreadX = spreadPixels;
	tReticuleSpreadY = spreadPixels;

	// Show this on screen so we can debug it easier.
	// Determine the on screen size of the max current shot spread.
	halfShotSpreadMaxInRadians = ( tMyWeapon.mShotSpreadAngleMaxCurrent / MAX_ANGLE ) * Pi;
	spreadPixels = projectonPixelDist * Tan( halfShotSpreadMaxInRadians );
	tReticuleSpreadMaxX = spreadPixels;
	tReticuleSpreadMaxY = spreadPixels;

	// Start the drawing of the retcule.
	aCanvas.Style = ERenderStyle.STY_Alpha;

	// Draw a centre dot for accurate aiming purposes.
	DrawReticleRect ( aCanvas, reticuleCenterX,  reticuleCenterY,  1, 1,  tColour );

	// Show the player how accurate their shot will be.
	tColour.A=128;
	DrawShotSpreadIndicator (	aCanvas,
								reticuleCenterX, reticuleCenterY,
								tReticuleSpreadX, tReticuleSpreadY,
								tColour	);
	if( IsDeveloper() )
	{
		// Show this on screen so we can debug it easier.
		tColour.R=255;
		tColour.G=0;
		tColour.B=0;
		tColour.A=128;
		DrawShotSpreadIndicator (	aCanvas,
									reticuleCenterX, reticuleCenterY,
									tReticuleSpreadMaxX, tReticuleSpreadMaxY,
									tColour	);
	}

	// Return to normal drawing as we are done drawing the reticule.
	aCanvas.Style = ERenderStyle.STY_Normal;
}

//------------------------------------------------------------------------------
// DrawRadioLog
//
simulated function DrawRadioLog ( Canvas aCanvas )
{
	local int		tPosY;
	local int		i,
					entry;
	local float		fx,
					fy;

	// only draw one line these days, less obtrusive
	SetOrangeColour(aCanvas);

	// top of radio log box
	tPosY = aCanvas.SizeY - 20;

	// find head of list
	entry = mSASGRI.mRadioLogEntriesHead - 1;

	// offset to text
	if (aCanvas.ClipX < 1024)
	{
		aCanvas.Font = aCanvas.FontBig24;
	}
	else
	{
		aCanvas.Font = aCanvas.FontBig34;
	}
	aCanvas.StrLen ( "Test", fx, fy );	// I'm just looking for the font height here ...
	fy -= 1;

	// draw string array
	for ( i = 0; i < MH_MAXMESSAGES; i++ )
	{
		if ( entry < 0 )
		{
			entry = mSASGRI.mMaxNumRadioLogEntries - 1;
		}


		// for centring too
		aCanvas.StrLen ( mSASGRI.mRadioMessageTextList[entry], fx, fy );

		aCanvas.SetPos ( aCanvas.SizeX * 0.5 - fx * 0.5, tPosY );

		aCanvas.DrawTextClipped ( mSASGRI.mRadioMessageTextList[entry] );
		tPosY += fy;

		entry--;
	}
}

//------------------------------------------------------------------------------
// DrawBoobyTrapDisarm
//
/*simulated function DrawBoobyTrapDisarm ( Canvas aCanvas )
{
	local SASPlayerController	tPC;
	local float					XLength;

	tPC = SASPlayerController ( Level.GetLocalPlayerController () );
	if ( tPC == None )
	{
		return;
	}

	// disarming booby trap icon
	if ( tPC.mbDisplayDisarmIcon )
	{
		tPC.mbDisplayDisarmIcon = false;

		XLength = 64.0;
		aCanvas.bNoSmooth = false;

		aCanvas.SetPos( 0.5 * (aCanvas.ClipX - XLength), 0.5 * (aCanvas.ClipY - XLength) );
		aCanvas.Style = ERenderStyle.STY_Translucent;

		if ( tPC.mbCanDisarm )
		{
			aCanvas.SetDrawColor( 0, 255, 0 );
		}
		else
		{
			aCanvas.SetDrawColor( 255, 0 , 0);
		}

		aCanvas.DrawTile( mDisarmIcons[ tPC.mDisarmIconIndex ], XLength, XLength, 0, 0, 128, 128 );
		aCanvas.SetPos( 0.5 * (aCanvas.ClipX - XLength), 0.5 * (aCanvas.ClipY - XLength) + XLength );

		if ( tPC.mbCanDisarm )
		{
			aCanvas.DrawText("F = Disarm");
		}
		else
		{
			aCanvas.DrawText("out of range");
		}

		aCanvas.bNoSmooth = true;
	}
}*/

/*
//------------------------------------------------------------------------------
// IsRoundComplete
//
simulated function bool IsRoundComplete ()
{
	return ( mSASGRI != None ) && mSASGRI.mbRoundComplete;
}
*/

//------------------------------------------------------------------------------
//
//
exec function OD( bool abDraw )
{
	mbDrawObjectivesDebug = abDraw;
}

//------------------------------------------------------------------------------
// InGame
//
auto state InGame
{
	///////////////////////////////////////////////////////////////////////////////
	// PostRender
	//
	simulated event PostRender (
		Canvas		aCanvas)	// Rendering canvas
	{
		local float YPos, YL;
		local SASPawn pwn;

		// Z-buffered HUD, default to obvious
		aCanvas.Z = 0;

		Super.PostRender ( aCanvas );

		//if ( IsRoundComplete () )
		//{
		//	EndMission ();
		//	return;
		//}
		if ( bShowScores )
		{
			return;
		}

		if ( !InitHUD () )
		{
			return;
		}

		if ( !mbDrawHUD )
		{
			return;
		}

		if ( !SASPlayerController(Level.GetLocalPlayerController()).mPressedButtonToStart )
		{
			//SASPlayerController(Level.GetLocalPlayerController()).RenderLevelStartPrompt( aCanvas, mStartGamePromptMessage );
			return;
		}

		// For the first few frames of the game, the level is rendered, and the matinee isn't
		// (this is an attempt to get the level textures cached)
		// So I have to stick a black square over the level.
		if (	( !SASPlayerController(Level.GetLocalPlayerController()).mMovieIntroDone &&
				Level.ShouldPlayStartupMovie() &&
				!IsMoviePlaying() ) ||
				SASPlayerController(Level.GetLocalPlayerController()).mMovieScriptedDone )
		{
			// cover things up
			aCanvas.SetDrawColor ( 0, 0, 0, 255 );
			aCanvas.DrawTileClipped (
				Level.DefaultTexture,
				aCanvas.SizeX, aCanvas.SizeY,
				0, 0,
				10, 10
				);

			// and then don't do anything else
			return;
		}

		if (IsMoviePlaying())
		{
			// So none of this then.
			return;
		}
		
		if( bRenderWeaponsOnly ) 
			return;

		// debug
		if ( mbDrawActorOverlays )
		{
			DrawActorOverlays ( aCanvas );
		}
		else if ( mbDrawAnimDebug )
		{
			DrawAnimDebug( aCanvas );
		}

		if (mbDrawSightLines)
		{
			foreach DynamicActors (class'SASPawn', pwn)
			{
				if (SASSoldierController (pwn.Controller) != None)
				{
					SASSoldierController (pwn.Controller).drawSightLineDebug (aCanvas);
				} // if
			} // foreach
		} // if

		if ( mbDrawActorDebug )
		{
			DrawActorDebug ( aCanvas );
		}

		if ( mbDrawTerroristGroupDebug )
		{
			YPos = 64.0;
			YL = 10.0;
			SASGameInfo( Level.Game ).mTerroristManager.DisplayGroupDebug( aCanvas, YL, YPos );
		}

		if (mDrawPawnLimbCollision > 0)
		{
			foreach DynamicActors ( class'SASPawn', pwn )
			{
				pwn.DrawLimbCollisionOverlay (self, aCanvas);
			} // foreach
		} // if

		/*foreach DynamicActors ( class'SASPawn', pwn )
		{
			if (SASSoldierController (pwn.Controller) != None &&
				SASSoldierController (pwn.Controller).mbIsWingman)
			{
				SASSoldierController (pwn.Controller).drawWingDebug (aCanvas);
			} // if
		} // foreach
*/
		if ( mbDrawObjectivesDebug )
		{
			mObjectiveManager.DrawDebug ( aCanvas );
		}

		DrawSPHUD ( aCanvas );
	}
}

simulated function bool InitHUD ()
{
	if ( mSASGRI == None )
	{
		InitSASGRI ();
		return false;
	}
	if ( mSquadManager == None )
	{
		InitSquadManager ();
		return false;
	}
	if ( mObjectiveManager == None )
	{
		InitObjectiveManager ();
	}

	if (mActionMenu == None)
	{
		InitActionMenu ();
		return false;
	} // if

// DEBUG!! -AC
// Place DVD like controls on the screen for replay playback.
//	if (mPlaybackControls == None)
//	{
//		InitActionMenu ();
//		return false;
//	} // if
// END DEBUG!!

	return true;
}

simulated function DrawSPHUD ( Canvas aCanvas )
{
	local SASPawn				myPawn;
	local SASPlayerController	PC;

	// Store owner playercontroller/pawn.
	// Used to determine which elements to draw depending on if these objects exist or not.
	PC = SASPlayerController( Level.GetLocalPlayerController() );
	if ( PC != None )
	{
		myPawn = SASPawn( PC.Pawn );
	}
	//weapon art polling
	DisplayWeaponLinearAart();
	//display damage controller bool
	
	// reset style
	aCanvas.Style = Style;
	aCanvas.SetDrawColor( 255, 255, 255 );
	if (aCanvas.ClipX < 1024)
	{
		aCanvas.Font = aCanvas.FontBig24;
	}
	else
	{
		aCanvas.Font = aCanvas.FontBig34;
	}

	mScaleX = aCanvas.SizeX / 1024.0;
	mScaleY = aCanvas.SizeY / 768.0;

// DEBUG!! -AC
// Place DVD like controls on the screen for replay playback.
//	mPlaybackControls.DrawPlaybackWidget( self, aCanvas, (aCanvas.SizeX/2), (aCanvas.SizeY-(aCanvas.SizeY/4)), ( aCanvas.SizeX - ( aCanvas.SizeX / 10 ) ), ( aCanvas.SizeY - ( aCanvas.SizeY / 10 ) ) );
// END DEBUG!!

	if( (Level.LevelAction != LEVACT_Loading) && (mSASGRI.mDifficultySetting.ShowCrosshair == 1) )
	{
		// hack for simon - always draw reticule
		if ((myPawn != None) && (mActionMenu.shouldDrawActionMenu () == false))
		{
			DrawReticle( aCanvas, PC );
			
			// Make sure to only aid the player in the PS2 version.
			if(IsPS2())
			{
				DrawAutoLockCircle( aCanvas, PC );
			}
		} // if
	}

	if ( mbDrawHUD && Level.LevelAction != LEVACT_Loading )
	{
		SetOrangeColour(aCanvas);

		if ( myPawn != None )
		{
			DrawTime( aCanvas );
			DrawPlayerStats( aCanvas, PC );

			DrawObjectives ( aCanvas );
			if ( mSASGRI.mDifficultySetting.ShowHealth == 1 )
			{
				// LAST MINUTE HACK: Squad health only shown in arcade mode - detecting this by checking
				// if reticule should be drawn.
				if ( mSASGRI.mDifficultySetting.ShowCrosshair == 1 )
				{
					DrawSquadStats ( aCanvas );
				}
			}
			if ( mSASGRI.mDifficultySetting.ShowMap == 1 )
			{
				DrawRadarMap ( aCanvas, PC );
			}
			DrawRadioLog ( aCanvas );

			DrawDamageIndicator( aCanvas );
		}

		// get rid of Z problems.
		aCanvas.Z = 0.0;

		if ( mFlashVignettes.Length > 0 )
		{
			DrawVignettes ( aCanvas );
		}
		if ( mActiveAfterImages.Length > 0 )
		{
			DrawAfterImage ( aCanvas );
		}
		
		DrawSplatTexture ( aCanvas );
		DrawDamageDirections ( aCanvas );
		DrawDamageOverlay( aCanvas );

		if ( myPawn != None )
		{
			if (mActionMenu.shouldDrawActionMenu () == true)
			{
				mActionMenu.drawActionMenu (self, aCanvas, aCanvas.SizeX / 3, (aCanvas.SizeY - aCanvas.SizeX / 3) / 2, aCanvas.SizeX / 3);
				bDrawOtherHUDitems = false;
			} // if
			else
			{
				bDrawOtherHUDitems = true;
			}
			if(bDrawOtherHUDitems)
				mActionMenu.drawActionIcon (self, aCanvas, aCanvas.SizeX * 0.5, aCanvas.SizeY - 90, 64);
		}
		// DEBUG - PRI stats for kills
		//pri = SASPRI ( PlayerController ( Owner ).PlayerReplicationInfo );
		//aCanvas.DrawTextAt ("Shots " $pri.mPlayerBulletsFired, 10, 380);
		//aCanvas.DrawTextAt ("Hits " $pri.mPlayerBulletsHitEnemy, 10, 390);
		//aCanvas.DrawTextAt ("Kills " $pri.mPlayerKills, 10, 400);
		//aCanvas.DrawTextAt ("Headshot " $pri.mPlayerHeadShotKills, 10, 410);
		//aCanvas.DrawTextAt ("Incap " $pri.mPlayerEnemiesIncapacitated, 10, 420);
		//aCanvas.DrawTextAt ("Knife " $pri.mPlayerKnifeKills, 10, 430);
		//aCanvas.DrawTextAt ("Ninja " $pri.mPlayerNinjaCount, 10, 440);
		//aCanvas.DrawTextAt ("Bowler " $pri.mPlayerBowler, 10, 450);
	}
}

//------------------------------------------------------------------------------
//
//
//state PauseScreen
//{
//}

//------------------------------------------------------------------------------
//
//
//::simulated function SetFontIdx ( int X )
//::{
//::	if ( X > 1600 )
//::	{
//::		mScoreFontIdx = 5;
//::	}
//::	else if ( X > 1280 )
//::	{
//::		mScoreFontIdx = 4;
//::	}
//::	else if ( X > 1024 )
//::	{
//::		mScoreFontIdx = 3;
//::	}
//::	else if ( X > 800 )
//::	{
//::		mScoreFontIdx = 2;
//::	}
//::	else if ( X > 640 )
//::	{
//::		mScoreFontIdx = 1;
//::	}
//::	else
//::	{
//::		mScoreFontIdx = 0;
//::	}
//::}

//------------------------------------------------------------------------------
//
//
simulated function int GetGradeIdx ( float score )
{
	// assess grade ...
	if ( score > mSASGRI.mLevelData.mGradeCaptain_PC )
	{
		return 4;
	}
	else if ( score > mSASGRI.mLevelData.mGradeSergeant_PC )
	{
		return 3;
	}
	else if ( score > mSASGRI.mLevelData.mGradeCorporal_PC )
	{
		return 2;
	}
	else if ( score > mSASGRI.mLevelData.mGradeTrooper_PC )
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

//------------------------------------------------------------------------------
//
//
function EndMission ()
{
	GotoState ( 'StatsScreen' );
	mActionMenu.endMission ();
}

//------------------------------------------------------------------------------
//
//
//::simulated function DrawMissionFailed ( Canvas aCanvas )
//::{
//::	if ( mbDrawHUD && Level.Pauser == None )
//::	{
//::		aCanvas.SetPos ( 0, 0 );
//::		aCanvas.SetDrawColor ( 255, 255, 255, 64 );
//::		aCanvas.Style = ERenderStyle.STY_Alpha;
//::		aCanvas.DrawTileClipped (
//::			mMissionFailedTexture,
//::			aCanvas.SizeX, aCanvas.SizeY,
//::			0, 0,
//::			mMissionFailedTexture.VSize, mMissionFailedTexture.USize
//::			);
//::		aCanvas.SetDrawColor( 255, 255, 255, 255 );
//::		aCanvas.Style = ERenderStyle.STY_Normal;
//::	}
//::}

simulated event bool DrawFinalScores ( Canvas aCanvas, int xPos1, int xPos2, int yPos )
{
	// We just do the frontend's final scores for the default mission, so this does nothing.
	return false;
}

function ActivateStatsScreen();


simulated function FixupScore()
{
	if ( mbScoreCalculated )
	{
		return;
	}
	mbScoreCalculated = true;

	// Do level specific score calculation. For normal missions this will
	// just call mSASGRI.UpdateScores(), for training missions the HUD uses a different
	// method to calculate the score for each mission.
	if ( !mSASGRI.mbMissionFailed )
	{
		CalcScore();
	}
	else
	{
		mSASGRI.mScore = 0;
		mSASGRI.mScorePC = 0;
	}

	// Update player profile with new scores for this level.
	mSASGRI.UpdatePlayerProfile();
	mObjectiveManager.UpdatePlayerProfile();
}

simulated function CalcScore()
{
	mSASGRI.UpdateScores();
}

//------------------------------------------------------------------------------
//
//

function PlayMissionEndMusic();


simulated event float PlayNextDebriefSound()
{
	return -1.0;
}

state StatsScreen
{	
	event BeginState()
	{
		SetTimer( 0.0, false );

		// Play ending music
		PlayMissionEndMusic();
	}

	function ActivateStatsScreen()
	{
		if ( !mbStatsScreenActivated )
		{
			mbStatsScreenActivated = true;
			GotoState( , 'Activate' );
		}
	}

	function PlayMissionEndMusic()
	{
		StopAllMusic( 0.0 );

		if ( mSASGRI.mbMissionFailed )
		{
			PlayMusic( "Mission_Fail_02", true );
		}
		else
		{
			PlayMusic( "Mission_Success", true );
		}
	}

	simulated event PostRender (
		Canvas aCanvas )	// Rendering canvas
	{
		// Very naughty - just draw a black poly over everything after the scripted movie render.
		if ( SASPlayerController(Level.GetLocalPlayerController()).mMovieScriptedDone )
		{
			// cover things up
			aCanvas.SetDrawColor ( 0, 0, 0, 255 );
			aCanvas.DrawTileClipped (
				Level.DefaultTexture,
				aCanvas.SizeX, aCanvas.SizeY,
				0, 0,
				10, 10
				);

			// and then don't do anything else
			return;
		}

		Super.PostRender(aCanvas);

		// draw something on screen
		//if ( mSASGRI.mbMissionFailed )
		//{
		//	DrawMissionFailed ( aCanvas );
		//}
		//else
		//{
			// JS the frontend draws all this stuff but then calls back to DrawFinalScores, rather than doing it here as we used to.
		//}
	}


	simulated event float PlayNextDebriefSound()
	{
		local Sound		s;
		local float		duration;

		switch ( meEndingSounds )
		{
		case ENDINGSOUNDS_Objectives:			// objective sounds
			do 
			{
				s = mObjectiveManager.GetObjectiveSound ( mObjSoundCount );
				mObjSoundCount++;
			} until ( ( s != None ) || ( mObjSoundCount >= mObjectiveManager.mNumObjectives ) );
			
			if ( s == None )
			{
				meEndingSounds = ENDINGSOUNDS_Casualty;
				return 1.0;
			}
			break;

		case ENDINGSOUNDS_Casualty:
			s = mObjectiveManager.mCasualtySounds[ mSASGRI.mSquadMembersKilled ];
			meEndingSounds = ENDINGSOUNDS_Grade;
			break;

		case ENDINGSOUNDS_Grade:
			if ( !mSASGRI.mbMissionFailed )
			{
				s = mObjectiveManager.mGradeSounds [ GetGradeIdx ( mSASGRI.mScorePC ) ];
			}
			meEndingSounds = ENDINGSOUNDS_Done;
			break;

		case ENDINGSOUNDS_Done:
		default:
			return -1.0;
		}

		if ( s != None )
		{
			duration = GetSoundDuration ( s ) + 0.3;
			PlayerController( Owner ).Pawn.PlaySound( s, SLOT_None, 1, true, 1000 );
			return duration;
		}
		else
		{
			return 1.0;
		}	
	}

	function Timer ()
	{
		// Calculate score here.
		if ( !mbScoreCalculated )
		{
			FixupScore();
		}

		SASGameInfo(Level.Game).MissionEndSequenceDone();

		// Turn off pause menu
		SASPlayerController( Owner ).ClientCloseMenu( true, true );
			
		// On PC, we start up the frontend while actually still in the level
		SASPlayerController( Owner ).SetPauseInternal ( true );
		StartupFrontend(0);

		SetTimer ( 0 );
	}

Begin:
	
	// Give bulletcam or any other pre-stats sequence a chance to pause the activation
	// of the stats screen.
	mbStatsScreenActivated = true;
	Sleep(0.1);
	if ( !mbStatsScreenActivated )
	{
		Stop;
	}
	
Activate:

	meEndingSounds = ENDINGSOUNDS_Objectives;
	mObjSoundCount = 0;
	SetTimer ( 5.0 );
}

//////////////////////////////////////////////////////////////////////////////
// WorldSpaceOverlays
//
simulated event WorldSpaceOverlays ()
{
	local NavigationPoint		nav;
	local SASPawn				pwn;
	local SASCoverPoint			cp;
	local SASDominationPoint	dp;
	local SASDoorMover			dm;
	local Color					cylinderCol;
	local Color					limbCol;
	local SASPickup				spu;
	local SASWeapon				weapon;
	local SASEntryPoint			ep;
	local Controller			C;

	Super.WorldSpaceOverlays ();

	// Debug draw of pickups
	if (mbDrawPickups)
	{
		foreach RadiusActors ( class'SASPickup', spu, Metres (20), Owner.Location)
		{
			spu.drawDebug (self);
		} // foreach
	} // if

	if (mbDrawWeapons)
	{
		foreach DynamicActors ( class'SASWeapon', weapon )
		{
			weapon.drawDebug (self);
		} // foreach
	}

	// Draw debug collision cylinders for all SASPawns
	if ( ( mDrawPawnCollision > 0) || ( mDrawPawnLimbCollision > 0) )
	{
		limbCol     = class'Canvas'.Static.MakeColor ( 255,   0,   0, 255 );
		cylinderCol = class'Canvas'.Static.MakeColor ( 255, 255,   0, 255 );

		foreach DynamicActors ( class'SASPawn', pwn )
		{
			if ( mDrawPawnCollision > 0 )
			{
				pwn.DrawCollisionCylinder ( self, cylinderCol, mDrawPawnCollision > 1, 9 );
			}
			if ( mDrawPawnLimbCollision > 0 )
			{
				pwn.DrawLimbCollision ( self, limbCol, false, 6 );
			}
		}
	} // if

	if ( mbDrawCoverPoints )
	{
		foreach AllActors ( class'SASCoverPoint', cp )
		{
			cp.DrawDebug ( self );
		}
	}

	if ( mbDrawDominationPoints )
	{
		foreach AllActors ( class'SASDominationPoint', dp )
		{
			dp.DrawDebug ( self );
		}
	}

	if ( mbDrawPaths )
	{
		for ( nav = Level.NavigationPointList; nav != None; nav = nav.NextNavigationPoint )
		{
			nav.DrawDebug( self );
		}
	}

	if ( mbDrawPaths )
	{
		for ( nav = Level.NavigationPointList; nav != None; nav = nav.NextNavigationPoint )
		{
			nav.DrawDebug( self );
		}
	}

	if ( mbDrawDoorCollision )
	{
		foreach AllActors ( class'SASDoorMover', dm)
		{
			dm.DrawDebug( self );
		}
	}

	/*foreach DynamicActors ( class'SASPawn', pwn )
	{
		if (SASSoldierController (pwn.Controller) != None &&
			SASSoldierController (pwn.Controller).mbIsWingman)
		{
			SASSoldierController (pwn.Controller).drawWingOverlay (self);
		} // if
	}*/

	if (mbDrawSightLines)
	{
		foreach DynamicActors ( class'SASPawn', pwn )
		{
			if (SASSoldierController (pwn.Controller) != None)
			{
				SASSoldierController (pwn.Controller).drawSightLineOverlay (self);
			} // if
			if (SASHostageController (pwn.Controller) != None)
			{
				SASHostageController (pwn.Controller).drawSightLineOverlay (self);
			} // if
		} // foreach
	} // if

	if (mbDrawSightLines)
	{
		foreach DynamicActors ( class'SASPawn', pwn )
		{
			if (SASSoldierController (pwn.Controller) != None)
			{
				SASSoldierController (pwn.Controller).drawSightLineOverlay (self);
			} // if
		} // foreach
	} // if

	if ( mDrawEPs > 0)
	{
		foreach AllActors ( class'SASEntryPoint', ep)
		{
			ep.drawEPOverlay( self );
		} // for
	} // if

	if ( mbDrawTerroristGroupDebug )
	{
		SASGameInfo( Level.Game ).mTerroristManager.DisplayGroupWorldSpaceOverlays( self );
	}

	if ( mbDrawShotDebug )
	{
		for ( C = Level.ControllerList; C != None; C = C.nextController )
		{
			if ( C.Pawn != None )
			{
				SASPawn( C.Pawn ).DrawShotDebug( self );
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION ActionSelect
//
function ActionSelect (int select)
{
	mActionMenu.ActionSelect (select);
} // ActionSelect

//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION UpdateActionMenu
//
function UpdateActionMenu (float deltaTime)
{
	mActionMenu.UpdateActionMenu (deltaTime);

// DEBUG!! -AC
// Place DVD like controls on the screen for replay playback.
//	mPlaybackControls.UpdatePlaybackWidget (deltaTime);
// END DEBUG!!
} // UpdateActionButton

//////////////////////////////////////////////////////////////////////////////
//
// FUNCTION draw3DText
//
// Draw text centred around the specified world position
function draw3DText (Canvas aCanvas, string text, Vector worldPosition)
{
	local vector screenPos;
	local PlayerController	tPC;

	tPC = Level.GetLocalPlayerController();
	if ( tPC == None || tPC.Pawn == None )
	{
		return;
	} // if

	// Only draw if the world position is in front of the camera
	if ((Vector (tPC.Pawn.Rotation ) dot (worldPosition - tPC.Pawn.Location)) < 0.0)
	{
		return;
	} // if

	screenPos = tPC.Player.Console.WorldToScreen (worldPosition);
	aCanvas.CentreText (text, screenPos.X, screenPos.y);
} // draw3DText
//////////////////////////////////////////////////////////////////////////////

/*
mSplatTexture(0)    = Texture'SFXTx.Wound.FxW_BloodSplat01'
mSplatTexture(1)    = Texture'SFXTx.Wound.FxW_BloodSplat02'
mSplatTexture(2)    = Texture'SFXTx.Wound.FxW_BloodSplat03'
mSplatTexture(3)    = Texture'SFXTx.Wound.FxW_BloodSplat04'
mSplatTexture(4)    = Texture'SFXTx.Wound.FxW_BloodSplat05'
mSplatTexture(5)    = Texture'SFXTx.Wound.FxW_BloodSplat06'
*/

//------------------------------------------------------------------------------
//
//




// Decompiled with UE Explorer.
defaultproperties
{
    CHARGE_BAR_HEIGHT=76.0000000
    CHARGE_BAR_HEIGHT_RES1=46.0000000
    PLAYER_HEAD_RIGHTNESS=80.0000000
    PLAYER_HEAD_RIGHTNESS_RES1=55.0000000
    HEAD_Y=100.0000000
    HEAD_Y_RES1=70.0000000
    PLAYER_HEAD_FADED_RES1=39.0000000
    CURRENT_MAG_LEFTNESS_RES1=130.0000000
    CURRENT_MAG_UPNESS_RES1=96.0000000
    CURRENT_MAG_WIDTH_RES1=30.0000000
    CURRENT_MAG_HEIGHT_RES1=70.0000000
    EMPTY_MAG_U_RES1=28.0000000
    EXTRA_MAGS_LEFTNESS_RES1=100.0000000
    EXTRA_MAG_RIGHT_STEP_RES1=20.0000000
    EXTRA_MAGS_UPNESS_RES1=82.0000000
    EXTRA_MAG_WIDTH_RES1=43.0000000
    EXTRA_MAG_HEIGHT_RES1=76.0000000
    EXTRA_MAG_U_RES1=60.0000000
    EXTRA_MAG_V_RES1=10.0000000
    CHARGE_BAR_WIDTH=200.0000000
    SQUAD_HEAD_RIGHTNESS=150.0000000
    CHARGE_BAR_WIDTH_RES1=120.0000000
    PLAYER_HEAD_FADED_U_RES1=44.0000000
    AMMO_COUNT_LEFTNESS_RES1=170.0000000
    BURST_LEFTNESS_RES1=200.0000000
    AMMO_COUNT_UPNESS=120.0000000
    AMMO_COUNT_UPNESS_RES1=100.0000000
    mObjectiveDisplayOnTime=3.0000000
    mObjectiveDisplayFadeTime=3.0000000
    mEndQuitTime=0.1000000
    mLabelScoring="Scoring"
    mLabelTerroristsKilled="Terrorists Killed"
    mLabelSurrederedTerroristsKilled="Surrendered Terrorists Killed"
    mLabelTerroristsCaptured="Terrorists Captured"
    mLabelTerroristsIncapacitated="Terrorists Incapacitated"
    mLabelSASKilled="SAS Killed"
    mLabelSASIncapacitated="SAS Incapacitated"
    mLabelHostagesKilled="Hostages Killed"
    mLabelHostagesSaved="Hostages Saved"
    mLabelHostagesIncapacitated="Hostages Incapacitated"
    mLabelTimeTaken="Time Taken"
    mLabelShotsFired="Shots Fired"
    mLabelShotsHit="Shots Hit"
    mLabelHitPC="Hit%"
    mLabelHeadHits="Head shots"
    mLabelBodyHits="Body shots"
    mLabelLimbHits="Limb shots"
    mLabelYES="YES"
    mLabelNO="NO"
    mLabelScorePC="Score%"
    mLabelGrade="Grade "
    mSingleFireModeLetter="S"
    mBurstFireModeLetter="B"
    mAutoFireModeLetter="A"
    mLabelGradeClass[0]="E: Recruit"
    mLabelGradeClass[1]="D: Trooper"
    mLabelGradeClass[2]="C: Corporal"
    mLabelGradeClass[3]="B: Sergeant"
    mLabelGradeClass[4]="A: Captain"
    mSplatTexture[0]=Texture'SFXTx.Wound.FxW_ScreenBlood01'
    mSplatFadeLength=3.0000000
    mInitialSplatNoFadeLength=3.0000000
    mOrangeStuff=Texture'HUDTx.Orange.HUD_01'
    mOrangeWeapons=Texture'HUDTx.Orange.gunsnclips'
    mOrangeHeads=Texture'HUDTx.Orange.HUD_Heads'
    mOrangeHeadsRes1=Texture'HUDTx.Orange.HUD_Heads_Res1'
    mOrangeHeadsTerr=Texture'HUDTx.Orange.HUD_HeadsTerr'
    mFireModeSingle=Texture'HUDTx.Orange.HUD_FireMode_Single'
    mFireModeBurst=Texture'HUDTx.Orange.HUD_FireMode_Burst'
    mFireModeAuto=Texture'HUDTx.Orange.HUD_FireMode_Auto'
    mOrangeChargeBar=Texture'HUDTx.Orange.HUD_ChargBar'
    mOrangeChargeBarRes1=Texture'HUDTx.Orange.HUD_ChargBar_Res1'
    mOrangeClips=Texture'HUDTx.Orange.HUD_Clips'
    mOrangeClipsRes1=Texture'HUDTx.Orange.HUD_Clips_Res1'
    mOrangeSpike=Texture'HUDTx.Elements.HUD_DamageSpiike'
    mDamageSphere=Texture'HUDTx.Elements.HUD_DamageSphere'
    mDripTexture=Texture'SFXTx.Wound.FxW_ScreenBlood2'
    mAfterImageColourspotTexture=Texture'SFXTx.Explosion.FxEXFlashburn'
    mAfterImageDarkspotTexture=Texture'SFXTx.Explosion.FxEXFlashburnBK'
    mAfterImageDarkspotFadeDurationRange=(Min=10.0000000,Max=10.0000000)
    mAfterImageColourspotFadeDurationRange=(Min=5.0000000,Max=10.0000000)
    mMaxAfterImages=100
    mXPixSizeAtDist100=800.0000000
    mYPixSizeAtDist100=600.0000000
    mMaxXPixSize=(Min=10.0000000,Max=800.0000000)
    mMaxYPixSize=(Min=10.0000000,Max=600.0000000)
    mDarkSpotInsetAmount=8
    mFalshBangDefaults=(FlashDurations=FlashDurations[0]=0.0000000
    FlashDurations[1]=0.0330000
    FlashDurations[2]=0.0670000
    FlashDurations[3]=0.1330000
    FlashDurations[4]=0.3000000,FlashIntensities=FlashIntensities[0]=0.0000000
    FlashIntensities[1]=1.0000000
    FlashIntensities[2]=0.0000000
    FlashIntensities[3]=1.0000000
    FlashIntensities[4]=0.0000000,VignetteDurations=VignetteDurations[0]=0.1660000
    VignetteDurations[1]=0.3300000
    VignetteDurations[2]=3.0000000,VignetteIntensities=VignetteIntensities[0]=0.0000000
    VignetteIntensities[1]=1.0000000
    VignetteIntensities[2]=0.0000000,BrightnessDurations=BrightnessDurations[0]=0.0000000
    BrightnessDurations[1]=0.2000000
    BrightnessDurations[2]=0.3600000
    BrightnessDurations[3]=1.8600000,BrightnessIntensities=BrightnessIntensities[0]=1.0000000
    BrightnessIntensities[1]=1.0000000
    BrightnessIntensities[2]=0.5000000
    BrightnessIntensities[3]=1.0000000,NumFlashKeys=5,NumBrightnessKeys=4,NumVignetteKeys=3,VignetteTexture=Texture'SFXTx.Explosion.FxEx_flash_vignetteBK',FlashModulateTexture=Texture'SFXTx.flashbang.FxScr_FlashModulate',FlashMaxAlpha=255,VignetteMaxAlpha=255)
    mDamageOverlayTex=Texture'SFXTx.Explosion.FxEx_flash_vignetteBK'
    mDamageOverlayDuration=0.6000000
    mDamageOverlayMaxAlpha=200.0000000
    mDamageOverlayRampDownPhase1MinAlpha=100.0000000
    mDamageOverlayRampUpEnd=0.1000000
    mDamageOverlayRampDownPhase1End=0.2000000
    mLastDamageTime[0]=-1000.0000000
    mLastDamageTime[1]=-1000.0000000
    mLastDamageTime[2]=-1000.0000000
    mLastDamageTime[3]=-1000.0000000
    mLastDamageTime[4]=-1000.0000000
    mLastDamageTime[5]=-1000.0000000
    mLastDamageTime[6]=-1000.0000000
    mLastDamageTime[7]=-1000.0000000
    mMapMask=Texture'HUDTx.Orange.MapMask'
    mMapCircler=Texture'HUDTx.Orange.HUD_MapCircle'
    mMissionFailedTexture=Texture'HUDTx.Logo.mission_failed'
    mMissionFailedRate=10.0000000
    mReticuleColourBorder=(R=0,G=0,B=0,A=128)
    mReticuleColourEnemy=(R=255,G=0,B=0,A=255)
    mReticuleColourHostage=(R=0,G=255,B=0,A=255)
    mReticuleColourAlly=(R=0,G=0,B=255,A=255)
    mReticuleColourBoobyTrap=(R=255,G=255,B=0,A=255)
    mReticuleColourDoorMover=(R=0,G=255,B=0,A=255)
    mReticuleColourNoTarget=(R=255,G=255,B=255,A=255)
    mReticleWidth=1.0000000
    mReticleHeight=4.0000000
    mReticleBorder=1.0000000
    mReticleGap=1.0000000
    mAutoTargetZoneTexture=Texture'HUDTx.Elements.HUD_CircleOnRet'
    mAutoTargetZoneLockTexture=Texture'HUDTx.Elements.HUD_CircleFinderRet'
    mLabelWingman="W"
    mLabelHuman="H"
    mLabelIncapacitated="I"
    mLabelDead="KIA"
    mLabelCancel="Cancel"
    mStanceNames[0]="Standing"
    mStanceNames[1]="Stooped"
    mStanceNames[2]="Crouched"
    mStanceNames[3]="Prone"
    mStanceNames[4]=""
    mStanceNames[5]="UNKNOWN"
    mDefTexture=Texture'Engine.WhiteSquareTexture'
    mAwardIcons[0]=Texture'GUIContent.AwardIcons.Award01_HHunter'
    mAwardIcons[1]=Texture'GUIContent.AwardIcons.Award02_Honcho'
    mAwardIcons[2]=Texture'GUIContent.AwardIcons.Award08_ICap'
    mAwardIcons[3]=Texture'GUIContent.AwardIcons.Award09_Brut'
    mAwardIcons[4]=Texture'GUIContent.AwardIcons.Award03_Hatchet'
    mAwardIcons[5]=Texture'GUIContent.AwardIcons.Award04_Frosty'
    mAwardIcons[6]=Texture'GUIContent.AwardIcons.Award07_DTap'
    mAwardIcons[7]=Texture'GUIContent.AwardIcons.Award05_Ninja'
    mAwardIcons[8]=Texture'GUIContent.AwardIcons.Award06_Bowler'
    mAwardIcons[9]=Texture'GUIContent.AwardIcons.Award10_Exec'
    mAwardIcons[10]=Texture'GUIContent.AwardIcons.Award11_Bobby'
    mLineart[0]=Texture'HUDTx.Weapon_Lineart.HUD_WL_AK47'
    mLineart[1]=Texture'HUDTx.Weapon_Lineart.HUD_WL_AKS74U'
    mLineart[2]=Texture'HUDTx.Weapon_Lineart.HUD_WL_AUG'
    mLineart[3]=Texture'HUDTx.Weapon_Lineart.HUD_WL_Beretta'
    mLineart[4]=Texture'HUDTx.Weapon_Lineart.HUD_WL_Browning'
    mLineart[5]=Texture'HUDTx.Weapon_Lineart.HUD_WL_CSGas'
    mLineart[6]=Texture'HUDTx.Weapon_Lineart.HUD_WL_Flashbang'
    mLineart[7]=Texture'HUDTx.Weapon_Lineart.HUD_WL_Frag'
    mLineart[8]=Texture'HUDTx.Weapon_Lineart.HUD_WL_Knife'
    mLineart[9]=Texture'HUDTx.Weapon_Lineart.HUD_WL_M4A1'
    mLineart[10]=Texture'HUDTx.Weapon_Lineart.HUD_WL_M60'
    mLineart[11]=Texture'HUDTx.Weapon_Lineart.HUD_WL_MAC11'
    mLineart[12]=Texture'HUDTx.Weapon_Lineart.HUD_WL_MK4Smoke'
    mLineart[13]=Texture'HUDTx.Weapon_Lineart.HUD_WL_Mossberg'
    mLineart[14]=Texture'HUDTx.Weapon_Lineart.HUD_WL_MP5'
    mLineart[15]=Texture'HUDTx.Weapon_Lineart.HUD_WL_MP5K'
    mLineart[16]=Texture'HUDTx.Weapon_Lineart.HUD_WL_MP5KLSS'
    mLineart[17]=Texture'HUDTx.Weapon_Lineart.HUD_WL_MP5LSS'
    mLineart[18]=Texture'HUDTx.Weapon_Lineart.HUD_WL_MP5SDLSST'
    mLineart[19]=Texture'HUDTx.Weapon_Lineart.HUD_WL_MP5SDT'
    mLineart[20]=Texture'HUDTx.Weapon_Lineart.HUD_WL_SG1'
    mLineart[21]=Texture'HUDTx.Weapon_Lineart.HUD_WL_SigP226'
    mLineart[22]=Texture'HUDTx.Weapon_Lineart.HUD_WL_SOCOM'
    mLineart[23]=Texture'HUDTx.Weapon_Lineart.HUD_WL_SWAT'
    mLineart[24]=Texture'HUDTx.Weapon_Lineart.HUD_WL_UZI9mm'
    mbDrawHUD=true
}