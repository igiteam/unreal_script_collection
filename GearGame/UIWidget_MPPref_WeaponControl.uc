/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * UIWidget_MPPref_WeaponControl.uc
 * Control for the player picking their primary and secondary weapons, as well as their skins
 */

class UIWidget_MPPref_WeaponControl extends GFxObject;

/** Cache of the profile for the player that this control corresponds to */
var private transient GearProfileSettings MyProfile;

/** Localized string containing the font HTML tag to use for the range / damage indicator dots.  Contains `DOTS`, which will be Repl()'d with the appropriate number of dots */
var localized string    DotFontString;

/** Character to use for the dots in the range / damage indicator */
var localized string    DotString;

/** Used to read whether a user has unlocked an award for a skin */
var transient GearAwardManager AwardManager;

/** Localized strings */
var localized string    SectionHeader;
var localized string    RangeHeader;
var localized string    DamageHeader;
var localized string    SkinHeader;

/**
 * Handles setting of localized strings for the title
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	switch(WidgetName)
	{
		case 'lbl_WeaponSectionHeader':
			Widget.SetString("htmlText", SectionHeader);
			break;
		case 'lbl_WeaponStatsTitleRange':
			Widget.SetString("htmlText", RangeHeader);
			break;
		case 'lbl_WeaponStatsTitleDamage':
			Widget.SetString("htmlText", DamageHeader);
			break;
		case 'lbl_SkinTitle':
			Widget.SetString("htmlText", SkinHeader);
			break;
		default:
			return FALSE;
	}
	
	return TRUE;
}

/**
 * Sets up the weapon preference widgets, based on the profile
 * 
 * @param   Profile     Profile for the player we're handing preferences for
 * @param AwardMan the award manager to check for unlocks
 */
function ConfigureWeaponPreferences( GearProfileSettings Profile, GearAwardManager AwardMan )
{
	local GearUIDataStore_GameResource GameResourceDS;
	local array<UIResourceDataProvider> WeaponList;

	// Cache the profile
	MyProfile = Profile;
	AwardManager = AwardMan;

	// Grab the game resource data store
	GameResourceDS = class'GearGFxMoviePlayer'.static.GetGameResourceDataStore();
	if ( GameResourceDS != None )
	{
		// Grab the list of weapons
		GameResourceDS.GetResourceProviders('Weapons', WeaponList);
		SetWeaponDataProviders(WeaponList);
	}
}

/**
 * Creates a data provider based on the weapon data providers passed in, and the player's profile
 * 
 * @param   WeaponProvider   Array of the available potential characters
 */
private function SetWeaponDataProviders(array<UIResourceDataProvider> WeaponProvider)
{
	local UIResourceDataProvider TmpDP;
	local GearGameWeaponSummary CurrentWeapon;
	local GFxObject PrimaryWeaponDP, SecondaryWeaponDP, TmpObject;
	local int PrimaryWeaponCnt, SecondaryWeaponCnt;
	local int PrimaryWeaponId, SecondaryWeaponId;

	// Determine the player's preferred loadout
	PrimaryWeaponId = MyProfile.GetPreferredPrimaryWeaponId();
	SecondaryWeaponId = MyProfile.GetPreferredSecondaryWeaponId();

	// Create the data providers for weapon selection
	PrimaryWeaponDP = CreateArray();
	SecondaryWeaponDP = CreateArray();

	// Iterate over the weapon list, inserting weapons into the primary or secondary arrays
	foreach WeaponProvider(TmpDP)
	{
		CurrentWeapon = GearGameWeaponSummary(TmpDP);

		TmpObject = CreateObject("Object");

		// Populate the element with the weapon information
		TmpObject.SetFloat("WeaponId", CurrentWeapon.WeaponID);
		TmpObject.SetString("WeaponName", Caps(CurrentWeapon.FriendlyName));
		TmpObject.SetString("WeaponImageMarkup", "img://" $ CurrentWeapon.WeaponMenuIcon);
		TmpObject.SetBool("bIsLocked", FALSE);

		// Set the weapon data
		TmpObject.SetString("Label2", GetDotIndicator(CurrentWeapon.Range));
		TmpObject.SetString("Label3", GetDotIndicator(CurrentWeapon.Damage));

		// Hook up weapon skins for this weapon
		TmpObject.SetObject("AvailableSkins", GetSkinDataProviderForWeapon(EWeaponClass(CurrentWeapon.WeaponID)));

		// Figure out where to add this weapon
		if( CurrentWeapon.bIsDefaultPrimaryWeapon )
		{
			// Check if this is the selected primary weapon
			TmpObject.SetBool("bIsSelectedWeapon", (CurrentWeapon.WeaponID == PrimaryWeaponId));

			// Add the weapon to the primary weapons DP
			PrimaryWeaponDP.SetElementObject(PrimaryWeaponCnt++, TmpObject);
		}
		else if( CurrentWeapon.bIsDefaultSecondaryWeapon )
		{
			// Check if this is the selected secondary weapon
			TmpObject.SetBool("bIsSelectedWeapon", (CurrentWeapon.WeaponID == SecondaryWeaponId));

			// Add the weapon to the secondary weapons DP
			SecondaryWeaponDP.SetElementObject(SecondaryWeaponCnt++, TmpObject);
		}
	}

	// Set the data providers
	ActionScript_SetPrimaryWeaponDataProvider(PrimaryWeaponDP);
	ActionScript_SetSecondaryWeaponDataProvider(SecondaryWeaponDP);
}

