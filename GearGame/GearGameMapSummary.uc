/**
 * Gears2 specific version of UIMapSummary.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGameMapSummary extends UIMapSummary;

/** Map identifier for the maps that the game is shipping with */
var config EGearMapsShipped ShippedMapType;

/** The unique identifier for the DLC pack this map came from */
var config int DLCId;

/** The x-coordinate pixel offset for the image within the mask. */
var config int XOffset;

/** The y-coordinate pixel offset for the image within the mask. */
var config int YOffset;

DefaultProperties
{

}
