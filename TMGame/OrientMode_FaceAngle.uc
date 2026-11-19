class OrientMode_FaceAngle extends CoreTask within HodAI;

// parameter
var float iAngle;

// output

// local
var int lTime;
var float lDelta;
var float lAngle;
var float lSign;
var Rotator lAngles;

state main
{
Begin:
	endon ('death');
	endon ('orient_mode_changed');

	//lDelta = a / 5;

	//for (i = 0; i < 5; ++ i)
	//{
	//	angles.yaw += a;
	//	pawn.SetRotation(anglestorotator(angles));
	//	angles = rotatortoangles(pawn.rotation);
	//	wait(0);
	//}
	//_return();

	lTime = gettime();
	//iAngle = AngleClamp180(iAngle - angles.yaw);//pawn.Rotation.yaw / 182.04;
	lSign = sign(iAngle);
	lAngle = abs(iAngle);

	if (lAngle > 0)
	{
		while (lAngle > 0)
		{
			wait (0);

			lDelta = 400 * (gettime() - lTime) / 1000.0;
			lTime = gettime();

			if (lDelta > lAngle)
				lDelta = lAngle;

			lAngle -= lDelta; 
			angles.yaw = AngleClamp360(angles.yaw + lSign * lDelta);
			pawn.SetRotation(anglestorotator(angles));
			pawn.SetDesiredRotation(pawn.rotation);
			angles = rotatortoangles(pawn.rotation);
		}
	}
	else
	{
		angles.yaw = AngleClamp360(angles.yaw);
		pawn.SetRotation(anglestorotator(angles));
		pawn.SetDesiredRotation(pawn.rotation);
		angles = rotatortoangles(pawn.rotation);
	}
}
