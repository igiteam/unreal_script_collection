/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * UIWidget_MPLoadoutContro.uc
 * 
 * Supporting class for the MP loadout control in the pregame lobby.  Corresponds with the ActionScript class gears.controls.MPLoadOutControl / Single / Double
 */

class UIWidget_MPLoadoutControl extends GFxObject;

/** The player PRI associated with this loadout */
var private transient GearPRI               MyPRI;

/** The profile associated with this loadout */
var private transient GearProfileSettings   MyProfile;

/** TRUE if the player is selecting from COG characters, FALSE if they're selecting from Locust */
var bool bIsCogCharacter;

/** The cached versions of the primary and secondary weapon IDs, so we don't have to look them up all the time */
var transient   int     CachedPrimaryWeaponId, CachedSecondaryWeaponId;
var transient   int     CachedPrimarySkinId, CachedSecondarySkinId;

/** Callback prototype to define the callbacks for when characters and weapons change, so we can update the profile. */
private delegate SelectionUpdated(int NewId);

/**
 * Sets the profile associated with this loadout, and sets up callback delegates so that we can store out the profiles for the player as they change their settings
 * 
 * @param   NewProfile  Profile to associate with this loadout
 */
function SetProfile(GearPRI NewPRI, GearProfileSettings NewProfile)
{
	local GearGRI GRI;
	local GearGFxMoviePlayer MoviePlayer;

	MyPRI = NewPRI;
	MyProfile = NewProfile;

	MoviePlayer = GearGFxMoviePlayer(Outer);
	GRI = MoviePlayer.GetGRI();

	// Set up the button text fields to have their proper localized strings
	if( !MoviePlayer.IsWingmanGametype(GRI) )
	{
		SetString("CharSelectOpenButtonHtml", Localize("ControllerFont", "Controller_A", "GearGameUI"));
		SetString("CharSelectCloseButtonHtml", Localize("ControllerFont", "Controller_B", "GearGameUI"));
	}
	// If this is wingman, blank out the character selection, since we don't need it
	else
	{
		SetString("CharSelectOpenButtonHtml", " ");
		SetString("CharSelectCloseButtonHtml", " ");
	}
		
	SetString("PrimaryNextButtonHtml", Localize("ControllerFont", "Controller_RightTrigger", "GearGameUI"));
	SetString("PrimaryPrevButtonHtml", Localize("ControllerFont", "Controller_LeftTrigger", "GearGameUI"));

	SetString("SecondaryNextButtonHtml", Localize("ControllerFont", "Controller_RightBumper", "GearGameUI"));
	SetString("SecondaryPrevButtonHtml", Localize("ControllerFont", "Controller_LeftBumper", "GearGameUI"));

	// Cache the stored values for the preferred primary and secondary weapon
	CachedPrimaryWeaponId = MyProfile.GetPreferredPrimaryWeaponId();
	CachedSecondaryWeaponId = MyProfile.GetPreferredSecondaryWeaponId();

	// Cache the stored values for the preferred weapon skins
	CachedPrimarySkinId = MyProfile.GetProviderIndexForWeaponSkin(EWeaponClass(CachedPrimaryWeaponId));
	CachedSecondarySkinId = MyProfile.GetProviderIndexForWeaponSkin(EWeaponClass(CachedSecondaryWeaponId));

	// Set up the callbacks, since we have a legitimate profile
	SetPrimaryWeaponChangeCallback( Callback_OnPrimaryWeaponChange );
	SetSecondaryWeaponChangeCallback( Callback_OnSecondaryWeaponChange );
	SetPrimarySkinChangeCallback( Callback_OnPrimarySkinChange );
	SetSecondarySkinChangeCallback( Callback_OnSecondarySkinChange );
	SetCharacterChangeCallback( Callback_OnCharacterChange );
}

/**
 * Sets the focus mask of the widget such that only the controller with the id specified can actually focus on the widget
 * 
 * @param   ControllerId    The controller to allow focus for on this widget
 */
function EnableControllerFocusFor(int ControllerId)
{
	SetFloat("focusGroupMask", ControllerId);
}

/**
 * Locks control of the widget when the PGL has moved onto the starting match state
 */
