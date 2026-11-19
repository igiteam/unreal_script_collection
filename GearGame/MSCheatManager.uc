/**
 * MS Automation functions wrapped up in a CheatManager
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class MSCheatManager extends GearCheatManager within GearPC
	native;

/** A cached copy of the Outer GearPC to save a ton of casting work in native code */
var GearPC GPC;

/**
 * Send a debug notification message
 *
 * @param Msg - the notification message.
 */
native function MS_SendDebugMessage(string Msg);

/** Dump the sound cue list to the debug output */
native exec function MS_ExtractSoundCues();

/** Write the profile to the debug output */
native exec function MS_DumpProfile();

/**
 * Print the name of a profile setting to the debug output
 *
 * @param ProfileSettingId - the identifier of the desired profile setting
 */
native exec function MS_GetProfileSettingName(int ProfileSettingId);

/**
 * Print a list of the values of a profile setting to the debug output
 *
 * @param ProfileSettingId - the identifier of the desired profile setting
 */
native exec function MS_GetProfileSettingValueList(int ProfileSettingId);

/**
 * Print the name of a profile setting value to the debug output
 *
 * @param ProfileSettingId - the identifier of the desired profile setting
 */
native exec function MS_GetProfileSettingValueName(int ProfileSettingId);

/**
 * Set a profile setting's value using an integer
 *
 * @param ProfileSettingId - the identifier of the desired profile setting
 *
 * @param Value - the desired value of the profile setting
 */
native exec function MS_SetProfileSettingValueId(int ProfileSettingId,int Value);

/**
 * Set a profile setting's value using a string
 *
 * @param ProfileSettingId - the identifier of the desired profile setting
 *
 * @param Value - the desired value of the profile setting
 */
native exec function MS_SetProfileSettingValueByName(int ProfileSettingId, const out string NewValue);

/** Write information about the current cover the player is using to the debug output */
native exec final function MS_GetCoverInfo();

/** Write information about the current streaming levels to the debug output */
native exec final function MS_GetStreamingInfo( string levelStatus );

/**
 * Output the current player's location to the debug log.
 *
 * @param MessageGUID - the unique identifier for this message
 */
native exec function MS_GetPlayerLoc(int MessageGUID);

/**
 * Output the current player's rotation to the debug log.
 *
 * @param MessageGUID - the unique identifier for this message
 */
native exec function MS_GetPlayerRotation(int MessageGUID);

/**
 * Output the current camera rotation to the debug log.
 *
 * @param MessageGUID - the unique identifier for this message
 */
native exec function MS_GetCameraRotation(int MessageGUID);

`if(`notdefined(FINAL_RELEASE))

/** Cache the Outer as a GearPC variable so native code can save time writing out casts */
function InitCheatManager()
{
	GPC = Outer;
}

/**
 * Play a sound cue on all player controllers
 *
 * @param SoundClip - the name of the sound to be played
 *
 * @param MessageGUID - the unique identifier of the debug output message generated
 */
exec function MS_PlaySoundCue(string SoundClip, int MessageGUID = 0)
{
	local SoundCue ASound;
	local PlayerController PC;

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		if(SoundClip != "")
		{
			ASound = SoundCue(DynamicLoadObject(SoundClip,class'SoundCue'));
			if(ASound != None)
			{
				PC.Kismet_ClientPlaySound(ASound,PC.Pawn,1.0f,1.0f,1.0f,FALSE,FALSE);
				MS_SendDebugMessage("UNREAL!UDC!" $  string(Rand(500)) $  "|1|" $  string(MessageGUID) $  "|1");
			}
			else
			{
				MS_SendDebugMessage("UNREAL!UDC!" $  string(Rand(500)) $  "|1|" $  string(MessageGUID) $  "|0");
			}
		}

	}
}

/**
 * Write whether the player can run to cover to the debug output
 *
 * @param MessageGUID - the unique identifier of the debug output message generated
 */
exec function MS_CanRunToCover(int MessageGUID = 0)
{
	local bool bResult;
	local CovPosInfo CoverCanRunTo;
	local int NoCameraAutoAlign;

	bResult = CanRunToCover(CoverCanRunTo, NoCameraAutoAlign);


	if(bResult == TRUE)
	{
		MS_SendDebugMessage("UNREAL!UDC!" $  string(Rand(500)) $  "|1|" $  string(MessageGUID) $  "|1");
	}
	else
	{
		MS_SendDebugMessage("UNREAL!UDC!" $  string(Rand(500)) $  "|1|" $  string(MessageGUID) $  "|0");
	}
}

