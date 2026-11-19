
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_NanoMission_AddTime extends SequenceAction;


/** Mission name to add time to **/
var() Name MissionName;

/** Time to add to the current mission:  Use negative numbers here to subtract time **/
var() float TimeToAdd;

/** This will add time to the "running total" / "elapsed time" for the mission **/
var() bool bAddToTimerCount;

/** This will add the amount to the Duration allowed for the mission **/
var() bool bAddToDurationAllowed;

/** Sound to play when adding time **/
var() SoundCue SoundToPlayWhenAdding;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}



/**
 * Called when this event is activated.
 */
event Activated()
{
	local NanoMissionManager NMM;
	local int Idx;

	NMM = NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).TheMissionManager;

	for( Idx = 0; Idx < NMM.Missions.Length; Idx++ )
	{
		if( NMM.Missions[Idx].MissionAction.MissionName == MissionName )
		{
			if( bAddToTimerCount == TRUE )
			{
				NMM.Missions[Idx].MissionAction.TimerCount += TimeToAdd;
			}

			if( bAddToDurationAllowed == TRUE )
			{
				NMM.Missions[Idx].MissionAction.DurationAllowed += TimeToAdd;
				NMM.Missions[Idx].MissionAction.TimeToFinishQuestBy += TimeToAdd;
			}


			NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetNanoPC().PlaySound( SoundToPlayWhenAdding );
			break;
		}
	}
}




defaultproperties
{
	ObjName="Mission Add Time"
	ObjCategory="Nano"

	bCallHandler=FALSE

	VariableLinks.Empty()


	bAddToTimerCount=TRUE
}