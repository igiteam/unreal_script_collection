/**
 * 
 * and then the planner goes:  foreach planner that I have: do some static function that will determine that specific rating.     end of the planner function   says  let's take the top rated plan and find actions that will fulfil it and push that AICmd_ onto the stack  and off that AI goes
 * 
 *
 *
 *
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class AIPlanner extends Actor
	dependson( NanoAIBase );



/** List of all active AI 
 * NOTE: we probably want to make this a struct and have some other meta data associated with it
 **/
var transient array<NanoAIBase> ListOfActiveAI;

var transient float StartupTime;


var transient float TimeRanPostOperations;
var transient float TimeRanMeleeOperations;


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	StartupTime = WorldInfo.TimeSeconds;
}


/** 
 *  So we need to be notified when an AI actually spawns and then we update our internal tracking structures.
 **/
function NotifyANewAIHasSpawned( const NanoAIBase InAI )
{
	ListOfActiveAI.AddItem( InAI );
}


/** 
 *  So we need to be notified when an AI actually dies and then we update our internal tracking structures.
 **/
function NotifyANewAIHasDied( const NanoAIBase InAI, class<DamageType> DamageType )
{
	ListOfActiveAI.RemoveItem( InAI );
}





function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	// prob should do this every time period
	if( `TimeSince(StartupTime) > 0.0f )
	{
		// cache off the Current Chaos Tier as calling functions in .uc land is slooow.  And we have LOTS of AI with
		// LOTS of actions and they all end up needing to know the Chaos Tier.
		// so do it once :-) and . access it
		NanoGRI(WorldInfo.GRI).AIBlackboard.CachedCurrChaosTier = NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel();

		CreateActionsForAIs();

		DoSpecialMeleeActionRating();

		// two phase pass to run utility again RunStrategies(); so we can have the "highest" guy run this actual strat for cases where there is only 1 slot to do something
		TickCurrActionOnAI( DeltaTime );

		if( `TimeSince(TimeRanPostOperations) > 0.500f )
		{
			NanoGRI(WorldInfo.GRI).AIBlackboard.PostAIPlannerTick();
			TimeRanPostOperations = WorldInfo.TimeSeconds;
		}

	}
}



delegate int SortByBestUtilityRating( NanoAIAction_EngageThreat_Trooper_Melee A, NanoAIAction_EngageThreat_Trooper_Melee B )
{
	return A.BestUtilityRating < B.BestUtilityRating ? -1 : 0;
}


/**
 * This is vital.   The player can basically teleport around with its run speed.  Move really quickly through the foes. So we look for the set of Foes around us and then have them have the ability to switch
 * To a different engage group.  (e.g.  I run from the center of a mass of guys to the outskirts and am standing next to a bunch of spectator ranged guys.   Those foes there 
 * should NOT just back up.  Instead they should switch up and become the new "center" of the ring.  
 *
 * This function is constantly looking to see where the player is and doing the "correct" thing to pop AI Actions of AIs that are no longer relevant to the fight.
 *
 *
 **/
