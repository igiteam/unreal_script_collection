/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_Knife extends NanoWeap_Sword;


function DamagedTarget( NanoPawn HitNP, vector HitLocation, vector HitNormal  )
{
	local vector OutLoc;
	local rotator OutRot;
	local SkeletalMeshComponent OutSMC;
	local name OutSocketName;
	local ParticleSystem OutPSToPlay;

	GetSocketAndMeshForDamagedTargetEffects( OutSMC, OutSocketName, OutPSToPlay );

	OutSMC.GetSocketWorldLocationAndRotation( OutSocketName, OutLoc, OutRot );

	// spawn the impact effect at the socket's location and leave it behind
	WorldInfo.MyEmitterPool.SpawnEmitter( OutPSToPlay, OutLoc, OutRot );


	//`log( `showvar(OutSMC) @ `showvar(OutSocketName) @ `showvar(OutPSToPlay) );

}


defaultproperties
{
	WeaponSheetClass=class'NanoMeleeWeaponSheet_Knife'

	Begin Object Name=WeaponMeshComp
		Scale3D=(X=1.0,Y=1.0f,Z=0.4f)
	End Object

	SummonAnimName="KN_Draw"
	DrawWeaponAnim="KN_Draw"
	TimeToSummonWeapon=0.0f
	//HolsterWeaponAnim="HG_Holster"

}