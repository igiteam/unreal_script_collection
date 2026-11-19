class UIScene_TDMScoreboard extends UIScene_BaseScoreboard;

struct PlayerWidgetData
{
	var UIImage wPlayerInfoBorder;
	var UILabel wPlayerName;
	var UILabel wPlayerLocation;
	var UIImage wPlayerSpeak;
	var UILabel wPlayerScore;
	var UILabel wPlayerKills;
	var UILabel wPlayerDeaths;
	var bool bTalking;
	var float TalkingTimer;
};

struct TeamDataStruct
{
	var PlayerWidgetData PlayerWidgets[4];
	var TPPlayerReplicationInfo PRIList[4];
};

var TeamDataStruct TeamData[2];

event InitScene()
{
	local int i, t;
	local string TeamName;

	super.InitScene();

	for (t = 0; t < 2; t++)
	{
		for (i = 0; i < 4; i++)
		{
			TeamName = ( t == 0 ) ? "Partisan" : "Axis";
			TeamName = TeamName $ string(i);
			
			TeamData[t].PlayerWidgets[i].wPlayerInfoBorder = UIImage( FindChild( name( TeamName$"_ScoreBoard" ), true ) );
			TeamData[t].PlayerWidgets[i].wPlayerName = UILabel( FindChild( name( TeamName$"_PlayerName" ), true ) );
			TeamData[t].PlayerWidgets[i].wPlayerLocation = UILabel( FindChild( name( TeamName$"_PlayerLocation" ), true ) );
			TeamData[t].PlayerWidgets[i].wPlayerScore = UILabel( FindChild( name( TeamName$"_Score" ), true ) );
			TeamData[t].PlayerWidgets[i].wPlayerSpeak = UIImage( FindChild( name( TeamName$"_Speak" ), true ) );
			TeamData[t].PlayerWidgets[i].wPlayerKills = UILabel( FindChild( name( TeamName$"_Kills" ), true ) );
			TeamData[t].PlayerWidgets[i].wPlayerDeaths = UILabel( FindChild( name( TeamName$"_Deaths" ), true ) );
			
			TeamData[t].PlayerWidgets[i].wPlayerInfoBorder.SetVisibility(false);
			TeamData[t].PlayerWidgets[i].wPlayerName.SetValue("");
			TeamData[t].PlayerWidgets[i].wPlayerLocation.SetValue("");
			TeamData[t].PlayerWidgets[i].wPlayerScore.SetValue("");
			TeamData[t].PlayerWidgets[i].wPlayerKills.SetValue("");
			TeamData[t].PlayerWidgets[i].wPlayerDeaths.SetValue("");
			TeamData[t].PlayerWidgets[i].wPlayerSpeak.ActivateStateByClass(class'UIState_Disabled',0);
			if (!IsXBoxBuild())
				TeamData[t].PlayerWidgets[i].wPlayerSpeak.SetVisibility(false);
		}
	}
}

/**
  * returns true if P1 should be sorted before P2
  */
simulated function bool InOrder( PlayerReplicationInfo P1, PlayerReplicationInfo P2 )
{
	// spectators are sorted last
    if( P1.bOnlySpectator )
    {
		return P2.bOnlySpectator;
    }
    else if ( P2.bOnlySpectator )
	{
		return true;
	}

	// sort by Score
    if( P1.Score < P2.Score )
	{
		return false;
	}
    if( P1.Score == P2.Score )
    {
		// if score tied, use deaths to sort
		if ( P1.Deaths > P2.Deaths )
			return false;

		// keep local player highest on list
		if ( (P1.Deaths == P2.Deaths) && (PlayerController(P2.Owner) != None) && (LocalPlayer(PlayerController(P2.Owner).Player) != None) )
			return false;
	}
    return true;
}

simulated function SortPRIArray(array<TPPlayerReplicationInfo> PRIArray)
{
    local int i,j;
    local TPPlayerReplicationInfo tmp;

    for (i=0; i<PRIArray.Length-1; i++)
    {
	for (j=i+1; j<PRIArray.Length; j++)
	{
	    if( !InOrder( PRIArray[i], PRIArray[j] ) )
	    {
			tmp = PRIArray[i];
			PRIArray[i] = PRIArray[j];
			PRIArray[j] = tmp;
	    }
	}
    }
}

