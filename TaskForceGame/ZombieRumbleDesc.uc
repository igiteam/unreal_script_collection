class ZombieRumbleDesc extends RumbleDescription;

var(Rumble) float MinStrength;
var(Rumble) float MaxStrength;
var(Rumble) float Duration;
var(Rumble) bool UseLeftMotor;
var(Rumble) bool UseRightMotor;

event bool GetRumbleValues(PlayerController Controller, float TimeIntoEffect, vector attenuatePos, out float LeftMotor, out float RightMotor)
{
	local float Rumble;
	local float dist;

	if ((TimeIntoEffect>Duration) && (Duration > 0))
	{
		LeftMotor = 0;
		RightMotor = 0;
//		log("Turning Rumble"@self@"off");
		return false;
	}

	Rumble = CalcRumble(Controller, TimeIntoEffect);

	if (OuterAttenuateRadius != -1)
	{
		if ((Controller == none) || (Controller.Pawn == none))
		{
			return false;
		}
		//need to attenuate rumble
		dist = VSize(Controller.Pawn.Location - attenuatePos);
		
		//log("RumbleAtten1: " $ dist); 
		
		if (dist > InnerAttenuateRadius)
		{
			if (dist < OuterAttenuateRadius)
			{
				//log("RumbleAtten2: " $ Rumble @ 1-(dist-InnerAttenuateRadius)/(OuterAttenuateRadius-InnerAttenuateRadius) @ 
				//	Rumble * (1-(dist-InnerAttenuateRadius)/(OuterAttenuateRadius-InnerAttenuateRadius)));
				Rumble *= 1-(dist-InnerAttenuateRadius)/(OuterAttenuateRadius-InnerAttenuateRadius);
			}
			else
			{
				//log("RumbleAtten3: Zeroing");
				Rumble = 0;
			}
		}
	}

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
}

function float CalcRumble(PlayerController Controller, float TimeIntoEffect);


// Decompiled with UE Explorer.
defaultproperties
{
    MaxStrength=1.0000000
    Duration=-1.0000000
    UseLeftMotor=true
    UseRightMotor=true
}