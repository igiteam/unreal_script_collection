class StateNegotiation_Over_Teleport extends CoreTask within StateNegotiation_Over;

var vector iDelta;
var float iTime;

// local
var float lNow;
var float lDeltaTime;

state main
{
begin:
	endon ('killanimscript');

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
}
