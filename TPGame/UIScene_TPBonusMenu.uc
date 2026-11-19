class UIScene_TPBonusMenu extends UIScene_BaseFrontEnd;

event InitScene()
{
	super.InitScene();

	RefreshBonusUnlockedStatus();
	

// 	if ( myTPC.IsSoftened() && (MenuItems[MenuItems.Length - 1].ButtonName == "CharWeapArtButton") )
// 		MenuItems.Remove( MenuItems.Length - 1, 1 );
}

function RefreshBonusUnlockedStatus()
{
	//`log(self @ "env art =" @  myTPC.IsBonusUnlocked( BONUS_UNLOCK_ENV_ART ));
	//`log(self @ "chw art =" @  myTPC.IsBonusUnlocked( BONUS_UNLOCK_CHAR_WEAP_ART ));


	if (!myTPC.IsBonusUnlocked( BONUS_UNLOCK_ENV_ART ))
	{
		MenuItems[2].wMenuButton.SetDatastoreBinding("<Strings:TPGame.BonusMenu.EnvArtLocked>");
		MenuItems[2].wMenuButton.StringRenderComponent.Fade(1.0f, 0.5f, 0.0f);
		MenuItems[2].bDisabled = true;
	}
	else
	{
		MenuItems[2].bDisabled = false;
		MenuItems[2].wMenuButton.SetDatastoreBinding("<Strings:TPGame.BonusMenu.EnvArt>");
		MenuItems[2].wMenuButton.StringRenderComponent.SetOpacity(1.0);
		MenuItems[2].wMenuButton.StringRenderComponent.ResetFade();
		
	}

	if (!myTPC.IsBonusUnlocked( BONUS_UNLOCK_CHAR_WEAP_ART ))
	{
		MenuItems[3].wMenuButton.SetDatastoreBinding("<Strings:TPGame.BonusMenu.CharWeapArtLocked>");
		MenuItems[3].wMenuButton.StringRenderComponent.Fade(1.0f, 0.5f, 0.0f);
		MenuItems[3].bDisabled = true;
	}
	else
	{
		MenuItems[3].bDisabled = false;
		MenuItems[3].wMenuButton.SetDatastoreBinding("<Strings:TPGame.BonusMenu.CharWeapArt>");
		MenuItems[3].wMenuButton.StringRenderComponent.SetOpacity(1.0);
		MenuItems[3].wMenuButton.StringRenderComponent.ResetFade();
		
	}
}

event SetVisibility( bool bIsVisible )
{
	if( bIsVisible == true )
	{
		//`log(self @ "setting visibility so refreshing bonus status");
		RefreshBonusUnlockedStatus();
	}
	
	super.SetVisibility(bIsVisible);
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
	local TPGameViewportClient viewport;

	viewport = TPGameViewportClient(LocPlayer.ViewportClient);

	switch (MenuIndex)
	{
		case 0:
		viewport.FullScreenPlayMovie('Credits', PLAYMOVIE_StreamBlock);
		break;

		case 2:
			if ( myTPC.IsBonusUnlocked( BONUS_UNLOCK_ENV_ART ) )		
				viewport.FullScreenPlayMovie('EnvArt', PLAYMOVIE_StreamBlock);
		break;

		case 3:
			if ( myTPC.IsBonusUnlocked( BONUS_UNLOCK_CHAR_WEAP_ART ) )		
				viewport.FullScreenPlayMovie('CharWeapArt', PLAYMOVIE_StreamBlock);
		break;
	}
}

