class OLUIFrontEnd_Console extends OLUIFrontEnd
    config(UI)
	dependson(OLHUD);

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{    
	local bool bResult;

	bResult = false;

	switch(WidgetName)
	{           
	case ('MainMenu'):
		if (MainMenuView == none)
		{
			MainMenuView = OLUIFrontEnd_MainMenu(Widget);
			ConfigureView(MainMenuView, WidgetName, WidgetPath);

			if (MenuType == EMT_MainMenu)
			{
				ConfigureTargetView(MainMenuView);
			}
			bResult = true;
		}            
		break;
	case ('Options'):
		if (OptionsView == none)
		{
			OptionsView = OLUIFrontEnd_Options_Console(Widget);
			ConfigureView(OptionsView, WidgetName, WidgetPath);
			bResult = true;
		}
		break;
	case ('GammaScreen'):
		if (GammaScreenView == none)
		{
			GammaScreenView = OLUIFrontEnd_Screen(Widget);
			ConfigureView(GammaScreenView, WidgetName, WidgetPath);

			if (MenuType == EMT_MainMenu && !HasInitializedGamma() && !class'OLUtils'.static.IsDingo())
			{
				ConfigureTargetView(GammaScreenView);
			}
			bResult = true;
		}
		break;
	case ('DifficultySelectionScreen'):
		if (DifficultySelectionView == none)
		{
			DifficultySelectionView = OLUIFrontEnd_DifficultySelectionScreen(Widget);
			ConfigureView(DifficultySelectionView, WidgetName, WidgetPath);
			bResult = true;
		}
		break;
	case ('ChapterSelection'):
		if (ChapterSelection == none)
		{
			ChapterSelection = OLUIFrontEnd_ChapterSelection(Widget);
			ConfigureView(ChapterSelection, WidgetName, WidgetPath);
			bResult = true;
		}
		break;
	case ('GamepadScreen'):
		if (GamepadScreenView == none)
		{
			GamepadScreenView = OLUIFrontEnd_Screen(Widget);
			ConfigureView(GamepadScreenView, WidgetName, WidgetPath);
			bResult = true;
		}
		break;
	case ('PauseMenu'):
		if (PauseMenuView == none)
		{
			PauseMenuView = OLUIFrontEnd_PauseMenu(Widget);
			ConfigureView(PauseMenuView, WidgetName, WidgetPath);

			if (MenuType == EMT_PauseMenu)
			{
				ConfigureTargetView(PauseMenuView);                 
			}
			bResult = true;
		}
		break;		
	case ('TabMenu'):
		if (TabMenuView == none)
		{
			TabMenuView = OLUIFrontEnd_TabMenu(Widget);
			ConfigureView(TabMenuView, WidgetName, WidgetPath);

			if (MenuType == EMT_TabMenu || MenuType == EMT_EvidenceMenu || MenuType == EMT_RecordingMenu)
			{
				ConfigureTargetView(TabMenuView);
			}
			bResult = true;
		}
		break;
	case ('RecordingList'):
		if (RecordingListView == none)
		{
			RecordingListView = OLUIFrontEnd_RecordingList(Widget);
			ConfigureView(RecordingListView, WidgetName, WidgetPath);

			if (MenuType == EMT_RecordingMenu)
			{
				ConfigureTargetView(RecordingListView);
			}
			bResult = true;
		}
		break;
	case ('RecordingView'):
		if (RecordingView == none)
		{
			RecordingView = OLUIFrontEnd_Screen(Widget);
			ConfigureView(RecordingView, WidgetName, WidgetPath);

			if (MenuType == EMT_RecordingMenu && GetOLPC().HUD.LatestRecordingTimer > 0.f)
			{
				OLUIFrontEnd_RecordingView_Console(RecordingView).Recording = GetOLPC().HUD.LatestRecordingName;
				ConfigureTargetView(RecordingView);
			}

			bResult = true;
		}
		break;
	case ('EvidenceList'):
		if (EvidenceListView == none)
		{
			EvidenceListView = OLUIFrontEnd_EvidenceList(Widget);
			ConfigureView(EvidenceListView, WidgetName, WidgetPath);

			if (MenuType == EMT_EvidenceMenu)
			{
				ConfigureTargetView(EvidenceListView);
			}
			bResult = true;
		}
		break;
	case ('EvidenceView'):
		if (EvidenceView == none)
		{
			EvidenceView = OLUIFrontEnd_Screen(Widget);
			ConfigureView(EvidenceView, WidgetName, WidgetPath);

			if (MenuType == EMT_EvidenceMenu && GetOLPC().HUD.LatestDocumentTimer > 0.f)
			{
				OLUIFrontEnd_EvidenceView_Console(EvidenceView).Collectible = GetOLPC().HUD.LatestDocumentName;
				ConfigureTargetView(EvidenceView);
			}
			bResult = true;
		}
		break;
	case ('Credits'):
		if (CreditsView == none)
		{
			CreditsView = OLUIFrontEnd_Credits(Widget);
			ConfigureView(CreditsView, WidgetName, WidgetPath);

			if (MenuType == EMT_Credits)
			{
				CreditsView.bGameOver = true;
				ConfigureTargetView(CreditsView);
			}
			bResult = true;
		}
		break;
	case ('SaveLocationList'):
		if (SaveLocationList == none)
		{
			SaveLocationList = OLUIFrontEnd_SaveLocationList(Widget);
			ConfigureView(SaveLocationList, WidgetName, WidgetPath);
			bResult = true;
		}
		break;
	default:
		break;
	}
	return bResult;
}

defaultproperties
{    
	//Views
	WidgetBindings.Empty
	WidgetBindings.Add((WidgetName="MainMenu",WidgetClass=class'OLUIFrontEnd_MainMenu'))
	WidgetBindings.Add((WidgetName="PauseMenu",WidgetClass=class'OLUIFrontEnd_PauseMenu'))
	WidgetBindings.Add((WidgetName="Options",WidgetClass=class'OLUIFrontEnd_Options_Console'))
	WidgetBindings.Add((WidgetName="GammaScreen",WidgetClass=class'OLUIFrontEnd_GammaScreen_Console'))
	WidgetBindings.Add((WidgetName="DifficultySelectionScreen",WidgetClass=class'OLUIFrontEnd_DifficultySelectionScreen'))
	WidgetBindings.Add((WidgetName="ChapterSelection",WidgetClass=class'OLUIFrontEnd_ChapterSelection'))
	WidgetBindings.Add((WidgetName="GamepadScreen",WidgetClass=class'OLUIFrontEnd_GamepadScreen_Console'))
	WidgetBindings.Add((WidgetName="Credits",WidgetClass=class'OLUIFrontEnd_Credits'))
	WidgetBindings.Add((WidgetName="TabMenu",WidgetClass=class'OLUIFrontEnd_TabMenu'))
	WidgetBindings.Add((WidgetName="RecordingList",WidgetClass=class'OLUIFrontEnd_RecordingList'))
	WidgetBindings.Add((WidgetName="RecordingView",WidgetClass=class'OLUIFrontEnd_RecordingView_Console'))
	WidgetBindings.Add((WidgetName="EvidenceList",WidgetClass=class'OLUIFrontEnd_EvidenceList'))
	WidgetBindings.Add((WidgetName="EvidenceView",WidgetClass=class'OLUIFrontEnd_EvidenceView_Console'))
	WidgetBindings.Add((WidgetName="SaveLocationList",WidgetClass=class'OLUIFrontEnd_SaveLocationList'))

	MovieInfo=SwfMovie'OLFrontEnd_Console.Manager'
}