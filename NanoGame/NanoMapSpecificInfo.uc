/**
 * This will hold all of our map specific data.
 *
 * examples:  AR light colors, ink cloud colors, weapon emissive light colors
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoMapSpecificInfo extends MapInfo
	editinlinenew
	hidecategories(object);

/** This points to an archetype which will hold all of the per map color values **/
var() NanoPerMapColorConfig ColorConfig;

/** Texture to use for map in this level */
var() Texture2D				MapTexture;

/** If this is set then it will be used in place of the MapTexture. **/
var transient Texture2D OverriddenAtRunTimeMapTexture;

/** If this is set then it will be used in place of the default anchors **/
var transient NanoMapAnchor OveriddenAtRunTime_MC_TopLeft_NW_MaxX_MinY;
var transient NanoMapAnchor OveriddenAtRunTime_MC_BottomRight_SE_MinX_MaxY;

/** What the scale of the new map is **/
var transient float OverriddenAtRunTimeMinimapToWorldScale;

/** Turn on super bloomyness */
var() bool					bBlowoutPP;

defaultproperties
{
}
