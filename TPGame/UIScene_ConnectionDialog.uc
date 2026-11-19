class UIScene_ConnectionDialog extends UIScene_BaseFrontEnd;

var UILabel InfoTextLabel;
var string InfoText;
var string Dots;

var float TimeCounter;
var int PointCount;
var float TimeDelay;



event InitScene()
{
	InfoTextLabel = UILabel( FindChild( 'InfoText', true ) );
		

	SetVisibility(true);

	super.InitScene();
}

function CleanUp()
{
	
	//if ( UIScene_TPCustomMatch( PreviousMenuScene ) != None )
	//{
		//PreviousMenuScene.HandleBack();
	//}

	super.CleanUp();
}

event HandleBack()
{
	local UIScene_TPCustomMatch CustomMatchScene;
	local UIScene_TPMultiplayerOptionsMenu MPMenu;

	CustomMatchScene = UIScene_TPCustomMatch(PreviousMenuScene);

	GetPC().DestroyOnlineSession();

	if (PreviousMenuScene != none || bGoBackWithNoPrevScene)
	{
		PlayUISound('SceneClosed');
		ActivateRemoteEvent(ExitRemoteEvent);
		SceneClient.CloseScene(self);
		if (CustomMatchScene != none)
		{
			MPMenu = UIScene_TPMultiplayerOptionsMenu(CustomMatchScene.PreviousMenuScene);
			CustomMatchScene.HandleBack();
			if (MPMenu != none && GetPC().bLanMatch && !IsXBoxBuild())
				MPMenu.HandleBack();
		}
		else
		{
			if (GetPC().bLanMatch && !IsXBoxBuild())
			{
				MPMenu = UIScene_TPMultiplayerOptionsMenu(PreviousMenuScene);
				if (MPMenu != none)
					MPMenu.HandleBack();
			}
			else
			{
				if (PreviousMenuScene != none)
					PreviousMenuScene.SetVisibility(true);
			}
		}
	}
}

//function bool CustomInputKey( const out InputEventParameters EventParms )
//{
//	if ( EventParms.InputKeyName == 'XboxTypeS_B' && EventParms.EventType == IE_Released )
//	{
//		if (PreviousMenuScene != none)
//		{
//			PlayUISound('SceneClosed');
//			SceneClient.CloseScene(self);
//		}
//		
//		return true;
//	}
//	return super.CustomInputKey(EventParms);
//}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	super.UpdateScene(DeltaTime, WorldInfo);

	TimeCounter += DeltaTime;
	if (TimeCounter > TimeDelay)
	{
		TimeCounter = 0.0;
		PointCount++;
		Dots $= ".";

		if (PointCount > 4)
		{
			PointCount = 0;
			Dots = "";
		}
	}
	InfoTextLabel.SetValue(InfoText$Dots);
}

event SceneDeactivated()
{
	local UIScene_TPMultiplayerOptionsMenu OptionsMenuScene;
	//local UIScene_TPCustomMatch CustomMatchScene;

	OptionsMenuScene = UIScene_TPMultiplayerOptionsMenu(PreviousMenuScene);
	//CustomMatchScene = UIScene_TPCustomMatch(PreviousMenuScene);

	if (OptionsMenuScene != none)
	{
		GetPC().OnlineSub.GameInterface.ClearFindOnlineGamesCompleteDelegate(OptionsMenuScene.GameSearchDone);
		GetPC().OnlineSub.GameInterface.FreeSearchResults();
		OptionsMenuScene.SearchingScene.SetVisibility(false);
	}
	/*else if (CustomMatchScene != none)
	{
		GetPC().OnlineSub.GameInterface.ClearFindOnlineGamesCompleteDelegate(OptionsMenuScene.GameSearchDone);
		GetPC().OnlineSub.GameInterface.FreeSearchResults();
		CustomMatchScene.SearchingScene.SetVisibility(false);
	}*/

	Super.SceneDeactivated();
}

//function OnMessageBoxResults(int PlayerIndex, bool bReturnValue)
//{
//	super.OnMessageBoxResults(PlayerIndex, bReturnValue);
//	HandleBack();
//}

