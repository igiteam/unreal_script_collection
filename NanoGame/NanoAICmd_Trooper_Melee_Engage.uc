/**
 * I am engaged with the FireTarger and choosing what action to do to attack them 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Trooper_Melee_Engage extends NanoAICmd_Trooper_MeleeBase within NanoAI_Trooper
	config(AI);


static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;
	local NanoAIBlackboard Blackboard;
	local NanoAIBase AI;
	local TargetableOctreeComponent Targetable;
	local bool bMeleeRingsHaveRoom;
	//local FiringTargetableDatum FTD;


	if( InAI.FireTarget == None )
	{
		`AILog_Ext( GetFuncName() @ "FireTarget is None!!",, InAI );
		return 0;
	}

	if( InAI.FireTarget.IsTargetable() == FALSE ) // something is not clearing the firetarget correctly
	{
		`AILog_Ext( GetFuncName() @ "Invalid FireTarget!!" @ `showvar(InAI.FireTarget) @ `showvar(InAI.FireTarget.IsTargetable()),, InAI );
		return 0;
	}


	Targetable = InAI.FireTarget.GetTargetableOctreeComponent();

	if( Targetable == None )
	{
		`log( "???????????" @ `showvar(Targetable) @ `showvar(InAI.FireTarget) @ `showvar(InAI.Focus) @ `showvar(InAI.Enemy) @ `showvar(InAI.FireTarget.IsTargetable()) );
	}


	Blackboard = InAI.GetBlackBoard();


	// if we are not allowed to attack
	if( ( NanoPawnBase(InAI.Pawn).NextAllowedAttackTime > InAI.WorldInfo.TimeSeconds )
		&& ( InAI.bMAI_OverrideAttackPacing == FALSE )
		)
	{
		return 0;
	}


	// so if there is a showcase foe out and engaged in melee
	// and we are not a showcase foe
	if( ( Blackboard.bShowcaseFoeEngagedInMelee == TRUE )
		&& ( NanoPawn_MetaCorpBase(InAI.Pawn).IsShowcaseForForMelee() == FALSE )
		)
	{
		// don't do this cmd.  By not doing this higher rated command we will end up doing Melee_Spectator which will push everyone back away from the SpecialMelee attack
		return 0;
	}

	//InAI.FireTarget.GetFiringTargetableDatum( FTD );


	if( Targetable.bHasOverridesForMeleeListRanges == TRUE )
	{
		bMeleeRingsHaveRoom = ( Targetable.MeleeEngageList.Length < Targetable.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeEngage );
	}
	else
	{
		bMeleeRingsHaveRoom = ( Targetable.MeleeEngageList.Length < Blackboard.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeEngage );
	}



	if( ( bMeleeRingsHaveRoom == TRUE )
		|| ( Targetable.MeleeEngageList.Find(InAI) != INDEX_NONE )
		|| ( ( NanoPawn_Infantry(InAI.Pawn).MeleeEngagePriorityLevel > 0 ) && ( AreThereAnyNonPriorityTargetsInMeleeRangeList( AI, NanoPawn_Infantry(InAI.Pawn).MeleeEngagePriorityLevel ) == TRUE ) )
		)
	{
		Retval = 55;
	}
	//else
	//{
		//`log( InAI @ "MeleeEngageListIsFull" @ Blackboard.MeleeEngageList.Length );
		//foreach Blackboard.MeleeEngageList( AI )
		//{
		//	`log( "  " @ AI @ AI.Pawn );
		//}
	//}

	// AHH???
	// this should make it so that we get priority if we are firing a weapon (including grabbing)
	if( InAI.Pawn.Weapon != None && InAI.Pawn.Weapon.IsFiring() == TRUE )
	{
		Retval += 90;
	}


	// give us an extra bonus if we just attacked.  This is used to help break ties due to
	// people leaving the MeleeEngageList and there being opening which everyone sees during their GetUtility
	// call.  Without something like this, we will have N AI all with 55 and then it is order dependent again.
	// which results in AIs seemingly swapping in and out of MeleeEngage position
	// NOTE: making this smaller will allow the order of FindAllNanoPawnsAroundPlayerPawn matter in determining
	//       who will win in ties
	if( `TimeSinceEx(InAI, InAI.LastMeleeAttackTime) < 4.0f )
	{
		Retval += 5;
	}
	

	// only give CombatResponse utility if there is actually room in the list
	// NOTE:  maybe move this above to replace the 55?
	if( ( bMeleeRingsHaveRoom == TRUE )
		|| ( Targetable.MeleeEngageList.Find(InAI) != INDEX_NONE )
		)
	{
		Retval += InAI.CombatResponse[ERT_Attack];
	}

	
	return Retval;
}


function GetDebugOverheadText( PlayerController PC, out array<string> OutText )
{
	OutText.AddItem( "NextAttack:" @ SavedCurrPacingValue @ " Attack:" @ SavedCurrAttackValue);
}


/** 
 * Look in the MeleeEngageList and see if there are non priority AIs in there that we could remove
 * to place in a high priority.
 **/
