//=============================================================================
// SASFighter.uc
//
// Abstract base class of soldiers and terrorists
//=============================================================================

class SASFighter extends SASPawn
	abstract
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

//-----------------------------------------------------------------------------
// Constants

const SURRENDERREACTION_None				= 0;
const SURRENDERREACTION_Stationary			= 1;
const SURRENDERREACTION_StaggerBackSmall	= 2;
const SURRENDERREACTION_StaggerBackLarge	= 3;

const AIMANIM_UP_MP5		= 'Stand_Delta1_Up_MP5';
const AIMANIM_UP_AK47		= 'Stand_Delta1_Up_AK47';
const AIMANIM_UP_SIG		= 'Stand_Delta1_Up_Sig';
const AIMANIM_UP_SHOTGUN	= 'Stand_Delta1_Up_Maruzen';
const AIMANIM_DOWN_MP5		= 'Stand_Delta1_Down_MP5';
const AIMANIM_DOWN_AK47		= 'Stand_Delta1_Down_AK47';
const AIMANIM_DOWN_SIG		= 'Stand_Delta1_Down_Sig';
const AIMANIM_DOWN_SHOTGUN	= 'Stand_Delta1_Down_Maruzen';

const ANIM_SelectPrimaryWpn		= 'Stand_Unsling_MP5';
const ANIM_SelectSecondaryWpn	= 'Stand_DrawSig';
const ANIM_SelectGrenade		= 'Stand_PickWeapon_Grenade';
const ANIM_DeselectPrimaryWpn	= 'Stand_Sling_MP5';
const ANIM_DeselectSecondaryWpn	= 'Stand_HolsterSig';
const ANIM_DeselectGrenade		= 'Stand_DropWeapon_Grenade';
const ANIM_GrenadePullPin		= 'Stand_PullPin_Grenade';
const ANIM_GrenadeThrowOverhead	= 'Stand_Throw_Grenade2';
const ANIM_GrenadeThrowPunch	= 'Stand_Throw_Grenade';
const ANIM_Punch				= 'Stand_Attack_Punch';
const ANIM_ReloadShotgunStart	= 'Stand_Reload_Maruzen_START';
const ANIM_ReloadShotgunMid		= 'Stand_Reload_Maruzen_MIDDLE';
const ANIM_ReloadShotgunEnd		= 'Stand_Reload_Maruzen_END';

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Member Vars
var EWpnHoldingPose		meWpnPose;

// Firing burst duration info.
var() Range				mBurstDurationLongPrimary;
var() Range				mBurstDurationLongSecondary;
var() Range				mBurstDurationShortPrimary;
var() Range				mBurstDurationShortSecondary;
var() Range				mBurstIntervalPrimary;
var() Range				mBurstIntervalSecondary;
var() float				mBurstDurationShortProbability;

// Surrendering vars - only used by terrorists but need to be here for shared
// anim system purposes.
var bool				mbSurrendered;
var bool				mbPlayedSurrendering;

// Hit anims for when surrendered.
var array<name>			mHitTorsoSurrenderedAnims;
var array<name>			mHitLeftArmSurrenderedAnims;
var array<name>			mHitRightArmSurrenderedAnims;

var array<Sound>		mChangeWeaponSounds;
var float				mChangeWeaponSoundVolume; 
var float				mChangeWeaponSoundRadius; 

replication 
{
	// Variables the server sends to clients.
	reliable if ( Role == ROLE_Authority )
		meWpnPose, 
		mbSurrendered, 
		mbPlayedSurrendering;

	// Functions the client calls on the server.
	reliable if ( Role < ROLE_Authority )
		ServerPlayPunchAnim,
		ServerPlayDeselectWeapon;
}

//-----------------------------------------------------------------------------
// Native Functions

native final function GetWeaponHandlingAnimInfo(
	byte				aWpnAnimType,
	SASWeaponAttachment	aWpnAttachment,
	out name			aAnimName,
	out float			aAnimBlendTime,
	out float			aAnimRate );

native final function float Get3rdPersonWeaponAnimRate( 
	name	a3rdPersonAnim,
	float	aBlendTime );

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// GetWeaponSpecificAnimName
//
// Return the name of an anim sequence for the current weapon. e.g. for sequence
// 'Stand' the function would return 'Stand_MP5' when holding an MP5. 
native simulated final function name GetWeaponSpecificAnimName(
	string		aSequence );		// Anim sequence prefix - e.g. 'Stand'

/*
event CheckConcatenatedAnim(
	name aAnim )
{
	// **************************************************
	// Please add new anim names in alphabetical order!!!
	// **************************************************
	if (	aAnim == 'Charge_F_AK47' ||
			aAnim == 'Charge_F_Maruzen' ||
			aAnim == 'Charge_F_MP5' ||
			aAnim == 'Charge_F_Sig' ||
			aAnim == 'Kneel_Fire1_AK47' ||
			aAnim == 'Kneel_Fire1_Maruzen' ||
			aAnim == 'Kneel_Fire1_MP5' ||
			aAnim == 'Kneel_Fire1_Sig' ||
			aAnim == 'Kneel_Ported_AK47' ||
			aAnim == 'Kneel_Ported_Maruzen' ||
			aAnim == 'Kneel_Ported_MP5' ||
			aAnim == 'Kneel_Ported_Sig' ||
			aAnim == 'Kneel_Ported2_AK47' ||
			aAnim == 'Kneel_Ported2_Maruzen' ||
			aAnim == 'Kneel_Ported2_MP5' ||
			aAnim == 'Kneel_Ported2_Sig' ||
			aAnim == 'Kneel_RotIncCCW_AK47' ||
			aAnim == 'Kneel_RotIncCCW_Maruzen' ||
			aAnim == 'Kneel_RotIncCCW_MP5' ||
			aAnim == 'Kneel_RotIncCCW_Sig' ||
			aAnim == 'Kneel_RotIncCW_AK47' ||
			aAnim == 'Kneel_RotIncCW_Maruzen' ||
			aAnim == 'Kneel_RotIncCW_MP5' ||
			aAnim == 'Kneel_RotIncCW_Sig' ||
			aAnim == 'Kneel_Sighted_AK47' ||
			aAnim == 'Kneel_Sighted_Maruzen' ||
			aAnim == 'Kneel_Sighted_MP5' ||
			aAnim == 'Kneel_Sighted_Sig' ||
			aAnim == 'Kneel_toStand_AK47' ||
			aAnim == 'Kneel_toStand_Maruzen' ||
			aAnim == 'Kneel_toStand_MP5' ||
			aAnim == 'Kneel_toStand_Sig' ||
			aAnim == 'Run_B_AK47' ||
			aAnim == 'Run_B_Maruzen' ||
			aAnim == 'Run_B_MP5' ||
			aAnim == 'Run_B_Sig' ||
			aAnim == 'Run_F_AK47' ||
			aAnim == 'Run_F_Maruzen' ||
			aAnim == 'Run_F_MP5' ||
			aAnim == 'Run_F_Sig' ||
			aAnim == 'Run_L_AK47' ||
			aAnim == 'Run_L_Maruzen' ||
			aAnim == 'Run_L_MP5' ||
			aAnim == 'Run_L_Sig' ||
			aAnim == 'Run_R_AK47' ||
			aAnim == 'Run_R_Maruzen' ||
			aAnim == 'Run_R_MP5' ||
			aAnim == 'Run_R_Sig' ||
			aAnim == 'Stand_Fire1_AK47' ||
			aAnim == 'Stand_Fire1_Maruzen' ||
			aAnim == 'Stand_Fire1_MP5' ||
			aAnim == 'Stand_Fire1_Sig' ||
			aAnim == 'Stand_Ported_AK47' ||
			aAnim == 'Stand_Ported_Maruzen' ||
			aAnim == 'Stand_Ported_MP5' ||
			aAnim == 'Stand_Ported_Sig' ||
			aAnim == 'Stand_Ported2_AK47' ||
			aAnim == 'Stand_Ported2_Maruzen' ||
			aAnim == 'Stand_Ported2_MP5' ||
			aAnim == 'Stand_Ported2_Sig' ||
			aAnim == 'Stand_Ported3_MP5' ||
			aAnim == 'Stand_Ported3_Sig' ||
			aAnim == 'Stand_Reload_AK47' ||
			aAnim == 'Stand_Reload_Maruzen' ||
			aAnim == 'Stand_Reload_MP5' ||
			aAnim == 'Stand_Reload_Sig' ||
			aAnim == 'Stand_RotIncCCW_AK47' ||
			aAnim == 'Stand_RotIncCCW_Maruzen' ||
			aAnim == 'Stand_RotIncCCW_MP5' ||
			aAnim == 'Stand_RotIncCCW_Sig' ||
			aAnim == 'Stand_RotIncCW_AK47' ||
			aAnim == 'Stand_RotIncCW_Maruzen' ||
			aAnim == 'Stand_RotIncCW_MP5' ||
			aAnim == 'Stand_RotIncCW_Sig' ||
			aAnim == 'Stand_Rot25CCW_MP5' ||
			aAnim == 'Stand_Rot25CW_MP5' ||
			aAnim == 'Stand_Rot90CCW_MP5' ||
			aAnim == 'Stand_Rot90CW_MP5' ||
			aAnim == 'Stand_Rot180CCW_MP5' ||
			aAnim == 'Stand_Rot180CW_MP5' ||
			aAnim == 'Stand_Rot90CCW_Sig' ||
			aAnim == 'Stand_Rot90CW_Sig' ||
			aAnim == 'Stand_Rot180CCW_Sig' ||
			aAnim == 'Stand_Rot180CW_Sig' ||
			aAnim == 'Stand_Sighted_AK47' ||
			aAnim == 'Stand_Sighted_Maruzen' ||
			aAnim == 'Stand_Sighted_MP5' ||
			aAnim == 'Stand_Sighted_Sig' ||
			aAnim == 'Stand_toKneel_AK47' ||
			aAnim == 'Stand_toKneel_Maruzen' ||
			aAnim == 'Stand_toKneel_MP5' ||
			aAnim == 'Stand_toKneel_Sig' ||
			aAnim == 'Stand_toProne_MP5' ||
			aAnim == 'Walk2_B_AK47' ||
			aAnim == 'Walk2_B_Maruzen' ||
			aAnim == 'Walk2_B_MP5' ||
			aAnim == 'Walk2_B_Sig' ||
			aAnim == 'Walk2_F_AK47' ||
			aAnim == 'Walk2_F_Maruzen' ||
			aAnim == 'Walk2_F_MP5' ||
			aAnim == 'Walk2_F_Sig' ||
			aAnim == 'Walk2_L_AK47' ||
			aAnim == 'Walk2_L_Maruzen' ||
			aAnim == 'Walk2_L_MP5' ||
			aAnim == 'Walk2_L_Sig' ||
			aAnim == 'Walk2_R_AK47' ||
			aAnim == 'Walk2_R_Maruzen' ||
			aAnim == 'Walk2_R_MP5' ||
			aAnim == 'Walk2_R_Sig' ||
			aAnim == 'Walk4_B_MP5' ||
			aAnim == 'Walk4_F_MP5' ||
			aAnim == 'Walk4_L_MP5' ||
			aAnim == 'Walk4_R_MP5' ||
			aAnim == 'Walk_B_AK47' ||
			aAnim == 'Walk_B_Maruzen' ||
			aAnim == 'Walk_B_MP5' ||
			aAnim == 'Walk_B_Sig' ||
			aAnim == 'Walk_F_AK47' ||
			aAnim == 'Walk_F_Maruzen' ||
			aAnim == 'Walk_F_MP5' ||
			aAnim == 'Walk_F_Sig' ||
			aAnim == 'Walk_L_AK47' ||
			aAnim == 'Walk_L_Maruzen' ||
			aAnim == 'Walk_L_MP5' ||
			aAnim == 'Walk_L_Sig' ||
			aAnim == 'Walk_R_AK47' ||
			aAnim == 'Walk_R_Maruzen' ||
			aAnim == 'Walk_R_MP5' ||
			aAnim == 'Walk_R_Sig' )
	{
		return;
	}

	LogHuman( "Anim <"$aAnim$"> not in hardcoded list of weapon specific anim names - coder needs to add it." );
}
*/


