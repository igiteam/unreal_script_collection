/**
 * This class should hold all of the base super generic functions / interface function / code
 * that is used for all AIs that we have.
 *
 *
 *
 *
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIBase extends GameAIController
	dependson( SeqEvt_AIStateChanged, NanoTypes )
	native(AI)
	config(AI)
	abstract;


/** AI mood, mainly for exposing state transition to Kismet via SetMood() */
var transient EAIMoods CurrentAIMood;

/**
 * Changing this basically just allows us to notify the pawn of "intention" changes.  Primarily this is
 * used by Boids to determine how close to stand to the boid target in question.
 *
 * If the AI is in "engaged" mode it wants to stand nearish the player.
 *
 * If it is far away it needs to close the distance.   And it needs to choose which anims to use to close said distance.
 *
 * Choosing which anims is based on actual distance to the target.  NOT based on which ConfrontationType we are in.
 * 
 * e.g.
 *   <Anim> is chosen by:  (in this case bounding or steppy step)
 *
 * -ECFT_Melee_Engaged (which gives my DesiredLoc from the target) 
 * -VSize(CurrLoc - DesiredLoc) > BoundDist
 * OR
 * -VSize(CurrLoc - DesiredLoc) > steppy step distance
 *
 * Basically: what options do I have that will take me that far.  Let me randomly pick from acceptable options
 * Then play animations which will do the root motion to move you there.
 *
 *
 **/
var transient privatewrite EConfrontationType ConfrontationType;

/**
 * We use this to determine what we just were doing so on entering melee we can see if we were just in standby to do a "charge!" shout
 * and/or other audio events.
 **/
var transient privatewrite EConfrontationType LastConfrontationType;


var transient NanoPawnBase MyNanoPawn;

/** Factory that was used to create this AI */
var transient SeqAct_AIFactory SpawnFactory;


//// AI PLANNER
/** This holds the list of commands that this AICmd can help satisfy / accomplish **/
var() array< class<NanoAIAction> > ListOfAIActionsThisAICanDo;

struct native AIActionUtilityInfo
{
	var() class<NanoAIAction>   ActionClass;
	var() float                 UtilityRating;
};
var(Debug) array< class<NanoAIAction> > ListOfAIActionsThisAIEverConsidered;
var(Debug) array<AIActionUtilityInfo>   LastActionChangedUtilityList;
var(Debug) array<AIActionUtilityInfo>   LastUtilityRatingsList;

var transient class<AIPlanBase> CurrAIPlan;

var transient float LastAIPlannerTime;
var transient float LastAIPlannerTime_Action;

var() transient int CombatResponse[4]; // c.f. NanoCombatEffectors

//// STIMULUS QUERIES

enum EQueryOption
{
	QO_Allow,
	QO_Disallow,
	QO_Require,
};

struct native StimulusInfo
{
	/** Location of the stimulus */
	var vector	Location;
	/** Actor associated with stimulus */
	var Actor	Actor;
	/** Time of event */
	var float	Time;
	/** Was this location visible? */
	var bool	bVisible;
	/** Priority of this stimulus */
	var int		Priority;
	/** Is this a friendly stimulus? */
	var bool	bIsFriendly;
	/** Did this stimulus indicate combat? (damage, weapon brandishing, etc) */
	var bool	bCombative;
	/** Did this stimulus involve taking damage? */
	var bool	bDamaged;
};

var transient array<StimulusInfo> Stimuli;


struct native NanoSkillUsageInfo
{
	var() EQueryOption Usage;
	var() class<NanoSkill> Skill;
	var() int MinSkillLevel;
	var() int MaxSkillLevel;

	structdefaultproperties
	{
		MinSkillLevel=-1
		MaxSkillLevel=-1
	}
};

struct native PlanIncreaseDatum
{
	var class<AIPlanBase> AIPlan;
	var float Amount;
};


struct native StimulusQuery
{
	/** Filter out any non-visible stimulus */
	var() EQueryOption Visibility;
	/** Filter out any stimulus with Priority < MinPriority */
	var() int MinPriority;
	/** Filter out any stimulus with Priority > MaxPriority */
	var() int MaxPriority;
	/** Filter out any stimulus outside of MinFOV, using FOVDir */
	var() float MinFOV;
	/** Filter out any stimulus beyond MaxFOX, using FOVDir */
	var() float MaxFOV;
	/** Use FOVDir as a base for MinFOV check, otherwise uses vector(Rotation) */
	var() vector FOVDir;
	/** Filter out any stimulus closer than MinDist */
	var() float MinDist;
	/** Filter out any stimulus further than MaxDist */
	var() float MaxDist;
	/** 
	 * Distance above us which we will "ignore" this stimuli (e.g. on a rooftop looking down at us).
	 * The idea here is that if the player is up high above the AI they are trying to be "sneaky" and the AI
	 * should not have immediate lock on.  (especially not the lower level AI)
	 **/
	var() float DistanceAboveUsToIgnoreStimuli;
	var() float DistanceBelowUsToIgnoreStimuli;
	/** Allow friendly stimulus results */
	var() bool bAllowFriendly;
	/** Allow non-friendly stimulus results */
	var() bool bAllowNonFriendly;
	/** Only care about damaged stimulus */
	var() bool bRequireDamaged;
	/** If we are going to disregard the override that having high chaos has on RequireDamaged**/
	var() bool bDisregardChaosOverride_RequireDamaged;

	/** Filter any stimulus where Time > MaxStimulusTime */
	var() float MaxStimulusTime;
	/** Only care about combative stimulus */
	var() EQueryOption bRequireCombative;

	/** Care about nano powers on the stimulus actor? */
	var() editinline array<NanoSkillUsageInfo> NanoSkillUsage;

	/** Optional query label */
	var() string QueryLabel;

	/** Limit the frequency of checks for this query if > 0 */
	var() float RetryDelay;
	var transient float LastQueryAttempt;

	/** If specified, this delegate is called when a new stimulus matches the registered query */
	var delegate<StimulusPassedQuery> StimulusPassed;

	var array<PlanIncreaseDatum> AIPlansThisIncreases;
	

	structdefaultproperties
	{
		MinFOV=-1.f
		MaxFOV=-1.f
		MaxDist=2048.f
	}
};

var transient array<StimulusQuery> PassiveQueries;

/** List of Kismet driven queries for mega-scripting! */
var transient array<SeqEvt_AIStimulus> KismetQueries;

var float MaxStimulusTime;

/** 
 * The time at which a stimulus that is "combative" is considered still hot
 *
 * Example:
 *
 * I can probably make a "hot" timer on the player.  So specific actions cause them to be viewed as a "weapon" out.
 *
 * So you go up to the VIP.  You cap his guards.  You cap him.  And you are "hot" for a while.
 *
 * A while passes.
 *
 * You walk down the corridor.  AIs will stream by you to your last location  of "hot".   If you have no weapons out, they will not attack you.
 *
 **/
var config float HotSimulusDuration;


//// BOID VARIABLES
/** AI is adjusting move position by boid rules */
var bool					bUseBoidMovement;
/** List of active rules to apply with boid movement */
var() editinline transient array<BoidMovementRule> BoidRules;

/** 
 * So for Melee ranges we we don't always want to be directly against the inner range.  So this is a nice
 * way to get a random offset into that range.
 * We will set this when ever we enter a melee AIAction;
 **/
var transient float BoidMeleeRangePercent;

//// PATH FINDING VARS
var transient bool bUseAltSearchStart;
var transient Vector AltSearchStart;
/** Currently moving along a route */
var transient bool bMovingToRoute;
var transient Route ActiveRoute;



/** Whether or not this AI should attack players without weapons visible **/
var transient bool bShouldAttackPlayersWithoutWeaponsVisible;


/** Is this AI under scripted control? */
var(Debug) transient bool bIsScripted;

var(Debug) transient bool bTargetDummy;

/** Last state before transitioning to the current */
var transient Name LastStateName;
/** Time of last state transition */
var transient float TimeOfTransition;


/** This is the NanoDefensivePoint we are going to be defending **/
var transient NanoDefensivePoint CurrNanoDefensivePoint;
var transient NanoDefensivePoint HACK_CurrNanoDefensivePoint;
var transient NanoGuardPoint CurrNanoGuardPoint;
var transient NanoReinforcementPoint CurrNanoReinforcementPoint;

/** This is the Patrol Point we are patrolling **/
var transient NanoPatrolPoint OrigPatrolPoint;
var transient NanoPatrolPoint CurrPatrolPoint;
var transient Name DesiredPatrolPointName;

var transient NanoDesignatedFleeSpot CurrFleeSpot;
var transient Name DesiredFleeSpotName;

/** This is the super special CinematicAITargetPoint that this AI is going to! **/
var transient CinematicAITargetPoint CurrCinematicAITargetPoint;

/** Sometimes we can get geometry which precludes boid movement from working correctly.  So we need to path find then. **/
var transient float LastBoidMovementToEnemyTimedOut;


/** When we last attacked **/
var transient float LastMeleeAttackTime;


/** We need to keep track of whether or not this AI was spawned into the cloud so we can count its point cost in the NPES land. **/
var transient bool bSpawnedIntoTheResponseCloud;

/**
 * We need to have a bool as when we spawn something and we we actually enter into the world and get AI ticked can be some time.
 * So we need to "cache" whether or not this was an initial spawn or not.
 **/
var transient bool bInitialSpawnOnDefensivePoint;

