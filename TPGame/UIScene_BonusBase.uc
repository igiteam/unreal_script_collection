class UIScene_BonusBase extends UIScene_BaseFrontEnd;

function UnlockBonusStrings()
{
	local UILabel bonusLabel;

	//
	// Go through all of the bonuses, and update the text of those that are unlocked.
	//
	bonusLabel = UILabel( FindChild( 'AlwaysHaveGrenadesLock', true ) );
	if ( myTPC.IsBonusActive( BONUS_ALWAYS_HAVE_GRENADES ) )
	{
		bonusLabel.SetDataStoreBinding("<Strings:TPGame.BonusCodesMain.Active>");
	}
	else if ( myTPC.IsBonusUnlocked( BONUS_ALWAYS_HAVE_GRENADES ) )
	{
		bonusLabel.SetDataStoreBinding("<Strings:TPGame.BonusCodesMain.Unlocked>");
	}

	bonusLabel = UILabel( FindChild( 'AlwaysHaveAmmoLock', true ) );
	if ( myTPC.IsBonusActive( BONUS_ALWAYS_HAVE_AMMO ) )
	{
		bonusLabel.SetDataStoreBinding("<Strings:TPGame.BonusCodesMain.Active>");
	}
	else if ( myTPC.IsBonusUnlocked( BONUS_ALWAYS_HAVE_AMMO ) )
	{
		bonusLabel.SetDataStoreBinding("<Strings:TPGame.BonusCodesMain.Unlocked>");
	}

	bonusLabel = UILabel( FindChild( 'DoubleHealthRegenRateLock', true ) );
	if ( myTPC.IsBonusActive( BONUS_DOUBLE_HEALTH_REGEN_RATE ) )
	{
		bonusLabel.SetDataStoreBinding("<Strings:TPGame.BonusCodesMain.Active>");
	}
	else if ( myTPC.IsBonusUnlocked( BONUS_DOUBLE_HEALTH_REGEN_RATE ) )
	{
		bonusLabel.SetDataStoreBinding("<Strings:TPGame.BonusCodesMain.Unlocked>");
	}

	
	// For the last three, they're either locked or active
	if ( myTPC.IsBonusUnlocked( BONUS_UNLOCK_ALL_LEVELS ) )
	{
		bonusLabel = UILabel( FindChild( 'AllLevelsLock', true ) );
		bonusLabel.SetDataStoreBinding("<Strings:TPGame.BonusCodesMain.Active>");
	}

	if ( myTPC.IsBonusUnlocked( BONUS_UNLOCK_ENV_ART ) )
	{
		bonusLabel = UILabel( FindChild( 'EnvArtLock', true ) );
		bonusLabel.SetDataStoreBinding("<Strings:TPGame.BonusCodesMain.Active>");
	}

	if ( myTPC.IsBonusUnlocked( BONUS_UNLOCK_CHAR_WEAP_ART ) )
	{
		bonusLabel = UILabel( FindChild( 'CharWeapArtLock', true ) );
		bonusLabel.SetDataStoreBinding("<Strings:TPGame.BonusCodesMain.Active>");
	}
}

