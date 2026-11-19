//=============================================================================
// SASTerrorist.uc
//=============================================================================

class SASTerrorist extends SASFighter
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Member Variables

// General properties
var() bool				mbFixedStationary;					// Terrorist cannot move if true.
var() name				mPatrolPointTag;					// Tag of a patrol point to start on.
var() Range				mReactionTime;						// Reaction time range
var() Range				mFiringDelayNewSighting;			
var() Range				mFiringDelayResighting;	
var() float				mCoverAggressionLevel;				// 0->1, specifies how frequently terrorist moves in and out of cover.
var() Range				mCoverMoveTime;						//
var() float				mDiscardNearEmptyClipChance;		// Chance of discarding a near empty clip when hiding at cover.
var() float				mChangeCoverThreatDistScalar;		// 
var() float				mMinChangeCoverDistToThreats;		// Min dist to threats below which will not try to move from cover.
var() float				mMinTimeAtCoverPoint;				// Min time at cover before can change cover
var() Range				mFireEmptyDuration;
var() Range				mSuppressiveFireDuration;			// Min/Max time to lay down suppressive fire.
var() Range				mFatalFunnelFireTime;				// Min/Max time to fire into fatal funnel.
var() float				mMinTimeBetweenGrenadeThrows;
var() bool				mbCanFireUndisciplined;				// Allow pawn to use undisciplined firing techniques.

// Engage threat properties
var() float				mAlertAggressivePct;				// Aggressive attack chance
var() float				mAlertCoverPct;						// Cover attack chance
var() float				mAlertRetreatPct;					// Retreat attack chance

// Acting dead properties
var() bool				mbActDeadFromStart;					// If true then will start level in acting dead state.
var() float				mActDeadChance;						// Chance of acting dead when becoming incapacitated. 
var() Range				mActDeadSleepTime;					// Time before recovering from acting dead.

// Surrendering
var() float				mSurrenderWhenCorneredChance;		// Chance of surrendering if cornered
var() float				mSurrenderWhenCorneredAssessInterval;	// Unused.
var() float				mSurrenderThreatMaxDist;			// Max dist to threats to consider surrendering
var() float				mSurrenderAllyMinDist;				// Min dist to active allies to consider surrendering
var() float				mSurrenderBreakoutGuardedChance;	// Chance of breaking out of surrendering while threats still nearby
var() Range				mSurrenderBreakoutGuardedTime;		// Time before breaking out of surrendering while threats still nearby

// Idle properties
var() array<name>		mIdleSpotAnims;						
var() Range				mIdleSpotAnimSpacing;
var() Range				mIdleChangeDirPeriod;
var() name				mIdleHidePointTag;		// REMOVE?
var() ESASStance		mIdleHideStance;		// REMOVE?

// Stunned params.
var() float				mStunnedSprayFireProbability;		// Chance of spraying fire when stunned by flashbang
var() Range				mStunnedSprayFireDuration;			// Duration to spray fire 

// Guarding hostages.
var() edfindable SASHostage mHostageTarget;					// Hostage to threaten/use as cover.
var() float				mHostageKillRangeFromThreat;		// Min range of threats before shooting threatened hostage.
var() Range				mHostageBeatingInterval;			// Time between hitting hostage
var() bool				mbBeatHostageTarget;				// If true then beating rather than threatening guarded hostage
var() bool				mbBeatKneelingHostage;				// If true then guarded hostage should kneel 
var() float				mBeatHostageTwiceChance;			// Chance of beating hostage twice in sight of player before killing him.
var() float				mBeatHostageTwiceMinDist;			// Min dist to player to allow hitting hostage in view a second time
var() Range				mHostageBeatingKillDelay;			// Delay before killing hostage after finished beating.
var() float				mHostageStandoffSpeechRange;		// Range from visible threats for playing standoff speech.

// Sound
var(Sound) array<Sound>	mKickSounds;

var bool				mbActingDead;
var bool				mbActingDeadCanBeCuffed;

replication
{
	// Varibles the server sends to clients.
	reliable if ( Role == ROLE_Authority && bNetDirty )
		mbActingDead,
		mbActingDeadCanBeCuffed;
}

//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions


