/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMSeqAct_PlayAnnouncement extends SequenceAction
	PerObjectLocalized;

var() ObjectiveAnnouncementInfo Announcement;

event Activated()
{
	local WorldInfo WI;

	WI = GetWorldInfo();
	WI.BroadcastLocalizedMessage(class'TMKismetAnnouncement', 0, None, None, self);
}

