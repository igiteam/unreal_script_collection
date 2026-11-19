/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * UIWidget_MPGamePreview.uc
 * 
 * Supporting class for the MP Game Preview in the pregame lobby.  Corresponds with the ActionScript class gears.controls.MPGamePreview
 */

class UIWidget_MPGamePreview extends GFxObject;

/**
 * Sets the game description to display in the pregame lobby MP game summary
 * 
 * @param   GameDescription Game description for the selected game type and map.  Can contain HTML formatted text
 */
function SetGameInfo(string GameDescription)
{
	SetString("GameInfoHtml", GameDescription);
}

/**
 * Sets the map image to display behind the game description
 * 
 * @param   PathToMap   Path to the image of the map shot (i.e. MyPackage.MyGroup.MyTexture)
 */
function SetMapImage(string PathToMap)
{
	SetString("MapImageMarkup", "img://" $ PathToMap);
}

defaultproperties
{
}
