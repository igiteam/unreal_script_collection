class TMCommandShortcut extends TMLocalMessage;

var localized string 	Commands[10];
var SoundNodeWave 		Voices[20];

static simulated function ClientReceive(
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	local TMPlayerController TMP;

	Super.ClientReceive( P, Switch,
		RelatedPRI_1, RelatedPRI_2, OptionalObject );

	TMP = TMPlayerController( P );

	if( TMP != none )
	{
		TMP.PlayAnnouncement( Default.Class, Switch );
	}
}

static function string GetString(
	optional int Switch,
	optional bool bPRI1HUD,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	return RelatedPRI_1.PlayerName $ ": "
		$ Default.Commands[ Switch % 10 ];
}

static function SoundNodeWave AnnouncementSound(
	int MessageIndex,
	Object OptionalObject,
	PlayerController PC )
{
	return Default.Voices[ MessageIndex ];
}


