/**
 * Base class for campaign related data providers
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearCampaignResourceProvider extends GearResourceDataProvider
	native(inherit)
	abstract;

/** Act number */
var config		int	        ActNum;

/** path name to the screenshot for this chapter */
var	config		string		ScreenshotPathName;

/** Friendly name for this chapter */
var	localized	string		DisplayName;

/** Localized display for showing chapter in a list */
var	localized	string		ListName;

/** short description of the chapter */
var	localized	string		Description;

/** the providers for the list of collectables contained in this chapter or act */
var	transient	array<GearCollectableDataProvider>		Collectables;

DefaultProperties
{

}
