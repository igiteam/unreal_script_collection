//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDGFxFrontend_MainMenu extends HDGFxFrontend
	  config(Engine);

var transient GFxObject HD_Title;
var transient GFxObject HD_SinglePlayTempGFxObject;
var transient GFxObject HD_MulitPlayTempGFxObject;
var transient GFxObject HD_MulitPlayMC;
var transient GFxObject HD_MulitPlay_CreatserverMC;
var transient GFxObject HD_MP_Input_Mapname;
var transient GFxObject HD_MP_Input_Servername;
var transient GFxObject HD_MP_Input_Gamemode;
var transient GFxObject HD_MP_Input_Maxnum;
var transient GFxObject HD_MP_Input_Maxtime;
var transient GFxObject HD_MP_Input_Maxscore;
var transient GFxObject HD_MP_Input_Balanceteam;
var transient GFxObject HD_MP_Input_Respawn;
var transient GFxObject HD_MP_Input_Teamnum;
var transient GFxObject HD_MP_Input_Chrnum;
var transient GFxObject HD_MP_Input_IP;
var transient GFxObject HD_MP_Button_JoinMC;
var transient GFxObject HD_MP_Button_CreatMC;
var transient GFxObject HD_MP_Button_RefreshMC;
var transient GFxObject HD_MP_Button_RefreshByIPMC;
var transient GFxObject HD_MP_MessageMC;
var transient GFxObject HD_MP_TitleMC;
var transient GFxObject HD_Version;
var array<GFxObject>    ServerListMC;

//Map name
var string  Beach01Map;
var string  Beach02Map;
var string  Beach03Map;
var string  HillMap;
var string  CliffMap;
var string  SeigeMap;
var string  FactoryMap;
var string  VillageMap;
var string  CityMap;
var string  TrainingMap;
var string  Range01Map;
var string  Range02Map;
var string  Range04Map;
var string  Player_Num;

//Mulit map
var string  MP_MapName;
var string  MP_ServerName;
var string  MP_GameMode;
var string  MP_PlayerName;
var int     MP_CreatTeam;
var int     MP_CreatChr;
var int     MP_PlayNum;
var int     MP_MaxTime;
var int     MP_MaxScore;
var int     MP_Respawn;
var bool    MP_Balanceteam;
var int     MP_JoinIdx;
var int     MP_JoinTeam;
var int     MP_JoinChr;
var int     SpectatorOnly;
var int     SinglePlayMaxLevel;
var bool    bDevelopingMode;

var () matrix  TempMatrix;

var HDIDSystem m_kIdSystem;
var HDGameSetting m_kGameSetting;

var config float SystemMusicVolume;
var config float SystemSFXVolume;
var config float SystemVoiceVolume;
var config bool SystemVoiceChatting;

