/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/** Representation of a location that an objective will point to */
class GearObjectiveLocator extends KeyPoint
	native;


/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/** The name of the lookup variable for finding the localized text in the [OBJECTIVE LOCATOR NAMES] section of the level_objectives.int file */
var() string DisplayName;

/** The highest difficulty that this locator will be seen */
var() EDifficultyLevel DiffLevel;

/** Sprites to use so the LD can distinguish what the difficulty of the locator is in the editor */
var const array<Texture2D> EditorSprites;


/************************************************************************/
/* C++ functions                                                        */
/************************************************************************/
cpptext
{
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void PostLoad();
}


defaultproperties
{
	DiffLevel=DL_Insane

	EditorSprites(DL_Casual)=Texture2D'EngineResources_Gears.GameStatsIcons.stats_icons_obj_casual'
	EditorSprites(DL_Normal)=Texture2D'EngineResources_Gears.GameStatsIcons.stats_icons_obj_normal'
	EditorSprites(DL_Hardcore)=Texture2D'EngineResources_Gears.GameStatsIcons.stats_icons_obj_hardcore'
	EditorSprites(DL_Insane)=Texture2D'Warfare_HUD.HUD.UI_HUD_Leader'

	bNoDelete=TRUE
	Begin Object Name=Sprite
		Sprite=Texture2D'Warfare_HUD.HUD.UI_HUD_Leader'
	End Object
}
