class shared_MoveToOriginOverTime extends CoreTask within animscripts_shared;

// parameter
var vector iOrigin;
//var float iTime;
//
//// output
//
//// local
//var vector lOffset;
//var vector lOffsetReduction;
//var int i;
//var float lDeltaTime;
//var float lTime;
//
//state main
//{
//Begin:
//	endon('killanimscript');
//	
//	if (distanceSquared(iOrigin, iOrigin) > 16*16*FInchSq && !mayMoveToPoint(iOrigin))
//		_return();
//	
//	KeepClaimedNodeInGoal = true;
//	
//	lOffset = origin - iOrigin;
//	// need fix
//	lOffset.z = 0;
//	
//	lFrames = int(iTime * 20);
//	lOffsetReduction = lOffset / iTime;
//	
//	lTime = 
//
//	for (i = 0; i < lFrames; i++)
//	{
//		lOffset -= lOffsetReduction;
//		teleport(iOrigin + lOffset);
//		wait (0.05);
//	}
//	
//	KeepClaimedNodeInGoal = false;
//}

var vector iDelta;
var float iTime;

// local
var float lNow;
var float lDeltaTime;

state main
{
begin:
	endon ('killanimscript');
	
	if (distanceSquared(iOrigin, iOrigin) > 16*16*FInchSq && !mayMoveToPoint(iOrigin))
		_return();
	
	KeepClaimedNodeInGoal = true;

	iDelta = iOrigin - origin;
	iDelta.z = 0;
	lNow = pawn.WorldInfo.TimeSeconds;
	iDelta /= iTime;

	while (iTime > 0)
	{
		wait (0);
		lDeltaTime = pawn.WorldInfo.TimeSeconds - lNow;
		lNow = pawn.WorldInfo.TimeSeconds;
		if ((iTime - lDeltaTime) < 0)
			lDeltaTime = iTime;
		iTime -= lDeltaTime;

		teleport(origin + iDelta * lDeltaTime);
	}

		
	KeepClaimedNodeInGoal = false;
}
