/**
 * Base class for all locusts
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawn_LocustBase extends GearPawn_Infantry
	dependson(GearPawn_Infantry)
	abstract
	native(Pawn)
	config(Pawn)
	implements(AIObjectAvoidanceInterface);

simulated function PostBeginPlay()
{
	// these need to go there due to this uncrealscipt compiler assertion:
	//Assertion failed: OverrideComponent==BaseTemplate [File:D:\depot_epicgames\code\UnrealEngine3\Development\Src\Editor\Src\UnEdObject.cpp] [Line: 663] OverrideComponent: 'DynamicLightEnvironmentComponent GearGame.Default__GearPawn_LocustBase:MyLightEnvironment' BaseTemplate: 'DynamicLightEnvironmentComponent GearGame.Default__GearPawn_Infantry:MyLightEnvironment' Stack: Address = 0x746f7065 (filename not found)
	LightEnvironment.SetTickGroup( TG_DuringAsyncWork );

	Super.PostBeginPlay();
}

simulated function byte GetMPWeaponColorBasedOnClass()
{
	return 1;
}

function int GetMaxDownCount()
{
	// locust always return max down count.. cuz in MP we would use maxdown anyway, and we don't play as locust in SP
	return MaxDownCount;
}

simulated function ShootOffAttachment( EAttachmentType AttachmentType, Vector ApplyImpulse, class<DamageType> DamageType, bool bForced )
{
	Super.ShootOffAttachment(AttachmentType, ApplyImpulse, DamageType, bForced);

	if ( Role == ROLE_Authority && !IsDoingASpecialMove() && AttachmentType == eATTACHTYPE_Helmet &&
		MyGearAI != None && !MyGearAI.IsA('GearAI_TDM') && Health > 0 )
	{
		ServerDoSpecialMove(SM_CoverHead);
	}
}

/************************************************************************
 * Avoidance Cylinder stubs                                             *
 ************************************************************************/
event AIAvoidanceCylinderComponent GetAIAvoidanceCylinderComponent();
function SetupAvoidanceCylinder();
function bool ShouldAvoid(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent);
function bool ShouldEvade(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent);
function bool ShouldRoadieRun(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent);
function CoupleLifetime(Interface_NavMeshPathObstacle PO);
/************************************************************************
* END Avoidance Cylinder stubs                                          *
************************************************************************/

defaultproperties
{
	CharacterFootStepType=CFST_Locust_Drone

	ControllerClass=class'GearAI_Locust'

	PhysHRMotorStrength=(X=200,Y=0)

	// HeadShot neck attachment
	Begin Object Class=StaticMeshComponent Name=LocustHeadShotMesh1
	    StaticMesh=StaticMesh'COG_Gore.Locust_Headshot_Gore'
		CollideActors=FALSE
		LightEnvironment=MyLightEnvironment
	End Object
	HeadShotNeckGoreAttachment=LocustHeadShotMesh1
	bCanPlayHeadShotDeath=TRUE

	SpecialMoveClasses(SM_MidLvlJumpOver)=class'GSM_MantleOverLocust'

	NoticedGUDSPriority=20

	bCanPickupInventory=false
	bForceDBNOInSiege=false
	SiegeTutorialType=GEARTUT_SIEGE_Drone

	Begin Object Name=GearPawnMesh
		// this is only locust related animset
		AnimSets.Add(AnimSet'Locust_Grunt.AnimSetLocust_CamSkel_ArmRip')
		// this has to go in here because locust can execute locust - in wing man? 	TTP 149114	
		AnimSets.Add(AnimSet'COG_MarcusFenix_Execution.Animations.AnimSetMarcus_CamSkel_ArmRip')
		AnimSets.Add(AnimSet'COG_MarcusFenix.Animations.Animset_Locust_Layered')
	End Object

	BigHeadVoicePitch=1.6
}