static function bool AreThereAnyNonPriorityTargetsInMeleeRangeList( out NanoAIBase out_AI, const float PriorityToTest )
{
	local bool Retval;
	local NanoAIBase AI;
	local TargetableOctreeComponent Targetable;

	// just checks the Player for now
	Targetable = NanoInterface_Targetable(NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetNanoPC().Pawn).GetTargetableOctreeComponent();


	foreach Targetable.MeleeEngageList( AI )
	{
		if( NanoPawn_Infantry(AI.Pawn).MeleeEngagePriorityLevel < PriorityToTest )
		{
			out_AI = AI;
			Retval = TRUE;
			break;
		}
	}

	return Retval;
}



function Pushed()
{ 
	local NanoAIBase AI;
	local NanoAIBlackboard Blackboard;
	local NanoPawn_MetaCorpBase MCB;
	local TargetableOctreeComponent Targetable;

	Super.Pushed();

	Blackboard = GetAIBlackboard();
	Targetable = FireTarget.GetTargetableOctreeComponent();

	AI = Outer;

	// so if we are a melee priority and the list is full and we are not in list
	// then we need to look at the list and remove anyone who is also not a high priority
	if( ( NanoPawn_Infantry(Pawn).MeleeEngagePriorityLevel > 0 )
		&& ( Targetable.MeleeEngageList.Length >= Blackboard.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeEngage )
		&& ( Targetable.MeleeEngageList.Find(Outer) == INDEX_NONE )
		)
	{
		if( AreThereAnyNonPriorityTargetsInMeleeRangeList( AI, NanoPawn_Infantry(AI.Pawn).MeleeEngagePriorityLevel ) == TRUE )
		{
			`AILog( "ABORTING!!!! AreThereAnyNonPriorityTargetsInMeleeRangeList" @ AI );
			//`log( "We found a non high priority in the melee engage list and we are kicking him out of the list" @ AI.Pawn );
			Targetable.MeleeEngageList.RemoveItem( AI );
			AI.AbortCommand( None, default.Class );
		}
	}


	// need to handle race conditions here

	// if the MeleeEngageList is full
	// AND I am not in that list already
	if( ( Targetable.MeleeEngageList.Length >= Blackboard.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeEngage )
		&& ( Targetable.MeleeEngageList.Find(Outer) == INDEX_NONE )
		)
	{
		`AILog( "ABORTING!!!! Due To Race Condition on MeleeEngageList Insertion" @ Outer );
		Status = 'Failure';
		AbortCommand( self );
		return;
	}


	Targetable.MeleeEngageList.AddItem( Outer );

	MeleeCircleAllowedToAttackTime = WorldInfo.TimeSeconds + RandRange( MeleeCircleReadyToFightPostArrivalRange.X, MeleeCircleReadyToFightPostArrivalRange.Y );

	//if( Targetable.MeleeEngageList.Find(Outer) == INDEX_NONE )
	//{
	//	`log( Outer @ "I am Pushing!!!" @ Targetable.MeleeEngageList.Length );
	//	
	//	`log( "  " @ Outer @ "Adding Self!!!" @ Targetable.MeleeEngageList.Length );
	//}

	SetConfrontationType( ECFT_Melee_Engaged );

	PossiblyPickFireTarget();

	RegisterAsActiveAttacker();

	Focus = FireTarget; // our focus for a melee target should always be our FireTarget

	// if there is no one left!!
	if( ( Targetable.MeleeStandByList.Length == 0 ) && ( Targetable.MeleeSpectatorList.Length == 0 ) )
	{
		// for now just turn this off
		//NanoGRI(WorldInfo.GRI).AttemptToPlayLine( EDLine_Combat_StandbyCircle_LastTrooperFromStandByEnteringMelee, Pawn );
	}
	// if we just moved from standby into melee
	else if( LastConfrontationType == ECFT_Melee_Standby )
	{
		NanoGRI(WorldInfo.GRI).AttemptToPlayLine( EDLine_Combat_StandbyCircle_EnteringMeleeCircle, Pawn );
	}
	// if we entered into melee and were not in there before
	else if( LastConfrontationType != ECFT_Melee_Engaged )
	{
		NanoGRI(WorldInfo.GRI).AttemptToPlayLine( EDLine_Combat_MeleeCircle_Commence, Pawn );
	}

	if( NanoWeap_Baton(Pawn.Weapon) != none )
	{
		NanoWeap_Baton(Pawn.Weapon).ActivateGlow();
	}

	MCB = NanoPawn_MetaCorpBase(Pawn);
	if( MCB != None )
	{
		// so here need to check to see if this guy should be a "showcase" battle
		if( MCB.IsShowcaseForForMelee() == TRUE )
		{
			Blackboard.bShowcaseFoeEngagedInMelee = TRUE;
		}
	}


	
}

function Popped()
{ 
	//`log( Outer @ "I am popping!!!" @ GetAIBlackboard().MeleeEngageList.Length );
	Super.Popped();

	FireTarget.GetTargetableOctreeComponent().MeleeEngageList.RemoveItem( Outer );
	//`log( "  " @ Outer @ "Removed Self!!!" @ GetAIBlackboard().MeleeEngageList.Length );

	UnregisterAsActiveAttacker();

	SetConfrontationType( ECFT_None );
}

// do something diff
// @TODO:  handle hit reactions when you hit  via calling self.TickAction
function Resumed( Name OldCommandName )
{
	if( OldCommandName == 'NanoAICmd_HitReaction' )
	{
		// Otherwise, start over
		GotoState( GetStateName(), 'Begin' );
	}

	SetConfrontationType( ECFT_Melee_Engaged );
}

/** This will shout out a taunt! **/
function ShoutOutATaunt()
{
	NanoGRI(WorldInfo.GRI).AttemptToPlayLine( EDLine_Combat_MeleeCircle_SustainedBattle, Pawn );
}

state Melee_Engaged `DEBUGSTATE
{

	function BeginState( Name PrevStateName )
	{
		Super.BeginState( PrevStateName );
		
		if( FRand() < 0.10f )
		{
			ShoutOutATaunt();
		}
	}

	function EndState( Name NextStateName )
	{
		Super.EndState( NextStateName );

		HandleBoidAlteringEvent( 'WaitingForAttackToFinish', TRUE );
	}


Begin:
	`AILog( GetStateName() @ "BEGIN TAG" );

	CurrTargetable = FireTarget.GetTargetableOctreeComponent();


	// if I am allowed to attack
	if( CurrTargetable.NumCurrentlyMeleeing >= GetAIBlackboard().MeleeListRanges[GetAIBlackboard().CachedCurrChaosTier].NumMeleeFireTickets )
	{
		//`log( " too many " @ `showvar(GetAIBlackboard().NumCurrentlyMeleeing) @ `showvar(GetAIBlackboard().MeleeListRanges[GetAIBlackboard().CachedCurrChaosTier].NumMeleeFireTickets) );
		//`AILog( GetStateName() @ "Too many people all shooting at once: " @ `showvar(GetAIBlackboard().NumCurrentlyMeleeing) @ `showvar(GetAIBlackboard().MeleeListRanges[GetAIBlackboard().CachedCurrChaosTier].NumMeleeFireTickets) );
		Sleep( 0.1f );
		Goto( 'Begin' );
	}


	FindAndActivateBestSubCmd();

	//// Clean up
AttackFinished:
	`AILog( Outer @ "attack finished" );

	`AILog( GetStateName()@"Attack Completed TAG" );

	Sleep( 0.1f );

	Goto( 'Begin' );
}



defaultproperties
{
	StartingStateName="Melee_Engaged"
	
	bAllowAntiBoidJitterCode=FALSE

	ListOfCmdsCanDo.Add(class'NanoAICmd_Trooper_Melee_MoveInRange')

	//ListOfCmdsCanDo.Add(class'NanoAICmd_Trooper_Attack_BreakOut')

	//ListOfCmdsCanDo.Add(class'NanoAICmd_Trooper_Attack_Trip' )
	//ListOfCmdsCanDo.Add(class'NanoAICmd_Trooper_Attack_Grab')
	ListOfCmdsCanDo.Add(class'NanoAICmd_Trooper_Attack_GrabAndBeat')
	ListOfCmdsCanDo.Add(class'NanoAICmd_Trooper_Attack_Melee')
	ListOfCmdsCanDo.Add(class'NanoAICmd_Trooper_Attack_GroundPound')
}


