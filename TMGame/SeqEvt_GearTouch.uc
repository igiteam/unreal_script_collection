/**
*
* Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
*/

class SeqEvt_GearTouch extends SeqEvent_Touch
	native(TGSequence);

enum ETGPawnRoadieRunFilter
{
	RRF_None,
	RRF_IgnoreRoadieRunningTGPawns,
	RRF_IgnoreNotRoadieRunningTGPawns
};

enum EGearCoverFilterType
{
	GCF_None,
	GCF_IgnoreInCoverHunkeredDown,
	GCF_IgnoreAllInCover
};

var(Gears) ETGPawnRoadieRunFilter RoadieRunFilterType;
var(Gears) EGearCoverFilterType CoverStatusFilterType;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function CheckRoadieRunTouchActivate(Actor InOriginator,Actor InInstigator, bool bNewRoadieRuning)
{
	if(RoadieRunFilterType == RRF_IgnoreNotRoadieRunningTGPawns)
	{
		if( bNewRoadieRuning)
		{
			CheckTouchActivate(InOriginator,InInstigator);
		}
		else
		{
			CheckUnTouchActivate(InOriginator,InInstigator);
		}
		
	}
	else if(RoadieRunFilterType == RRF_IgnoreRoadieRunningTGPawns)
	{
		if( !bNewRoadieRuning)
		{
			CheckTouchActivate(InOriginator,InInstigator);
		}
		else
		{
			CheckUnTouchActivate(InOriginator,InInstigator);
		}

	}
}

function CheckCoverStatusTouchActivate(Actor InOriginator, Actor InInstigator, bool bInCover, bool bExposed)
{
	//`log(GetFuncName()@bInCover@bExposed@CoverStatusFilterType);
	if(CoverStatusFilterType == GCF_IgnoreInCoverHunkeredDown)
	{
		if(!bInCover || bExposed)
		{
			CheckTouchActivate(InOriginator,InInstigator);
		}
		else
		{
			CheckUnTouchActivate(InOriginator,InInstigator);
		}
	}
	else if(CoverStatusFilterType == GCF_IgnoreAllInCover)
	{
		if(!bInCover)
		{
			CheckTouchActivate(InOriginator,InInstigator);
		}
		else
		{
			CheckUnTouchActivate(InOriginator,InInstigator);
		}
	}
}
