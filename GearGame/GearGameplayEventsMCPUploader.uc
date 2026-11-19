/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Streams gameplay events recorded during a session to disk
 */
class GearGameplayEventsMCPUploader extends GameplayEventsReader
	native
	config(Game);

/** Header of the gameplay events file after filtering */
var GameplayEventsHeader MCPHeader;
/** The byte stream containing the MCP payload */
var init array<byte> DataPayload;
/** FArchive pointer to hold MCP payload */
var const native pointer MemoryArchive{FArchive};

/** Reference to the handlers that will be processing the data */
var GearGameStateObject GearGameState;
var GearGameplayEventsHandlerMCP StatsHandler;
var GearGameStatsAggregatorMCP AggregateHandler;

/** Maximum file size the readers will open */
var config int MaxFileSizeToUpload;
/** LOD to force if not -1 */
var config int ForceLODUpload;
/** Percentage chance buckets for LOD */
var config array<int> LODPercent;
/** Level of detail aggregator names to construct (num entries must match LODPercent) */
var config array<string> EventHandlerDetail;

/* 
 * Create the stats handlers to use when uploading data to MCP 
 * Does a die roll to determine the level of detail to upload to the server
 */
function Init()
{		
	local string LODClassName;
	local int DiceRoll, LODIdx;
	if (ForceLODUpload >= 0 && ForceLODUpload < LODPercent.length)
	{
	   LODClassName = EventHandlerDetail[ForceLODUpload];
	}
	else
	{
		DiceRoll = Rand(1000);
		for (LODIdx=0; LODIdx<LODPercent.length; LODIdx++)
		{
			if (DiceRoll <= LODPercent[LODIdx])
			{
				LODClassName = EventHandlerDetail[LODIdx];
				break;
			}
		}
	}

	`Log("GearGameplayEventsMCPUploader: ChooseDetailLevel using class:"@LODClassName);
	if (LODClassName != "")
	{
		GearGameState = new(self) class'GearGameStateObject';
		StatsHandler = new(self, LODClassName) class'GearGameplayEventsHandlerMCP';
		AggregateHandler = new(self) class'GearGameStatsAggregatorMCP';
	}
}

/** Read in the data previously written and upload it to MCP */
native function UploadGameplayStats(OnlineEventsInterfaceMcp MCPInterface, GameplayEventsWriter StatsWriter);

// Create the header information necessary for MCP
native protected function SerializeHeaderMCP();

// Create the footer information necessary for MCP
native protected function SerializeFooterMCP();

defaultproperties
{
}