private function DoSpecialMeleeActionRating()
{
	local NanoGRI NanoGRI;
	local array<NanoPawn> PawnsWithinMeleeEngageRange;
	local NanoPawn NP;
	local NanoAIBase AI;
	local string UtilityString;
	// misnamed for the time being
	local array<NanoAIAction_EngageThreat_Trooper_Melee> AIsToSort;
	local array<NanoAIAction_EngageThreat_Trooper_Melee> TopAIs;
	local NanoAIAction_EngageThreat_Trooper_Melee AIActionToAdd;
	local int i;
	local TargetableOctreeComponent Targetable;
	local int NumAIAborted;


	NanoGRI = NanoGRI(WorldInfo.GRI);

	if( ( `TimeSince(TimeRanMeleeOperations) < 0.100f ) || ( NanoGRI.GetNanoPC() == none ) )
	{
		return;
	}

	TimeRanMeleeOperations = WorldInfo.TimeSeconds;

	// this need to be fixed up to be so intrusive
	//FIXMEMP:  Assumes there is only one player!
	PawnsWithinMeleeEngageRange = NanoGRI.FindAllNanoPawnsAroundPlayerPawn( NanoPawn(NanoGRI.GetNanoPC().Pawn), class'BoidRule_TrooperMelee'.default.EngageRanges[NanoGRI.AIBlackboard.CachedCurrChaosTier].SpectatorRange.Y );


	if( PawnsWithinMeleeEngageRange.Length == 0 )
	{
		return;
	}


	//`log( "DoSpecialMeleeShizzleDoSpecialMeleeShizzleDoSpecialMeleeShizzleDoSpecialMeleeShizzleDoSpecialMeleeShizzle" @ `showvar(PawnsWithinMeleeEngageRange.Length) );

	foreach PawnsWithinMeleeEngageRange( NP )
	{
		AI = NanoAIBase(NP.Controller);

		// special case code for stopping tackled pawns from wanting to attack
		if( ( AI == None ) || ( ApplicableForAIPlannerTicking( AI ) == FALSE ) )
		{
			continue;
		}

		if( AI != None )
		{
			//AIActionToAdd = NanoAIAction_EngageThreat_Trooper_Melee(AI.Commandlist);
			AIActionToAdd = AI.FindCommandOfClass( class'NanoAIAction_EngageThreat_Trooper_Melee' );

			//`log( NP @ AI @ `showvar(AI.Commandlist)  );

			if( AIActionToAdd != None )
			{
				AIActionToAdd.GetBestSubCmd( UtilityString ); // mutates the AIAction to have best utility and best command
				//`log( AI @ UtilityString );
				AIsToSort.AddItem( AIActionToAdd );
				UtilityString = "";
			}
			else
			{
				//`log( "  Not adding as AIAction NOT NanoAIAction_EngageThreat_Trooper_Melee:" @ NP @ AI @ `showvar(AI.Commandlist)  );
			}
		}
	}

	// so what we want to do here is:
	//   gather the top NumMeleeEngage AI into a new list
	//   now check those against the current MeleeEngageList
	//         if yes then do nothing
	//         if no then abortcommand on the ones not in our new list
	//  
	//   now for the ones not in the MeleeEngageList
	//       push the new command that was highest rated to do

	if( AIsToSort.Length > 0 )
	{
		//`log( "SORTING" @ `showvar(AIsToSort.Length) );
		if( AIsToSort.Length > 1 )
		{
			AIsToSort.Sort( SortByBestUtilityRating );
		}

		//for( i = 0; i < AIsToSort.Length; ++i )
		//{
		//	//`log( "  AIsToSort" @ AIsToSort[i].Outer @ `showvar(AIsToSort[i].BestUtilityRating) @ `showvar(AIsToSort[i].BestUtilityCmd) ); 
		//}

		// take top NumMeleeEngage as our TopAIs
		for( i = 0; i < AIsToSort.Length; ++i )
		{
			if( i < NanoGRI.AIBlackboard.MeleeListRanges[NanoGRI.AIBlackboard.CachedCurrChaosTier].NumMeleeEngage )
			{
				//`log( "  TopAIs.AddItem" @ AIsToSort[i].Outer @ `showvar(AIsToSort[i].BestUtilityRating) @ `showvar(AIsToSort[i].BestUtilityCmd) );
				TopAIs.AddItem( AIsToSort[i] );
			}
			else
			{
				break;
			}
		}


		//`log( "TopAIs now consist of" );
		//for( i = 0; i < TopAIs.Length; ++i )
		//{
		//	//`log( "  TopAIs" @ TopAIs[i] @ TopAIs[i].Outer @ `showvar(TopAIs[i].ChildCommand) );
		//}


		Targetable = NanoInterface_Targetable(NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn).GetTargetableOctreeComponent();

		//`log( "Look for AIs to possibly move to the MeleeEngaged list" );
		// look in the engage list and see if we should possibly abort their command as they are no longer the
		// TopAI to be in the engage list
		foreach Targetable.MeleeEngageList( AI )
		{
			if( ( AI.CommandList == none ) || ( ApplicableForAIPlannerTicking( AI ) == FALSE ) )
			{
				//`log( "OOOOOH NO!" @ AI @ `showvar(AI.CommandList) );
				//ApplicableForAIPlannerTicking_Log( AI );
				continue;
			}

			// don't punt people from the list if we don't need to
			// we don't have enough top AIs to take up all of the spaces in the MeleeEngage list so don't kick any
			if( NumAIAborted >= TopAIs.Length )
			{
				break;
			}



			if( TopAIs.Find( AI.FindCommandOfClass( class'NanoAIAction_EngageThreat_Trooper_Melee' ) ) == INDEX_NONE )
			{
				`AILog_Ext( "  AbortCommand AbortedByPlanner_DoSpecialMeleeActionRating" @ AI @ `showvar(AI.CommandList) @ `showvar(AI.CommandList.ChildCommand), , AI );

				//`log( "  AbortCommand " @ AI @ `showvar(AI.CommandList) @ `showvar(AI.CommandList.ChildCommand) );
				AI.CommandList.ChildCommand.Status = 'AbortedByPlanner_DoSpecialMeleeActionRating'; // this should show up somewhere but it doesn't seem to
				AI.AbortCommand( AI.CommandList.ChildCommand  );
			}

			NumAIAborted++;
		}

		// for all of the TopAIs, let's see if they are not already in the EngageList.
		// if they are not then add them by doing a the best command
		foreach TopAIs( AIActionToAdd )
		{
			if( Targetable.MeleeEngageList.Find( AIActionToAdd.Outer ) == INDEX_NONE )
			{
				//`log( "  DoCommandIniting " @ AIActionToAdd.Outer @ `showvar(AIActionToAdd.BestUtilityRating) @ `showvar(AIActionToAdd.BestUtilityCmd) );
				AIActionToAdd.DoCommandIniting( AIActionToAdd.BestUtilityString, AIActionToAdd.BestUtilityCmd );
			}
		}
	}


	//if( NanoGRI.AIBlackboard.MeleeEngageList.Length > NanoGRI.AIBlackboard.MeleeListRanges[NanoGRI.AIBlackboard.CachedCurrChaosTier].NumMeleeEngage )
	//{
	//	`warn( "ALERT ALERT ALERT" @ `showvar(NanoGRI.AIBlackboard.MeleeEngageList.Length) );
	//	for( i = 0; i < NanoGRI.AIBlackboard.MeleeEngageList.Length; ++i )
	//	{
	//		`log( "  " @ NanoGRI.AIBlackboard.MeleeEngageList[i] );
	//	}
	//}

}


/** Single function to add in our "special" conditions to tell the Planner to not Plan that pawn. **/
private final function bool ApplicableForAIPlannerTicking( const out NanoAIBase AI )
{
	if( NanoTurretBase(AI.Pawn) != None )
	{
		return TRUE;
	}

	if( ( AI.Pawn != None )
		&& ( AI.bTargetDummy == FALSE )
		&& ( AI.bIsScripted == FALSE ) // NOTE we want to remove this horrible flag usage
		&& ( NanoPawnBase(AI.Pawn).bStunned == FALSE ) // if we have not been stunned
		&& ( NanoPawnBase(AI.Pawn.Base) == None ) // if we are not standing on another pawn
		&& ( NanoPawn(AI.Pawn) == None || ( NanoPawn(AI.Pawn).IsDoingASpecialMove() == FALSE ) )
		//&& ( NanoAICmd_Trooper_Melee_MoveInRange(AI.CommandList) == None ) // don't stop transform guys who are moving ???
		)
	{
		return TRUE;
	}

	return FALSE;
}

private final function ApplicableForAIPlannerTicking_Log( const out NanoAIBase AI )
{
	`log( "   " @ `showvar(( NanoTurretBase(AI.Pawn) != None )) );
	`log( "   " @ `showvar(( AI.Pawn != None )) );
	`log( "   " @ `showvar(( AI.bTargetDummy == FALSE )) );
	`log( "   " @ `showvar(( AI.bIsScripted == FALSE )) );

	if( NanoPawnBase(AI.Pawn) != None )
	{
		`log( "   " @ `showvar(( NanoPawnBase(AI.Pawn).bStunned == FALSE ) ) );
		`log( "   " @ `showvar(( NanoPawnBase(AI.Pawn.Base) == None )) );
	}

	if( NanoPawn(AI.Pawn) != None )
	{
		`log( "   " @ `showvar(!NanoPawn(AI.Pawn).IsDoingASpecialMove()) );
	}
	else
	{
		`log( "   " @ `showvar(( NanoPawn(AI.Pawn) != None )) );
	}
	

}