function FillTeamList(float DeltaTime)
{
	local TPPlayerReplicationInfo PRI;
	local int i, j, PIndex;
	local int PlayerCounts[4];
	local int NumPartisans, NumNazis;
	local string OutLocationString;

	local array<TPPlayerReplicationInfo> PartisanPRIArray, NaziPRIArray;
	
    for (i = 0; i < 4; i++)
	{
		TeamData[0].PRIList[i] = None;
		TeamData[1].PRIList[i] = None;
	}

	PlayerCounts[0] = 0;
	PlayerCounts[1] = 0;
	PlayerCounts[2] = 0;
	PlayerCounts[3] = 0;

	
	for ( i = 0; i < GRI.PRIArray.Length; i++)
	{
		PRI = TPPlayerReplicationInfo( GRI.PRIArray[i] );

		if (PRI != none)
		{
			if (PRI.Team != none)
			{
				if (PRI.Team.TeamIndex == 0)
					NumPartisans++;
				else
					NumNazis++;

				PIndex = PlayerCounts[PRI.Team.TeamIndex];
				TeamData[PRI.Team.TeamIndex].PRIList[ PIndex ] = PRI;
	
				PlayerCounts[PRI.Team.TeamIndex]++;
				if ( PRI.bReadyToPlay )
				{
					PlayerCounts[2]++;
				}
			}
			PlayerCounts[3]++;
		}
	}

	PartisanPRIArray.Insert(0, NumPartisans);
	NaziPRIArray.Insert(0, NumNazis);

	for (i = 0; i < PartisanPRIArray.Length; i++)
		PartisanPRIArray[i] = TeamData[0].PRIList[i];
	
	for (i = 0; i < NaziPRIArray.Length; i++)
		NaziPRIArray[i] = TeamData[1].PRIList[i];
	
	SortPRIArray(PartisanPRIArray);
	SortPRIArray(NaziPRIArray);

	for (i = 0;i < 4; i++)
	{
		for (j = 0; j < 2; j++)
		{
			if (TeamData[j].PRIList[i] != none )
			{
				PRI = TeamData[j].PRIList[i];

				TeamData[j].PlayerWidgets[i].wPlayerInfoBorder.SetVisibility(true);
				TeamData[j].PlayerWidgets[i].wPlayerName.SetVisibility(true);
			
				if (PRI.PlayerName != "@$%*Player")
					TeamData[j].PlayerWidgets[i].wPlayerName.SetValue( PRI.PlayerName );

				TeamData[j].PlayerWidgets[i].wPlayerScore.SetVisibility(true);
				TeamData[j].PlayerWidgets[i].wPlayerScore.SetValue( string(int(PRI.Score)) );
		
				if ( GRI.GameStatus != GS_PostGame)
				{
					TeamData[j].PlayerWidgets[i].wPlayerName.StringRenderComponent.SetColor(MakeLinearColor(1.0,1.0,1.0,1.0));
					if (IsXBoxBuild())
						TeamData[j].PlayerWidgets[i].wPlayerSpeak.SetVisibility(true);
				}
				else
				{
					if (IsXBoxBuild())
						TeamData[j].PlayerWidgets[i].wPlayerSpeak.SetVisibility(false);
				}

				if (TeamData[j].PlayerWidgets[i].bTalking)
				{
					TeamData[j].PlayerWidgets[i].TalkingTimer -= DeltaTime;
					if (TeamData[j].PlayerWidgets[i].TalkingTimer <= 0)
					{
						TeamData[j].PlayerWidgets[i].bTalking = false;
						TeamData[j].PlayerWidgets[i].TalkingTimer = 0;
						TeamData[j].PlayerWidgets[i].wPlayerSpeak.ActivateStateByClass(class'UIState_Disabled',0);
					}
				}

				if (myTPC.Pawn != none && PRI.Team.TeamIndex == myTPC.Pawn.PlayerReplicationInfo.Team.TeamIndex)
				{
					TeamData[j].PlayerWidgets[i].wPlayerLocation.SetVisibility(true);
					if (GetDataStoreStringValue(PRI.GetLocationName(), OutLocationString))
						TeamData[j].PlayerWidgets[i].wPlayerLocation.SetValue( OutLocationString );
					else
						TeamData[j].PlayerWidgets[i].wPlayerLocation.SetValue( " " );
				}
				else
				{
					TeamData[j].PlayerWidgets[i].wPlayerLocation.SetVisibility(false);
				}
				TeamData[j].PlayerWidgets[i].wPlayerKills.SetVisibility(true);
				TeamData[j].PlayerWidgets[i].wPlayerKills.SetValue(string(PRI.Kills));
				TeamData[j].PlayerWidgets[i].wPlayerDeaths.SetVisibility(true);
				TeamData[j].PlayerWidgets[i].wPlayerDeaths.SetValue(string(int(PRI.Deaths)));
			}
			else
			{
				TeamData[j].PlayerWidgets[i].wPlayerInfoBorder.SetVisibility(false);
				TeamData[j].PlayerWidgets[i].wPlayerName.SetVisibility(false);
				TeamData[j].PlayerWidgets[i].wPlayerName.SetValue( " " );
				TeamData[j].PlayerWidgets[i].wPlayerScore.SetVisibility(false);
				TeamData[j].PlayerWidgets[i].wPlayerScore.SetValue( " " );
				TeamData[j].PlayerWidgets[i].wPlayerLocation.SetVisibility(false);
				TeamData[j].PlayerWidgets[i].wPlayerLocation.SetValue( " " );
				TeamData[j].PlayerWidgets[i].wPlayerKills.SetVisibility(false);
				TeamData[j].PlayerWidgets[i].wPlayerKills.SetValue("");
				TeamData[j].PlayerWidgets[i].wPlayerDeaths.SetVisibility(false);
				TeamData[j].PlayerWidgets[i].wPlayerDeaths.SetValue("");
			}
		}
	}
}

