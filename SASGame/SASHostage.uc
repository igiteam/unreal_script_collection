//=============================================================================
// SASHostage.uc
//=============================================================================

class SASHostage extends SASPawn
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants
//

//-----------------------------------------------------------------------------
// Enums
//

//-----------------------------------------------------------------------------
// Member Vars
//

var() Range			mReactionTime;
var() Range			mSlowReactionTime;
var() float			mPanicChance;
var() float			mWetSelfChance;
var() float			mStockholmChance;
var() float			mPanicTimeout;
var() bool			mbUnresponsive;

// Speech control params.
var() Range			mGuardedSpeechTime;				// Time between whimpers/other guarded speech samples.
var() float			mThreatenedStockholmChance;
var() float			mThreatenedPleadForHelpChance;	// Chance of playing plead for help instead of whimper when in threatened state.
var() float			mWiredHostageIdentChance;		// Chance of playing ident wired hostage on sighting soldier while unguarded.
var() float			mTerroristIdentChance;			// Chance of playing ident terrorist on sighting soldier while unguarded.
var() Range			mPanicSpeechInterval;

// Wired with explosive params.
var() bool			mbExplosive;
var() class<SASGenericExplosion>	mExplosionClass;
var() float			mExplosiveDisarmTime;
var() float			mExplosiveDisarmRadius;
var() float			mExplosiveWarnMaxDist;

// Gun taped to had params.
var() bool			mbGunTapedToHand;
var() float			mGunTapedToHandDeactivationRange;
var() Range			mGunTapedToHandInitialSpeechDelay;
var() Range			mGunTapedToHandSpeechInterval;		

// Flinch params.
var() Range			mNearbyGunfireDist;
var() float			mNearbyGunfireFlinchChance;
var() float			mDistantGunfireFlinchChance;
var() float			mGunfireFlinchMaxDist;
var() float			mGunfireTakeCoverMaxDist;
var() Range			mMinTimeBetweenFlinches;
var() Range			mFlinchMinTimeBetweenGunfire;
var() float			mGunfireCounterDecayRate;

var() float			mExplosionFlinchMaxDist;
var() float			mExplosionDiveToGroundMaxDist;

// Taking cover params.
var() Range			mSustainedGunfireToTakeCover;
var() Range			mTimeInCover;

// Animation data.

var() Array<Name>	mStandIdleAnims;
var() Array<Name>	mStandFlinchAnims;

// Misc runtime vars.
var bool			mbCowering;
var bool			mbWettingSelf;
var bool			mbThreatened;
var bool			mbTakingBeating;
var bool			mbIsFollowing;
var bool			mbReadyToBeCuffed;
var bool			mbObeyOrderGetDown;
var bool			mbObeyOrderFollow;
var bool			mbPanicking;
var SASTerrorist	mGuardingTerrorist;
var SASWeeWeePool	mPoolOfWee;
var SASWeeWeeDrip	mWeeWeeDrip;


//-----------------------------------------------------------------------------
// Replication
//
replication
{
	// Variables the server should send to the client.
	reliable if ( bNetDirty && ( Role == ROLE_Authority ) )
		mbExplosive,
		mbGunTapedToHand,
		mbCowering,
		mbThreatened,
		mbTakingBeating,
		mbIsFollowing,
		mbReadyToBeCuffed,
		mGuardingTerrorist,
		mbObeyOrderGetDown,
		mbObeyOrderFollow,
		mbPanicking;
}


//-----------------------------------------------------------------------------
// Native Functions
//

//-----------------------------------------------------------------------------
// Exec Functions
//

//-----------------------------------------------------------------------------
// Functions
//

