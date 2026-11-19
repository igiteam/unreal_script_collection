/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMSeqAct_ToggleAnnouncements extends SequenceAction;

event Activated()
{
	local TMGameReplicationInfo GRI;

	GRI = TMGameReplicationInfo(GetWorldInfo().GRI);
	if (GRI != None)
	{
		if (InputLinks[0].bHasImpulse)
		{
			GRI.bAnnouncementsDisabled = false;
		}
		else if (InputLinks[1].bHasImpulse)
		{
			GRI.bAnnouncementsDisabled = true;
		}
	}
}

