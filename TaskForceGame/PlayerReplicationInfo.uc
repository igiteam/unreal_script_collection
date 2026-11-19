//=============================================================================
// PlayerReplicationInfo.
//=============================================================================
class PlayerReplicationInfo extends ReplicationInfo
	native nativereplication;

// also replicate here player class and skins and any other seldom changed stuff


var float				Score;			// Player's current score.
var float				Deaths;			// Number of player's deaths.
var Actor				HasFlag;
var int					Ping;				// packet loss packed into this property as well
var Volume				PlayerVolume;
var ZoneInfo            PlayerZone;
var int					NumLives;

var string				PlayerName;		// Player name, or blank if none.
var string				CharacterName, OldCharacterName;
var string				OldName, PreviousName;		// Temporary value.
var int					PlayerID;		// Unique id number.
var TeamInfo			Team;			// Player Team
var int					TeamID;			// Player position in team. 
var class<VoicePack>	VoiceType;

var int					NextClassIdx;	// kkm--Class to change to on the next respawn.
var int					OldClassIdx;		// last state of the following var
var int					ClassIdx;		// in DM, represents the class of player you are (rifleman, sniper, heavy)

var bool				bWasTerrorist;     // last state of the following var
var bool				bTerrorist;     // in DM represents whether or not to use terrorist mesh
var bool				bAdmin;				// Player logged in as Administrator
var bool				bIsFemale;
var bool				bIsSpectator;
var bool				bOnlySpectator;
var bool				bWaitingPlayer;
var bool				bReadyToPlay;
var bool				bOutOfLives;
var bool				bBot;
var bool				bWelcomed;			// set after welcome message broadcast (not replicated)
var bool				bReceivedPing;			
var bool				bHasFlag;			
var bool				bPausedGame;			
var bool                bNextTerrorist; // kkm--Should I become a terrorist on the next respawn?
var bool				ScoringKOH;		//true if we're currently scoring on the hill
var bool				IsDead;			// kkm--Player is dead and hasn't respawned yet

// Time elapsed.
var int					StartTime;

var localized String    StringSpectating;
var localized String	StringUnknown;

var int					GoalsScored;		// not replicated - used on server side only
var int					Kills;				

var String xuid;
var String Gamertag;
var bool IsGuest;
var byte VoiceStatus; // 0 - no voice, 1 - voice thru tv, 2 - voice on, 3 - talking, 4 - team talking

var vector RadarPos;

var EMPClientStatus MPClientStatus;
var XboxAddr xbAddr;

replication
{
	// Things the server should send to the client.
	reliable if ( bNetDirty && (Role == Role_Authority) )
		MPClientStatus,
		Score, Deaths,Kills, bHasFlag, PlayerVolume, PlayerZone,
		PlayerName, Team, TeamID, VoiceType, bIsFemale, bAdmin, 
		bIsSpectator, bOnlySpectator, bWaitingPlayer, bReadyToPlay,
		bOutOfLives, CharacterName,
		xuid, Gamertag, IsGuest, VoiceStatus,
		ClassIdx, bTerrorist,
		bPausedGame, RadarPos,
		bNextTerrorist, IsDead, NextClassIdx, ScoringKOH, xbAddr;
	reliable if ( bNetDirty && !bNetOwner && (Role == Role_Authority) )
		Ping; 
	reliable if ( bNetInitial && (Role == Role_Authority) )
		StartTime, bBot;
	
	// called on server from client
	reliable if( Role < ROLE_Authority )
		SetFlag, SetMPClientStatus, SetNextClass, SetNextTeam,
		SetXBAddr, SetVoiceStatus, ServerSetRemoteMute;

	// called on client from server
	reliable if( Role == ROLE_Authority )
		ClientSetRemoteMute;
}

event SetXBAddr( XboxAddr MyXBAddr )
{
	xbAddr = MyXBAddr;
}

event SetVoiceStatus( byte MyVoiceStatus )
{
	VoiceStatus = MyVoiceStatus;
}

event ServerSetRemoteMute( PlayerReplicationInfo MuteThisGuy, bool on )
{
	// forward to the client who is to be remote muted
	MuteThisGuy.ClientSetRemoteMute( self, on );
}

native simulated function ClientSetRemoteMute( PlayerReplicationInfo GuyWhoMutedMe, bool on );

event SetNextClass( int idx )
{
	NextClassIdx = idx;
}

event SetNextTeam( bool bTerrorist )
{
	bNextTerrorist = bTerrorist;
}

