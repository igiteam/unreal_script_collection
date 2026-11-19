/**
 * So this class is our "brain" for determine what kind of melee attack state to be in.
 *     -engaged
 *     -standby
 *     -spectating
 *
 *
 *
 *
 *

 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_EngageThreat_Trooper_Melee extends NanoAIAction_EngageThreatBase within NanoAI_Trooper;

static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;
	local bool bHasEnemyModeratelyClose;
	local int ResultCount;
	local array<int> StimulusIndices;
	local NanoAIBlackboard Blackboard;
	local bool bMeleeRingsHaveRoom;
	local TargetableOctreeComponent Targetable;
	local vector TargetLocation;
	local StimulusQuery ModifiedMeleeEngageThreatQuery;


	if( InAI.FireTarget == None )
	{
		`AILog_Ext( GetFuncName() @ "FireTarget is None!!",, InAI );
		InAI.PossiblyPickFireTarget();
		return 0;
	}

	if( InAI.FireTarget.IsTargetable() == FALSE ) // something is not clearing the firetarget correctly
	{
		`AILog_Ext( GetFuncName() @ "Invalid FireTarget!!" @ `showvar(InAI.FireTarget) @ `showvar(InAI.FireTarget.IsTargetable()),, InAI );
		return 0;
	}



	//`log( "NanoAICmd_Trooper_Attack_Melee GetUtility" );

	//`log( `showvar(InAI.FireTarget) @ VSize(InAI.FireTarget.GetTargetedLocation() - InAI.Pawn.Location) );


	// if we hit something then we need to bail out and let the confront action run
	// We do this because all of the indiv cmd movement is based on boid movement

	TargetLocation = InAI.FireTarget.GetTargetedLocation();

	if( InAI.NavigationHandle.ObstacleLineCheck( InAI.Pawn.Location, TargetLocation, vect(0,0,0) ) == FALSE )
	{
		`AILog_Ext( GetFuncName() @ "ObstacleMesh issue!" @ `showvar(InAI.Pawn.Location) @ `showvar(TargetLocation),, InAI );
		return 0;
	}




	// allow the enemy to run away and probably force a switch to another Action (as we will not increase the retval dramatically at the bottom
	if( ( VSize(TargetLocation - InAI.Pawn.Location) < 1024 ) && ( abs(TargetLocation.Z - InAI.Pawn.Location.Z) < 256 ) )
	{
		bHasEnemyModeratelyClose = TRUE;
	}


	ModifiedMeleeEngageThreatQuery = NanoAI(InAI).MeleeEngageThreatQuery;

	// so if we have an enemy, then we don't require damaged nor do we require combative anymore
	`AILog_Ext( GetFuncName() @ "I have an FireTarget: " @ `showvar(InAI.FireTarget),, InAI );
	ModifiedMeleeEngageThreatQuery.bRequireCombative = QO_Require;
	ModifiedMeleeEngageThreatQuery.bRequireDamaged = FALSE;

	ResultCount = InAI.MultipleResultStimulusQuery( ModifiedMeleeEngageThreatQuery, StimulusIndices );


	Blackboard = InAI.GetBlackBoard();
	Targetable = InAI.FireTarget.GetTargetableOctreeComponent();

	// so this needs to be per type // ask for override it seems
	// so we need the TargetableComponent to have override capability.  Most will just use the AIBlackboard settings it seems

	if( Targetable.bHasOverridesForMeleeListRanges == TRUE )
	{
		bMeleeRingsHaveRoom = ( Targetable.MeleeSpectatorList.Length < Targetable.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeSpectator ) || ( Targetable.MeleeStandByList.Length < Targetable.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeStandby ) || ( Targetable.MeleeEngageList.Length < Targetable.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeEngage );
	}
	else
	{
		bMeleeRingsHaveRoom = ( Targetable.MeleeSpectatorList.Length < Blackboard.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeSpectator ) || ( Targetable.MeleeStandByList.Length < Blackboard.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeStandby ) || ( Targetable.MeleeEngageList.Length < Blackboard.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeEngage );
	}


	`AILog_Ext( GetFuncName() @ `showvar(ResultCount) @ `showvar(bMeleeRingsHaveRoom) @ `showvar(bHasEnemyModeratelyClose),, InAI );

	if( ( ResultCount > 0 ) 
		&& ( bMeleeRingsHaveRoom == TRUE )
		)
	{
		Retval += 45;
	}

	if( ( ResultCount > 0 ) 
		&&( bHasEnemyModeratelyClose == TRUE )
		)
	{
		Retval += 40;
	}


	// if there is no one in the list or I am in the list bias this to stay in the list
	if(( ResultCount > 0 ) 
		&& ( ( Targetable.MeleeEngageList.Length == 0 ) || ( Targetable.MeleeEngageList.Find( InAI ) != INDEX_NONE ) )
		)
	{
		Retval += 5;
	}

	// so if were actually "valid" take what ever "bonus" pts we got and then add on the start val
	if( Retval > 0 )
	{
		Retval += default.UtilityStartVal; 

	}


	return Retval;
}

function Pushed()
{ 
	Super.Pushed();
	SetActiveBoidMovementByClass( class'BoidRule_TrooperMelee', TRUE );
	NanoPawnBase(Pawn).ModifyPawnBasedBoidRules_AvoidTeamaates( FALSE );

	// this makes it so the pawn starts running toward the player and then the planner will set it to the correct confrontation type once it plans
	SetConfrontationType( ECFT_Melee_Engaged );
}


function Popped()
{ 
	Super.Popped();
	SetActiveBoidMovementByClass( class'BoidRule_TrooperMelee', FALSE );
	NanoPawnBase(Pawn).ModifyPawnBasedBoidRules_AvoidTeamaates( TRUE );

	SetConfrontationType( ECFT_None );
}

state Combat_MeleeAttack extends Combat
{
	simulated function Texture2D GetDebugIcon() { return Texture2D'UI_HUD.AI.T_UI_Debug_Icons_CombatMelee'; }

	function BeginState(Name PrevStateName)
	{
		Super.BeginState(PrevStateName);
		if (bHasBaton)
		{
			MyTrooper.SpawnNanoBaton();
		}

		NanoGRI(WorldInfo.GRI).GetMusicManager().HandleMusicEvent( EME_CombatStarts );
	}

	function EndState( Name NextStateName )
	{
		Super.EndState( NextStateName );

	}

Begin:
	`AILog( GetStateName()@"Begin TAG" );

	// this will end up updating the attacker list (for camera and other hotness)
	PossiblyPickFireTarget();

	Sleep( 0.1f );
}

defaultproperties
{
	StartingStateName="Combat_MeleeAttack"


	ListOfCmdsCanDo.Add(class'NanoAICmd_Trooper_Melee_Engage')
	ListOfCmdsCanDo.Add(class'NanoAICmd_Trooper_Melee_Standby')
	ListOfCmdsCanDo.Add(class'NanoAICmd_Trooper_Melee_Spectator')

}
