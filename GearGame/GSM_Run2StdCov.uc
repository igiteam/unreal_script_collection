
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Run2StdCov extends GSM_Run2Cover;
var()	GearPawn.BodyStance	BS_TravelAnimationVariation;
var()	GearPawn.BodyStance	BS_TravelAnimationMirroredVariation;
var()	GearPawn.BodyStance	BS_ImpactAnimationVariation;

/** Decide which animation to use */
function SetupTransitionAnimation()
{
	if ( VSizeSq(PawnOwner.AcquiredCoverInfo.Location - PawnOwner.Location) <= 10000 )
	{
		TransitionAnimation = CTA_ShortDistance;
	}
	else
	{
		Super.SetupTransitionAnimation();
	}
}
/** 
 * Returns proper Travel BodyStance 
 * If mirrored, return mirrored animation
  **/
function GearPawn.BodyStance GetTravelAnimation(bool bMirrored)
{
	// if not mirrored 
	if ( TransitionAnimation == CTA_ShortDistance )
	{
		if ( bMirrored )
		{
			return BS_TravelAnimationMirroredVariation;
		}
		else
		{
			return BS_TravelAnimationVariation;
		}
	}

	return Super.GetTravelAnimation(bMirrored);
}
/** 
 * Returns proper Impact BodyStance 
 **/
function GearPawn.BodyStance GetImpactAnimation()
{
	if ( TransitionAnimation == CTA_ShortDistance )
	{
		return BS_ImpactAnimationVariation;
	}

	return Super.GetImpactAnimation();
}

/** 
* Return TRUE if using Impact Animation
* For shorter distance cover entering, we ignore impact animation as it doesn't need that dramatic hitting effect. 
**/
function bool UseImpactAnimation()
{
	if ( TransitionAnimation == CTA_ShortDistance )
	{
		return FALSE;
	}

	return Super.UseImpactAnimation();
}

/**
* Get Mini Travel Anim Duration
* This is the time it takes to travel to the target cover slot
* Min time can fluctuate if in combat or out of combat (slow) or so
* to reflect intensity of the scene.
**/
function float GetMinTravelAnimDuration()
{
	if ( TransitionAnimation == CTA_ShortDistance )
	{
		return 0.5f;
	}

	return Super.GetMinTravelAnimDuration();
}

/**
* Get Blend Out time for run2 cover
* When you don't have impact animation, you'd like to use blend
* This also fluctuate as situation
**/
function float GetBlendOutTime()
{
	if ( TransitionAnimation == CTA_ShortDistance )
	{
		return 0.25f;
	}

	return Super.GetBlendOutTime();
}

defaultproperties
{
	BS_TravelAnimation=(Stance=((Slot=BS_FullBody,AnimName="AR_Run_Fwd2Cov_Std_Start")))
	BS_TravelAnimationMirrored=(Stance=((Slot=BS_FullBody,AnimName="AR_Run_Fwd2Cov_Std_Mirrored_Start")))
	BS_ImpactAnimation=(Stance=((Slot=BS_CovStdIdle,AnimName="AR_Run_Fwd2Cov_Std_Stop")))

	BS_TravelAnimationVariation=(Stance=((Slot=BS_FullBody,AnimName="AR_Idle_Fwd2Cov_Std")))
	BS_TravelAnimationMirroredVariation=(Stance=((Slot=BS_FullBody,AnimName="AR_Idle_Fwd2Cov_Std_Mirrored")))
}
