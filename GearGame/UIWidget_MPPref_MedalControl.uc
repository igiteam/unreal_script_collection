/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * UIWidget_MedalControl.uc
 * Control for the player picking their medal from a list of available medals
 */

class UIWidget_MPPref_MedalControl extends GFxObject;

/** Location of the "no medal" selection icon */
var string NoMedalIcon;

/** Cache of the profile for the player that this control corresponds to */
var private transient GearProfileSettings MyProfile;

/** Localized string for the section header */
var localized string    SectionHeader;

/**
 * Handles setting of localized strings for the title
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	switch(WidgetName)
	{
		case 'lbl_MedalSectionHeader':
			Widget.SetString("htmlText", SectionHeader);
			break;
		default:
			return FALSE;
	}
	
	return TRUE;
}

/**
 * Sets up the medal preference widgets, based on the profile
 * 
 * @param   Profile     Profile for the player we're handing preferences for
 */
function ConfigureMedalPreferences( GearProfileSettings Profile )
{
	// Cache the profile
	MyProfile = Profile;

	// Populate the medal selection widget
	SetMedalDataProvider();
}

/**
 * Creates a data provider based on the and the player's award manager and their profile preferences
 */
private function SetMedalDataProvider()
{
	local GFxObject MedalDP, TmpObject;
	local int MedalCnt, SelectedAwardIdx, i;
	local int AwardProgress, AwardProgressTotal;
	local name BestAwardName;
	local bool bShouldBeShown;
	local GearAwardManager AwardManager;
	local GearAward CurrentAward;

	AwardManager = GearGFxMoviePlayer(Outer).GetGearPC().AwardManager;
	SelectedAwardIdx = MyProfile.GetPreferredMedalIndex();

	if( AwardManager != None )
	{
		// Create a dataprovider to populate the medal list
		MedalDP = CreateArray();

		// Create a "no medal option"
		TmpObject = CreateObject("Object");
		TmpObject.SetFloat("MedalId", -1);
		TmpObject.SetString("MedalName", Caps(Localize("StatNameStrings", "Default", "GearAwards")));
		TmpObject.SetString("MedalDesc", Caps(Localize("AwardTitleStrings", "Default", "GearAwards")));
		TmpObject.SetString("MedalMarkup", "img://" $ NoMedalIcon);
		TmpObject.SetString("IconMarkup", "img://" $ NoMedalIcon);
		TmpObject.SetFloat("MedalRank", -1);
		TmpObject.SetBool("bIsSelectedMedal", (SelectedAwardIdx == -1));
		TmpObject.SetBool("bIsLocked", FALSE);
		TmpObject.SetFloat("ProgressCurrent", 0.f);
		TmpObject.SetFloat("ProgressTotal", 0.f);
		MedalDP.SetElementObject(MedalCnt++, TmpObject);

		// Iterate over the rest of the awards
		for(i = 0; i < AwardManager.MedalDisplayOrder.Length; i++)		
		{
			// Get the best award for the display order category
			BestAwardName = '';
			bShouldBeShown = AwardManager.GetBestMedalForPosition(i, BestAwardName);
			CurrentAward = AwardManager.GetAwardByName(BestAwardName);

			// We only care about medals
			if( CurrentAward != None )
			{
				TmpObject = CreateObject("Object");

				// Populate the data for this award
				TmpObject.SetFloat("MedalId", CurrentAward.PersistentDataID);
				TmpObject.SetString("MedalName", Caps(CurrentAward.GetNameString(CurrentAward.AwardName)));
				TmpObject.SetString("MedalDesc", Caps(CurrentAward.GetTitleString(CurrentAward.AwardName)));
				TmpObject.SetString("MedalMarkup", "img://" $ CurrentAward.IconPath);
				TmpObject.SetString("IconMarkup", "img://" $ CurrentAward.IconPath);
				TmpObject.SetFloat("MedalRank", CurrentAward.MedalRank);
				TmpObject.SetBool("bIsSelectedMedal", (AwardManager.GetAwardIndex(CurrentAward) == SelectedAwardIdx));
				TmpObject.SetBool("bIsLocked", !bShouldBeShown);

				// If progress is defined for this award, then tell the data provider
				AwardManager.GetProgressTowardsNextLevel(i, AwardProgress, AwardProgressTotal);
				TmpObject.SetFloat("ProgressCurrent", AwardProgress);
				TmpObject.SetFloat("ProgressTotal", AwardProgressTotal);

				// Add the medal to the data provider
				MedalDP.SetElementObject(MedalCnt++, TmpObject);
			}
		}

		// Set the data provider to populate the widget
		ActionScript_SetMedalDataProvider(MedalDP);
	}
}

//====================================================
// ActionScript Stubs
//====================================================
private function ActionScript_SetMedalDataProvider(GFxObject MedalDP)
{
	ActionScriptVoid("SetMedalDataProvider");
}

defaultproperties
{
	NoMedalIcon="UI_Medals.T_Medals_Default"
}