///////////////////////////////////////////////////////////////////////////////
// PlayWeaponSpecificAnim
//
// Plays the weapon spcific animation for a specified animation sequence. 
// e.g. For sequence 'Stand' will play anim 'Stand_mp5' when current weapon
// is an mp5.
// Note: Only plays weapon specific animation on the top half of the body - 
// always uses the mp5 version of the animation on the legs.
simulated function PlayWeaponSpecificAnim(
	string			aSequence,
	optional float	aRate,
	optional float	aBlendTime,
	optional int	aChannel,
	optional bool	abLoop )
{
	local name		upperBodyAnim,
					lowerBodyAnim;

	// Always use MP5 anims for the legs.
	lowerBodyAnim = name( aSequence$"_MP5" );
	
	if ( mThirdPersonWeapon == None )
	{
		upperBodyAnim = lowerBodyAnim;
	}
	else
	{
		upperBodyAnim = GetWeaponSpecificAnimName( aSequence );
	}
	
	if ( upperBodyAnim != 'None' )
	{
		if ( abLoop )
		{
			LoopSplitBodyAnimIfNeeded( upperBodyAnim, lowerBodyAnim, aRate, aBlendTime, aChannel );
		}
		else
		{
			PlaySplitBodyAnim( upperBodyAnim, lowerBodyAnim, aRate, aBlendTime, aChannel );
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// GetWeaponSpecificMovementAnims
//
// Fills in array 'aMoveAnims' with the movement animations specific to the
// move type (defined by the aSequence paramter) and the current weapon held.
simulated function GetWeaponSpecificMovementAnims(
	string		aSequence,
	out name	aMoveAnims[4] )
{
	switch ( mWeaponAnimSet )
	{
	case WPN3P_MP5:
		aMoveAnims[0] = name( aSequence$"_F_MP5" );
		aMoveAnims[1] = name( aSequence$"_B_MP5" );
		aMoveAnims[2] = name( aSequence$"_L_MP5" );
		aMoveAnims[3] = name( aSequence$"_R_MP5" );
		break;

	case WPN3P_AK47:
		aMoveAnims[0] = name( aSequence$"_F_AK47" );
		aMoveAnims[1] = name( aSequence$"_B_AK47" );
		aMoveAnims[2] = name( aSequence$"_L_AK47" );
		aMoveAnims[3] = name( aSequence$"_R_AK47" );
		break;

	case WPN3P_Sig:
		aMoveAnims[0] = name( aSequence$"_F_Sig" );
		aMoveAnims[1] = name( aSequence$"_B_Sig" );
		aMoveAnims[2] = name( aSequence$"_L_Sig" );
		aMoveAnims[3] = name( aSequence$"_R_Sig" ); 
		break;

	case WPN3P_Shotgun:
		aMoveAnims[0] = name( aSequence$"_F_Maruzen" );
		aMoveAnims[1] = name( aSequence$"_B_Maruzen" );
		aMoveAnims[2] = name( aSequence$"_L_Maruzen" );
		aMoveAnims[3] = name( aSequence$"_R_Maruzen" ); 
		break;

	case WPN3P_Grenade:
	case WPN3P_Knife:
		//Warn( "GetWeaponSpecificMovementAnims called when holding grenade/knife weapon " $Weapon$ ". Playing MP5 set.");
		aMoveAnims[0] = name( aSequence$"_F_MP5" );
		aMoveAnims[1] = name( aSequence$"_B_MP5" );
		aMoveAnims[2] = name( aSequence$"_L_MP5" );
		aMoveAnims[3] = name( aSequence$"_R_MP5" );
		break;

	default:
		//Warn( "GetWeaponSpecificMovementAnims called when holding unrecognised wpn type (" $Weapon$ "). Playing MP5 set.");
		aMoveAnims[0] = name( aSequence$"_F_MP5" );
		aMoveAnims[1] = name( aSequence$"_B_MP5" );
		aMoveAnims[2] = name( aSequence$"_L_MP5" );
		aMoveAnims[3] = name( aSequence$"_R_MP5" );
		break;
	}

	// Use default anims if requested ines aren't available.
	if ( aMoveAnims[0] == 'None' )
	{
		aMoveAnims[0] = name( aSequence$"_F_MP5" );
		aMoveAnims[1] = name( aSequence$"_B_MP5" );
		aMoveAnims[2] = name( aSequence$"_L_MP5" );
		aMoveAnims[3] = name( aSequence$"_R_MP5" );
	}
/*
	if ( aMoveAnims[0] != 'None' )
	{
		CheckConcatenatedAnim( aMoveAnims[0] );
	}
	if ( aMoveAnims[1] != 'None' )
	{
		CheckConcatenatedAnim( aMoveAnims[1] );
	}
	if ( aMoveAnims[2] != 'None' )
	{
		CheckConcatenatedAnim( aMoveAnims[2] );
	}
	if ( aMoveAnims[3] != 'None' )
	{
		CheckConcatenatedAnim( aMoveAnims[3] );
	}
*/
}

// JS shockingly, I'm combining some duplicated code
simulated function SetupTurnAnims()
{
	local String stand_or_kneel;
	
	switch ( meStance )
	{
	case STANCE_Standing:
		stand_or_kneel = "Stand";
		break;

	case STANCE_Crouched:
		stand_or_kneel = "Kneel";
		break;

	case STANCE_Prone:
		TurnLeftAnim = '';
		TurnRightAnim = '';
		LowerTurnLeftAnim = '';
		LowerTurnRightAnim = '';
		return;
	}
	
	// The upper body uses the weapon-specific stuff

	if ( mbSurrendered )
	{
		TurnLeftAnim = 'Stand_SurrenderBreath';
		TurnRightAnim = 'Stand_SurrenderBreath';
	}
	else if ( meWpnPose == WPNPOSE_PortedHigh )
	{
		TurnLeftAnim = GetWeaponSpecificAnimName( "Stand_Ported2" );
		TurnRightAnim = TurnLeftAnim;
	}
	else
	{
		TurnLeftAnim	= GetWeaponSpecificAnimName( stand_or_kneel$"_RotIncCCW" );
		TurnRightAnim	= GetWeaponSpecificAnimName( stand_or_kneel$"_RotIncCW" );
	}

	// The lower body always uses the MP5 anims
	LowerTurnLeftAnim	= name( stand_or_kneel$"_RotIncCCW_MP5" );
	LowerTurnRightAnim	= name( stand_or_kneel$"_RotIncCW_MP5" );
}


///////////////////////////////////////////////////////////////////////////////
// AnimateWalking
//
simulated function AnimateWalking()
{
	local name	upperBodyAnims[4];

	WalkingPct = Default.WalkingPct;
	
	SetupTurnAnims();

	if ( mDamageSpeedMod < 1.0 )
	{
		// Limping walk anims
		if ( mbSurrendered )
		{
			upperBodyAnims[0] = 'Stand_SurrenderBreath';
			upperBodyAnims[1] = 'Stand_SurrenderBreath';
			upperBodyAnims[2] = 'Stand_SurrenderBreath';
			upperBodyAnims[3] = 'Stand_SurrenderBreath';
		}
		else
		{
			GetWeaponSpecificMovementAnims( "Walk4", upperBodyAnims );
		}

		SetMovementAnims( 
			'Walk4_F_MP5',
			'Walk4_B_MP5',
			'Walk4_L_MP5',
			'Walk4_R_MP5',
			upperBodyAnims[0],
			upperBodyAnims[1],
			upperBodyAnims[2],
			upperBodyAnims[3] );
	}
	else
	{
		// Standard walk
		if ( mbSurrendered )
		{
			upperBodyAnims[0] = 'Stand_SurrenderBreath';
			upperBodyAnims[1] = 'Stand_SurrenderBreath';
			upperBodyAnims[2] = 'Stand_SurrenderBreath';
			upperBodyAnims[3] = 'Stand_SurrenderBreath';
		}
		else
		{
			GetWeaponSpecificMovementAnims( "Walk", upperBodyAnims );
		}

		SetMovementAnims(
			'Walk_F_MP5',
			'Walk_B_MP5',
			'Walk_L_MP5',
			'Walk_R_MP5',
			upperBodyAnims[0],
			upperBodyAnims[1],
			upperBodyAnims[2],
			upperBodyAnims[3] );
	}
}


///////////////////////////////////////////////////////////////////////////////
// AnimateCrouchWalking
//
simulated function AnimateCrouchWalking()
{
	local name	upperBodyAnims[4];

	SetupTurnAnims();

	GetWeaponSpecificMovementAnims( "Walk2", upperBodyAnims );

	SetMovementAnims(
		'Walk2_F_MP5',
		'Walk2_B_MP5',
		'Walk2_L_MP5',
		'Walk2_R_MP5',
		upperBodyAnims[0],
		upperBodyAnims[1],
		upperBodyAnims[2],
		upperBodyAnims[3] );
}


///////////////////////////////////////////////////////////////////////////////
// AnimateRunning
//
simulated function AnimateRunning()
{
	local name	upperBodyAnims[4];

	SetupTurnAnims();

	if ( mbSurrendered )
	{
		SetMovementAnims( 'Run_F', 'Run_B', 'Run_L', 'Run_R' );
	}
	else
	{
		UpdateWeaponPose();
		switch ( meWpnPose )
		{
			case WPNPOSE_PortedHigh:
				// When the weapon should be ported high need to make sure that this animation
				// plays on the upper half of the run anims.
				upperBodyAnims[0] = GetWeaponSpecificAnimName( "Stand_Ported2" );
				upperBodyAnims[1] = upperBodyAnims[0];
				upperBodyAnims[2] = upperBodyAnims[0];
				upperBodyAnims[3] = upperBodyAnims[0];
				break;

			default:
				GetWeaponSpecificMovementAnims( "Run", upperBodyAnims );
				break;
		}
		

		SetMovementAnims(
			'Run_F_MP5',
			'Run_B_MP5',
			'Run_L_MP5',
			'Run_R_MP5',
			upperBodyAnims[0],
			upperBodyAnims[1],
			upperBodyAnims[2],
			upperBodyAnims[3] );
	}
}


///////////////////////////////////////////////////////////////////////////////
// AnimateCharging
//
simulated function AnimateCharging()
{
	local name	upperBodyAnims[4];

	TurnLeftAnim	= GetWeaponSpecificAnimName( "Stand_RotIncCCW" );
	TurnRightAnim	= GetWeaponSpecificAnimName( "Stand_RotIncCW" );

	GetWeaponSpecificMovementAnims( "Run", upperBodyAnims );

	upperBodyAnims[0] = GetWeaponSpecificAnimName( "Charge_F" );
		
	SetMovementAnims(
		'Charge_F_MP5',
		'Run_B_MP5',
		'Run_L_MP5',
		'Run_R_MP5',
		upperBodyAnims[0],
		upperBodyAnims[1],
		upperBodyAnims[2],
		upperBodyAnims[3] );	
}


///////////////////////////////////////////////////////////////////////////////
// GetStanceTransitionAnimName
//
// Returns the name of the (weapon specific) transition animation name to move
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
		case STANCE_Crouched:

			// Stand to crouch.

			if ( mbSurrendered )
			{
				return 'Stand_toKneelCaptive';
			}
			else
			{
				return GetWeaponSpecificAnimName( "Stand_toKneel" );
			}
			break;

		case STANCE_Prone:

			// Stand to prone.
			
			if ( mbSurrendered )
			{
				return 'StandSurrender_toProne';
			}
			else
			{
				return GetWeaponSpecificAnimName( "Stand_toProne" );
			}
			break;
		}
		break;

	case STANCE_Crouched:
		switch ( aeToStance )
		{
		case STANCE_Standing:

			// Crouch to stand.

			if ( mbSurrendered )
			{
				return 'Kneel_toStandSurrender';
			}
			else
			{
				return GetWeaponSpecificAnimName( "Kneel_toStand" );
			}
			break;

		case STANCE_Prone:

			// Crouch to prone.

			// No weapon specifc anims available.
			return 'Kneel_toProne_MP5';
		}
		break;

	case STANCE_Prone:
		Warn( "GetStanceTransitionAnimName: No 'transition from prone' anims available for soldiers/terrorists." ); 
		break;
	}

	return 'None';
}


