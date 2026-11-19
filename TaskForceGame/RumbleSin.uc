class RumbleSin extends ZombieRumbleDesc;

//var float MinStrength;
//var float MaxStrength;
var(Rumble) float Frequency; //Cycles per sec (Yeahm I know that's Hertz, but do the artists, huh? Answer me that)
//var float Duration;
//
//var bool UseLeftMotor;
//var bool UseRightMotor;

function float CalcRumble(PlayerController Controller, float TimeIntoEffect)
{
	local float rad;
	local float rumble;

	rad = TimeIntoEffect*2*PI*Frequency;
	rad = rad % (2*PI);

	Rumble = MinStrength + (((sin(rad)/2)+0.5)*(MaxStrength-MinStrength));

//	log("Rumble: " $ Rumble $ " Rad: " $ rad);

	return Rumble;
}
/*
event bool GetRumbleValues(PlayerController Controller, float TimeIntoEffect, out float LeftMotor, out float RightMotor)
{
	local float rad;
	local float rumble;

	if ((TimeIntoEffect>Duration) && (Duration > 0))
	{
		LeftMotor = 0;
		RightMotor = 0;
		log("Truning RumbleCos off");
		return false;
	}

	rad = TimeIntoEffect*2*PI*Frequency;
	rad = rad % (2*PI);

	Rumble = MinStrength + (((sin(rad)/2)+0.5)*(MaxStrength-MinStrength));

	log("Rumble: " $ Rumble $ " Rad: " $ rad);

	if (UseLeftMotor)
	{
		LeftMotor = Rumble;
	}
	else
	{
		LeftMotor = 0;
	}

	if (UseRightMotor)
	{
		RightMotor = Rumble;
	}
	else
	{
		RightMotor = 0;
	}

	return true;
}*/


// Decompiled with UE Explorer.
defaultproperties
{
    Frequency=1.0000000
}