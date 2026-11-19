/**
* Base melee weapon
*
*  Weapon used for melee only
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class GearWeap_Melee extends GearWeapon
	config(Weapon)
	hidedropdown;

var() config array<float>	AttackDamage;

function DoMeleeDamage( Actor Target, Vector HitLocation, float DamageScale )
{
	local GearPawn P;

	P = GearPawn(Instigator);
	if (P != None && Target != None)
	{
		Target.TakeDamage(AttackDamage[0] * DamageScale, GetWeaponController(), HitLocation, Normal(HitLocation-Instigator.Location), InstantHitDamageTypes[0],, self);
	}
}

simulated function bool HasAnyAmmo()
{
	// weapon doesn't use ammo
	return true;
}

/** this weapon has no team based colors **/
simulated function SetMaterialBasedOnTeam(MeshComponent TheMesh, int TeamNum);

simulated function TimeWeaponEquipping()
{
	SetTimer( 0.0001f, FALSE, 'WeaponEquipped' );
	return;
}

simulated function bool ShouldDrawCrosshair();

defaultproperties
{
	WeaponStatName="Melee"

	bCanThrowActiveWeapon=false
	bUseTargetingCamera=false
	bAllowAimingStance=false

	bInfiniteSpareAmmo=true
	WeaponIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=69,V=340,UL=77,VL=40)
	HUDDrawData=(DisplayCount=0)
	HUDDrawDataSuper=(DisplayCount=0)

	WeaponEquipSound=None
	WeaponDeEquipSound=None
	WeaponReloadSound=None
	FireSound=None

	InstantHitDamageTypes(0)=class'GDT_Melee'

	WeaponID=WC_Melee
}