///////////////////////////////////////////////////////////////////////////////
// PlayFiring
//
// Called by weapon at start of firing.
simulated function PlayFiring(
	float		aRate,					// Animation playback rate
	name		aFiringMode )			// Weapon firing mode
{
	local float	blendTime;

	if ( bIgnorePlayFiring || mbSprayFiring )
	{
		return;
	}

	if ( (mFiringPose & FIRINGPOSE_Undisciplined) != 0x0 )
	{
		PlayUndisciplinedFiring( aRate, aFiringMode );
	}
	else if ( (mFiringPose & FIRINGPOSE_Spinout) != 0x0 )
	{
		PlaySpinoutFiring( aRate, aFiringMode );
	}
	else
	{
		// When firing pose changes we allow a bit of blend time to the new pose.
		if ( mFiringPoseChangeTime > Level.TimeSeconds - 0.3 )
		{
			blendTime = 0.3;
		}
		PlayNormalFiring( aRate, aFiringMode, blendTime );
	}
}


///////////////////////////////////////////////////////////////////////////////
// PlayNormalFiring
//
simulated function PlayNormalFiring(
	float	aRate,			// Animation playback rate
	name	aFiringMode,	// Weapon firing mode
	float	aBlendTime )
{
	local float					firingFrame,
								rate,
								aimAlpha;
	local name					fireAnim,
								aimAnim;
	local SASWeaponAttachment	wpn3rdPerson;;
	

	// Big hack for testing - find the third person weapon attached to this pawn.
	// TODO: Pass this in as a parameter.
	local int i;
	for ( i = 0; i < Attached.Length; i++ )
	{
		wpn3rdPerson = SASWeaponAttachment(Attached[i]);
		if ( wpn3rdPerson != None && !wpn3rdPerson.bHidden )
		{
			break;
		}
		wpn3rdPerson = None;
	}
	if ( wpn3rdPerson == None )
	{
		return;
	}

	switch ( wpn3rdPerson.mCategory )
	{
	case WPNCAT_Primary:
	case WPNCAT_Secondary:
	case WPNCAT_Special:
		if ( meStance == STANCE_Crouched )
		{
			fireAnim = GetWeaponSpecificAnimName( "Kneel_Fire1" );
		}
		else
		{
			fireAnim = GetWeaponSpecificAnimName( "Stand_Fire1" );
		}
		break;

	case WPNCAT_Grenade:
		fireAnim	= 'Stand_PullPin_Grenade';
		break;

	case WPNCAT_Knife:
		if ( Weapon != None && SASKnifeWeapon( Weapon ).mbUseSecondSlash )
		{
			fireAnim	= 'Stand_Attack2_Knife';
		}
		else
		{
			fireAnim	= 'Stand_Attack1_Knife';
		}
		break;
	}

	if ( mAimPitch != 0.0 )
	{
		aimAnim = GetFireWeaponAimingAnimName( mAimPitch );
		if ( aimAnim != 'None' )
		{
			aimAlpha = FMin( IAbs( mAimPitch ), MAX_AIM_PITCH ) / MAX_AIM_PITCH;
		}
	}

	if ( fireAnim != 'None' )
	{
		// If current animation on this channel is not  
		AnimBlendParams( ANIMCHANNEL_FIRING, 1.0, 0.0, 0.0, FIRING_BLENDBONE, true );

		// Scale anim rate to match first person anim.
		aRate = Get3rdPersonWeaponAnimRate( fireAnim, 0.0 );

		PlayAnim( fireAnim, aRate, aBlendTime, ANIMCHANNEL_FIRING );

		if ( aimAnim != 'None' )
		{
			AnimBlendParams( ANIMCHANNEL_AIMING, aimAlpha, 0, 0, FIRING_BLENDBONE, true );
			LoopIfNeeded( aimAnim, aRate, aBlendTime, ANIMCHANNEL_AIMING );
			
			// Synch with firing frame
			GetAnimParams( ANIMCHANNEL_FIRING, fireAnim, firingFrame, rate );
			firingFrame = Clamp( firingFrame, 0.0, 1.0 );
			SetAnimFrame( firingFrame, ANIMCHANNEL_AIMING );
		}
		else
		{
			AnimBlendParams( ANIMCHANNEL_AIMING, 0.0, 0.0, 0, FIRING_BLENDBONE, true );
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// PlayUndisciplinedFiring
//
simulated function PlayUndisciplinedFiring(
	float	aRate,					// Animation playback rate
	name	aFiringMode )			// Weapon firing mode
{
	local name		fireAnim,
					fireBone;
	local float		duration,
					fpDuration;

	if ( bIgnorePlayFiring || mbSprayFiring || (mThirdPersonWeapon == None) )
	{
		return;
	}

	//switch ( mThirdPersonWeapon.mCategory )
	//{
	//case WPNCAT_Primary:
		
		switch ( mFiringPose )
		{
		case FIRINGPOSE_LeanOut:
			if ( meStance == STANCE_Crouched )
			{
				fireAnim = 'Kneel_ShootCornerR_AK47';
				//fireBone = FIRING_BLENDBONE;
			}
			else
			{
				fireAnim = 'Stand_ShootCornerR_AK47';
			}
			break;

		case FIRINGPOSE_PointOut:
			if ( meStance == STANCE_Crouched )
			{
				fireAnim = 'Kneel_ShootCornerR_AK47';
				//fireBone = FIRING_BLENDBONE;
			}
			else
			{
				fireAnim = 'Stand_ShootCornerR_AK47';
			}
			break;

		case FIRINGPOSE_Overhead:
			if ( meStance == STANCE_Crouched )
			{
				fireAnim = 'Kneel_ShootCornerUp_AK47';
			}
			else
			{
				fireAnim = 'Stand_ShootCornerUp_AK47';
			}
			break;
		}
		//break;

	//case WPNCAT_Secondary:
	//	LoopIfNeeded( 'Stand_Fire1_Sig', aRate, 0.00, ANIMCHANNEL_FIRING );
	//	break;

	//default:
	//	Warn( self$" trying to do undisciplined firing with non-primary/secondary weapon." );
	//	return;
	//}

	// Scale anim rate to match first person anim.
	duration = GetNamedAnimDuration( fireAnim );
	// TODO: Need to store this duration on third person wpn for MP.
	if ( Weapon != None )
	{
		fpDuration = Weapon.GetAnimDuration( 0 );
	}
	if ( duration > 0.0 && fpDuration > 0.0 )
	{
		aRate = (duration / fpDuration) * 1.0;
	}
	else
	{
		aRate = 1.0;
	}

	AnimBlendParams( ANIMCHANNEL_FIRING, 1.0, 0.0, 0.0, fireBone, true );
	LoopIfNeeded( fireAnim, aRate, 0.0, ANIMCHANNEL_FIRING );
}


///////////////////////////////////////////////////////////////////////////////
// PlaySpinoutFiring
//
simulated function name GetSpinoutFiringAnim()
{
	local name anim;

	switch ( mFiringPose )
	{
	case FIRINGPOSE_SpinoutLeft:
		anim = 'Stand_Spinout_L_Fire_MP5';
		break;

	case FIRINGPOSE_SpinoutRight:
		anim = 'Stand_Spinout_R_Fire_MP5';
		break;

	case FIRINGPOSE_SpinoutLeftSquat:
		anim = 'Stand_Spinout_Squat_L_Fire_MP5';
		break;

	case FIRINGPOSE_SpinoutRightSquat:
		anim = 'Stand_Spinout_Squat_R_Fire_MP5';
		break;

	default:
		Warn( "Invalid firing pose "$mFiringPose$" when calling PlaySpinoutFiring" );
		break;
	}

	return anim;
}


///////////////////////////////////////////////////////////////////////////////
// PlaySpinoutFiring
//
simulated function PlaySpinoutFiring(
	float		aRate,					// Animation playback rate
	name		aFiringMode )			// Weapon firing mode
{
	local name anim;

	anim = GetSpinoutFiringAnim();
	if ( anim != 'None' )
	{
		AnimBlendParams( ANIMCHANNEL_FIRING, 1.0, 0.0, 0.0, '', true );
		LoopIfNeeded( anim, aRate, 0.0, ANIMCHANNEL_FIRING );
	}
}


///////////////////////////////////////////////////////////////////////////////
// 

//
// Play 1 frame spinout pose on base channel while spinout firing.
simulated function PlaySpinoutFiringPose()
{
	local name anim;

	switch ( mFiringPose )
	{
	case FIRINGPOSE_SpinoutLeft:
		anim = 'Stand_Spinout_L_Single_MP5';
		break;

	case FIRINGPOSE_SpinoutRight:
		anim = 'Stand_Spinout_R_Single_MP5';
		break;

	case FIRINGPOSE_SpinoutLeftSquat:
		anim = 'Stand_Spinout_Squat_L_Single_MP5';
		break;

	case FIRINGPOSE_SpinoutRightSquat:
		anim = 'Stand_Spinout_Squat_R_Single_MP5';
		break;

	default:
		Warn( "Invalid firing pose "$mFiringPose$" when calling PlaySpinoutFiring" );
		break;
	}

	if ( anim != 'None' )
	{
		PlayAnim( anim, 1.0, 0.0 );
	}
}


///////////////////////////////////////////////////////////////////////////////
// AnimateToUndisciplinedFiring
//
simulated function bool AnimateToUndisciplinedFiring()
{
	local name	anim;
			
	switch ( mFiringPose )
	{
	case FIRINGPOSE_LeanOut:
		if ( meStance == STANCE_Crouched )
		{
			anim = 'Kneel_toShootCornerR_AK47';
		}
		else
		{
			anim = 'Stand_toShootCornerR_AK47';
		}
		break;

	case FIRINGPOSE_PointOut:
		if ( meStance == STANCE_Crouched )
		{
			anim = 'Kneel_toShootCornerR_AK47';
		}
		else
		{
			anim = 'Stand_toShootCornerR_AK47';	
		}
		break;

	case FIRINGPOSE_Overhead:
		if ( meStance == STANCE_Crouched )
		{
			anim = 'Kneel_toShootCornerUp_AK47';
		}
		else
		{
			anim = 'Stand_toShootCornerUp_AK47';
		}
		break;
	}

	if ( anim != 'None' )
	{
		AnimBlendParams( ANIMCHANNEL_ACTION, 1.0, 0.15, 0.15, '', true );
		PlayActionAnim( 
			anim, 
			1.0,
			0.15,
			false,		
			false,
			false );

		return true;
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// PlayCoverSpinoutAnim
//
simulated function PlayCoverSpinoutAnim()
{
	local name anim;

	switch ( mFiringPose )
	{
	case FIRINGPOSE_SpinoutLeft:
		anim = 'Stand_Spinout_L_Out_MP5';
		break;

	case FIRINGPOSE_SpinoutRight:
		anim = 'Stand_Spinout_R_Out_MP5';
		break;

	case FIRINGPOSE_SpinoutLeftSquat:
		anim = 'Stand_Spinout_Squat_L_Out_MP5';
		break;

	case FIRINGPOSE_SpinoutRightSquat:
		anim = 'Stand_Spinout_Squat_R_Out_MP5';
		break;

	default:
		Warn( "Invalid firing pose "$mFiringPose$" when calling PlayCoverSpinoutAnim." );
		return;
	}

	PlayActionAnim( anim, 1.0, 0.0, true, false, true );
	bIgnoreRootMotionVertical = true; 
}


///////////////////////////////////////////////////////////////////////////////
// EndCoverSpinoutAnim
//
simulated function EndCoverSpinoutAnim()
{
	if ( Physics == PHYS_RootMotion )
	{
		SetPhysics( PHYS_Walking );
		EndPlayRootMotionAnim( GetSpinoutFiringAnim(), 32767 );
	}

	bIgnoreRootMotionVertical = false;
	
	ChangeAnimation();
}


///////////////////////////////////////////////////////////////////////////////
// EndCoverSpinoutReturnAnim
//
simulated function EndCoverSpinoutReturnAnim()
{
	if ( Physics == PHYS_RootMotion )
	{
		SetPhysics( PHYS_Walking );
		EndPlayRootMotionAnim( 'Stand_Sighted_AK47', 32767 );
	}

	ChangeAnimation();

}


///////////////////////////////////////////////////////////////////////////////
// PlayCoverSpinoutReturnAnim
//
simulated function PlayCoverSpinoutReturnAnim()
{
	local name anim;

	switch ( mFiringPose )
	{
	case FIRINGPOSE_SpinoutLeft:
		anim = 'Stand_Spinout_L_In_MP5';
		break;

	case FIRINGPOSE_SpinoutRight:
		anim = 'Stand_Spinout_R_In_MP5';
		break;

	case FIRINGPOSE_SpinoutLeftSquat:
		anim = 'Stand_Spinout_Squat_L_In_MP5';
		break;

	case FIRINGPOSE_SpinoutRightSquat:
		anim = 'Stand_Spinout_Squat_R_In_MP5';
		break;

	default:
		Warn( "Invalid firing pose "$mFiringPose$" when calling PlayCoverSpinoutReturnAnim." );
		return;
	}

	PlayActionAnim( anim, 1.0, 0.0, true, false, true );
	bIgnoreRootMotionVertical = true; 
}


///////////////////////////////////////////////////////////////////////////////
// PlaySprayFiring
//
simulated function PlaySprayFiring(
	float	aYawAlpha,
	float	aPitchAlpha,
	float	aAnimRate )
{
	local name	anim;
	local float	blend, rate;
	local float	pitchFrame;

	if ( aPitchAlpha < 0)
	{
		anim = 'Stand_Fire_Delta1_Up_MP5';
		blend = -aPitchAlpha;
	}
	else
	{
		anim = 'Stand_Fire_Delta1_Down_MP5';
		blend = aPitchAlpha;
	}

	AnimBlendParams( ANIMCHANNEL_FIRING, blend, 0.2, 0, FIRING_BLENDBONE, true );
	LoopIfNeeded( anim, aAnimRate, 0.0, ANIMCHANNEL_FIRING );
	
	// Store current anim frame of pitch anim for synching yaw anim.
	GetAnimParams( ANIMCHANNEL_FIRING, anim, pitchFrame, rate );

	if ( aYawAlpha < 0)
	{
		anim = 'Stand_Fire_Delta1_Left_MP5';
		blend = -aYawAlpha;
	}
	else
	{
		anim = 'Stand_Fire_Delta1_Right_MP5';
		blend = aYawAlpha;
	}

	AnimBlendParams( ANIMCHANNEL_AIMING, blend, 0.2, 0.0, FIRING_BLENDBONE, true );
	LoopIfNeeded( anim, aAnimRate, 0.0, ANIMCHANNEL_AIMING );

	// Synch with pitch frame
	SetAnimFrame( pitchFrame, ANIMCHANNEL_AIMING );
}


///////////////////////////////////////////////////////////////////////////////
// GetAimWeaponAnimName
//
native simulated function name GetAimWeaponAnimName(
	int	aAimAngle );


///////////////////////////////////////////////////////////////////////////////
// GetFireWeaponAimingAnimName
//
simulated function name GetFireWeaponAimingAnimName(
	int	aAimAngle )
{
	local name	anim;
	
	if ( aAimAngle < 0 )
	{
		switch ( mWeaponAnimSet )
		{
		case WPN3P_MP5:
			anim = 'Stand_Fire_Delta1_Up_MP5';
			break;

		case WPN3P_AK47:
			anim = 'Stand_Fire_Delta1_Up_AK47';
			break;

		case WPN3P_Sig:
			anim = 'Stand_Fire_Delta1_Up_Sig';
			break;

		case WPN3P_Shotgun:
			anim = 'Stand_Fire_Delta1_Up_Maruzen';
			break;
		}
	}
	else if ( aAimAngle > 0 )
	{
		switch ( mWeaponAnimSet )
		{
		case WPN3P_MP5:
			anim = 'Stand_Fire_Delta1_Down_MP5';
			break;

		case WPN3P_AK47:
			anim = 'Stand_Fire_Delta1_Down_AK47';
			break;

		case WPN3P_Sig:
			anim = 'Stand_Fire_Delta1_Down_Sig';
			break;

		case WPN3P_Shotgun:
			anim = 'Stand_Fire_Delta1_Down_Maruzen';
			break;
		}
	}

	return anim;
}


simulated function PlayWeaponHandlingAnim(
	byte				aWpnAnimType,
	SASWeaponAttachment	aFromWeaponAttachment )
{
	local name	anim;
	local float	blendTime,
				rate;

	// Make sure aiming anim is not trying to play.
	StopAiming();

	GetWeaponHandlingAnimInfo( aWpnAnimType, aFromWeaponAttachment, anim, blendTime, rate );
	if ( anim != 'None' )
	{
		//rate = Get3rdPersonWeaponAnimRate( aAnimName, aBlendTime );
		if ( rate == 0.0 )
		{
			rate = 1.0;
		}

		// Up/down anims have additional rate scalar.
		if ( aFromWeaponAttachment != None )
		{
			if ( aWpnAnimType == WPNHANDLINGANIM_Select )
			{
				rate *= aFromWeaponAttachment.mWeaponUpAnimRateScalar;
			}
			else if ( aWpnAnimType == WPNHANDLINGANIM_Deselect )
			{
				rate *= aFromWeaponAttachment.mWeaponDownAnimRateScalar;

				PlayChageWeaponSound();
			}
		}

		AnimBlendParams( ANIMCHANNEL_FIRING, 1.0, 0, 0, FIRING_BLENDBONE, true );
		PlayAnim( anim, rate, blendTime, ANIMCHANNEL_FIRING );
	}
}


///////////////////////////////////////////////////////////////////////////////
// PlayChageWeaponSound
//
simulated function PlayChageWeaponSound()
{
	local Sound randSound;

	if ( mChangeWeaponSounds.Length > 0 )
	{
		randSound = mChangeWeaponSounds[Rand(mChangeWeaponSounds.Length)];
		PlaySound( randSound, SLOT_Misc, mChangeWeaponSoundVolume,, mChangeWeaponSoundRadius ); 
	}
}


///////////////////////////////////////////////////////////////////////////////
// PlayReloading
//
simulated function PlayReloading()
{
	if ( mThirdPersonWeapon == None )
	{
		return;
	}

	if ( mThirdPersonWeapon.mCategory == WPNCAT_Grenade )
	{
		PlaySelectWeapon();
		return;
	}

	// Server tells the 3rd person weapon a new weapon handling anim is being played. 
	// The 3rd person weapon then replicates this info and plays the anim on the client pawn.
	if ( Level.NetMode != NM_Standalone && Role == ROLE_Authority )
	{
		mThirdPersonWeapon.SetPawnWeaponHandlingAnim( WPNHANDLINGANIM_Reload );
	}

	// Play it on server/owner client side.
	PlayWeaponHandlingAnim( WPNHANDLINGANIM_Reload, mThirdPersonWeapon );
}


///////////////////////////////////////////////////////////////////////////////
// PlayShotgunReloadSingleShell
//
simulated function PlayShotgunReloadSingleShell()
{
	if ( mThirdPersonWeapon == None )
	{
		return;
	}

	// Server tells the 3rd person weapon a new weapon handling anim is being played. 
	// The 3rd person weapon then replicates this info and plays the anim on the client pawn.
	if ( Level.NetMode != NM_Standalone && Role == ROLE_Authority )
	{
		mThirdPersonWeapon.SetPawnWeaponHandlingAnim( WPNHANDLINGANIM_Reload );
	}

	// Play it on server/owner client side.
	PlayWeaponHandlingAnim( WPNHANDLINGANIM_ReloadShotgunShell, mThirdPersonWeapon );
}


///////////////////////////////////////////////////////////////////////////////
// PlayShotgunReloadEnd
//
simulated function PlayShotgunReloadEnd()
{
	if ( mThirdPersonWeapon == None )
	{
		return;
	}

	// Server tells the 3rd person weapon a new weapon handling anim is being played. 
	// The 3rd person weapon then replicates this info and plays the anim on the client pawn.
	if ( Level.NetMode != NM_Standalone && Role == ROLE_Authority )
	{
		mThirdPersonWeapon.SetPawnWeaponHandlingAnim( WPNHANDLINGANIM_ReloadShotgunEnd );
	}

	// Play it on server/owner client side.
	PlayWeaponHandlingAnim( WPNHANDLINGANIM_ReloadShotgunEnd, mThirdPersonWeapon );
}


///////////////////////////////////////////////////////////////////////////////
// PlaySelectWeapon
//
simulated function PlaySelectWeapon()
{
	// Update idle animation.
	ChangeAnimation();

	if ( mThirdPersonWeapon == None )
	{
		return;
	}

	// Server tells the 3rd person weapon a new weapon handling anim is being played. 
	// The 3rd person weapon then replicates this info and plays the anim on the client pawn.
	if ( Level.NetMode != NM_Standalone && Role == ROLE_Authority )
	{
		mThirdPersonWeapon.SetPawnWeaponHandlingAnim( WPNHANDLINGANIM_Select );
	}

	// Play it on server/owner client side.
	PlayWeaponHandlingAnim( WPNHANDLINGANIM_Select, mThirdPersonWeapon );
}


///////////////////////////////////////////////////////////////////////////////
// PlaySelectWeapon
//
simulated function PlayDeselectWeapon()
{
	if ( mThirdPersonWeapon == None )
	{
		return;
	}

	// Play it on client side.
	PlayWeaponHandlingAnim( WPNHANDLINGANIM_Deselect, mThirdPersonWeapon );

	// Tell server to replicate anim to all clients.
	ServerPlayDeselectWeapon();
}


///////////////////////////////////////////////////////////////////////////////
// ServerPlayDeselectWeapon
//
function ServerPlayDeselectWeapon()
{
	if ( Level.NetMode != NM_Standalone && Role == ROLE_Authority )
	{
		if ( !IsLocallyControlled() )
		{
			// Play on server if its not the server pawn which instigated the anim.
			PlayWeaponHandlingAnim( WPNHANDLINGANIM_Deselect, mThirdPersonWeapon );
		}

		// Server tells the 3rd person weapon a new weapon handling anim is being played. 
		// The 3rd person weapon then replicates this info and plays the anim on the client pawn.
		mThirdPersonWeapon.SetPawnWeaponHandlingAnim( WPNHANDLINGANIM_Deselect );
	}
}


///////////////////////////////////////////////////////////////////////////////
// PlayPullPinGrenade
//
simulated function PlayPullPinGrenade()
{
	if ( mThirdPersonWeapon == None )
	{
		return;
	} 

	// Server tells the 3rd person weapon a new weapon handling anim is being played. 
	// The 3rd person weapon then replicates this info and plays the anim on the client pawn.
	if ( Level.NetMode != NM_Standalone && Role == ROLE_Authority )
	{
		mThirdPersonWeapon.SetPawnWeaponHandlingAnim( WPNHANDLINGANIM_GrenadePullPin );
	}

	PlayWeaponHandlingAnim( WPNHANDLINGANIM_GrenadePullPin, mThirdPersonWeapon );
}


///////////////////////////////////////////////////////////////////////////////
// PlayThrowGrenade
//
simulated function PlayThrowGrenade()
{
	if ( mThirdPersonWeapon == None )
	{
		return;
	} 

	// Server tells the 3rd person weapon a new weapon handling anim is being played. 
	// The 3rd person weapon then replicates this info and plays the anim on the client pawn.
	if ( Level.NetMode != NM_Standalone && Role == ROLE_Authority )
	{
		mThirdPersonWeapon.SetPawnWeaponHandlingAnim( WPNHANDLINGANIM_GrenadeThrow );
	}

	PlayWeaponHandlingAnim( WPNHANDLINGANIM_GrenadeThrow, mThirdPersonWeapon );
}


///////////////////////////////////////////////////////////////////////////////
// PlayPunch
//
// This is called on owner client to instigate punching a terrorist/hostage. 
simulated function PlayPunch(
	SASPawn	aNewPunchTarget )
{
	local SASWeapon	myWpn;

	if ( mThirdPersonWeapon == None )
	{
		return;
	} 

	// Locally controlled pawn should play 1st person punch anim.
	if ( IsLocallyControlled() )
	{
		mPunchTarget = None;

		if ( Weapon != None )
		{
			myWpn = SASWeapon( Weapon );
			if ( myWpn != None )
			{
				if ( myWpn.DoPunch() )
				{
					mPunchTarget = aNewPunchTarget; 

					PlayWeaponHandlingAnim( WPNHANDLINGANIM_Punch, mThirdPersonWeapon );

					// Tell server to replicate the punch animation.
					ServerPlayPunchAnim();
				}
			}
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// ServerPlayPunchAnim
//
function ServerPlayPunchAnim()
{
	if ( Level.NetMode != NM_Standalone && Role == ROLE_Authority )
	{
		PlayWeaponHandlingAnim( WPNHANDLINGANIM_Punch, mThirdPersonWeapon );

		// Server tells the 3rd person weapon a new weapon handling anim is being played. 
		// The 3rd person weapon then replicates this info and plays the anim on the client pawn.
		mThirdPersonWeapon.SetPawnWeaponHandlingAnim( WPNHANDLINGANIM_Punch );
	}
}


///////////////////////////////////////////////////////////////////////////////
// PlayStaggerBackwardAnim
//
simulated function PlayStaggerBackwardAnim()
{
	PlayActionAnim( 'Stand_Punched_Doorway', 1.0, 0.25, true, false, true );
}


///////////////////////////////////////////////////////////////////////////////
// EndStaggerBackwardAnim
//
simulated function EndStaggerBackwardAnim()
{
	if ( Physics == PHYS_RootMotion )
	{
		SetPhysics( PHYS_Walking );
	}

	EndPlayRootMotionAnim( 'Stand_punched_door_EndTarg' );
	ChangeAnimation();
}


///////////////////////////////////////////////////////////////////////////////
// PlaySurrenderingAnim
//
simulated function PlaySurrenderingAnim(
	int	aSurrenderReaction )
{
	local float	randVal;
	local name	anim; 

	switch ( aSurrenderReaction )
	{
	case SURRENDERREACTION_StaggerBackSmall:
		// Can play stationary or small step back anims.
		randVal = FRand();
		if ( randVal < 0.5 )
		{
			anim = 'Stand_Surrender2_AK47';
		}
		else
		{
			anim = 'Stand_Surrender4_AK47';
		}
		break;

	case SURRENDERREACTION_StaggerBackLarge:
		// Can play any anim.
		randVal = FRand();
		if ( randVal < 0.34 )
		{
			anim = 'Stand_Surrender2_AK47';
		}
		else if ( randVal < 0.67 )
		{
			anim = 'Stand_Surrender3_AK47';
		}
		else
		{
			anim = 'Stand_Surrender4_AK47';
		}
		break;

	default:
		// Only play stationary anims.
		anim = 'Stand_Surrender4_AK47';
		break;
	}

	// Kill anims on firing/aiming channels and rotation channels.
	AnimBlendToAlpha( ANIMCHANNEL_Firing, 0, 0.2 );
	AnimBlendToAlpha( ANIMCHANNEL_Aiming, 0, 0.2 );
	AnimBlendToAlpha( 2, 0, 0.2 );	// Right turn channel
	AnimBlendToAlpha( 3, 0, 0.2 );	// Left turn channel

	PlayActionAnim( anim, 1.0, 0.25, true, false, true );
}


///////////////////////////////////////////////////////////////////////////////
// EndSurrenderingAnim
//
simulated function EndSurrenderingAnim(
	bool abBreakingOut )
{
	local name	anim;

	if ( Physics == PHYS_RootMotion )
	{
		SetPhysics( PHYS_Walking );
	}

	// If breaking out of surrender anim early then want to return to firing stance, 
	// else end in surrendered pose.
	if ( abBreakingOut )
	{
		anim = 'Stand_Sighted_AK47'; 
	}
	else
	{
		anim = 'Stand_SurrenderBreath';
	}

	EndPlayRootMotionAnim( anim );
	ChangeAnimation();
}


///////////////////////////////////////////////////////////////////////////////
// PlaySurrenderBreakout
//
simulated function PlaySurrenderBreakout()
{
	PlayActionAnim( 'Stand_SurrenderBreath_toStandSig', 1.0, 0.15, false );
}


///////////////////////////////////////////////////////////////////////////////
// UpdateWeaponPose
//
simulated function UpdateWeaponPose()
{
	if ( mbAiming || (Controller == None) )
	{
		meWpnPose = WPNPOSE_Aimed;
	}
	else
	{
		meWpnPose = Controller.RequestWeaponPose();
	}
}


///////////////////////////////////////////////////////////////////////////////
// AnimateStanding
//
simulated function AnimateStanding(
	bool bNoBlend )
{
	local float				blendTime;
	local EWeaponCategory	wpnCat;
	local EWpnHoldingPose	ePose;

	if ( bNoBlend )
	{
		blendTime = 0.0;
	}
	else
	{
		blendTime = 0.2;
	}

	if ( mbSurrendered )
	{
		PlayAnim( 'Stand_SurrenderBreath', 1.0, 0.2 );
	}
	else
	{
		if ( mThirdPersonWeapon != None )
		{
			wpnCat = mThirdPersonWeapon.mCategory;
		}
		else
		{
			wpnCat = WPNCAT_Primary;
		}
		
		switch ( wpnCat )
		{
		case WPNCAT_Grenade:
			LoopIfNeeded( 'Stand_Ready_Grenade', 1.0, 0.15 );
			break;

		case WPNCAT_Knife:
			LoopSplitBodyAnimIfNeeded( 'Stand_Ported_Knife', 'Stand_Ported_MP5', 1.0, blendTime, 0 );
			break;

		default:
			switch ( meWpnPose )
			{
				case WPNPOSE_Aimed:
					PlayWeaponSpecificAnim( "Stand_Sighted", 1.0, blendTime,, true );
					break;

				case WPNPOSE_PortedLow:
					PlayWeaponSpecificAnim( "Stand_Ported", 1.0, blendTime,, true );
					break;

				case WPNPOSE_PortedHigh:
					PlayWeaponSpecificAnim( "Stand_Ported2", 1.0, blendTime,, true );
					break;

				case WPNPOSE_PortedStackup:
					PlayWeaponSpecificAnim( "Stand_Ported3", 1.0, blendTime,, true );
					break;

				default:
					Warn( "AnimateStanding: <"$self$"> has invalid weapon pose <"$ePose$">" );
					PlayWeaponSpecificAnim( "Stand_Sighted", 1.0, blendTime,, true );
					break;
			}
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// AnimateCrouching
//
simulated function AnimateCrouching(
	bool bNoBlend )
{
	local float				blendTime;
	local EWeaponCategory	wpnCat;
	local name				specialAnim;
	local EWpnHoldingPose	ePose;

	if ( bNoBlend )
	{
		blendTime = 0.0;
	}
	else
	{
		blendTime = 0.2;
	}
	
	if ( mThirdPersonWeapon != None )
	{
		wpnCat = mThirdPersonWeapon.mCategory;
	}
	else
	{
		wpnCat = WPNCAT_Primary;
	}
	
	switch ( wpnCat )
	{
	case WPNCAT_Grenade:
		LoopSplitBodyAnimIfNeeded( 'Stand_Ready_Grenade', 'Kneel_Sighted_MP5', 1.0, 0.15 );
		break;
	
	case WPNCAT_Knife:
		LoopSplitBodyAnimIfNeeded( 'Stand_Ported_Knife', 'Kneel_Sighted_MP5', 1.0, blendTime, 0 );
		break;

	default:
		if ( Controller != None )
		{
			specialAnim = Controller.GetSpecialCrouchAnim();
			if ( specialAnim != 'None' )
			{
				LoopIfNeeded( specialAnim, 1.0, 0.15);
				return;
			}
		}

		switch ( meWpnPose )
		{
		case WPNPOSE_Aimed:
			PlayWeaponSpecificAnim( "Kneel_Sighted", 1.0, blendTime,, true );
			break;

		case WPNPOSE_PortedLow:
			PlayWeaponSpecificAnim( "Kneel_Ported", 1.0, blendTime,, true );
			break;

		case WPNPOSE_PortedHigh:
			PlayWeaponSpecificAnim( "Kneel_Ported2", 1.0, blendTime,, true );
			break;

		default:
			Warn( "AnimateCrouching: <"$self$"> has invalid weapon pose <"$ePose$">" );
			PlayWeaponSpecificAnim( "Kneel_Sighted", 1.0, blendTime,, true );
			break;
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// AnimateProne
//
simulated function AnimateProne(
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

	// Kill animations on firing/hit/aiming channels instantly when in prone state.
	AnimBlendToAlpha( ANIMCHANNEL_Firing, 0.0, 0.0 );
	AnimBlendToAlpha( ANIMCHANNEL_Aiming, 0.0, 0.0 );
	AnimBlendToAlpha( ANIMCHANNEL_Hit, 0.0, 0.0 );

	if ( ShouldUseIncapAnims() )
	{
		anim = ChooseIncapacitatedAnim();
	}
	else if ( mbCaptured )
	{
		anim = 'Prone_CaptiveBreathCuffed';
	}
	else
	{
		// Animate cuffed on base channel if cuffing is in progress.
		if ( mbSurrendered && mbCuffingStarted )
		{
			anim = 'Prone_CaptiveBreathCuffed';
		}
		else
		{
			anim = 'Prone_CaptiveBreath';
		}
	}

	LoopAnim (anim, RandRange ( 0.9, 1.1 ), blendTime);
}


///////////////////////////////////////////////////////////////////////////////
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

	anim = GetWeaponSpecificAnimName( "Stand_toKneel" );

	if ( anim != 'None' )
	{
		PlayActionAnim( anim, aRate, 0.15, false );
	}
}

///////////////////////////////////////////////////////////////////////////////
// AnimateCrouchToStand
//
simulated function AnimateCrouchToStand()
{
	local name anim;

	anim = GetWeaponSpecificAnimName( "Kneel_toStand" );

	if ( anim != 'None' )
	{
		PlayActionAnim( anim, RandRange( 0.9, 1.1 ), 0.15, false );
	}
}


///////////////////////////////////////////////////////////////////////////////
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

	if ( mbSurrendered )
	{
		anim = 'StandSurrender_toProne';
	}
	else
	{
		anim = GetWeaponSpecificAnimName( "Stand_toProne" );
	}

	if ( anim != 'None' )
	{
		PlayActionAnim( anim, aRate, 0.15, false );
	}
}


///////////////////////////////////////////////////////////////////////////////
// AnimateProneToStand
//
simulated function AnimateProneToStand()
{
	Warn( "No prone-to-stand anims available for soldiers/terrorists." );
}


///////////////////////////////////////////////////////////////////////////////
// AnimateCrouchToProne
//
simulated function AnimateCrouchToProne(
	optional float aRate )
{
	local name anim;

	if ( mbSurrendered )
	{
		Warn( "No crouch-to-prone captive anim available - using mp5 anim." );
		anim = 'Kneel_ToProne_MP5';
	}
	else
	{
		Warn( "Crouch-to-prone anims not available for all weapons - using mp5 anim." );
		anim = 'Kneel_ToProne_MP5';
	}

	PlayActionAnim( anim, RandRange( 0.9, 1.1 ), 0.15, false );
}



///////////////////////////////////////////////////////////////////////////////
// AnimateToStunned
//
simulated function AnimateToStunned()
{
	local name	anim;

	switch ( meStunnedAnimType )
	{
	case STUNANIM_Blinded:
		anim = 'Stand_toBlinded_AK47';
		break;

	/*case STUNANIM_Dazed:
		anim = 'Stand_toBlinded_AK47';	// temp
		break;*/

	case STUNANIM_SprayingFire:
		anim = 'Stand_toBlinded_AK47';	// temp
		break;
	}

	if ( anim != 'None' )
	{
		PlayActionAnim( anim, RandRange( 0.85, 1.15 ), 0.15, false, mbHeadlessChicken );
	}
}


///////////////////////////////////////////////////////////////////////////////
// AnimateFromStunned
//
simulated function AnimateFromStunned()
{
	local name	anim;

	anim = GetTranisitionFromStunnedAnim();

	if ( anim != 'None' )
	{
		PlayActionAnim( anim, 1.0, 0.15, false, mbHeadlessChicken );
	}
}


///////////////////////////////////////////////////////////////////////////////
// GetTranisitionFromStunnedAnim
//
simulated function name GetTranisitionFromStunnedAnim()
{
	local name	anim;

	switch ( meStunnedAnimType )
	{
	case STUNANIM_Blinded:
		anim = 'Blinded_toStand_AK47';
		break;

	/*case STUNANIM_Dazed:
		anim = 'Dazed_toStandAK47';
		break;*/

	case STUNANIM_SprayingFire:
		anim = 'Blinded_toStand_AK47';	// temp
		break;
	}

	return anim;
}



///////////////////////////////////////////////////////////////////////////////
// AnimateStunned
//
simulated function AnimateStunned()
{
	local name	anim;

	switch ( meStunnedAnimType )
	{
	case STUNANIM_Blinded:
		anim = 'Stand_Blinded_AK47';
		break;

	case STUNANIM_SprayingFire:
		anim = 'Stand_Blinded_SprayFire_AK47';
		break;
	}

	if ( anim != 'None' )
	{
		PlayActionAnim( anim, RandRange( 0.9, 1.1 ), 0.25, true, mbHeadlessChicken );
	}
}


///////////////////////////////////////////////////////////////////////////////
// AnimateToGassed
//
simulated function AnimateToGassed()
{
	PlayActionAnim( 'Stand_toGassed_AK47', RandRange( 0.85, 1.15 ), 0.2, false, mbHeadlessChicken  );
}


///////////////////////////////////////////////////////////////////////////////
// AnimateFromGassed
//
simulated function AnimateFromGassed()
{
	local name	anim;

	anim = GetTranisitionFromGassedAnim();
	if ( anim != 'None' )
	{
		PlayActionAnim( anim, 1.0, 0.1, false, mbHeadlessChicken );
	}
}


///////////////////////////////////////////////////////////////////////////////
// GetTranisitionFromGassedAnim
//
simulated function name GetTranisitionFromGassedAnim()
{
	return 'Gassed_toStand_AK47';
}


///////////////////////////////////////////////////////////////////////////////
// ChooseGassedAnim
//
// Select a random gassed anim.
simulated function name ChooseGassedAnim ()
{
	local name	anim;
	local float	randThreshold,
				frame,
				rate;

	GetAnimParams( ANIMCHANNEL_Action, anim, frame, rate );
	
	// More likely to play gassed coughing anim if already in that anim.
	if ( anim == 'Stand_Gassed_AK47' )
	{
		randThreshold = 0.5;
	}
	else
	{
		randThreshold = 0.35;
	}
	
	if ( FRand() < randThreshold )
	{
		anim = 'Stand_Gassed_AK47';
	}
	else
	{
		anim = 'Stand_GassedStill_AK47';
	}

	return anim;
} // ChooseGassedAnim


///////////////////////////////////////////////////////////////////////////////
// GetTranisitionFromActingDeadAnim
//
simulated function name GetTransitionFromActingDeadAnim()
{
	return 'Prone_FakeDead_toKneel_AK47';
}


///////////////////////////////////////////////////////////////////////////////
// AnimateFromActingDead
//
simulated function AnimateFromActingDead()
{
	local name anim;

	anim = GetTransitionFromActingDeadAnim();
	PlayActionAnim( anim, 1.0, 0.2, true );
}


///////////////////////////////////////////////////////////////////////////////
// AnimateToIncapacitated
//
simulated function bool AnimateToIncapacitated()
{
	local name	anim;
	local float	randVal;

	switch ( meStance )
	{
	case STANCE_Crouched:
		anim = 'Kneel_toProneIncap1';
		break;

	case STANCE_Standing:
		randVal = FRand();
		if ( randVal < 0.25 )
		{
			anim = 'Stand_toProneIncap1';
		}
		else if ( randVal < 0.5 )
		{
			anim = 'Stand_toProneIncap2';
		}
		else if ( randVal < 0.75 )
		{
			anim = 'Stand_toProneIncap3';
		}
		else
		{
			anim = 'Stand_toProneIncap4';
		}
	}

	if ( anim != 'None' )
	{
		// Kill hit anims playing.
		AnimBlendToAlpha( ANIMCHANNEL_Hit, 0.0, 0.2 );

		PlayActionAnim( anim, 1.0, 0.1, true );
		return true;
	}

	return false;
}


///////////////////////////////////////////////////////////////////////////////
// ChooseIncapacitatedAnim
//
simulated function name ChooseIncapacitatedAnim()
{
	if ( mbCaptured || mbCuffingStarted )
	{
		return 'Cuffed_Incap';
	}
	else if ( FRand() < 0.15 )
	{
		return 'Prone_Incap1';
	}

	return 'Prone_IncapBreath';
}


///////////////////////////////////////////////////////////////////////////////
// AnimateIncapacitated
//
/*simulated function AnimateIncapacitated( 
	bool abInstant )
{
	local name		anim;
	local float		blendTime;

	if ( abInstant )
	{
		blendTime = 0.0;
	}
	else
	{
		blendTime = 0.25;
	}

	anim = ChooseIncapacitatedAnim();
	PlayActionAnim( anim, 1.0, blendTime, true );
}*/


///////////////////////////////////////////////////////////////////////////////
// GetPunchedAnim
//
// Select appropriate animation for standing / kneeling.
simulated function name GetPunchedAnim()
{
	switch ( meStance )
	{
	case STANCE_Standing:
		return 'Stand_Punched';

	case STANCE_Crouched:
		return 'Kneel_Punched';
	}

	return 'None';
} 


///////////////////////////////////////////////////////////////////////////////
// PlayFlinch
//
simulated function bool PlayFlinch()
{
	local name anim;

	/*if ( FRand() < 0.5 )
	{
		anim = 'Stand_Flinch01_AK47';
	}
	else
	{
		anim = 'Stand_Flinch2_AK47';
	}*/
	anim = 'Stand_Flinch3_AK47';

	PlayActionAnim( anim, 1.0, 0.15, false );
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// ChooseHitAnim
//
simulated function name ChooseHitAnim(
	EHitAnimType	aHitAnimType )
{
	local name	surrenderedHitAnim;
	local int	randIdx;

	// Overriding SASPawn version to handle hit while surrendered.
	if ( mbSurrendered )
	{
		switch ( aHitAnimType )
		{
		case HITANIM_Torso:
			if ( mHitTorsoSurrenderedAnims.Length > 0 )
			{
				randIdx = Rand( mHitTorsoSurrenderedAnims.Length );
				surrenderedHitAnim = mHitTorsoSurrenderedAnims[randIdx];
				if ( (surrenderedHitAnim == mLastHitAnim) && (mHitTorsoSurrenderedAnims.Length > 1) )
				{
					surrenderedHitAnim = mHitTorsoSurrenderedAnims[(randIdx+1) % mHitTorsoSurrenderedAnims.Length];
				}
			}
			break;

		case HITANIM_LeftArm:
			if ( mHitLeftArmSurrenderedAnims.Length > 0 )
			{
				randIdx = Rand( mHitLeftArmSurrenderedAnims.Length );
				surrenderedHitAnim = mHitLeftArmSurrenderedAnims[randIdx];
				if ( (surrenderedHitAnim == mLastHitAnim) && (mHitLeftArmSurrenderedAnims.Length > 1) )
				{
					surrenderedHitAnim = mHitLeftArmSurrenderedAnims[(randIdx+1) % mHitLeftArmSurrenderedAnims.Length];
				}
			}
			break;

		case HITANIM_RightArm:
			if ( mHitRightArmSurrenderedAnims.Length > 0 )
			{
				randIdx = Rand( mHitRightArmSurrenderedAnims.Length );
				surrenderedHitAnim = mHitRightArmSurrenderedAnims[randIdx];
				if ( (surrenderedHitAnim == mLastHitAnim) && (mHitRightArmSurrenderedAnims.Length > 1) )
				{
					surrenderedHitAnim = mHitRightArmSurrenderedAnims[(randIdx+1) % mHitRightArmSurrenderedAnims.Length];
				}
			}
			break;

		case HITANIM_LeftLeg:
		case HITANIM_RightLeg:
			break;	
		}

		return surrenderedHitAnim;
	}
	else
	{
		return Super.ChooseHitAnim( aHitAnimType );
	}
}


//-----------------------------------------------------------------------------
// States

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mBurstDurationLongPrimary=(Min=2.5000000,Max=4.0000000)
    mBurstDurationLongSecondary=(Min=2.5000000,Max=4.0000000)
    mBurstDurationShortPrimary=(Min=1.0000000,Max=2.0000000)
    mBurstDurationShortSecondary=(Min=1.0000000,Max=2.0000000)
    mBurstIntervalPrimary=(Min=1.5000000,Max=2.0000000)
    mBurstIntervalSecondary=(Min=1.5000000,Max=2.0000000)
    mBurstDurationShortProbability=0.5000000
    mHitTorsoSurrenderedAnims[0]="Stand_Shot_Middle_Surrender01"
    mHitTorsoSurrenderedAnims[1]="Stand_Shot_Middle_Surrender02"
    mHitTorsoSurrenderedAnims[2]="Stand_Shot_Middle_Surrender03"
    mHitTorsoSurrenderedAnims[3]="Stand_Shot_Middle_Surrender04"
    mHitLeftArmSurrenderedAnims[0]="Stand_Shot_Left_Surrender01"
    mHitLeftArmSurrenderedAnims[1]="Stand_Shot_Left_Surrender02"
    mHitLeftArmSurrenderedAnims[2]="Stand_Shot_Left_Surrender03"
    mHitRightArmSurrenderedAnims[0]="Stand_Shot_Right_Surrender01"
    mHitRightArmSurrenderedAnims[1]="Stand_Shot_Right_Surrender02"
    mChangeWeaponSounds[0]=Sound'mm_generic.Sounds.WD_change_weapon_01'
    mChangeWeaponSounds[1]=Sound'mm_generic.Sounds.WD_change_weapon_02'
    mChangeWeaponSounds[2]=Sound'mm_generic.Sounds.WD_change_weapon_03'
    mChangeWeaponSounds[3]=Sound'mm_generic.Sounds.WD_change_weapon_04'
    mChangeWeaponSounds[4]=Sound'mm_generic.Sounds.WD_change_weapon_05'
    mChangeWeaponSounds[5]=Sound'mm_generic.Sounds.WD_change_weapon_06'
    mChangeWeaponSounds[6]=Sound'mm_generic.Sounds.WD_change_weapon_07'
    mChangeWeaponSounds[7]=Sound'mm_generic.Sounds.WD_change_weapon_08'
    mChangeWeaponSoundVolume=0.4500000
    mChangeWeaponSoundRadius=120.0000000
    mHitTorsoAnims[0]="Stand_Shot_Middle"
    mHitTorsoAnims[1]="Stand_Shot_Middle_01"
    mHitTorsoAnims[2]="Stand_Shot_Middle_02"
    mHitTorsoAnims[3]="Stand_Shot_Middle_03"
    mHitTorsoAnims[4]="Stand_Shot_Middle_04"
    mHitLeftArmAnims[0]="Stand_Shot_Left"
    mHitLeftArmAnims[1]="Stand_Shot_Left_01"
    mHitRightArmAnims[0]="Stand_Shot_Right"
    mHitRightArmAnims[1]="Stand_Shot_Right_01"
    mHitLeftLegAnims[0]="Stand_Shot_Leftleg"
    mHitRightLegAnims[0]="Stand_Shot_Rightleg"
    mDirectionalDeathAnimsStanding=(Anim=Anim[0]="death_02")
}