/** Whether or not this AI was originally spawned onto the Rooftops **/
var transient bool bInitialSpawnOnRooftops;


/** Once a fighter enters the Melee Circle they will want this long before attacking. **/
var config Vector2D MeleeCircleReadyToFightPostArrivalRange;
var transient float MeleeCircleAllowedToAttackTime;


/**
 * This needs to be an NanoInterface_Targetable as we have vehicles and other crazy things that we want the AI to be able to attack.
 * Sadly we can't do this because somewhere the Interface is being crazy and crashes at runtime (In native code it looks like)
 * So we will just put this to Actor and then Cast it to a NanoInterface_Targetable if we need to.
 *
 **/
var transient privatewrite NanoInterface_Targetable FireTarget;
var transient float TimeOfLastPickTarget;

/** Acceptable distance offset from the goal */
var float MoveOffset;


//// Manual AI START

/** Manual AI I am the closest pawn to the player **/
var transient bool bMAI_ClosestPawn;

/** We need a global override for the attack pacing shizzle.  So our helper functions can || against this **/
var transient bool bMAI_OverrideAttackPacing;

/** If we have an asked an AI to range attack a player **/
var transient bool bMAI_RangeAttackPlayer;

//// Manual AI END

/** Used to determine whether or not the AI is actually trying to aim their gun to take a shot **/
var transient bool bTryingToTargetWithLaserSight;


event PostBeginPlay()
{
	Super.PostBeginPlay();
	InitPlayerReplicationInfo();
}


event Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess(NewPawn, bVehicleTransition);
	`AILog(`location@`showvar(NewPawn));
	if( Pawn != None )
	{
		MyNanoPawn = NanoPawnBase(NewPawn);
		Pawn.SetMovementPhysics();

		// so all of the AI (no matter where they are spawned from) will be routed through this
		// right now we have some systems that spawn AIs automagically
		// and we also want to give the ability for the LD just set up their "forced" spawning of dudes but not just
		// utterly break the amorphous procedural spawning
		NanoGRI(WorldInfo.GRI).NPES.NotifyANewAIHasSpawned( self );
		NanoGRI(WorldInfo.GRI).AIP.NotifyANewAIHasSpawned( self );

		// let the planner take over
		//GotoState('Idle');

		EnableHeadTracking();
	}
}




function PostAIFactorySpawned(SeqAct_AIFactory SpawningFactory, INT SpawnSetIdx);

function SetFireTarget( Actor NewFireTarget )
{
	`AILog( GetFuncName()@`showvar(FireTarget)@`showvar(NewFireTarget) );

	UnregisterAsAttacker();
	FireTarget = NewFireTarget;
	Enemy = Pawn(NewFireTarget); // sort of lame that Conontroller.uc's enemy is a pawn.  It should either be an interface or an actor as lots of "targetable" things derive from actor.
	Focus = NewFireTarget;
	RegisterAsAttacker();

	TimeOfLastPickTarget = WorldInfo.TimeSeconds;
}

function RegisterAsAttacker()
{
	if( NanoPawnBase(FireTarget) != None )
	{
		NanoPawnBase(FireTarget).RegisterAttacker(self);
	}
}
function UnregisterAsAttacker()
{
	if( NanoPawnBase(FireTarget) != None )
	{
		NanoPawnBase(FireTarget).UnregisterAttacker(self);
	}
}


function SetConfrontationType( EConfrontationType CT )
{
	if( CT != ConfrontationType )
	{
		LastConfrontationType = ConfrontationType;
		ConfrontationType = CT;

		MyNanoPawn.NotifyConfrontationTypeChanged( ConfrontationType, LastConfrontationType );
	}
}

function SetMood(EAIMoods NewMood)
{
	if (CurrentAIMood != NewMood)
	{
		CurrentAIMood = NewMood;
		TriggerEventClass(class'SeqEvt_AIStateChanged',self,CurrentAIMood);
		Pawn.TriggerEventClass(class'SeqEvt_AIStateChanged',Pawn,CurrentAIMood);
		if (NanoAICmd(CommandList) != None)
		{
			NanoAICmd(CommandList).HandleMoodChange(NewMood);
		}
	}
}



final function NanoAIBlackboard GetBlackBoard()
{
	return NanoGRI(WorldInfo.GRI).AIBlackboard;
}


//// KISMET

function OnSetAIMood( SeqAct_SetAIMood inAction )
{
	SetMood( inAction.NewMood );
}




//// STATES

