/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ManageTempest extends SeqAct_Latent 
	native (Sequence);

/** Enum of the different actions that can be applied to the tempest */
enum TempestActionType
{
	TAT_SetBeamTarget,
	TAT_SetBeamParams,
	TAT_SetDistractionBehavior,
	TAT_Deprecated,
	TAT_StartLanded,
	TAT_StopLanded,
	TAT_EnableBeamWeapon,
	TAT_DisableBeamWeapon,
	TAT_StartVent,
	TAT_StopVent,
	TAT_SkipFaceEnemy,
	TAT_ResumeFaceEnemy,
	TAT_SetBalconyMode,
	TAT_UnSetBalconyMode,
	TAT_StartTower,
	TAT_StopTower,
	TAT_SetMouthHealth,
	TAT_SetTowerHealth,
	TAT_StartSneakAttack,
	TAT_DisableAI,
	TAT_EnableAI,
};

/** Whether to disable the beam attack or not */
var(Beam) bool bDisableBeamAttack;

/** Time between Beam Attacks */
var(Beam) float TimeBetweenBeamAttacks;

/** How long should the beam be on */
var(Beam) float BeamTime;

/** Whether to display the tower's health */
var (Tower) bool bDisplayTowerHealth;

/** Total amount of health the tower has at full health */
var (Tower) float TowerFullHealth;

/** Amount of health the tower has right now */
var (Tower) float TowerCurrentHealth;

/** Amount of health the Tempest's back has when on the tower */
var (Tower) float TempestBackHealth;

/**
 * Location to shoot and follow with the beam attack
 * (Used in conjunction with BeamAttackTypes TBA_SweepFromTarget, TBA_TargetLock)
 */
var Actor FollowBeamTarget;

/** Whether to allow the distraction behavior or not */
var(Distract) bool bAllowDistraction;

/** Amount of damage to have the distraction occur (in conjunction with bAllowDistraction) */
var(Distract) int DamageForDistraction;

/** The current enemy of the Tempest to be outputted to kismet */
var Actor Enemy;

/** The amount of health in the health bucket for the tempest */
var() float MouthHealth;

/** Waiting for this SpecialMove to finish **/
var transient ESpecialMove SpecialMoveToFinish;
/** Trace if it has been started yet **/
var transient bool  bSpecialMoveStarted;

/** Amount of time to do the sneak attack beam */
var(Sneak) float SneakBeamTime;

/** Object to shoot the beam at */
var(Sneak) Actor SneakBeamTarget;

cpptext
{
public:
	virtual UBOOL UpdateOp(FLOAT DeltaTime);
	virtual void Activated();
};

/**
 * Return the version number for this class.  Child classes should increment this method by calling Super then adding
 * a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
 * link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
 * Super.GetObjClassVersion() should be incremented by 1.
 *
 * @return	the version number for this specific class.
 */
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 15;
}

/** Triggered by script, letting it know that it's all done **/
function TriggerFinished(TempestActionType TempestAT)
{
	// trigger started/finished
	ActivateOutputLink(0);
	ActivateOutputLink(1);
}

/** Triggered by script, letting it know that it has started, but hasn't finished yet. Waiting for ending. **/
function TriggerStarted(TempestActionType TempestAT, ESpecialMove SpecialMove)
{
	// trigger started
	ActivateOutputLink(0);
	SpecialMoveToFinish = SpecialMove;
}

/** Triggered by script, letting it know that it's all done **/
function TriggerFailed(TempestActionType TempestAT, string Reason)
{
	`warn(self@" Failed triggering "@TempestAT@" because "@Reason);

	// activate fail output
	ActivateOutputLink(0);
	ActivateOutputLink(2);
}

defaultproperties
{
	ObjName="Manage Tempest"
	ObjCategory="Gear"

	bAutoActivateOutputLinks=false
	bLatentExecution=true

	SneakBeamTime=2.0f

	InputLinks(TAT_SetBeamTarget)=(LinkDesc="Set Beam Target")
	InputLinks(TAT_SetBeamParams)=(LinkDesc="Set Beam Params")
	InputLinks(TAT_SetDistractionBehavior)=(LinkDesc="Set Distract Behavior")
	InputLinks(TAT_Deprecated)=(LinkDesc="Deprecated")
	InputLinks(TAT_StartLanded)=(LinkDesc="Start Landed")
	InputLinks(TAT_StopLanded)=(LinkDesc="Stop Landed")
	InputLinks(TAT_EnableBeamWeapon)=(LinkDesc="Enable Beam Weapon")
	InputLinks(TAT_DisableBeamWeapon)=(LinkDesc="Disable Beam Weapon")
	InputLinks(TAT_StartVent)=(LinkDesc="Start Vent")
	InputLinks(TAT_StopVent)=(LinkDesc="Stop Vent")
	InputLinks(TAT_SkipFaceEnemy)=(LinkDesc="Skip Face Enemy")
	InputLinks(TAT_ResumeFaceEnemy)=(LinkDesc="Resume Face Enemy")	
	InputLinks(TAT_SetBalconyMode)=(LinkDesc="Set Balcony Mode")
	InputLinks(TAT_UnSetBalconyMode)=(LinkDesc="Remove Balcony Mode")
	InputLinks(TAT_StartTower)=(LinkDesc="Start Tower")
	InputLinks(TAT_StopTower)=(LinkDesc="Stop Tower")
	InputLinks(TAT_SetMouthHealth)=(LinkDesc="Set Mouth Health")
	InputLinks(TAT_SetTowerHealth)=(LinkDesc="Set Tower Health")
	InputLinks(TAT_StartSneakAttack)=(LinkDesc="Start Sneak Attack")
	InputLinks(TAT_DisableAI)=(LinkDesc="Disable AI")
	InputLinks(TAT_EnableAI)=(LinkDesc="Enable AI")

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Follow Beam Target",PropertyName=FollowBeamTarget)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Object',LinkDesc="Current Enemy",PropertyName=Enemy)
	VariableLinks(3)=(ExpectedType=class'SeqVar_Float',LinkDesc="Beam Time",PropertyName=BeamTime)
	VariableLinks(4)=(ExpectedType=class'SeqVar_Float',LinkDesc="Time Between Beam Attacks",PropertyName=TimeBetweenBeamAttacks)
	VariableLinks(5)=(ExpectedType=class'SeqVar_Float',LinkDesc="Mouth Health",PropertyName=MouthHealth)
	VariableLinks(6)=(ExpectedType=class'SeqVar_Float',LinkDesc="Tower Total Health",PropertyName=TowerFullHealth)
	VariableLinks(7)=(ExpectedType=class'SeqVar_Float',LinkDesc="Tower Current Health",PropertyName=TowerCurrentHealth)
	VariableLinks(8)=(ExpectedType=class'SeqVar_Float',LinkDesc="Sneak BeamTime",PropertyName=SneakBeamTime)
	VariableLinks(9)=(ExpectedType=class'SeqVar_Object',LinkDesc="Sneak BeamTarget",PropertyName=SneakBeamTarget)
	VariableLinks(10)=(ExpectedType=class'SeqVar_Float',LinkDesc="Back Health",PropertyName=TempestBackHealth)

	OutputLinks.Empty
	OutputLinks(0)=(LinkDesc="Out")
	OutputLinks(1)=(LinkDesc="Finished")
	OutputLinks(2)=(LinkDesc="Failed")

	TempestBackHealth=2000
}
