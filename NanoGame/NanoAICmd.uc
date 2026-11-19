/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd extends GameAICommand
	native(AI)
	abstract;


/** This bool determines whether or not an AI in this Cmd is allowed to do the anti BOID Jitter code. **/
var bool bAllowAntiBoidJitterCode;



var transient Name StartingStateName;
var transient bool bForceTransition;


var const int UtilityStartVal;
var const int UtilityEndVal;

var transient bool bIdleQueryTripped;

/**
 * This is the set of cmd that this action can do.  Each time this command is looking to progress/choose a behavior it will pick the top rated one
 * (Very similar to how the AIPlanner chooses Actions for AIs!)
 **/
var array< class<NanoAICmd> > ListOfCmdsCanDo;
var transient int BestUtilityRating;
var transient class<NanoAICmd> BestUtilityCmd;
var transient string BestUtilityString;


/** Special move to do when waiting to attack **/
var name WaitingToAttackSpecialMoveName;

static event int GetUtility( AIController InAI )
{
	return InternalGetUtility( NanoAIBase(InAI) );
}

static function int InternalGetUtility( NanoAIBase InAI )
{
	`warn( "NanoAICmd Base Class InternalGetUtility was called.  Please have your Parent Type or your indiv AICmd implement this function" );
	ScriptTrace();
	return -1;
}

/** Use the default nav icon if we don't have a specialized icon.  This will show up in the MoveToLocation AICmd. **/
simulated function Texture2D GetDebugIcon()
{
	return Texture2D'EditorResources.S_NavP';
}




function Pushed()
{
	Super.Pushed();
	GotoState( StartingStateName );
}





static function AIPlanTransitionTo ( NanoAIBase InAI, const bool InbForceTransition )
{
	local NanoAICmd Cmd;

	if( InAI != None )
	{
		Cmd = new(InAI) default.Class; // are calling this function via .static so the class we are calling it on is known
		if( Cmd != None )
		{
			Cmd.StartingStateName = default.StartingStateName;
			Cmd.bForceTransition = InbForceTransition;

			InAI.PushCommand(Cmd);
		}
		else
		{
			`warn( "OH NOES! Cmd is none!" @ `showvar(Cmd) @ `showvar(InAI) @ `showvar(default.Class) );
			ScriptTrace();
		}
	}
}

static final function Activate( NanoAIBase InAI, const out string UtilityString )
{
	local NanoAICmd Cmd;

	if( InAI != None )
	{
		Cmd = new(InAI) default.class;
		if( ( Cmd != None )
			&& ( InAI.Commandlist.class != Cmd.default.Class )
			)
		{
			`AILog_Ext( UtilityString, , InAI );
			`AILog_Ext( "GetBestSubCmd: " @ `showvar(Cmd) , , InAI );
			InAI.PushCommand( Cmd );
		}
	}
}