//-----------------------------------------------------------------------------
// PreBeginPlay
//
event PreBeginPlay ()
{
	local float	tot;

	Super.PreBeginPlay();

	// If side has not been specified for instance then set it to default
	// hostage side.
	if (mSide == SIDE_None )
	{
		mSide = SIDE_Hostage;
	}

	// Sanity check that mPawnType var is set correctly.
	if ( mPawnType != PAWN_Hostage )
	{
		Warn( "SASHostage with pawn type != PAWN_Hostage!!!" );
		mPawnType = PAWN_Hostage;
	}

	// Normalise reaction behaviour chances.
	mPanicChance = FMax( mPanicChance, 0.0 );
	mWetSelfChance = FMax( mWetSelfChance, 0.0 );
	mStockholmChance = FMax( mStockholmChance, 0.0 );
	tot = mPanicChance + mWetSelfChance + mStockholmChance;
	if ( tot > 0.0 )
	{
		mPanicChance /= tot;
		mWetSelfChance /= tot;
		mStockholmChance /= tot;
	}
	// Else they are all zero which indicates none on these reactions are allowed.

	// if any spawn points are associated with this hostage then choose one
	ChooseSpawnPoint();

	if ( mbExplosive && (mExplosionClass == None) )
	{
		LogHuman( "Hostage <"$self$"> set to be explosive but have undefined explosion class." );
	}
}


//-----------------------------------------------------------------------------
// Activated
//
// This gets called on pawns which start the level inactive when they get activated.
event Activated()
{
	// Find a place to spawn.
	ChooseSpawnPoint();
}


//-----------------------------------------------------------------------------
// AnimEnd
//
simulated event AnimEnd(
	int	aChannel )
{
	if (	aChannel == ANIMCHANNEL_Action && 
			mbPanicking && 
			meStance == STANCE_Standing )
	{	
		// Keep looping panic anim.
		PlayPanic( true );
	}
	else
	{
		Super.AnimEnd( aChannel );
	}
}


//-----------------------------------------------------------------------------
// TakeDamage
// 
function TakeDamage(
	int					aDamage, 
	Pawn				aInstigatedBy, 
	vector				aHitlocation, 
	vector				aMomentum, 
	class<DamageType>	aDamageType,
	optional Weapon		weapon)
{
	Super.TakeDamage( aDamage, aInstigatedBy, aHitlocation, aMomentum, aDamageType, weapon );

	// If wired with explosives then blow up.
	if ( mbExplosive )
	{
		Explode();

		// Make sure this kills me!
		if ( IsAlive() )
		{
			Health = 0;
			Died( aInstigatedBy.Controller, aDamageType, aHitlocation );
		}
	}
}


//-----------------------------------------------------------------------------
// CanBeOrdered
//
simulated function bool CanBeOrdered(
	SASHostageController.EHostageOrder	aeOrderType )
{
	// Properties that make us unorderable:
	//		- Flagged as unresponsive in editor
	//		- Explosive
	//		- (Stunned)
	//		- (Gassed)
	//		- (Scripting)
	if ( mbUnresponsive || mbExplosive )
	{
		return false;
	}

	switch ( aeOrderType )
	{
	case HOSTAGEORDER_GetDown:
		// Can't get down if already cuffed.
		if ( mbCaptured )
		{
			return false;
		}
		return mbObeyOrderGetDown;

	case HOSTAGEORDER_Follow:
		// Only obey follow order if handcuffed.
		if ( !mbCaptured )
		{
			return false;
		}
		return mbObeyOrderFollow;
	}

	return false;
}


//-----------------------------------------------------------------------------
// DisarmExplosive
//
function DisarmExplosive()
{
	// Only allow on server.
	if ( Role != ROLE_Authority )
	{
		return;
	}

	mbExplosive = false;
	if ( Controller != None )
	{
		SASHostageController( Controller ).ExplosiveDisarmed();
	}
}


//-----------------------------------------------------------------------------
// Explode
//
function Explode()
{
	if ( mExplosionClass != None )
	{
		Spawn( mExplosionClass,,, Location, rot( 16384, 0, 0 ) );
	}
}


//-----------------------------------------------------------------------------
// GetMaxPace
//
function ESASPace GetMaxPace()
{
	return PACE_Running;
}


//-----------------------------------------------------------------------------
// AnimateStanding
//
simulated function AnimateStanding(
	bool bNoBlend )
{
	local float blendTime;
	local name	anim;

	if ( bNoBlend )
	{
		blendTime = 0.0;
	}
	else
	{
		blendTime = 0.2;
	}

	if ( mbCaptured )
	{
		anim = 'Stand_BreathCuffed';
	}
	else if ( mbThreatened )
	{
		anim = 'Stand_CaptiveBreath';
	}
	else if ( mbTakingBeating )
	{
		anim = 'Stand_Breath';
	}
	else
	{
		anim = mStandIdleAnims[Rand( mStandIdleAnims.Length )];
	}

	if ( anim != 'None' )
	{
		PlayAnim( anim, RandRange ( 0.9, 1.4 ), 0.2 );
	}
}


