/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * This class is used on a dedicated server to create a network accessible 
 * beacon for responding to reservation requests for player matches. 
 * It's primary goal is to wait for the first playlist configuration request 
 * and block out all others after a successful configuration.
 * It also handles all tracking of who has reserved space, how much space is 
 * available, and how many parties can reserve space.
 */
class GearPlayerMatchDedicatedBeaconHost extends GearPlayerMatchBeaconHost
	native(Online);