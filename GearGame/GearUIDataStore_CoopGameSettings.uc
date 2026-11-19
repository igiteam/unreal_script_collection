/**
 * Game settings data store for Gears 2.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearUIDataStore_CoopGameSettings extends UIDataStore_OnlineGameSettings;

defaultproperties
{
	Tag=CoopOnlineGameSettings
	GameSettingsCfgList.Empty
	GameSettingsCfgList.Add((SettingsName="CoopGameSettings",GameSettingsClass=class'GearGame.GearCoopGameSettings'))
}