//-----------------------------------------------------------------------------
// AnimateCrouching
//
simulated function AnimateCrouching(
	bool bNoBlend )
{
	local float blendTime;
	local name anim;

	if ( bNoBlend )
	{
		blendTime = 0.0;
	}
	else
	{
		blendTime = 0.2;
	}

	if ( mbCaptured )
	{
		anim = 'Kneel_BreathCuffed';
	}
	else if ( mbCowering )
	{
		if ( mbThreatened || mbTakingBeating )
		{
			anim = 'Kneel_Cower_Captive';
		}
		else
		{
			anim = 'Kneel_Cower';
		}
	}
	else
	{
		if ( mbWettingSelf )
		{
			// TODO: Play this on action channel - split body anims have matching
			// anim duration on upper/lower halves.
			anim = 'Kneel_Sob';
		}
		else if ( mbThreatened || mbTakingBeating )
		{
			anim = 'Kneel_CaptiveBreath';
		}
		else
		{
			anim = 'Kneel_Breath';
		}
	}

	PlaySplitBodyAnim( anim, 'Kneel_Breath', RandRange( 0.9, 1.15 ), 0.2 );
}


//-----------------------------------------------------------------------------
// AnimateProne
//
simulated function AnimateProne(
	bool bNoBlend )
{
	local float blendTime;

	if ( bNoBlend )
	{
		blendTime = 0.0;
	}
	else
	{
		blendTime = 0.2;
	}

	if ( mbCaptured || mbCuffingStarted )
	{
		PlayAnim( 'Prone_CaptiveBreathCuffed', RandRange( 0.9, 1.2 ), 0.2 );	
	}
	else
	{
		PlayAnim( 'Prone_CaptiveBreath', RandRange( 0.9, 1.2 ), 0.2 );
	}
}


//-----------------------------------------------------------------------------
// AnimateWalking
//
simulated function AnimateWalking()
{
	WalkingPct = Default.WalkingPct;

	if ( mbCaptured )
	{
		SetMovementAnims(
			'Walk_FCaptive',
			'Walk_BCaptive',
			'Walk_LCaptive',
			'Walk_RCaptive' );
	}
	else
	{
		SetMovementAnims(
			'Walk_F',
			'Walk_B',
			'Walk_L',
			'Walk_R' );
	}

	SetupTurnAnims();
}


//-----------------------------------------------------------------------------
// AnimateRunning
//
simulated function AnimateRunning()
{
	if ( mbCaptured )
	{
		SetMovementAnims(
			'Run_F_Captive',
			'Run_B_Captive',
			'Run_L_Captive',
			'Run_R_Captive' );
	}
	else
	{
		SetMovementAnims(
			'Run_F',
			'Run_B',
			'Run_L',
			'Run_R' );
	}

	SetupTurnAnims();
}


//-----------------------------------------------------------------------------
// AnimateCharging
//
simulated function AnimateCharging()
{
	Warn( "SASPawn.AnimateCharging called - hostages cannot charge." );
}


//-----------------------------------------------------------------------------
// SetupTurnAnims
//
simulated function SetupTurnAnims()
{
	switch ( meStance )
	{
	case STANCE_Standing:
		if ( mbCaptured )
		{
			TurnLeftAnim	= 'Stand_RotIncCCWCuffed';
			TurnRightAnim	= 'Stand_RotIncCWCuffed';
		}
		else
		{
			TurnLeftAnim	= 'Stand_RotIncCCW';
			TurnRightAnim	= 'Stand_RotIncCW';
		}
		break;

	default:
		TurnLeftAnim = '';
		TurnRightAnim = '';
		break;
	}
}

//-----------------------------------------------------------------------------
// AnimateStandToCrouch
//
simulated function AnimateStandToCrouch(
	optional float	aRate )
{
	local name	anim;
	local float randScale;

	if ( aRate <= 0.0 )
	{
		aRate = 1.0;
	}

	randScale = 1.1 - (FRand() * 0.2);
	aRate = aRate * randScale;

	if ( mbCaptured )
	{
		anim = 'Stand_ToKneelCuffed';
	}
	else if ( mbThreatened )
	{
		anim = 'Stand_ToKneelCaptive';
	}
	
	else
	{
		anim = 'Stand_ToKneel';
	}

	PlayActionAnim( anim, aRate, 0.15, false );
}


