/**
 * 
 * Eventually this should be every close to:  NanoAIAction_EngageThreat_Trooper_Melee where there are
 * different types of "attack strategies the turret can do" 
 * E.g.  suppressive fire, kill the biggest threat, kill the weakest threat, shoot down incoming drop pods / drop ships, AntiAir only etc.
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_EngageThreat_SentryTurret extends NanoAIAction_EngageThreatBase within NanoAI_SentryTurret
	config(AI);


var transient NanoSentryTurretBase MyTurret;


/** Once we have a firetarget pause this long **/
var config float TimeToPauseBeforeFiringOnceWeHaveAFireTarget;

/** Min Time we will scan for a target **/
var config float TimeForScanningForNextTarget;

/** How long to pause after we have killed our target **/
var config float TimeToPauseAfterWeHaveKilledOurTarget;



/** If we had a target to kill previously **/
var transient bool bHadTargetToKill;


static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;

	Retval = default.UtilityStartVal;

	return Retval;
}


simulated function Texture2D GetDebugIcon() { return Texture2D'UI_HUD.AI.T_UI_Debug_Icons_CombatRanged'; }


function Pushed()
{ 
	Super.Pushed();

	MyTurret = NanoSentryTurretBase(Outer.Pawn);

}


function Popped()
{ 
	Super.Popped();
}


function CleanUpStartFiringVars()
{
	if( bHadTargetToKill == TRUE )
	{
		Pawn.StopFire(0);
		Outer.Pawn.PlaySound( MyTurret.DoneFiringSound );

		bHadTargetToKill = FALSE; // we no longer have a target now
	}
}


state SearchAndDestroy
{

Begin:
	`AILog( GetStateName()@"Begin TAG" );

	if( MyTurret.bForging == TRUE )
	{
		`AILog( GetStateName()@"Still forging" );
		Sleep( 0.5f );
		Goto( 'Begin' );
	}


	`AILog( GetStateName()@"Starting combat loop" );
CombatLoop:
	
	if( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() == 0 )
	{
		`AILog( GetStateName()@"Chaos is not up so do not start firing" );
		CleanUpStartFiringVars();
		Sleep( 0.5f );
		Goto( 'CombatLoop' );
	}



	if( FireTarget == None )
	{
		Outer.Pawn.PlaySound( MyTurret.ScanningSound );
		//`log( "sleeping" @ `showvar(TimeForScanningForNextTarget) );
		Sleep( TimeForScanningForNextTarget );
	}

	//`log( "PossiblyPickFireTarget" );
	PossiblyPickFireTarget();

	//FireTarget = NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn;
	//SetFireTarget( FireTarget );

	if( FireTarget != None )
	{
		// here we need to do a line of sight check so we don't just keep firing when things are hidden
		if( Pawn.LineOfSightTo( FireTarget ) == TRUE )
		{
			`AILog( `showvar(FireTarget) @ `showvar(VSize(FireTarget.GetTargetedLocation()-Outer.Pawn.Location) ) );

			bHadTargetToKill = TRUE;
			Outer.Pawn.PlaySound( MyTurret.AboutToFireSound );
			//`log( "sleeping" @ `showvar(TimeToPauseBeforeFiringOnceWeHaveAFireTarget) );
			Sleep( TimeToPauseBeforeFiringOnceWeHaveAFireTarget );

			Pawn.StartFire(0);
		}
		else
		{
			SetFireTarget( None );
		}
	}


	if( FireTarget == None )
	{
		CleanUpStartFiringVars();
		//`log( "sleeping" @ `showvar(TimeToPauseAfterWeHaveKilledOurTarget) );
		Sleep( TimeToPauseAfterWeHaveKilledOurTarget );
	}	

	Sleep( 0.5f );

	Goto( 'CombatLoop' );
}




defaultproperties
{
	StartingStateName="SearchAndDestroy"
}