var AudioComponent CastListBGM;

	function bool Start(optional bool StartPaused = false)
	{
		super.Start();
		SetSystemVolume ();
		SetVoiceChatting ();
		Player_Num = "?NumPlay=0";
		TMGame(GetPC().WorldInfo.Game).OnLanGameSearchEnded = LanGameSearchEnded;
		Advance(0);
		HD_Version   = GetVariableObject("_root.HDVersion");
		HD_Version.SetText("Version: " $ class'Engine'.default.GameVersion);
		if( Left(GetPC().WorldInfo.GetMapName(), 10) ~= "TMFrontEnd")
		{
			class'Engine'.static.EnableIME(True);   //Open IME
		}
		return TRUE;
	}
	function PlayCastBgm()
	{
	   if(CastListBGM == None)
		CastListBGM = GetPC().CreateAudioComponent(SoundCue'HD_FrontEnd.HD_UI_SOUND.castlistbgm_Cue',False,True);
	   CastListBGM.Play();
	}

	function StopCastBgm()
	{
	  CastListBGM.Stop();
	}
	/** Read player name*/
	function string ReadPlayerName ()
	{
		local LoginPlayerManager    PlayerManager;

		PlayerManager = class'GameEngine'.static.GetPlayerManager();

		return PlayerManager.currentPlayerName;
	}

	/** Modify player name*/
	function ModifyPlayerName (string playerName)
	{
		local LoginPlayerManager    PlayerManager;

		PlayerManager = class'GameEngine'.static.GetPlayerManager();

		PlayerManager.currentPlayerName = playerName;
	}

	function SetSystemVolume ()
	{
		GetPC().SetAudioGroupVolume('SFX', SystemSFXVolume);
		GetPC().SetAudioGroupVolume('Music', SystemMusicVolume);
		GetPC().SetAudioGroupVolume('Voice', SystemVoiceVolume);
	}

	function SetVoiceChatting ()
	{
		local OnlineSubsystem OS;
		local OnlineVoiceInterface VI;

		// Figure out if we have an online subsystem registered
		OS = class'GameEngine'.static.GetOnlineSubsystem();

		if( OS != None )
		{
			// Grab the game interface to verify the subsystem supports it
			VI = OS.VoiceInterface;
			if( VI != None )
			{
				if (SystemVoiceChatting)
				{
					VI.StartSpeechRecognition(0);
				}
				else
				{
					VI.StopSpeechRecognition(0);
				}
			}
		}
	}

	function QuitGame()
	{
		local LoginPlayerManager PlayerManager;

		PlayerManager = class'GameEngine'.static.GetPlayerManager();

		PlayerManager.currentPlayerName = "";
		PlayerManager.SaveConfig ();

		ConsoleCommand("quit");
	}

	function SetSinglePlayCurrentMaxLevel ()
	{
		local GFxObject TmpObject;
		TmpObject = GetVariableObject("_root.managerall.sp.ChoseMap");

		if (bDevelopingMode)
		{
		 TmpObject.SetFloat("CurrentMaxLevel", float(8));
		}
		else
		{
		 TmpObject.SetFloat("CurrentMaxLevel", float(SinglePlayMaxLevel));
		}
	}

	function SetFinishedTraining ()
	{
		local GFxObject TmpObject;
		local string PlayerName;
		local LoginPlayerInfo PlayerInfo;
		local LoginPlayerManager PlayerManager;

		PlayerManager = class'GameEngine'.static.GetPlayerManager();

		TmpObject = GetVariableObject("_root.managerall");
		PlayerName = playerManager.currentPlayerName;
		bDevelopingMode = playerManager.bDevelopingMode;
		PlayerInfo = playerManager.getPlayer(PlayerName);
		SinglePlayMaxLevel = PlayerInfo.LevelInSinglePlay;

		if (bDevelopingMode)
		{
		 TmpObject.SetBool("bFinishedTraining", true);
		}
		else
		{
		 //TmpObject.SetBool("bFinishedTraining", PlayerInfo.bFinishedTraining);       Delete Training Lock
		 TmpObject.SetBool("bFinishedTraining", true);
		}
	}

	function StartGame(int Level_num)
	{
	if (!bDevelopingMode && Level_num <= 8 && Level_num > SinglePlayMaxLevel)
	{
	   return ;
	}
	class'Engine'.static.EnableIME(False);
	switch (Level_num)
		{
			case(1):
				ConsoleCommand("open "$Beach01Map$"?game=TMGame.TGGameSP_Base"$Player_Num);
				break;
			 case(2):
				ConsoleCommand("open "$Beach03Map $ "?game=TMGame.TGGameSP_Base"$Player_Num);
				break;
			 case(3):
				ConsoleCommand("open "$HillMap $ "?game=TMGame.TGGameSP_Base"$Player_Num);
				break;
			case(4):
				ConsoleCommand("open "$CliffMap$"?game=TMGame.TGGameSP_Base"$Player_Num);
				break;
			case(5):
				ConsoleCommand("open "$SeigeMap$"?game=TMGame.TGGameSP_Base"$Player_Num);
				break;
			case(6):
				ConsoleCommand("open "$FactoryMap$"?game=TMGame.TGGameSP_Base"$Player_Num);
				break;
			case(7):
				ConsoleCommand("open "$VillageMap$"?game=TMGame.TGGameSP_Sniper"$Player_Num);
				break;
			case(8):
				ConsoleCommand("open "$CityMap$"?game=TMGame.TGGameSP_Base"$Player_Num);
				break;
			case(9):
				ConsoleCommand("open "$Range02Map$"?game=TMGame.TGGameSP_Train"$Player_Num);
				break;
			case(10):
				ConsoleCommand("open "$Range01Map$"?game=TMGame.TGGameSP_Train"$Player_Num);
				break;
			case(11):
				ConsoleCommand("open "$TrainingMap$"?game=TMGame.TGGameSP_Base"$Player_Num);
				break;
			case(12):
				ConsoleCommand("open "$Range04Map$"?game=TMGame.TGGameSP_Base"$Player_Num);
				break;
		}
	}
	//MulitPlay Init
	function InitMP()
	{
		local GFxObject TmpObject;
		local LoginPlayerInfo PlayerInfo;
		local LoginPlayerManager PlayerManager;

		PlayerManager = class'GameEngine'.static.GetPlayerManager();

		PlayerInfo = PlayerManager.getPlayer(playerManager.currentPlayerName);
		MP_ServerName = PlayerInfo.PlayerName;

		// Init MP
		HD_MulitPlayMC             = GetVariableObject("_root.managerall.mp");
		HD_MP_Button_JoinMC        = HD_MulitPlayMC.GetObject("Joinserver");
		HD_MP_Button_CreatMC       = HD_MulitPlayMC.GetObject("Creatserver");
		HD_MP_Button_RefreshMC     = HD_MulitPlayMC.GetObject("Refresh");
		HD_MP_Button_RefreshByIPMC = HD_MulitPlayMC.GetObject("RefreshByIP");
		HD_MP_Input_IP             = HD_MulitPlayMC.GetObject("Input_ip");
		HD_MulitPlay_CreatserverMC = HD_MulitPlayMC.GetObject("Creatservermc");
		HD_MP_Input_Mapname        = HD_MulitPlay_CreatserverMC.GetObject("Input_mapname");
		HD_MP_Input_Servername     = HD_MulitPlay_CreatserverMC.GetObject("Input_servername");
		HD_MP_Input_Gamemode       = HD_MulitPlay_CreatserverMC.GetObject("Input_gamemode");
		HD_MP_Input_Maxnum         = HD_MulitPlay_CreatserverMC.GetObject("Input_maxnum");
		HD_MP_MessageMC            = HD_MulitPlayMC.GetObject("F_Message");
		HD_MP_TitleMC              = HD_MulitPlayMC.GetObject("F_Title");

		SetMessage();
		//ReFreshs();

		TmpObject = HD_MulitPlayMC.GetObject("MultiPlay_PlayerName");
		TmpObject.SetText("??:"$PlayerInfo.PlayerName);
		TmpObject = HD_MulitPlayMC.GetObject("MultiPlay_PlayerMilitary");
		TmpObject.SetText("??:"$PlayerInfo.MilitaryRank);
		TmpObject = HD_MulitPlayMC.GetObject("MultiPlay_PlayerScore");
		TmpObject.SetText("??:"$(PlayerInfo.PlayerScore));
	}

	function InitMPCreat()
	{
		//local GFxObject DataProvider;
		//local GFxObject TempObj;


		// Init MP_Creat
		SetServerListVisable();
		HD_MulitPlay_CreatserverMC = HD_MulitPlayMC.GetObject("Creatservermc");
		HD_MP_Input_Mapname        = HD_MulitPlay_CreatserverMC.GetObject("Input_mapname");
		HD_MP_Input_Servername     = HD_MulitPlay_CreatserverMC.GetObject("Input_servername");
		HD_MP_Input_Gamemode       = HD_MulitPlay_CreatserverMC.GetObject("Input_gamemode");
		HD_MP_Input_Maxnum         = HD_MulitPlay_CreatserverMC.GetObject("Input_maxnum");
		HD_MP_Input_Maxtime        = HD_MulitPlay_CreatserverMC.GetObject("Input_maxtime");
		HD_MP_Input_Maxscore       = HD_MulitPlay_CreatserverMC.GetObject("Input_maxscore");
		HD_MP_Input_Balanceteam    = HD_MulitPlay_CreatserverMC.GetObject("Input_balanceteam");
		HD_MP_Input_Respawn        = HD_MulitPlay_CreatserverMC.GetObject("Input_respawn");
		HD_MP_Input_Teamnum        = HD_MulitPlay_CreatserverMC.GetObject("Input_teamnum");
		HD_MP_Input_Chrnum         = HD_MulitPlay_CreatserverMC.GetObject("Input_chrnum");

		HD_MP_Input_Servername.SetText(MP_ServerName);

		InitMapName();
	}

	function InitMapName()
	{
		local int Idx;
		local int NameIdx;
		local string GameModeFontStr;
		local GFxObject MapNameDataProvider;

		switch(HD_MP_Input_Gamemode.GetFloat("_selectedIndex"))
		{
			case(0):
			GameModeFontStr ="MP";//????
			HD_MP_MessageMC.SetText(MessageInfo[0]);
			HD_MP_Input_Maxnum.SetVisible(True);
			HD_MP_Input_Respawn.SetVisible(True);
			Break;

			case(1):
			GameModeFontStr ="HL";//????
			HD_MP_MessageMC.SetText(MessageInfo[1]);
			HD_MP_Input_Maxnum.SetVisible(True);
			HD_MP_Input_Respawn.SetVisible(True);
			Break;

			case(2):
			GameModeFontStr ="FD";//????
			HD_MP_MessageMC.SetText(MessageInfo[2]);
			HD_MP_Input_Maxnum.SetVisible(False);
			HD_MP_Input_Respawn.SetVisible(False);
			Break;

		}
		MapNameDataProvider = HD_MP_Input_Mapname.Outer.CreateArray();
		NameIdx = 0;
		 for(Idx=0;Idx<MapName.Length;Idx++)
		 {
			 if(Left(MapName[Idx].FileName, 2) == GameModeFontStr)
				{
				MapNameDataProvider.SetElementString(NameIdx,MapName[Idx].ShowName);
				NameIdx++;
				}
		 }
		HD_MP_Input_Mapname.SetObject("dataProvider", MapNameDataProvider);
		HD_MP_Input_Mapname.SetFloat("_selectedIndex",0);

		HD_MP_TitleMC.SetText(MessageTitle[0]);

	}

	//MulitPlayJoin Init
	function InitMPJoin()
	{

		local GFxObject  TempObj;

		SetServerListVisable();
		TempObj = HD_MulitPlayMC.GetObject("Output_mapname");
		TempObj.SetText(ServerListMC[MP_JoinIdx].GetObject("Map").GetText());
		TempObj = HD_MulitPlayMC.GetObject("Output_servername");
		TempObj.SetText(ServerListMC[MP_JoinIdx].GetObject("Name").GetText());
		TempObj = HD_MulitPlayMC.GetObject("Output_gamemode");
		TempObj.SetText(ServerListMC[MP_JoinIdx].GetObject("GameMode").GetText());
		TempObj = HD_MulitPlayMC.GetObject("Output_maxnum");
		TempObj.SetText(ServerListMC[MP_JoinIdx].GetObject("Playnum").GetText());
		TempObj = HD_MulitPlayMC.GetObject("Output_maxtime");
		TempObj.SetText(ServerListMC[MP_JoinIdx].GetObject("Timemax").GetText());
		TempObj = HD_MulitPlayMC.GetObject("Output_maxscore");
		TempObj.SetText(ServerListMC[MP_JoinIdx].GetObject("Scoremax").GetText());


		HD_MP_Input_Mapname    = HD_MulitPlay_CreatserverMC.GetObject("Input_mapname");
		HD_MP_Input_Servername = HD_MulitPlay_CreatserverMC.GetObject("Input_servername");
		HD_MP_Input_Maxnum     = HD_MulitPlay_CreatserverMC.GetObject("Input_maxnum");

		SetMessage();
	}

	function InChangeJob(float TeamIdx,float JobIdx)
	{
	  local GFxObject TempObj;
	  local int i;

	  TempObj = HD_MulitPlayMC.GetObject("Output_jobtip");
	  i = 10*(TeamIdx)+JobIdx;
	  TempObj.SetText(JobTip[i]);

	}
	//Click Creat Call
	function CreatServers()
	{
		local string  GameModeEn;
		local int     MapIdx;

		MP_ServerName =  HD_MP_Input_Servername.GetText();
		MP_GameMode   =  HD_MP_Input_Gamemode.GetString("selectedItem");
		MP_PlayNum    =  int(HD_MP_Input_Maxnum.GetFloat("selectedItem"));
		MP_MaxTime    =  int(HD_MP_Input_Maxtime.GetFloat("selectedItem"));
		MP_Respawn    =  int(HD_MP_Input_Respawn.GetFloat("selectedItem"));
		MP_Balanceteam = bool(HD_MP_Input_Balanceteam.GetFloat("_selectedIndex"));
		MP_MaxScore   =  int(HD_MP_Input_Maxscore.GetFloat("selectedItem"));
		MP_CreatTeam  =  int(HD_MP_Input_Teamnum.GetFloat("_selectedIndex"));
		MP_CreatChr   =  int(HD_MP_Input_Chrnum.GetFloat("_selectedIndex"));

		for(MapIdx=0;MapIdx<MapName.Length;MapIdx++)
		 {
		  if(MapName[MapIdx].ShowName ==  HD_MP_Input_Mapname.GetString("selectedItem"))
		   Break;
		 }
		MP_MapName    =  MapName[MapIdx].FileName;

		switch(MP_GameMode)
		{
		 case (GameModeName[0]):
			  GameModeEn =  "TMGame.HDTeamDeathMatch";
			  Break;
		 case (GameModeName[1]):
			  GameModeEn =  "TMGame.HDHoldLineGame";
			  Break;
		 case (GameModeName[2]):
			  GameModeEn =  "TMGame.HDFightToDeath";
			  MP_PlayNum =  32;
			  Break;
		}

		if(HD_MP_Input_Maxtime.GetString("selectedItem") == "???")
		 MP_MaxTime = 9999;
		if(HD_MP_Input_Maxscore.GetString("selectedItem") == "???")
		 MP_MaxScore= 9999;
		if(HD_MP_Input_Respawn.GetString("selectedItem")== "???")
		 MP_Respawn = -1;

		if(MP_CreatTeam == 2)
			SpectatorOnly = 1;

		if(MP_MapName!="")
		{
			TMGame(GetPC().WorldInfo.Game).CreateLanGame(MP_MapName,
													  MP_ServerName,
													  GameModeEn,
													  MP_MaxScore,
													  MP_MaxTime,
													  MP_PlayNum,
													  MP_Respawn,
													  MP_Balanceteam,
													  MP_CreatTeam,
													  MP_CreatChr,
													  SpectatorOnly);
		}
	}
	//Click Join Call
	function JoinServers()
	{
		local GFxObject TempObj;

		TempObj    = HD_MulitPlayMC.GetObject("Output_teamnum");
		MP_JoinTeam=  int(TempObj.GetFloat("_selectedIndex"));
		TempObj    = HD_MulitPlayMC.GetObject("Output_chrnum");
		MP_JoinChr =  int(TempObj.GetFloat("_selectedIndex"));
		if(MP_JoinTeam == 2)
		 SpectatorOnly = 1;
		TMGame(GetPC().WorldInfo.Game).JoinLanGame(MP_JoinIdx,
												   MP_JoinTeam,
												   MP_JoinChr,
												   SpectatorOnly);
	}

	function SetJoinIdx(int Idx)
	{
		MP_JoinIdx = Idx;
	}

	//Click ReFresh Call
	function ReFreshs()
	{
		local TMGame  TMG;
		TMG = TMGame(GetPC().WorldInfo.Game);
		if(TMG!=None)
		{
			TMG.SearchLanGame();
			SetButtonVisable();
		}
		SetServerListVisable();
	}

	function ReFreshsByIP()
	{
		local TMGame  TMG;
		TMG = TMGame(GetPC().WorldInfo.Game);
		if(TMG!=None && !TMG.QueryLanGame(HD_MP_Input_IP.GetText()))
		{
			SetButtonVisable();
			SetServerListVisable();
		}

	}

	function  LanGameSearchEnded(OnlineGameSearch InGameSearch, bool InIsSucceeded)
	{
	 local OnlineGameSearchResult result;
	 local GFxObject        TempIdxMc;
	 local GFxObject        TempMapMc;
	 local GFxObject        TempScoreMc;
	 local GFxObject        TempTimeMc;
	 local GFxObject        TempServerMc;
	 local GFxObject        TempGameMode;
	 local GFxObject        TempPlayerNumMc;
	 local GFxObject        TempRedNumMc;
	 local GFxObject        TempBlueNumMc;
	 local GFxObject        TempNameMc;

	 local int Idx;
	 local int MapIdx;
	 local float SMC_height;
	 local string PN;

	 if(InGameSearch.Results.Length>0)
	 {
	  foreach InGameSearch.Results( result, Idx )
	  {
	   ServerListMC[Idx].SetVisible(TRUE);
//     ServerListMC[Idx] = HD_MulitPlayMC.GetObject("ServerList"$Idx);
	   if(ServerListMC[Idx]==None)
	   {
		ServerListMC[Idx]= HD_MulitPlayMC.AttachMovie("ServerList","ServerList"$Idx);
	   }
	   SMC_height       = ServerListMC[Idx].GetFloat("_height");
	   TempIdxMc        = ServerListMC[Idx].GetObject("Idx");
	   TempMapMc        = ServerListMC[Idx].GetObject("Map");
	   TempServerMc     = ServerListMC[Idx].GetObject("Servername");
	   TempGameMode     = ServerListMC[Idx].GetObject("GameMode");
	   TempPlayerNumMc  = ServerListMC[Idx].GetObject("Playnum");
	   TempRedNumMc     = ServerListMC[Idx].GetObject("Rednum");
	   TempBlueNumMc    = ServerListMC[Idx].GetObject("Bluenum");
	   TempNameMc       = ServerListMC[Idx].GetObject("Name");
	   TempTimeMc       = ServerListMC[Idx].GetObject("Timemax");
	   TempScoreMc      = ServerListMC[Idx].GetObject("Scoremax");

	   ServerListMC[Idx].SetPosition(0,(SMC_height+10)*Idx);

	   TempIdxMc.SetText(string(Idx));
		for(MapIdx=0;MapIdx<MapName.Length;MapIdx++)
			{
				if(MapName[MapIdx].FileName == result.GameSettings.MapName)
				{
				 TempMapMc.SetText(MapName[MapIdx].ShowName);
				 Break;
				}
			}
	   TempServerMc.SetText(result.GameSettings.HostAddr);

	   if(result.GameSettings.Game ~= "TMGame.HDTeamDeathMatch")
		{
			TempGameMode.SetText(GameModeName[0]);
		}
	   else if(result.GameSettings.Game ~= "TMGame.HDHoldLineGame")
		{
			TempGameMode.SetText(GameModeName[1]);
		}
		else
		{
			TempGameMode.SetText("????");
		}
	   PN = (result.GameSettings.NumPublicConnections-result.GameSettings.NumOpenPublicConnections) $ "/" $ result.GameSettings.NumPublicConnections;
	   TempPlayerNumMc.SetText(PN);
	   TempNameMc.SetText(result.GameSettings.OwningPlayerName);
	   TempScoreMc.SetText(result.GameSettings.GoalScore);
	   TempTimeMc.SetText(result.GameSettings.TimeLimit) ;
	   TempRedNumMc.SetText(((result.GameSettings.NumPublicConnections)/2)-result.GameSettings.NumRedTeamOpenConnection);
	   TempBlueNumMc.SetText(((result.GameSettings.NumPublicConnections)/2)-result.GameSettings.NumBlueTeamOpenConnection);
		if(result.GameSettings.NumOpenPublicConnections <= 0)
		{
		  ServerListMC[Idx].SetString("Message","??????????????");
		 }
		else if(!result.GameSettings.bAllowJoinInProgress && result.GameSettings.bStarted)
		{
		 ServerListMC[Idx].SetString("Message","????????????????");
		}
		 else
		 {
		 ServerListMC[Idx].SetString("Message","?????????????");
		 ServerListMC[Idx].SetBool("bJoin",True);
		 }
	  }
	 }
	 SetButtonVisable(TRUE);
	 SetServerListVisable(TRUE);
	}

	function SetGameLevel(float LevelNum)
	{
	 GetPC().WorldInfo.Game.GameDifficulty = LevelNum;//Def 1.0  Easy 1.0 Normal 1.5 Hard 2.0
	 GetPC().WorldInfo.Game.SaveConfig();
	}
	function SetButtonVisable(optional bool bOpen = false)
	{
	HD_MP_Button_JoinMC.SetVisible(bOpen);
	HD_MP_Button_CreatMC.SetVisible(bOpen);
	HD_MP_Button_RefreshMC.SetVisible(bOpen);
	HD_MP_Button_RefreshByIPMC.SetVisible(bOpen);
	}

	function SetServerListVisable(optional bool bOpen = false)
	{
	 local int     Idx;

	 for(Idx= 0; Idx < ServerListMC.Length;Idx++)
	   {
		ServerListMC[Idx].SetVisible(bOpen);
	   }
	}
	function CloseServerList()
	{
	   ServerListMC.Remove(0,ServerListMC.Length);
	}

	function SetMessage()
	{
	 local string Message;
	 local string Title;

	 class'UIRoot'.static.GetDataStoreStringValue("<Registry:FrontEndError_Message>", Message);
	 class'UIRoot'.static.GetDataStoreStringValue("<Registry:FrontEndError_Title>", Title);
	 HD_MP_MessageMC.SetText(Message);
	 HD_MP_TitleMC.SetText(Title);
	}

	function EnterLogin (int index)
	{
		 m_kIdSystem.EnterLogin(index);
	}

	function CheckLogin ()
	{
		local GFxObject TmpObject;
		local LoginPlayerManager PlayerManager;

		PlayerManager = class'GameEngine'.static.GetPlayerManager();

		TmpObject = GetVariableObject("_root");
		if (playerManager.currentPlayerName == "")
		{
		   TmpObject.SetBool("bFirstIn", true);
		}
		else
		{
		   TmpObject.SetBool("bFirstIn", false);
		}
	}

	function Array<string> LoadData()
	{
		if (m_kIdSystem == none)
		{
		 m_kIdSystem = new(none, "IdSystem") class'HDIDSystem';

		}

		return m_kIdSystem.LoadData();
	}

	function SaveData()
	{
		m_kIdSystem.SaveData();
	}

	function AddPlayer()
	{
		local GFxObject kObject;
		local string playerName;

		kObject = GetVariableObject("_root.idsystem.createdialog.create_playername");
		playerName = kObject.GetText();

		/*if( (InStr(playerName, " ")) >= 0)
		{
		   playername = Repl(playerName," ","");
		} */

		m_kIdSystem.AddPlayer(playerName);
	}

	function DeletePlayer()
	{
		local GFxObject kObject;
		local string playerName;
		kObject = GetVariableObject("_root.idsystem.deletedialog.deleted_player");
		playerName = kObject.GetText();

		m_kIdSystem.DeletePlayer(playerName);
	}

	function EnterGame ()
	{
		local GFxObject kIDSystem;
		local GFxObject kLogindialog;
		local GFxObject kUserList;
		local int                   iSelectedIndex;
		local string                playerName;
		local LoginPlayerManager    PlayerManager;

		PlayerManager = class'GameEngine'.static.GetPlayerManager();
		kIDSystem = GetVariableObject("_root.idsystem");
		kLogindialog = kIDSystem.GetObject("logindialog");
		kUserList = kLogindialog.GetObject("Userlist");
		iSelectedIndex = int(kUserList.GetFloat("selectedIndex"));

		playerName = PlayerManager.Players[iSelectedIndex].playerName;

		m_kIdSystem.EnterGame(playerName);
	}

	function GameSetting_InitControl ()
	{
		if (m_kGameSetting == none)
		{
			 m_kGameSetting = new(none, "GameSetting") class'HDGameSetting';
			 m_kGameSetting.PlayerController = HDEntryPlayerController(GetPC());
			 m_kGameSetting.PlayerInput = HDPlayerInput(m_kGameSetting.PlayerController.PlayerInput);
			 m_kGameSetting.Profile = TMProfileSettings(m_kGameSetting.PlayerController.OnlinePlayerData.ProfileProvider.Profile);
			 m_kGameSetting.HD_GameSettingMC = GetVariableObject("_root.managerall.game_setting");
			 m_kGameSetting.SystemSet = new(none, "SystemSet") class'HDSystemSet';

			 m_kGameSetting.Audio_SoundEffectVolume = SystemSFXVolume;
			 m_kGameSetting.Audio_MusicVolume = SystemMusicVolume;
			 m_kGameSetting.Audio_VoiceVolume = SystemVoiceVolume;
			 m_kGameSetting.Audio_Chatting = int(SystemVoiceChatting);
		}

		m_kGameSetting.InitControlSetting ();
		GameSetting_SetKeySet ();
	}

	function GameSetting_SetKeySet ()
	{
		SetVariableStringArray("_root.managerall.game_setting.Control_KeySetting.Key_Array", 0, m_kGameSetting.Control_KeySetting_tmp);
	}

	function GameSetting_GetKeySet ()
	{
		GetVariableStringArray("_root.managerall.game_setting.Control_KeySetting.Key_Array", 0, m_kGameSetting.Control_KeySetting_tmp);
	}

	function GameSetting_InitVideoAudio ()
	{
		m_kGameSetting.InitVideoAudioSetting ();
	}

	function GameSetting_SetControlValue ()
	{
		m_kGameSetting.SetControlValue ();
		GameSetting_GetKeySet ();
	}

	function GameSetting_SetVideoAudioValue ()
	{
		m_kGameSetting.SetVideoAudioValue ();
	}

	function GameSetting_Reset ()
	{
		m_kGameSetting.Audio_SoundEffectVolume = SystemSFXVolume;
		m_kGameSetting.Audio_MusicVolume = SystemMusicVolume;
		m_kGameSetting.Audio_VoiceVolume = SystemVoiceVolume;
		m_kGameSetting.Audio_Chatting = int(SystemVoiceChatting);

		m_kGameSetting.ResetSetting ();

		if (m_kGameSetting.iCurrentPage == 1)
		{
		 GameSetting_SetKeySet ();
		}
	}

	function GameSetting_Apply ()
	{
	   if (m_kGameSetting.iCurrentPage == 1)
	   {
		GameSetting_GetKeySet ();
	   }

	   m_kGameSetting.ApplySetting ();
	   m_kGameSetting.SaveSetting ();

	   // Audio
	   SystemSFXVolume = m_kGameSetting.Audio_SoundEffectVolume;
	   SystemMusicVolume = m_kGameSetting.Audio_MusicVolume;
	   SystemVoiceVolume = m_kGameSetting.Audio_VoiceVolume;
	   SystemVoiceChatting = bool(m_kGameSetting.Audio_Chatting);

	   GetPC().SetAudioGroupVolume('SFX', SystemSFXVolume);
	   GetPC().SetAudioGroupVolume('Music', SystemMusicVolume);
	   GetPC().SetAudioGroupVolume('Voice', SystemVoiceVolume);
	   SetVoiceChatting ();
	   SaveConfig ();
	}

	 event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
	{
		local bool bWasHandled;
		bWasHandled = false;
	 switch(WidgetName)
	 {
		case ('Btn_OK'):

		HD_Title = Widget.GetObject("label");
		HD_Title.SetText(OK);
		HD_Title = Widget.GetObject("textField");
		HD_Title.SetText(OK);
		bWasHandled = true;
		break;

		case ('training'):

		HD_Title = Widget.GetObject("label");
		HD_Title.SetText(Training);
		HD_Title = Widget.GetObject("textField");
		HD_Title.SetText(Training);
		bWasHandled = true;
		break;

		 case ('range01'):

		HD_Title = Widget.GetObject("label");
		HD_Title.SetText(Range01);
		HD_Title = Widget.GetObject("textField");
		HD_Title.SetText(Range01);
		bWasHandled = true;
		break;

		 case ('range02'):

		HD_Title = Widget.GetObject("label");
		HD_Title.SetText(Range02);
		HD_Title = Widget.GetObject("textField");
		HD_Title.SetText(Range02);
		bWasHandled = true;
		break;

		 case ('range03'):

		HD_Title = Widget.GetObject("label");
		HD_Title.SetText(Range03);
		HD_Title = Widget.GetObject("textField");
		HD_Title.SetText(Range03);
		bWasHandled = true;
		break;

		  case ('range04'):

		HD_Title = Widget.GetObject("label");
		HD_Title.SetText(Range04);
		HD_Title = Widget.GetObject("textField");
		HD_Title.SetText(Range04);
		bWasHandled = true;
		break;

		 case ('back'):

		HD_Title = Widget.GetObject("label");
		HD_Title.SetText(Back);
		HD_Title = Widget.GetObject("textField");
		HD_Title.SetText(Back);
		bWasHandled = true;
		break;

		case ('singleplay'):

		HD_Title = Widget.GetObject("label");
		HD_Title.SetText(SinglePlay);
		HD_Title = Widget.GetObject("textField");
		HD_Title.SetText(SinglePlay);
		bWasHandled = true;
		break;

		 case ('multplay'):

		HD_Title = Widget.GetObject("label");
		HD_Title.SetText(MultiPlay);
		HD_Title = Widget.GetObject("textField");
		HD_Title.SetText(MultiPlay);
		bWasHandled = true;
		break;

		 case ('gamesetting'):

		HD_Title = Widget.GetObject("label");
		HD_Title.SetText(GameSetting);
		HD_Title = Widget.GetObject("textField");
		HD_Title.SetText(GameSetting);
		bWasHandled = true;
		break;

		 case ('castlist'):

		HD_Title = Widget.GetObject("label");
		HD_Title.SetText(CastList);
		HD_Title = Widget.GetObject("textField");
		HD_Title.SetText(CastList);
		bWasHandled = true;
		break;

		 case ('exitgame'):

		HD_Title = Widget.GetObject("label");
		HD_Title.SetText(Exit);
		HD_Title = Widget.GetObject("textField");
		HD_Title.SetText(Exit);
		bWasHandled = true;
		break;

		case ('level1'):

		HD_SinglePlayTempGFxObject = Widget.GetObject("label");
		HD_SinglePlayTempGFxObject.SetText(LevelName[1]);
		HD_SinglePlayTempGFxObject = Widget.GetObject("textField");
		HD_SinglePlayTempGFxObject.SetText(LevelName[1]);
		bWasHandled = true;
		break;

		case ('level2'):
		HD_SinglePlayTempGFxObject = Widget.GetObject("label");
		HD_SinglePlayTempGFxObject.SetText(LevelName[2]);
		HD_SinglePlayTempGFxObject = Widget.GetObject("textField");
		HD_SinglePlayTempGFxObject.SetText(LevelName[2]);
		bWasHandled = true;
		break;

		case ('level3'):
		HD_SinglePlayTempGFxObject = Widget.GetObject("label");
		HD_SinglePlayTempGFxObject.SetText(LevelName[3]);
		HD_SinglePlayTempGFxObject = Widget.GetObject("textField");
		HD_SinglePlayTempGFxObject.SetText(LevelName[3]);
		bWasHandled = true;
		break;
		case ('level4'):

		HD_SinglePlayTempGFxObject = Widget.GetObject("label");
		HD_SinglePlayTempGFxObject.SetText(LevelName[4]);
		HD_SinglePlayTempGFxObject = Widget.GetObject("textField");
		HD_SinglePlayTempGFxObject.SetText(LevelName[4]);
		bWasHandled = true;
		break;

		case ('level5'):
		HD_SinglePlayTempGFxObject = Widget.GetObject("label");
		HD_SinglePlayTempGFxObject.SetText(LevelName[5]);
		HD_SinglePlayTempGFxObject = Widget.GetObject("textField");
		HD_SinglePlayTempGFxObject.SetText(LevelName[5]);
		bWasHandled = true;
		break;

		case ('level6'):
		HD_SinglePlayTempGFxObject = Widget.GetObject("label");
		HD_SinglePlayTempGFxObject.SetText(LevelName[6]);
		HD_SinglePlayTempGFxObject = Widget.GetObject("textField");
		HD_SinglePlayTempGFxObject.SetText(LevelName[6]);
		bWasHandled = true;
		break;

		case ('level7'):
		HD_SinglePlayTempGFxObject = Widget.GetObject("label");
		HD_SinglePlayTempGFxObject.SetText(LevelName[7]);
		HD_SinglePlayTempGFxObject = Widget.GetObject("textField");
		HD_SinglePlayTempGFxObject.SetText(LevelName[7]);
		bWasHandled = true;
		break;

		case ('level8'):
		HD_SinglePlayTempGFxObject = Widget.GetObject("label");
		HD_SinglePlayTempGFxObject.SetText(LevelName[8]);
		HD_SinglePlayTempGFxObject = Widget.GetObject("textField");
		HD_SinglePlayTempGFxObject.SetText(LevelName[8]);
		bWasHandled = true;
		break;

		case ('level9'):
		HD_SinglePlayTempGFxObject = Widget.GetObject("label");
		HD_SinglePlayTempGFxObject.SetText(LevelName[9]);
		HD_SinglePlayTempGFxObject = Widget.GetObject("textField");
		HD_SinglePlayTempGFxObject.SetText(LevelName[9]);
		bWasHandled = true;
		break;

		case ('Creatserver'):

		HD_MulitPlayTempGFxObject = Widget.GetObject("label");
		HD_MulitPlayTempGFxObject.SetText(CreatServer);
		HD_MulitPlayTempGFxObject = Widget.GetObject("textField");
		HD_MulitPlayTempGFxObject.SetText(CreatServer);
		bWasHandled = true;
		break;

		case ('Joinserver'):

		HD_MulitPlayTempGFxObject = Widget.GetObject("label");
		HD_MulitPlayTempGFxObject.SetText(JoinServer);
		HD_MulitPlayTempGFxObject = Widget.GetObject("textField");
		HD_MulitPlayTempGFxObject.SetText(JoinServer);
		bWasHandled = true;
		break;

		case ('Refresh'):

		HD_MulitPlayTempGFxObject = Widget.GetObject("label");
		HD_MulitPlayTempGFxObject.SetText(ReFresh);
		HD_MulitPlayTempGFxObject = Widget.GetObject("textField");
		HD_MulitPlayTempGFxObject.SetText(ReFresh);
		bWasHandled = true;
		break;

		case ('RefreshByIP'):

		HD_MulitPlayTempGFxObject = Widget.GetObject("label");
		HD_MulitPlayTempGFxObject.SetText(ReFreshsBy);
		HD_MulitPlayTempGFxObject = Widget.GetObject("textField");
		HD_MulitPlayTempGFxObject.SetText(ReFreshsBy);
		bWasHandled = true;
		break;

		case 'enterGame':
				  HD_Title = Widget.GetObject("label");
				  HD_Title.SetText(m_kIdSystem.Login_enterGame[m_kIdSystem.LanguageIndex]);
				  HD_Title = Widget.GetObject("textField");
				  HD_Title.SetText(m_kIdSystem.Login_enterGame[m_kIdSystem.LanguageIndex]);
				  bWasHandled = true;
				  break;

			  case 'deleteUser':
				  HD_Title = Widget.GetObject("label");
				  HD_Title.SetText(m_kIdSystem.Login_deleteUser[m_kIdSystem.LanguageIndex]);
				  HD_Title = Widget.GetObject("textField");
				  HD_Title.SetText(m_kIdSystem.Login_deleteUser[m_kIdSystem.LanguageIndex]);
				  bWasHandled = true;
				  break;

			 case 'createUser':
				  HD_Title = Widget.GetObject("label");
				  HD_Title.SetText(m_kIdSystem.Login_createUser[m_kIdSystem.LanguageIndex]);
				  HD_Title = Widget.GetObject("textField");
				  HD_Title.SetText(m_kIdSystem.Login_createUser[m_kIdSystem.LanguageIndex]);
				  bWasHandled = true;
				  break;

			 case 'quitGame':
				  HD_Title = Widget.GetObject("label");
				  HD_Title.SetText(m_kIdSystem.Login_quitGame[m_kIdSystem.LanguageIndex]);
				  HD_Title = Widget.GetObject("textField");
				  HD_Title.SetText(m_kIdSystem.Login_quitGame[m_kIdSystem.LanguageIndex]);
				  bWasHandled = true;
				  break;

			 case 'create_title':
				  HD_Title = Widget.GetObject("text");
				  HD_Title.SetText(m_kIdSystem.Create_title[m_kIdSystem.LanguageIndex]);
				  HD_Title = Widget.GetObject("textField");
				  HD_Title.SetText(m_kIdSystem.Create_title[m_kIdSystem.LanguageIndex]);
				  bWasHandled = true;
				  break;

			 case 'create_inputguide':
				  HD_Title = Widget.GetObject("text");
				  HD_Title.SetText(m_kIdSystem.Create_inputguide[m_kIdSystem.LanguageIndex]);
				  HD_Title = Widget.GetObject("textField");
				  HD_Title.SetText(m_kIdSystem.Create_inputguide[m_kIdSystem.LanguageIndex]);
				  bWasHandled = true;
				  break;

			 case 'create_error':
				  HD_Title = Widget.GetObject("text");
				  HD_Title.SetText(m_kIdSystem.Create_error[m_kIdSystem.LanguageIndex]);
				  HD_Title = Widget.GetObject("textField");
				  HD_Title.SetText(m_kIdSystem.Create_error[m_kIdSystem.LanguageIndex]);
				  bWasHandled = true;
				  break;

			 case 'create_ok':
				  HD_Title = Widget.GetObject("label");
				  HD_Title.SetText(m_kIdSystem.Create_ok[m_kIdSystem.LanguageIndex]);
				  HD_Title = Widget.GetObject("textField");
				  HD_Title.SetText(m_kIdSystem.Create_ok[m_kIdSystem.LanguageIndex]);
				  bWasHandled = true;
				  break;

			 case 'create_cancel':
				  HD_Title = Widget.GetObject("label");
				  HD_Title.SetText(m_kIdSystem.Create_cancel[m_kIdSystem.LanguageIndex]);
				  HD_Title = Widget.GetObject("textField");
				  HD_Title.SetText(m_kIdSystem.Create_cancel[m_kIdSystem.LanguageIndex]);
				  bWasHandled = true;
				  break;

			 case 'delete_title':
				  HD_Title = Widget.GetObject("text");
				  HD_Title.SetText(m_kIdSystem.Delete_title[m_kIdSystem.LanguageIndex]);
				  HD_Title = Widget.GetObject("textField");
				  HD_Title.SetText(m_kIdSystem.Delete_title[m_kIdSystem.LanguageIndex]);
				  bWasHandled = true;
				  break;

			 case 'delete_guide':
				  HD_Title = Widget.GetObject("text");
				  HD_Title.SetText(m_kIdSystem.Delete_guide[m_kIdSystem.LanguageIndex]);
				  HD_Title = Widget.GetObject("textField");
				  HD_Title.SetText(m_kIdSystem.Delete_guide[m_kIdSystem.LanguageIndex]);
				  bWasHandled = true;
				  break;

			 case 'delete_ok':
				  HD_Title = Widget.GetObject("label");
				  HD_Title.SetText(m_kIdSystem.Delete_ok[m_kIdSystem.LanguageIndex]);
				  HD_Title = Widget.GetObject("textField");
				  HD_Title.SetText(m_kIdSystem.Delete_ok[m_kIdSystem.LanguageIndex]);
				  bWasHandled = true;
				  break;

			 case 'delete_cancel':
				  HD_Title = Widget.GetObject("label");
				  HD_Title.SetText(m_kIdSystem.Delete_cancel[m_kIdSystem.LanguageIndex]);
				  HD_Title = Widget.GetObject("textField");
				  HD_Title.SetText(m_kIdSystem.Delete_cancel[m_kIdSystem.LanguageIndex]);
				  bWasHandled = true;
				  break;
	 }

	 if (!bWasHandled)
		{
			bWasHandled = Super.WidgetInitialized(WidgetName, WidgetPath, Widget);
		}
		return bWasHandled;

	}
