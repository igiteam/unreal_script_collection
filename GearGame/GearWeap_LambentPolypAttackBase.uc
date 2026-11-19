/**
 * Lambent Polyp Attack
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeap_LambentPolypAttackBase extends GearWeapon
	abstract
	config(Weapon);

function DoMeleeDamage( Actor Target, Vector HitLocation, float DamageScale )
{
	local GearPawn P;

	P = GearPawn(Instigator);
	if( P != None )
	{
		Target.TakeDamage( RandRange(MeleeAttackDamageMin, MeleeAttackDamageMax)  * DamageScale, GetWeaponController(), HitLocation, Normal(HitLocation-Instigator.Location), class'GDT_LambentPolyp_Melee',, self );
		PlaySound(MeleeImpactSound);
	}
}

/** this weapon has no team based colors **/
simulated function SetMaterialBasedOnTeam( MeshComponent TheMesh, int TeamNum );

simulated function TimeWeaponEquipping()
{
	SetTimer( 0.0001f, FALSE, 'WeaponEquipped' );
	return;
}

simulated function Vector GetMuzzleLoc()
{
	local vector OutLocation;

	GearPawn(Instigator).Mesh.GetSocketWorldLocationAndRotation('Spit', OutLocation);
	return OutLocation;
}

simulated function GetProjectileFirePosition( out vector out_ProjLoc, out vector out_ProjDir, optional out float out_ProjSpeed )
{
	Super.GetProjectileFirePosition(out_ProjLoc, out_ProjDir, out_ProjSpeed );

	out_ProjLoc = Owner.Location;
}

function OverrideAIAimRotation(out rotator DesiredAimRot, vector StartFireLoc, vector AimLoc)
{
	local class<GearProjectile> ProjClass;
	local vector TossVelocity;

	// GravityScale * 0.5 because SuggestTossVelocity() assumes we are using PHYS_Falling, which has double gravity
	// but we actually are using PHYS_Projectile with Acceleration manually set to the desired gravity
	ProjClass = class<GearProjectile>(GetProjectileClass());
	Instigator.SuggestTossVelocity(TossVelocity, AimLoc, StartFireLoc, ProjClass.default.Speed,, 0.2,,, Instigator.PhysicsVolume.GetGravityZ() * ProjClass.default.GravityScale * 0.5);

	DesiredAimRot.Pitch = rotator(TossVelocity).Pitch;
}

defaultproperties
{
	WeaponFireTypes(0)=EWFT_Projectile
	InstantHitDamageTypes(0)=class'GDT_Boomshot'

	BS_MeleeAttack.Empty()
	BS_MeleeAttack(0)=(Stance=((Slot=BS_FullBody,AnimName="low_attack")))
	BS_MeleeAttack(1)=(Stance=((Slot=BS_FullBody,AnimName="jump_attack")))

	bWeaponCanBeReloaded=false
}
