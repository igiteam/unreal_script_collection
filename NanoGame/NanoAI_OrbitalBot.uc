/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAI_OrbitalBot extends NanoAI_Combat
	DependsOn(NanoPawn_MetaCorp_OrbitalBotBase)
	native(AI);

var() NanoPawn_MetaCorp_OrbitalBotBase	Bot;

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess(NewPawn, bVehicleTransition);

	Bot = NanoPawn_MetaCorp_OrbitalBotBase(Pawn);
	Bot.Init();
}

final function EnableAllWeapons()
{
/*
		if( !bDummyAI )
		{
			Bot.EnableAllLimbs( TRUE );
		}*/
	
}

final function DisableAllWeapons()
{
//	Bot.EnableAllLimbs( FALSE );
}

state Idle
{
	simulated function Texture2D GetDebugIcon() { return Texture2D'UI_HUD.AI.T_UI_Debug_Icons_Idle'; }

	function bool ShouldTransitionToCombat()
	{
		local StimulusQuery Query;
		local array<int> StimulusIndices;

		`AILog(GetFuncName()@"...");
		Query.bAllowFriendly = FALSE;
		Query.bAllowNonFriendly = TRUE;
		Query.MinFOV = -1.f;
		Query.MaxFOV = -1.f;
		Query.MinDist = 0.f;
		Query.MaxDist = 4096.f;
		if( MultipleResultStimulusQuery(Query,StimulusIndices) > 0 )
		{
			return TRUE;
		}
		return FALSE;
	}

	function PickNewAction();

Begin:
	`AILog( GetStateName()@"Begin TAG" );

	PossiblyTransitionTo('Combat',ShouldTransitionToCombat);
	PickNewAction();
	Sleep(1.f);
	Goto('Begin');
}

state Combat
{
	function EndState( Name NextStateName )
	{
		Super.EndState( NextStateName );

		DisableAllWeapons();
		Focus = None;
	}

	function Name ChooseAction()
	{
		return 'Delay';
	}	

Begin:
	`AILog( GetStateName()@"Begin TAG" );

	// Activate weapons
	EnableAllWeapons();

CombatLoop:
	`AILog( GetStateName()@"CombatLoop TAG" );
	Sleep( 0.1f );
	PossiblyPickFireTarget();
	
	Goto( ChooseAction() );

Delay:	
	`AILog( "Can shoot enemy"@`showvar(FireTarget)@`showvar(LastErrorCode) );
	Sleep(1.f);

	if( Enemy != None )
	{
		Focus = Enemy;
		Pawn.StartFire(0);
		Sleep(5.f);	
		Focus = None;
	}

	
	Goto( 'CombatLoop' );
}

defaultproperties
{
}