final function FindAndActivateBestSubCmd()
{
	local class<NanoAICmd> Cmd;
	local string UtilityString;

	Cmd = GetBestSubCmd( UtilityString );
	if( Cmd != None )
	{
		Cmd.static.Activate( NanoAIBase(Outer), UtilityString );
	}
	else
	{
		`AILog_Ext( "FindAndActivateBestSubCmd FAILED to find any valid SubCmds" @ UtilityString, , Outer );
	}
}


function class<NanoAICmd> GetBestSubCmd( out string UtilityString )
{
	local class<NanoAICmd> ACmd;
	local class<NanoAICmd> BestCmd;
	local int CmdRating;
	local int BestRating;

	BestUtilityRating = -1;
	BestUtilityCmd = None;
	BestUtilityString = "";

	UtilityString @= "";

	foreach ListOfCmdsCanDo( ACmd )
	{
		CmdRating = ACmd.static.GetUtility( NanoAIBase(Outer) );
		UtilityString @= ( "   " @ ACmd @ CmdRating @ "\n" );

		if( CmdRating > BestRating )
		{
			BestRating = CmdRating;
			BestCmd = ACmd;
		}
	}

	UtilityString @= ( "    ==>" @ `showvar(BestCmd) @ `showvar(BestRating) @ "\n" );

	BestUtilityRating   = BestRating;
	BestUtilityCmd      = BestCmd;
	BestUtilityString   = UtilityString;

	return BestCmd;
}

/** This warns if the utility values for this AICmd are not outside of UtilityEndVal **/
static function WarnIfUtilityValueIsSuspect( out int InUtilty )
{
	if( InUtilty > default.UtilityEndVal )
	{
		`warn( "Utility value is greater than UtilityEndVal" @ `showvar(InUtilty) @ `showvar(default.UtilityEndVal) @ `showvar(default.Class) );
	}
}

/** Truncates that passed in value to default.UtilityEndVal  **/
static function TruncateUtility( out int InUtilty )
{
	InUtilty = Min( InUtilty, default.UtilityEndVal );
}

static function DrawDebugUtilityRating( NanoHUD_Base H, NanoAIBase AI, NanoAICmd SuperCmd, optional bool bUnavailable, optional byte StackDepth, optional float Rating = -1.f )
{
	local float XL, YL;
	local String Text;
	local float ActionRating, ActionBarHeight;
	local class<NanoAICmd> SubCmdClass;
	local GameAICommand ChildCmd;


	ActionBarHeight = 8.f;

	H.Canvas.Font = class'Engine'.static.GetTinyFont();

	if( bUnavailable )
	{
		H.Canvas.SetDrawColor(64, 64, 64, 255);
		Text = String(default.class)@"(N/A)";
	}
	else
	{
		switch( StackDepth )
		{
			case 0:
				H.Canvas.SetDrawColor(225, 0, 0, 255);
				break;
			case 1:
				H.Canvas.SetDrawColor(0, 225, 0, 255);
				break;
			case 2:
				H.Canvas.SetDrawColor(0, 0, 225, 255);
				break;
			case 3:
				H.Canvas.SetDrawColor(225, 225, 0, 255);
				break;
			case 4:
				H.Canvas.SetDrawColor(225, 0, 225, 255);
				break;
			case 5:
				H.Canvas.SetDrawColor(0, 225, 225, 255);
				break;
			case 6:
			default:
				H.Canvas.SetDrawColor(225, 225, 225, 255);
				break;
		}
		
		ActionRating = Rating;
		if( ActionRating < 0.f )
		{
			ActionRating = GetUtility( AI );
		}
		Text = String(default.class)@"("$ActionRating$")";
	}
	H.Canvas.StrLen(Text, XL, YL);
	H.Canvas.SetPos( (H.Canvas.SizeX * 0.95f) - XL, H.Canvas.CurY );
	AI.DrawDebugText( H, Text );
	
	if( ActionRating > 0.f )
	{
		ActionRating = FMax( ActionRating, 1.f );
		H.Canvas.SetPos( (H.Canvas.SizeX * 0.95f) - ActionRating, H.Canvas.CurY + 1.f );
		H.Canvas.DrawRect( ActionRating, ActionBarHeight );
		H.Canvas.SetPos( H.Canvas.CurX, H.Canvas.CurY + ActionBarHeight + 1.f );
	}


	if( SuperCmd != None && SuperCmd.Class == default.Class && Rating < 0.f )
	{
		foreach SuperCmd.ListOfCmdsCanDo( SubCmdClass )
		{
			for( ChildCmd = SuperCmd.ChildCommand; ChildCmd != None; ChildCmd = ChildCmd.ChildCommand )
			{
				if( ChildCmd.Class == SubCmdClass )
				{
					break;
				}
			}

			SubCmdClass.static.DrawDebugUtilityRating( H, AI, NanoAICmd(ChildCmd), bUnavailable, StackDepth + 1 );
		}
	}
}

event String GetDebugVerboseText()
{
	return Super.GetDebugVerboseText()@"State:"@GetStateName();
}

function bool HandleMoodChange(EAIMoods NewMood)
{
	if (NanoAICmd(ChildCommand) != None)
	{
		return NanoAICmd(ChildCommand).HandleMoodChange(NewMood);
	}
	return FALSE;
}

/** Checks to see if the FireTarget is within range of our weapon **/
static function bool IsInAttackRange( NanoAIBase InAI )
{
	local Vector VectToTarg;
	local NanoWeap_Melee Weap;
	local float DistToTarget;
	local float CylinAdd;

	Weap = NanoWeap_Melee(InAI.Pawn.Weapon);
	if( ( Weap != None ) && ( InAI.FireTarget != None ) && ( InAI.LineOfSightTo(InAI.FireTarget, InAI.FireTarget.GetTargetedLocation()) == TRUE ) )
	{
		VectToTarg = (InAI.FireTarget.GetTargetedLocation()-InAI.Pawn.Location);

		//`log( `showvar( Pawn(InAI.FireTarget) ) @ `showvar(Actor(InAI.FireTarget).Location) @ `showvar(InAI.FireTarget.GetTargetedLocation() ) );
		CylinAdd = InAI.Pawn.GetCollisionRadius() + Pawn(InAI.FireTarget).GetCollisionRadius();
		DistToTarget = VSize(VectToTarg) - CylinAdd;

		if( DistToTarget <= Weap.WeaponRange )
		{
			return TRUE;
		}
	}

	//`AILog( Outer @ GetFuncName() @ `showvar(DistToTarget) @ `showvar(Weap.WeaponRange) @ `showvar(bUseBoidMovement) );

	return FALSE;
}


/** Checks to see if the InAI is within the ConfrontationType's Range with regard to the firetarget **/
final static function bool IsInRange( NanoAIBase InAI )
{
	local Vector VectToTarg;
	local float CylinAdd;
	local float DistToTarget;
	local int ChaosTier;
	local Vector2D TestRange;
	local float RandomOffset;

	if( InAI.FireTarget == None )
	{
		`AILog_Ext( GetFuncName() @ "InAI.FireTarget was None!!!!" @ `showvar(InAI.ConfrontationType),, InAI );
		return FALSE;
	}

	VectToTarg = (InAI.FireTarget.GetTargetedLocation() - InAI.Pawn.Location); 
	CylinAdd = InAI.Pawn.GetCollisionRadius() + Pawn(InAI.FireTarget).GetCollisionRadius();
	DistToTarget = VSize(VectToTarg) - CylinAdd;

	ChaosTier = InAI.GetBlackBoard().CachedCurrChaosTier;

	switch( InAI.ConfrontationType )
	{
	case ECFT_Melee_Attacking:
		TestRange = class'BoidRule_TrooperMelee'.default.EngageRanges[ChaosTier].AttackingRange;
		break;
	case ECFT_Melee_Engaged:
		TestRange = class'BoidRule_TrooperMelee'.default.EngageRanges[ChaosTier].EngagedRange;
		break;
	case ECFT_Melee_Standby:
		TestRange = class'BoidRule_TrooperMelee'.default.EngageRanges[ChaosTier].StandbyRange;
		break;
	case ECFT_Melee_Spectator:
		TestRange = class'BoidRule_TrooperMelee'.default.EngageRanges[ChaosTier].SpectatorRange;
		break;
	case ECFT_Ranged:
		TestRange.X = class'BoidRule_TrooperRanged'.default.MinDistanceToStandFromFoe;
		TestRange.Y = class'BoidRule_TrooperRanged'.default.MaxDistanceToStandFromFoe;
		break;
	case ECFT_RangedCloser:
		TestRange.X = class'BoidRule_TrooperRangedCloser'.default.MinDistanceToStandFromFoe;
		TestRange.Y = class'BoidRule_TrooperRangedCloser'.default.MaxDistanceToStandFromFoe;
		break;
	case ECFT_RooftopSentinel:
		TestRange = class'BoidRule_TrooperMelee'.default.EngageRanges[ChaosTier].EngagedRange;
		break;
		
		// you are never in range if you are in ECFT_None
	case ECFT_None:
		return FALSE;
		break;



	default:
		`warn( GetFuncName() @ "ConfrontationType not found" @ `showvar(InAI) @ `showvar(InAI.ConfrontationType) );
		`AILog_Ext( GetFuncName() @ "ConfrontationType not found" @ `showvar(InAI) @ `showvar(InAI.ConfrontationType),, InAI );
		return FALSE;
		break;
	}

	RandomOffset = 0; // ( TestRange.Y - TestRange.X ) * InAI.BoidMeleeRangePercent;

	// so now test to see if we are within range specified by our ConfrontationType
	if( ( (TestRange.X + RandomOffset) <= DistToTarget ) && ( DistToTarget <= TestRange.Y ) ) // we want to see if the guy is within the range without offset as we assume the boids will put the guy in the correct location.  We just want to make certain we are within the correct range ????
	{
		return TRUE;
	}

	//`AILog_Ext( GetFuncName() @ "FALSE" @ `showvar(DistToTarget) @ `showvar(InAI.ConfrontationType) @ `showvar(TestRange.X) @ `showvar(TestRange.X + RandomOffset) @ `showvar(TestRange.Y) @ `showvar(InAI.bUseBoidMovement) @ `showvar(InAI.BoidMeleeRangePercent),, InAI );

	return FALSE;
}








// sub classes can implement this
delegate IdleQueryTripped( int StimulusIdx, optional array<PlanIncreaseDatum> AIPlansRatingToIncrease );

/** Some AICmds do special attacks that have a specific range.  (e.g. SpecialMeleeAttacks) **/
static function float GetAttackRange();


/** 
 * This allows the individual AIActions to modify the stimulus that was just added.  In this way we can
 * have AI modify whether or not they can hear something or that they can see the enemy wielding a certain weapon.
 * As the stimulus was modified directly the utility functions do not need to have knowledge of every possible
 * state.
 *
 *
 **/
function StimulusAdded();

function int GetActiveAttackSlots()
{
	local NanoAICmd CC;

	CC = NanoAICmd(ChildCommand);
	if( CC != None )
	{
		return CC.GetActiveAttackSlots();
	}
	return 1;
}


final simulated function NanoAIBlackboard GetAIBlackboard()
{
	return NanoGRI(WorldInfo.GRI).AIBlackboard;
}


function DoWaitingToAttackSpecialMove()
{
	`AILog( GetFuncName() @ `showvar(WaitingToAttackSpecialMoveName) );
	NanoPawn(Outer.Pawn).DoSpecialMove( WaitingToAttackSpecialMoveName );
	//`log( "completed DoWaitingToAttackSpecialMove" );
}


/** This will add any AI Command based constraints that are wanted when path finding **/
function AddAIBasedPathConstraints();


state SelectSubCmd `DEBUGSTATE
{
Begin:
	`AILog( GetStateName()@"BEGIN TAG" );

	FindAndActivateBestSubCmd(); // is this going to work?  I think because the "top level" AI actions are not going to get to override what is on the stack because all of the "top level" things for attacking and moving are now these subcmd things
	Sleep( 0.1f );

	Goto( 'Begin' );
}



defaultproperties
{
	bAllowAntiBoidJitterCode=TRUE

	UtilityStartVal=-1
	UtilityEndVal=-1

	StartingStateName="SelectSubCmd"

	// idea is that in each "class" you just have to deal with relative priorities
	// and not have to worry about the entire set of actions
	// additionally, no matter what you are going to be bounded by UtilityEndVal
	// Current ranges:
	//RunAway 390 - 500
	//EngageThreat 290 - 400
	//ConfrontPossibleThreat 190 - 300
	//Defensive 90 - 200
	//Idle 1 - 100

	//Scripted // this really is overriding the set of cmds avail to the AI

	// visually debug the aicmds
	// auto call playersonly when a cmd changes  / call bugitai

	// tagging an ai to do shit to.  So aim at and press button and then that guy is "tagged"




// Utilty function rules all
// if things are not correctly occurring then the utility function is broken in some way.
// one should not try to set special bools on blackboard/controller/active state and then look for them
// 
// if the current set of stimuli is not "valid" / "able to have data for the utility" then we need to
// more than likely add some generalized functionality to it.
//
// if that can not be done then we need to start along the "bool cloud" path  But that should be the last option
//
//

}
