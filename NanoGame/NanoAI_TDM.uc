/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoAI_TDM extends NanoAI
	native(AI);

cpptext
{
	virtual UBOOL IsPlayerOwner()
	{
		return TRUE;
	}
}


defaultproperties
{

}