function OnPlayerTalking(UniqueNetId TalkingPlayer)
{
	Local TPPlayerReplicationInfo TalkerPRI;
	local int i, j;

	TalkerPRI = ResolveUniqueNetID(TalkingPlayer);

	if ( TalkerPRI != none )
	{
		for (i = 0;i < 4; i++)
		{
			for (j = 0; j < 2; j++)
			{
				if (CanCommunicate(TalkingPlayer) && TalkerPRI.PlayerName == TeamData[j].PlayerWidgets[i].wPlayerName.GetValue())
				{
					TeamData[j].PlayerWidgets[i].bTalking = true;
					TeamData[j].PlayerWidgets[i].TalkingTimer = DefaultTalkingTime;
					TeamData[j].PlayerWidgets[i].wPlayerSpeak.ActivateStateByClass(class'UIState_Enabled',0);
				}
			}
		}
	}
}


function SetSelIndex(int PlayerIndex)
{
	local LocalPlayer LP;
	local PlayerReplicationInfo PRI;
	local int i,j;
	local int NewIndex;

	LP = GetPlayerOwner(PlayerIndex);
	NewIndex = -1;

	if (LP!=None && LP.Actor != none )
	{
		PRI = LP.Actor.PlayerReplicationInfo;

		for ( i = 0; i < 2; i++ )
		{
			for (j=0;j<4;j++)
			{
				if ( TeamData[i].PRIList[j] == PRI )
				{
					NewIndex = i * 4 + j;
					ChangeSelection(NewIndex);
					return;
				}
			}
		}
	}
	ChangeSelection(NewIndex);
}

