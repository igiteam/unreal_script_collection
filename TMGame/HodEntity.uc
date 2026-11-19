class HodEntity extends HodObject
	native(TG);

var vector origin;
var Angle angles;

function Actor GetActor();

function vector GetOrigin()
{
	return origin;
}

function vector GetShootAtPos()
{
	// need fixed
	//assert(false);
	return origin;
}

function float GetYaw(vector org)
{
	return VectorToAngles(org - origin).yaw;
}

function float GetYawToOrigin(vector org)
{
	local float yaw;

	yaw = angles.yaw - GetYaw( org );
	yaw = AngleClamp180( yaw );
	return -yaw;
}

// Gives the result as an angle between - 180 and 180
function float AngleClamp180(float iAngle)
{
	local float angleFrac;

	angleFrac = iAngle / 360.0;
	iAngle = (angleFrac - ffloor(angleFrac)) * 360.0;
	if (iAngle > 180.0)
		return iAngle - 360.0;
	return iAngle;
}

function float AngleClamp360(float iAngle)
{
	local float angleFrac;
	angleFrac = iAngle / 360.0;
	iAngle = (angleFrac - ffloor(angleFrac)) * 360.0;
	return iAngle;
}

// equivalent to abs( AngleClamp180( iAngle ) )
function float AbsAngleClamp180(float iAngle)
{
	local float angleFrac;

	angleFrac = iAngle / 360.0;
	iAngle = (angleFrac - ffloor(angleFrac)) * 360.0;
	if( iAngle > 180.0 )
		return 360.0 - iAngle;
	return iAngle;
}

function vector LocalToWorldCoords(vector iPosition)
{
	local vector x, y, z;
	GetAxes(AnglesToRotator(angles), x, y, z);
	return iPosition.x * x + iPosition.y * y + iPosition.z * z + origin;

}
