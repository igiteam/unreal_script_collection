//=============================================================================
// GameReplicationInfo.
//=============================================================================
class GameReplicationInfo extends ReplicationInfo
	native nativereplication config;

var string GameName;						// Assigned by GameInfo.
var string GameClass;						// Assigned by GameInfo.
var bool bTeamGame;							// Assigned by GameInfo.
var bool bStopCountDown;    // NB: affects match time, not CountDown time
var bool bMatchHasBegun;
var bool bMatchPending;
var bool bGameEnded;
var bool bTeamSymbolsUpdated;
var bool bVIPSFWins;
var bool bStartedCountDown; // NB: it's the FINAL COUNTDOOOOOWWWWNNN
var bool bEnemiesOnRadar;
var int  RemainingTime, ElapsedTime, RemainingMinute;
var float SecondCount;
var int GoalScore;
var int TimeLimit;
var int MaxLives;
var int CountDown; // CountDown timer (other than match/round time)
var int VIPRoundNum;

// i hate you wes
var string RoundWinners[11];  // relevant player name (not neccessarilly the winner)
var int RoundResults[11];     // win reason

var int RoundsPlayed;
var int NumMatchRounds;

var int ClassLimits[6];
var TeamInfo Teams[2];

var() globalconfig string ServerName;		// Name of the server, i.e.: Bob's Server.
var() globalconfig string ShortName;		// Abbreviated name of server, i.e.: B's Serv (stupid example)
var() globalconfig string AdminName;		// Name of the server admin.
var() globalconfig string AdminEmail;		// Email address of the server admin.
var() globalconfig int	  ServerRegion;		// Region of the game server.

var() globalconfig string MOTDLine1;		// Message
var() globalconfig string MOTDLine2;		// Of
var() globalconfig string MOTDLine3;		// The
var() globalconfig string MOTDLine4;		// Day

var Actor Winner;			// set by gameinfo when game ends
var string ExtraWinText;

var int WinReason;

var() array<PlayerReplicationInfo> PRIArray;

var vector FlagPos1;	// replicated 2D position of one object
var vector FlagPos2;	// replicated 2D position of one other object
var byte NumFlags;		//Maybe these could go bNetInitial?

//hack
var Controller VIPController;

enum ECarriedObjectState
{
    COS_Home,
    COS_HeldFriendly,
    COS_HeldEnemy,
    COS_Down,
};
var ECarriedObjectState CarriedObjectState[2];

var Enums.EGameType GameTypeID;	// Assigned by GameInfo.

// stats
var int MatchID;
replication
{
	reliable if ( bNetDirty && (Role == ROLE_Authority) )
		bStopCountDown, Winner, Teams, FlagPos1, FlagPos2, NumFlags, 
		CarriedObjectState, bMatchHasBegun, bMatchPending, bGameEnded, MatchID, 
		WinReason,VIPController,RoundsPlayed,RoundWinners,
		RoundResults,ExtraWinText,NumMatchRounds,CountDown,
		VIPRoundNum,bVIPSFWins,bStartedCountDown; 

	reliable if ( bNetInitial && (Role==ROLE_Authority) )
		GameName, GameClass, GameTypeID, bTeamGame, 
		RemainingTime, ElapsedTime,MOTDLine1, MOTDLine2, 
		MOTDLine3, MOTDLine4, ServerName, ShortName, AdminName,
		AdminEmail, ServerRegion, GoalScore, MaxLives, TimeLimit,
		ClassLimits, bEnemiesOnRadar;

	reliable if ( !bNetInitial && bNetDirty && (Role == ROLE_Authority) )
		RemainingMinute;

	//send this to server
	reliable if (Role < ROLE_Authority)
		SetServerRoundResults,ClearServerRoundResults;
}

simulated event bool CanChangeClass( int TeamIdx, int ClassIdx, PlayerReplicationInfo me )
{
	return ClassLimits[ClassIdx-1] < 0 ||
	       ClassLimits[ClassIdx-1] > GetTeamClassCount( TeamIdx, ClassIdx, me );
}

simulated event int GetClassCount( int ClassIdx, PlayerReplicationInfo me )
{
	local int i, classCount;

	for( i = 0; i < PRIArray.Length; ++i )
	{
		if( PRIArray[i] == me )
			continue;
		if( PRIArray[i].MPClientStatus == 2 && PRIArray[i].ClassIdx == ClassIdx )
		{
			++classCount;
		}
	}

	return classCount;
}

simulated event int GetTeamClassCount( int TeamIdx, int ClassIdx, PlayerReplicationInfo me )
{
	local int i, classCount;

	if( !bTeamGame )
		return GetClassCount( ClassIdx, me );
	else
	{
		for( i = 0; i < PRIArray.Length; ++i )
		{
			if( PRIArray[i] == me )
				continue;
			if( PRIArray[i].MPClientStatus == 2 && 
			    PRIArray[i].Team.TeamIndex == TeamIdx && PRIArray[i].ClassIdx == ClassIdx )
			{
				++classCount;
			}
		}

		return classCount;
	}
}

simulated event int GetTeamCount( int TeamIdx, PlayerReplicationInfo me )
{
	local int i, teamCount;

	for( i = 0; i < PRIArray.Length; ++i )
	{
		if( PRIArray[i] == me )
			continue;
		if( PRIArray[i].MPClientStatus == 2 && PRIArray[i].Team.TeamIndex == TeamIdx )
		{
			++teamCount;
		}
	}

	return teamCount;
}