function LockLoadout()
{
	// Set the button text fields to be blank
	SetString("CharSelectOpenButtonHtml", "");
	SetString("CharSelectCloseButtonHtml", "");
	
	SetString("PrimaryNextButtonHtml", "");
	SetString("PrimaryPrevButtonHtml", "");

	SetString("SecondaryNextButtonHtml", "");
	SetString("SecondaryPrevButtonHtml", "");
	
	ActionScript_LockLoadout();
}

/**
 * Whether or not we're currently in the character selection menu
 * 
 * @return TRUE if we're character selecting, FALSE otherwise
 */
function bool IsInCharacterLoadout()
{
	return GetBool("bDisplayingCharacterSelect");
}

/**
 * Whether or not the specified character is valid for the specified gametype
 * 
 * @param   Character   Character summary for the character to test for
 * @param   GameType    Game type to test character for
 * 
 * @return  TRUE if we can use this character, FALSE if not
 */
function bool IsCharacterValidForGameType(GearGameCharacterSummary Character, EGearMPTypes GameType)
{
	// In CTL, we can't select leader characters
	if( GameType == eGEARMP_CTL )
	{
		return !Character.bIsLeader;
	}

	return TRUE;
}

//==================================================================
// Widget Population
//==================================================================

/**
 * Sets the description text for the weapon slots, usually "1" and "2"
 * 
 * @param   NewPrimaryWeaponText    New description text for the primary weapon selector
 * @param   NewSecondaryWeaponText  New description text for the secondary weapon selelctor
 */
function SetWeaponSlotDescriptions(string NewPrimaryWeaponText, string NewSecondaryWeaponText)
{
	SetString("PrimaryWeaponSlotHtml", NewPrimaryWeaponText);
	SetString("SecondaryWeaponSlotHtml", NewSecondaryWeaponText);
}

/**
 * Sets up the option steppers that contains the weapon options for the primary and the secondary weapons
 * 
 * @param   WeaponSummaries             List of all the weapon summaries, from the data store.
 */
function SetWeaponData(const out array<GearGameWeaponSummary> WeaponSummaries)
{
	local GearGameWeaponSummary CurrentWeapon;
	local GFxObject PrimaryWeaponDP, SecondaryWeaponDP, WeaponObj, WeaponSelectorObj, SkinDataProvider;
	local int PrimaryWeaponLength, SecondaryWeaponLength;
	local int PrimaryWeaponIdx, SecondaryWeaponIdx;
	local int SelectedSkinIndex;

	// Create the data providers for the primary and secondary list
	PrimaryWeaponDP = CreateArray();
	SecondaryWeaponDP = CreateArray();

	PrimaryWeaponLength = 0;
	SecondaryWeaponLength = 0;

	PrimaryWeaponIdx = 0;
	SecondaryWeaponIdx = 0;

	// Iterate over the weapon summaries, and drop them into the appropriate data provider
	foreach WeaponSummaries(CurrentWeapon)
	{
		WeaponObj = CreateObject("Object");
		WeaponObj.SetFloat("WeaponId", CurrentWeapon.WeaponID);
		WeaponObj.SetString("WeaponName", Caps(CurrentWeapon.FriendlyName));
		WeaponObj.SetString("WeaponImageMarkup", "img://" $ CurrentWeapon.WeaponMenuIcon);  // This will be used if there is no skinned weapon image availabe

		// Grab skin information for this weapon, so we can cycle through
		CreateSkinDataProvider(EWeaponClass(CurrentWeapon.WeaponID), SkinDataProvider, SelectedSkinIndex);
		WeaponObj.SetObject("SkinDataProvider", SkinDataProvider);
		WeaponObj.SetFloat("SelectedSkinIndex", SelectedSkinIndex);

		// Add the weapon to either the primary or the secondary default weapon list, if appropriate
		if( CurrentWeapon.bIsDefaultPrimaryWeapon )
		{
			// If this weapon has the id of our selected primary weapon, update the selected index
			if( CachedPrimaryWeaponId == CurrentWeapon.WeaponID )
			{
				PrimaryWeaponIdx = PrimaryWeaponLength;
			}

			PrimaryWeaponDP.SetElementObject(PrimaryWeaponLength, WeaponObj);
			PrimaryWeaponLength++;
		}
		else if( CurrentWeapon.bIsDefaultSecondaryWeapon )
		{
			// If this weapon has the id of our selected secondary weapon, update the selected index
			if( CachedSecondaryWeaponId == CurrentWeapon.WeaponID )
			{
				SecondaryWeaponIdx = SecondaryWeaponLength;
			}

			SecondaryWeaponDP.SetElementObject(SecondaryWeaponLength, WeaponObj);
			SecondaryWeaponLength++;
		}
	}

	// Set the data providers to their weapon option steppers
	WeaponSelectorObj = GetObject("PrimaryWeaponSelect");
	WeaponSelectorObj.SetObject("dataProvider", PrimaryWeaponDP);
	WeaponSelectorObj.SetFloat("selectedIndex", PrimaryWeaponIdx);

	WeaponSelectorObj = GetObject("SecondaryWeaponSelect");
	WeaponSelectorObj.SetObject("dataProvider", SecondaryWeaponDP);
	WeaponSelectorObj.SetFloat("selectedIndex", SecondaryWeaponIdx);
}

