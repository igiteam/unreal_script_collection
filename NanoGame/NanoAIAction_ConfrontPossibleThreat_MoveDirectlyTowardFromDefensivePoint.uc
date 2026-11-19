/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_ConfrontPossibleThreat_MoveDirectlyTowardFromDefensivePoint extends NanoAIAction_ConfrontPossibleThreatBase within NanoAI;


static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;
	local array<int> StimulusIndices;

	local StimulusQuery ModifiedConfrontThreatQuery;

	local NanoPC NPC;
	local bool bWithinDefendRadius;

	local int ChaosLevel;
	local ChaosPacifismManager CM;

	//local int Index;

	//`AIlog_Ext( "NanoAIAction_ConfrontPossibleThreat_MoveDirectlyTowardFromDefensivePoint GetUtility()" ,, InAI );


	//`log( NanoAI_Trooper(InAI).ConfrontPossibleThreatQuery.bRequireCombative @ NanoAI_Trooper(InAI).ConfrontPossibleThreatQuery.MaxDist @ InAI.MultipleResultStimulusQuery( NanoAI_Trooper(InAI).ConfrontPossibleThreatQuery, StimulusIndices ) );


	// need to also check that if we were shot then spazz out

	ModifiedConfrontThreatQuery = NanoAI(InAI).ConfrontPossibleThreatQuery;

	ModifiedConfrontThreatQuery.bRequireDamaged = FALSE;
	ModifiedConfrontThreatQuery.bDisregardChaosOverride_RequireDamaged = FALSE;

	if( 
		( InAI.MultipleResultStimulusQuery( ModifiedConfrontThreatQuery, StimulusIndices ) > 0 )
		)
	{
		`AILog_Ext( "Someone shot me!" ,, InAI );
		//`AILog_Ext( InAI.StimulusQueryToString( ModifiedConfrontThreatQuery ) ,, InAI );

// 		foreach StimulusIndices(Index)
// 		{
// 			`AIlog_Ext( `showvar(InAI.Stimuli[Index].Actor) ,, InAI );
// 			`AIlog_Ext( `showvar(InAI.Stimuli[Index].Priority) ,, InAI );
// 			`AIlog_Ext( `showvar(InAI.Stimuli[Index].bIsFriendly) ,, InAI );
// 			`AIlog_Ext( `showvar(InAI.Stimuli[Index].bCombative) ,, InAI );
// 			`AIlog_Ext( `showvar(InAI.Stimuli[Index].bDamaged) ,, InAI );
// 		}


		Retval += default.UtilityStartVal + 50;

		//NanoGRI(InAI.WorldInfo.GRI).GetNanoPC().ConsoleCommand("PlayersOnly");

	}



	//// check for the threat being inside the RaidusToDefend of this AI's CurrentNanoDefensivePoint

	foreach InAI.WorldInfo.AllControllers( class'NanoPC', NPC )
	{
		break;
	}

	if( InAI.CurrNanoDefensivePoint != None )
	{
		bWithinDefendRadius = ( VSize(NPC.Pawn.Location - InAI.CurrNanoDefensivePoint.Location) < InAI.CurrNanoDefensivePoint.RadiusToDefend );
	}

	//`log( `showvar(bWithinDefendRadius) @ VSize(NPC.Pawn.Location - InAI.CurrNanoDefensivePoint.Location) @ InAI.CurrNanoDefensivePoint.RadiusToDefend );


	CM = NanoGRI(InAI.WorldInfo.GRI).GetCurrentChaosManager();

	if( CM != none )
	{
		ChaosLevel = CM.GetChaosTier();
	}


	ModifiedConfrontThreatQuery = NanoAI(InAI).ConfrontPossibleThreatQuery;

	ModifiedConfrontThreatQuery.bRequireDamaged = FALSE;


	if( ( ChaosLevel > 0 )
		&& ( ( bWithinDefendRadius == TRUE ) || ( InAI.MultipleResultStimulusQuery( ModifiedConfrontThreatQuery, StimulusIndices ) > 0 ) )
		)
	{
		`AILog_Ext( "INSIDE RadiusToDefend",, InAI );
		Retval += default.UtilityStartVal + 50; // semi bogus to do another UtilityStartVal but this wil make certain certain that the AI will go off and attack the interloper!
	}

	return Retval;
}



function Pushed()
{
	local NanoPC NPC;

	Super.Pushed();

	// if we are hanging out on the rooftops looking for players then try to do a line of sight check to them
	if( ConfrontationType == ECFT_RooftopSentinel )
	{
		foreach WorldInfo.AllControllers(class'NanoPC', NPC)
		{
			if( LineOfSightTo(NPC.Pawn) )
			{
				NanoGRI(WorldInfo.GRI).AttemptToPlayLine( EDLine_SightPlayerFromDistance, Pawn );
				break;
			}
		}
	}

	ListOfAIActionsThisAICanDo.RemoveItem( class'NanoAIAction_ConfrontPossibleThreat_MoveDirectlyTowardFromDefensivePoint' );

	ListOfAIActionsThisAICanDo.AddItem( class'NanoAIAction_ConfrontPossibleThreat_MoveDirectlyToward' );
	ListOfAIActionsThisAICanDo.AddItem( class'NanoAIAction_EngageThreat_Trooper_Ranged' );
	ListOfAIActionsThisAICanDo.AddItem( class'NanoAIAction_EngageThreat_Trooper_Melee' );

}


function Popped()
{
	Super.Popped();

}



state ConfrontPossibleThreat
{

Begin:
	PossiblyPickFireTarget();

	Sleep(1.f);
	Goto('Begin');

}



defaultproperties
{
	StartingStateName="ConfrontPossibleThreat"
}