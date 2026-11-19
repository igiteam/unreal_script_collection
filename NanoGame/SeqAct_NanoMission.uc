/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_NanoMission extends SeqAct_Latent
	native(Sequence);


// need to Localize these 
/** This will show up on the main HUD **/
var() Name MissionName; 
/** This will show up on the Mission HUD **/
var() String MissionDescription;
/** This will show up on the main HUD **/
var() String MissionSummary; 


/** If you fail a mission this will say this text. **/
var() String FailedString; 

/** If you succeed a mission this will say this text. **/
var() String SuccessString; 


/** Duration the Mission Name will stay on the screen **/
var() float DurationMissionNameStaysOnScreen;

/** Duration for how long the mission is allowed to be active before auto failing. **/
var() float DurationAllowed;
/** Which direction the timer should count.  -1 for counting down 1 for counting up **/
var() int TimerDirection;

/** The label for the "time" hud text for missions that use timers/counters. **/
var() string TimerLabel;

var transient float	TimerCount;


var transient bool bStarted;
var protected transient bool bFailed;
var protected transient bool bSucceeded;
var protected transient bool bAbandoned;

/** Some missions we want to treat failures as successes.  (Find Alan for why he needs this :-) ) **/
var(SuccessFailure) bool bAlwaysFireSucccessOutEvenInCaseOfFailure;


var transient float TimeToFinishQuestBy;

/** Sound to play when mission started */
var() SoundCue    StartedSound;
/** Sound to play when mission aborted */
var() SoundCue    AbandonSound;
/** Sound to play when mission fails */
var() SoundCue    FailureSound;
/** Sound to play when mission succeeded */
var() SoundCue    SuccessSound;

/** SoundCue which will give a brief overview of the mission.  NOTE: this starts playing at the same time as StartedSound.  So add a brief pause in the sound cue. */
var() SoundCue    MissionOverview;


/** This is the reward that we give out for this Mission **/
var() RewardDatum Reward;


cpptext
{
	virtual void Activated();

	virtual UBOOL UpdateOp( FLOAT DeltaTime );
	
	virtual void DeActivated();
}


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 14;
}