simulated function bool ChangeSelection(int NewSelection)
{
	//local int nRow, nCol;
	//local int OldSelection;
	if (GRI.GameStatus != GS_PostGame)
		return false;

	NewSelection = Clamp(NewSelection, 0, 7);
	
	if (SelIndex == NewSelection)
		return false;

	if (SelIndex > 3)
	{
		TeamData[1].PlayerWidgets[SelIndex-4].wPlayerName.StringRenderComponent.SetColor(MakeLinearColor(1.0,1.0,1.0,1.0));
		TeamData[1].PlayerWidgets[SelIndex-4].wPlayerName.StringRenderComponent.ResetFade();
		TeamData[1].PlayerWidgets[SelIndex-4].wPlayerName.StringRenderComponent.SetOpacity(1.0);
	}
	else
	{
		TeamData[0].PlayerWidgets[SelIndex].wPlayerName.StringRenderComponent.SetColor(MakeLinearColor(1.0,1.0,1.0,1.0));
		TeamData[0].PlayerWidgets[SelIndex].wPlayerName.StringRenderComponent.ResetFade();
		TeamData[0].PlayerWidgets[SelIndex].wPlayerName.StringRenderComponent.SetOpacity(1.0);
	}
	
	if (NewSelection > 3)
	{
		if (TeamData[1].PRIList[NewSelection-4] != none)
		{
			SelIndex = NewSelection;
			;
			if (IsXBoxBuild())
			{
				TeamData[1].PlayerWidgets[NewSelection-4].wPlayerName.StringRenderComponent.SetColor(MakeLinearColor(0.82,0.66,0.0,1.0));
				TeamData[1].PlayerWidgets[NewSelection-4].wPlayerName.StringRenderComponent.Pulse(1.0,0.35,2.0);
			}
			return true;
		}
		else
		{
			if (SelIndex > 3)
				TeamData[1].PlayerWidgets[SelIndex-4].wPlayerName.StringRenderComponent.Pulse(1.0,0.35,2.0);
			else
				TeamData[0].PlayerWidgets[SelIndex].wPlayerName.StringRenderComponent.Pulse(1.0,0.35,0.5);
		}
	}
	else
	{
		if (TeamData[0].PRIList[NewSelection] != none)
		{
			SelIndex = NewSelection;
			;
			if (IsXBoxBuild())
			{
				TeamData[0].PlayerWidgets[NewSelection].wPlayerName.StringRenderComponent.SetColor(MakeLinearColor(0.82,0.66,0.0,1.0));
				TeamData[0].PlayerWidgets[NewSelection].wPlayerName.StringRenderComponent.Pulse(1.0,0.35,2.0);
			}
			return true;
		}
		else
		{
			if (SelIndex > 3)
				TeamData[1].PlayerWidgets[SelIndex-4].wPlayerName.StringRenderComponent.SetColor(MakeLinearColor(0.82,0.66,0.0,1.0));
			else
				TeamData[0].PlayerWidgets[SelIndex].wPlayerName.StringRenderComponent.SetColor(MakeLinearColor(0.82,0.66,0.0,1.0));
		}
	}
	
	return false;
}

function bool CustomInputKey( const out InputEventParameters EventParms )
{
	//local UIScene OpenedScene;
	if (IsXboxBuild())
	{
		if ( ( EventParms.InputKeyName == 'XboxTypeS_A' ) &&
			  EventParms.EventType == IE_Released )
		{
			if ( SelIndex > 3 )
			{				
				if (TeamData[1].PRIList[SelIndex-4] != none)
				{
					DisplayGamerCard(class'UIInteraction'.static.GetPlayerControllerId(0),TeamData[1].PRIList[SelIndex-4]);
					PlayUISound('Clicked');
				}
			}
			else
			{
				if (TeamData[0].PRIList[SelIndex] != none)
				{
					DisplayGamerCard(class'UIInteraction'.static.GetPlayerControllerId(0),TeamData[0].PRIList[SelIndex]);
					PlayUISound('Clicked');
				}
			}
			return true;
		}
	}
	return super.CustomInputKey(EventParms);
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	super.UpdateScene(DeltaTime, WorldInfo);

	if ( GRI.GameStatus >= GS_PreGame)
	{
		FillTeamList(DeltaTime);
	}
}

