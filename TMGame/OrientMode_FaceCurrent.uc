class OrientMode_FaceCurrent extends CoreTask within HodAI;

// local
var Angle lCurrentAngle;

state main
{
Begin:
	endon ('death');
	endon ('orient_mode_changed');

	lCurrentAngle = angles;

	while (true)
	{
		wait (0);
		//pawn.SetRotation(anglestorotator(lCurrentAngle));
		//pawn.SetDesiredRotation(pawn.rotation);
		//angles = rotatortoangles(pawn.rotation);
	}
}