/**
 * Sets up the weapon skin option steppers for the specified weapon
 * 
 * @param   CurrentWeaponClass  WeaponClass of the weapon to get skin data for
 * @param   OutSkinProvider     Out param that will contain the skin data provider object after completion
 * @param   SelectedIndex       Index into the above data provider of the player's currently selected skin
 */
function CreateSkinDataProvider(EWeaponClass CurrentWeaponClass, out GFxObject OutSkinProvider, out int SelectedIndex)
{
	local array<GearWeaponSkinProvider> Skins;
	local GearWeaponSkinProvider CurrentSkin;
	local GearAwardManager AwardManager;
	local bool bSkinIsUnlocked;
	local GFxObject SkinObj;
	local int SkinCount, CurrentSkinId;

	// Grab the current persistent skin id
	CurrentSkinId = MyProfile.GetProviderIndexForWeaponSkin(CurrentWeaponClass);
		
	// Grab all of the weapon skins, so we can iterate over and find which ones apply to our current weapon
	if( class'GearUIDataStore_GameResource'.static.GetWeaponSkinsForWeapon(CurrentWeaponClass, Skins) )
	{
		// Create a data provider for the skins
		OutSkinProvider = CreateArray();
		SkinCount = 0;

		// Cache off the award manager
		AwardManager = GearPC(MyPRI.Owner).AwardManager;

		foreach Skins(CurrentSkin)
		{
			// Determine if this skin is valid for this weapon
			if( CurrentSkin.WeaponClassType == CurrentWeaponClass )
			{
				// Determine if this skin has been unlocked
				bSkinIsUnlocked = (CurrentSkin.AwardName == '') || AwardManager.HasEarnedAwardByName(CurrentSkin.AwardName);

				// Skip locked skins and Epic only skins for people that aren't Epic employees
				if( bSkinIsUnlocked && (!CurrentSkin.bIsEpicOnly || (CurrentSkin.bIsEpicOnly && MyProfile.IsEpicDev())) )
				{
					// Create an entry for this skin
					SkinObj = CreateObject("Object");
					SkinObj.SetFloat("SkinId", CurrentSkin.WeaponSkinUniqueId);
					SkinObj.SetString("SkinImageMarkup", "img://" $ CurrentSkin.SkinnedWeaponImagePath);

					// Save the index of the skin if this is our selected index
					if( CurrentSkin.WeaponSkinUniqueId == CurrentSkinId )
					{
						SelectedIndex = SkinCount;
					}
					OutSkinProvider.SetElementObject(SkinCount, SkinObj);
					SkinCount++;    
				}
			}
		}
	}
}

/**
 * Sets up the data provider for the character selection tile list 
 * 
 * @param   Characters  List of character summaries which the player can choose from
 * @param   bIsCog      TRUE if the player is choosing from COG characters, FALSE if they're choosing from Locust
 * @param   TeamNum     Index of the team the player is on, used for Wingman only
 */
