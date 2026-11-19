/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Stunned extends NanoAICmd;

struct StunInfo
{
	var Name StunType;
	var float TimeOfExpiration;
};
var transient array<StunInfo>	StunList;
var transient Name StunAnimName;
var transient bool bStopFire;

var transient Actor SavedFocus;

var transient bool bWasUsingBoids;



/**
 * So sometimes we can get an infinite stun where we want the AI to land or something before they get up.
 * Sadly sometimes we never get a land event.  So we need to have time out of some amount
 **/
var float TimeOutNoMatterWhat;
var transient float TimeToExitStunnedStateDueToTimeOut;


static final function StunAI( GameAIController AI, optional float FixedDuration, optional Name NewStunType, optional Name NewStunAnimName, optional bool bReplaceExisting, optional bool bForceStopFire = TRUE )
{
	local NanoAICmd_Stunned Cmd;
	local int Idx;
	local bool bInfiniteStun, bUpdatedCommand;

	if( AI != None )
	{
		// If already have a stunned command pushed
		Cmd = AI.FindCommandOfClass(default.class);
		if( Cmd != None )
		{
			for( Idx = 0; Idx < Cmd.StunList.Length; Idx++ )
			{
				// If we can find a matching type
				if( Cmd.StunList[Idx].StunType == NewStunType )
				{
					if( bReplaceExisting )
					{
						`AILog_Ext("stun replacement",'Stun',AI);

						Cmd.StunList.Remove( Idx, 1 );
					}
					else
					{
						`AILog_Ext("stun updated"@`showvar(NewStunType)@`showvar(FixedDuration)@"vs"@Cmd.StunList[Idx].TimeOfExpiration-AI.WorldInfo.TimeSeconds,'Stun',AI);

						bUpdatedCommand = TRUE;
						bInfiniteStun = (Cmd.StunList[Idx].TimeOfExpiration == 0.f || FixedDuration <= 0.f);
						if( bInfiniteStun )
						{
							// Clear expiration time if was or is infinite
							Cmd.StunList[Idx].TimeOfExpiration = 0.f;
						}
						else if( (AI.WorldInfo.TimeSeconds + FixedDuration) > Cmd.StunList[Idx].TimeOfExpiration )
						{
							// Otherwise, update the timer if it would leave us stunned longer
							Cmd.StunList[Idx].TimeOfExpiration = AI.WorldInfo.TimeSeconds + FixedDuration;
						}
						
					}
					break;
				}
			}
		}

		if( Cmd == None )
		{
			Cmd = new(AI) class'NanoAICmd_Stunned';
			Cmd.StunAnimName = NewStunAnimName;
			Cmd.bStopFire = bForceStopFire;
			if( Cmd != None )
			{
				AI.PushCommand(Cmd);
			}
		}
		else if( NewStunAnimName != Cmd.StunAnimName )
		{
			Cmd.PlayStunAnim(NewStunAnimName);	
		}

		if( !bUpdatedCommand )
		{
			`AILog_Ext("stun"@`showvar(NewStunType)@`showvar(FixedDuration)@`showvar(NewStunAnimName),'Stun',AI);

			Idx = Cmd.StunList.Length;
			Cmd.StunList.Length = Idx + 1;
			Cmd.StunList[Idx].StunType = NewStunType;
			if( FixedDuration > 0.f )
			{
				Cmd.StunList[Idx].TimeOfExpiration = AI.WorldInfo.TimeSeconds + FixedDuration;
				AI.SetTimer( 0.1f, TRUE, nameof(Cmd.CheckStunTimers), Cmd );
			}
		}
	}
}

static final function UnstunAI(GameAIController AI, optional Name NewStunType)
{
	local NanoAICmd_Stunned Cmd;
	local int Idx;
	
	if( AI != None )
	{
		// If already have a stunned command pushed
		Cmd = AI.FindCommandOfClass(default.class);
		if( Cmd != None )
		{
			for( Idx = 0; Idx < Cmd.StunList.Length; Idx++ )
			{
				if( Cmd.StunList[Idx].StunType == NewStunType )
				{
					`AILog_Ext("unstun"@`showvar(NewStunType)@Cmd.StunList.Length,'Stun',AI);
					Cmd.StunList.Remove( Idx, 1 );
					break;
				}
			}
			if( Cmd.StunList.Length == 0 )
			{
				Cmd.Status = 'Success';
				AI.PopCommand( Cmd );
			}
		}
	}
}