simulated event StartMission()
{
	local NanoPawn NP;
	local NanoGRI NGRI;
	local Sequence OuterSequence;
	local array<SequenceObject> ParentMissions;
	local SeqAct_NanoMission Parent;

	// Find the sequence that contains this missions sequence
	OuterSequence = ParentSequence.ParentSequence;
	if(OuterSequence != None)
	{
		OuterSequence.FindSeqObjectsByClass(class'SeqAct_NanoMission', FALSE, ParentMissions);

		// Output warning if two mission actions found in that sequence
		if(ParentMissions.length > 1)
		{
			`log("Mission"@MissionName@"has multiple parent missions!");
		}

		if(ParentMissions.length > 0)
		{
			Parent = SeqAct_NanoMission(ParentMissions[0]);
		}
	}

	// Use pawn to find GRI to find mission manager
	NP = NanoPawn(GetTargetVar( self, "Target" ));
	NGRI = NP.GetGRI();

	// Add this mission to the manager
	NGRI.TheMissionManager.AddMission(self, Parent);
	TimeToFinishQuestBy = class'WorldInfo'.static.GetWorldInfo().TimeSeconds + DurationAllowed;
	TimerCount = DurationAllowed;
	bStarted = TRUE;

	// Play sound
	if(NP != none)
	{
		PlayerController(NP.Controller).PlaySound(StartedSound);
		if( MissionOverview != None )
		{
			PlayerController(NP.Controller).PlaySound(MissionOverview);
		}
	}

	`loginfo( 'Nano_Missions', "StartQuestStartQuestStartQuestStartQuest" @ TimeToFinishQuestBy );
}


simulated event Failed()
{
	local NanoPawn NP;
	NP = NanoPawn(GetTargetVar( self, "Target" ));
	if(NP != none)
	{
		PlayerController(NP.Controller).PlaySound(FailureSound);

		if( FailedString == "" )
		{
			FailedString = "You have failed" @ MissionName;
		}

		NanoHUD_Base(NanoGRI(NP.WorldInfo.GRI).GetNanoPC().myHUD).SlideTextMessage( FailedString, DurationMissionNameStaysOnScreen, class'Engine'.static.GetLargeFont(), None );
	}


	
	RemoveMissionFromManager();
}

simulated event Succeeded()
{
	local NanoPawn NP;
	NP = NanoPawn(GetTargetVar( self, "Target" ));
	if(NP != none)
	{
		PlayerController(NP.Controller).PlaySound(SuccessSound);

		if( SuccessString == "" )
		{
			SuccessString = "You have succeeded in" @ MissionName;
		}

		NanoHUD_Base(NanoGRI(NP.WorldInfo.GRI).GetNanoPC().myHUD).SlideTextMessage( SuccessString, DurationMissionNameStaysOnScreen, class'Engine'.static.GetLargeFont(), None );


		GiveMissionRewards( NP );

		NanoGRI(NP.WorldInfo.GRI).NCM.HandleChallengeEvent( ECET_CompletedAMission );
	}

	RemoveMissionFromManager();
}

simulated event Abandoned()
{
	local NanoPawn NP;
	NP = NanoPawn(GetTargetVar( self, "Target" ));
	if(NP != none)
	{
		PlayerController(NP.Controller).PlaySound(AbandonSound);
	}

	RemoveMissionFromManager();
}


simulated function RemoveMissionFromManager()
{
	local NanoPawn NP;
	local NanoGRI NGRI;

	bStarted = FALSE;

	bFailed = FALSE;
	bSucceeded = FALSE;
	bAbandoned = FALSE;

	NP = NanoPawn(GetTargetVar( self, "Target" ));
	NGRI = NP.GetGRI();

	NGRI.TheMissionManager.RemoveMission(self);
}


simulated function GiveMissionRewards( NanoPawn ToGiveReward )
{
	ToGiveReward.GetGRI().GiveReward( Reward, ToGiveReward );
}




simulated function DumpToLog()
{

}


function Actor GetTargetVar( SeqAct_NanoMission Action, String PropName )
{
	local array<Object> objVars;
	local int idx;
	local Actor destActor;
	local Controller C;

	// find the first supplied actor
	Action.GetObjectVars( objVars, PropName );
	for (idx = 0; idx < objVars.Length && destActor == None; idx++)
	{
		destActor = Actor(objVars[idx]);

		// If its a player variable, teleport to the Pawn not the Controller.
		C = Controller(destActor);
		if(C != None && C.Pawn != None)
		{
			destActor = C.Pawn;
		}
	}

	return destActor;
}






defaultproperties
{
	ObjName="Nano Mission"
	ObjCategory="Nano"

	InputLinks(0)=(LinkDesc="Start")
	InputLinks(1)=(LinkDesc="Fail")
	InputLinks(2)=(LinkDesc="Succeed")
	InputLinks(3)=(LinkDesc="Abandon")

	OutputLinks(0)=(LinkDesc="Started")
	OutputLinks(1)=(LinkDesc="Failed")
	OutputLinks(2)=(LinkDesc="Succeeded")
	OutputLinks(3)=(LinkDesc="Abandoned")

	VariableLinks(1)=(LinkDesc="DurationAllowed",ExpectedType=class'SeqVar_Float',bWriteable=TRUE,bSequenceNeverReadsOnlyWritesToThisVar=TRUE,PropertyName=DurationAllowed)
	VariableLinks(2)=(LinkDesc="TimeElapsed",ExpectedType=class'SeqVar_Float',bWriteable=TRUE,bSequenceNeverReadsOnlyWritesToThisVar=TRUE,PropertyName=TimerCount)


	FailedString=""
	SuccessString=""


	StartedSound=SoundCue'Interface_Audio.Objectives.PointOfInterestAdded'
	AbandonSound=SoundCue'Interface_Audio.Objectives.WaveCompleted'
	FailureSound=SoundCue'Interface_Audio.Objectives.FailObjective'
	SuccessSound=SoundCue'Interface_Audio.Objectives.CompleteObjective'


	// might want to have variable links here for sub-step text
	TimerDirection=-1
	TimerLabel="Time"

	DurationMissionNameStaysOnScreen=5.0f
}