//-----------------------------------------------------------------------------
// AnimateCrouchToStand
//
simulated function AnimateCrouchToStand()
{
	local name anim;

	if ( mbCaptured )
	{
		anim = 'Kneel_ToStandCuffed';
	}
	else
	{
		anim = 'Kneel_ToStand';
	}

	PlayActionAnim( anim, RandRange( 0.9, 1.2 ), 0.15, false );
}


//-----------------------------------------------------------------------------
// AnimateStandToProne
//
simulated function AnimateStandToProne(
	optional float aRate )
{
	local name	anim;
	local float	randScale;

	if ( aRate == 0.0 )
	{
		aRate = 1.0;
	}

	randScale = 1.1 - (FRand() * 0.2);
	aRate = aRate * randScale;

	if ( mbCaptured )
	{
		anim = 'Stand_ToProneCaptive';
	}
	else
	{
		anim = 'Stand_ToProne';
	}

	PlayActionAnim( anim, aRate, 0.15, false );
}


//-----------------------------------------------------------------------------
// AnimateProneToStand
//
simulated function AnimateProneToStand()
{
	PlayActionAnim( 'Prone_ToStand', RandRange( 0.9, 1.2 ), 0.15, false );
}


//-----------------------------------------------------------------------------
// AnimateCrouchToProne
//
simulated function AnimateCrouchToProne(
	optional float	aRate )
{
	local float	randScale;

	if ( aRate == 0.0 )
	{
		aRate = 1.0;
	}

	randScale = 1.1 - (FRand() * 0.2);
	aRate = aRate * randScale;

	PlayActionAnim( 'Kneel_ToProne', aRate, 0.15, false );
}


//-----------------------------------------------------------------------------
// GetStanceTransitionAnimName
//
// Returns the name of the transition animation name to move
// between 2 specified stances.
simulated function name GetStanceTransitionAnimName(
	ESASStance	aeFromStance,
	ESASStance	aeToStance )
{
	if ( aeFromStance == aeToStance )
	{
		return 'None';
	}

	switch ( aeFromStance )
	{
	case STANCE_Standing:
		switch ( aeToStance )
		{
		case STANCE_Crouched:	// Stand to crouch.
			if ( mbCaptured )
			{
				return 'Stand_toKneelCuffed';
			}
			else if ( mbThreatened )
			{
				return 'Stand_toKneelCaptive';
			}
			else
			{
				return 'Stand_toKneel';
			}
			break;

		case STANCE_Prone:		// Stand to prone.
			if ( mbCaptured )
			{
				return 'Stand_toProneCaptive';
			}
			else
			{
				return 'Stand_toProne';
			}
			break;
		}
		break;

	case STANCE_Crouched:		// Crouch to stand.
		switch ( aeToStance )
		{
		case STANCE_Standing:
			if ( mbCaptured )
			{
				return 'Kneel_toStandCuffed';
			}
			else
			{
				return 'Kneel_toStand';
			}
			break;

		case STANCE_Prone:		// Crouch to prone.
			return 'Kneel_toProne';
		}
		break;

	case STANCE_Prone:
		switch ( aeToStance )	
		{
		case STANCE_Standing:	// Prone to standing.
			if ( mbCaptured )
			{
				return 'ProneCuffed_toStand';
			}
			else
			{
				return 'Prone_ToStand';
			}
		}
		break;
	}

	return 'None';
}


//-----------------------------------------------------------------------------
// AnimateToStunned
//
simulated function AnimateToStunned()
{
	PlayActionAnim( 'Stand_toDazed', RandRange( 0.85, 1.15 ), 0.15, false, mbHeadlessChicken );
}


//-----------------------------------------------------------------------------
// AnimateFromStunned
//
simulated function AnimateFromStunned()
{
	PlayActionAnim( 'Dazed_toStand', RandRange( 0.85, 1.15 ), 0.15, false, mbHeadlessChicken );
}


//-----------------------------------------------------------------------------
// AnimateStunned
//
simulated function AnimateStunned()
{
	PlayActionAnim( 'Stand_Dazed', RandRange( 0.9, 1.1 ), 0.25, true, mbHeadlessChicken );
}


