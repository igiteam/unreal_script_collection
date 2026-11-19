class UIScene_TPPlayerMatch extends UIScene_BaseFrontEnd;

var int SelectedMenuIndex;

event InitScene()
{
	super.InitScene();
	if (IsPCBuild() && GetLoginStatus(LocPlayer.ControllerId) != LS_LoggedIn && !GetPC().bLanMatch)
		SetVisibility(false);
	else
		SetVisibility(true);
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
	SelectedMenuIndex = MenuIndex;
}

