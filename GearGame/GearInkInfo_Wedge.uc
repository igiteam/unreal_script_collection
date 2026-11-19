/** 
 * A manager object for a single "patch" of fire.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearInkInfo_Wedge extends GearFireInfo_Wedge;

defaultproperties
{
	FireOriginHeight=40.f
	FireSpawnerClass=class'Emit_BouncyInk'

	// no light
	Components.Remove(FireLight0)
	FireLight=FireLight0

	BouncyFireSpawnParams.Empty
	BouncyFireSpawnParams(0)=(MaxStickyFires=3,YawDelta=0,DistBetweenSpawnsRange=(X=190,Y=220))
	BouncyFireSpawnParams(1)=(MaxStickyFires=2,YawDelta=-2500,DistBetweenSpawnsRange=(X=190,Y=240),SpawnOffset=(Y=-35))
	BouncyFireSpawnParams(2)=(MaxStickyFires=2,YawDelta=2500,DistBetweenSpawnsRange=(X=190,Y=240),SpawnOffset=(Y=35))
	BouncyFireSpawnParams(3)=(MaxStickyFires=2,YawDelta=-5000,DistBetweenSpawnsRange=(X=190,Y=240),SpawnOffset=(Y=-70))
	BouncyFireSpawnParams(4)=(MaxStickyFires=2,YawDelta=5000,DistBetweenSpawnsRange=(X=190,Y=240),SpawnOffset=(Y=70))

	FireLoopSoundCue=SoundCue'Weapon_Grenade.InkGrenade.InkGrenadeSprayingLoopCue'
}



