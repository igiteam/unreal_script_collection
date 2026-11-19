class OrientMode_FaceDefault extends CoreTask within HodAI;

// local
var int lTime;
var float lDelta;
var float lSpeed;

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

		lSpeed = length(pawn.Velocity);

		//if (alwaysRunForward)
		//{
		//	if (lSpeed > 0)
		//	{
		//		FaceMotion(lDelta);
		//	}
		//	else if (animscripts_utility.IsValidEnemy(enemy))
		//	{
		//		FaceEnemy(lDelta);
		//	}
		//}
		
		if (lSpeed > 0)
		{
			FaceMotion(lDelta);
		}
		//else if (animscripts_utility.IsValidEnemy(enemy))
		//{
		//	FaceEnemy(lDelta);
		//}
	}
}