/**
 * Returns a data provider constructed with all the weapon skins available for a given weapon
 * 
 * @param   Weapon  Class of the weapon to construct the skin data provider for
 */
function GFxObject GetSkinDataProviderForWeapon( EWeaponClass Weapon )
{
	local array<GearWeaponSkinProvider> Skins;
	local GearWeaponSkinProvider CurrentSkin;
	local GFxObject SkinDP, SkinObj;
	local int SelectedSkin, i;
	local bool bIsLocked;

	// Figure out which skin we have selected for this weapon
	SelectedSkin = MyProfile.GetProviderIndexForWeaponSkin(Weapon);

	if( class'GearUIDataStore_GameResource'.static.GetWeaponSkinsForWeapon(Weapon, Skins) )
	{
		SkinDP = CreateArray();

		// Iterate over all skins returned from the data store, and add them to the array
		foreach Skins(CurrentSkin)
		{
			// Skip Epic only skins for people that aren't Epic employees
			if (!CurrentSkin.bIsEpicOnly ||
				(CurrentSkin.bIsEpicOnly && MyProfile.IsEpicDev()))
			{
				// Create a new entry in the data provider for the skin
				SkinObj = CreateObject("Object");

				// Set its properties
				SkinObj.SetFloat("SkinId", CurrentSkin.WeaponSkinUniqueId);
				SkinObj.SetString("SkinName", Caps(CurrentSkin.SkinName));
				SkinObj.SetString("IconMarkup", "img://" $ CurrentSkin.IconPath);
				// Figure out if this skin is unlocked or not
				bIsLocked = CurrentSkin.AwardName != '' && !AwardManager.HasEarnedAwardByName(CurrentSkin.AwardName);
				SkinObj.SetBool("bIsLocked", bIsLocked);

				// If there is no default skin selected, use the first in the data provider
				if( SelectedSkin == INDEX_NONE )
				{
					SelectedSkin = CurrentSkin.WeaponSkinUniqueId;
				}
				SkinObj.SetBool("bIsSelectedSkin", (CurrentSkin.WeaponSkinUniqueId == SelectedSkin));

				// Add the skin object to the data provider
				SkinDP.SetElementObject(i++, SkinObj);
			}
		}
	}

	return SkinDP;
}

/**
 * Returns a string with a specified number of dots
 * 
 * @param   NumDots Number of dots to make into a string
 * @return  Formatted string with the specified number of dots
 */
function string GetDotIndicator(byte NumDots)
{
	local string TmpString;

	// Create a string of dots
	while(NumDots > 0)
	{
		TmpString $= DotString;
		NumDots--;
	}

	// Add the dots to the formatting string
	return Repl(DotFontString, "`DOTS`", TmpString);
}

//====================================================
// ActionScript Stubs
//====================================================
private function ActionScript_SetPrimaryWeaponDataProvider(GFxObject WeaponDP)
{
	ActionScriptVoid("SetPrimaryWeaponDataProvider");
}

private function ActionScript_SetSecondaryWeaponDataProvider(GFxObject WeaponDP)
{
	ActionScriptVoid("SetSecondaryWeaponDataProvider");
}

defaultproperties
{
}