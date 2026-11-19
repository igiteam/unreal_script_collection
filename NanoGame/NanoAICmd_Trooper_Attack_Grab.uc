/** 
 * AI Command that handles melee grab attack
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoAICmd_Trooper_Attack_Grab extends NanoAICmd_Trooper_Attack_Base within NanoAI_Trooper
	config(AI);

var transient float		GrabTimeRemaining;
var transient NanoPawn	VictimPawn;
var float		GrabDotThresh;

/** Whether or not this should not check for LOS before grabbing **/
var transient bool bForced;

/** How many attackers are required to allow us to grab. **/
var int MinNumAttackerRequiredToGrab;


static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Rating;
	local NanoAI_Trooper AI;
	local Vector VectToTarget;
	local float	 VectToTargDotTargRot;
	local NanoPawn FT;
	local int NumAttackers;
	local FiringTargetableDatum FTD;
	local TargetableOctreeComponent Targetable;


	if( NanoPawnBase(InAI.Pawn).bHasShield == TRUE )
	{
		return 0;
	}

	if( InAI.GetBlackBoard().bMAI_DoAGrabAttack == TRUE )
	{
		`AILog_Ext( "Doing a Manual AI Grab attack",, InAI );
		InAI.GetBlackBoard().bMAI_DoAGrabAttack = FALSE; // ??? maybe on popped
		return 110;
	}



	// to do a grab we will be in ECFT_Melee_Engaged 
	// if we are not IsInRange for ECFT_Melee_Engaged then we should not attempt to even do a grab attack
	if( IsInRange( InAI) == FALSE  )
	{
		return 0;
	}


	InAI.FireTarget.GetFiringTargetableDatum( FTD );

	// don't attack if the target is stunned
	if( FTD.bIsTeslaShockStunned == TRUE )
	{
		//`log( "Don't attack! bIsTeslaShockStunned" );
		return 0;
	}

	AI = NanoAI_Trooper(InAI);
	if( AI != None )
	{
		FT = NanoPawn(AI.FireTarget);
		if( FT != None && FT.Physics != PHYS_Falling && FT.InteractionPawn == None )
		{

			Targetable = InAI.FireTarget.GetTargetableOctreeComponent();

			NumAttackers = Targetable.MeleeEngageList.Length;
			// Don't grab if there is no one else to attack grab victim
			if( NumAttackers > default.MinNumAttackerRequiredToGrab )
			{
				// always go for a grab attempt if we are allowed to
				if( `TimeSinceEx(AI, AI.MyTrooper.LastGrabAttemptTime) > AI.MyTrooper.MinTimeBetweenGrabAttempts && 
					`TimeSinceEx(AI, FT.LastGrabbedTime) > FT.MinTimeBetweenGrabVictim )
				{
					VectToTarget = Normal(AI.FireTarget.GetTargetedLocation() - AI.Pawn.Location);
					VectToTargDotTargRot = VectToTarget DOT Vector(AI.FireTarget.GetRotation());

					// Behind the target (GrabDotThresh == -1), always grab
					if( VectToTargDotTargRot > default.GrabDotThresh )
					{
						Rating += 110;
					}

					//`log( AI.Pawn@"Try To Grab"@FT@`showvar(VectToTargDotTargRot)@`showvar(default.GrabDotThresh)@`showvar(AI.FireTarget) );
					//AI.Pawn.DrawDebugLine( AI.Pawn.Location + VectToTarget * 64.f, AI.Pawn.Location, 255, 0, 0, TRUE );
					//AI.Pawn.DrawDebugLine( AI.Pawn.Location + Vector(AI.FireTarget.GetRotation()) * 64.f, AI.Pawn.Location, 0, 255, 0, TRUE );
				}
			}
		}
	}

	return Rating;
}

static final function Grab( NanoAI_Trooper AI, optional bool bInForced )
{
	local NanoAICmd_Trooper_Attack_Grab Cmd;

	if( AI != None )
	{
		Cmd = new(AI) default.class;
		if( Cmd != None )
		{
			Cmd.bForced = bInForced;
			AI.PushCommand( Cmd );
		}
	}
}

function Pushed()
{
	Super.Pushed();

	HandleBoidAlteringEvent( 'WaitingForGrabToFinish', FALSE );
	SetConfrontationType( ECFT_Melee_Attacking );

	VictimPawn = NanoPawn(FireTarget);
	if( VictimPawn != None )
	{
		VictimPawn.LastGrabbedTime = WorldInfo.TimeSeconds;
	}

	GotoState( 'GrabAttempt' );
}

