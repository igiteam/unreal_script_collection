//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDTEAMHUD extends HDHUD
   config(Game);

var HDGFxTeamHUD    HDTHUD;
var HDGFxChar       HDChar;
var bool            bShowScore;

var config float    TeamScorePosY;

var localized string TEAM_INFO_MESSAGE;
var localized string WaitForRespawn;
var localized string StartMatchMessage;

simulated function SetShowScore( bool InShow )
{
	bShowScore = InShow;

	if( bShowScore )
	{
		ShowScoreBand();
	}
	else
	{
		CloseScoreBand();
	}
}

exec function ShowScoreBand()
{
	HDTHUD.Start();
	HDTHUD.UpdateInfo();

	SetTimer( 1.0, true, 'Update' );
}

exec function CloseScoreBand()
{
	if( !bShowScore )
	{
		HDTHUD.Stop();
		ClearTimer( 'Update' );
	}
}

function Update()
{
	HDTHUD.UpdateInfo();
}

//MulitPlay Char to All
exec function AllChar()
{
	 if(HDChar != None)
		HDChar.Close(TRUE);

	 HDChar = new class'HDGFxChar';
	 HDChar.CommandString = "Say ";
	 HDChar.Start();
}

//MulitPlay Char in Team
exec function TeamChar()
{
	 if(HDChar != None)
		HDChar.Close(TRUE);

	 HDChar = new class'HDGFxChar';
	 HDChar.CommandString = "TeamSay ";
	 HDChar.Start();
}

simulated function DisplayMap()
{
	local HDMapInfo MI;

	MI = HDMapInfo( WorldInfo.GetMapInfo() );
	if( MI != none )
	{
		if( MI.HDGFxTeamMiniMap == None )
		{
			MI.HDGFxTeamMiniMap = new class'HDGFxTeamMiniMap';
			MI.HDGFxTeamMiniMap.MovieInfo = SwfMovie'TM_HUD.TM_UI_MiniMap';
			MI.HDGFxTeamMiniMap.Start();
		}

		MI.DrawGFxMap();
		MI.DrawTaskTip();
	}

}

simulated function SetPawnNameVisible(bool bShow)
{
	local Pawn P;
	foreach WorldInfo.AllPawns(class'Pawn', P)
	{
		TMPawn(P).bShowAllTeamName = bShow;
	}
}

simulated simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	HDTHUD = new class'HDGFxTeamHUD';   //EM class
	HDTHUD.MovieInfo = SwfMovie'TM_HUD.TM_UI_TeamHud';
	HDTHUD.myHUD = self;
	HDTHUD.LocalPlayerOwnerIndex = class'Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(PlayerOwner.Player));
	HDTHUD.SetTimingMode(TM_Real);
}

simulated function string GetTeamInfoMessage()
{
	local int numRedPlayers, numBluePlayers, numSpeculators;
	local PlayerReplicationInfo PRI;

	foreach WorldInfo.GRI.PRIArray( PRI )
	{
		if( PRI.Team == none
		|| PRI.Team.TeamIndex == 255 )
		{
			numSpeculators ++;
		}
		else if( PRI.Team.TeamIndex == 0 )
		{
			numRedPlayers ++;
		}
		else if( PRI.Team.TeamIndex == 1 )
		{
			numBluePlayers ++;
		}
	}

	return Repl( Repl( Repl( TEAM_INFO_MESSAGE, "\`r", numRedPlayers ),
		"\`b", numBluePlayers ), "\`s", numSpeculators );
}

/**
 * This function is called to draw the hud while the game is still in progress.  You should only draw items here
 * that are always displayed.  If you want to draw something that is displayed only when the player is alive
 * use DrawLivingHud().
 */