///////////////////////////////////////////////////////////////////////////////
// PreBeginPlay
// 
event PreBeginPlay()
{
	local bool				bInPosition;
	local bool				bFound;
	local float				total;
	local float				scale;
	local Actor				hidePointActor;
	local SASPatrolPoint	pp;
	local SASGRI			gri;

	Super.PreBeginPlay();

	// If side has not been specified for instance then set it to default
	// terrorist side. 
	if ( mSide == SIDE_None )
	{
		mSide = SIDE_Terrorist;
	}

	// Sanity check that mPawnType var is set correctly.
	if ( mPawnType != PAWN_Terrorist )
	{
		Warn( "SASTerrorist with pawn type != PAWN_Terrorist!!!" );
		mPawnType = PAWN_Terrorist;
	}

	// Normalise engage reaction percentages
	mAlertAggressivePct	= Max( mAlertAggressivePct, 0.0 );
	mAlertCoverPct		= Max( mAlertCoverPct, 0.0 );
	mAlertRetreatPct	= Max( mAlertRetreatPct, 0.0 );
	total = mAlertAggressivePct + mAlertCoverPct + mAlertRetreatPct;
	if ( total == 0.0 )
	{
		mAlertAggressivePct	= 0.34;
		mAlertCoverPct		= 0.33;
		mAlertRetreatPct	= 0.33;
	}
	else
	{
		scale = 1.0 / total;

		mAlertAggressivePct	*= scale;
		mAlertCoverPct		*= scale;
		mAlertRetreatPct	*= scale;
	}

	// Make sure properties are in valid ranges
	mStunnedSprayFireProbability = FClamp( mStunnedSprayFireProbability, 0.0, 1.0 );

	// Place at 'hiding' location if specified, otherwise choose random
	// spawn point.
	if ( mIdleHidePointTag != 'None' )
	{	
		foreach AllActors ( class'Actor', hidePointActor, mIdleHidePointTag )
		{
			SetLocation ( hidePointActor.Location );
			SetRotation ( hidePointActor.Rotation );
			DropToGround();
			
			bInPosition = true;

			break;
		}

		if ( !bInPosition )
		{
			Warn( "Could not find hide point with tag "$mIdleHidePointTag$" for terrorist "$self );

			// Set idle hide point tag to None to indicate that we don't have a hide point.
			mIdleHidePointTag = 'None';
		}
	}

	if ( mPatrolPointTag != 'None' )
	{
		// Check that a patrol point exists with our patrol point tag
		foreach AllActors ( class'SASPatrolPoint', pp, mPatrolPointTag )
		{
			bFound = true;
			break;
		}

		if ( !bFound )
		{
			Warn( "Could not find patrol point with tag "$mPatrolPointTag$" for terrorist "$self );
	
			// Set patrol point tag to None to indicate that we can't patrol.
			mPatrolPointTag = 'None';
		}
	}

	// If we have a hostage target then we shouldn't spray fire when getting stunned.
	if ( mHostageTarget != None )
	{
		mStunnedSprayFireProbability = 0.0;
	}

	// Scale various attributes as required by the difficulty setting.
	gri = SASGRI( Level.Game.GameReplicationInfo );
	if ( gri != None )
	{
		// Scale reaction time.
		if ( gri.mDifficultySetting.TerrReactTimeScalar <= 0.0 )
		{
			LogHuman( "Difficulty settings: TerrReactTimeScalar <= 0" );
		}
		else
		{
			mReactionTime.Min *= gri.mDifficultySetting.TerrReactTimeScalar;
			mReactionTime.Max *= gri.mDifficultySetting.TerrReactTimeScalar;
		}

		// Scale firing accuracy cone.
		if ( gri.mDifficultySetting.TerrAccScalar <= 0.0 )
		{
			LogHuman( "Difficulty settings: TerrAccScalar <= 0" );
		}
		else
		{
			mShooterSpreadAngleNormal *= gri.mDifficultySetting.TerrAccScalar;
		}

		// Scale firing 'innacuracy' cone.
		if ( gri.mDifficultySetting.TerrInaccScalar <= 0.0 )
		{
			LogHuman( "Difficulty settings: TerrInaccScalar <= 0" );
		}
		else
		{
			mShooterNoHitZoneBase *= gri.mDifficultySetting.TerrInaccScalar;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Activated
//
// This gets called on pawns which start the level inactive when they get activated.
event Activated()
{
	local SASTerroristController	TC;

	TC = SASTerroristController( Controller );
	if ( TC != None && TC.mTerroristMgr != None )
	{
		TC.mTerroristMgr.AddTerrorist( TC );
	}

	// Find a place to spawn.
	if ( mIdleHidePointTag == 'None' )
	{
		ChooseSpawnPoint();
	}
}


///////////////////////////////////////////////////////////////////////////////
// Surrender
// 
function Surrender(
	bool bSurrendered )
{	
	if ( bSurrendered != mbSurrendered )
	{
		mbPlayedSurrendering = false;
	}
	mbSurrendered		= bSurrendered;
	SetCombatCapable( !bSurrendered );

	StopAiming();

	if ( mePace == PACE_Charging )
	{
		SetPace( PACE_Running );
	}
	ChangeAnimation();
}


///////////////////////////////////////////////////////////////////////////////
// ThreatenHostage
// 
function ThreatenHostage( 
	SASHostage	aHostage,
	float		aHostageKillRangeFromThreat	)
{
	mbBeatHostageTarget = false;
	mHostageTarget = aHostage;
	mHostageKillRangeFromThreat = aHostageKillRangeFromThreat;

	SASTerroristController( Controller ).DoThreatenHostage();
}


///////////////////////////////////////////////////////////////////////////////
// StopThreateningHostage
// 
function StopThreateningHostage()
{
	//mHostageTarget = None;

	SASTerroristController( Controller ).StopThreateningHostage();
}


///////////////////////////////////////////////////////////////////////////////
// KillThreatenedHostage
// 
function KillThreatenedHostage()
{
	if ( mHostageTarget != None )
	{
		// FIXME: This will only work if terrorist has line of fire to hostage - since
		// ThreatenHostage state assumes this is true when moving to the KillHostage label.
		SASTerroristController(Controller ).GotoState( 'ThreateningHostage', 'KillHostage' );
	}
}


///////////////////////////////////////////////////////////////////////////////
// BeatUpHostage
// 
//::function BeatUpHostage( 
//::	SASHostage	aHostage )
//::{
//::	mbBeatHostageTarget = true;
//::	mHostageTarget = aHostage;
//::
//::	SASTerroristController( Controller ).DoBeatHostage();
//::}


///////////////////////////////////////////////////////////////////////////////
// StopBeatingHostage
// 
function StopBeatingHostage( 
	SASHostage	aHostage )
{
	mbBeatHostageTarget = false;
	SASTerroristController( Controller ).StopBeatingHostage();
}


///////////////////////////////////////////////////////////////////////////////
// CanBePunched
//
// Check if pawn can be puched using action menu. 
simulated event bool CanBePunched()
{
	// Check SASPawn shared criteria
	if ( !Super.CanBePunched() )
	{
		return false;
	}

	if ( mbSurrendered || mbActingDead )
	{
		return false;
	}

	return true;
}


///////////////////////////////////////////////////////////////////////////////
// CanBeHandcuffed
//
simulated event bool CanBeHandcuffed()
{
	if ( meStance != STANCE_Prone )
	{
		return false;
	}

	if ( mbActingDead )
	{
		return mbActingDeadCanBeCuffed;
	}

	if ( mbIsIncapacitated )
	{
		return mbIncapCanBeCuffed;
	}

	return true;
}


///////////////////////////////////////////////////////////////////////////////
// PlayActingDead
// 
simulated function PlayActingDead(
	bool			abStayDown )
{
	if ( (Controller != None) && (Controller.mType == CONTROLLER_AITerrorist) )
	{
		SASTerroristController( Controller ).DoActingDead( abStayDown );

		// Prevent acting dead happening more than once.
		mActDeadChance = 0.0;

		PlaySpeech( SPEECH_TerrFeignDeath );
	}
}


///////////////////////////////////////////////////////////////////////////////
// EndActingDead
// 
simulated function EndActingDead(
	bool abRecoverToIdle ) 
{
	if ( (Controller != None) 
		&& (SASTerroristController( Controller ) != None) )
	{
		SASTerroristController( Controller ).EndActingDead( abRecoverToIdle );
	}
}

///////////////////////////////////////////////////////////////////////////////
// MultiTimer
// 
event MultiTimer(
	int	aTimerIndex )
{
	switch ( aTimerIndex )
	{
	default:
		Super.MultiTimer( aTimerIndex );
		break;
	}
}


///////////////////////////////////////////////////////////////////////////////
// PlayCallingAnim
//
function bool PlayCallingAnim(
	Pawn	aDirectedTo )
{
	local name		anim;
	local bool		bUseLeftOrRightBeckon,
					bUpperBodyOnly;
	local float		tmp,
					dist,
					dp;
	local Vector	vecToOther,
					dir;

	dir = YawDirection();

	vecToOther = aDirectedTo.Location - Location;
	dist = NormalizeAndGetLength( vecToOther );
	dp = dir Dot vecToOther;

	// Don't signal to people in front.
	if ( dp > 0.707 )
	{
		return false;
	}

	if ( (dist < 240.0) || (dp > -0.867/*cos(150)*/) )
	{
		// When nearby or always play either left or right beckon anim.
		bUseLeftOrRightBeckon = true;
	}

	if ( bUseLeftOrRightBeckon )
	{
		// Beckoned pawn is to left or right of me?

		// Get our right vec.
		tmp = dir.X;
		dir.X = -dir.Y;
		dir.Y = tmp;

		dp = dir Dot vecToOther;
		if ( dp < 0.0 )
		{
			anim = 'Stand_BeckonR_AK47';
		}
		else
		{
			anim = 'Stand_BeckonL_AK47';
		}
	}
	else
	{
		anim = 'Stand_RaiseAlarm_AK47';
	}
	
	if ( meStance == STANCE_Crouched )
	{
		bUpperBodyOnly = true;
	}
	PlayActionAnim( anim, 1.0, 0.15, false, bUpperBodyOnly );

	return true;
}


///////////////////////////////////////////////////////////////////////////////
// AnimNotifyKick
// 
// Callback from animation to instigate a kick... Used in send scene
// when terrorist kicks your dead body.
simulated event AnimNotifyKick()
{
	local float			pitch;

	pitch = ((frand()*0.4)-0.2);
	PlaySound(mKickSounds[rand(mKickSounds.Length)], SLOT_None,,,,pitch);
}


///////////////////////////////////////////////////////////////////////////////
// AnimNotifyDropWeapon
//
simulated event AnimNotifyDropWeapon()
{
	// Only drop weapon on anim notify when surrendering. However we might
	// just unsurrender while playing the anim in which case don't drop it!
	if ( mbSurrendered )
	{
		DropWeapon();
	}
}

///////////////////////////////////////////////////////////////////////////////
// ChooseStunnedAnim
//
// Select a random stunned anim. Does not play the anim, just sets up the
// mStunnedAnim param which is used in future calls to AnimateStunned().
simulated function ChooseStunnedAnim()
{
	// Decide whether to spray fire or not
	if (	(FRand() < mStunnedSprayFireProbability) && 
			(Weapon != None) &&
			(SASWeapon( Weapon ).HasFireMode( 
					class'SASWeapon'.Static.GetFireModeFromName( 'FIREMODE_Auto' ))) )
	{
		meStunnedAnimType = STUNANIM_SprayingFire;
	}
	else
	{
		meStunnedAnimType = STUNANIM_Blinded;
	}
}


///////////////////////////////////////////////////////////////////////////////
// ChooseBeatHostageAnim
//
simulated function name ChooseBeatHostageAnim()
{
	local float	randVal;

	if ( Weapon == None )
	{
		return 'None';
	}

	randVal = FRand();

	switch ( SASWeapon( Weapon ).mCategory )
	{
	case WPNCAT_Primary:
		if ( mbBeatKneelingHostage )
		{
			// Choose random beat kneeling hostage anim.
			if ( randVal < 0.5 )
			{
				return 'Stand_Rifebutt_02_AK47';
			}
			else
			{
				return 'Stand_Punch_03_AK47';
			}
		}
		else
		{
			// Choose random beat standing hostage anim.
			if ( randVal < 0.25 )
			{
				return 'Stand_Rifebutt_AK47';
			}
			else if ( randVal < 0.5 )
			{
				return 'Stand_Rifebutt_03_AK47';
			}
			else if ( randVal < 0.75 )
			{
				return 'Stand_Punch_01_AK47';
			}
			else
			{
				return 'Stand_Punch_02_AK47';
			}
		}
		break;

	case WPNCAT_Secondary:
		if ( mbBeatKneelingHostage )
		{
			if ( randVal < 0.5 )
			{
				return 'Stand_Pistolwhip_02_AK47';
			}
			else
			{
				return 'Stand_Pistolwhip_03_AK47';
			}
		}
		else
		{
			return 'Stand_Pistolwhip_01_AK47';
		}
		break;

	default:
		Warn( self$" called ChooseBeatHostageAnim with invalid weapon category <"$SASWeapon( Weapon ).mCategory$">" );
	}

	return 'None';
}


///////////////////////////////////////////////////////////////////////////////
// PlayTakeHit
//
simulated function PlayTakeHit(
	Vector				aHitLocation,
	int					aDamage,
	class<DamageType>	aDamageType )
{
	if ( mbActingDead )
	{
		return;
	}

	// Use different anims if surrendered.
	if ( mbSurrendered && meStance == STANCE_Standing )
	{
		PlayTakeHitSurrendered( aHitLocation, aDamage, aDamageType );
		return;
	}

	Super.PlayTakeHit( aHitLocation, aDamage, aDamageType );
}


///////////////////////////////////////////////////////////////////////////////
// PlayTakeHit
//
simulated function PlayTakeHitSurrendered(
	Vector				aHitLocation,
	int					aDamage,
	class<DamageType>	aDamageType )
{
	local name			hitAnim,
						startBone;
	local ESASBodyParts hitBodyPart;

	// Randomly play?
	if ( (mPlayHitAnimChance < 1.0) && (FRand() > mPlayHitAnimChance) )
	{
		return;
	}

	// Don't play hit anims if any of:
	// 1) while in root motion physics
	// 2) incapacitated
	// 3) not in standing or crouched stance
	// 4) controller is in animation transition state
	if (	(Physics == PHYS_RootMotion) ||
			mbIsIncapacitated ||
			((meStance != STANCE_Standing) && (meStance != STANCE_Crouched)) ||
			((Controller != None) && (Controller.GetStateName() == 'Transition')) )
	{
		return;
	}

	hitBodyPart = ESASBodyParts( mLimbCylinders[mTakeHitAnimBoneCylinder].mBodyPart );

	// Do full body/partial body anim depending on whether moving or not.
	if ( !IsStationary() )
	{
		// If not stationary, don't play hit anims on legs.
		switch ( hitBodyPart )
		{
		case BODYPART_LLEG:
		case BODYPART_RLEG:
			return;
		}

		// Only play on upper body.
		startBone = SPINE_BONE;
	}

	hitAnim = ChooseSurrenderedHitAnim( hitBodyPart );
	if ( hitAnim != 'None' )
	{
		mLastHitAnim = hitAnim;

		AnimBlendParams( ANIMCHANNEL_HIT, 1.0, 0.0, 0.0, startBone, true );
		PlayAnim( hitAnim, 1.0, 0.1, ANIMCHANNEL_HIT );
	}
}


///////////////////////////////////////////////////////////////////////////////
// ChooseSurrenderedHitAnim
//
simulated function name ChooseSurrenderedHitAnim(
	ESASBodyParts	aHitBodyPart )
{
	local float	randVal;

	switch ( aHitBodyPart )
	{
	case BODYPART_HEAD:
	case BODYPART_BODY:
	case BODYPART_LLEG:
	case BODYPART_RLEG:
	case BODYPART_UNKNOWN:
		randVal = FRand();
		if ( randVal < 0.25 )
		{
			return 'Stand_Shot_Middle_Surrender01';
		}
		else if ( randVal < 0.5 )
		{
			return 'Stand_Shot_Middle_Surrender02';
		}
		else if ( randVal < 0.75 )
		{
			return 'Stand_Shot_Middle_Surrender03';
		}
		else
		{
			return 'Stand_Shot_Middle_Surrender04';
		}

	case BODYPART_LARM:
		randVal = FRand();
		if ( randVal < 0.34 )
		{
			return 'Stand_Shot_Left_Surrender01';
		}
		else if ( randVal < 0.67 )
		{
			return 'Stand_Shot_Left_Surrender02';
		}
		else
		{
			return 'Stand_Shot_Left_Surrender03';
		}

	case BODYPART_RARM:
		randVal = FRand();
		if ( randVal < 0.5 )
		{
			return 'Stand_Shot_Right_Surrender01';
		}
		else 
		{
			return 'Stand_Shot_Right_Surrender02';
		}
		break;

	default:
		Warn( "SASTerrorist.ChooseSurrenderedHitAnim called with invalid hit body part <"$aHitBodyPart$">" );
		return 'None';
	}

	return 'None';
}


///////////////////////////////////////////////////////////////////////////////
// ShouldUseIncapAnims
//
simulated function bool ShouldUseIncapAnims()
{
	if ( Super.ShouldUseIncapAnims() )
	{
		return true;
	}

	return mbActingDead;
}

//-----------------------------------------------------------------------------
// GetMaxPace
//
function ESASPace GetMaxPace()
{
	// Surrendered terrorists can only walk unless they are avoiding grenades.
	if ( mbSurrendered )
	{
		if ( SASAIController( Controller ).mNumGrenadesDetected == 0 )
		{
			return PACE_Walking;
		}
		else
		{
			return PACE_Running;
		}
	}
	return Super.GetMaxPace();
}


///////////////////////////////////////////////////////////////////////////////
//
function bool DrawCollision ()
{
	return false;
} // DrawCollision

//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mReactionTime=(Min=0.5000000,Max=0.8500000)
    mFiringDelayNewSighting=(Min=0.5000000,Max=0.8500000)
    mFiringDelayResighting=(Min=0.2000000,Max=0.3000000)
    mCoverAggressionLevel=0.5000000
    mCoverMoveTime=(Min=4.0000000,Max=8.0000000)
    mChangeCoverThreatDistScalar=0.3500000
    mMinChangeCoverDistToThreats=250.0000000
    mMinTimeAtCoverPoint=2.5000000
    mSuppressiveFireDuration=(Min=0.5000000,Max=0.5000000)
    mbCanFireUndisciplined=true
    mAlertAggressivePct=33.3400000
    mAlertCoverPct=33.3300000
    mAlertRetreatPct=33.3300000
    mActDeadChance=0.2500000
    mActDeadSleepTime=(Min=3.0000000,Max=5.0000000)
    mSurrenderWhenCorneredChance=0.1000000
    mSurrenderWhenCorneredAssessInterval=5.0000000
    mSurrenderThreatMaxDist=400.0000000
    mSurrenderAllyMinDist=700.0000000
    mSurrenderBreakoutGuardedChance=0.3300000
    mSurrenderBreakoutGuardedTime=(Min=5.0000000,Max=10.0000000)
    mIdleSpotAnimSpacing=(Min=6.0000000,Max=12.0000000)
    mStunnedSprayFireProbability=0.3000000
    mStunnedSprayFireDuration=(Min=1.5000000,Max=3.0000000)
    mHostageKillRangeFromThreat=150.0000000
    mHostageBeatingInterval=(Min=1.0000000,Max=2.0000000)
    mBeatHostageTwiceChance=0.5000000
    mBeatHostageTwiceMinDist=250.0000000
    mHostageBeatingKillDelay=(Min=1.0000000,Max=1.5000000)
    mHostageStandoffSpeechRange=2000.0000000
    mKickSounds[0]=Sound'SASSounds.Base.Kick'
    mSide=3
    mInventoryWeapons="SASWeapons.AK47_Wpn"
    mGasGrenadeIgnoreChance=0.3000000
    mShooterNoHitZoneBase=5460
    mShooterNoHitZoneDecay=2730.0000000
    mShooterNoHitZoneTimeout=10.0000000
    mPawnType=2
    bSameZoneHearing=true
    bMuffledHearing=true
    bAroundCornerHearing=true
    GroundSpeed=255.0000000
    Health=40
    ControllerClass=Class'SASTerroristController'
    BaseMovementRate=240.0000000
    Mesh=SkeletalMesh'CSas.CT02'
}