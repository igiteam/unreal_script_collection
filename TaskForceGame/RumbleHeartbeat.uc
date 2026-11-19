class RumbleHeartbeat extends RumbleDescription;

const LONG_PERIOD = 0.8f;
const SHORT_PERIOD = 0.1f;
const EFFECT_TIME = 0.1f;
const MIN_STR = 0.3f;
const MAX_STR = 0.4f;

//var sound HeartBeatSound;
//var bool PlayHeartSound;

//the motor speeds go from 0-1
//NOTE: This function needs to be able to be called multiple times per Tick, as each viewport and controller will call it
event bool GetRumbleValues(PlayerController Controller, float TimeIntoEffect, vector attenuatePos, out float LeftMotor, out float RightMotor)
{
	local float period;

	LeftMotor = 0;
	RightMotor = 0;
	
	period = TimeIntoEffect % (LONG_PERIOD + EFFECT_TIME + SHORT_PERIOD + EFFECT_TIME);
	
	period -= LONG_PERIOD;

	if (period<0)
	{
//		playHeartSound = true;
		return true;
	}
	else if (period>EFFECT_TIME)
	{
		period -= EFFECT_TIME + SHORT_PERIOD; 
	
		if (period<0)
		{
//			playHeartSound = true;
			return true;
		}
	}
	
//	if (playHeartSound)
//	{
//		log("PlayHeartSound: " $ HeartBeatSound);
//		Controller.PlaySound(HeartBeatSound,SLOT_Interface);
//		playHeartSound = false;
//	}
	
	//now period should range from 0 - EFFECT_TIME
	period = period*2*PI*EFFECT_TIME;
	period = period % (2*PI);

	LeftMotor = MIN_STR + (((sin(period)/2)+0.5)*(MAX_STR-MIN_STR));
	RightMotor = LeftMotor;
	
	return true;
}

