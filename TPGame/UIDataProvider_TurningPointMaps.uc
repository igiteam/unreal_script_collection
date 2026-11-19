/**
 * Provides information about the static resources available for a particular gametype.
 *
 * Copyright 1998-2006 Epic Games, Inc. All Rights Reserved
 */
class UIDataProvider_TurningPointMaps extends UIDataProvider_TurningPointResource
	native
	PerObjectConfig
	Config(Game);

/** Actual map name to load */
var config string MapName;

/** Friendly displayable name to the player. */
var config localized string FriendlyName;

/** Localized description of the map */
var config localized string Description;

/** Markup text used to bind the map preview image */
var config string LevelPreviewImageMarkup;

/** Whether or not the chapter is currently unlocked. */
var transient bool bUnlocked;

var config string ChapterPointID;

/** Textures for act completed images. */
var	transient	Surface CompleteImage;

/**
 * @return Returns whether or not the map is enabled. Based on the unlocked flag.
 */
event bool IsProviderDisabled()
{
	return !bUnlocked;
}

