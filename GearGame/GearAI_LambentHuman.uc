/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_LambentHuman extends GearAI
	config(AI);

/** Overridden to add random variation to ground speed */
event Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess(NewPawn, bVehicleTransition);
	GearPawn_LambentHumanBase(NewPawn).AddGroundSpeedVariation();
}

singular function bool StepAsideFor(Pawn ChkPawn);

function FireFromOpen(optional int InBursts = 1, optional bool bAllowFireWhileMoving=true);

function DoMeleeAttack(optional Pawn NewEnemy, optional Actor InTarget)
{
	if (NewEnemy != None)
	{
		SetEnemy(NewEnemy);
	}

	class'AICmd_Attack_LambentHumanMelee'.static.Melee(self, InTarget);
}

function OnNewEnemy(Actor InInstigator, AIReactChannel OrigChannel)
{
	GearPawn_LambentHumanBase(MyGearPawn).PlayEnemyAcquiredSound();
}

event bool CanUseJumpLink(JumpLink Link)
{
	return Link.bAllowLambentHuman;
}

defaultproperties
{
	DefaultCommand=class'AICmd_Base_LambentHuman'
	DefaultReactConditions.Empty
	DefaultReactConditionClasses.Empty

	CombatMood=AICM_Aggressive

	RotationRate=(Pitch=50000,Yaw=100000,Roll=50000)
	//MeleePounceRange=150.f
	IntermediatePointArrivalDist=10.f

	// melee reaction
	Begin Object Name=EnemyInMeleeRangeReaction0
		AutoSubscribeChannels(0)=EnemyWithinMeleeDistance
		OutputFunction=BeginMeleeCommandWrapper
	End Object
	DefaultReactConditions.Add(EnemyInMeleeRangeReaction0)

	Begin Object Class=AIReactCond_LambentHuman_ShouldPounce Name=ShouldPounceReaction0
		CommandClass=class'AICmd_Move_Pounce'
	End Object
	DefaultReactConditions.Add(ShouldPounceReaction0)

	Begin Object Class=AIReactCond_LambentHuman_ShouldPounce Name=ShouldProwlReaction0
		CommandClass=class'AICmd_Move_Prowl'
	End Object
	DefaultReactConditions.Add(ShouldProwlReaction0)

	// plays a sound whenever we have a new enemy
	Begin Object class=AIReactCond_GenericCallDelegate Name=SoundCaller0
		AutoSubscribeChannels(0)=NoticedEnemy
		OutputFunction=OnNewEnemy
	End Object
	DefaultReactConditions.Add(SoundCaller0)

	bCanRevive=false
	bCanExecute=false
	bUseFireTickets=false
	bUseFlockingMovement=true
	bPreferMelee=true

	MaxPathLaneValue=4.f
}
