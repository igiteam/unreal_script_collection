/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_Boomer extends GearAI;

var float NextFireTime;

/** Stored ref to the movable cover we're trying to push. */
var transient Actor MovableCoverToPush;
var transient Actor MovableCoverAlignActor;

function float GetFireDelay()
{
	`AIlog(GetFuncName()@self);
	MyGearPawn.TelegraphAttack();
	return 1.f;
}

function bool CanFireWeapon( Weapon Wpn, byte FireModeNum )
{
	// always allow reloading
	if (FireModeNum == class'GearWeapon'.const.RELOAD_FIREMODE || MyGearPawn.MyGearWeapon.ShouldAutoReload())
	{
		return true;
	}

	// if we would have fired, call GetFireDelay first and see if we should wait
	if( Super.CanFireWeapon(Wpn,FireModeNum) )
	{

		`AILog(GetFuncName()@WorldInfo.TimeSeconds@NextFireTime@FireModeNum,'Weapon');
		if(WorldInfo.TimeSeconds < NextFireTime)
		{
			return false;
		}
		else if(NextFireTime == 0 && !(IsReloading() || IsSwitchingWeapons()))
		{
			NextFireTime = WorldInfo.TimeSeconds + GetFireDelay();
			return false;
		}
		return true;
	}
	return false;
}

function NotifyWeaponFired( Weapon W, byte FireMode )
{
	Super.NotifyWeaponFired(W,FireMode);
	SetTimer(0.2f,FALSE,nameof(ResetNextFireTime));
}

function ResetNextFireTime()
{
	NextFireTime=0;
}

function bool ShouldAllowWalk()
{
	return false;
}

function AddBasePathConstraints(bool bIsCoverSearch)
{
	Super.AddBasePathConstraints(bIsCoverSearch);
	class'Path_AvoidInEscapableNodes'.static.DontGetStuck( Pawn );
}

function GoExecuteEnemy(GearPawn P);

function HandleScriptedSpecialMove(ESpecialMove InSpecialMove, Actor InAlignActor,
										 optional GearPawn InInteractionPawn, optional int InSpecialMoveFlags,
										 optional vector InAlignOffset )
{
	// for boomers, special handling for pushcover (there's a boomer that pushes a car in sp_fort)
	if (InSpecialMove == SM_PushCover)
	{
		if (InAlignActor != None)
		{
			MovableCoverAlignActor = InAlignActor;
			MovableCoverToPush = InterpActor_MovableCover(InAlignActor.Base);
			if (MovableCoverToPush == None)
			{
				`warn("*** GSM_PushCover failed.  To use PushCover with a Boomer, AlignActor must be set and based on the InterpActor_MovableCover actor.");
			}
		}
	}

	super.HandleScriptedSpecialMove(InSpecialMove, InAlignActor, InInteractionPawn, InSpecialMoveFlags, InAlignOffset);
}

defaultproperties
{
	DefaultCommand=class'AICmd_Base_Boomer'

	// Don't want reactions
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

	MaxStepAsideDist=196.f

	bCanRevive=FALSE
	bCanExecute=FALSE
}
