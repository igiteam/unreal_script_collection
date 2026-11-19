/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearHordeEnemyList extends Object
	config(Game)
	perobjectconfig
	native;

/** information on one enemy character that may be chosen to participate in a wave */
struct native EnemySpawnInfo
{
	/** enemy type to spawn - we use the AIFactory enum to take advantage of the convenient list there */
	var EAITypes EnemyType;
	/** whether this enemy is a boss; only one entry such flagged may be picked in a single wave */
	var bool bIsBoss;
	/** if true, the min/max wave settings ignore the shifting that occurs when the waves loop around back to 1 */
	var bool bAbsoluteWaveRange;
	/** class names of inventory to give the enemy - optional, overrides the default if specified (class name only - no package) */
	var array<name> InventoryOverrides;
	/** optional combat mood that should be applied to the AI */
	var ECombatMood CombatMood;
	/** players must have reached this wave before this enemy appears */
	var int MinWave;
	/** max wave this enemy type is allowed to spawn in, 0 for any wave */
	var int MaxWave;
	/** minimum amount of this enemy we should try to keep around (while wave points are available) */
	var int MinCount;
	/** maximum amount of this enemy we can have around at once */
	var int MaxCount;
	/** how many wave points this enemy costs */
	var int WaveCost;
};
var const config array<EnemySpawnInfo> EnemyList;
/** a group of enemies defined in EnemyList that may spawn as a group */
struct native EnemySquadInfo
{
	/** indices into the EnemyList */
	var array<int> EnemyIndices;
	/** minimum wave this squad may appear in - must be equal or larger than the highest of the enemies that are in the squad */
	var int MinWave;
	/** maximum wave this squad may appear in - must be equal or less than the lowest of the enemies that are in the squad */
	var int MaxWave;
	/** total cost of this squad. NOT FOR CONFIGURING */
	var int WaveCost;
};
var config array<EnemySquadInfo> EnemySquadList;

/** count of currently alive Pawns in each EnemyList slot */
var array<int> EnemyListAliveCount;

/** reference to objects required by this list to make sure they stay around as long as this object does */
var array<Object> RequiredObjects;

/** server only - initializes runtime info (squad requirements, etc) */
function Initialize()
{
	local int i, j;

	EnemyListAliveCount.length = EnemyList.length;
	for (i = 0; i < EnemySquadList.length; i++)
	{
		EnemySquadList[i].WaveCost = 0;
		for (j = 0; j < EnemySquadList[i].EnemyIndices.length; j++)
		{
			EnemySquadList[i].MinWave = Max(EnemySquadList[i].MinWave, EnemyList[EnemySquadList[i].EnemyIndices[j]].MinWave);
			if (EnemyList[EnemySquadList[i].EnemyIndices[j]].MaxWave > 0)
			{
				// initialize to impossibly high value if this is the first enemy with a max
				if (EnemySquadList[i].MaxWave == 0)
				{
					EnemySquadList[i].MaxWave = 999;
				}
				EnemySquadList[i].MaxWave = Min(EnemySquadList[i].MaxWave, EnemyList[EnemySquadList[i].EnemyIndices[j]].MaxWave);
			}
			EnemySquadList[i].WaveCost += EnemyList[EnemySquadList[i].EnemyIndices[j]].WaveCost;
		}
	}
}

/** loads the objects/packages required by this enemy set and triggers LoadComplete delegate when done */
native final function Load();

delegate LoadComplete(GearHordeEnemyList List);
