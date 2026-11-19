/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * UIWidget_MPPref_CharacterControl.uc
 * Control for the player picking their preferred COG and Locust character
 */

class UIWidget_MPPref_CharacterControl extends GFxObject;

/** Cache of the profile for the player that this control corresponds to */
var private transient GearProfileSettings MyProfile;

/** Cache of the award manager for the player that this control corresponds to */
var private transient GearAwardManager MyAwardManager;

/** Localized strings for the header names */
var localized string    COGHeaderTitle;
var localized string    LocustHeaderTitle;
var localized string    SectionHeader;

/**
 * Handles setting of localized strings for the title
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	switch(WidgetName)
	{
		case 'lbl_CharacterSectionHeader':
			Widget.SetString("htmlText", SectionHeader);
			break;
		default:
			return FALSE;
	}
	
	return TRUE;
}

/**
 * Initialization function for this widget.  Uses provided profile to populate the character selection widget with characters available to the player
 * 
 * @param   Profile     Profile of the player who should be selecting their character
 */
function ConfigureCharacterPreferences(GearProfileSettings ProfileSettings, GearAwardManager AwardManager)
{
	local GearUIDataStore_GameResource GameResourceDS;
	local array<UIResourceDataProvider> TempData;
	local GFxObject CharacterDataProvider;

	// Cache the data
	MyProfile = ProfileSettings;
	MyAwardManager = AwardManager;

	// Set the titles for the character header types
	ActionScript_SetCogHeaderLabel(COGHeaderTitle);
	ActionScript_SetLocustHeaderLabel(LocustHeaderTitle);

	GameResourceDS = class'GearGFxMoviePlayer'.static.GetGameResourceDataStore();
	if( GameResourceDS != None )
	{
		// Grab all the COG characters, and populate the data store
		GameResourceDS.GetResourceProviders('COGs', TempData);
		CharacterDataProvider = CreateCharacterDataProvider( TempData, TRUE );
		ActionScript_SetCogCharDataProvider(CharacterDataProvider);

		// Grab all the Locust characters, and populate the data store
		GameResourceDS.GetResourceProviders('Locusts', TempData);
		CharacterDataProvider = CreateCharacterDataProvider( TempData, FALSE );
		ActionScript_SetLocustCharDataProvider(CharacterDataProvider);
	}

}

/**
 * Creates a data provider based on the character data providers passed in, and the player's profile
 * 
 * @param   CharacterProvider   Array of the available potential characters
 * @param   bIsCOG              TRUE if the provided array is of COG characters, FALSE if Locust
 * 
 * @return  A GFxObject with an array, which serves as a data provider for the character select
 */
private function GFxObject  CreateCharacterDataProvider(array<UIResourceDataProvider> CharacterProvider, bool bIsCOG)
{
	local GearGameCharacterSummary CurrentCharacter;
	local GFxObject CharacterDataStore, TmpObject;
	local int i, SelectedIndex, CharacterId;

	// Figure out what they already have selected
	SelectedIndex = MyProfile.GetPreferredClassIndex( bIsCOG ? 0 : 1);

	// Create a datastore to send over to ActionScript with all the character data
	CharacterDataStore = CreateArray();
	
	// Iterate over the character data, populating the array
	for( i = 0; i < CharacterProvider.Length; i++ )
	{
		CurrentCharacter = GearGameCharacterSummary(CharacterProvider[i]);

		if( CurrentCharacter != None )
		{
			TmpObject = CreateObject("Object");

			TmpObject.SetString("CharName", Caps(CurrentCharacter.CharacterName));
			TmpObject.SetString("CharInfo", CurrentCharacter.CharacterBio);
			TmpObject.SetString("IconMarkup", "img://" $ CurrentCharacter.CharacterPortraitSmall);
			TmpObject.SetString("PortraitMarkup", "img://" $ CurrentCharacter.CharacterPortraitLarge);
			TmpObject.SetBool("bIsSelectedChar", FALSE);
	
			// See if this character should be locked
			if( CurrentCharacter.AwardName != '' && !MyAwardManager.HasEarnedAwardByName(CurrentCharacter.AwardName) )
			{
				TmpObject.SetBool("bIsLocked", TRUE);
			}

			// Grab the character id, and see if this is the one the player has selected
			if( bIsCOG )
			{
				CharacterId = COGCharacterSummary(CurrentCharacter).ProfileId;
			}
			else
			{
				CharacterId = LocustCharacterSummary(CurrentCharacter).ProfileId;
			}
			TmpObject.SetFloat("CharId", CharacterId);
			TmpObject.SetBool("bIsSelectedChar", (CharacterId == SelectedIndex));

			// Add the element to the provider
			CharacterDataStore.SetElementObject(i, TmpObject);
		}
	}
	
	return CharacterDataStore;
}

//====================================================
// ActionScript Stubs
//====================================================
private function ActionScript_SetCogHeaderLabel(string NewHeader)
{
	ActionScriptVoid("SetCogHeaderLabel");
}

private function ActionScript_SetLocustHeaderLabel(string NewHeader)
{
	ActionScriptVoid("SetLocustHeaderLabel");
}

private function ActionScript_SetCogCharDataProvider(GFxObject CharacterDP)
{
	ActionScriptVoid("SetCogCharDataProvider");
}

private function ActionScript_SetLocustCharDataProvider(GFxObject CharacterDP)
{
	ActionScriptVoid("SetLocustCharDataProvider");
}

defaultproperties
{
}