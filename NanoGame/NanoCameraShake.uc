/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * Base class that encapsulates parameters for defining 
 * a code-driven (oscillating) screen shake.
 */

class NanoCameraShake extends CameraShake
	editinlinenew
	native;

/** True to use TargetingDampening multiplier while player is targeted, False to use global defaults (see TargetingAlpha). */
var(Oscillation) bool bOverrideTargetingDampening;

/** Amplitude multiplier to apply while player is targeting.  Ignored if bOverrideTargetingDampening == FALSE */
var(Oscillation) float TargetingDampening;

defaultproperties
{
}
