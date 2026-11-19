/**
 * This action checks to see if player 0's storage device is valid.
 *
 * Copyright ? 2006 Epic Games, Inc. All Rights Reserved.
 */
class UIAction_CheckStorageDevice extends UIAction
	native(inherit);

enum EDeviceValidErrorCode
{
	DVEC_Valid,
	DVEC_NoneSelected,
	DVEC_Invalid
};

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/** 
 * Checks to see if a device ID is still valid.
 *
 * @param DeviceID		Device ID to check to see is still valid.
 *
 * @return	TRUE if the device ID is still valid, FALSE otherwise.
 */
event bool CheckDeviceId(int DeviceID)
{
	local bool bResult;
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterfaceEx PlayerInterfaceEx;
	bResult = false;

	// Figure out if wehave an online subsystem registered
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		PlayerInterfaceEx = OnlineSub.PlayerInterfaceEx;

		if(PlayerInterfaceEx != none)
		{
			bResult = PlayerInterfaceEx.IsDeviceValid(DeviceID);
		}
	}

	return bResult;
}

