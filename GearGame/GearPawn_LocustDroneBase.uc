/**
 * Base class for locust drones
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawn_LocustDroneBase extends GearPawn_LocustBase
	abstract
	config(Pawn);

simulated function PostBeginPlay()
{
	// these need to go there due to this uncrealscipt compiler assertion:
	//Assertion failed: OverrideComponent==BaseTemplate [File:D:\depot_epicgames\code\UnrealEngine3\Development\Src\Editor\Src\UnEdObject.cpp] [Line: 663] OverrideComponent: 'DynamicLightEnvironmentComponent GearGame.Default__GearPawn_LocustBase:MyLightEnvironment' BaseTemplate: 'DynamicLightEnvironmentComponent GearGame.Default__GearPawn_Infantry:MyLightEnvironment' Stack: Address = 0x746f7065 (filename not found)
	LightEnvironment.SetTickGroup( TG_DuringAsyncWork );

	Super.PostBeginPlay();
}

/** Grunts just explode when shot by ride reaver or brumak - like crowd members - save ragdoll perf */
simulated function bool ShouldUseSimpleEffectDeath(class<GearDamageType> GearDamageType)
{
	if( ClassIsChildOf(GearDamageType, class'GearGame.GDT_RideReaverCannon') ||
		ClassIsChildOf(GearDamageType, class'GearGame.GDT_ReaverMinigun') ||
		ClassIsChildOf(GearDamageType, class'GearGame.GDT_BrumakBulletPlayer') ||
		ClassIsChildOf(GearDamageType, class'GearGame.GDT_BrumakCannonPlayer') ||
		ClassIsChildOf(GearDamageType, class'GearGame.GDT_ReaverCannonCheap') )
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

/** called when banzai attacking */
function PlayBanzaiChargeScream();

defaultproperties
{
	CharacterFootStepType=CFST_Locust_Drone

	DefaultInventory(0)=class'GearGame.GearWeap_LocustAssaultRifle'
	HeadIcon=MaterialInstanceConstant'UI_CharPortraits.HUDHeads.UI_HUDHeads_LOC_Drone'

	ControllerClass=class'GearAI_Locust'

	PhysHRMotorStrength=(X=200,Y=0)

	SpecialMoveClasses(SM_MidLvlJumpOver)=class'GSM_MantleOverLocust'

	NoticedGUDSEvent=GUDEvent_NoticedDrone
	NoticedGUDSPriority=20
}
