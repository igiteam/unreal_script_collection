/** 
 * A manager object for a single "patch" of fire.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearInkInfo_Circular extends GearFireInfo_Circular;

defaultproperties
{
	FireOriginHeight=40.f
	FireSpawnerClass=class'Emit_BouncyInk'

	// no light
	Components.Remove(FireLight0)
	FireLight=FireLight0

	CircularSpreadPatternAngle=7000

	CircularMaxStickyFires=1
	CircularNumBouncyFires=9
	CircularDistBetweenSpawnsRange=(X=50,Y=265)
	CircularSurfaceBias=0.7f
	CircularForwardVelocityBias=0.7

	FireLoopSoundCue=SoundCue'Weapon_Grenade.InkGrenade.InkGrenadeSprayingLoopCue'
}