state Idle `DEBUGSTATE
{
	function BeginState(Name PrevStateName)
	{
		Super.BeginState(PrevStateName);
		SetMood(AIMood_Unaware);
		ScriptTrace();
	}
}


state Dead
{
	function BeginState(Name PrevStateName)
	{
		Super.BeginState(PrevStateName);
		SetMood(AIMood_Killed);
	}
}




//// DEBUG AI

/** Util for drawing debug text, which will wrap to a new column when it goes off the bottom of the screen */
function DrawDebugText(NanoHUD_Base H, String Text)
{
	local float XL, YL;

	if( H.Canvas.CurY >= H.Canvas.SizeY * 0.95f )
	{
		H.Canvas.SetPos(H.Canvas.CurX + DebugTextMaxLen + 8.f, H.Canvas.SizeY * 0.05f);
		DebugTextMaxLen = 0.f;
	}

	H.Canvas.StrLen(Text, XL, YL);
	if( XL > DebugTextMaxLen )
	{
		DebugTextMaxLen = XL;
	}

	H.Canvas.DrawText(Text,,,,H.Text_NoClipShadowed);
}


/**
 * Returns our current health percentage.
 */
simulated final function float GetHealthPercentage()
{
	local Vehicle V;
	local Pawn P;

	P = Pawn;
	V = Vehicle(Pawn);
	if( V != None )
	{
		P = V.Driver;
	}

	if( P == None )
	{
		return 1.f;
	}
	else
	if( NanoPawnBase(P) != None)
	{
		return (P.Health/float(NanoPawnBase(P).DefaultHealth));
	}
	else
	{
		return (P.Health/float(P.HealthMax));
	}
}


simulated function Texture2D GetDebugIcon()
{
	local NanoAICmd ActiveCmd;

	ActiveCmd = NanoAICmd(GetActiveCommand());
	if( ActiveCmd != none )
	{
		return ActiveCmd.GetDebugIcon();
	}

	return Texture2D'EditorResources.S_NavP';
}


simulated function Texture2D GetBrokenIcon()
{
	// Texture2D'EditorResources.RedSquareTexture'
	return Texture2D'UI_HUD.AI.BrokenAI';
}


simulated function Texture2D GetScriptedIcon()
{
	return Texture2D'UI_HUD.AI.BrokenAI';
}


simulated function DrawDebug( NanoHUD_Base H, optional bool bSpecificDebug )
{
	local Texture2D Icon;
	local GameAICommand Cmd;
	local Canvas	Canvas;
	local int       CmdCnt;
	local class<NanoAIAction> AnAction;
	local bool bAvailableAction;
	local AICmdHistoryItem Item;
	local String Text;
	local int Idx;
	local float XL, YL;
	
// 	local int Idx;
// 
// 	for( Idx = 0; Idx < Stimuli.Length; Idx++ )
// 	{
// 		DrawDebugLine( Pawn.Location, Stimuli[Idx].Actor.Location, 0, 0, 255 );
// 		if( Stimuli[Idx].bVisible )
// 		{
// 			DrawDebugLine( Pawn.Location, Stimuli[Idx].Location, 0, 255, 0 );
// 		}
// 		else
// 		{
// 			DrawDebugLine( Pawn.Location, Stimuli[Idx].Location, 255, 0, 0 );
// 		}
// 	}

	if( bAIBroken )
	{
		Icon = GetBrokenIcon();
	}
	else if( bIsScripted )
	{
		Icon = GetScriptedIcon();
	}
	else
	{
		Icon = GetDebugIcon();
	}

	if( Icon != None )
	{
		DrawIconOverhead( H, Icon );
	}

	if( GetActiveCommand() != None )
	{
		GetActiveCommand().DrawDebug( H, '' );
	}

	// Draw list of commands down the side of the screen
	if( bSpecificDebug && Pawn != None )
	{
		Canvas = H.Canvas;
		Canvas.Font = class'Engine'.Static.GetTinyFont();
		Canvas.SetDrawColor(225, 0, 0, 255);
		Canvas.SetPos(Canvas.SizeX * 0.05f, Canvas.SizeY * 0.05f);

		DrawDebugText( H, String(self) );
		
		// WRITE OUT COMMAND STACK
		Canvas.SetDrawColor(255, 255, 255, 255);
		DrawDebugText( H, "************************************************************" );
		Canvas.SetDrawColor(0, 0, 255, 255);
		DrawDebugText( H, "COMMAND STACK" );
		foreach AllCommands( class'GameAICommand', Cmd )
		{
			if( Cmd.ChildCommand == None )
			{
				Canvas.SetDrawColor(225, 0, 0, 255);
			}
			else
			{
				Canvas.SetDrawColor(0, 255, 0, 255);
			}
			DrawDebugText( H, String(Cmd.Name) );
			Text = Cmd.GetDebugVerboseText();
			if( Len(Text) > 0 )
			{
				DrawDebugText( H, ".........."@Text );
			}
			CmdCnt++;
		}
		if( CmdCnt == 0 )
		{
			DrawDebugText( H, "NO COMMANDS ACTIVE" );
		}

		// WRITE OUT COMMAND HISTORY
		Canvas.SetDrawColor(255, 255, 255, 255);
		DrawDebugText( H, "************************************************************" );
		Canvas.SetDrawColor(0, 0, 255, 255);
		DrawDebugText( H, "COMMAND HISTORY (Count:"@CommandHistoryNum$")" );
		CmdCnt = 0;
		foreach CommandHistory( Item )
		{
			CmdCnt++;
			Canvas.SetDrawColor(255, 0, 0, 255);
			DrawDebugText( H, "Cmd"@CmdCnt$":"@String(Item.CmdClass)@"Time:"@Item.TimeStamp);
			if( Len(Item.VerboseString) > 0 )
			{
				Canvas.SetDrawColor(255, 64, 64, 255);
				DrawDebugText( H, ".............."@Item.VerboseString );
			}
		}

		// WRITE OUT UTILITY FUNCTIONS
		// CURRENT UTILITY RATINGS
		Canvas.SetPos(Canvas.SizeX * 0.95f, Canvas.SizeY * 0.05f);
		Text = "CURRENT UTILITY RATINGS";
		Canvas.StrLen(Text, XL, YL);
		Canvas.SetPos( (Canvas.SizeX * 0.95f) - XL, Canvas.CurY );
		Canvas.SetDrawColor(255, 255, 255, 255);
		DrawDebugText( H, Text );

		if( bUseAITree )
		{
			for( Idx = 0; Idx < AITreeHandle.LastUtilityRatingList.Length; Idx++ )
			{
				class<NanoAICmd>(AITreeHandle.LastUtilityRatingList[Idx].CommandClass).static.DrawDebugUtilityRating( H, self, NanoAICmd(CommandList), FALSE, 0, -1.f );//AITreeHandle.LastUtilityRatingList[Idx].UtilityRating );
			}
		}
		else
		{
			foreach ListOfAIActionsThisAIEverConsidered( AnAction )
			{
				bAvailableAction = (ListOfAIActionsThisAICanDo.Find( AnAction ) >= 0);
				AnAction.static.DrawDebugUtilityRating( H, self, NanoAICmd(CommandList), !bAvailableAction, 0 );
			}
		}

		// LAST ACTION CHANGED UTILITY RATINGS
		Text = "LAST ACTION CHANGED UTILITY RATINGS";
		Canvas.StrLen(Text, XL, YL);
		Canvas.SetPos( (Canvas.SizeX * 0.95f) - XL, Canvas.CurY );
		Canvas.SetDrawColor(255, 255, 255, 255);
		DrawDebugText( H, Text );

		if( bUseAITree )
		{
//			for( Idx = 0; Idx < AITreeHandle.LastUtilityRatingListAtChange.Length; Idx++ )
//			{
//				class<NanoAICmd>(AITreeHandle.LastUtilityRatingListAtChange[Idx].CommandClass).static.DrawDebugUtilityRating( H, self, None, FALSE, 0, AITreeHandle.LastUtilityRatingListAtChange[Idx].UtilityRating );
//			}
		}
		else
		{
			for( Idx = 0; Idx < LastActionChangedUtilityList.Length; Idx++ )
			{
				LastActionChangedUtilityList[Idx].ActionClass.static.DrawDebugUtilityRating( H, self, None, FALSE, 0, LastActionChangedUtilityList[Idx].UtilityRating );
			}
		}

		NanoGRI(WorldInfo.GRI).AIBlackboard.DrawDebug( H );

//		DrawDebugLine( Pawn.Location, BP2Vect(DestinationPosition), 0, 255, 255 );
	}
}


simulated function DrawIconOverhead(NanoHUD_Base HUD, Texture2D Icon)
{
	local NanoPC	PC;
	local Canvas	Canvas;
	local Vector	CameraLoc, ScreenLoc;
	local Rotator	CameraRot;
	local String	Str;
	local array<string>	Strings;
	local float		X, Y, HealthPct;

	PC = NanoPC(HUD.PlayerOwner);
	Canvas = HUD.Canvas;
	Canvas.SetDrawColor(255,255,255);

	// project location onto the hud
	PC.GetPlayerViewPoint( CameraLoc, CameraRot );
	ScreenLoc = Canvas.Project( Pawn.Location + vect(0,0,1) * Pawn.GetCollisionHeight() * 1.5f );
	Canvas.SetPos( ScreenLoc.X - Icon.SizeX/2, ScreenLoc.Y - Icon.SizeY/2 );
	Canvas.DrawTexture( Icon, 0.75f );

	Canvas.SetDrawColor(255,255,255);

	X = ScreenLoc.X + Icon.SizeX/2 + 5;
	Y = ScreenLoc.Y - Icon.SizeY/2;
	Canvas.SetPos( X, Y );
	Str = "#"$GetRightMost(self);
    Str $= " " $ GetActionString();

	//Str $= "  Focus:" @ Focus @ FocalPosition.Position ; //X @ FocalPosition.Y @ FocalPosition.Z;
	
	Canvas.DrawText( Str, TRUE );

	GetDebugOverheadText(PC,Strings);
	foreach Strings(Str)
	{
		Canvas.DrawText(Str,TRUE);
	}

	Canvas.SetDrawColor(0,255,0);
	HealthPct = GetHealthPercentage();
	Canvas.DrawTile(Texture2D'WhiteSquareTexture',64.f * HealthPct,4,0,0,2,2);
	Canvas.SetDrawColor(255,0,0);
	Canvas.DrawTile(Texture2D'WhiteSquareTexture',64.f * (1.f - HealthPct),4,0,0,2,2);

	Canvas.SetDrawColor(255,255,255);
}


function GetDebugOverheadText( PlayerController PC, out array<string> OutText )
{
	local Vector VectToTarg;
	local float CylinAdd;
	local float DistToTarget;


	if( NanoPawn(MyNanoPawn) != None && NanoPawn(MyNanoPawn).ActiveSpecialMoveName != '' )
	{
		OutText.AddItem( "NSM:" @ NanoPawn(MyNanoPawn).ActiveSpecialMoveName  );
	}

	if( FireTarget != None )
	{
		VectToTarg = (FireTarget.GetTargetedLocation() - Pawn.Location); 
		CylinAdd = Pawn.GetCollisionRadius() + Pawn(FireTarget).GetCollisionRadius();
		DistToTarget = VSize(VectToTarg) - CylinAdd;

		OutText.AddItem("FireTarget:"$FireTarget @ "Rng"@DistToTarget @ `showvar(class'NanoAICmd'.static.IsInRange(self)) @ `showvar(BoidMeleeRangePercent) );
	}

	if( PC.Pawn != None )
	{
	//	OutText.AddItem("DistFromPlayer"@VSize(Pawn.Location-PC.Pawn.Location)@" ZDifference"@(Pawn.Location.Z-PC.Pawn.Location.Z));
	}

	OutText.AddItem( string(CurrentAIMood) @ string(ConfrontationType) @ "Prev:" @string(LastConfrontationType) @ string(Pawn.Mesh.RootMotionMode) );

	//OutText.AddItem( "Team" @ string(GetTeamNum()) );


	OutText.AddItem( "CurrDP" @ CurrNanoDefensivePoint @ "CurrGP" @ CurrNanoGuardPoint @ "HackDP" @ HACK_CurrNanoDefensivePoint );

	//OutText.AddItem( "GroundSpeed" @ Pawn.GroundSpeed @ "Vel:" @ VSize(Pawn.Velocity) );

	// now ask our ActiveCommand if we have one
	if( GetActiveCommand() != None )
	{
		GetActiveCommand().GetDebugOverheadText( PC, OutText );
	}


	OutText.AddItem( `showvar(ConfrontationType) @ `showvar(LastConfrontationType) );
	OutText.AddItem( `showvar(Focus) );
}



//// MISC HELPER FUNCTIONS


function bool IsPointWithinRange( Vector Pt )
{
	return TRUE;
}

final function bool HasValidTarget( optional Actor TestTarget )
{
	return FALSE;
}

// OPTIMIZE: GetTeamNum() is actually pretty slow when it is called a thousand times a frame especially as it is a native call
final function bool IsFriendlyActor(Actor TestActor)
{
	//`log( `showvar(self) @  `showvar(TestActor) @ `showvar(TestActor.GetTeamNum() ) @ `showvar(GetTeamNum()) @ "isFriendly:" @ (TestActor == None || TestActor.GetTeamNum() == 255 || TestActor.GetTeamNum() == GetTeamNum()) );
	return TestActor == None || TestActor.GetTeamNum() == 255 || TestActor.GetTeamNum() == GetTeamNum();
}



//// TRANSITIONS

delegate bool DefaultShouldTransition()
{
	return TRUE;
}

function ScriptedTransitionTo(Name StateName)
{
	`AILog( "ScriptedTransition to"@StateName@"from"@GetStateName() );
	bIsScripted = TRUE;
	TransitionTo(StateName,TRUE);
}

function PossiblyTransitionTo(Name StateName, delegate<DefaultShouldTransition> ShouldTransition)
{
	`AILog(GetFuncName()@`showvar(StateName)@`showvar(bIsScripted));
	if (!bIsScripted && ShouldTransition() && (CommandList == None || CommandList.AllowStateTransitionTo(StateName)))
	{
		TransitionTo(StateName);
	}
}

