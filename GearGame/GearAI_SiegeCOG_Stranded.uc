/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_SiegeCOG_Stranded extends GearAI_SiegeCOG;

/** set when running away because we were tagged with a grenade */
var GameAICommand GrenadeTagFearCmd;

function bool CanEvade(optional bool bCheckChanceToEvade, optional float InChanceToEvade = -1.0, optional float ChanceToEvadeScale = 1.0)
{
	return (GetDifficultyLevel() > DL_Casual && Super.CanEvade(bCheckChanceToEvade, InChanceToEvade, ChanceToEvadeScale));
}

function bool CheckInterruptCombatTransitions()
{
	local GearProj_Grenade Grenade;

	if (MyGearPawn != None && !MyGearPawn.IsDBNO() && !IgnoreNotifies() && (GrenadeTagFearCmd == None || GrenadeTagFearCmd.IsPendingKill()))
	{
		foreach MyGearPawn.BasedActors(class'GearProj_Grenade', Grenade)
		{
			break;
		}
		// run away from enemy if tagged with a grenade
		if (Grenade != None && Grenade.Instigator != None)
		{
			`AILog("Tagged with grenade! Run away from" @ Grenade.Instigator);
			// we can't run away very well with a heavy weapon!
			if (MyGearPawn != None && MyGearPawn.IsCarryingAHeavyWeapon())
			{
				MyGearPawn.ThrowActiveWeapon();
			}
			bShouldRoadieRun = true;
			// enemy is too close or couldn't find cover - just run!
			if (MyGearPawn == None || (!MyGearPawn.IsAKidnapper() && MyGearPawn.EquippedShield == None))
			{
				class'NavMeshPath_AvoidFireFromCover'.static.AvoidFireFromCover(NavigationHandle);
			}
			class'NavMeshPath_AlongLine'.static.AlongLine(NavigationHandle, Normal(Pawn.Location - Grenade.Instigator.Location));
			class'NavMeshGoal_AwayFromPosition'.static.FleeFrom(NavigationHandle, Grenade.Instigator.Location, 2500);
			if (NavigationHandle.FindPath())
			{
				// abort currently active move if necessary to run away
				if (AICmd_MoveToGoal_Mesh(GetActiveCommand()) != None)
				{
					AbortCommand(GetActiveCommand());
				}
				Focus = None;
				SetMovePoint(NavigationHandle.PathCache_GetGoalPoint(),, true,, true, false);
				GrenadeTagFearCmd = GetActiveCommand();
				return true;
			}
			else
			{
				`AILog("Failed to find path away!");
				return Super.CheckInterruptCombatTransitions();
			}
		}
		else
		{
			return Super.CheckInterruptCombatTransitions();
		}
	}
	else
	{
		return Super.CheckInterruptCombatTransitions();
	}
}

defaultproperties
{
	CombatMood=AICM_Aggressive
	DefaultReactConditions.Remove(SiegeCOGTargetedReaction)
}
