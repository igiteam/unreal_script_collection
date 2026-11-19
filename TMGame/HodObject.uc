class HodObject extends CoreObject within HodSystem
	native(TG);

const vec_undefined = vect(100000000, 100000000, 100000000);
const time_undefined = -1;
const float_undefined = 100000000;
const obj_undefined = none;

const invalid_vector = vect(100000000, 100000000, 100000000);
const invalid_float = 100000000;
const invalid_time = -1;

const FInch = 1.27;
const FInchSq = 1.6129;

var name type;

enum Ternary
{
	TernaryFalse,
	TernaryTrue,
	TernaryUndefined,
};

struct native Angle
{
	var float pitch;
	var float yaw;
	var float roll;
};

struct native ApproachTypes
{
	var name data[2];
};

struct native TransAngle
{
	var float data[10];
	
	structdefaultproperties
	{
		data[0] = 100000000;
		data[1] = 100000000;
		data[2] = 100000000;
		data[3] = 100000000;
		data[4] = 100000000;
		data[5] = 100000000;
		data[6] = 100000000;
		data[7] = 100000000;
		data[8] = 100000000;
		data[9] = 100000000;
	}
};

struct native TransSplit
{
	var float data[10];
	
	structdefaultproperties
	{
		data[0] = 100000000;
		data[1] = 100000000;
		data[2] = 100000000;
		data[3] = 100000000;
		data[4] = 100000000;
		data[5] = 100000000;
		data[6] = 100000000;
		data[7] = 100000000;
		data[8] = 100000000;
		data[9] = 100000000;
	}
};

struct native TransDist
{
	var vector data[10];
	
	structdefaultproperties
	{
		data[0] = (X=100000000, Y=100000000, Z=100000000);
		data[1] = (X=100000000, Y=100000000, Z=100000000);
		data[2] = (X=100000000, Y=100000000, Z=100000000);
		data[3] = (X=100000000, Y=100000000, Z=100000000);
		data[4] = (X=100000000, Y=100000000, Z=100000000);
		data[5] = (X=100000000, Y=100000000, Z=100000000);
		data[6] = (X=100000000, Y=100000000, Z=100000000);
		data[7] = (X=100000000, Y=100000000, Z=100000000);
		data[8] = (X=100000000, Y=100000000, Z=100000000);
		data[9] = (X=100000000, Y=100000000, Z=100000000);
	}
};

struct native TransAnim
{
	var name data[10];
};

struct native AnimationSet
{
	var array<name> data;
};

struct native AnimWeightSet
{
	var array<float> data;
};

struct native AnimSetArray
{
	var array<AnimationSet> data;
};

struct native AnimWeightSetArray
{
	var array<AnimWeightSet> data;
};

struct native TraceInfo
{
	var vector position;
};

function WaitNotify(float time, name note, optional bool newThread = false)
{
	local HodObject_WaitNotify task;
	task = new(self) class'HodObject_WaitNotify';
	task.time = time;
	task.note = note;
	run(task, newThread);
}

function int RandomInt(int inMax)
{
	return Rand(inMax);
}

function int RandomIntRange(int inMin, int inMax)
{
	return inMin + RandomInt(inMax - inMin);
}

function float RandomFloat(float inMax)
{
	return FRand() * inMax;
}

function float RandomFloatRange(float inMin, float inMax)
{
	return inMin + RandomFloat(inMax - inMin);
}

function float Distance(vector from, vector to)
{
	return VSize(from - to);
}

function float DistanceSquared(vector from, vector to)
{
	return VSizeSq(from - to);
}

function float VectorDot(vector v1, vector v2)
{
	return v1 dot v2;
}

function vector VectorNormalize(vector v)
{
	return normal(v);
}

function vector VectorScale(vector v, float s)
{
	return v * s;
}

function vector anglestoright(Angle iAngle)
{
	local vector x, y, z;
	GetAxes(AnglesToRotator(iAngle), x, y, z);
	return y;
}

function vector anglestoforward(Angle iAngle)
{
	local vector x, y, z;
	GetAxes(AnglesToRotator(iAngle), x, y, z);
	return x;
}

function Angle VectorToAngles(vector point)
{
	return RotatorToAngles(rotator(point));
}

function Angle RotatorToAngles(rotator r)
{
	local Angle lAngle;

	lAngle.pitch = r.pitch / 182.04;
	lAngle.yaw = r.yaw / 182.04;
	lAngle.roll = r.roll / 182.04;

	return lAngle;
}

function Rotator AnglesToRotator(Angle iAngle)
{
	local Rotator lRotator;

	lRotator.Pitch = iAngle.pitch * 182.04;
	lRotator.Yaw = iAngle.yaw * 182.04;
	lRotator.Roll = iAngle.roll * 182.04;

	return lRotator;
}

function float Length(vector v)
{
	return VSize(v);
}

function float LengthSquared(vector v)
{
	return VSizeSq(v);
}

function bool isdefined(name n)
{
	return n != '';
}

function bool float_isdefined(float v)
{
	return v != float_undefined;
}

function bool vec_isdefined(vector v)
{
	return v != vec_undefined;
}

function bool obj_isdefined(Object o)
{
	return o != none;
}

function bool time_isdefined(int t)
{
	return t != time_undefined;
}

function bool node_isdefined(HodNode n)
{
	return n != none && n.IsValid();
}

function bool ternary_isdefined(Ternary t)
{
	return t != TernaryUndefined;
}

function float sign(float x)
{
	if (x > 0)
		return 1;
	else if (x < 0)
		return -1;
	return 0;
}

function float squared(float x)
{
	return x * x;
}

function bool flag(name iFlag)
{
	return level.flag[FlagId(iFlag)];
}
