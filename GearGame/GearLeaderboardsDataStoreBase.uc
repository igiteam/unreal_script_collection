/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * This class holds the game modes and leaderboard time line filters
 */
class GearLeaderboardsDataStoreBase extends UIDataStore_OnlineStats
	native(UIPrivate);

`include(GearOnlineConstants.uci)

/** The class to load and instance */
var class<GearLeaderboardSettingsBase> LeaderboardSettingsClass;

/** The set of settings that are to be exposed to the UI for filtering the leaderboards */
var Settings LeaderboardSettings;

/** The data provider that will expose the leaderboard settings to the ui */
var UIDataProvider_Settings SettingsProvider;

cpptext
{
private:
// UIDataStore interface

	/**
	 * Loads and creates an instance of the registered filter object
	 */
	virtual void InitializeDataStore(void);

	/**
	 * Returns the stats read results as a collection and appends the filter provider
	 *
	 * @param OutFields	out value that receives the list of exposed properties
	 */
	virtual void GetSupportedDataFields(TArray<FUIDataProviderField>& OutFields)
	{
		Super::GetSupportedDataFields(OutFields);
		// Append our settings provider
		new(OutFields)FUIDataProviderField(FName(TEXT("Filters")),DATATYPE_Provider,SettingsProvider);
	}

	/**
	 * Returns the list element provider for the specified proprety name
	 *
	 * @param PropertyName the name of the property to look up
	 *
	 * @return pointer to the interface or null if the property name is invalid
	 */
	virtual TScriptInterface<IUIListElementProvider> ResolveListElementProvider(const FString& PropertyName)
	{
		// Make a copy because we potentially modify the string
		FString CompareName(PropertyName);
		FString ProviderName;
		// If there is an intervening provider name, snip it off
		if (ParseNextDataTag(CompareName,ProviderName) == FALSE)
		{
			CompareName = ProviderName;
		}
		// Check for the stats results
		if (FName(*CompareName) == StatsReadName)
		{
			return this;
		}
		// See if this is for one of our filters
		return SettingsProvider->ResolveListElementProvider(CompareName);
	}
}

/**
 * Gets the player's rank for the specified row in the StatsRead.Rows, if available
 * 
 * @param   RowIndex    Index into StatsRead.Rows to get the player's rank for
 * @return  A string containing the player's rank, or "--" if there was an error
 */
native function string GetPlayerRankForRow(int RowIndex);


/**
 * Gets the string for the stat value for the specified row and column in the StatsRead, if available
 * 
 * @param   RowIndex    Index into StatsRead.Rows to get the column value for
 * @param   ColumnIndex Index into the columns array of the StatsRead Row to get the value for
 * @return  A string containing the player's rank, or "--" if there was an error
 */
native function string GetColumnValueForRow(int RowIndex, int ColumnIndex);