function Popped()
{
	Super.Popped();

	HandleBoidAlteringEvent( 'WaitingForGrabToFinish', TRUE );
	SetConfrontationType( ECFT_Melee_Engaged );

	StopFiring();
	Focus = FireTarget;

	ModifyActiveBoidMovement_AvoidTeammates( TRUE );
	ModifyActiveBoidMovement_UseMinEnemyLocationChangeToUpdate( TRUE );
	ModifyActiveBoidMovement_AntiTwitchDelta( 32.0f );

	MyTrooper.LastGrabAttemptTime = WorldInfo.TimeSeconds;
	ClearTimer( nameof(self.AttackTimedOut), self);
}

function Resumed( name OldCommandName )
{
	Super.Resumed( OldCommandName );

	if( OldCommandName != 'NanoAICmd_SpecialMoveStub' )
	{
		Status = 'Failure';
		PopCommand( self );
	}
}

function AttackTimedOut()
{
	`AILog( `location );

	Status = 'Failure';
	PopCommand( self );
}

state GrabAttempt `DEBUGSTATE
{
	function bool IsInGrabRange()
	{
		local Vector VectToTarg;
		local NanoWeap_Melee Weap;

		Weap = NanoWeap_Melee(Pawn.Weapon);
		if( Weap != None )
		{
			VectToTarg = (FireTarget.GetTargetedLocation()-Pawn.Location);
			if( VSize(VectToTarg) <= 175.f )
			{
				return TRUE;
			}
		}
		return FALSE;
	}


Begin:
	`AILog( GetStateName()@"BEGIN TAG" );

	//`log( Outer @ "START OH!!!");
	// Setting this bool makes the ModifyPawnVelocity if( bAvoidTeammates ) check not pass so 
	// that this pawn will barrel through.  His teammates should then move out of the way as 
	// they will be bAvoidTeammates from the melee boid rule.
	ModifyActiveBoidMovement_AvoidTeammates( FALSE );
	ModifyActiveBoidMovement_UseMinEnemyLocationChangeToUpdate( FALSE );
	ModifyActiveBoidMovement_AntiTwitchDelta( 0.0f );

	// Focus on who we want to grab
	Focus = FireTarget;

	// check to see if we have the correct weapon to do a grab attack
	if( NanoWeap_Melee(Pawn.Weapon) == None )
	{
		Sleep( MyTrooper.SpawnNanoBaton() );
	}


	if( IsInGrabRange() == FALSE )
	{
		HandleBoidAlteringEvent( 'WaitingForAttackToFinish', TRUE );
		SetTimer( 3.f, FALSE, nameof(self.AttackTimedOut), self);
		// this should allow the pawn to move up and grab the enemy
		do
		{
			`AILog( "Moving In for a grab!!!" @ `showvar(VSize(FireTarget.GetTargetedLocation()-Pawn.Location)) @ `showvar(Pawn.Weapon) );
			//`log( Outer @  "  Moving In for a grab!!!" );
			Sleep( 0.1f );
		} until ( IsInGrabRange() );
		ClearTimer( nameof(self.AttackTimedOut), self);
	}


	// If nothing is in our way
	if( ( LineOfSightTo(FireTarget) && !IsFireLineBlocked() ) || bForced )
	{
		// Attempt the grab
		`AILog( "attempting grab!!!" @ bForced );
		//`log( Outer @  "attempting grab!!!" @ bForced );
		Pawn.StartFire( class'NanoWeap_Melee'.const.FIREMODE_Grab );
		do
		{
			`AILog( "Doing grab fire()!!!" );
			//`log( Outer @  "Doing grab fire()!!!" );
			Sleep( 0.1f );
		} until (!Pawn.Weapon.IsFiring());
	}
	else
	{
		`AILog( "NO LINE OF SIGHT FOR GRAB??!" );
		Sleep( 1.f );
	}

	ModifyActiveBoidMovement_AvoidTeammates( TRUE );
	ModifyActiveBoidMovement_UseMinEnemyLocationChangeToUpdate( TRUE );
	ModifyActiveBoidMovement_AntiTwitchDelta( 32.0f );

	//`log( Outer @ "END OH!!!");

	Status = 'Success';
	PopCommand( self );
}

defaultproperties
{
	bReplaceActiveSameClassInstance=TRUE

	GrabDotThresh=-1.f
	MinNumAttackerRequiredToGrab=1
}