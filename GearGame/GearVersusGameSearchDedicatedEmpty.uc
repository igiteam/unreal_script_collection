/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Used to find empty dedicated servers to be configured for a user's requested playlist
 */
class GearVersusGameSearchDedicatedEmpty extends GearVersusGameSearchDedicated;

defaultproperties
{
	// Which server side query to execute
	Query=(ValueIndex=SESSION_MATCH_QUERY_DEDICATEDEMPTY)
}