/**
 * Set the current player's rotation
 *
 * @param Yaw - the desired yaw of the new rotation
 *
 * @param Pitch - the desired pitch of the new rotation
 *
 * @param Roll - the desired roll of the new rotation
 *
 * @param MessageGUID - the unique identifier of the debug output message generated
 */
exec function MS_SetPlayerRotation(int Yaw, int Pitch, int Roll, int MessageGUID = 0)
{
	local vector SetLocation;
	local rotator SetNewRotation;
	GetPlayerViewPoint( SetLocation, SetNewRotation );
	SetNewRotation.Yaw = Yaw;
	// so passing in -1 for Pitch, Yaw, or Roll will leave the current value, otherwise update it with the new value
	if(Roll !=-1)
	{
		SetNewRotation.Roll = Roll;
	}
	if(Pitch !=-1)
	{
		SetNewRotation.Pitch = Pitch;
	}
	if (Yaw != -1)
	{
		SetNewRotation.Yaw = Yaw;
	}
	ClientSetRotation(SetNewRotation);
	MS_SendDebugMessage("UNREAL!UDC!" $  string(Rand(500)) $  "|1|" $  string(MessageGUID) $  "|1");
}

/** Force a profile write */
exec function MS_SaveProfile()
{
	SaveProfile( MS_OnProfileWriteComplete );
}

/**
 * Called when the forced profile write is complete
 *
 * @param LocalUserNum - the user index that had their profile written.
 *
 * @param bWasSuccessful - true if the write completed without error
 */
function MS_OnProfileWriteComplete(byte LocalUserNum, bool bWasSuccessful)
{
	ClearSaveProfileDelegate( MS_OnProfileWriteComplete );
	// Update the controller with the new settings
	UpdateLocalCacheOfProfileSettings();
	`log("<MS_OnProfileWriteComplete LocalUserNum = " $ LocalUserNum $ " WasSuccessful=" $ bWasSuccessful $ ">");
}

/** Make all current players enter god mode */
exec function MS_God()
{
	local PlayerController PC;

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		PC.CheatManager.God();
	}
}

/** Make all current players ghost */
exec function MS_Ghost()
{
	local PlayerController PC;

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		PC.CheatManager.Ghost();
	}
}

/** Make all current players walk */
exec function MS_Walk()
{
	local PlayerController PC;

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		PC.CheatManager.Walk();
	}
}

/** Make all current players fly */
exec function MS_Fly()
{
	local PlayerController PC;

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		PC.CheatManager.Fly();
	}
}

/** Give all current players all guns */
exec function MS_Loaded()
{
	local PlayerController PC;

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		GearCheatManager(PC.CheatManager).bMPCheats = true;
		PC.CheatManager.Loaded();
	}
}

/** Give all current players unlimited health */
exec function MS_UnlimitedHealth()
{
	local GearPC PC;

	foreach WorldInfo.AllControllers(class'GearPC', PC)
	{
		PC.UnlimitedHealth();
	}
}

/** Give all current players unlimited ammo */
exec function MS_UnlimitedAmmo()
{
	local PlayerController PC;

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		GearCheatManager(PC.CheatManager).bMPCheats = true;
		GearCheatManager(PC.CheatManager).UnlimitedAmmo();
	}
}

/** Give all current players unlimited clips */
exec function MS_UnlimitedClips()
{
	local PlayerController PC;

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		GearCheatManager(PC.CheatManager).bMPCheats = true;
		GearCheatManager(PC.CheatManager).UnlimitedClips();
	}
}

`endif

/**
 * Ends the match with the specified team as the winner
 *
 * @param WinningTeam the team that won the match
 */
exec function EndMatch(optional int WinningTeam)
{
	local GearGameMP_Base Game;
	
	Game = GearGameMP_Base(WorldInfo.Game);
	if (Game != None)
	{
		Game.GoalScore = 1;
		Game.HandleTeamWin(WinningTeam);
	}
}
