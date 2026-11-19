/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * UIWidget_MPCustomMap.uc
 * 
 * Supporting class for the custom map selector widget in the pregame lobby.  Corresponds with the ActionScript class gears.controls.MPCustomMapControl
 */

class UIWidget_MPCustomMap extends GFxObject;

/**
 * Called when the widget is initialized.  Should set up the controller button mappings 
 */
function Initialize()
{
	// Set the forward and back trigger widgets
	if( class'WorldInfo'.static.GetWorldInfo().GRI.Role == ROLE_Authority )
	{
		// If we're the host, then show the triggers
		SetString("NextButtonHtml", Localize("ControllerFont", "Controller_RightTrigger", "GearGameUI"));
		SetString("PrevButtonHtml", Localize("ControllerFont", "Controller_LeftTrigger", "GearGameUI"));
	}
	else
	{
		// If we're the clients, then show nothing
		SetString("NextButtonHtml", "");
		SetString("PrevButtonHtml", "");
	}	
}

/** 
 * Updates the displayed name and image for the map.  Used for custom host map selection
 * 
 * @param   MapName     Map name to display
 * @param   MapImage    Path to the map image to display
 */
function SetMapNameAndImage( string MapName, string MapImage )
{
	local ASValue ASVal;
	local array<ASValue> Args;
	
	ASVal.Type = AS_String;
	ASVal.s = Caps(MapName);    
	Args[0] = ASVal;
	ASVal.Type = AS_String;
	ASVal.s = "img://" $ MapImage;   
	Args[1] = ASVal;
	ASVal.Type = AS_Boolean;
	ASVal.b = true;
	Args[2] = ASVal;

	Invoke("OnChangeAnimate", Args);  
}

/** 
 * Populates the widget with the list of potential maps from the Pregame GRI  
 *  
 * @param   PregameGRI  GRI for the pregame game, which contains the map list
 */
function PopulateMapList( GearPregameGRI PregameGRI )
{
	local int i;
	local GFxObject DataProvider, CurrentObject;

	// Create a dataprovider array to push to ActionScript
	DataProvider = CreateArray();
	for( i = 0; i < PregameGRI.MapFileNames.Length; i++ )
	{
		// Add each element to the dataprovider
		CurrentObject = CreateObject("Object");
		CurrentObject.SetString("MapName", Caps(PregameGRI.LocMapNames[i]));
		CurrentObject.SetFloat("MapId", i);
		CurrentObject.SetString("MapImageMarkup", "img://" $ PregameGRI.MapScreenshotPaths[i]);

		DataProvider.SetElementObject(i, CurrentObject);
	}

	// Push the data provider to ActionScript
	SetObject("dataProvider", DataProvider);
	SetFloat("selectedIndex", 0);
}

defaultproperties
{
}
