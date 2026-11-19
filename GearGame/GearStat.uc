/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearStat extends Object;
/** This class represents a single tracked statistic over several periods */

/** The name of this stat */
var name StatName;

/** Array of delegate functions to be called whenever this stat is modified */
var array< delegate<OnStatModified> > OnStatModifiedDelegates;

/** Stat data by period */
var array<int> StatDataByPeriod;

/** Where to find the stat in the persistent data. Only relevant for the Persistent period*/
var int PersistentDataID;

/** Delegate prototype for the function to be called when the stat is modified 
 *	@param NameOfStat The name of the stat that was modified
 */
delegate OnStatModified(name NameOfStat);

/** Delegate prototype for the function used to modify the stat 
 *	@param InitialValue The original value of this stat
 *	@param Amount The amount to change the InitialValue by. Its use varies based on the function.
 */
delegate int Modifier(int InitialValue, int Amount);

/** Modifier function - Adds the Amount to the preexisting InitialValue of the stat 
 *	@param InitialValue The original value of this stat
 *	@param Amount The amount to add to the InitialValue
 */
function int DeltaModifier(int InitialValue, int Amount)
{
	return InitialValue + Amount;	
}

/** Modifier function - Use the Amount, ignoring the InitialValue 
 *	@param InitialValue The original value of this stat
 *	@param Amount The amount to set the stat to
 */
function int SetModifier(int InitialValue, int Amount)
{
	return Amount;
}

/** Modifier function - Use the max of the existing amount and the new amount
 *	@param InitialValue The original value of this stat
 *	@param Amount The amount to set the stat to
 */
function int MaxModifier(int InitialValue, int Amount)
{
	return Max(InitialValue, Amount);
}

/** Called by the game code when something has caused this stat to change 
 *	@param Amount A value used to change the stat
 *	@param ModType The way in which the Amount will be used to change the stat
 */
function ModifyStat(int Amount, EStatModificationType ModType)
{
	local int PeriodIndex;
	local int DelegateIndex;
	local delegate<Modifier> ModifierFunc;
	local delegate<OnStatModified> StatModFunc;
	
	//Determine which modifier function to use
	switch (ModType)
	{
		case GEARSTATMODTYPE_Delta:
			ModifierFunc = DeltaModifier;
			break;
		case GEARSTATMODTYPE_Set:
			ModifierFunc = SetModifier;
			break;
		case GEARSTATMODTYPE_Maximum:
			ModifierFunc = MaxModifier;
			break;
		default:
			ModifierFunc = DeltaModifier;
			break;
	}
	
	//For every period...
	for (PeriodIndex = 0; PeriodIndex < StatDataByPeriod.Length; PeriodIndex++)
	{
		//Modify that periods data appropriately, then...
		StatDataByPeriod[PeriodIndex] = ModifierFunc(StatDataByPeriod[PeriodIndex], Amount);
	}
	
	//For every listener function...
	for (DelegateIndex = 0; DelegateIndex < OnStatModifiedDelegates.Length; DelegateIndex++)
	{
		//Call the function!
		StatModFunc = OnStatModifiedDelegates[DelegateIndex];
		StatModFunc(StatName);
	}
}

/** Returns the localized string of the name of this stat */
static function String GetNameString(Name LookupName)
{
	return Localize("StatNameStrings", String(LookupName), "GearAwards");
}

/** Returns the localized string of the description of this stat */
static function String GetDescString(Name LookupName)
{
	return Localize("StatDescStrings", String(LookupName), "GearAwards");
}
