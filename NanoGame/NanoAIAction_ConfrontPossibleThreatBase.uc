/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_ConfrontPossibleThreatBase extends NanoAIAction within NanoAI
	abstract;


simulated function Texture2D GetDebugIcon() 
{ 
	return Texture2D'UI_HUD.AI.T_UI_Debug_Icons_Search'; 
}


function Pushed()
{ 
	Super.Pushed();

	SetMood(AIMood_Alert);

	NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_ChallengePlayer,Pawn);
}


function Popped()
{ 
	Super.Popped();
	SetActiveBoidMovementByClass( class'BoidRule_TrooperRanged', FALSE );
}



state ConfrontPossibleThreat `DEBUGSTATE
{

	function BeginState(Name PrevStateName)
	{
		local NanoPC NPC;
		local bool bPlayerIsInCombat;

		SetMood(AIMood_Alert);
		SetFireTarget( None );
		InitBoidRulesForState();
		LastTimeNoticedAlertStimuli = WorldInfo.TimeSeconds;

		if (DefensePoints.Length == 0)
		{
			// defensive aicmds should do this
			//LookForNearbyDefensePoints();
		}

		if( Role == ROLE_Authority )
		{
			// see if any players are currently in combat, and fire off the appropriate music event
			bPlayerIsInCombat = FALSE;
			foreach WorldInfo.AllControllers(class'NanoPC', NPC)
			{
				if( NPC.IsInCombat() )
				{
					bPlayerIsInCombat = TRUE;
					break;
				}
			}

			if( !bPlayerIsInCombat )
			{
				NanoGRI(WorldInfo.GRI).GetMusicManager().HandleMusicEvent( EME_TrooperSpotAndMoveToIntercept );
			}
			else
			{
				NanoGRI(WorldInfo.GRI).GetMusicManager().HandleMusicEvent( EME_TrooperArrivesToEngage );
			}
		}
	}

	function EndState( Name NextStateName )
	{
		Super.EndState( NextStateName );

	}

	function InitBoidRulesForState()
	{
		SetActiveBoidMovementByClass( class'BoidRule_TrooperRanged', TRUE );
	}

	function float RateStimulusForAlertAction(int Index)
	{
		local float Rating;
		Rating = Stimuli[Index].Priority;
		Rating *= 1024.f/VSize2D(Stimuli[Index].Location - Pawn.Location);
		if (Stimuli[Index].bVisible)
		{
			Rating *= 2.f;
		}
		if( Stimuli[Index].bCombative )
		{
			Rating *= 2.f;
		}
		`AILog(GetFuncName()@`showvar(Index)@`showvar(Rating));
		return Rating;
	}

}

/**
 * So for some of the confront actions we want to have them automatically go after a foe if there is a raised chaos level.
 **/
static function bool ChaosIsHighAndThereAreFoesNearby( NanoAI InAI )
{
	local array<int> StimulusIndices;
	local StimulusQuery ModifiedDefensiveQuery;
	local int ChaosLevel;
	local ChaosPacifismManager CM;

	ModifiedDefensiveQuery = InAI.DefensiveQuery;

	if( ( InAI.CurrNanoDefensivePoint != None )
		&& ( InAI.CurrNanoDefensivePoint.bShouldAutoAttackWhenHighChaos == TRUE )
		)
	{
		CM = NanoGRI(InAI.WorldInfo.GRI).GetCurrentChaosManager();

		if( CM != none )
		{
			ChaosLevel = CM.GetChaosTier();
		}

		ModifiedDefensiveQuery = InAI.DefensiveQuery;
		ModifiedDefensiveQuery.bRequireDamaged = FALSE;
		ModifiedDefensiveQuery.MaxDist = InAI.CurrNanoDefensivePoint.RadiusToDefend;

		//`log( `showvar(ChaosLevel) );

		if( ( ChaosLevel > 0 )
			&& (InAI.MultipleResultStimulusQuery( ModifiedDefensiveQuery, StimulusIndices ) > 0 )
			)
		{
			return TRUE;
		}
	}

	return FALSE;
}





defaultproperties
{
	UtilityStartVal=190
	UtilityEndVal=300

}