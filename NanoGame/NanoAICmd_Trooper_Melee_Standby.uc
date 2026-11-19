/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Trooper_Melee_Standby extends NanoAICmd_Trooper_MeleeBase within NanoAI_Trooper
	config(AI);


static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Retval;
	local NanoAIBlackboard Blackboard;
	local TargetableOctreeComponent Targetable;
	local bool bMeleeRingsHaveRoom;


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


	Blackboard = InAI.GetBlackBoard();

	// so if there is a showcase foe out and engaged in melee
	// and we are not a showcase foe
	if( ( Blackboard.bShowcaseFoeEngagedInMelee == TRUE )
		&& ( NanoPawn_MetaCorpBase(InAI.Pawn).IsShowcaseForForMelee() == FALSE )
		)
	{
		// don't do this cmd.  By not doing this higher rated command we will end up doing Melee_Spectator which will push everyone back away from the SpecialMelee attack
		return 0;
	}


	Targetable = InAI.FireTarget.GetTargetableOctreeComponent();

	if( Targetable.bHasOverridesForMeleeListRanges == TRUE )
	{
		bMeleeRingsHaveRoom = ( Targetable.MeleeStandByList.Length < Targetable.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeStandby );
	}
	else
	{
		bMeleeRingsHaveRoom = ( Targetable.MeleeStandByList.Length < Blackboard.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeStandby );
	}


	if( ( bMeleeRingsHaveRoom == TRUE )
		|| ( Targetable.MeleeStandByList.Find(InAI) != INDEX_NONE )
		)
	{
		Retval = 25;
	}

	return Retval;
}


function Pushed()
{ 
	Super.Pushed();
	FireTarget.GetTargetableOctreeComponent().MeleeStandByList.AddItem( Outer );

	PossiblyPickFireTarget();

	RegisterAsActiveAttacker();

	Focus = FireTarget; // our focus for a melee target should always be our FireTarget
	SetConfrontationType( ECFT_Melee_Standby );

	if( NanoWeap_Baton(Pawn.Weapon) != none )
	{
		NanoWeap_Baton(Pawn.Weapon).KillGlow();
	}
}


function Resumed( Name OldCommandName )
{ 
	Super.Resumed( OldCommandName );

	SetConfrontationType( ECFT_Melee_Standby );

	if( NanoWeap_Baton(Pawn.Weapon) != none )
	{
		NanoWeap_Baton(Pawn.Weapon).KillGlow();
	}
}



function Popped()
{ 
	Super.Popped();
	FireTarget.GetTargetableOctreeComponent().MeleeStandByList.RemoveItem( Outer );
	UnregisterAsActiveAttacker();
}


/** This will shout out a taunt! **/
function ShoutOutATaunt()
{
	//NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_Combat_StandbyCircle_SustainedBattle,Pawn);
}



state Melee_Standby `DEBUGSTATE
{
	function BeginState( Name PrevStateName )
	{
		Super.BeginState( PrevStateName );

		Focus = FireTarget;


		SetTimer( (0.5f + (FRand() * 4.0f)), FALSE, nameof(ShoutOutATaunt), self );
	}


Begin:
	`AILog( GetStateName() @ "BEGIN TAG" );

	FindAndActivateBestSubCmd();

	if( IsTimerActive( nameof(DoWaitingToAttackSpecialMove), self ) == FALSE )
	{
		//`log( "setting time for DoWaitingToAttackSpecialMove" );
		SetTimer( (0.5f + (FRand() * 3.0f)), FALSE, nameof(DoWaitingToAttackSpecialMove), self );
	}

	Sleep( 0.1f );

	Goto( 'Begin' );
}


defaultproperties
{
	StartingStateName="Melee_Standby"

	WaitingToAttackSpecialMoveName="NSM_Trooper_IdleBreak_Standby"

	ListOfCmdsCanDo.Add(class'NanoAICmd_Trooper_Melee_MoveInRange')

	ListOfCmdsCanDo.Add(class'NanoAICmd_Trooper_Attack_ChargeGrab')
	ListOfCmdsCanDo.Add(class'NanoAICmd_Trooper_Attack_ChargeAttack')
}