event SetMPClientStatus( EMPClientStatus mpcs )
{
	MPClientStatus = mpcs;
}

function PostBeginPlay()
{
	if ( Role < ROLE_Authority )
		return;
    if (AIController(Owner) != None)
        bBot = true;
	if ( Level.Game == None || Level.Game.GameReplicationInfo == None )
	{
		StartTime = 0;
	}
	else
	{
		StartTime = Level.Game.GameReplicationInfo.ElapsedTime;
	}
	Timer();
	SetTimer(1.5 + FRand(), true);
}

simulated function PostNetBeginPlay()
{
	local GameReplicationInfo GRI;
	
	ForEach DynamicActors(class'GameReplicationInfo',GRI)
	{
		GRI.AddPRI(self);
		break;
	}
}

simulated function Destroyed()
{
	local GameReplicationInfo GRI;
	
	ForEach DynamicActors(class'GameReplicationInfo',GRI)
        GRI.RemovePRI(self);
        
    Super.Destroyed();
}
	
function SetCharacterName(string S)
{
	CharacterName = S;
}

/* Reset() 
reset actor to initial state - used when restarting level without reloading.
*/
function Reset()
{
	Super.Reset();
	Score = 0;
	Deaths = 0;
	SetFlag(None);
	bReadyToPlay = false;
	NumLives = 0;
	bOutOfLives = false;
	MPClientStatus = MPCS_Pending;
}

event SetFlag(Actor NewFlag)
{
	HasFlag = NewFlag;
	bHasFlag = (HasFlag != None);
}

simulated function string GetHumanReadableName()
{
	return PlayerName;
}

simulated function string GetLocationName()
{
    if( ( PlayerVolume == None ) && ( PlayerZone == None ) )
        return StringSpectating;
    
	if( ( PlayerVolume != None ) && ( PlayerVolume.LocationName != class'Volume'.Default.LocationName ) )
		return PlayerVolume.LocationName;
	else if( PlayerZone != None && ( PlayerZone.LocationName != "" )  )
		return PlayerZone.LocationName;
    else if ( Level.Title != Level.Default.Title )
		return Level.Title;
	else
        return StringUnknown;
}

simulated function material GetPortrait();
event UpdateCharacter();

function UpdatePlayerLocation()
{
    local Volume V, Best;
    local Pawn P;
    local Controller C;

    C = Controller(Owner);

    if( C != None )
        P = C.Pawn;
    
    if( P == None )
		{
        PlayerVolume = None;
        PlayerZone = None;
        return;
    }
    
    if ( PlayerZone != P.Region.Zone )
		PlayerZone = P.Region.Zone;

    foreach P.TouchingActors( class'Volume', V )
    {
        if( V.LocationName == "") 
            continue;
        
        if( (Best != None) && (V.LocationPriority <= Best.LocationPriority) )
            continue;
            
        if( V.Encompasses(P) )
            Best = V;
		}
    if ( PlayerVolume != Best )
		PlayerVolume = Best;
}

/* DisplayDebug()
list important controller attributes on canvas
*/
simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	if ( Team != None )
		Canvas.DrawText("     PlayerName "$PlayerName$" Team "$Team.GetHumanReadableName() $"("$Team.TeamIndex$") has flag "$HasFlag);
	else
		Canvas.DrawText("     PlayerName "$PlayerName$" NO Team");

	if ( !bBot )
	{
		YPos += YL;
		Canvas.SetPos(4, YL);
		Canvas.DrawText("               bIsSpec:"$bIsSpectator@"OnlySpec:"$bOnlySpectator@"Waiting:"$bWaitingPlayer@"Ready:"$bReadyToPlay@"OutOfLives:"$bOutOfLives);
	}
}
 					
event ClientNameChange()
{
	//hack
	Controller(Owner).ClientNameChange();
}

function Timer()
{
    local Controller C;

	UpdatePlayerLocation();
	SetTimer(1.5 + FRand(), true);
	if( FRand() < 0.65 )
		return;

	if( !bBot )
	{
	    C = Controller(Owner);
		if ( !bReceivedPing )
			Ping = int(C.ConsoleCommand("GETPING"));
	}
}

function SetPlayerName(string S)
{
	OldName = PlayerName;
	PlayerName = S;
}

function SetWaitingPlayer(bool B)
{
	bIsSpectator = B;	
	bWaitingPlayer = B;
}


// Decompiled with UE Explorer.
defaultproperties
{
    StringSpectating="Spectating"
    StringUnknown="Unknown"
    MPClientStatus=1
    NetUpdateFrequency=5.0000000
}