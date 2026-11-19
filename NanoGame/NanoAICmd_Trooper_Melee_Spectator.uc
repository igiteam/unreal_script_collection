/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Trooper_Melee_Spectator extends NanoAICmd_Trooper_MeleeBase within NanoAI_Trooper
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



	Targetable = InAI.FireTarget.GetTargetableOctreeComponent();
	Blackboard = InAI.GetBlackBoard();


	if( Targetable.bHasOverridesForMeleeListRanges == TRUE )
	{
		bMeleeRingsHaveRoom = ( Targetable.MeleeSpectatorList.Length < Targetable.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeSpectator );
	}
	else
	{
		bMeleeRingsHaveRoom = ( Targetable.MeleeSpectatorList.Length < Blackboard.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeSpectator );
	}



	if( ( bMeleeRingsHaveRoom == TRUE )
		|| ( Targetable.MeleeSpectatorList.Find(InAI) != INDEX_NONE )
		)
	{
		Retval = 10;
	}


	// meh sort of dirty hack here.  But if we are doing a ChargeAttack we want "spectator" to maintain
	// its top Utility rating so the TickAction doesn't determine that Engage is better and abort Spectator
	// and all of its children
	if( NanoAI_Trooper(InAI).FindCommandOfClass( class'NanoAICmd_Trooper_Attack_ChargeAttack' ) != none )
	{
		Retval += 50;

		if( InAI.Pawn.Weapon.IsFiring() == TRUE )
		{
			Retval += 90;
		}
	}


	return Retval;
}


function Pushed()
{ 
	Super.Pushed();
	FireTarget.GetTargetableOctreeComponent().MeleeSpectatorList.AddItem( Outer );

	SetConfrontationType( ECFT_Melee_Spectator );
	Focus = FireTarget; // our focus for a melee target should always be our FireTarget

	if( NanoWeap_Baton(Pawn.Weapon) != none )
	{
		NanoWeap_Baton(Pawn.Weapon).KillGlow();
	}
	
}


function Resumed( Name OldCommandName )
{ 
	Super.Resumed( OldCommandName );

	SetConfrontationType( ECFT_Melee_Spectator );

	if( NanoWeap_Baton(Pawn.Weapon) != none )
	{
		NanoWeap_Baton(Pawn.Weapon).KillGlow();
	}
}


function Popped()
{ 
	Super.Popped();
	FireTarget.GetTargetableOctreeComponent().MeleeSpectatorList.RemoveItem( Outer );
}


/** This will shout out a taunt! **/
function ShoutOutATaunt()
{
	//NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_Combat_SpectatorCircle_TauntPlayer,Pawn);
}



state Melee_Spectator `DEBUGSTATE
{
	function BeginState( Name PrevStateName )
	{
		Super.BeginState( PrevStateName );

		Focus = FireTarget;

		SetTimer( (0.5f + (FRand() * 6.0f)), FALSE, nameof(ShoutOutATaunt), self );
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
	StartingStateName="Melee_Spectator"

	WaitingToAttackSpecialMoveName="NSM_Trooper_IdleBreak_Spectator"

	ListOfCmdsCanDo.Add(class'NanoAICmd_Trooper_Melee_MoveInRange')

	ListOfCmdsCanDo.Add(class'NanoAICmd_Trooper_Attack_ChargeAttack')
}


