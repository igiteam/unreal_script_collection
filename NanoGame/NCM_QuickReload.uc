/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NCM_QuickReload extends NanoChasisModifier;

struct QuickReloadDatum
{
	/** The percentage faster to reload */
	var() float PercentFasterReload;
};
var() config array<QuickReloadDatum> ModLevel;

/** Returns max number of pips available for this modifier */
static function int GetMaxModLevel()
{
    return default.ModLevel.Length-1;
}

/** Returns max number of pips available for this modifier for the UI */
static function int GetMaxModLevelUI()
{
	return default.ModLevel.Length;
}


/** Get how much faster of a reload this chasis affects */
static function float GetPercentFasterReload( int InModLevel )
{
	return default.ModLevel[InModLevel].PercentFasterReload;
}



defaultproperties
{
	WeaponsThisCanModify=(class'NanoWeap_MP7')
}