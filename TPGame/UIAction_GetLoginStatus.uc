/**
 * This action determines whether the playerindex specified is logged in with live, without live, or not logged in at all.
 *
 * Copyright ? 2006 Epic Games, Inc. All Rights Reserved.
 */
class UIAction_GetLoginStatus extends UIAction
	native(Sequence);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/** Player to get online status for. */
var() int PlayerID;

/** @return Returns the player's current login status enum using the online subsystem. */
event ELoginStatus GetLoginStatus(int ControllerId)
{
	local ELoginStatus Result;
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;

	Result = LS_NotLoggedIn;

	// Figure out if we have an online subsystem registered
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		// Grab the player interface to verify the subsystem supports it
		PlayerInterface = OnlineSub.PlayerInterface;
		if (PlayerInterface != None)
		{
			// Get status
			Result = PlayerInterface.GetLoginStatus(ControllerId);
		}
	}

	return Result;
}