function TransitionTo( Name StateName, optional bool bForceTransition )
{
	// so here we need to perhaps null out all of the accumulated rating values as
	// we have legacy (and probably) needed type of transitions back from certain states
	// this will push us to some state and then allow the stimuli to start increasing the rating to push us to a specific
	// state again

	`AILog("Transitioning to"@StateName@"from"@GetStateName()@bForceTransition);
	if( bForceTransition || GetStateName() != StateName )
	{
		if (CommandList != None)
		{
			AbortCommand(CommandList);
		}
		LastStateName = GetStateName();
		TimeOfTransition = WorldInfo.TimeSeconds;
		`log( "!!!! We are Transitioning from"@GetStateName()@"to"@StateName@bForceTransition );
		ScriptTrace();
		GotoState(StateName, 'Begin');
	}
}

function ScriptedTransitionToCombat();





//// PATHING

/** This will add any AI based constraints that are wanted when path finding **/
function AddAIBasedPathConstraints();



/** 
 * This will add all of the various path constraints that each "entity" wants to add. 
 * For example, a specific AI might want to add constraints for how it is "thinking", the pawn class
 * might have certain things it can do (e.g. jump from higher distances thatn other pawns).
 * The AIAction might wnat to bias the path finding to run near fires!
 * And eventually we might have some global modifier where maybe the metacorp communication network has been hacked
 * so people run away from Lyrik!
 **/
final function AddExtraPathConstraints()
{

	// all of these need to be array of constraints and not in the a function
	// so that way we can have the npes all the constraints 

	AddAIBasedPathConstraints();

	MyNanoPawn.AddPawnBasedPathConstraints();

	if( NanoAICmd(CommandList) != None )
	{
		NanoAICmd(CommandList).AddAIBasedPathConstraints();
	}
}


event MoveToActor( Actor NewMoveActor, optional float MaxMoveTime, optional bool NewbFaceFocus = TRUE )
{
	class'NanoAICmd_Move'.static.MoveTo( self,, NewMoveActor, MaxMoveTime, NewbFaceFocus );
}

function MoveToLocation( vector NewMoveLocation, optional float MaxMoveTime, optional bool NewbFaceFocus = TRUE )
{
	class'NanoAICmd_Move'.static.MoveTo( self, NewMoveLocation,, MaxMoveTime, NewbFaceFocus );
}

event bool GeneratePathToActor( Actor Goal, optional float WithinDistance, optional bool bAllowPartialPath )
{
	if( NavigationHandle == None )
	{
		`AILog("Warning, invalid nav handle");
		return FALSE;
	}

	NavigationHandle.SetFinalDestination(Goal.Location);

	AddExtraPathConstraints();

	class'NavMeshPath_Toward'.static.TowardGoal( NavigationHandle, Goal );
	class'NavMeshGoal_At'.static.AtActor( NavigationHandle, Goal, WithinDistance, bAllowPartialPath );

	if( NavigationHandle.FindPath() )
	{
		NavigationHandle.ClearConstraints();
		return TRUE;
	}
	NavigationHandle.ClearConstraints();
	return FALSE;
}

event bool GeneratePathToLocation( Vector Goal, optional float WithinDistance, optional bool bAllowPartialPath )
{
	if( NavigationHandle == None )
	{
		`AILog("Warning, invalid nav handle");
		return FALSE;
	}

	NavigationHandle.SetFinalDestination(Goal);

	AddExtraPathConstraints();

	class'NavMeshPath_Toward'.static.TowardPoint( NavigationHandle, Goal );
	class'NavMeshGoal_At'.static.AtLocation( NavigationHandle, Goal, WithinDistance, bAllowPartialPath );

	if( NavigationHandle.FindPath() )
	{
		NavigationHandle.ClearConstraints();
		return TRUE;
	}
	NavigationHandle.ClearConstraints();
	return FALSE;
}

event bool GeneratePathToFlightNetwork( Vector Goal, optional out FlightVolume out_FV )
{
	local Actor A;
	
	if( NavigationHandle == None )
	{
		`AILog("Warning, invalid nav handle");
		return FALSE;
	}

	AddExtraPathConstraints();

	class'NavMeshPath_Toward'.static.TowardPoint( NavigationHandle, Goal );
	class'NavMeshGoal_FlightVolume'.static.ToFlightVolume( NavigationHandle );

	if( NavigationHandle.FindPath( A ) )
	{
		out_FV = FlightVolume(A);
		NavigationHandle.ClearConstraints();
		return TRUE;
	}

	NavigationHandle.ClearConstraints();
	return FALSE;
}


function float GetDestinationOffset()
{
	if( Pawn.Physics == PHYS_Flying )
	{
		return Pawn.GetCollisionRadius() * 2.f;
	}
	return 0.f;
}

event bool GetAnimRelatedMoveLocation( out Vector out_MoveLoc, out float out_MoveOffset )
{
	local NanoWeaponBase Weap;
	if( MoveTimer > 0.f )
	{
		out_MoveLoc = BP2Vect(DestinationPosition);
		return TRUE;
	}

	if( Enemy != None )
	{
		Weap = NanoWeaponBase(Pawn.Weapon);
		if( Weap != None )
		{
			out_MoveOffset += Weap.WeaponRange;
		}
		if( Pawn(FireTarget) != None )
		{
			out_MoveOffset += Pawn(FireTarget).GetCollisionRadius();
		}

		out_MoveLoc = FireTarget.GetTargetedLocation();
		return TRUE;
	}

	return FALSE;
}


event bool TeleportToLocation(vector NewLoc, rotator NewRot, optional bool bCancelCombat = TRUE, optional bool bCancelMovement = TRUE )
{
	//debug
	`AILog( GetFuncName()@bCancelCombat@bCancelMovement@NewLoc );
	//DrawDebugLine(Pawn.Location,NewLoc,255,0,0,TRUE);
	//DrawDebugCoordinateSystem(NewLoc,rot(0,0,0),100.f,TRUE);

	NewLoc.Z += 32.f;
	if (Pawn != None &&
		Pawn.SetLocation(NewLoc))
	{
		if( Pawn.Physics == PHYS_RigidBody )
		{
			Pawn.Mesh.SetRBPosition( NewLoc );
		}

		// 		RouteCache_Empty();
		// 
		// 		if( bCancelMovement )
		// 		{
		// 			ClearMovementInfo(FALSE);
		// 		}
		// 
		// 		InvalidateCover();
		// 
		// 		if( bCancelCombat && CommandList != None )
		// 		{
		// 			BeginCombatCommand( None, "Teleported" );
		// 		}
		Pawn.SetRotation(NewRot);
		Pawn.SetMovementPhysics();
		Pawn.ZeroMovementVariables();
		return TRUE;
	}

	//debug
	`AILog( "TELEPORT FAILED?!" );

	return FALSE;
}

final function bool IsCloseEnoughToDefensePoint()
{
	//`AILog(`location@"number of points available:"@DefensePoints.Length);

	if (CurrNanoDefensivePoint != None)
	{
		`AILog( `location @  "wanting to defend" @ `showvar(CurrNanoDefensivePoint) @ "which is units away:" @ VSize(Pawn.Location - CurrNanoDefensivePoint.Location) );
		// demo wants people to move to the point so let's just do that now
		return VSize(Pawn.Location - CurrNanoDefensivePoint.Location) < 128.0f; // CurrNanoDefensivePoint.RadiusToDefend
	}
	return FALSE;
}


final function NanoPawn FindClosestPlayerPawn()
{
	local NanoPawn RetVal;
	local NanoPC NPC;
	local float NearestFocusDistance, CurrentFocusDistance;

	foreach WorldInfo.AllControllers(class'NanoPC', NPC)
	{
		CurrentFocusDistance = VSizeSq(NPC.Pawn.Location - Pawn.Location);
		if( (RetVal == None) || (NearestFocusDistance > CurrentFocusDistance) )
		{
			RetVal = NPC.MyNP;
			NearestFocusDistance = CurrentFocusDistance;
		}
	}

	return RetVal;
}


function SetFocusBasedOnLocation()
{
	// if we have no enemy  or our current focus is the fall back of the CurrCinematicAITargetPoint
	// let's try to find a a valid enemy focus
	if( ( Enemy == none ) || ( Focus == CurrCinematicAITargetPoint) )
	{
		// 		PossiblyPickFireTarget();
		// 		if( Enemy != none )
		// 		{
		// 			Focus = FireTarget; // our focus for a melee target should always be our FireTarget
		// 		}

		Focus = FindClosestPlayerPawn();
		//`log( "NEW FOCUS!!" @ Focus );
	}


	// so when in cinematics the pawn can be moved / killed / bad things done to it
	// which results in the focus being 0,0,0  which is clearly bad.
	// in that case focus on the CinematicAITargetPoint
	if( ( Focus == none ) || ( Focus.Location == vect(0,0,0) ) )
	{
		Focus = CurrCinematicAITargetPoint;
		//`log( "FALL BACK FOCUS!!" @ Focus );
	}

	// 	if( Focus == CurrCinematicAITargetPoint)
	// 	{
	// 		DrawDebugLine( Focus.Location, Pawn.Location, 255, 0, 0, TRUE );
	// 	}
	// 	else
	// 	{
	// 		DrawDebugLine( Focus.Location, Pawn.Location, 0, 255, 0, TRUE );
	// 	}
	// 
	// 	`log( `showvar(Focus) @ `showvar(Focus.Location) );
}





//// STIMULUS


/**
 * Allow the AICommands to modify the stimuli.
 *
 * The idea here is that you could have a state that affects one of the passed in stimuli in some way.
 * e.g. An ogre that is drunk and mostly passed out.  He can't hear very well nor see very well. So
 * when he gets a stimuli his current state modifies it.  Or conversely the orgre is wearing super ears
 * item and he can hear really well.
 *
 * Then when the various GetUtility() functions of AIActions run, they will be checking against the modified
 * data values.  
 *
 * This allows us to NOT have to share special state data around at all.  Everyone deals with some stimuli.  And some states
 * modify that data.
 *
 *
 *
 **/
function StimulusAdded()
{
	local NanoAICmd ActiveCmd;

	ActiveCmd = NanoAICmd(GetActiveCommand());
	if( ActiveCmd != none )
	{
		ActiveCmd.StimulusAdded();
	}
}


function AddQuery(const out StimulusQuery Query)
{
	PassiveQueries.AddItem(Query);
}

function RemoveQuery(const out StimulusQuery Query)
{
	local int Idx;
	Idx = PassiveQueries.Find('QueryLabel',Query.QueryLabel);
	if (Idx != INDEX_NONE)
	{
		PassiveQueries.Remove(Idx,1);
	}
}

simulated event ReceivedNewEvent(SequenceEvent Evt)
{
	`AILog(`location@`showvar(Evt));
	if (SeqEvt_AIStimulus(Evt) != None)
	{
		KismetQueries.AddItem(SeqEvt_AIStimulus(Evt));
	}
}

/** Returns TRUE if we have any active stimulus we should react to. */
function bool HasAnyStimulus()
{
	return Stimuli.Length > 0 && `TimeSince(Stimuli[0].Time) < MaxStimulusTime;
}

function bool SingleResultStimulusQuery(const out StimulusQuery Query, out int StimulusIdx)
{
	local int Idx;
	for (Idx = 0; Idx < Stimuli.Length; Idx++)
	{
		if (StimulusPassesQuery(Idx,Query))
		{
			StimulusIdx = Idx;
			return TRUE;
		}
	}
	return FALSE;
}

function int MultipleResultStimulusQuery(const out StimulusQuery Query, out array<int> StimulusIndices)
{
	local int Idx;
	StimulusIndices.Length = 0;
	for (Idx = 0; Idx < Stimuli.Length; Idx++)
	{
		if (StimulusPassesQuery(Idx,Query))
		{
			StimulusIndices.AddItem(Idx);
		}
	}
	return StimulusIndices.Length;
}


/** 
 * This is the delegate type that is called from the Stimulus Queries when they pass.
 * 
 **/
delegate StimulusPassedQuery( int StimulusIdx, optional array<PlanIncreaseDatum> AIPlansRatingToIncrease )
{
}


function bool HasVisibleStimulus(optional out int StimulusIdx, optional int MinPriority = 0, optional float MinFOV = 0.2f, optional vector FOVDir, optional float MinDist = 0.f)
{
	`AILog(`location@`showvar(MinPriority), 'Stimuli' );

	if (IsZero(FOVDir))
	{
		FOVDir = vector(Pawn.Rotation);
	}

	for (StimulusIdx = 0; StimulusIdx < Stimuli.Length; StimulusIdx++)
	{
		if (Stimuli[StimulusIdx].bVisible &&
			`TimeSince(Stimuli[StimulusIdx].Time) < MaxStimulusTime &&
			Stimuli[StimulusIdx].Priority >= MinPriority &&
			Normal(Stimuli[StimulusIdx].Location - Pawn.Location) dot FOVDir >= MinFOV &&
			(MinDist <= 0.f || VSize(Stimuli[StimulusIdx].Location - Pawn.Location) < MinDist))
		{
			return TRUE;
		}
		else
		{
			`AILog(`showvar(StimulusIdx)@`showvar(`TimeSince(Stimuli[StimulusIdx].Time))@"visible:"@Stimuli[StimulusIdx].bVisible@"pri:"@Stimuli[StimulusIdx].Priority@Normal(Stimuli[StimulusIdx].Location - Pawn.Location) dot FOVDir@Stimuli[StimulusIdx].Actor@VSize(Stimuli[StimulusIdx].Location - Pawn.Location), 'Stimuli' );
		}
	}

	return FALSE;
}


