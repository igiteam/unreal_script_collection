/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAI_PacifierBot extends NanoAI_Combat
	DependsOn(NanoPawn_MetaCorp_PacifierBotBase)
	native(AI);

cpptext
{
	// Interface_NavigationHandle
	virtual void SetupPathfindingParams( FNavMeshPathParams& out_ParamCache );
}

var() transient NanoPawn_MetaCorp_PacifierBotBase	Bot;

// SOUND VARS //
var(Sound) float LastDamageVoiceTime;

// Basic Ideas:
// *DONE* Target individual arms, eyes, legs, etc.
// *DONE* All weapons able to target seperate actors (other player or civilians throwing stones)
// *DONE* Movement is towards the 'primary target' ... whatever the bot's target is, but weapons can then pick from all stimuli and engage them
// (maybe choose a limb every so often as the primary limb which engages the primary target, and all other limbs must pick secondary ones)

// *DONE* Two parts: Lower body Chassis and Upper Body which can detatch and hover/fly
// *DONE* Tattler bots dock in eye sockets
//		if all can be destroyed, pacifier is blind
// *DONE* Grabby hand
// *DONE* Cut off individual legs... autoadjust animation and/or abandon Chassis for fly mode if too badly damaged
// *DONE* Backpack with rockets can be pinata-ed to drop rockets at its feet as shotable `splody tanks

var(Debug) bool bDummyAI;

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess(NewPawn, bVehicleTransition);

	Bot = NanoPawn_MetaCorp_PacifierBotBase(Pawn);
	Bot.Init();
}


function OnAIStateTransition(SeqAct_AIStateTransition Action)
{
    bShouldAttackPlayersWithoutWeaponsVisible = Action.bShouldAttackPlayersWithoutWeaponsVisible;

	switch (Action.DesiredState)
	{
		case TS_AIControlled:
			bIsScripted = FALSE;
			TransitionTo('Idle', TRUE);
			break;
		case TS_Idle:
			ScriptedTransitionTo('Idle');
			break;
		case TS_Alert:
			break;
		case TS_Combat_Ranged:
			break;
		case TS_Combat_Melee:
			break;
		case TS_Patrol:
			break;
	}
}

final function EnableAllWeapons()
{
	if( !bDummyAI )
	{
		Bot.EnableAllLimbs( TRUE );
	}
}

final function DisableAllWeapons()
{
	Bot.EnableAllLimbs( FALSE );
}


state Idle
{
	simulated function Texture2D GetDebugIcon() { return Texture2D'UI_HUD.AI.T_UI_Debug_Icons_Idle'; }

	function bool ShouldTransitionToCombat()
	{
		local StimulusQuery Query;
		local array<int> StimulusIndices;

		`AILog(GetFuncName()@"...");
		Query.bAllowFriendly = FALSE;
		Query.bAllowNonFriendly = TRUE;
		Query.MinFOV = -1.f;
		Query.MaxFOV = -1.f;
		Query.MinDist = 0.f;
		Query.MaxDist = 4096.f;
		if( MultipleResultStimulusQuery(Query,StimulusIndices) > 0 )
		{
			return TRUE;
		}
		return FALSE;
	}
	
	function PickNewAction();

Begin:
	`AILog( GetStateName()@"Begin TAG" );
	
	PossiblyTransitionTo('Combat',ShouldTransitionToCombat);
	PickNewAction();
	Sleep(1.f);
	Goto('Begin');
}

state Combat
{
	function EndState( Name NextStateName )
	{
		Super.EndState( NextStateName );

		DisableAllWeapons();
		Focus = None;
	}

	function bool ShouldDetachAndHover()
	{
		if( Bot.ShouldUndock() )
		{
			return TRUE;
		}
		return FALSE;
	}

	function bool CanMoveFreely()
	{
		if( Bot.StuckInPlace() )
		{
			return FALSE;
		}
		return TRUE;
	}

	function Name ChooseAction()
	{
		if( ShouldDetachAndHover() )
		{
			return 'DetachAndHover';
		}

		if( CanMoveFreely() )
		{
			if( !CanActivelyAttackTarget( LastErrorCode ) )
			{
				if( LastErrorCode == 'AttackFail_NoLOS' )
				{
					return 'MoveToLineOfSight';
				}
			}
			if( Enemy != None )
			{
				if( !IsPointWithinRange(FireTarget.GetTargetedLocation()) )
				{
					return 'MoveToWithinRange';
				}
			}
		}

		return 'Delay';
	}	

Begin:
	`AILog( GetStateName()@"Begin TAG" );

	// Activate weapons
	EnableAllWeapons();

CombatLoop:
	`AILog( GetStateName()@"CombatLoop TAG" );
	Sleep( 0.1f );
	PossiblyPickFireTarget();
	if( CanMoveFreely() && !bDummyAI )
	{
		Focus = FireTarget;
	}
	else
	{
		Focus = None;
	}

	Goto( ChooseAction() );

MoveToLineOfSight:
	`AILog( "Move until reachable..."@FireTarget );
	class'NanoAICmd_Move_UntilReachable'.static.MoveToPoint( self, FireTarget.GetTargetedLocation(),, TRUE );
	Goto( 'CombatLoop' );

MoveToWithinRange:
	`AILog( "Move until within range..."@FireTarget );
	class'NanoAICmd_Move_UntilInRange'.static.MoveToVisibleActor( self, FireTarget,, 5.f );
	Goto( 'CombatLoop' );

DetachAndHover:
	`AILog( "Undock and hover..." );
	class'NanoAICmd_Pacifier_Undock'.static.Undock( self );
	Goto( 'CombatLoop' );

Delay:	
	`AILog( "Can shoot enemy"@`showvar(FireTarget)@`showvar(LastErrorCode) );
	Sleep(1.f);
	
	Goto( 'CombatLoop' );
}

function bool IsPointWithinRange( Vector Pt )
{
	local float Dist;
	Dist = VSize(Pt-Pawn.Location);
	return Dist < 2048.f;
}

function float RateStimulusForFireTarget(int Index)
{
	local float Rating;
	local NanoPawn NP;

	Rating = -1.f;

	NP = NanoPawn(Stimuli[Index].Actor);
	if( NP != None && !NP.IsDusted() )
	{
		Rating = Stimuli[Index].Priority;
		Rating *= 4096.f/VSize2D(Stimuli[Index].Location - Pawn.Location);
		if (Stimuli[Index].bVisible)
		{
			Rating *= 2.f;
		}
	}		
//	`AILog(GetFuncName()@`showvar(Index)@`showvar(Rating));
	return Rating;
}

function NotifyFireTargetChanged()
{
	if( FireTarget != None )
	{
		SetTimer( FRand()*2.f, FALSE, nameof(PlayTargetVoice) );
	}
	else
	{
		SetTimer( 5.f+FRand()*5.f, FALSE, nameof(PlaySearchVoice) );
	}
}

function PlaySearchVoice()
{
	if( FireTarget == None )
	{
		Bot.PlayVoiceOver_Search();
		SetTimer( 5.f+FRand()*15.f, FALSE, nameof(PlaySearchVoice) );
	}
}

function PlayTargetVoice()
{
	if( FireTarget != None )
	{
		Bot.PlayVoiceOver_Target();
		SetTimer( 5.f+FRand()*15.f, FALSE, nameof(PlayTargetVoice) );
	}
}

function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
{
	if( `TimeSince(LastDamageVoiceTime) > 3.f )
	{
		LastDamageVoiceTime = WorldInfo.TimeSeconds;
		Bot.PlayVoiceOver_Damage();
	}
}

defaultproperties
{
	bDummyAI=FALSE
}
