class MSCHelper extends Info
	native;

struct native export ServerInfo
{
	var ServerResponseLine s;
	var float LastPingTime;
	var float LastDetailsTime;
};

var const float PingTimeThresh;
var const float DetailsTimeThresh;
var array<ServerInfo> ServerList;
var array<int> OutstandingPings;
var int NumSimultaneousPings;
var bool QueryRunning;
var MasterServerClient MSC;
var float Time;
var int DebugSpewLevel;
var bool TestMode;

enum ESortBy
{
	SB_SERVERNAME,
	SB_MAPNAME,
	SB_GAMETYPE,
	SB_CURPLAYERS,
	SB_PING
};

native event Sort( ESortBy sb, optional bool descending );

event PostBeginPlay()
{
	//
	if (!TestMode)
	{
		MSC = Spawn(class'MasterServerClient');
		MSC.OnReceivedServer	= OnReceivedServer;
		MSC.OnQueryFinished		= OnQueryFinished;
		MSC.OnReceivedPingInfo	= OnReceivedPingInfo;
		MSC.OnPingTimeout		= OnPingTimeout;
	}
	/*
	delegate OnQueryFinished( EResponseInfo ResponseInfo, int Info );
	delegate OnReceivedServer( GameInfo.ServerResponseLine s );
	delegate OnReceivedPingInfo( int ListID, EPingCause PingCause, GameInfo.ServerResponseLine s );
	delegate OnPingTimeout( int ListID, EPingCause PingCause );
	//delegate OnReceivedMOTDData( EMOTDResponse Command, string Value );
	*/
	//
}

event LogChecked(int level, coerce string s)
{
	if (DebugSpewLevel >= level)
	{
		log(s);
	}
}

//Delegates
event OnReceivedServer( GameInfo.ServerResponseLine s )
{
	local int i;
	local ServerInfo si;

	if (TestMode)
	{
		return;
	}

	si.s = s;
	si.s.ServerID = ServerList.Length;
	si.LastPingTime = -1;
	si.LastDetailsTime = -1;

	i = ServerList.Length;
	ServerList.Length=i+1;
	ServerList[i] = si;

	LogChecked(1, "MSCHelper: ReceivedServer: " $ s.IP $ ":" $ s.Port);
	LogChecked(2, s.ServerID @ s.ServerName @ s.MapName @ s.GameType );

//	Don't think I need this, since I store last ping time...
//	if( Servers[i].s.Ping == 0 )
//		Servers[i].s.Ping = 9999;
//
}

event OnPingTimeout( int listid, ServerQueryClient.EPingCause PingCause  )
{
	local int i, serverNum;

	if (TestMode)
	{
		return;
	}

	for( serverNum = 0; serverNum < ServerList.Length; ++serverNum )
	{
		if( ServerList[serverNum].s.ServerID == listid )
			break;
	}

	if( serverNum == ServerList.Length )
	{
		LogChecked( 2, "Mystery server with ID" @ listid @ "timed out" );
		return;
	}

	LogChecked(1, "MSCHelper: PingTimeout: " $ ServerList[serverNum].s.IP $ ":" $ ServerList[serverNum].s.Port);

	if( ServerList[serverNum].LastPingTime < 0 )
	{
		if (ServerList[serverNum].LastPingTime == -2)
		{
			LogChecked( 2, "Removing server" @ listid );
			ServerList.Remove(serverNum,1);
		}
		else
		{
			LogChecked( 2, "Last chance for server" @ listid );
			ServerList[serverNum].LastPingTime = -2;
		}
	}

	// remove from the outstanding ping list
	for( i=0;i<OutstandingPings.Length;i++ )
	{
		if( OutstandingPings[i] == listid )
		{
			OutstandingPings.Remove(i,1);
			break;
		}
	}

	// continue pinging
	if( PingCause == PC_AutoPing )
	{
		PingServers();
	}
}

event OnReceivedPingInfo( int listid, ServerQueryClient.EPingCause PingCause, GameInfo.ServerResponseLine s )
{
	local int i, serverNum;

	if (TestMode)
	{
		return;
	}

	for( serverNum = 0; serverNum < ServerList.Length; ++serverNum )
	{
		if( ServerList[serverNum].s.ServerID == listid )
			break;
	}

	if( serverNum == ServerList.Length )
	{
		LogChecked( 2, "Got ping from mystery server with ID" @ listid );
		return;
	}

	LogChecked(1, "MSCHelper: ReceivedPingInfo: " $ ServerList[serverNum].s.IP $ ":" $ ServerList[serverNum].s.Port);

	ServerList[serverNum].s = s;
	ServerList[serverNum].s.ServerID = listid;
	ServerList[serverNum].LastPingTime = Time;

	if (PingCause == PC_Clicked)
	{
		ServerList[serverNum].LastDetailsTime = Time;
	}

/*	// see if we can move the ping start marker	down
	for( i=PingStart;i<listid && i<Servers.Length;i++ )
		if(	Servers[i].Ping	== 9999	)
			break;
	if(	i <	listid )
		PingStart =	listid;
*/

	// remove from the outstanding ping	list
	for( i=0; i<OutstandingPings.Length; ++i )
	{
		if(	OutstandingPings[i]	== listid )
		{
			OutstandingPings.Remove(i,1);
			break;
		}
	}

	// continue	pinging
	if(	PingCause == PC_AutoPing )
	{
		PingServers();
	}
}