function SetCharacterData(const out array<GearGameCharacterSummary> Characters, bool bIsCog, int TeamNum)
{
	local GearGameCharacterSummary  CurrentCharacter;
	local GFxObject DataProvider, CharacterObj;
	local int CurrentIndex, CharacterProfileId, SelectedProfileId, ValueId;
	local OnlineGameSettings GameSettings;
	local GearAwardManager AwardManager;
	local EGearMPTypes GameType;
	local GearGRI GRI;

	// Cache off the award manager
	AwardManager = GearPC(MyPRI.Owner).AwardManager;

	// Cache the game settings, and the game type we're choosing a loadout for
	GameType = eGEARMP_MAX;
	GameSettings = class'GearGFxMoviePlayer'.static.GetCurrentGameSettings();
	if( GameSettings != None )
	{
		GameSettings.GetStringSettingValue(class'GearVersusGameSettings'.const.CONTEXT_VERSUSMODES, ValueId);
		GameType = EGearMPTypes(ValueId);
	}

	// Get the preferred characters
	bIsCogCharacter = bIsCog;

	// If this is a wingman match, pull the character selection out of the GRI
	GRI = GearGFxMoviePlayer(Outer).GetGRI();
	if( GearGFxMoviePlayer(Outer).IsWingmanGametype(GRI) )
	{
		SelectedProfileId = GRI.WingmanClassIndexes[TeamNum];
	}
	// Otherwise, just pull the character out of the profile settings
	else
	{
		SelectedProfileId = MyProfile.GetPreferredClassIndex( ( bIsCogCharacter ) ? 0 : 1  );
	}

	DataProvider = CreateArray();
	CurrentIndex = 0;	
	foreach Characters(CurrentCharacter)
	{
		// Check to see if this character is banned by this gametype, and skip if so
		if( !IsCharacterValidForGameType(CurrentCharacter, GameType) )
		{
			continue;
		}

		CharacterObj = CreateObject("Object");

		CharacterObj.SetString("CharName", Caps(CurrentCharacter.CharacterName));
		CharacterObj.SetString("Image", "img://" $ CurrentCharacter.CharacterPortraitSmall);
		CharacterObj.SetString("PortraitMarkup", "img://" $ CurrentCharacter.CharacterPortraitLarge);
		
		if( CurrentCharacter.AwardName != '' && !AwardManager.HasEarnedAwardByName(CurrentCharacter.AwardName) )
		{
			CharacterObj.SetBool("bIsLocked", TRUE);
		}

		// Set the ID (annoyingly defined separately in the COG / Locust classes
		if( bIsCog )
		{
			CharacterProfileId = COGCharacterSummary(CurrentCharacter).ProfileId;
		}
		else if( LocustCharacterSummary(CurrentCharacter) != None )
		{
			CharacterProfileId = LocustCharacterSummary(CurrentCharacter).ProfileId;
		}
		CharacterObj.SetFloat("Id", CharacterProfileId);

		// If the character we have selected matches the one we're on, update the SelectedIdx
		if( CharacterProfileId == SelectedProfileId )
		{			
			CharacterObj.SetBool("bIsSelectedChar", TRUE);
		}
		else 
		{
			CharacterObj.SetBool("bIsSelectedChar", FALSE);
		}

		DataProvider.SetElementObject(CurrentIndex, CharacterObj);
		CurrentIndex++;
	}

	// Set the data provider and the selected index on the character selection widget	
	ActionScript_SetCharDataProvider(DataProvider);	
}

//==================================================================
// Stub functions
//==================================================================
/**
 * Sets the dataProvider for the Character List using an ActionScript stub function defined in MPLoadOutControl
 * that updates the currently selected character.
 *
 * @param	CharacterDataProvider	Array with data for available characters to be displayed in the control.
 */
function ActionScript_SetCharDataProvider(GFxObject CharacterDataProvider)
{
	ActionScriptVoid("SetCharDataProvider");
}

/**
 * Stub function to call into ActionScript and lock the loadout control 
 */
function ActionScript_LockLoadout()
{
	ActionScriptVoid("LockLoadout");
}


//==================================================================
// Callback handling
//==================================================================

/**
 * Sets an ActionScript function hook so we can handle the player changing their primary weapon selection
 * 
 * @param   Callback    Function that will handle changing the primary weapon in the profile 
 */
function SetPrimaryWeaponChangeCallback(delegate<SelectionUpdated> Callback)
{
	ActionScriptSetFunction("Callback_OnPrimaryWeaponChange");
}

/**
 * Sets an ActionScript function hook so we can handle the player changing their secondary weapon selection
 * 
 * @param   Callback    Function that will handle changing the secondary weapon in the profile 
 */