//-----------------------------------------------------------------------------
// ChooseGassedAnim
//
// Select a random gassed anim.
simulated function name ChooseGassedAnim()
{
	local name	anim;
	local float	randThreshold,
				frame,
				rate;

	GetAnimParams( ANIMCHANNEL_Action, anim, frame, rate );
	
	// More likely to play gassed coughing anim if already in that anim.
	if ( (anim == 'Stand_Gassed') || (anim == 'Stand_GassedCuffed' ))
	{
		randThreshold = 0.5;
	}
	else
	{
		randThreshold = 0.35;
	}
	
	if ( FRand() < randThreshold )
	{
		if ( mbCaptured )
		{
			anim = 'Stand_GassedCuffed';
		}
		else
		{
			anim = 'Stand_Gassed';
		}
	}
	else
	{
		if ( mbCaptured )
		{
			anim = 'Stand_GassedCuffedStill';
		}
		else
		{
			anim = 'Stand_GassedStill';
		}
	}

	return anim;
}


//-----------------------------------------------------------------------------
// AnimateToGassed
//
simulated function AnimateToGassed()
{
	local name	anim;

	if ( mbCaptured )
	{
		anim = 'Stand_toGassedCuffed';
	}
	else
	{
		anim = 'Stand_toGassed';
	}

	PlayActionAnim( anim, RandRange( 0.85, 1.15 ), 0.2, false, mbHeadlessChicken );
}


//-----------------------------------------------------------------------------
// AnimateFromGassed
//
simulated function AnimateFromGassed()
{
	Warn( "AnimateFromGassed - hostages do not have 'from gassed' transition anim." );
}


//-----------------------------------------------------------------------------
// AnimateIncapacitated
//
//::simulated function AnimateIncapacitated(
//::	bool abInstant )
//::{
//::	Warn( "AnimateIncapacitated - hostages do not have incapacitated animations." );
//::}


//-----------------------------------------------------------------------------
// PlayDiveToGround
//
simulated function PlayDiveToGround()
{
	switch ( meStance )
	{
	case STANCE_Standing:
		AnimateStandToProne( 3.0 );
		break;

	case STANCE_Crouched:
		AnimateCrouchToProne( 3.0 );
		break;
	}
}


//-----------------------------------------------------------------------------
// PlayFlinch
//
simulated function bool PlayFlinch()
{
	switch ( meStance )
	{
	case STANCE_Standing:
		return AnimateFlinchStanding();

	case STANCE_Crouched:
		return AnimateFlinchKneeling();
	}

	return false;
}


//-----------------------------------------------------------------------------
// AnimateFlinchStanding
//
simulated function bool AnimateFlinchStanding()
{
	local name	anim;
	local float	rate;

	if ( mbCaptured )
	{
		anim = 'Stand_FlinchCuffed';
	}
	else if ( mbThreatened || mbTakingBeating )
	{
		anim = 'Stand_FlinchCaptive';
	}
	else
	{
		anim = mStandFlinchAnims[Rand ( mStandFlinchAnims.Length )];
	}

	if ( anim != 'None' )
	{
		rate = RandRange( 0.9, 1.4 );

		// Playing anim on action channel on top half of body and playing 
		// full body on channel 0 - this will mean only top half of anim plays if 
		// hostage is moving but will see anim on legs when no movement anims are playing.
		PlayActionAnim( anim, rate, 0.2, false, true );
		PlayAnim( anim, rate, 0.2 );		
		return true;
	}

	return false;
}


//-----------------------------------------------------------------------------
// AnimateFlinchKneeling
//
simulated function bool AnimateFlinchKneeling()
{
	local name	upperBodyAnim;

	if ( mbCaptured )
	{
		upperBodyAnim = 'Stand_FlinchCuffed';
	}
	else if ( mbThreatened || mbTakingBeating )
	{
		upperBodyAnim = 'Stand_FlinchCaptive';
	}
	else
	{
		upperBodyAnim = mStandFlinchAnims[Rand ( mStandFlinchAnims.Length )];
	}

	if ( upperBodyAnim != 'None' )
	{
		PlayActionAnim( upperBodyAnim, RandRange ( 0.9, 1.4 ), 0.2, false, true );
		return true;
	}

	return false;
}