event OnQueryFinished( MasterServerClient.EResponseInfo ResponseInfo, int Info )
{
	if (TestMode)
	{
		FillTestServers();
		return;
	}

	LogChecked(1, "MSCHelper: QueryFinished: " $ ResponseInfo);
	
	QueryRunning = false;
	
    if( ResponseInfo == RI_Success )
    {
        PingServers();
    }
}

//Query Interface
event ClearQuery()
{
	MSC.Query.Length = 0;
}

event AddQueryTerm(string Key, string GameType, MasterServerClient.EQueryType QueryType)
{
	local MasterServerClient.QueryData QD;
	local int i;

	//do we want to search this to make sure there are no duplicate entries?

	QD.Key			= Key;
	QD.Value		= GameType;
	QD.QueryType	= QueryType;

	i = MSC.Query.Length;
	MSC.Query.Length = i + 1;
	MSC.Query[i] = QD;
}

event StartQuery()
{
	if (TestMode)
	{
		FillTestServers();
		return;
	}

	LogChecked(1, "MSCHelper: Starting Query");
	MSC.StartQuery(CTM_Query);
	QueryRunning = true;
}

event PingServers()
{
    local int i;

	if (TestMode)
	{
		return;
	}

    for( i=0; (i < ServerList.Length) && (OutstandingPings.Length < NumSimultaneousPings); ++i )
    {
        if( ServerList[i].LastPingTime == -1 )
        {
			PingServer( i, PC_AutoPing );
        }
    }
}

event Stop()
{
	//clear our lists...
	ServerList.Remove(0,ServerList.Length);
    OutstandingPings.Remove(0,OutstandingPings.Length);
    
    if (TestMode)
	{
		return;
	}
    
    MSC.CancelPings();
}

event PingServer(int serverNum, ServerQueryClient.EPingCause pc)
{
	local ServerQueryClient.EQueryInterfaceCommand cmd;
	local int i;
	local int pingCap;
	
	if (TestMode)
	{
		return;
	}
	
	LogChecked(2, "MSCHelper: CHECK Pinging Server: " $ ServerList[serverNum].s.IP $ ":" $ ServerList[serverNum].s.Port @ "(" $ ServerList[serverNum].s.QueryPort $ ")" );
	
	//check if we are already waiting on a ping from this server
	for( i=0; i<OutstandingPings.Length; ++i )
	{
		if(	OutstandingPings[i]	== ServerList[ServerNum].s.ServerID )
		{
			LogChecked(2, "MSCHelper: already Pinging Server: " $ ServerList[serverNum].s.IP $ ":" $ ServerList[serverNum].s.Port @ "(" $ ServerList[serverNum].s.QueryPort $ ")" );
			//already on the list, don't re-add
			return;
		}
	}
	
	if (pc == PC_Clicked)
	{
		cmd = QI_RulesAndPlayers;
		pingCap = -1;
	}
	else
	{
		cmd = QI_Ping;
		pingCap = NumSimultaneousPings;
	}

	if ((pingCap > 0) && (OutstandingPings.Length >= pingCap))
	{
		LogChecked(2, "MSCHelper: too busy to ping Server: " $ ServerList[serverNum].s.IP $ ":" $ ServerList[serverNum].s.Port @ "(" $ ServerList[serverNum].s.QueryPort $ ")" );
		//too busy right now to handle this...
		return;
	}
	
	LogChecked(1, "MSCHelper: Pinging Server: " $ ServerList[serverNum].s.IP $ ":" $ ServerList[serverNum].s.Port @ "(" $ ServerList[serverNum].s.QueryPort $ ")" @ ServerList[serverNum].LastPingTime );
	MSC.PingServer( ServerList[serverNum].s.ServerID, pc, ServerList[serverNum].s.IP, ServerList[serverNum].s.QueryPort, cmd, ServerList[serverNum].s );

	//add to outstanding list
	i = OutstandingPings.Length;
    OutstandingPings.Length = i+1;
    OutstandingPings[i] = ServerList[serverNum].s.ServerID;
}

