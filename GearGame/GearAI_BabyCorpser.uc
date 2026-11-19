/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_BabyCorpser extends GearAI
	native(AI)
	config(AI);

/** GoW global macros */

cpptext
{
	virtual void UpdatePawnRotation();
}

// not sure why this was stubbed out but we should make sure bFire is turned off since corpsers can't shoot
function StopFiring()
{
	bFire = 0;
}

function DoCoverHead();

/** Overridden to enforce melee weapon for the wretch */
function NotifyChangedWeapon(Weapon PrevWeapon, Weapon NewWeapon)
{
	if (NewWeapon != None && GearWeap_BabyCorpserMelee(NewWeapon) == None)
	{
		`AILog("Fixing switch to non-melee weapon:"@NewWeapon);
		Pawn.InvManager.SetCurrentWeapon(PrevWeapon);
	}
	else
	{
		Super.NotifyChangedWeapon(PrevWeapon,NewWeapon);
	}
}

function bool AllowWeaponInInventory(class<GearWeapon> NewWeaponClass)
{
	// prevent non-melee weapons for the wretch
	if (!ClassIsChildOf(NewWeaponClass,class'GearWeap_BabyCorpserMelee'))
	{
		return FALSE;
	}
	return TRUE;
}

function FireFromOpen(optional int InBursts = 1, optional bool bAllowFireWhileMoving=true);

function FireFromCover();

function DoMeleeAttack(optional Pawn NewEnemy, optional Actor InTarget)
{
	if (NewEnemy != None)
	{
		SetEnemy(NewEnemy);
	}

	class'AICmd_Attack_Melee_BabyCorpser'.static.InitCommand(self);
}


defaultproperties
{
	bCanExecute=false
	bCanRevive=false
	RotationRate=(Pitch=60000,Yaw=60000,Roll=2048)
	CombatMood=AICM_Aggressive

	DefaultCommand=class'AICmd_Base_BabyCorpser'

	//ignore reactions
	DefaultReactConditions.Empty
	DefaultReactConditionClasses.Empty

	// have to re-init the delegates here so they get the right function object
	// melee reaction
	Begin Object Name=EnemyInMeleeRangeReaction0
		OutputFunction=BeginMeleeCommandWrapper
	End Object
	DefaultReactConditions.Add(EnemyInMeleeRangeReaction0)

	// execute enemy
	Begin Object Name=ExecutEnemyReaction0
		OutputFunction=HandleExecuteReactionAndPushExecuteCommand
	End Object
	DefaultReactConditions.Add(ExecutEnemyReaction0)

	// don't move in squads
	bIgnoreSquadPosition=true
}
