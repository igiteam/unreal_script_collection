class PlayerMuzzleLight extends MuzzleLight;

//var Weapon Weap;
//var(PlayerMuzzleFlash) float FlashOnWeapBrightness;
//var(PlayerMuzzleFlash) float FlashOnWeapBrightnessSubdued;
//var int	WeapBrightnessVariation;

simulated function PlayerFlash(Weapon W)
{
//	Weap = W;
//	WeapBrightnessVariation *= -1;
//	Weap.AmbientGlow = FlashOnWeapBrightness+WeapBrightnessVariation;
	TimeShown=0;
	LightBrightness=default.LightBrightness;
	GotoState('Visible');
}

simulated function PlayerSubduedFlash(Weapon W)
{
//	Weap = W;
//	WeapBrightnessVariation *= -1;
//	Weap.AmbientGlow=FlashOnWeapBrightnessSubdued+(WeapBrightnessVariation/2);
	TimeShown=0;
	LightBrightness=default.LightBrightness*0.20;
	GotoState('Visible');
}

simulated state Visible
{
	simulated event Tick(float Delta)
	{
		TimeShown+=Delta;
		if (TimeShown > SustainTime)
			gotoState('');

		if (TimeShown > FadeStartTime)
		{
			LightSaturation = default.LightSaturation * 0.60;
			LightBrightness-=FadeSpeed*Delta;
			if (LightBrightness<=0)
			{
				LightBrightness = Default.LightBrightness;
				gotoState('');
			}
		}
	}
	
	simulated function EndState()
	{
		bDynamicLight = false;
	//	Weap.AmbientGlow=0;
	}
	
	simulated function BeginState()
	{	
		TimeShown=0;
		bDynamicLight = true;
	}
		
}


// Decompiled with UE Explorer.
defaultproperties
{
    LightBrightness=60.0000000
    LightRadius=6.0000000
    LightHue=32
    LightSaturation=125
    bDynamicLight=false
    RelativeLocation=(X=16.0000000,Y=-5.0000000,Z=22.0000000)
}