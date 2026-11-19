/**
 * Data provider for campaign chapters; DefaultGame.ini
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearCampaignChapterData extends GearCampaignResourceProvider
	native(inherit);

/** Chapter number */
var config int	ChapterNum;

/** the name of the map data provider associated with this chapter */
//var	config		string	MapProviderName;

/** Localized string for the time associated with this chapter, or blank for none */
var localized   string      ChapterTime;

/** Localized string for the location associated with this chapter, or blank for none */
var localized   string      ChapterLocation;

/** the name of the map associated with this chapter */
var	config		string		MapName;

/** Whether or not this chapter should always be unlocked */
var config      bool        IsAlwaysUnlocked;

/**
 * Initializes the list of providers for the collectables contained in the chapter associated with this provider.
 */
function InitializeCollectables()
{
	local GearUIDataStore_GameResource GameResourceDS;
	local array<UIResourceDataProvider> CollectableProviders;
	local GearCollectableDataProvider Provider;
	local int ProviderIdx;

	Collectables.Length = 0;

	GameResourceDS = class'GearUIManager'.static.GetGameResourceDataStore();
	GameResourceDS.GetResourceProviders('Collectables', CollectableProviders);
	for ( ProviderIdx = 0; ProviderIdx < CollectableProviders.Length; ProviderIdx++ )
	{
		Provider = GearCollectableDataProvider(CollectableProviders[ProviderIdx]);

		// if the collectable's chapter id matches this provider's value, add it to our list
		if ( Provider.ContainingChapterId == ChapterNum )
		{
			Collectables.AddItem(Provider);
		}
	}
}

/* === UIResourceDataProvider interface === */
/**
 * Provides the data provider with the chance to perform initialization, including preloading any content that will be needed by the provider.
 *
 * @param	bIsEditor	TRUE if the editor is running; FALSE if running in the game.
 */
event InitializeProvider( bool bIsEditor )
{
	Super.InitializeProvider(bIsEditor);

	InitializeCollectables();
}

DefaultProperties
{

}
