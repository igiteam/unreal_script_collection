/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAI_SentryBot extends NanoAI;

var NanoPawn_MetaCorp_SentryBotBase MySentryBot;

var vector PointOfInterest;
var transient NanoInterface_TattlerBotDock Dock;
var transient NanoInterface_TattlerBotDock PendingDock;
var vector UndockingLocation;

var float AlertRange;
var vector AlertMoveLocation;

var float DockedFOV;

/** How long does it take from seeing an illicit action to decay **/
var float IllicitSkillUsageDegradeTime;
var transient float LastIllicitSkillSeen;

/** This is the number of illicit dashes that need to be seen before stimulus is fired **/
var int NumIllicitDashSeenTrigger;
var transient int NumIllicitDashSeen;

/** This is the number of illicit jumps that need to be seen before stimulus is fired **/
var int NumIllicitJumpSeenTrigger;
var transient int NumIllicitJumpSeen;

/** We need to keep a bool around as the stimulus system results in many stimulii per target while we just want a single notification of when target is lost or found for chaos level modification **/
var transient bool bCountedChaosForThisTarget;

/** 
 *  This is the min distance at which the sentry bot will look to broadcast to other AI.  Anything smaller than this it is assumed that those AI
 * are already aware of what is occurring (or will be shortly!!)  
 **/
var float BroadcastStimuliDistanceMin;
/**
 *  This is the max distance at which sentry bots will broadcast info to.  Anything outside of this range can't be reached by the paltry broadcast
 *  limits of the sentry bot (and Thorn's jamming of said broadcasting).  So with this it makes a real mesh for information to flow over.
 **/ 
var float BroadcastStimuliDistanceMax;

/** The time between drop pod summons **/
var config vector2d SummonDropPodRange;

var vector DropPodLandingSpot;


event Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess(NewPawn,bVehicleTransition);
	MySentryBot = NanoPawn_MetaCorp_SentryBotBase(NewPawn);
	GotoState( 'Undocking' );
}

function int PrioritizeStimulus(Actor StimulusActor, vector StimulusLocation, bool bVisible, bool bIsFriendly, bool bCombative )
{
	local NanoPawn NP;
	local int Priority;
	Priority = Super.PrioritizeStimulus(StimulusActor,StimulusLocation,bVisible,bIsFriendly, bCombative );

	// Only care about boosting priority of enemies
	NP = NanoPawn(StimulusActor);
	if (NP != None && NP.GetTeamNum() != GetTeamNum() )
	{
		// if they're doing anything abnormal pay attention
		if (NP.bIsSwordActive 
			|| !NP.bEmptyHanded 
			|| NP.CurrNanoState != ENS_Normal
			|| IsPawnDoingIllicitSkills( NP )
			)
		{
			`AILog("Player doing something"@`showvar(NP));
			Priority++;
		}
	}
	return Priority;
}

/** This will degrade the number of Illicit skill usages seen. (currently this just resets to 0) **/
function IllicitSkillUsageDegrade()
{
	//`log( "IllicitSkillUsageDegradeIllicitSkillUsageDegradeIllicitSkillUsageDegradeIllicitSkillUsageDegrade" );
	NumIllicitDashSeen = 0;
	NumIllicitJumpSeen = 0;
}

