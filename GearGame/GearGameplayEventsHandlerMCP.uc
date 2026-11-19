/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Streams gameplay events recorded during a session to disk
 */
class GearGameplayEventsHandlerMCP extends GameplayEventsHandler
	native
	perobjectconfig
	config(Game);

/** FArchive pointer to hold MCP payload */
var const native pointer MemoryArchive{FArchive};

cpptext
{
	/** The function that does the actual handling of data (override with particular implementation) */
	virtual void HandleEvent(struct FGameEventHeader& GameEvent, class IGameEvent* GameEventData);
};

/** A chance to do something before the stream starts */
native event PreProcessStream();

/** A chance to do something after the stream ends */
native event PostProcessStream();

defaultproperties
{
}