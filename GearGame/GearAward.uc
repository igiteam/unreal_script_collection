/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAward extends Object;
/** This class represents a single award */

/** Name of the award */
var name AwardName;

/** Where to find this award in the persistent data */
var int PersistentDataID;

/** If you can earn the award multiple times, and how you do so. */
var EAwardRepeatType RepeatType;

/** Location of the picture to show */
var string  IconPath;

/** Rank of the medal, which determines how many stars / which crest the image has (-1 no rank, 0: bronze, 1: silver, 2: gold, 3:epic/max */
var int     MedalRank;

/** Name of the sound event to play when the alert for this award comes out*/
var string EarnedSoundEvent;
var string ProgressSoundEvent;

/** The type of the award */
var EAwardType AwardType;

/** The amount of exp given for earning this award, if any */
var int ExpBonus;

/** The amount of progress messages to show, if any */
var EAwardProgressType ProgressType;

/** Variable used in conjunction with the ProgressType */
var int ProgressArg;

/** The amount to subtract from this award's progress (as it would overlap with a previous, lesser award) */
var int ProgressMinimum;

/** How far along we are towards earning this award */
var int ProgressNumerator;
var int ProgressDenominator;

/**How we should represent the progress */
var EProgressRepresentation ProgressRepresentation;

/** A specific relevant stat */
struct SpecificStat
{
	/** The stat's identifier */
	var name StatName;
	/** The period of the stat */
	var ERecordingPeriodType StatPeriod;
	/**
		Stat Comparison Value
		  1      >        3
	 */
	/** How to compare the stat to the value */
	var EComparisonType Comparison;
	/** The value to compare the stat to */
	var int Value;
	/** The stat itself */
	var GearStat Stat;
};

/** What stats are relevant to the earning of this award*/
var array<SpecificStat> StatsToMonitor;

/** The stat object associated to this Award (where the number of times this award was earned is kept) */
var GearStat AssociatedStat;


function bool CanGiveAward()
{
	//If the award is not repeatable and you already have one, don't even bother.
	if ((RepeatType == GEARAWARDREPEAT_None && AssociatedStat.StatDataByPeriod[GEARPERIOD_Persistent] > 0)  ||
		(RepeatType == GEARAWARDREPEAT_OncePerGame && AssociatedStat.StatDataByPeriod[GEARPERIOD_Game] > 0) ||
		(RepeatType == GEARAWARDREPEAT_OncePerRound && AssociatedStat.StatDataByPeriod[GEARPERIOD_Round] > 0))
	{
		return false;
	}

	return true;
}

/** 
 *  Function called when a stat this award is subscribed to has been modified
 *	@param StatName The name of the stat modified
 */
