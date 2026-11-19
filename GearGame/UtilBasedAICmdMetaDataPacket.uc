/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
* this class represents transient information about utility function activated commands
* and allows for passing of data between command activations (e.g. save the last time this command activated so the util function
* can factor that into its evaluation)
*/
class UtilBasedAICmdMetaDataPacket extends Object;

/** last time (worldseconds) the command this metadata is storing info for was activated */
var float LastActivationTime;

/** number of times this command has activated */
var int   NumberOfActivations;

/** class of the command which this meta data is attached to */
var class<AICmd_Base_UtilitySelectedCmd> CommandClass; 