static final function bool IsStunnedBy(GameAIController AI, Name NewStunType)
{
	local NanoAICmd_Stunned Cmd;
	local int Idx;
	
	if( AI != None )
	{
		// If already have a stunned command pushed
		Cmd = AI.FindCommandOfClass(default.class);
		if( Cmd != None )
		{
			for( Idx = 0; Idx < Cmd.StunList.Length; Idx++ )
			{
				if( Cmd.StunList[Idx].StunType == NewStunType )
				{
					return TRUE;
				}
			}
		}
	}

	return FALSE;
}



function CheckStunTimers()
{
	local int Idx;

	`AILog( GetFuncName() @  `showvar(StunList.Length) );

	for( Idx = 0; Idx < StunList.Length; Idx++ )
	{
		if( StunList[Idx].TimeOfExpiration != 0.f && 
			GameAIOwner.WorldInfo.TimeSeconds >= StunList[Idx].TimeOfExpiration )
		{
			StunList.Remove( Idx--, 1 );
		}
	}

	if( StunList.Length == 0 )
	{
		`AILog(`location);
		PopCommand(self);
	}
}

function Pushed()
{
	local NanoAI AI;
	local NanoPawn NP;

	Super.Pushed();

	SavedFocus = Focus;
	Focus = None;

	`AILog(`location);
	if (Pawn != None)
	{
		if (Pawn.Physics == PHYS_Walking)
		{
			Pawn.ZeroMovementVariables();
		}
		if( bStopFire )
		{
			Pawn.StopFire(1);
		}
		NP = NanoPawn(Pawn);
		if( NP != None )
		{
			NP.SetDesiredRotation( Pawn.Rotation, TRUE );
			NP.bStunned = TRUE;
			PlayStunAnim(StunAnimName);
		}		
	}
	GameAIOwner.MoveTimer = -1.f;
	AI = NanoAI(GameAIOwner);
	if (AI != None)
	{
		bWasUsingBoids = AI.bUseBoidMovement;
		AI.SetUseBoidMovement( FALSE );
		if( bStopFire )
		{
			AI.StopFiring();
		}
	}

	TimeToExitStunnedStateDueToTimeOut = WorldInfo.TimeSeconds + TimeOutNoMatterWhat;
}

function PlayStunAnim(Name NewStunAnimName)
{
	local NanoPawn NP;
	NP = NanoPawn(Pawn);
	if (NP != None)
	{
		`AILog(`location@`showvar(NP)@`showvar(NewStunAnimName));
		StunAnimName = NewStunAnimName;
		NP.FullBodySlot.PlayCustomAnim(NewStunAnimName,1.f,0.1f,-1.f,FALSE,TRUE);
	}
}

function Popped()
{
	local NanoAI AI;
	local NanoPawn NP;

	Super.Popped();

	Focus = SavedFocus;
	NP = NanoPawn(Pawn);
	if (NP != None)
	{
		NP.LockDesiredRotation( FALSE );
		NP.bStunned = FALSE;
		if( StunAnimName != '' )
		{
			NP.FullBodySlot.StopCustomAnim(0.1f);
		}
	}
	AI = NanoAI(GameAIOwner);
	if (AI != None)
	{
		AI.SetUseBoidMovement( bWasUsingBoids );
	}
	ClearTimer(nameof(CheckStunTimers),self);
}

function Paused(GameAICommand NewCmd)
{
	`AILog(`location);
	ClearTimer(nameof(CheckStunTimers),self);
}

function Resumed(Name OldCommandName)
{
	`AILog(`location);
	SetTimer(0.1f,TRUE,nameof(CheckStunTimers),self);
}

function bool AllowStateTransitionTo(Name StateName)
{
	return FALSE;
}




state StunnedAndCannotAct `DEBUGSTATE
{
Begin:
	`AILog( GetStateName()@"BEGIN TAG" );

	if( WorldInfo.TimeSeconds > TimeToExitStunnedStateDueToTimeOut )
	{
		`AILog( "Stun State popping self due to timeout!  We were stunned more than:" @ `showvar(TimeToExitStunnedStateDueToTimeOut) );
		Status = 'Success';
		PopCommand( self );
	}


	Sleep( 0.1f );

	Goto( 'Begin' );
}




defaultproperties
{
	StartingStateName="StunnedAndCannotAct"

	bAllowNewSameClassInstance=TRUE

	TimeOutNoMatterWhat=15.0f
}


