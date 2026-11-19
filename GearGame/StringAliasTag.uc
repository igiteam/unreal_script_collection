/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class StringAliasTag extends TranslatorTag
	native(inherit)
	Config(UI);

// ======== From UIDataStore_StringAliasMap

const SABM_FIND_FIRST_BIND = -2;

/** Struct to store the field values and how they map to localized strings */
struct native MenuInputMapping
{
	/** the name of the input alias; i.e. Accept, Cancel, Conditional1, etc. */
	var name FieldName;

	/**
	 * Name of the platform type this mapping is associated with.  Valid values are PC, 360, and PS3.
	 */
	var name Set;

	/**
	 * The actual markup string corresponding to this alias's letter in [usually] a button font
	 */
	var string MappedText;
};

/** Array of input string mappings for use in the front end. */
var config array<MenuInputMapping> MenuInputMapArray;

/** collection of list element provider instances that are associated with each ElementProviderType */
var const private native transient Map_Mirror MenuInputSets{TMap<FName, TMap<FName, INT> >};

/** The index [into the Engine.GamePlayers array] for the player that this data store provides settings for. */
var const transient int PlayerIndex;


// ======== From GearUIDataStore_StringAliasBindingsMap

/** Struct to map localized text from [GameMappedStrings] to [ButtonFont] for non-PC platforms */
struct native ControllerMapping
{
	/** The key - which is a [GameMappedStrings] */
	var name KeyName;
	/** The XBox360 mapping */
	var String XBoxMapping;
};

struct native TagCacheElement
{
	var name KeyName;
	var String MappingString;
	var int FieldIndex;
};

/** The value of the input's bUsingGamepad value the last time this datastore was used - for clearing cache */
var transient bool bPreviousUsingGamepadValue;

/**
* Map of command names of the form GBA_ to the key bindings that should be drawn on screen
* since its heavy on string compares
*/
var	const	transient	native	Map_Mirror	CommandToBindNames{TMap<FName, FTagCacheElement>};

/** Array of mappings for localized text from [GameMappedStrings] to [ButtonFont] for non-PC platforms */
var config array<ControllerMapping> ControllerMapArray;

/**
 * Called by GetStringWithFieldName() to retreive the string using the input binding system.
 */
native virtual function int GetBoundStringWithFieldName( String FieldName, out String MappedString, optional out int StartIndex, optional out String BindString );

/*
* Given an input command of the form GBA_ return the mapped keybinding string
* Returns TRUE if it exists, FALSE otherwise
*/
native protected final function bool FindMappingInBoundKeyCache(string Command, out string MappingStr, out int FieldIndex);

/** Given a input command of the form GBA_ and its mapping store that in a lookup for future use */
native protected final function AddMappingToBoundKeyCache(string Command, string MappingStr, int FieldIndex);

/** Clear the command to input keybinding cache	*/
native final function ClearBoundKeyCache();


native function string Translate( String InOption );

/** Returns a pointer to the ULocalPlayer associated with this tag handler. */
native function LocalPlayer GetPlayerOwner() const;

native function Init(LocalPlayer InLocalPlayer);

/**
 * Attempts to find a mapping index given a field name.
 *
 * @param FieldName		Fieldname to search for.
 *
 * @return Returns the index of the mapping in the mapping array, otherwise INDEX_NONE if the mapping wasn't found.
 */
//native final function int FindMappingWithFieldName( optional String FieldName="", optional String SetName="" );

/**
 * Set MappedString to be the localized string using the FieldName as a key
 * Returns the index into the mapped string array of where it was found.
 */
native virtual function int GetStringWithFieldName( String FieldName, out String MappedString );

DefaultProperties
{
	Tag="StringAliasBinding"
}



