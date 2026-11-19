class InteractionWeapGrenade extends SFRMInteraction; 

var float SpeedMod; 

function float GetSpeedModifier() { return SpeedMod; }

function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
{
	local byte k;
	//local float OldCrossHair, Mag;
	k = Key;

	switch (Action)
	{
		case IST_Axis:
			break; 
		case IST_Press:
		case IST_Hold: 
		case IST_Release: 
			if (Delta == 0)
				SpeedMod = 1.0f;
			else
				SpeedMod = (1.0f / 255.0f) * Delta; 
			
			break;
		default:
	}

	return false;
}


// Decompiled with UE Explorer.
defaultproperties
{
    SpeedMod=1.0000000
}