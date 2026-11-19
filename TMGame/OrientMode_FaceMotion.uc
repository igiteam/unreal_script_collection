class OrientMode_FaceMotion extends CoreTask within HodAI;

// parameter

// output

// local
var int lTime;
var float lDelta;

state main
{
Begin:
	endon ('death');
	endon ('orient_mode_changed');

	lTime = gettime();

	while (true)
	{
		wait (0);
		lDelta = (gettime() - lTime) / 1000.0;
		lTime = gettime();

		if (length(pawn.Velocity) > 0)
		{
			FaceMotion(lDelta);
		}
	}
}
