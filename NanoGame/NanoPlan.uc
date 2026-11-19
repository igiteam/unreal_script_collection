/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPlan extends Object
    config(Game)
	abstract;

/** Pawn who owns me */
var transient NanoPawn PawnOwner;

/** Name shown on menus */
var string              PlanName;

/** The class for the WeaponModifier **/
// @todo, move to NanoPlan_WeaponModifierBase?
var class<NanoWeaponModifier> WeaponModifierClass;  // needs to be a name so we can DLO it

/** Slot that this plan can be loaded into */
var ENanoPlanSlot       PlanSlot;

/** How much it costs to unlock this plan */
var config int          UnlockCost;

/** this weapon's UI icon; used in the menus and HUD to represent the weapon */
var	NanoIconData		PlanIcon;


/** How many Nano Power buckets must be used to Forge this Plan **/
var config int NumNanoPowerBucketsToUse;

/** How many Nano Power Forge Core buckets must be used to Forge this Plan **/
var config int NumNanoPowerForgeCoreBucketsToUse;

/** Holds the per-plan data used by forge UI */
struct native ForgeUIPlanData
{
	var string PlanName;
	var string PlanDescription;
	var StaticMesh UIMesh;
	/** Some of the meshes we have are HUGE and we need to scale them down **/
	var float Scale;
	/** Some meshes are oriented "up" so they don't really fit in the area.  So we need to rotate them **/
	var rotator MeshRotation;

	structdefaultproperties
	{
		Scale=1.0f
	}
};
var() const ForgeUIPlanData ForgeUIData;


/** Some plans have crosshairs to show it it is going to aim into the world to place the object.  Or allow you to spawn an object somewhere based off aiming **/
var Texture2D AimingCrossHair;

/** Whether or not we should slow our velocity when using this forge **/
var config bool bShouldSlowVelocity;

delegate OnForgeActorFinished();

simulated function InitPlan(NanoPawn PlanOwnerPawn)
{
	PawnOwner = PlanOwnerPawn;
}


static function bool CanDoForge( NanoPawn NP )
{
	//`log(  `showvar(default.class) @  `showvar(default.NumNanoPowerBucketsToUse) );
	return NP.HasEnoughNanoBuckets( default.NumNanoPowerBucketsToUse, TRUE ) 
		&& NP.HasEnoughNanoForgeCoreBuckets( default.NumNanoPowerForgeCoreBucketsToUse, TRUE ) 
		&& IsValidLocationToSpawn( NP );
}


/** For many plans we need to have an area which to spawn the object.  We want to check that we can spawn before paying nano cost **/
static function bool IsValidLocationToSpawn( NanoPawn NP )
{
	return TRUE;
}

/** 
 * We need to make certain we have a correct place to spawn.
 *
 * returns TRUE/FALSE if it found a location.  And will update the out_loc and out_rot 
 **/
protected static function bool FindLocationAndRotationToSpawn( const NanoPawn NP, out vector out_Loc, out rotator out_Rot, out Actor out_HitActor )
{
	return TRUE;
}


static function PayNanoPowerCost( NanoPawn NP )
{
	NP.ConsumeNanoBucket( default.NumNanoPowerBucketsToUse );
	NP.ConsumeNanoForgeCoreBucket( default.NumNanoPowerForgeCoreBucketsToUse );
}



function StartForge(optional delegate<NanoPawn.OnForgeFinished> OnFinishCallback)
{
	OnForgeActorFinished = OnFinishCallback;

	PawnOwner.bSlowVelocityDueToForging = bShouldSlowVelocity;
}

function EndForge()
{
	PawnOwner.bSlowVelocityDueToForging = FALSE;
}



defaultproperties
{
	PlanIcon=(IconTex=Texture2D'Nano_ProtoHUD_Ingame.T_UI_HUD_Ingame_WeaponIcons',Coords=(U=64,V=64,UL=64,VL=64))		
}