function DescribeStimulus(int StimulusIdx,optional int MinPriority,optional float MinFOV = 0.2,optional vector FOVDir,optional float MinDist)
{
	`AILog(`showvar(StimulusIdx)@`showvar(`TimeSince(Stimuli[StimulusIdx].Time))@"visible:"@Stimuli[StimulusIdx].bVisible@"pri:"@Stimuli[StimulusIdx].Priority@Normal(Stimuli[StimulusIdx].Location - Pawn.Location) dot FOVDir@Stimuli[StimulusIdx].Actor@VSize(Stimuli[StimulusIdx].Location - Pawn.Location));
}


function TrimStimuli(Actor StimulusActor, bool bVisible, bool bIsFriendly)
{
	local int Idx;
	// first pass trim anything old and lower pri
	for (Idx = 0; Idx < Stimuli.Length; Idx++)
	{
		// only trim old if friendly, or if new is enemy
		if ( `TimeSince(Stimuli[Idx].Time) > MaxStimulusTime && (!bIsFriendly || Stimuli[Idx].bIsFriendly))
		{
			Stimuli.Remove(Idx--,1);
		}
		else if (Stimuli[Idx].Actor == StimulusActor)
		{
			if (bVisible)
			{
				Stimuli.Remove(Idx--,1);
			}
		}
	}
}


/** Returns location of last known stimulus */
function vector GetStimulusLocation(optional int StimulusIdx)
{
	return Stimuli[StimulusIdx].Location;
}


function vector GetNearestStimulusLocation(optional out int StimulusIdx)
{
	local float Dist, BestDist;
	local int BestIdx;
	for (StimulusIdx = 0; StimulusIdx < Stimuli.Length; StimulusIdx++)
	{
		if (`TimeSince(Stimuli[StimulusIdx].Time) < MaxStimulusTime)
		{
			Dist = VSize(Stimuli[StimulusIdx].Location - Pawn.Location);
			if (Dist < BestDist || BestDist == 0.f)
			{
				BestDist = Dist;
				BestIdx = StimulusIdx;
			}
		}
	}
	StimulusIdx = BestIdx;
	return Stimuli[StimulusIdx].Location;
}


function int PrioritizeStimulus(Actor StimulusActor, vector StimulusLocation, bool bVisible, bool bIsFriendly, bool bCombative )
{
	local float StimulusDistance;
	local int Priority;

	if( Pawn == None )
	{
		return 0;
	}

	Priority = 0;
	StimulusDistance = VSize2D(Pawn.Location - StimulusLocation);

	if( StimulusDistance < 512.f )
	{
		`AILog("+ stimuli close", 'Stimuli' );
		Priority = 5;
	}
	else if( StimulusDistance < 1024.f)
	{
		`AILog("+ stimuli somewhat close  < 1024", 'Stimuli' );
		Priority = 4;
	}
	else if( StimulusDistance < 2048.f )
	{
		`AILog("+ stimuli not very close  < 2048", 'Stimuli' );
		Priority = 3;
	}
	else if( StimulusDistance < 4096.f )
	{
		`AILog("+ stimuli far away  < 4096", 'Stimuli' );
		Priority = 2;
	}
	else if( StimulusDistance < 8192.f )
	{
		`AILog("+ stimuli far far away  < 8192", 'Stimuli' );
		Priority = 2;
	}
	else
	{
		`AILog("+ not close at all"@`showvar(StimulusDistance)@"Setting no Priority on this Stimulus");
	}

	if( bVisible )
	{
		`AILog("+ stimuli visible", 'Stimuli' );
		Priority += 1;
	}

	if( !bIsFriendly )
	{
		`AILog("+ not friendly", 'Stimuli' );
		Priority += 2;
		if( bCombative )
		{
			`AILog("+ combative!", 'Stimuli' );
			Priority += 2;
		}
	}
	return Priority;
}


