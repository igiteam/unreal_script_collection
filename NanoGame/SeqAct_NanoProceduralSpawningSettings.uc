/**
 * This will set the
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_NanoProceduralSpawningSettings extends SequenceAction;

/** Whether or not the normal EnemyManagement needs to have a tattler seeing the player character do "bad things" **/
var() bool bDoEnemyManagementRequireTattlerSight;

/** Whether or not to try and spawn foes around the player **/
var() bool bDoEnemyManagement;

/** Whether or not to attempt to find defensive points to spawn foes at **/
var() bool bDoEnemyManagement_DefensivePoints;

/** Whether or not to spawn enemies on the rooftops. **/
var() bool bDoEnemyManagement_Rooftops;

/** Whether or not to do the enemy clean up (e.g. if distance > N OR not rendered in N )**/
var() bool bDoEnemyCleanUp;

/** Duration to be outside of the red circle to reset chaos **/
var() float DurationOutsideOfHotZoneToResetChaos;

/** Radius To Find Crowd Members To Turn Into AI when chaos is triggered **/
var() float RadiusToFindCrowdMembersToTurnIntoAI;

/** Min distance police cars will spawn from player **/
var() float PoliceCar_SpawnDistance_Min;

/** Max distance police cars will spawn from player **/
var() float PoliceCar_SpawnDistance_Max;




static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 9;
}

/**
 * Called when this event is activated.
 */
event Activated()
{
	local NanoGRI NGRI;


	NGRI = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI);

	NGRI.NPES.bDoEnemyManagementRequireTattlerSight = bDoEnemyManagementRequireTattlerSight;

	NGRI.NPES.bDoEnemyManagement = bDoEnemyManagement;

	NGRI.NPES.bDoEnemyManagement_DefensivePoints = bDoEnemyManagement_DefensivePoints;

	NGRI.NPES.bDoEnemyManagement_Rooftops = bDoEnemyManagement_Rooftops;

	NGRI.NPES.bDoEnemyCleanUp = bDoEnemyCleanUp;

	NGRI.NPES.DurationOutsideOfHotZoneToResetChaos = DurationOutsideOfHotZoneToResetChaos;

	NGRI.NPES.RadiusToFindCrowdMembersToTurnIntoAI = RadiusToFindCrowdMembersToTurnIntoAI;

	NGRI.NPES.PoliceCar_SpawnDistance_Min = PoliceCar_SpawnDistance_Min;

	NGRI.NPES.PoliceCar_SpawnDistance_Max = PoliceCar_SpawnDistance_Max;

}




defaultproperties
{
	ObjName="Set Nano Procedural Spawning Settings"
	ObjCategory="Nano Procedural"

	VariableLinks.Empty()
	bCallHandler=FALSE

	InputLinks.Empty()
	InputLinks(0)=(LinkDesc="In")


	bDoEnemyManagementRequireTattlerSight=FALSE
	bDoEnemyManagement=TRUE
	bDoEnemyManagement_DefensivePoints=TRUE
	bDoEnemyManagement_Rooftops=TRUE
	bDoEnemyCleanUp=TRUE
	RadiusToFindCrowdMembersToTurnIntoAI=4096.0f
	DurationOutsideOfHotZoneToResetChaos=15.0f

	PoliceCar_SpawnDistance_Min=14000
	PoliceCar_SpawnDistance_Max=17000
}