private function TickCurrActionOnAI( float DeltaTime )
{
	local NanoAIBase AI;

	foreach ListOfActiveAI( AI )
	{
		if( ( `TimeSince(AI.LastAIPlannerTime_Action) > 0.100f )
			&& ( NanoAIAction(AI.Commandlist) != None )
			&& ( ApplicableForAIPlannerTicking(AI) == TRUE )
			)
		{
			//`log( "TickCurrActionOnAI" @ AI.Commandlist );
			NanoAIAction(AI.Commandlist).TickAction( DeltaTime );
			AI.LastAIPlannerTime_Action = WorldInfo.TimeSeconds;
		}
	}
}


private function CreateActionsForAIs()
{
	local NanoAIBase AI;

	foreach ListOfActiveAI( AI )
	{
		if( ( `TimeSince(AI.LastAIPlannerTime) > 0.100f )
			&& ( ApplicableForAIPlannerTicking(AI) == TRUE )
			)
		{
			DoTopRatedAction( AI );
			AI.LastAIPlannerTime = WorldInfo.TimeSeconds;
		}
	}
}


private function DoTopRatedAction( NanoAIBase InAI )
{
	local class<NanoAIAction> AIAction;
	local string UtilityString;
	local array< class<AICommandBase> > Cmds;
	local class<NanoAICmd> ToPush;
	local int i;
	local GameAICommand Cur;

	if( InAI.AITree != None && InAI.bUseAITree )
	{
		Cmds = InAI.AITree.EvaluateTree( InAI, InAI.AITreeHandle );

		//test
// 		`log( InAI@"EVAL TREE"@Cmds.Length );
// 		for( i = 0; i < Cmds.Length; i++ )
// 		{
// 			`log("   >>"@Cmds[i] );
// 		}

		Cur = InAI.CommandList;
		while( Cur != None )
		{
			if( Cmds.Length > 0 && Cur.class == Cmds[0] )
			{
				Cmds.Remove( 0, 1 );
			}
			else
			{
				break;
			}

			Cur = Cur.ChildCommand;
		}

		//test
// 		`log( "After compare: Cur"@Cur@Cmds.Length );
// 		for( i = 0; i < Cmds.Length; i++ )
// 		{
// 			`log("   >>"@Cmds[i] );
// 		}

		InAI.AbortCommand( Cur );
		for( i = 0; i < Cmds.Length; i++ )
		{
			if( ApplicableForAIPlannerTicking( InAI ) )
			{
				ToPush = class<NanoAICmd>(Cmds[i]);
				ToPush.static.AIPlanTransitionTo( InAI, FALSE );
			}
		}

		//debug
		InAI.AITreeHandle.LastUtilityRatingListAtChange.Length = 0;
		InAI.AITreeHandle.LastUtilityRatingListAtChange = InAI.AITreeHandle.LastUtilityRatingList;

		return;
	}



	AIAction = InAI.FindBestAIActionForPlan( UtilityString );
	//`AILog_Ext( UtilityString, , InAi );
	//`log( InAI @ "Found AICmd: " @ AIAction );

	// so we can do this InAI.Commandlist
	if( ( AIAction != None )
		&& (( InAI.Commandlist == None )
		   || ( InAI.Commandlist.class != AIAction )
		   )
		)
	{
		// so now we need to instantiate this AICmd
		`AILog_Ext( "AIPlanner Doing new Action", , InAI );
		`AILog_Ext( UtilityString, , InAI );
		`AILog_Ext( "DoTopRatedAction: " @ InAI @ AIAction, , InAI );

		//`log( InAi @ "AIPlanner Doing new Action" );
		//`log( InAi @ UtilityString );
		//`log( InAi @"DoTopRatedAction: " @ AIAction );

		InAI.AbortCommand( InAI.Commandlist );

		//debug
		InAI.LastActionChangedUtilityList.Length = 0;
		InAI.LastActionChangedUtilityList = InAI.LastUtilityRatingsList;


		AIAction.static.AIPlanTransitionTo ( InAI, FALSE );
	}
}






defaultproperties
{
	TickGroup=TG_DuringAsyncWork
}


/*

Planner
  AIs
    AIPlans this ai can do
      -Types of AICmds that can fulfill the plan
	AICmds this ai can do


    AIPlan_Idle
	AIPlan_ConfrontPossibleThreat
	AIPlan_EngageThreat
        AICmd_EngageBase



Blackboard
  -someone writes to the black board saying we want to have guys on rooftops and some on the ground
      -the AICmds that are active then look at the blackboard and see if that influences them or not
	         -> so when you N dudes all with plan ConfrontPossibleThreat they look and see what AICmds 
			    satisfy that Plan and then for each of those AICmds run Eval on it.
				    -that eval then could look at the blackboard and see if there:
					     -is a flanking desire (and give a higher rating)
                         -desire for more dudes on rooftops



*/