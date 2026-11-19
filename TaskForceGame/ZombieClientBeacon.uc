class ZombieClientBeacon extends ClientBeaconReceiver;

var bool boundToPort;
var bool CheckID;
var bool IsLive;
var bool IsActive;

function bool CheckBeaconText(string BeaconText)
{
	return (GetIsLive(BeaconText) == IsLive);
}

static event Enums.EGameType GetGameType(string text)
{
	local string temp;
	local int delimPos;

	delimPos = InStr(text, "\\t");
	
	temp = Left(Text, DelimPos);
	
	if (temp ~= "DM")
	{
		return GT_Deathmatch;
	}
	else if (temp ~= "TDM")
	{
		return GT_TeamDeathmatch;
	}
	
	return GT_Deathmatch;
}

static event string GetGameTypeText(string text)
{
	local string temp;
	local int delimPos;

	delimPos = InStr(text, "\\t");
	
	temp = Left(Text, DelimPos);
	
	return temp;
}

static function string GetMap(string text)
{
	local string temp;
	local int delimPos;
	
	delimPos = InStr(text, "\\t");
	
	temp = Mid(Text, DelimPos+2);
	
	temp = Left( temp, InStr(temp,"\\t") );
	
	return temp;
}

static function int GetCurPlayers(string text)
{
	local string temp;
	local int delimPos;
	
	delimPos = InStr(text, "\\t");
	temp = Mid(Text, DelimPos+2);
	
	delimPos = InStr(temp, "\\t");
	temp = Mid(temp, DelimPos+2);
	
	temp = Left( temp, InStr(temp,"\\t") );
	
	return (int(temp));
}

static function int GetMaxPlayers(string text)
{
	local string temp;
	local int delimPos;
	
	delimPos = InStr(text, "\\t");
	temp = Mid(Text, DelimPos+2);
	
	delimPos = InStr(temp, "\\t");
	temp = Mid(temp, DelimPos+2);
	
	delimPos = InStr(temp, "\\t");
	temp = Mid(temp, DelimPos+2);
	
//	temp = Left( temp, InStr(temp,"\\t") );
	
	return (int(temp));
}

static function bool GetIsLive(string text)
{
	local string temp;
	local int delimPos;
	
	delimPos = InStr(text, "\\t");
	temp = Mid(Text, DelimPos+2);
	
	delimPos = InStr(temp, "\\t");
	temp = Mid(temp, DelimPos+2);
	
	delimPos = InStr(temp, "\\t");
	temp = Mid(temp, DelimPos+2);
	
	delimPos = InStr(temp, "\\t");
	temp = Mid(temp, DelimPos+2);
	
	temp = Left( temp, InStr(temp,"\\t") );
	
	return (temp == "1");
}

static function string GetHostName(string text)
{
	local string temp;
	local int delimPos;
	
	delimPos = InStr(text, "\\t");
	temp = Mid(Text, DelimPos+2);
	
	delimPos = InStr(temp, "\\t");
	temp = Mid(temp, DelimPos+2);
	
	delimPos = InStr(temp, "\\t");
	temp = Mid(temp, DelimPos+2);
	
	delimPos = InStr(temp, "\\t");
	temp = Mid(temp, DelimPos+2);
	
	delimPos = InStr(temp, "\\t");
	temp = Mid(temp, DelimPos+2);
	
	return temp;
}

function BeginPlay()
{
	//intentionally empty; I don't want to do the superclass logic
}

function bool CheckPrevSessionID(string prevSessionID)
{
//	if (!CheckID)
//	{
//		return true;
//	}
//	
//	log("ZombieClientBeacon: CheckPrevID: " $ prevSessionID @ LocalXSessionID);
//	return (prevSessionID ~= LocalXSessionID);
	return true;
}

function StartQuery(optional bool shouldCheckID, optional bool IsLive)
{
	log( "StartQuery!!!!!!!!!!!!!!!!!1" );
	checkID = shouldCheckID;
	
	if (!boundToPort)
	{
		if( BindPort( BeaconPort, true ) > 0 )
		{
			boundToPort = true;
		}
		else
		{
			warn( "ZombieClientBeacon failed: Beacon port in use." );
		}
	}
	
	if (boundToPort)
	{
		IsActive = true;
		SetTimer( 1.0, true );
	}
}

function StopQuery()
{
	log( "Stopped query" );
	IsActive=false;
	SetTimer( 0.0, false );
}

//<Test code...>

function string GetBeaconAddress( int i )
{
	local string s;
    
    s = IpAddrToString(Beacons[i].Addr)
      $ "/" $ GetMap(Beacons[i].Text) $ ".cmf"
//      $ "?XSessionID=" $ Beacons[i].RemoteSessionID 
//      $ "?XExchangeKey=" $ Beacons[i].RemoteExchangeKey
//      $ "?XHostAddr=" $ Beacons[i].RemoteHostAddr
    ;

    return s;

//	return IpAddrToString(Beacons[i].Addr);
}

/*
function Timer()
{
	Beacons[0].Text = Level.Game.GetBeaconText();
}
*/
//</Test code...>