event SetFlagPosTeam(vector newFlagPos, int teamIdx)
{
	if (teamIdx == 0)
	{
		FlagPos1 = newFlagPos;
		++NumFlags;
		//log("SetFlagPosTeam: Flag1: " $ FlagPos1.x @ FlagPos1.y @ FlagPos1.z);
	}
	else if (teamIdx == 1)
	{
		FlagPos2 = newFlagPos;
		++NumFlags;
		//log("SetFlagPosTeam: Flag2: " $ FlagPos2.x @ FlagPos2.y @ FlagPos2.z);
	}
	else
	{
		log("SetFlagPosTeam: Bad TeamIdx!: " $ teamIdx @ newFlagPos.x @ newFlagPos.y @ newFlagPos.z);
	}
}

event SetFlagPos(vector newFlagPos)
{
	if (NumFlags == 0)
	{
		FlagPos1 = newFlagPos;
		++NumFlags;
		//log("SetFlagPos: Flag1: " $ FlagPos1.x @ FlagPos1.y @ FlagPos1.z);
	}
	else if (NumFlags == 1)
	{
		FlagPos2 = newFlagPos;
		++NumFlags;
		//log("SetFlagPos: Flag2: " $ FlagPos2.x @ FlagPos2.y @ FlagPos2.z);
	}
	else
	{
		log("SetFlagPos: Too many flags!: " $ newFlagPos.x @ newFlagPos.y @ newFlagPos.z);
	}
}

event ClearServerRoundResults()
{
	while (RoundsPlayed>0)
	{
		RoundWinners[RoundsPlayed-1]="";
		RoundResults[RoundsPlayed-1] = 12;    // intentionally bad value
		--RoundsPlayed;
	}
}

event SetServerRoundResults(int roundNum,string Winner,int Reason)
{
	if (roundNum<0 || roundNum>=30) return;
	if (roundNum >=RoundsPlayed)
		RoundsPlayed = roundNum+1;

	RoundResults[roundNum]=Reason;
	RoundWinners[roundNum]=Winner;
}

simulated function SetCarriedObjectState(int Team, name NewState)
{
	switch( NewState )
	{
		case 'Down':
			CarriedObjectState[Team] = COS_Down;
			break;
		case 'HeldEnemy':
			CarriedObjectState[Team] = COS_HeldEnemy;
			break;
		case 'Home':
			CarriedObjectState[Team] = COS_Home;
			break;
		case 'HeldFriendly':
			CarriedObjectState[Team] = COS_HeldFriendly;
			break;
	}
}

simulated function name GetCarriedObjectState(int Team)
{
	switch( CarriedObjectState[Team] )
	{
		case COS_Down:
			return 'Down';
		case COS_HeldEnemy:
			return 'HeldEnemy';
		case COS_Home:
			return 'Home';
		case COS_HeldFriendly:
			return 'HeldFriendly';
	}
	return '';
}			

simulated function PostNetBeginPlay()
{
	local PlayerReplicationInfo PRI;
	
	ForEach DynamicActors(class'PlayerReplicationInfo',PRI)
		AddPRI(PRI);
	if ( Level.NetMode == NM_Client )
		TeamSymbolNotify();
}

simulated function TeamSymbolNotify()
{
	local Actor A;

	if ( (Teams[0] == None) || (Teams[1] == None)
		|| (Teams[0].TeamIcon == None) || (Teams[1].TeamIcon == None) )
		return;
	bTeamSymbolsUpdated = true;
	ForEach AllActors(class'Actor', A)
		A.SetGRI(self);
}

simulated function PostBeginPlay()
{
	if( Level.NetMode == NM_Client )
	{
		// clear variables so we don't display our own values if the server has them left blank 
		ServerName = "";
		AdminName = "";
		AdminEmail = "";
		MOTDLine1 = "";
		MOTDLine2 = "";
		MOTDLine3 = "";
		MOTDLine4 = "";
	}

	SecondCount = Level.TimeSeconds;
	SetTimer(1, true);
}

/* Reset() 
reset actor to initial state - used when restarting level without reloading.
*/
function Reset()
{
	Super.Reset();
	Winner = None;
	ExtraWinText="";
}

simulated function Timer()
{
	if ( Level.NetMode == NM_Client )
	{
		ElapsedTime++;
		if ( RemainingMinute != 0 )
		{
			RemainingTime = RemainingMinute;
			RemainingMinute = 0;
		}
		if ( (RemainingTime > 0) && !bStopCountDown )
			RemainingTime--;
		if ( !bTeamSymbolsUpdated )
			TeamSymbolNotify();
		SetTimer(Level.TimeDilation, true);
	}
}

simulated function AddPRI(PlayerReplicationInfo PRI)
{
    PRIArray[PRIArray.Length] = PRI;
}

simulated function RemovePRI(PlayerReplicationInfo PRI)
{
    local int i;

    for (i=0; i<PRIArray.Length; i++)
    {
        if (PRIArray[i] == PRI)
            break;
    }

    if (i == PRIArray.Length)
    {
        log("GameReplicationInfo::RemovePRI() pri="$PRI$" not found.", 'Error');
        return;
    }

    PRIArray.Remove(i,1);
	}

simulated function GetPRIArray(out array<PlayerReplicationInfo> pris)
{
    local int i;
    local int num;

    pris.Remove(0, pris.Length);
    for (i=0; i<PRIArray.Length; i++)
    {
        if (PRIArray[i] != None)
            pris[num++] = PRIArray[i];
    }
}


// Decompiled with UE Explorer.
defaultproperties
{
    bStopCountDown=true
    bEnemiesOnRadar=true
    ServerName="Another Server"
    ShortName="Server"
    bNetNotify=true
}