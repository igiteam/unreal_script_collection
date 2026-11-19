/**
 * Game settings data store for Gears 2.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearUIDataStore_GameSettings extends UIDataStore_OnlineGameSettings;

/**
 * Sets the index into the list of game settings to use
 *
 * @param	ContextId	the context id of the game settings object to use.  Should be one of the
 *						CONTEXT_VERSUSMODES values.
 */
event SetCurrentByContextId(int ContextId)
{
	local int GameSettingsIndex, GameTypeValueId;
	local OnlineGameSettings GameSettings;

	for ( GameSettingsIndex = 0; GameSettingsIndex < GameSettingsCfgList.Length; GameSettingsIndex++ )
	{
		GameSettings = GameSettingsCfgList[GameSettingsIndex].GameSettings;
		if ( GameSettings != None )
		{
			if (GameSettings.GetStringSettingValue(class'GearGame'.const.CONTEXT_VERSUSMODES, GameTypeValueId)
			&&	ContextId == GameTypeValueId)
			{
				SetCurrentByIndex(GameSettingsIndex);
				return;
			}
		}
	}

	`log("No game settings objects found with a CONTEXT_VERSUSMODES value of" @ ContextId);
}

event OnlineGameSettings GetGameSettingsByContextId( int ContextId )
{
	local int GameSettingsIndex, GameTypeValueId;
	local OnlineGameSettings GameSettings, Result;

	for ( GameSettingsIndex = 0; GameSettingsIndex < GameSettingsCfgList.Length; GameSettingsIndex++ )
	{
		GameSettings = GameSettingsCfgList[GameSettingsIndex].GameSettings;
		if ( GameSettings != None )
		{
			if (GameSettings.GetStringSettingValue(class'GearGame'.const.CONTEXT_VERSUSMODES, GameTypeValueId)
			&&	ContextId == GameTypeValueId)
			{
				Result = GameSettings;
				break;
			}
		}
	}

	`log("No game settings objects found with a CONTEXT_VERSUSMODES value of" @ ContextId);
	return Result;
}

defaultproperties
{
	GameSettingsCfgList.Empty
	//Keep this list indexed by the eGEARMP enum
	GameSettingsCfgList(eGEARMP_Warzone)=(SettingsName="GameSettingsWarzone",GameSettingsClass=class'GearGame.GearWarzoneSettings')
	GameSettingsCfgList(eGEARMP_Execution)=(SettingsName="GameSettingsExecution",GameSettingsClass=class'GearGame.GearExecutionSettings')
	GameSettingsCfgList(eGEARMP_Horde)= (SettingsName="GameSettingsHorde",GameSettingsClass=class'GearGame.GearHordeSettings')
	GameSettingsCfgList(eGEARMP_Wingman)=(SettingsName="GameSettingsWingman",GameSettingsClass=class'GearGame.GearWingmanSettings')
	GameSettingsCfgList(eGEARMP_KOTH)=(SettingsName="GameSettingsKOTH",GameSettingsClass=class'GearGame.GearKOTHSettings')
	GameSettingsCfgList(eGEARMP_CTL)=(SettingsName="GameSettingsCTL",GameSettingsClass=class'GearGame.GearCTLSettings')
	GameSettingsCfgList(eGEARMP_Newbie)=(SettingsName="GameSettingsNewbie",GameSettingsClass=class'GearGame.GearNewbieSettings')
	GameSettingsCfgList(eGEARMP_Siege)=(SettingsName="GameSettingsSiege",GameSettingsClass=class'GearGame.GearSiegeSettings')
}
