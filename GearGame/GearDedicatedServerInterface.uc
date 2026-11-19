/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class GearDedicatedServerInterface extends Object
	config(Engine)
	native(Online);

enum EServerStatus
{
	STATUS_LAUNCHING,			// Starting up
	STATUS_IDLE,				// Waiting for players to join
	STATUS_STARTINGMATCH,		// Starting match
	STATUS_RUNNING,				// In session with connected players
	STATUS_RESTARTING,			// Restarting the server
	STATUS_SHUTTINGDOWN,		// Responding to shutdown flag detection
	STATUS_FINISHEDSHUTDOWN		// Last status set by Gears on process exit if shutdown was clean
};

/** Class that does the actual work of contacting the master database */
var transient native pointer Connection{struct FDedicatedServerInterface};

/** Whether or not to create/use this interface */
var config bool bUseDedicatedServerInterface;

cpptext
{
	/** Overridden to properly cleanup memory allocations */
	virtual void BeginDestroy()
	{
		Super::BeginDestroy();
		ShutDown();
	}
};

/*
 *   Called to open a connection to the specified master database
 *	@return TRUE if successful, FALSE in error or bUseDedicatedServerInterface is FALSE
 */
native function bool Initialize();

/*
 *   Must be called to properly close connection to master database
 */
native function ShutDown();

/*
 *  Contact the master database to get the currently assigned server configuration
 *  based on current server allocations and load
 *  @param ServerSettings array of key,value string pairs meant to override GConfig settings
 *  @return TRUE on successful data retrieval and FALSE on any error (or bUseDedicatedServerInterface is FALSE)
 */
native function	bool GetServerSettings(out array<KeyValuePair> ServerSettings);

/* 
 *  Communicate the status of the dedicated server to the database
 * @param Status - current status of the dedicated server
 */
native function SetStatus(EServerStatus Status);

/**
 * @return TRUE if the server is being requested to shutdown
 */ 
native function bool ShouldShutdown();

defaultproperties
{
	
}