//------------------------------------------------------------------------------
// AnimateStandToCaptive
//
simulated function AnimateStandToCaptive()
{
	PlayAnim ( 'StandBreath_toStandCaptive', RandRange( 0.9, 1.4 ), 0.2 );
}


//------------------------------------------------------------------------------
// PlayPanic
//
simulated function PlayPanic( bool abPlayLocallyOnly )
{
	PlayActionAnim( 'Stand_Flinch04', RandRange( 0.9, 1.2 ), 0.2, false, true, false, abPlayLocallyOnly ); 
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

	if ( mbExplosive || mbUnresponsive || mbThreatened || mbTakingBeating )
	{
		return false;
	}

	return true;
}


//------------------------------------------------------------------------------
// GetPunchedAnim
//
// Select appropriate animation for standing / kneeling
simulated function name GetPunchedAnim()
{
	switch ( meStance )
	{
	case STANCE_Standing:
		return 'StandJabbed_toProne';

	case STANCE_Crouched:
		return 'KneelJabbed_toProne';
	}

	return 'None';
} 


//------------------------------------------------------------------------------
// PlayPunchedAnim
//
simulated function bool PlayPunchedAnim()
{
	local name anim;

	anim = GetPunchedAnim();
	if ( anim != 'None' )
	{
		PlayActionAnim( anim, 1.0, 0.0, true );
		
		// Standing anims move far from centre - use root motion.
		// GP: Not with new anims.
		//if ( meStance == STANCE_Standing )
		//{
		//	StartRootMotion( true );
		//}
		return true;
	}

	return false;
}


//------------------------------------------------------------------------------
// EndPunchedAnim
//
simulated function EndPunchedAnim()
{
	if ( Physics == PHYS_RootMotion )
	{
		SetPhysics( PHYS_Walking );
		EndPlayRootMotionAnim( 'Stand_Breath' );
	}

	ChangeAnimation();
}


//------------------------------------------------------------------------------
// GetBeatenReactionAnim
//
// Return the reaction animation name for a named terrorist beating anim.
simulated function name GetBeatenReactionAnim( 
	name	aTerroristHitAnim )
{
	switch ( aTerroristHitAnim )
	{
	case 'Stand_Rifebutt_AK47':
		return 'Stand_Rifle_Reaction01';

	case 'Stand_Rifebutt_02_AK47':
		return 'Kneel_Rifle_Reaction01';

	case 'Stand_Rifebutt_03_AK47':
		return 'Stand_Rifle_Reaction02';
	
	case 'Stand_Pistolwhip_01_AK47':
		return 'Stand_Pistol_Reaction01';
	
	case 'Stand_Pistolwhip_02_AK47':
		return 'Kneel_Pistol_Reaction02';

	case 'Stand_Pistolwhip_03_AK47':
		return 'Kneel_Pistol_Reaction01';

	case 'Stand_Punch_01_AK47':
	case 'Stand_Punch_02_AK47':
		return 'Stand_Jab_Reaction01';

	case 'Stand_Punch_03_AK47':
		if ( FRand() < 0.5 )
		{
			return 'Kneel_Jab_Reaction01max';
		}
		else
		{
			return 'Kneel_Jab_Reaction02max';
		}
	}

	Warn( "Unrecognised terrorist beating anim <"$aTerroristHitAnim$"> passed to GetBeatenReactionAnim." );
	return 'None';
}


//------------------------------------------------------------------------------
// StartThreatenedByTerrorist
//
function StartThreatenedByTerrorist(
	SASTerrorist aTerrorist )
{
	mbThreatened = true;
	mGuardingTerrorist = aTerrorist;
	if ( Controller != None )
	{
		SASHostageController( Controller ).StartThreatened();
	}
}


//------------------------------------------------------------------------------
// StartBeatenByTerrorist
//
function StartTakeBeatingFromTerrorist(
	SASTerrorist aTerrorist )
{
	mbTakingBeating = true;
	mGuardingTerrorist = aTerrorist;
	if ( Controller != None )
	{
		SASHostageController( Controller ).StartTakeBeating();
	}
}


//------------------------------------------------------------------------------
// AnimNotifyBeating
//
simulated event AnimNotifyBeating()
{
	PlaySpeech( SPEECH_HostageBeaten );
}


