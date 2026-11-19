/** message class for announcements played through "Play Announcement" Kismet action
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMKismetAnnouncement extends TMObjectiveSpecificMessage;

static function ObjectiveAnnouncementInfo GetObjectiveAnnouncement(byte MessageIndex, Object Objective, PlayerController PC)
{
	local TMSeqAct_PlayAnnouncement Action;
	local ObjectiveAnnouncementInfo EmptyAnnouncement;

	Action = TMSeqAct_PlayAnnouncement(Objective);
	return (Action != None) ? Action.Announcement : EmptyAnnouncement;
}

static function byte AnnouncementLevel(byte MessageIndex)
{
	return 1;
}

