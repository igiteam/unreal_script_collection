/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ToggleObjectsObjectiveHUD extends SequenceAction;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}

/** When this action is activated, it  */
event Activated()
{
	local array<SequenceObject> Missions;
	local SequenceObject AMission;
	local NanoGRI NGRI;
	local NanoInterface_Objective RadarObj;
	local int Idx, MissionIdx;



	// get GRI via worldinfo
	NGRI = NanoGRI(GetWorldInfo().GRI);

	// Now find the mission in this sequence that these objectives are related to
	ParentSequence.FindSeqObjectsByClass(class'SeqAct_NanoMission', FALSE, Missions);
	if(Missions.length == 0)
	{
		`log("OBJECTIVE: No mission found for"@self);
		return;
	}

	if(Missions.length > 1)
	{
		`log("OBJECTIVE: Too many mission for"@self@`showvar(Missions.length));
		foreach Missions( AMission )
		{
			`log(  "  " @ `showvar(AMission) @ `showvar(SeqAct_NanoMission(AMission).MissionName) );
		}
	}

	`log("OBJECTIVE: " @ `showvar(NGRI.TheMissionManager.Missions.Length) );

	// Look up entry in mission manager
	MissionIdx = NGRI.TheMissionManager.Missions.Find( 'MissionAction', SeqAct_NanoMission(Missions[0]) );
	if( MissionIdx != INDEX_NONE )
	{
		// If replacing, clear array
		if(InputLinks[0].bHasImpulse)
		{
			NGRI.TheMissionManager.Missions[MissionIdx].RadarObjectives.length = 0;
			`log("CLEARING OBJS");
		}

		// Now go over each target we passed in..
		for(Idx=0; Idx<Targets.length; Idx++)
		{
			RadarObj = NanoInterface_Objective(Targets[Idx]);
			if(RadarObj != None)
			{
				// Adding
				if(InputLinks[0].bHasImpulse || InputLinks[1].bHasImpulse)
				{
					NGRI.TheMissionManager.Missions[MissionIdx].RadarObjectives.AddItem(RadarObj);
					`log("ADDING OBJ:"@RadarObj);
				}
				// Removing
				else if(InputLinks[2].bHasImpulse)
				{
					NGRI.TheMissionManager.Missions[MissionIdx].RadarObjectives.RemoveItem(RadarObj);
					`log("REMOVING OBJ:"@RadarObj);
				}
			}
			else
			{
				`log("OBJECTIVE:  Non NanoInterface_Objective as a targeted var" @ `showvar(Targets[Idx]) );
			}
		}
	}
	else
	{
		`log("OBJECTIVE:  Could not find the mission" @ `showvar(MissionIdx) );
	}
}

defaultproperties
{
	ObjName="Toggle Objects Objective HUD"
	ObjCategory="Nano"
	bCallHandler=FALSE

	InputLinks(0)=(LinkDesc="Replace")
	InputLinks(1)=(LinkDesc="Add")
	InputLinks(2)=(LinkDesc="Remove")
}