simulated function DrawGameHud()
{
	//local float xl, yl;
	local Pawn P;
	//local int i, len;
	//local UniqueNetId OtherPlayerNetId;

	Super.DrawGameHud();

	// Draw any spectator information
	if( TMOwnerPRI != None )
	{
		if( TMOwnerPRI.bOnlySpectator || TMPlayerOwner.IsInState('Spectating') )
		{
			if( WorldInfo.NetMode == NM_ListenServer
			&& HDFightToDeath( WorldInfo.Game ) != none
			&& HDFightToDeath( WorldInfo.Game ).bShouldStartMatch == false )
			{
				DisplayHUDMessage( StartMatchMessage $ " (" $ GetTeamInfoMessage() $ ")" );
			}
			else
			{
				P = Pawn(TMPlayerOwner.ViewTarget);
				if( P != None
				&& P.PlayerReplicationInfo != None
				&& P.PlayerReplicationInfo != TMOwnerPRI )
				{
					DisplayHUDMessage(SpectatorMessage @ "-" @
						P.PlayerReplicationInfo.PlayerName);
				}
				else
				{
					DisplayHUDMessage( SpectatorMessage);
				}
			}
		}
		else if( TMOwnerPRI.bIsSpectator )
		{
			if( WorldInfo.NetMode == NM_ListenServer
			&& HDFightToDeath( WorldInfo.Game ) != none
			&& HDFightToDeath( WorldInfo.Game ).bShouldStartMatch == false )
			{
				DisplayHUDMessage( StartMatchMessage $ " (" $ GetTeamInfoMessage() $ ")" );
			}
			else
			{
				DisplayHUDMessage( WaitingForMatch $ " (" $ GetTeamInfoMessage() $ ")" );
			}

			//ShowScoreBand();
		}
		else if( TMPlayerOwner.IsDead() )
		{
			DisplayHUDMessage( DeadMessage );
		}
	}

	DrawRespawnTime();

//    Canvas.Font = GetFontSizeIndex(1);
//
//    // Check if any remote players are using VOIP
//    if ( ( CharPRI == None )
//  && ( PlayerOwner.VoiceInterface != None )
//  && ( WorldInfo.NetMode != NM_Standalone )
//    && ( WorldInfo.GRI != None ) )
//    {
//        len = WorldInfo.GRI.PRIArray.Length;
//        for( i = 0; i < len; i++ )
//        {
//            OtherPlayerNetId = WorldInfo.GRI.PRIArray[i].UniqueID;
//            if ( PlayerOwner.VoiceInterface.IsRemotePlayerTalking(OtherPlayerNetId)
//                && (WorldInfo.GRI.PRIArray[i] != PlayerOwner.PlayerReplicationInfo)
//                && (TMPlayerReplicationInfo(WorldInfo.GRI.PRIArray[i]) != None)
//                && (PlayerOwner.GameplayVoiceMuteList.Find('Uid', OtherPlayerNetId.Uid) == INDEX_NONE) )
//            {
//                ShowPortrait( TMPlayerReplicationInfo(WorldInfo.GRI.PRIArray[i]) );
//                break;
//            }
//        }
//    }
}

simulated function DrawRespawnTime()
{
	local float StrX, StrY;
	local string Msg;
	local float RespawnTime;

	RespawnTime = TMPlayerController(PlayerOwner).RespawnTime;

	if( RespawnTime <= 0.0 )    return;

	/*Msg = WaitForRespawn $*/
	Msg = "" $ Max( 0, Round(
		WorldInfo.GRI.RespawnTime - ( WorldInfo.TimeSeconds - RespawnTime ) ) );

	Canvas.Font = ChineseFont;
	Canvas.StrLen( Msg, StrX, StrY );

	Canvas.DrawColor = PlayerOwner.PlayerReplicationInfo.Team.TeamColor;

	Canvas.SetPos( ( Canvas.SizeX - StrX ) / 2.0, Canvas.SizeY * 1.0 / 4.0 );
	Canvas.DrawText( Msg, true, 3.0, 3.0 );
}