function SetSecondaryWeaponChangeCallback(delegate<SelectionUpdated> Callback)
{
	ActionScriptSetFunction("Callback_OnSecondaryWeaponChange");
}

/**
 * Sets an ActionScript function hook so we can handle the player changing their primary weapon skin selection
 * 
 * @param   Callback    Function that will handle changing the primary weapon skin in the profile 
 */
function SetPrimarySkinChangeCallback(delegate<SelectionUpdated> Callback)
{
	ActionScriptSetFunction("Callback_OnPrimarySkinChange");
}


/**
 * Sets an ActionScript function hook so we can handle the player changing their secondary weapon skin selection
 * 
 * @param   Callback    Function that will handle changing the secondary weapon skin in the profile 
 */
function SetSecondarySkinChangeCallback(delegate<SelectionUpdated> Callback)
{
	ActionScriptSetFunction("Callback_OnSecondarySkinChange");
}

/**
 * Sets an ActionScript function hook so we can handle the player changing their character selection
 * 
 * @param   Callback    Function that will handle changing character selection in the profile 
 */
function SetCharacterChangeCallback(delegate<SelectionUpdated> Callback)
{
	ActionScriptSetFunction("Callback_OnCharacterChange");
}

//==================================================================
// Profile Updating
//==================================================================

/**
 * Updates the player's profile with their new choice for primary weapon
 * 
 * @param   NewWeaponId     Weapon ID of the primary weapon the player has selected 
 */
function Callback_OnPrimaryWeaponChange(int NewWeaponId)
{
	MyProfile.SetPreferredPrimaryWeaponId(NewWeaponId);

	CachedPrimaryWeaponId = NewWeaponId;

	MyPRI.ServerSetWeaponId(CachedPrimaryWeaponId, CachedSecondaryWeaponId);
	MyPRI.InitialPrimaryWeaponType = NewWeaponId;
}

/**
 * Updates the player's profile with their new choice for secondary weapon
 * 
 * @param   NewWeaponId     Weapon ID of the secondary weapon the player has selected 
 */
function Callback_OnSecondaryWeaponChange(int NewWeaponId)
{
	MyProfile.SetPreferredSecondaryWeaponId(NewWeaponId);
	
	CachedSecondaryWeaponId = NewWeaponId;

	MyPRI.ServerSetWeaponId(CachedPrimaryWeaponId, CachedSecondaryWeaponId);
	MyPRI.InitialSecondaryWeaponType = NewWeaponId;
}

/**
 * Updates the player's profile with their new choice for primary weapon skin
 * 
 * @param   NewWeaponSkinId     Weapon ID of the primary weapon skin the player has selected 
 */
function Callback_OnPrimarySkinChange(int NewWeaponSkinId)
{
	local EWeaponClass CurrentWeapon;

	CurrentWeapon = EWeaponClass(CachedPrimaryWeaponId);
	MyProfile.SetUniqueIdForWeaponSkin(CurrentWeapon, NewWeaponSkinId);
	CachedPrimarySkinId = NewWeaponSkinId;
}

/**
 * Updates the player's profile with their new choice for secondary weapon skin
 * 
 * @param   NewWeaponSkinId     Weapon ID of the secondary weapon skin the player has selected 
 */
function Callback_OnSecondarySkinChange(int NewWeaponSkinId)
{
	local EWeaponClass CurrentWeapon;

	CurrentWeapon = EWeaponClass(CachedSecondaryWeaponId);
	MyProfile.SetUniqueIdForWeaponSkin(CurrentWeapon, NewWeaponSkinId);
	CachedSecondarySkinId = NewWeaponSkinId;
}

/**
 * Updates the player's profile with their new choice for character
 * 
 * @param   NewCharacterId     Weapon ID of the primary weapon the player has selected 
 */
function Callback_OnCharacterChange(int NewCharacterId)
{
	// Special:  If thrashball cole is selected, play a "Woooo!" for Cliff
	if( NewCharacterId == CMPC_ColeThrashball )
	{
		GearGFxMoviePlayer(Outer).PlaySoundFromTheme('ColeSelected');
	}

	MyProfile.SetPreferredClassIndex((bIsCogCharacter ? 0 : 1), NewCharacterId);
}
