/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoTeamInfo_CTF extends NanoTeamInfo;

enum EFlagStatus
{
	FS_Home,
	FS_Carried,
	FS_Dropped,
};
var repnotify EFlagStatus FlagStatus;

replication
{
	if (Role == ROLE_Authority)
		FlagStatus;
}

simulated event ReplicatedEvent(Name VarName)
{
	if (VarName == nameof(FlagStatus))
	{
		SendFlagStatusMessage();
	}
	Super.ReplicatedEvent(VarName);
}

function UpdateFlagStatus(EFlagStatus NewFlagStatus)
{
	FlagStatus = NewFlagStatus;
	SendFlagStatusMessage();
}

function ScoreCapture()
{
	Score += 1000.f;
}

simulated function SendFlagStatusMessage()
{
	local PlayerController PC;
	foreach WorldInfo.AllControllers(class'PlayerController',PC)
	{
		if (PC.IsLocalPlayerController())
		{
			if (PC.GetTeamNum() == TeamIndex)
			{
				if (FlagStatus == FS_Home)
				{
					PC.ClientMessage("FLAG RETURNED TO HOME");
				}
				else if (FlagStatus == FS_Carried)
				{
					PC.ClientMessage("FLAG TAKEN");
				}
				else if (FlagStatus == FS_Dropped)
				{
					PC.ClientMessage("FLAG DROPPED");
				}
			}
			else
			{
				if (FlagStatus == FS_Home)
				{
					PC.ClientMessage("ENEMY FLAG RETURNED TO HOME");
				}
				else if (FlagStatus == FS_Carried)
				{
					PC.ClientMessage("ENEMY FLAG TAKEN");
				}
				else if (FlagStatus == FS_Dropped)
				{
					PC.ClientMessage("ENEMY FLAG DROPPED");
				}
			}
		}
	}
}