/** Checks to see if this pawn is doing any illicit skills **/
function bool IsPawnDoingIllicitSkills( NanoPawn NP )
{
	local NanoSkill_Dash SKD;
	local NanoSkill_Jump SKJ;

	// so every one second we will actually process the stimulus
	if( ( ( LastIllicitSkillSeen - WorldInfo.TimeSeconds ) > -1.0f )
		// and if we are not already in an alert state (dirty but works for now)
		&& ( NumIllicitDashSeen < NumIllicitDashSeenTrigger )
		&& ( NumIllicitJumpSeen < NumIllicitJumpSeenTrigger )
		)
	{
		return FALSE;
	}

	//`log( "IsPawnDoingIllicitSkills" );

	LastIllicitSkillSeen = WorldInfo.TimeSeconds;

	SKD = NP.GetActiveSkill(class'NanoSkill_Dash');

	if( ( SKD != None ) && ( SKD.GetCurrentSkillLevelInUse() >= 2 ) )
	{
		if( ++NumIllicitDashSeen > NumIllicitDashSeenTrigger )
		{
			// so here we want to start up our IllicitTrigger degrading
			SetTimer( IllicitSkillUsageDegradeTime, FALSE, nameof(IllicitSkillUsageDegrade) );
			//`log( "IsPawnDoingIllicitSkills DASHING!!!" @ NumIllicitDashSeen );
			return TRUE;
		}
	}
	

	SKJ = NP.GetActiveSkill(class'NanoSkill_Jump');

	if( ( SKJ != None ) && ( SKJ.GetCurrentSkillLevelInUse() >= 1 ) )
	{
		if( ++NumIllicitJumpSeen > NumIllicitJumpSeenTrigger )
		{
			// so here we want to start up our IllicitTrigger degrading
			SetTimer( IllicitSkillUsageDegradeTime, FALSE, nameof(IllicitSkillUsageDegrade) );
			//`log( "IsPawnDoingIllicitSkills JUMPING!!!" @ NumIllicitJumpSeen );
			return TRUE;
		}
	}
	
	return FALSE;
}


final function BroadcastStimuliToMetaCorpUnits( int StimuliIdx )
{
	local NanoAI AI;
	local Actor StimuliActor;
    local float DistanceToMetaCorpUnit;

	if( ( StimuliIdx < 0 ) || ( Stimuli.length == 0 ) )
	{
		return;
	}

	StimuliActor = Stimuli[StimuliIdx].Actor;

	if( StimuliActor != none )
	{
		// this makes the "stimulus net" but it also ends up touching EVERY AIController in the level! and each Sentry bot does this
		// so when they are all near you they will all go bonkers and end up all AddStimulus so:
		// 10 sentry bots all doing this is like 81 calls to AddStimulus and like 400 iterations if there are 40 other AI controllers (which there
		// will be when there are lots of SecurityCameras (e.g. sp_cityscale_p has about 56 AI Controllers active when you start fighting in a chaos
		// tier 1 fight )
		foreach WorldInfo.AllControllers( class'NanoAI', AI )
		{
			if( AI.Pawn != none
				&& Pawn != none
				)
			{
				DistanceToMetaCorpUnit = VSize(AI.Pawn.Location - Pawn.Location);
			}

			if( AI != self 
				&& DistanceToMetaCorpUnit > BroadcastStimuliDistanceMin // so assumption here is that if people are close to this AI then they will get the same stimulus that this AI trying to tell them it just got.  So don't tell them!  (it helps a TON in reducing the needless chatter)
                && DistanceToMetaCorpUnit < BroadcastStimuliDistanceMax // and we don't shout across the entire map at every single entity that is over there.  Just the ones near us.  And then it flows out to the others based on their locations / connections.  (Which is sort of neat)
				&& IsFriendlyActor(AI) 
				)
			{
				AI.AddStimulus( StimuliActor, StimuliActor.Location, TRUE, AI.IsFriendlyActor(StimuliActor) );
			}
		}
	}
}

function RegisterDock(NanoInterface_TattlerBotDock NewDock)
{
	if (NewDock != None)
	{
		`AILog(`location@`showvar(Dock));
		Dock = NewDock;
		SetRotation(Pawn.Rotation);
		GotoState('Docked');
	}
}

function RegisterPendingDock( NanoInterface_TattlerBotDock NewDock )
{
	if( NewDock != None )
	{
		`AILog(`location@`showvar(Dock));
		PendingDock	= NewDock;
		if( IsInState( 'Docked' ) )
		{
			Undock();
		}
		else
		{
			FinishedUndocking();			
		}
	}
}

function FinishedUndocking()
{
	if( PendingDock != None )
	{
		Dock = PendingDock;
		UndockingLocation = Dock.GetDockLocation( MySentryBot );
		ReturnToDock();
	}
}
	
function UpdateDockedAlertness();

function Undock();

function ReturnToDock()
{
	if( Dock != None )
	{
		GotoState( 'ReturningToDock' );
	}
}