//------------------------------------------------------------------------------
// EndGuardedByTerrorist
//
function EndGuardedByTerrorist()
{
	mbThreatened = false;
	mbTakingBeating = false;

	if ( Controller != None )
	{
		SASHostageController( Controller ).EndGuardedByTerrorist();
	}
	
	mGuardingTerrorist = None;
}


//------------------------------------------------------------------------------
// Died
//
function Died(
	Controller			aKiller, 
	class<DamageType>	aDamageType, 
	Vector				aHitLocation )
{
	local SASCoverPoint CP;

	// TODO: Move this to controller PawnDied fn.
	CP = SASHostageController(Controller).mCoverPoint;
	if ( CP != None )
	{
		CP.Relinquish( self );
	}

	Super.Died( aKiller, aDamageType, aHitLocation );
}


//------------------------------------------------------------------------------
// BulletHitNearby
//
// Event called when a bullet hits close to the pawn.
function BulletHitNearby( 
	SASAmmo aBullet, 
	Vector	aHitLocation )
{
	//TODO: Make the bullet create the noise.
	SASHostageController( Controller ).HearNoise ( 1.0, aBullet, NOISE_Ricochet, aHitLocation );
}


//------------------------------------------------------------------------------
// Touch
//
event Touch( 
	Actor	aTouched )
{
	local SASEvacuationVolume	EV;

	// Deal with touching evac volumes.
	EV = SASEvacuationVolume( aTouched );
	if ( EV != None )
	{
		if ( mbCaptured && (Controller != None) && (Controller.mType == CONTROLLER_AIHostage) )
		{
			SASHostageController( Controller ).EnterredEvacuationVolume( EV );
		}
	}
}


//-----------------------------------------------------------------------------
// Default properties
//

// Decompiled with UE Explorer.
defaultproperties
{
    mReactionTime=(Min=0.0200000,Max=0.1400000)
    mSlowReactionTime=(Min=0.1500000,Max=1.0000000)
    mPanicChance=0.3400000
    mWetSelfChance=0.3400000
    mStockholmChance=0.3300000
    mPanicTimeout=5.0000000
    mGuardedSpeechTime=(Min=5.0000000,Max=12.0000000)
    mThreatenedStockholmChance=0.3000000
    mThreatenedPleadForHelpChance=0.3000000
    mWiredHostageIdentChance=0.5000000
    mTerroristIdentChance=0.7000000
    mPanicSpeechInterval=(Min=6.0000000,Max=8.0000000)
    mExplosiveDisarmTime=5.0000000
    mExplosiveDisarmRadius=90.0000000
    mExplosiveWarnMaxDist=500.0000000
    mGunTapedToHandDeactivationRange=200.0000000
    mGunTapedToHandSpeechInterval=(Min=4.0000000,Max=7.0000000)
    mNearbyGunfireDist=(Min=120.0000000,Max=2500.0000000)
    mNearbyGunfireFlinchChance=1.0000000
    mDistantGunfireFlinchChance=0.5000000
    mGunfireFlinchMaxDist=8000.0000000
    mGunfireTakeCoverMaxDist=2500.0000000
    mMinTimeBetweenFlinches=(Min=0.2000000,Max=0.6000000)
    mFlinchMinTimeBetweenGunfire=(Min=2.0000000,Max=3.0000000)
    mGunfireCounterDecayRate=0.7000000
    mSustainedGunfireToTakeCover=(Min=5.0000000,Max=8.0000000)
    mTimeInCover=(Min=5.0000000,Max=10.0000000)
    mStandIdleAnims[0]="Stand_Breath"
    mStandIdleAnims[1]="Stand_Idle01"
    mStandFlinchAnims[0]="Stand_Flinch"
    mStandFlinchAnims[1]="Stand_Flinch01"
    mStandFlinchAnims[2]="Stand_Flinch02"
    mStandFlinchAnims[3]="Stand_Flinch03"
    mSide=1
    mbCanMoveCrouched=false
    mGasGrenadeIgnoreChance=0.3000000
    mFlashBehindMeMod=0.7000000
    mStunDisorientThreshold=0.2000000
    mStunDisorientThresholdAlert=0.2000000
    mStunDisorientTime=(Min=2.0000000,Max=4.0000000)
    mDirectionalDeathAnimsStanding=(Anim=Anim[0]="Stand_Death")
}