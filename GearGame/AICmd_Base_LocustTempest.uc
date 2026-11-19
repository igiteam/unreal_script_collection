/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class AICmd_Base_LocustTempest extends AICommand_Base_Combat
	within GearAI_LocustTempest;

var transient GearPawn_LocustTempestBase Tempest;

var transient bool bIsRecoveringFromPause;

/** Time of last beam attack */
var float LastTimeOfBeamAttack;

function Pushed()
{
	Super.Pushed();

	Tempest = GearPawn_LocustTempestBase(MyGearPawn);
			
	GotoState('InCombat');
}

function Resumed( Name OldCommandName )
{
	Super.Resumed(OldCommandName);

	bIsRecoveringFromPause = true;
	GotoState('InCombat');
}

state InCombat
{
Begin:
	if( !SelectTarget() )
	{
		`AILog("Could not select enemy!");
		GotoState('DelayFailure');
	}

	OnNewEnemy();
	Focus=Enemy;
	FinishRotation();
	if (!bIsRecoveringFromPause)
	{
		Sleep(EnemyAcquiredGracePeriod);
		`AILog("sleeping"@EnemyAcquiredGracePeriod);
		bIsRecoveringFromPause = false;
	}

	while( HasValidEnemy() )
	{
		Sleep(0.1f);
		if (!Tempest.bDisableAI)
		{
			if (WorldInfo.TimeSeconds - LastTimeOfBeamAttack > Tempest.TimeBetweenBeamAttacks && !Tempest.bBeamDisabled)
			{
				Tempest.DoInAirBeamAttack(Enemy);
				LastTimeOfBeamAttack = WorldInfo.TimeSeconds;
			}
			else if (!Tempest.bLanded && !Tempest.bBeamDisabled && !Tempest.IsDoingSpecialMove(SM_Tempest_BeamInAir))
			{
				class'AICmd_Tempest_Hover'.static.InitCommand(Outer);
			}
		}
	}
	Goto('Begin');
};

defaultproperties
{
}