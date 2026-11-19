/**
 * 
 * BullRam:
 * 
 * Wanted Behavior:
 * Scan - Disruptor scans the area for the ideal path to run into as many troublemakers as possible. Ideally it targets a human player over anythign else.
 * Acquire target - Once the path has been acquired it prepares for its telegraph.
 * Telegraph - Disruptor stomps its feet and charges up its electro horns.
 * Charge - any foes hit will go flying and it will keep moving through them for N feet or until it hits a wall
 * Return to Scan
 * 
 * 
 * Has large curled "ram" like coils on its head that charge up with electricity which can send a foe flying a great distance. It activates its coils and then charges in a straight line until it hits something. 
 *
 * Players can cut off either coil with their sword. First couple of swipes lop off the first one, next time the second coil is cut off.
Has a tail with a club like device on the end of it that can be used to smash and stomp.
 * 
 * Players who are good can get up above or behind it where it has a "smartjump" location on its back and ride it for a few seconds ("Mechanical Bull" style) before driving their swords into its neck, finishing it. 
 * 
 * Players who dense up before it hits them cause it severe damage and it pulls back, stunned, and has to "shake it off." Each time this happens one coil breaks. (This should damage the robot.)
 * 
 * Once both coils are broken the Disruptor stops charging and simply runs around with its tail bashing side to side.
 * 
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAI_BullRam extends NanoAI_Combat
	config(AI)
    native(AI);

var transient NanoPawn_MetaCorp_BullRamBase MyBull;



var transient vector ChargeLocation;




event Possess( Pawn NewPawn, bool bVehicleTransition )
{
	Super.Possess( NewPawn, bVehicleTransition );
	MyBull = NanoPawn_MetaCorp_BullRamBase(NewPawn);

	class'BoidRule_BullRam'.static.AddRule( self, TRUE );
	SetActiveBoidMovementByClass( class'BoidRule_BullRam', TRUE );

	//GotoState( 'Idle' );
}


//delegate IdleQueryTripped( int StimulusIdx, optional array<PlanIncreaseDatum> AIPlansRatingToIncrease );

// state Idle
// {
// 	simulated function Texture2D GetDebugIcon() { return Texture2D'UI_HUD.AI.T_UI_Debug_Icons_Idle'; }
// 
// 	function BeginState(Name PrevStateName)
// 	{
// 		NanoPawn(Pawn).DestroyCurrentWeapon();
// 		SetMood(AIMood_Unaware);
// 
// 		PassiveQueries.AddItem(IdleQuery);
// 	}
// 
// 	function EndState(Name NextStateName)
// 	{
// 		RemoveQuery(IdleQuery);
// 		Super.EndState(NextStateName);
// 	}
// 
// 	delegate IdleQueryTripped( int StimulusIdx, optional array<PlanIncreaseDatum> AIPlansRatingToIncrease )
// 	{
// 		TransitionTo('Alert');
// 	}
// 
// 
// Begin:
// 	`AILog( GetStateName()@"Begin TAG" );
// 	if (!IsCloseEnoughToDefensePoint())
// 	{
// 		//`AILog( "Move Moving Moving to:" @ GetClosestDefensePoint() );
// 		MoveToActor( GetClosestDefensePoint());
// 	}
// 	Sleep(1.f);
// 	Goto('Begin');
// }
// 
// 
// 
// state Alert `DEBUGSTATE
// {
// 	simulated function Texture2D GetDebugIcon() { return Texture2D'UI_HUD.AI.T_UI_Debug_Icons_Alert'; }
// 
// 	function bool ShouldTransitionToCombat()
// 	{
// 		local array<int> StimulusIndices;
// 
// 		if( `TimeSince(TimeOfTransition) > 1.f )
// 		{
// 			if( MultipleResultStimulusQuery( MeleeEngageThreatQuery, StimulusIndices ) > 0 )
// 			{
// 				return TRUE;
// 			}
// 		}
// 		return FALSE;
// 	}
// 
// 	function bool ShouldTransitionToIdle()
// 	{
// 		return `TimeSince(LastTimeNoticedAlertStimuli) > 5.f && !ShouldTransitionToCombat();
// 	}
// 
// 	function float RateStimulusForAlertAction(int Index)
// 	{
// 		local float Rating;
// 
// 		Rating = Stimuli[Index].Priority;
// 		Rating *= 1024.f/(Max( VSize2D(Stimuli[Index].Location - Pawn.Location), 1 ) );
// 
// 		if (Stimuli[Index].bVisible)
// 		{
// 			Rating *= 2.f;
// 		}
// 
// 		if( Stimuli[Index].bCombative )
// 		{
// 			Rating *= 2.f;
// 		}
// 
// 		`AILog(GetFuncName()@`showvar(Index)@`showvar(Rating));
// 
// 		return Rating;
// 	}
// 
// 	function PickNewAction()
// 	{
// 		local array<int> StimulusIndices;
// 		local int Index, BestIndex;
// 		local float StimulusRating, BestStimulusRating;
// 		local float DotToStimulus, DistToStimulus;
// 
// 		MultipleResultStimulusQuery( PickNewActionQuery, StimulusIndices );
// 		BestIndex = -1;
// 		BestStimulusRating = 0.f;
// 
// 		foreach StimulusIndices(Index)
// 		{
// 			StimulusRating = RateStimulusForAlertAction(Index);
// 			if (BestIndex == -1 || StimulusRating > BestStimulusRating)
// 			{
// 				BestIndex = Index;
// 				BestStimulusRating = StimulusRating;
// 			}
// 		}
// 
// 	   `AILog("PickNewAction StimulusIndices:"@StimulusIndices.Length);
// 
// 		if( BestIndex >= 0 )
// 		{
// 			LastTimeNoticedAlertStimuli = WorldInfo.TimeSeconds;
// 			DotToStimulus = Normal(Stimuli[BestIndex].Location - Pawn.Location) DOT vector(Pawn.Rotation);
// 
// 			//debug
// 			`AILog("Investigating stimulus - angle:"@DotToStimulus);
// 			DescribeStimulus( BestIndex );
// 
// 			if( DotToStimulus < 0.3f )
// 			{
// 				//debug
// 				`AILog("-> turning towards stimulus location"@"["$Stimuli[BestIndex].Location$"]"@"["$GetFocalPoint()$"]");
// 
// 				if( Stimuli[BestIndex].bVisible )
// 				{
// 					Alert_PendingFocus = Stimuli[BestIndex].Actor;
// 				}
// 				else
// 				{
// 					Alert_PendingFocalPoint = Stimuli[BestIndex].Location;
// 				}
// 				GotoState(GetStateName(),Focus!=None?'TurnTowardsFocus':'TurnTowardsPoint');
// 			}
// 			else
// 			{
// 				DistToStimulus = VSize(Stimuli[BestIndex].Location-Pawn.Location);
// 				if( !Stimuli[BestIndex].bVisible || DistToStimulus > 256.f )
// 				{
// 					//debug
// 					`AILog( "-> move towards best stimulus"@Stimuli[BestIndex].Actor );
// 					ChargeLocation = Stimuli[BestIndex].Location;
// //					GotoState( 'Charge' );
// 					class'NanoAICmd_BullRam_Charge'.static.Charge( self, ChargeLocation, None, 5.0f, TRUE );
// 				}
// 			}
// 		}
// 		else
// 		{
// 			Focus = None;
// 		}
// 	}
// 
// 	function StimulusAdded()
// 	{
// 		if (Stimuli[0].bVisible && !Stimuli[0].bIsFriendly && `TimeSince(TimeOfTransition) > 1.f)
// 		{
// 			`AILog("Visible enemy noted, checking combat transition");
// 			//PossiblyTransitionTo('Combat',ShouldTransitionToCombat);
// 		}
// 	}
// 
// 	function BeginState(Name PrevStateName)
// 	{
// 		SetMood(AIMood_Alert);
// 		SetFireTarget( None );
// 		InitBoidRulesForState();
// 		LastTimeNoticedAlertStimuli = WorldInfo.TimeSeconds;
// 	}
// 
// 	function EndState( Name NextStateName )
// 	{
// 		Super.EndState( NextStateName );
// 		SetActiveBoidMovementByClass( class'BoidRule_BullRam', FALSE );
// 	}
// 
// 	function InitBoidRulesForState()
// 	{
// 		SetActiveBoidMovementByClass( class'BoidRule_BullRam', TRUE );
// 	}
// 
// 
// Begin:
// 	`AILog( GetStateName()@"Begin TAG" );
//     PickNewAction();
//     Sleep(0.1f);
// 
// 	`AILog( "Alert state looping " @ Focus );
// 	Goto('Begin');
// 
// 
// TurnTowardsFocus:
// 	Sleep(0.10f);
// 	`AILog( GetStateName()@"TurnTowardsFocus TAG" );
// 	Focus = Alert_PendingFocus;
// 	do
// 	{
// 		Sleep(0.25f);
// 		if( Focus == none )
// 		{
// 			break;
// 		}
// 		`AILog("updated angle"@(Normal(Focus.Location - Pawn.Location) dot vector(Pawn.Rotation) > 0.3)@Focus);
// 	} until (Normal(Focus.Location - Pawn.Location) dot vector(Pawn.Rotation) > 0.3);
// 	Goto('Begin');
// 
// TurnTowardsPoint:
// 	Sleep(0.10f);
// 	`AILog( GetStateName()@"TurnTowardsPoint TAG" );
// 	SetFocalPoint(Alert_PendingFocalPoint);
// 	do 
// 	{
// 		Sleep(0.25f);
// 		`AILog("updated angle"@Normal(GetFocalPoint() - Pawn.Location) dot vector(Pawn.Rotation)@GetFocalPoint());
// 	} until (Normal(GetFocalPoint() - Pawn.Location) dot vector(Pawn.Rotation) > 0.3);
// 	Goto('Begin');
// }


/** If an AI registeres with an tesla coil it can receive a notification that the tesla was destroyed **/
function TeslaCoilWeCareAboutWasDestroyed( const TeslaCoil InTesla, Controller InstigatedBy )
{
	// so if one of our tesla coils was killed
	if( ( MyBull.HornLeft == InTesla ) || ( MyBull.HornRight == InTesla ) )
	{
		if( ( NanoPC(InstigatedBy) != none ) && ( MyBull.IsThereARiderOnMe( NanoPawn(NanoPC(InstigatedBy).Pawn) ) == TRUE ) )
		{
			MyBull.KickRiderOff( NanoPawn(NanoPC(InstigatedBy).Pawn) );
		}

        if( MyBull.HornLeft == InTesla )
        {
			//`log( "left none" );
			MyBull.HornLeft = none;
        }

        if( MyBull.HornRight == InTesla )
	    {
			//`log( "right none" );
			MyBull.HornRight = none;
        }

	}
}



defaultproperties
{

	ListOfAIActionsThisAICanDo.Empty()
	//ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Idle_StandAround' )
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_ConfrontPossibleThreat_MoveDirectlyToward_SmashInto' )

	//ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_EngageThreat_Trooper_Melee' )

	NavMeshPath_SearchExtent_Modifier=(X=-60,Y=-60,Z=0)
}