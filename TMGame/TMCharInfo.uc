/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 * This object is used as a store for all character profile information.
 */
class TMCharInfo extends Object
	native
	config(CharInfo);

/** information about AI abilities/personality (generally map directly to TMBot properties) */
struct native CustomAIData
{
	var float Tactics, StrafingAbility, Accuracy, Aggressiveness, CombatStyle, Jumpiness, ReactionTime;
	/** full path to class of bot's favorite weapon */
	var string FavoriteWeapon;

	structdefaultproperties
	{
		Aggressiveness=0.4
		CombatStyle=0.2
	}
};

/** Structure defining a pre-made character in the game. */
struct native CharacterInfo
{
	/** Short unique string . */
	var string CharID;

	/** This defines which 'set' of parts we are drawing from. */
	var string FamilyID;

	/** Friendly name for character. */
	var localized string CharName;

	/** Localized description of the character. */
	var localized string Description;

	/** Preview image markup for the character. */
	var string PreviewImageMarkup;

	/** Faction to which this character belongs (e.g. IronGuard). */
	var string Faction;

	/** AI personality */
	var CustomAIData AIData;

	/** any extra properties of this character (for mod use) */
	var string ExtraInfo;

	/** whether this character shows up in menus by default */
	var bool bLocked;

	/** If true, this character will never be used for a random character in a single player game */
	var bool bRestrictInSinglePlayer;

	// @TODO: VOICE PACK
};

/** Structure defining information about a particular faction (eg. Ironguard) */
struct native FactionInfo
{
	var string Faction;

	/** Preview image markup for the faction. */
	var string PreviewImageMarkup;

	/** Localized version of the faction name to display in the UI. */
	var localized string FriendlyName;

	/** Description of the faction. */
	var localized string Description;
};


/** Array of PLA complete character profiles, defined in TMCustomChar.ini file. */
var() config array<CharacterInfo>		PLACharacters;

/** Array of foreign army complete character profiles, defined in TMCustomChar.ini file. */
var() config array<CharacterInfo>		ForeignCharacters;


/** Array of top-level factions (eg Iron Guard). */
var() config array<FactionInfo>			Factions;

/** Array of info for each family (eg IRNM) */
var() array< class<TMFamilyInfo> >		Families;

var() config float LOD1DisplayFactor;
var() config float LOD2DisplayFactor;
var() config float LOD3DisplayFactor;

/** Structure defining setup for capturing character portrait bitmap. */
struct native CharPortraitSetup
{
	/** Name of bone to center view on. */
	var name	CenterOnBone;

	/** Translation of mesh (applied on top of CenterOnBone alignment. */
	var vector	MeshOffset;

	/** Rotation of mesh. */
	var rotator	MeshRot;

	/** FOV of camera. */
	var	float	CamFOV;

	/** Directional light rotation. */
	var rotator	DirLightRot;
	/** Directional light brightness. */
	var	float	DirLightBrightness;
	/** Directional light color. */
	var color	DirLightColor;

	/** Directional light rotation. */
	var rotator	DirLight2Rot;
	/** Directional light brightness. */
	var	float	DirLight2Brightness;
	/** Directional light color. */
	var color	DirLight2Color;

	/** Directional light rotation. */
	var rotator	DirLight3Rot;
	/** Directional light brightness. */
	var	float	DirLight3Brightness;
	/** Directional light color. */
	var color	DirLight3Color;

	/** Skylight brightness. */
	var float	SkyBrightness;

	/** Sky light color */
	var color	SkyColor;

	/** Sky lower brightness */
	var float	SkyLowerBrightness;

	/** Sky lower colour */
	var color	SkyLowerColor;

	/** Position of background mesh */
	var vector	PortraitBackgroundTranslation;

	/** Size of texture to render to */
	var int		TextureSize;
};

/** Array used to map between bits stored in profile and unlocked chars. */
var array<String>	UnlockableChars;

// Default portrait config to use
var() config CharPortraitSetup	PortraitSetup;

/** StaticMesh to use for background of portrait. */
var StaticMesh PortraitBackgroundMesh;

var const int MALE_ASSAULTER_ID;
var const int MALE_MACHINEGUN_ID;
var const int MALE_SNIPPER_ID;
var const int MALE_SHOTGUN_ID;
var const int FEMALE_ASSAULTER_ID;
var const int FEMALE_MACHINEGUN_ID;
var const int FEMALE_SNIPPER_ID;
var const int FEMALE_SHOTGUN_ID;
var const int COMMANDER_ID;
var const int PIRATE_ID;
var const int BIO_ID;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/** Given a faction and character ID, find the character that defines all its parts. */
static native final function CharacterInfo FindCharacter(string InFaction, string InCharID);

/** Find the info class for a particular family */
static native final function class<TMFamilyInfo> FindFamilyInfo(string InFamilyID);

/** Return a random family from the list of all families */
static final function string GetRandomCharClassName()
{
	local int Idx;

	Idx = Rand(default.Families.length - 1);

	return "TMGame." $ string( default.Families[Idx].name );
}

/**
 *	This loads all assets associated with a custom character family (based on ini file) and create a
 *	TMCharFamilyAssetStore which is used to keep refs to all the required assets.
 *	@param bBlocking	If true, game will block until all assets are loaded.
 *	@param bArms		Load package containing arm mesh for this family
 */
static native final function TMCharFamilyAssetStore LoadFamilyAssets(string InFamilyID, bool bBlocking, bool bArms);