state ReturningToDock
{
Begin:

	// TODO: handle the case where the dock has been destroyed / none'd   need to find another dock or just kill self

	// Give dock chance to prep bot for return
	Dock.PrepareReturnToDock(MySentryBot);

	// Move back to prepared docking position
	//todo: May need to make this handle a dynamic position...ie a moving pac-bot
	Focus = None;
	MySentryBot.DisableScanner();
	class'NanoAICmd_Move_Mesh'.static.MoveToPoint(self,UndockingLocation,FALSE);

	// Prep for move into docking position
	`AILog(`showvar(Dock.GetDockLocation(MySentryBot)));
	MySentryBot.PlaySpikeRetract();
	Sleep(0.25f);
	Dock.PrepareToDockBot(MySentryBot);

	// Move to final docking position
	MoveTo(Dock.GetDockLocation(MySentryBot,TRUE));
	`AILog("At dock");

	// Complete docking
	Dock.CompleteDock( MySentryBot );
	Sleep(0.5f);
	GotoState('Docked');
}

/** Locked into a sentry camera housing */
state Docked
{
	function ReturnToDock();
	
	function Undock()
	{
		GotoState('Undocking');
	}

	function BeginState(Name PrevStateName)
	{
		PendingDock = None;

		Dock.HandleNewDock(MySentryBot);	
	
		// Tell kismet we docked
		if( MySentryBot != None )
		{
			MySentryBot.TriggerEventClass( class'SeqEvt_Tattler', Dock, 2 );
			MySentryBot.bIsDocked = TRUE;

			if( bCountedChaosForThisTarget == TRUE )
			{
				// Tell kismet we stopped tracking something
				MySentryBot.TriggerEventClass( class'SeqEvt_Tattler', Focus, 1 );
				NanoGRI(WorldInfo.GRI).ModifyChaosLevel( GetChaosZone(), Focus, class'NanoCausingChaosValues'.default.TattlerBotLost );
				bCountedChaosForThisTarget = FALSE;
			}
		}
	}

	function EndState(Name NextStateName)
	{
		bClampRotation = FALSE;
		if( MySentryBot != None )
		{
			MySentryBot.bIsDocked = FALSE;
		}		
	}

	function CheckForStimulus()
	{
		local int Idx;
		local NanoCrowd_PedestrianBase Civ, BestCiv;
		local float Dist, BestDist;
		if (HasAnyStimulus())
		{
			// check for something to undock and chase
			if (HasVisibleStimulus(Idx,2,DockedFOV,Dock.GetDockLookDir(MySentryBot),AlertRange))
			{
				`AILog("Alert stimulus in view, undocking");
				MySentryBot.SetScannerAlert(TRUE);
				Focus = Stimuli[Idx].Actor;

				BroadcastStimuliToMetaCorpUnits( Idx );
		
				if( bCountedChaosForThisTarget == FALSE )
				{
					// Tell kismet we started tracking something
					MySentryBot.TriggerEventClass( class'SeqEvt_Tattler', Focus, 0 );
					NanoGRI(WorldInfo.GRI).ModifyChaosLevel( GetChaosZone(), Focus, class'NanoCausingChaosValues'.default.TattlerBotAquired );
					bCountedChaosForThisTarget = TRUE;
				}

				GotoState('Docked','Targeting');
				// set timer to undock in a sec
				if (!IsTimerActive(nameof(UpdateDockedAlertness)))
				{
					`AILog("- updated alertness");
					SetTimer(MaxStimulusTime,FALSE,nameof(UpdateDockedAlertness));
				}
			}
			// check for something to look at
			else if (HasVisibleStimulus(Idx,,DockedFOV,Dock.GetDockLookDir(MySentryBot),AlertRange))
			{
				`AILog("Normal stimulus");
				Focus = Stimuli[Idx].Actor;

				BroadcastStimuliToMetaCorpUnits( Idx );

				DescribeStimulus(Idx,,DockedFOV,Dock.GetDockLookDir(MySentryBot),AlertRange);
				GotoState('Docked','Targeting');
			}
			else
			{
				`AILog("No stimulus in view, sleeping");
				Focus = None;
				foreach MySentryBot.VisibleActors(class'NanoCrowd_PedestrianBase',Civ,AlertRange*0.5,MySentryBot.Location)
				{
					Dist = VSize(MySentryBot.Location - Civ.Location);
					if (BestCiv == None || Dist < BestDist)
					{	
						BestCiv = Civ;
						BestDist = Dist;
					}
				}
				if (BestCiv != None)
				{
					`AILog("Checking out some nano civ");
					Focus = BestCiv;
					GotoState('Docked','Targeting');
				}
			}
		}
    }

	function ValidateCurrentTarget()
	{
		local int Priority;
		local int Idx;
		if (Focus != None && Normal(Focus.Location - Pawn.Location) dot Dock.GetDockLookDir(MySentryBot) >= DockedFOV)
		{
			// if they've done something naughty then undock
			Priority = FindPriorityForStimulusActor(Focus);
			if (FindPriorityForStimulusActor(Focus) > 1)
			{
				MySentryBot.SetScannerAlert(TRUE);
				`AILog("High priority stimulus!");
				// set timer to undock in a sec
				if (!IsTimerActive(nameof(UpdateDockedAlertness)))
				{
					`AILog("- updated alertness");
					SetTimer(MaxStimulusTime,FALSE,nameof(UpdateDockedAlertness));
				}
			}
			else
			{
				// check for a more interesting focus
				if (HasVisibleStimulus(Idx,Priority,DockedFOV,Dock.GetDockLookDir(MySentryBot),AlertRange))
				{
					Focus = Stimuli[Idx].Actor;
					BroadcastStimuliToMetaCorpUnits( Idx );
				}
			}
		}
		else
		{
			`AILog("Stimulus no longer valid");
			if( Focus != None )
			{
				if( bCountedChaosForThisTarget == TRUE )
				{
					// Tell kismet we stopped tracking something
					MySentryBot.TriggerEventClass( class'SeqEvt_Tattler', Focus, 1 );
					NanoGRI(WorldInfo.GRI).ModifyChaosLevel( GetChaosZone(), Focus, class'NanoCausingChaosValues'.default.TattlerBotLost );
					bCountedChaosForThisTarget = FALSE;
				}
			}

			ClearTimer(nameof(UpdateDockedAlertness));
			Focus = None;
			GotoState('Docked','Begin');
		}
	}

	function UpdateDockedAlertness()
	{
		if (Focus != None && FindPriorityForStimulusActor(Focus) > 1)
		{
			if (NanoGRI(WorldInfo.GRI).GetCurrentChaosManager().GetChaosTier() < 2)
			{
				`AILog("Still alert, undocking");
				GotoState('Undocking');
			}
		}
		else
		{
			`AILog("No longer alert");
			MySentryBot.SetScannerAlert(FALSE);
		}
	}

	function Tick(float DeltaTime)
	{
		if (Focus != None)
		{
			ValidateCurrentTarget();
		}
		Global.Tick(DeltaTime);
	}

	function bool IsOutOfRange(Actor CheckActor)
	{
		local float Dist;
		Dist = VSize(CheckActor.Location - MySentryBot.Location);
		if (Pawn(CheckActor) != None)
		{	
			return Dist < AlertRange;
		}
		else
		{
			return Dist < AlertRange * 0.25f;
		}
	}

Begin:
	MySentryBot.SetScannerAlert(FALSE);
	CheckForStimulus();
	MySentryBot.DisableScanner();
	Focus = None;
	SetFocalPoint(Dock.GetDockLocation(MySentryBot) + Dock.GetDockLookDir(MySentryBot) * 256.f);
	Sleep(1.f);
	Goto('Begin');

Targeting:
	`AILog("Looking at"@`showvar(Focus));
	MySentryBot.EnableScanner();
	do
	{
		Sleep(1.f);
	} until (Focus == None || IsOutOfRange(Focus));
	Goto('Begin');
}

state Undocking
{
	function BeginState( Name PreviousStateName )
	{
		// Tell kismet we are undocking
		MySentryBot.TriggerEventClass( class'SeqEvt_Tattler', Focus, 3 );
	}

	function EndState(Name NextStateName)
	{
		Pawn.AccelRate = Pawn.default.AccelRate;
	}

Begin:
	`AILog("Undocking..");
	MySentryBot.DisableScanner();
	Sleep(0.5f);
	if (Dock != None)
	{
		Dock.PrepareToUndockBot(MySentryBot);
	}
	else
	{
		MySentryBot.Undock(Dock.GetDockLookDir(MySentryBot));
	}
	do
	{
		Sleep(2.f);
	} until (Pawn == None || Pawn.Physics != PHYS_RigidBody);
	UndockingLocation = Pawn.Location;

	FinishedUndocking();

	ScriptedTransitionTo('Alert');
}

state IdleTattler
{
	function CheckForStimulus()
	{
		local int Index, AlertIndex, IdleIndex;
		local StimulusQuery Query;
		local array<int> StimulusIndices;
		Query.bAllowFriendly = FALSE;
		Query.bAllowNonFriendly = TRUE;
		Query.MinFOV = -1.f;
		Query.MaxFOV = -1.f;
		Query.MinDist = 0.f;
		Query.MaxDist = 4096.f;
		if (MultipleResultStimulusQuery(Query,StimulusIndices) > 0)
		{
			AlertIndex = -1;
			IdleIndex = -1;
			foreach StimulusIndices(Index)
			{
				if (`TimeSince(Stimuli[Index].Time) > 3.f)
				{
					continue;
				}
				if (Stimuli[Index].Priority > 1 && Stimuli[Index].Actor != None && VSize2D(Stimuli[Index].Location - Pawn.Location) < AlertRange)
				{
					if (AlertIndex == -1 || VSize2D(Stimuli[Index].Location - Pawn.Location) < VSize2D(Stimuli[AlertIndex].Location - Pawn.Location))
					{
						AlertIndex = Index;
					}
				}
				else
				{
					if (IdleIndex == -1 || VSize2D(Stimuli[Index].Location - Pawn.Location) < VSize2D(Stimuli[IdleIndex].Location - Pawn.Location))
					{
						IdleIndex = Index;
					}
				}
			}
		}
		if (AlertIndex != -1)
		{
			Focus = Stimuli[AlertIndex].Actor;
			BroadcastStimuliToMetaCorpUnits( AlertIndex );
			PossiblyTransitionTo('Alert',ShouldTransitionToAlert);
		}
		else if (IdleIndex != -1)
		{
			if (Dock != None && `TimeSince(TimeOfTransition) > 2.f)
			{
				ReturnToDock();
			}
			else
			{
				Focus = Stimuli[IdleIndex].Actor;
				BroadcastStimuliToMetaCorpUnits( IdleIndex );
				PointOfInterest = Stimuli[IdleIndex].Location;
				GotoState('IdleTattler','InvestigatePOI');
			}
		}
	}

	function BeginState(Name PrevStateName)
	{
		if (MySentryBot != None)
		{
			MySentryBot.ActivateIdle();
		}
	}

	function bool ShouldTransitionToAlert()
	{
		return TRUE;
	}

Begin:
	CheckForStimulus();
	Sleep(0.5f);
	Goto('Begin');

InvestigatePOI:
	// face the direction of the incident
	if (Focus == None)
	{
		MySentryBot.DisableScanner();
		SetFocalPoint(PointOfInterest);
	}
	else
	{
		MySentryBot.EnableScanner();
	}
	if (VSize(PointOfInterest - Pawn.Location) > AlertRange * 0.35f)
	{
		MoveToLocation( PointOfInterest, 5.f );
		MySentryBot.EnableScanner();
		Sleep(1.f);
		if (Focus == None)
		{
			MySentryBot.DisableScanner();
		}
	}
	else
	{
		Sleep(0.3f);
	}
	// reset the point of interest and look for something else
	PointOfInterest = Pawn.Location;
	Focus = None;
	Goto('Begin');
}

state Alert
{
	function CheckForStimulus()
	{
		local int Index, AlertIndex;
		local StimulusQuery Query;
		local array<int> StimulusIndices;
		Query.bAllowFriendly = FALSE;
		Query.bAllowNonFriendly = TRUE;
		Query.MinFOV = -1.f;
		Query.MaxFOV = -1.f;
		Query.MinDist = 0.f;
		Query.MaxDist = 4096.f;
		if (MultipleResultStimulusQuery(Query,StimulusIndices) > 0)
		{
			AlertIndex = -1;
			foreach StimulusIndices(Index)
			{
				if (Stimuli[Index].Actor != None && VSize2D(Stimuli[Index].Location - Pawn.Location) < AlertRange)
				{
					if (AlertIndex == -1 || VSize2D(Stimuli[Index].Location - Pawn.Location) < VSize2D(Stimuli[AlertIndex].Location - Pawn.Location))
					{
						AlertIndex = Index;
					}
				}
			}
		}
		if( (AlertIndex != -1) && (Stimuli.Length > 0 ) )
		{
			Focus = Stimuli[AlertIndex].Actor;
		
			if( bCountedChaosForThisTarget == FALSE )
			{
				// Tell kismet we started tracking something
				MySentryBot.TriggerEventClass( class'SeqEvt_Tattler', Focus, 0 );
				NanoGRI(WorldInfo.GRI).ModifyChaosLevel( GetChaosZone(), Focus, class'NanoCausingChaosValues'.default.TattlerBotAquired );
				bCountedChaosForThisTarget = TRUE;
			}

			BroadcastStimuliToMetaCorpUnits( AlertIndex );
		}
	}

	function BeginState(Name PrevStateName)
	{
		MySentryBot.ActivateAlert();
		SetTimer( GetDropPodDelay(), FALSE, nameof(TryToSpawnDropPod));
	}

	function EndState(Name NextStateName)
	{
		MySentryBot.ActivateIdle();
		ClearTimer( nameof(TryToSpawnDropPod) );
	}

	function bool IsPointWithinRange( Vector Pt )
	{
		return VSize2D(Pt - Pawn.Location) < AlertRange * 0.5f;
	}

	function bool ShouldTransitionToIdle()
	{
		if (`TimeSince(TimeOfTransition) < 5.f)
		{
			return FALSE;
		}
		if (Focus != None && PrioritizeStimulus(Focus,Focus.Location,LineOfSightTo(Focus),IsFriendlyActor(Focus),FALSE) > 1)
		{
			return FALSE;
		}
		return TRUE;
	}

	function float GetDropPodDelay()
	{
		return RandRange( SummonDropPodRange.X, SummonDropPodRange.Y );
	}

	function TryToSpawnDropPod()
	{
		local StimulusQuery Query;
		local array<int> StimulusIndices;
		local NanoGRI NGRI;

		NGRI = NanoGRI(WorldInfo.GRI);
		
		Query.bAllowFriendly = FALSE;
		Query.bAllowNonFriendly = TRUE;

		Query.bRequireCombative = QO_Require; //  I think because this query only happens ever N seconds that if lyrik is not combative at the time of the query then we will not trigger.     bCombative probably needs to look at last fire time and have a window or so.  So for now we say:  need combative OR if we are above chaose level 1 then don't require as the metacorp world is being attacked
		if( NGRI.GetCurrentChaosManager().GetChaosTier() > 1 )
		{
			Query.bRequireCombative = QO_Disallow;
		}

		Query.Visibility = QO_Require;
		Query.MinFOV = 0.3f;
		Query.MaxFOV = -1.f;
		Query.MinPriority = 1;
		MultipleResultStimulusQuery( Query, StimulusIndices );

		// if we see something illicit
		// and we are allowed to spawn more drop pods OR
		if( ( StimulusIndices.Length > 0 ) 
			&& ( NGRI.AIBlackboard.GetNumAIDropPod() < NGRI.AIBlackboard.GetMaxAIDropPodAllowed( NGRI.GetCurrentChaosManager().GetChaosTier() ) )
			)
		{
			if( ChooseDropPodLandingSpot() )
			{
				GotoState( GetStateName(), 'BeginSpawnDropPod' );
			}
		}
		else
		{
			//`log( "booo can't spawn" @ NGRI.AIBlackboard.GetNumAIDropPod() @ NGRI.AIBlackboard.GetMaxAIDropPodAllowed( NGRI.GetCurrentChaosManager().GetChaosTier() ) @ StimulusIndices.Length );
		}		

		SetTimer( GetDropPodDelay(), FALSE, nameof(TryToSpawnDropPod));
	}

	function bool ChooseDropPodLandingSpot()
	{
		local int Idx;
		local Vector Dir, DropLoc;
		local Vector HitLocation, HitNormal;
		local Actor HitActor;
		local Rotator Rot;

		Rot = rot(0,16384,0) * Rand(3);
		for( Idx = 0; Idx < 4; Idx++ )
		{
			Dir = Vector((Rot + rot(0,16384,0)) * Idx);
			DropLoc = Pawn.Location + Dir * 512.f;

			HitActor = Trace( HitLocation, HitNormal, DropLoc + vect(0,0,4096), DropLoc, FALSE, vect(40,40,1) );
			if( HitActor == None )
			{
				DropPodLandingSpot = DropLoc;
				return TRUE;
			}
		}

		return FALSE;
	}

	function SpawnDropPod()
	{
		local NanoProj_DropPod Pod;

		Pod = Spawn( class'NanoProj_DropPod',,, DropPodLandingSpot + vect(0,0,4096), Rotator(vect(0,0,-1)) );
		if( Pod != None )
		{
			Pod.SetPhysics( PHYS_Falling );
			Pod.SpawnDecalActor( DropPodLandingSpot );
		}
	}

	/** Give tattler a chance to call in more than one pod */
	function bool ShouldSpawnAnotherPod()
	{
		return  FALSE;
	}

Begin:
	if (Focus == None)
	{
		AlertMoveLocation = Pawn.Location + (Normal(VRand() * vect(1,1,0)) * AlertRange);
		if (GeneratePathToLocation(AlertMoveLocation,,TRUE))
		{
			class'NanoAICmd_Move_Mesh'.static.MoveToPoint(self,AlertMoveLocation,FALSE);
		}
		else
		{
			SetFocalPoint(AlertMoveLocation);
			Sleep(1.f);
		}
		CheckForStimulus();
	}
	if( Focus != None )
	{
		BroadcastStimuliToMetaCorpUnits( Stimuli.Find('Actor', Focus) );
	}
	if ( ( Focus != None ) && (VSize(Focus.Location - Pawn.Location) > (AlertRange * 0.65)) )
	{
		class'NanoAICmd_Move_UntilInRange'.static.MoveToPoint(self,Focus.Location);
	}
	Sleep(0.5f);
	PossiblyTransitionTo('IdleTattler',ShouldTransitionToIdle);
	Goto('Begin');

BeginSpawnDropPod:
	// Rotate upward
	Focus = None;
	Pawn.bRollToDesired = TRUE;
	Pawn.SetDesiredRotation( Rotator(vect(0,0,1)) );
	Pawn.ZeroMovementVariables();
	// Turn on effects
	MySentryBot.PlayCallDropPodEffects();
	Sleep( 2.f );
	// Spawn
SpawnPod:
	SpawnDropPod();
	if( ShouldSpawnAnotherPod() && ChooseDropPodLandingSpot() )
	{
		Sleep( 0.5f + FRand() * 1.f );
		Goto( 'SpawnPod' );
	}
	// Wait a moment
	Sleep( 1.f );
	// Turn off effects
	MySentryBot.StopCallDropPodEffects();
	// Reset rotation
	Pawn.bRollToDesired = FALSE;
	Pawn.ResetDesiredRotation();
	Goto('Begin');
}


simulated function NanoVolume_ChaosZone GetChaosZone()
{
	return MySentryBot.GetChaosZone(); // should be the dock where this sentry is from
}



defaultproperties
{
	AlertRange=1536.f
	DockedFOV=0.2f
	
	IllicitSkillUsageDegradeTime=7.0f
	NumIllicitDashSeenTrigger=5
	NumIllicitJumpSeenTrigger=5


	BroadcastStimuliDistanceMin=1500
	BroadcastStimuliDistanceMax=8000 // tried 5k in the sp_cityscale_p and it seemed a lil small


	ConfrontPossibleThreatQuery=( QueryLabel="ConfrontPossibleThreat",bAllowFriendly=FALSE,bAllowNonFriendly=TRUE,bRequireCombative=QO_Allow,MinFOV=-1.f,MaxFOV=-1.f,MinDist=0.f,MaxDist=9048.f )

	ConfrontPossibleThreatQuery_Rooftop=( QueryLabel="ConfrontPossibleThreatQuery_Rooftop",bAllowFriendly=FALSE,bAllowNonFriendly=TRUE,bRequireCombative=QO_Allow,MinFOV=-1.f,MaxFOV=-1.f,MinDist=0.f,MaxDist=8048.f )


//	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Idle_StandAround' )
//	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Idle_TattlerPatrol' )



	//ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_ConfrontPossibleThreat_MoveDirectlyToward' )

}
