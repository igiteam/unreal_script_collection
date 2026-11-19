/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * This class is used to connect to a network beacon on a dedicated server
 * in order to request a reservation for their party with that host
 * and possibly configure the server for a given playlist
 */
class GearPlayerMatchDedicatedBeaconClient extends GearPlayerMatchBeaconClient
	dependson(GearPlayerMatchDedicatedBeaconHost)
	native(Online);