final function int FindPriorityForStimulusActor(Actor StimulusActor)
{
	local int Priority, Idx;
	Priority = -1;
	for (Idx = 0; Idx < Stimuli.Length; Idx++)
	{
		if (Stimuli[Idx].Actor == StimulusActor && Stimuli[Idx].Priority > Priority && `TimeSince(Stimuli[Idx].Time) < MaxStimulusTime)
		{
			Priority = Stimuli[Idx].Priority;
		}
	}
	return Priority;
}


final function AddStimulus(Actor StimulusActor, vector StimulusLocation, bool bVisible, optional bool bIsFriendly, optional bool bCombative, optional bool bDamaged)
{
	local int Priority, Idx;
	local StimulusQuery Query;
	local SeqEvt_AIStimulus Evt;
	local array<int> QuerySuccesses;

	Priority = PrioritizeStimulus( StimulusActor, StimulusLocation, bVisible, bIsFriendly, bCombative );

	if (Priority >= 0)
	{
		if (NanoPawn(StimulusActor) != None && NanoPawn(StimulusActor).bDebugInvisToAI)
		{
			return;
		}
		// remove lower pri + old stuff
		TrimStimuli(StimulusActor,bVisible,bIsFriendly);
		// and add new one
		Stimuli.Insert(0,1);
		Stimuli[0].Location = StimulusLocation;
		Stimuli[0].Actor = StimulusActor;
		Stimuli[0].Time = WorldInfo.TimeSeconds;
		Stimuli[0].bVisible = bVisible;
		Stimuli[0].Priority = Priority;
		Stimuli[0].bIsFriendly = bIsFriendly;
		Stimuli[0].bCombative = bCombative;
		Stimuli[0].bDamaged = bDamaged;

		`AILog(`location@`showvar(StimulusActor)@`showvar(bVisible)@`showvar(Priority)@`showvar(bIsFriendly), 'Stimuli' );

		StimulusAdded();

		// check for any passive queries
		for (Idx = 0; Idx < PassiveQueries.Length; Idx++)
		{
			Query = PassiveQueries[Idx];
			if (StimulusPassesQuery(0,Query))
			{
				PassiveQueries[Idx].LastQueryAttempt = WorldInfo.TimeSeconds;
				StimulusPassedQuery = Query.StimulusPassed;
				StimulusPassedQuery( 0, Query.AIPlansThisIncreases );
			}
		}

		// check for any Kismet queries
		foreach KismetQueries(Evt)
		{
			QuerySuccesses.Length = 0;
			for (Idx = 0; Idx < Evt.Queries.Length; Idx++)
			{
				Query = Evt.Queries[Idx];
				if (StimulusPassesQuery(0,Query))
				{
					Evt.Queries[Idx].LastQueryAttempt = WorldInfo.TimeSeconds;
					`AILog("Activate"@`showvar(Evt)@Idx);
					QuerySuccesses.AddItem(Idx);
				}
			}
			if (QuerySuccesses.Length > 0)
			{
				// c.f. http://jira/browse/NANO-538
				Evt.CheckActivate(Stimuli[0].Actor,Stimuli[0].Actor,false,QuerySuccesses);
			}
		}
	}
	else
	{
		`AILog(`location@"ignoring"@`showvar(StimulusActor)@`showvar(Priority), 'Stimuli' );
	}
}


final function bool StimulusPassesQuery(int Idx, const out StimulusQuery Query)
{
	local vector FOVDir;
	local NanoPawn QueryNP;
	local int SkillIdx;
	local NanoSkill ActiveSkill;
	local bool bFoundMatch;

	local bool bChaosOverride;
	local TargetableOctreeComponent Targetable;
	local bool bMeleeRingsHaveRoom;
	local NanoAIBlackboard Blackboard;

	local NanoInterface_Targetable NIT;
	local bool bIsActuallyCombative;


	// can do tricky things here I guess
	// need to have some "override rule" that says:  hey if we have any chaos then go ahead 
	// and ignore certain rules and say they passed.  (e.g.  if a query REQUIRES damage, then if there is chaos do not
	// require chaos)

	if( NanoGRI(WorldInfo.GRI).AIBlackboard.CachedCurrChaosTier  > 0 )
	{
		bChaosOverride = TRUE;
	}


	if (Query.RetryDelay > 0.f && `TimeSince(Query.LastQueryAttempt) < Query.RetryDelay)
	{
		`AILog("+ fail retry delay");
		return FALSE;
	}

	// check for friendly right off the bat.  We have LOTS of AIs all generating stimuli so let's do any extra work if
	// they are from our friends
	if (!Query.bAllowFriendly && Stimuli[Idx].bIsFriendly)
	{
		`AILog("+ fail friendly", 'Stimuli' );
		return FALSE;
	}

	if (!Query.bAllowNonFriendly && !Stimuli[Idx].bIsFriendly)
	{
		`AILog("+ fail non friendly", 'Stimuli' );
		return FALSE;
	}

	NIT = NanoInterface_Targetable(Stimuli[Idx].Actor);

	if (NIT != None )
	{
		if( NIT.IsTargetable() == FALSE )
		{
			`AILog("+ NIT.IsTargetable() == FALSE!", 'Stimuli' );
			return FALSE;
		}
	} 


	if (NIT != None )
	{
		Targetable = NIT.GetTargetableOctreeComponent();
		Blackboard = GetBlackBoard();

		if( Targetable.bHasOverridesForMeleeListRanges == TRUE )
		{
			bMeleeRingsHaveRoom = ( Targetable.MeleeSpectatorList.Length < Targetable.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeSpectator ) || ( Targetable.MeleeStandByList.Length < Targetable.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeStandby ) || ( Targetable.MeleeEngageList.Length < Targetable.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeEngage ) || Targetable.RangedShooterList.Length < Targetable.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumRangedShooter;
		}
		else
		{
			bMeleeRingsHaveRoom = ( Targetable.MeleeSpectatorList.Length < Blackboard.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeSpectator ) || ( Targetable.MeleeStandByList.Length < Blackboard.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeStandby ) || ( Targetable.MeleeEngageList.Length < Blackboard.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeEngage ) || Targetable.RangedShooterList.Length < Blackboard.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumRangedShooter;
		}

		//`log( "Found a NanoInterface_Targetable" @ `showvar(Stimuli[Idx].Actor) @ `showvar(Targetable.MeleeEngageList.Length) @ `showvar(bMeleeRingsHaveRoom) @ `showvar(Targetable.bHasOverridesForMeleeListRanges) ); 
		//if( Targetable.bHasOverridesForMeleeListRanges )
		//{
		//	`log( `showvar(Targetable.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeEngage) @ `showvar(Targetable.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeStandby) @ `showvar(Targetable.MeleeListRanges[Blackboard.CachedCurrChaosTier].NumMeleeSpectator ) );
		//}

		if( bMeleeRingsHaveRoom == FALSE )
		{
			`AILog("+ bMeleeRingsHaveRoom FALSE", 'Stimuli' );
			return FALSE;
		}
	}




	//`AILog( `showvar(bChaosOverride) @ `showvar(Query.bDisregardChaosOverride_RequireDamaged) @ `showvar(Query.bRequireDamaged) @ `showvar(Stimuli[Idx].bDamaged) );


	// if this query is disregarding the ChaosOverride
	if( ( bChaosOverride == FALSE ) || ( Query.bDisregardChaosOverride_RequireDamaged == TRUE ) )
	{
		if (Query.bRequireDamaged && !Stimuli[Idx].bDamaged)
		{
			`AILog("+ fail require damaged", 'Stimuli' );
			return FALSE;
		}
	}


	// turn this back on when we want there to be a requirement of chaos being up before the AI will respond to drawn weapons
	//if( bChaosOverride == FALSE )
	//{

	QueryNP = NanoPawn(Stimuli[Idx].Actor);

	if( QueryNP != None )
	{
		// so check all of the vars that cause "hot stimuli"
		bIsActuallyCombative = bIsActuallyCombative || `TimeSince( QueryNP.LastMeleeAttackTime ) < HotSimulusDuration;
		bIsActuallyCombative = bIsActuallyCombative || `TimeSince( QueryNP.LastWeaponFireTime ) < HotSimulusDuration;
		bIsActuallyCombative = bIsActuallyCombative || `TimeSince( QueryNP.LastCausedCrowdPanicTime ) < HotSimulusDuration;
		bIsActuallyCombative = bIsActuallyCombative || `TimeSince( QueryNP.LastTookDamageTime ) < HotSimulusDuration;
	}

	bIsActuallyCombative = bIsActuallyCombative || Stimuli[Idx].bCombative;


		if( Query.bRequireCombative == QO_Require && !bIsActuallyCombative )
		{
			`AILog("+ fail require combative", 'Stimuli' );
			return FALSE;
		}
		else if( Query.bRequireCombative == QO_Disallow && bIsActuallyCombative )
		{
			`AILog("+ fail require not combative", 'Stimuli' );
			return FALSE;
		}
	//}


	if (Query.Visibility == QO_Require && !Stimuli[Idx].bVisible)
	{
		`AILog("+ fail require visible", 'Stimuli' );
		return FALSE;
	}
	else if (Query.Visibility == QO_Disallow && Stimuli[Idx].bVisible)
	{
		`AILog("+ fail require not visible", 'Stimuli' );
		return FALSE;
	}

	if (Query.MinPriority > Stimuli[Idx].Priority)
	{
		`AILog("+ fail min priority"@`showvar(Query.MinPriority)@`showvar(Stimuli[Idx].Priority), 'Stimuli' );
		return FALSE;
	}

	if (Query.MaxPriority > 0 && Query.MaxPriority < Stimuli[Idx].Priority)
	{
		`AILog("+ fail max priority"@`showvar(Query.MaxPriority), 'Stimuli' );
		return FALSE;
	}

	if (Query.MaxStimulusTime > 0.f && `TimeSince(Stimuli[Idx].Time) > MaxStimulusTime)
	{
		`AILog("+ fail stimulus time", 'Stimuli' );
		return FALSE;
	}

	if (Query.MinFOV > -1.f)
	{
		FOVDir = Query.FOVDir;
		if (IsZero(FOVDir))
		{
			FOVDir = vector(Rotation);
		}
		if ((Normal(Stimuli[Idx].Location - Pawn.Location) dot FOVDir) < Query.MinFOV)
		{
			`AILog("+ fail min fov"@`showvar(Query.MinFOV), 'Stimuli' );
			return FALSE;
		}
	}

	if (Query.MaxFOV > -1.f)
	{
		FOVDir = Query.FOVDir;
		if (IsZero(FOVDir))
		{
			FOVDir = vector(Rotation);
		}
		if ((Normal(Stimuli[Idx].Location - Pawn.Location) dot FOVDir) > Query.MaxFOV)
		{
			`AILog("+ fail max fov"@`showvar(Query.MinFOV), 'Stimuli' );
			return FALSE;
		}
	}
	
	// so here we need to test to see if the ai is on the ground only?

	// and have a different Z height check?  



	if (Query.MinDist > 0.f && VSize(Stimuli[Idx].Location - Pawn.Location) < Query.MinDist)
	{
		`AILog("+ fail min dist"@`showvar(Query.MinDist), 'Stimuli' );
		return FALSE;
	}

	// @todo:  we probably want to add an angle check here also.  So things that are really acute take full DistanceAboveUsToIgnoreStimuli
	// and things that are more obtuse only use a portion.  (idea being if you are directly above it is harder to see you than
	// if you are far away
	if( Query.DistanceAboveUsToIgnoreStimuli > 0 && 
		(Stimuli[Idx].Location.Z - Pawn.Location.Z) > Query.DistanceAboveUsToIgnoreStimuli ) // if the stimulus is N stories above the AI
	{
		//`log("+ fail due to stimuli being far above the AI" @ (Stimuli[Idx].Location.Z - Pawn.Location.Z) );
		`AILog("+ fail due to stimuli being far above the AI" @ (Stimuli[Idx].Location.Z - Pawn.Location.Z), 'Stimuli' );
		return FALSE;
	}

	if( Query.DistanceBelowUsToIgnoreStimuli > 0 && 
		(Stimuli[Idx].Location.Z - Pawn.Location.Z) < -Query.DistanceBelowUsToIgnoreStimuli  ) // if the stimulus is N stories above the AI
	{
		//`log("+ fail due to stimuli being far below the AI" @ (Stimuli[Idx].Location.Z - Pawn.Location.Z) );
		`AILog("+ fail due to stimuli being far below the AI" @ (Stimuli[Idx].Location.Z - Pawn.Location.Z), 'Stimuli' );
		return FALSE;
	}

	if (Query.MaxDist > 0.f && VSize(Stimuli[Idx].Location - Pawn.Location) > Query.MaxDist)
	{
		if (!Stimuli[Idx].bVisible || Stimuli[Idx].Actor == None || VSize2D(Stimuli[Idx].Actor.Location - Pawn.Location) > Query.MaxDist)
		{
			`AILog("+ fail max dist"@`showvar(Query.MaxDist)@VSize2D(Stimuli[Idx].Location - Pawn.Location)@`showvar(Stimuli[Idx].Actor), 'Stimuli' );
			return FALSE;
		}
	}

	if (Query.NanoSkillUsage.Length > 0)
	{
		QueryNP = NanoPawn(Stimuli[Idx].Actor);
		if (QueryNP != None)
		{
			for (SkillIdx = 0; SkillIdx < Query.NanoSkillUsage.Length; SkillIdx++)
			{
				bFoundMatch = FALSE;
				foreach QueryNP.ActiveSkills(ActiveSkill)
				{
					if (ClassIsChildOf(ActiveSkill.Class,Query.NanoSkillUsage[SkillIdx].Skill))
					{
						bFoundMatch = TRUE;
						if (Query.NanoSkillUsage[SkillIdx].MinSkillLevel >= 0 && Query.NanoSkillUsage[SkillIdx].MinSkillLevel > ActiveSkill.ActiveSkillLevel)
						{
							`AILog("+ fail skill min level check"@Skill);
							return FALSE;
						}
						if (Query.NanoSkillUsage[SkillIdx].MaxSkillLevel >= 0 && Query.NanoSkillUsage[SkillIdx].MaxSkillLevel < ActiveSkill.ActiveSkillLevel)
						{
							`AILog("+ fail skill max level check"@Skill);
							return FALSE;
						}
						if (Query.NanoSkillUsage[SkillIdx].Usage == QO_Disallow)
						{
							`AILog("+ fail skill usage disallow"@Skill);
							return FALSE;
						}
					}
				}
				if (!bFoundMatch && Query.NanoSkillUsage[SkillIdx].Usage == QO_Require)
				{
					`AILog("+ fail skill usage require"@Query.NanoSkillUsage[SkillIdx].Skill);
					return FALSE;
				}
			}
		}
	}

	//`AILog( "++ Query Passes" @ StimulusQueryToString( Query ), 'Stimuli' );
	return TRUE;
}


// This is an "AICmd/AIPlaner Interface function which we will need to implement in the NanoAIBase and NanoAICmd
// any StimulusPassed functions will need this type of set up
delegate IdleQueryTripped( int StimulusIdx, optional array<PlanIncreaseDatum> AIPlansRatingToIncrease )
{
	local NanoAICmd ActiveCmd;

	ActiveCmd = NanoAICmd(GetActiveCommand());
	if( ActiveCmd != none )
	{
		ActiveCmd.IdleQueryTripped( StimulusIdx, AIPlansRatingToIncrease );
	}
	else
	{
		`warn( "IdleQueryTripped was tripped with a none NanoAICmd on the stack" @ GetActiveCommand() @ " This probably means that there is an state that is not an AICmd and should be fixed." );
	}
}



//// BOIDS

function SetActiveBoidMovementByClass( class<BoidMovementRule> BoidClass, bool bSet )
{
	local int Idx;

	for( Idx = 0; Idx < BoidRules.Length; Idx++ )
	{
		if( ClassIsChildOf( BoidRules[Idx].Class, BoidClass ) )
		{
			//`AILog("SetActiveBoidMovementByClass"@`location@`showvar(BoidClass)@`showvar(bSet));
			//if( bSet == FALSE )
			//{
			//	ScriptTrace();
			//}
			BoidRules[Idx].SetActive( bSet );
		}
	}
}

function ClearBoidMovementByClass( class<BoidMovementRule> BoidClass )
{
	local int Idx;

	for( Idx = 0; Idx < BoidRules.Length; Idx++ )
	{
		if( ClassIsChildOf( BoidRules[Idx].Class, BoidClass ) )
		{
			//`AILog("ClearBoidMovementByClass"@`location@`showvar(BoidClass));
			BoidRules.Remove( Idx--, 1 );
		}
	}
}

function CleanupBoidRules()
{
	BoidRules.Length = 0;
}

function SetUseBoidMovement( bool bUse )
{
	//`AILog(" SetUseBoidMovement"@`location@`showvar(bUse));
	bUseBoidMovement = bUse;
}

function HandleBoidAlteringEvent( Name EventName, bool bEnableBoids )
{
	//`AILog(" HandleBoidAlteringEvent"@`location@`showvar(EventName)@`showvar(bEnableBoids));
	SetUseBoidMovement( bEnableBoids );
}


/** This will look at the active boid rules and set their bAvoidTeammates to the passed in bool **/
function ModifyActiveBoidMovement_AvoidTeammates( bool NewVal )
{
	local int Idx;

	for( Idx = 0; Idx < BoidRules.Length; Idx++ )
	{
		if( BoidRules[Idx].bActive == TRUE )
		{
			`AILog("ModifyActiveBoidMovement_AvoidTeammates"@`location@`showvar(BoidRules[Idx])@`showvar(NewVal));
			BoidRules[Idx].bAvoidTeammates = NewVal;
		}
	}
}

/** This will look at the active boid rules and set their bAvoidTeammates to the passed in bool **/
function ModifyActiveBoidMovement_AntiTwitchDelta( float NewVal )
{
	local int Idx;

	for( Idx = 0; Idx < BoidRules.Length; Idx++ )
	{
		if( BoidRules[Idx].bActive == TRUE )
		{
			//`log( self @ "ModifyActiveBoidMovement_AntiTwitchDelta"@`location@`showvar(BoidRules[Idx])@`showvar(NewVal));
			`AILog("ModifyActiveBoidMovement_AntiTwitchDelta"@`location@`showvar(BoidRules[Idx])@`showvar(NewVal));
			BoidRules[Idx].AntiTwitchDelta = NewVal;
		}
	}
}


/** This will look at the active boid rules and set their bAvoidTeammates to the passed in bool **/
function ModifyActiveBoidMovement_UseMinEnemyLocationChangeToUpdate( bool NewVal )
{
	local int Idx;

	for( Idx = 0; Idx < BoidRules.Length; Idx++ )
	{
		if( BoidRules[Idx].bActive == TRUE )
		{
			//`log( self @ "ModifyActiveBoidMovement_UseMinEnemyLocationChangeToUpdate"@`location@`showvar(BoidRules[Idx])@`showvar(NewVal));
			`AILog("ModifyActiveBoidMovement_UseMinEnemyLocationChangeToUpdate"@`location@`showvar(BoidRules[Idx])@`showvar(NewVal));
			BoidRules[Idx].bUseMinEnemyLocationChangeToUpdate = NewVal;
		}
	}
}