event Tick(float delta)
{
	Time += Delta;
}

event int GetNumServers()
{
	return ServerList.Length;
}

event int GetNumPingedServers()
{
	local int i, pinged;
	for( i = 0; i < ServerList.Length; ++i )
	{
		if( ServerList[i].LastPingTime >= 0 )
			++pinged;
	}
	return pinged;
}

event bool GetServerInfo(int serverNum, out ServerResponseLine s)
{
	s = ServerList[serverNum].s;

	if (TestMode)
	{
		return true;
	}
	
	if (ServerList[serverNum].LastPingTime < 0)
	{
		// so we don't sort incorrectly
		s.Ping = 9999;//ServerList[serverNum].LastPingTime;
	}

	LogChecked(2, "MSCHelper: GetServerInfo " $ QueryRunning @ (Time - ServerList[serverNum].LastPingTime) @ PingTimeThresh);

	if ( !QueryRunning && ((Time - ServerList[serverNum].LastPingTime) > PingTimeThresh) )
	{
		PingServer(serverNum, PC_AutoPing);
	}
	
	return (ServerList[serverNum].LastPingTime >= 0);
}

event bool GetServerDetails(int serverNum, out ServerResponseLine s)
{
	s = ServerList[serverNum].s;
	
	if (TestMode)
	{
		return true;
	}
	
	LogChecked(2, "MSCHelper: GetServerDetails " $ (Time - ServerList[serverNum].LastDetailsTime) @ DetailsTimeThresh);

	if ( !QueryRunning && (Time - ServerList[serverNum].LastDetailsTime) > DetailsTimeThresh)
	{
		PingServer(serverNum, PC_Clicked);
	}
	
	return (ServerList[serverNum].LastDetailsTime >= 0);
}

event FillTestServers()
{
	local int i;
	local int count;
	local ServerInfo si;
	local string GTs[4];
	local string TestMapNames[28];

	if (!TestMode)
	{
		return;
	}

	GTs[0] = "SFRMDeathmatch";
	GTs[1] = "SFRMTeamDeathmatch";
	GTs[2] = "GTVIP";
	GTs[3] = "GTCTF";

//
	i=0;
	TestMapNames[i++]="BACKHILLS";
	TestMapNames[i++]="BAZAAR";
	TestMapNames[i++]="BIGSTREETS";
	TestMapNames[i++]="BRIDGE";
	TestMapNames[i++]="CHURCH";
	TestMapNames[i++]="COMPOUND";
	TestMapNames[i++]="COURTYARD";
	TestMapNames[i++]="CROSSING";
	TestMapNames[i++]="DELTABASE";
	TestMapNames[i++]="DESERT";
	TestMapNames[i++]="DOCKS";
	TestMapNames[i++]="DOCKS";
	TestMapNames[i++]="FACTORY";
	TestMapNames[i++]="FOREST";
	TestMapNames[i++]="GALLERY";
	TestMapNames[i++]="HOSPITAL";
	TestMapNames[i++]="HOTEL";
	TestMapNames[i++]="INSTITUTION";
	TestMapNames[i++]="LABS";
	TestMapNames[i++]="Merclab";
	TestMapNames[i++]="OILRIG";
	TestMapNames[i++]="PARIS";
	TestMapNames[i++]="SOUTHAMERICA";
	TestMapNames[i++]="STREETS";
	TestMapNames[i++]="SUBWAY";
	TestMapNames[i++]="SYRIANIGHTS";
	TestMapNames[i++]="THEGAP";
	TestMapNames[i++]="TOWERS";
//

	ServerList.Remove(0,ServerList.Length);

	for (count=0; count<10; ++count)
	{
		si.s.ServerID = count;
		si.s.IP = "" $ Rand(255) $ "." $ Rand(255) $ "." $ Rand(255) $ "." $ Rand(255);
		si.s.Port = Rand(2500);
		si.s.QueryPort = si.s.Port+1;
		si.s.ServerName = "Another Red Merc " $ Rand(1000);
		si.s.MapName = TestMapNames[Rand(28)];
		si.s.GameType = GTs[Rand(4)];
		si.s.CurrentPlayers = Rand(32);
		si.s.MaxPlayers = Rand(32-si.s.CurrentPlayers)+si.s.CurrentPlayers;
		si.s.Ping = Rand(300);
		
		si.LastPingTime = -1;
		si.LastDetailsTime = -1;

		i = ServerList.Length;
		ServerList.Length=i+1;
		ServerList[i] = si;
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    PingTimeThresh=2.0000000
    DetailsTimeThresh=3.0000000
    NumSimultaneousPings=10
    DebugSpewLevel=2
}