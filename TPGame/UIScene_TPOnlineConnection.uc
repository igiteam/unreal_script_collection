class UIScene_TPOnlineConnection extends UIScene_BaseFrontEnd;

function OnClick(UIScene OpenedScene, int MenuIndex)
{
	if (MenuIndex == 0)
	{
		GetPC().bUsesArbitration = false;
	}
	if (MenuIndex == 1)
	{
		GetPC().bUsesArbitration = true;
	}
}

function CleanUp()
{
	super.CleanUp();
	GetPC().bUsesArbitration = false;
}
