/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMVictoryMessage extends TMLocalMessage;

var SoundNodeWave VictorySounds[6];

static function byte AnnouncementLevel(byte MessageIndex)
{
	return 1;
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
	return Default.VictorySounds[MessageIndex];
}

static simulated function ClientReceive(
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	local TMHUD HUD;

	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

	HUD = TMHUD(P.myHUD);
	if ( (HUD != None) && HUD.bIsSplitScreen )
	{
		return;
	}

	TMPlayerController(P).PlayAnnouncement(default.class,Switch );
}

/**
  * kill all queued messages and play immediately
  */
static function bool AddAnnouncement(TMAnnouncer Announcer, int MessageIndex, optional PlayerReplicationInfo PRI, optional Object OptionalObject)
{
	local TMQueuedAnnouncement RemovedAnnouncement;

	while ( Announcer.Queue != None )
	{
		RemovedAnnouncement = Announcer.Queue;
		Announcer.Queue = Announcer.Queue.nextAnnouncement;
		RemovedAnnouncement.Destroy();
	}
	super.AddAnnouncement(Announcer, MessageIndex, PRI, OptionalObject);
	return Announcer.PlayingAnnouncementClass.static.KilledByVictoryMessage(Announcer.PlayingAnnouncementIndex);
}

