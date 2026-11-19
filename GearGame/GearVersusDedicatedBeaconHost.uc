/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * This class is used on a dedicated server to create a network accessible 
 * beacon for responding to reservation requests for player matches. 
 * It's overloaded goal is to wait for the first playlist configuration request 
 * and block out all playlist configuration requests after a successful configuration
 * while waiting for others to fill all reservation slots
 */
class GearVersusDedicatedBeaconHost extends GearPartyBeaconHost;

defaultproperties
{
	//Allow people searching for same gametype configuration to join
	bAllowAdditionalConfigurationRequests=true
}