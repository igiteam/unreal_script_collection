class OLTypes extends Object
	native
	abstract;

struct native StruggleConfig
{
	var() name InitIdleAnimEnemy;
	var() name EntryAnimPlayer;
	var() name EntryAnimEnemy;
	var() name CycleAnimPlayer;
	var() name CycleAnimEnemy;
	var() name ExitAnimPlayer;
	var() name ExitAnimEnemy;	
	var() name KilledAnimPlayer;
	var() name KillAnimEnemy;	
	var() float EntryPlayerBlendInTime;
	var() float ExitPlayerBlendOutTime;

	var() float CycleTime;
	var() bool bNoFail; // if set, cycle time is the minimum time, and struggle finishes upon succeeding
	var() float MinRate;
	var() float MaxRateStart;
	var() float MaxRateEnd;
	var() float SuccessPctForMinRate;
	var() float SuccessPctForMaxRate;

	var() array<AnimSet> HeroAnimSets;

	structdefaultproperties
	{
		CycleTime=3.0;
		MinRate=0.25;
		MaxRateStart=1.0;
		MaxRateEnd=3.0;
		SuccessPctForMinRate=0.5;
		SuccessPctForMaxRate=1.0;
		EntryPlayerBlendInTime=0.25;
		ExitPlayerBlendOutTime=0.25;
	}
};

struct native BlendSpaceNode
{
	var() name AnimName;
	var() vector2d Coords;

	structcpptext
	{
		FBlendSpaceNode(FName animName, const FVector2D& coords) { AnimName = animName; Coords = coords; }
	}
};

