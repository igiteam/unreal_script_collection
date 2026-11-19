class StartupMessage extends CriticalEventPlus;

//#exec OBJ LOAD File=AnnouncerMain.uax

var localized string CountdownStage[8];

var localized string PressToStartMessage;
var localized string PressToStartMessageClient;
var localized string PressToSayNotReady;
var localized string PressToSayReady;

var sound StandbySound;
var sound GoSound;

static simulated function ClientReceive( 
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	if ( Switch < 7 )
	{
		P.Level.FillPrecacheMaterialsArray();
		P.Level.FillPrecacheStaticMeshesArray();
	}		
	
	// don't play sound if quickstart=true, so no 'play' voiceover at start of tutorials
	//if ( Switch == 5 && P != none && P.Level != none && P.Level.Game != none )// && (!P.Level.Game.IsA('Deathmatch') || !DeathMatch(P.Level.Game).bQuickstart) )
	//{
	//	P.PlayAnnouncement(sound'AnnouncerMain.Play',1,true);
	//}
	else if ( (Switch > 1) && (Switch < 5) )
	{
		P.PlayBeepSound();
	}
	else if ( Switch == 7 )
	{
		//P.ClientPlaySound(Default.Riff);
	}
}

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (Switch == 0)
	{
		// Getting ready to start
		
		// Only the server can set the game off.
		if (RelatedPRI_1 != None && RelatedPRI_1.Level.Game != None)
			return Default.PressToStartMessage; // server
		else
		{
			// the others show if they are ready or not.
			if (RelatedPRI_1 != None)
			{
				if (RelatedPRI_1.bReadyToPlay)
					return Default.PressToSayNotReady;
				else
					return Default.PressToSayReady;
			}
			else
				return Default.PressToStartMessageClient; // client
		}
	}
	else
	{
		return Default.CountdownStage[Switch - 1];
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    CountdownStage[0]="The match is about to begin...3"
    CountdownStage[1]="The match is about to begin...2"
    CountdownStage[2]="The match is about to begin...1"
    CountdownStage[3]="The match has begun!"
    PressToStartMessage="Wait for others then press Action Button to start!"
    PressToStartMessageClient="Waiting for server to start game."
    PressToSayNotReady="Press Action Button to show you are NOT ready"
    PressToSayReady="Press Action Button to show you are ready"
    StandbySound=Sound'SASZeroAlpha.Base.ZA_go_02'
    GoSound=Sound'SASZeroAlpha.Base.ZA_go_02'
    bIsConsoleMessage=false
    DrawColor=(R=32,G=64,B=255,A=255)
}