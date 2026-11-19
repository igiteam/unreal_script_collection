class UIScene_DMScoreboard extends UIScene_BaseScoreboard;

struct PlayerWidgetStruct
{
	var UILabel wPlayerName;
	var UILabel wPlayerScore;
	var UILabel wPlayerKills;
	var UILabel wPlayerDeaths;
	var UIImage wPlayerTalking;
	var bool bTalking;
	var float TalkingTimer;
	var TPPlayerReplicationInfo PRI;
};
var PlayerWidgetStruct PlayerData[8];

event InitScene()
{
	local int i;

	

	super.InitScene();

	for (i = 0; i < 8; i++)
	{
		PlayerData[i].wPlayerName = UILabel( FindChild( name( "Player_"$string(i) ), true ) );
		PlayerData[i].wPlayerScore = UILabel( FindChild( name( "Score_"$string(i) ), true ) );
		PlayerData[i].wPlayerKills = UILabel( FindChild( name( "Kills_"$string(i) ), true ) );
		PlayerData[i].wPlayerDeaths = UILabel( FindChild( name( "Deaths_"$string(i) ), true ) );
		//PlayerData[i].wPlayerTalking = UIImage( FindChild( name( "Playerspeak_"$i ), true ) );
		//if (!IsXBoxBuild())
		//	PlayerData[i].wPlayerTalking.SetVisibility(false);
		//PlayerData[i].wPlayerTalking.ActivateStateByClass(class'UIState_Disabled',0);

		PlayerData[i].wPlayerName.SetValue("");
		PlayerData[i].wPlayerScore.SetValue("");
		PlayerData[i].wPlayerKills.SetValue("");
		PlayerData[i].wPlayerDeaths.SetValue("");
	}
}

function FillList(float DeltaTime)
{
	local TPPlayerReplicationInfo PRI;
	local int i;

	for (i = 0; i < 8; i++)
	{
		PlayerData[i].wPlayerName.SetValue("");
		PlayerData[i].wPlayerScore.SetValue("");
		PlayerData[i].wPlayerKills.SetValue("");
		PlayerData[i].wPlayerDeaths.SetValue("");
		PlayerData[i].PRI = none;

		if ( GRI.GameStatus != GS_PostGame)
		{
			PlayerData[i].wPlayerName.StringRenderComponent.SetColor(ColorToLinearColor(UnReadyNameColor));
			//if (IsXBoxBuild())
			//	PlayerData[i].wPlayerTalking.SetVisibility(true);
		}
		else
		{
			//if (IsXBoxBuild())
			//	PlayerData[i].wPlayerTalking.SetVisibility(false);
		}
	}

	GRI.SortPRIArray();

	for ( i = 0; i < GRI.PRIArray.Length; i++)
	{
		PRI = TPPlayerReplicationInfo( GRI.PRIArray[i] );
		if (PRI != none)
		{
			if (PRI.PlayerName != "@$%*Player")
				PlayerData[i].wPlayerName.SetValue(PRI.PlayerName);

			PlayerData[i].wPlayerScore.SetValue(string(int(PRI.Score)));
			PlayerData[i].wPlayerKills.SetValue(string(PRI.Kills));
			PlayerData[i].wPlayerDeaths.SetValue(string(int(PRI.Deaths)));

			if (PlayerData[i].bTalking)
			{
				PlayerData[i].TalkingTimer -= DeltaTime;
				if (PlayerData[i].TalkingTimer <= 0)
				{
					PlayerData[i].bTalking = false;
					PlayerData[i].TalkingTimer = 0;
					//PlayerData[i].wPlayerTalking.ActivateStateByClass(class'UIState_Disabled',0);
				}
			}
		}
	}
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	super.UpdateScene(DeltaTime, WorldInfo);
	
	if ( GRI.GameStatus >= GS_PreGame)
	{
		FillList(DeltaTime);
	}
}

function OnPlayerTalking(UniqueNetId TalkingPlayer)
{
	Local TPPlayerReplicationInfo TalkerPRI;
	local int i;
	TalkerPRI = ResolveUniqueNetID(TalkingPlayer);
	if ( TalkerPRI != none )
	{
		//wPlayerTalkingLabel
		for (i = 0; i < 8; i++)
		{
			if (CanCommunicate(TalkingPlayer) && TalkerPRI.PlayerName == PlayerData[i].wPlayerName.GetValue())
			{
				PlayerData[i].bTalking = true;
				PlayerData[i].TalkingTimer = DefaultTalkingTime;
				//PlayerData[i].wPlayerTalking.ActivateStateByClass(class'UIState_Enabled',0);
				//wPlayerTalking[i].ImageComponent.Fade(1.0,0.0,0.05);
			}
		}
		//GetPlayerOwner(0).Actor.ClientMessage(TalkerPRI$" is talking");
		//TalkerPRI.ChatFadeValue = 1.0;
		//TalkerPRI.ChatFadeTime = 1.5;
	}
}

function SetSelIndex(int PlayerIndex)
{
	local LocalPlayer LP;
	local PlayerReplicationInfo PRI;
	local int i;
	local int NewIndex;

	LP = GetPlayerOwner(PlayerIndex);
	NewIndex = -1;

	if (LP!=None && LP.Actor != none )
	{
		PRI = LP.Actor.PlayerReplicationInfo;

		for ( i = 0; i < GetWorldInfo().GRI.PRIArray.Length; i++ )
		{
			if ( GetWorldInfo().GRI.PRIArray[i] == PRI )
			{
				NewIndex = i;
				ChangeSelection(NewIndex);
				return;
			}
		}
	}
	ChangeSelection(NewIndex);

}

simulated function bool ChangeSelection(int NewSelection)
{
	local int TempSelection;
	TempSelection = NewSelection;
	
	if (GRI.GameStatus != GS_PostGame)
		return false;

	NewSelection = Clamp(NewSelection, 0, GetWorldInfo().GRI.PRIArray.Length-1);
	
	if (GetWorldInfo().GRI.PRIArray[SelIndex].bReadyToPlay)
		PlayerData[SelIndex].wPlayerName.StringRenderComponent.SetColor(ColorToLinearColor(ReadyNameColor));
	else
		PlayerData[SelIndex].wPlayerName.StringRenderComponent.SetColor(ColorToLinearColor(UnReadyNameColor));

	PlayerData[SelIndex].wPlayerName.StringRenderComponent.ResetFade();
	PlayerData[SelIndex].wPlayerName.StringRenderComponent.SetOpacity(1.0);

	if (TempSelection != -1 && GetWorldInfo().GRI.PRIArray[NewSelection] != none)
	{
		SelIndex = NewSelection;
		if (IsXboxBuild())
		{
			PlayerData[SelIndex].wPlayerName.StringRenderComponent.SetColor(ColorToLinearColor(GamerTagSelectedColor));
			PlayerData[SelIndex].wPlayerName.StringRenderComponent.Pulse(1.0,0.35,2.0);
		}
		return true;
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
				if (GetWorldInfo().GRI.PRIArray[SelIndex] != none)
				{
					DisplayGamerCard(class'UIInteraction'.static.GetPlayerControllerId(0),GetWorldInfo().GRI.PRIArray[SelIndex]);
					PlayUISound('Clicked');
				}
				return true;
			}
	}
	return super.CustomInputKey(EventParms);
}