//// NOTIFIES


function NotifyTakeHit(Controller InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
{
	local NanoDefensivePoint NDP;
	local NanoGRI NGRI;


	Super.NotifyTakeHit(InstigatedBy,HitLocation,Damage,damageType,Momentum);

	if( ( InstigatedBy != None ) && ( InstigatedBy.Pawn != None ) && ( Damage > 0 ) )
	{
		NGRI = NanoGRI(WorldInfo.GRI);

		// add combative stimulus
		AddStimulus(InstigatedBy.Pawn,HitLocation,TRUE,IsFriendlyActor(InstigatedBy),TRUE,TRUE);
		NGRI.GetCurrentChaosManager().ModifyChaosLevel( InstigatedBy, class'NanoCausingChaosValues'.default.DamageInflicted );

		NDP = CurrNanoDefensivePoint;
	
		// so we are hacking this here for now
		if( NDP != None )
		{
			NDP.UnderAttack();

			//`log( "NotifyTakeHit:" @ self @ InstigatedBy @ HitLocation @ `showvar(NDP.DistanceToReactDueToSniperKill) );
			NGRI.AddStimuliInARadiusAroundEvent( NDP.DistanceToReactDueToSniperKill, InstigatedBy.Pawn, HitLocation, TRUE, FALSE, TRUE, TRUE );
			
			//DrawDebugSphere( HitLocation, NDP.DistanceToReactDueToSniperKill, 10, 255, 0, 0, TRUE );			
		}
		else
		{
			//`log( "!!!!!!! NotifyTakeHit" @ self @ `showvar(CurrNanoDefensivePoint) @ `showvar(damageType) );
		}
	}
}


function NotifyKilled(Controller Killer, Controller Killed, pawn KilledPawn, class<DamageType> damageType)
{

	local NanoDefensivePoint NDP;

	`AILog(`location@`showvar(Killer));

	Super.NotifyKilled(Killer,Killed,KilledPawn,damageType);

	if (KilledPawn == Pawn)
	{
		if( NanoAIBase(Killed) != none )
		{
			NDP = NanoAIBase(Killed).CurrNanoDefensivePoint;
		}

		// so we are hacking this here for now
		if( ( NDP != None ) && ( ClassIsChildOf( class'NDT_KilledByProceduralSpawner', damageType) == FALSE ) )
		{
			NDP.UnderAttack();
		}

		if( Killer != none )
		{
			AddStimulus(Killer.Pawn,KilledPawn.Location,TRUE,IsFriendlyActor(Killer),TRUE,TRUE);
		}
		
		GotoState('Dead');
	}
}

event bool NotifyBump(Actor Other, Vector HitNormal)
{
	local NanoAICmd_Move MoveCmd;
	local Pawn P;
	local bool bShouldAttackPlayer;

	P = Pawn(Other);
	if( P != None )
	{
		bShouldAttackPlayer = (P.Weapon != None && NanoWeap_Hands(P.Weapon) == None) || bShouldAttackPlayersWithoutWeaponsVisible;
	}

	AddStimulus(Other,Other.Location,TRUE,IsFriendlyActor(Other),bShouldAttackPlayer);
	MoveCmd = NanoAICmd_Move(GetActiveCommand());
	if (MoveCmd != None)
	{
		return MoveCmd.HandleBump(Other,HitNormal);
	}
	return Super.NotifyBump(Other,HitNormal);
}


event HearNoise( float Loudness, Actor NoiseMaker, optional Name NoiseType )
{
	local Pawn P;
	local bool bShouldAttackPlayer;

	`AILog(`location@`showvar(NoiseType),'Stimuli');
	// OPTIMIZE:
	// AController::CanHear() just returns a UBOOL.  But it can do a bunch of stuff in there such a linecheck!
	// So when you get to here you end up doing more linechecks from CanSee (even tho you probably already did one)
	// which results in RefireCheckTimer ..... NanoWeaponPlaySoundLocal doing excessive line checks

	P = Pawn(NoiseMaker);
	if( P != None )
	{
		bShouldAttackPlayer = (P.Weapon != None && NanoWeap_Hands(P.Weapon) == None) || bShouldAttackPlayersWithoutWeaponsVisible;
	}
	bShouldAttackPlayer = bShouldAttackPlayer || (NoiseType == 'NanoWeaponPlaySoundLocal');

	AddStimulus(NoiseMaker,NoiseMaker.Location,CanSee(Pawn(NoiseMaker)),IsFriendlyActor(NoiseMaker), bShouldAttackPlayer );
}

// this is what is used to make the player aggro when it sees it
event SeePlayer(Pawn Seen)
{
	local bool bShouldAttackPlayer;

	bShouldAttackPlayer = (Seen.Weapon != None && NanoWeap_Hands(Seen.Weapon) == None) || bShouldAttackPlayersWithoutWeaponsVisible;

	AddStimulus(Seen,Seen.Location,TRUE,IsFriendlyActor(Seen),bShouldAttackPlayer);
}

event SeeMonster(Pawn Seen)
{
	AddStimulus(Seen,Seen.Location,TRUE,IsFriendlyActor(Seen));
}






/**
 * This will look at all of the cmds an AI has and see if it can do the passed in plan.
 *
 *
 *
 *
 * So in here is where we need to look at the world and see if there are any "sims object model" aicmds out there that
 * we can do
 *
 *
 *
 *
 **/
function class<NanoAIAction> FindBestAIActionForPlan( out string UtilityString )
{
	local class<NanoAIAction> AnAction;
	local array< class< NanoAIAction> > ListOfValidAIActions;
	//local int IdxToChoose;
	local int ActionRating;
	local int BestActionRating;
	local class<NanoAIAction> BestAction;
	local int DebugIdx;

	// for all of the AICmds that AI can do
	foreach ListOfAIActionsThisAICanDo( AnAction )
	{
		ListOfValidAIActions.AddItem( AnAction );

		//debug
		if( ListOfAIActionsThisAIEverConsidered.Find( AnAction ) < 0 )
		{
			ListOfAIActionsThisAIEverConsidered.AddItem( AnAction );
		}
	}

	


	// run through them all and evaluate them via some utility function
	// having a rating on each ai cmd?
	//     -each ai cmd can then look at the black board and see what is up?
	//     -


	LastUtilityRatingsList.Length = 0;
	if( ListOfValidAIActions.Length > 0 )
	{		
// 		`log( "Now Choosing from:" @ ListOfValidAICmds.Length);
// 		foreach ListOfValidAICmds( ACmd )
// 		{
// 			`log( "   " @ ACmd );
// 		}

		UtilityString @= ( self @ "FindBestAIAction Now Choosing from:" @ ListOfValidAIActions.Length @ "\n");
		foreach ListOfValidAIActions( AnAction )
		{
			ActionRating = AnAction.static.GetUtility( Self );
			UtilityString @= ( "   " @ AnAction @ ActionRating @ "\n" );

			//debug
			if( ActionRating > 0.f )
			{
				DebugIdx = LastUtilityRatingsList.Length;
				LastUtilityRatingsList.Length = DebugIdx + 1;
				LastUtilityRatingsList[DebugIdx].ActionClass = AnAction;
				LastUtilityRatingsList[DebugIdx].UtilityRating = ActionRating;
			}

			if( ActionRating > BestActionRating )
			{
				BestActionRating = ActionRating;
				BestAction = AnAction;
			}
		}


		UtilityString @= ( "    ==>" @ `showvar(BestAction) @ `showvar(BestActionRating) @ "\n" );

		return BestAction;
	}
	else
	{
		// if you are seeing this then you need to make certain ListOfAIActionsThisAICanDo has items
		// and then look at each of their GetUtility functions to see what is hosed
		// AIPlanner.uc  DoTopRatedAction   has a bunch of log functions to see what each action is rated
		`warn( "No AICmds found that have a higher than 0 GetUtility Rating"  );
		`log( "Was Choosing from:" @ `showvar(ListOfValidAIActions.Length) );
		foreach ListOfValidAIActions( AnAction )
		{
			`log( "   " @ AnAction @ "UtilityRating:" @ AnAction.static.GetUtility( Self ) );
		}
	}

	return none;
}


function ResetCombatEffectors()
{
	local int i;

	for( i = 0; i < ERT_MAX; ++i )
	{
		CombatResponse[i] = 0;
	}
}


function DegradeCombatEffectors()
{
	local int i;

	for( i = 0; i < ERT_MAX; ++i )
	{
		CombatResponse[i] *= 0.80f;
	}
}


/** chimpy helper function until we can add ToString() to all our structs.  time time need more time **/
function String StimulusQueryToString( const out StimulusQuery Query )
{
	local String Retval;

	Retval @= Query.QueryLabel @ " ";

	Retval @= Query.bAllowFriendly @ " ";
	Retval @= Query.bAllowNonFriendly @ " ";
	Retval @= Query.bRequireDamaged @ " ";
	Retval @= Query.bDisregardChaosOverride_RequireDamaged @ " ";


	return Retval;
}


function bool PossiblyPickFireTarget();


function EnableHeadTracking()
{
	local NanoPawn NP;

	NP = NanoPawn(Pawn);

	//`log( `showvar(NP.HeadTrackSkelControl) );
	if( (NP != None) && (NP.HeadTrackSkelControl != None) )
	{
		NP.HeadLookAtActor = GetHeadTrackingTarget();
		NP.HeadLookAtBoneName = 'b_MF_Head';

		if(NP.HeadLookAtActor != None )
		{
			NP.HeadTrackSkelControl.SetSkelControlActive(TRUE);
		}
	}
}

function DisableHeadTracking()
{
	local NanoPawn NP;

	NP = NanoPawn(Pawn);
	if( (NP != None) && (NP.HeadTrackSkelControl != None) )
	{
		NP.HeadLookAtActor = None;
		NP.HeadLookAtBoneName = '';
		NP.HeadTrackSkelControl.SetSkelControlActive(FALSE);
	}
}

function Actor GetHeadTrackingTarget()
{
	return NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn;
}



defaultproperties
{
	NavigationHandleClass=class'NanoNavigationHandle'

	bIsPlayer=FALSE

	CurrentAIMood=AIMood_Unaware

	bUseBoidMovement=TRUE

	MaxStimulusTime=2.f
	bSkipExtraLOSChecks=TRUE

	TickFrequencyDecreaseDistanceStart=6000
	TickFrequencyDecreaseDistanceEnd=10000
	TickFrequencyAtEndDistance=0.1

	MoveOffset=128.0f
}