//@todo Actually care about StatName and optimize to not check all stats. 
//IE check the stat that changed first, and only check the others if the new one passes. Probably not worth it though unless we start having awards with LOTS of dependant stats.
function OnStatModified(name StatName)
{
	local int StatIndex;
	local SpecificStat CurrentStat;
	local bool ConditionsMet;
	local int StatVal;
	local int NumAwards;
	local int CompareValue;
	local int OldNumerator;
	local bool bWantsProgressAlert;

	if (!CanGiveAward())
	{
		return;
	}

	ConditionsMet = True;
	for(StatIndex = 0; StatIndex < StatsToMonitor.Length; StatIndex++)
	{
		CurrentStat = StatsToMonitor[StatIndex];
		StatVal = CurrentStat.Stat.StatDataByPeriod[CurrentStat.StatPeriod];
		NumAwards = AssociatedStat.StatDataByPeriod[CurrentStat.StatPeriod];
		CompareValue = CurrentStat.Value;
		//If this is one of the multiplying repeat types, compute the next value necessary to win an award
		switch (RepeatType)
		{
			case GEARAWARDREPEAT_Multiple:
				CompareValue = CompareValue*(1+NumAwards);
				break;
			case GEARAWARDREPEAT_Double:
				CompareValue = CompareValue* ((2**(NumAwards+1))-1);
				break;
		}
		//Do the appropriate compare of the value vs the current stat
		switch (CurrentStat.Comparison)
		{
			case GEARCOMPARE_Equal:
				if (!(StatVal == CompareValue))
				{
					ConditionsMet = False;
				}
				break;
			case GEARCOMPARE_NotEqual:
				if (!(StatVal != CompareValue))
				{
					ConditionsMet = False;
				}
				break;
			case GEARCOMPARE_LessThan:
				if (!(StatVal < CompareValue))
				{
					ConditionsMet = False;
				}
				break;
			case GEARCOMPARE_LessThanEqual:
				if (!(StatVal <= CompareValue))
				{
					ConditionsMet = False;
				}
				break;
			case GEARCOMPARE_GreaterThan:
				if (!(StatVal > CompareValue))
				{
					ConditionsMet = False;
				}
				break;
			case GEARCOMPARE_GreaterThanEqual:
				if (!(StatVal >= CompareValue))
				{
					ConditionsMet = False;
				}
				break;
			default:
				`Log("Invalid comparison type for stat "$ CurrentStat.StatName $" in award "$ AwardName);
		}
		if (!ConditionsMet)
		{
			break;
		}
	}
	if (ConditionsMet)
	{
		GearAwardManager(Outer).AwardEarned(self);
		//No point in seeing if the award was won more than once for the None type, and the Unlimited type would just go into an infinite loop
		if (RepeatType != GEARAWARDREPEAT_None && RepeatType != GEARAWARDREPEAT_OncePerGame && RepeatType != GEARAWARDREPEAT_OncePerRound && RepeatType != GEARAWARDREPEAT_Unlimited)
		{
			OnStatModified(StatName);
		}
	}

	//Now let's see if we need to show a progress message
	OldNumerator = ProgressNumerator;
	ComputeProgress();
	/* If we care about progress and
	 * this award is not a ribbon and
	 * we do not already have the award and
	 * we have passed the minimum (so not to show gold progress while working on silver, etc)
	 * we have actually made progress
	 * check to see if we want to show a progress message */
	if (ProgressType != GEARAWARDPROGRESS_None &&
		AwardType != GEARAWARDTYPE_Ribbon &&
		ProgressNumerator < ProgressDenominator && 
		ProgressNumerator - ProgressMinimum > 0 &&
		ProgressNumerator > OldNumerator)
	{
		switch (ProgressType)
		{
			case GEARAWARDPROGRESS_Always:
				bWantsProgressAlert = true;
				break;
			case GEARAWARDPROGRESS_Percentage:
				if ( int( (100*(float(ProgressNumerator-ProgressMinimum)/float(ProgressDenominator-ProgressMinimum)))/ ProgressArg) > int((100*(float(OldNumerator-ProgressMinimum)/float(ProgressDenominator-ProgressMinimum)))/ ProgressArg) )
				{
					bWantsProgressAlert = true;
				}
				break;
			case GEARAWARDPROGRESS_Constant:
				if ( (ProgressNumerator-ProgressMinimum)/ ProgressArg > (OldNumerator-ProgressMinimum)/ ProgressArg)
				{
					bWantsProgressAlert = true;
				}
				break;
			case GEARAWARDPROGRESS_None:
			default:
				break;
		}
		if (bWantsProgressAlert)
		{
			GearAwardManager(Outer).PC.GetAlertManager().Alert(eALERT_Medal,GetNameString(AwardName), 
					GetDescString(AwardName), "" ,ProgressNumerator -ProgressMinimum , ProgressDenominator - ProgressMinimum, ProgressRepresentation,
					IconPath,MedalRank, ProgressSoundEvent);
		}
	}
};

/**
 * Function to get the progress towards earning this award
 * 
 * @param Numerator - out parameter that will be filled by the amount of steps completed towards earning the award
 * @param Denominator - out parameter that will be filled by the amount of steps needed towards earning the award
 * @param bSubtractProgressMin - Whether or not we should subtract the ProgressMinimum from the results
 * 
 * @return The amount of times this award has been earned so far
 */
function int GetProgress(out int Numerator, out int Denominator, optional bool bSubtractProgressMin)
{
	Numerator = ProgressNumerator;
	Denominator = ProgressDenominator;

	if (bSubtractProgressMin)
	{
		Numerator -= ProgressMinimum;
		Denominator -= ProgressMinimum;
	}

	return AssociatedStat.StatDataByPeriod[GEARPERIOD_Persistent];
}


function ComputeProgress()
{
	local int StatIndex;
	local int TempNumerator,TempDenominator;
	local int NewNumerator, NewDenominator;

	for(StatIndex = 0; StatIndex < StatsToMonitor.Length; StatIndex++)
	{
		GetStatProgress(StatIndex, TempNumerator, TempDenominator);
		NewNumerator += TempNumerator;
		NewDenominator += TempDenominator;
	}

	ProgressNumerator = NewNumerator;
	ProgressDenominator = NewDenominator;
}

/**
 * Function to get the progress towards the completion of a single stat that this award requires
 *
 * @param StatIndex - the index in the StatsToMonitor list of the stat we are inquiring about
 * @param Numerator - out parameter that will be filled by the amount of steps completed towards completing a stat of this award
 * @param Denominator - out parameter that will be filled by the amount of steps needed towards completing a stat of this award
 * @param bIgnoreRepeat - whether we only want the progress of the very first completion of this stat
 * 
 * @return whether the stat has ever been completed or not
 */
function bool GetStatProgress(int StatIndex, out int Numerator, out int Denominator, optional bool bIgnoreRepeat)
{
	local SpecificStat CurrentStat;
	local int StatVal;
	local int NumAwards;
	local int CompareValue;
	
	Numerator = 0;
	Denominator = 0;

	if (StatIndex >= 0 && StatIndex < StatsToMonitor.Length)
	{
		CurrentStat = StatsToMonitor[StatIndex];
		StatVal = CurrentStat.Stat.StatDataByPeriod[CurrentStat.StatPeriod];
		NumAwards = AssociatedStat.StatDataByPeriod[CurrentStat.StatPeriod];
		CompareValue = CurrentStat.Value;

		// If we are ignoring repeat and we've completed this stat at least once, we can bail early
		if (bIgnoreRepeat && NumAwards > 0)
		{
			Denominator = CompareValue;
			Numerator = Denominator;
			return true;
		}

		// See if we need to ignore repeating (used for knowing if this stat has EVER been completed)
		if (!bIgnoreRepeat)
		{
			//If this is one of the multiplying repeat types, compute the next value necessary to win an award
			switch (RepeatType)
			{
				case GEARAWARDREPEAT_Multiple:
					CompareValue = CompareValue*(1+NumAwards);
					if (NumAwards != 0)
					{
						Numerator = -CurrentStat.Value*(1+(NumAwards-1));
						Denominator = -CurrentStat.Value*(1+(NumAwards-1));
					}
					break;
				case GEARAWARDREPEAT_Double:
					CompareValue = CompareValue* ((2**(NumAwards+1))-1);
					if (NumAwards != 0)
					{
						Numerator = -CurrentStat.Value*((2**NumAwards)-1);
						Denominator = -CurrentStat.Value*((2**NumAwards)-1);
					}
					break;
			}
		}

		//Do the appropriate compare of the value vs the current stat
		switch (CurrentStat.Comparison)
		{
			//==, >=, and > will be dealt with normally
			case GEARCOMPARE_Equal:
			case GEARCOMPARE_GreaterThanEqual:
				Numerator +=  Min(StatVal, CompareValue);
				Denominator += CompareValue;
				break;
			case GEARCOMPARE_GreaterThan:
				Numerator += Min(StatVal, CompareValue+1);
				Denominator += CompareValue+1;
				break;

			//< and <= are strange, so they will be dealt with as each stat being its own value
			case GEARCOMPARE_NotEqual:
				if (!(StatVal != CompareValue))
				{
					Numerator++;
				}
				Denominator++;
				break;
			case GEARCOMPARE_LessThan:
				if (!(StatVal < CompareValue))
				{
					Numerator++;
				}
				Denominator++;
				break;
			case GEARCOMPARE_LessThanEqual:
				if (!(StatVal <= CompareValue))
				{
					Numerator++;
				}
				Denominator++;
				break;
			
			default:
				`Log("Invalid comparison type for stat "$ CurrentStat.StatName $" in award "$ AwardName);
		}
	}

	return (Numerator >= Denominator);
}

/**
 * Returns the number of times this award has been earned
 *
 * @param PeriodType - the time period we want to know the number of times they earned the award for
 */
function int GetNumTimesEarned(optional ERecordingPeriodType PeriodType=GEARPERIOD_Persistent)
{
	return AssociatedStat.StatDataByPeriod[PeriodType];
}

/** Returns the localized string that represents the title you received from this award */
static function String GetTitleString(Name LookupName)
{
	return Localize("AwardTitleStrings", String(LookupName), "GearAwards");
}

/** Returns the localized string of the name of this award */
static function String GetNameString(Name LookupName)
{
	return Localize("StatNameStrings", String(LookupName), "GearAwards");
}

/** Returns the localized string of the description of this award */
static function String GetDescString(Name LookupName)
{
	return Localize("StatDescStrings", String(LookupName), "GearAwards");
}

/** Returns the localized string of the long version of the description of this award */
static function String GetLongDescString(Name LookupName)
{
	return Localize("StatLongDescStrings", String(LookupName), "GearAwards");
}

defaultproperties
{
	IconPath="UI_Awards.UI_Medal"
	ProgressSoundEvent="Alert_SquarePopUp_Progress"
}
