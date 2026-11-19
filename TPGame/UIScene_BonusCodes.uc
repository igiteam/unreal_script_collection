class UIScene_BonusCodes extends UIScene_BonusBase;

var localized string BonusErrorTitle, BonusErrorMessage;

event InitScene()
{
	super.InitScene();
	DisplayKeyboard("",14);
}

function OnKeyboardResults(int PlayerIndex, string ReturnValue)
{
	local	int		bonusID;

	;
	if (ReturnValue == "")
	{
		;
		SceneClient.CloseScene(self);
		PreviousMenuScene.SetVisibility(true);
	}
	else
	{
		;

		if (ReturnValue=="RESET")
		{
			;
			myTPC.ResetProfile();
			SceneClient.CloseScene(self);
			PreviousMenuScene.SetVisibility(true);
			return;
		}

		bonusID = myTPC.ProcessBonusCode(ReturnValue);
		;

		if (bonusID != -1)
		{
			if ( bonusID == BONUS_UNLOCK_ALL_LEVELS )
			{
				myTPC.UnlockAllChapters();
				myTPC.WriteProfile(true);
			}

			SceneClient.CloseScene(self);
			
			UIScene_BonusBase(PreviousMenuScene).UnlockBonusStrings();
			
			PreviousMenuScene.SetVisibility(true);

		}
		else
		{
			SceneClient.CloseScene(self);
			PreviousMenuScene.SetVisibility(true);
			
			PreviousMenuScene.DisplayMessageBox(BonusErrorMessage, BonusErrorTitle);
		}

	}
}

