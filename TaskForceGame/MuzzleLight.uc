class MuzzleLight extends Actor
	abstract
	native;

var float TimeShown;
var float SustainTime;	// How long to display it
var float FadeStartTime;
var float FadeSpeed;

var(MuzzleFlash) ELightType FlashLightType;
var(MuzzleFlash) ELightEffect FlashLightEffect;

simulated event Flash()
{
	TimeShown=0;
	
	if( !bDynamicLight )
	{
		bDynamicLight = true;
		GotoState('Visible');
	}
}

auto state Invisible
{

Begin:
	bDynamicLight = false;
	Disable('Tick');
}

simulated state Visible
{
	simulated event Tick(float Delta)
	{
		TimeShown+=Delta;
		if (TimeShown > SustainTime)
			gotoState('Invisible');
			
		if (TimeShown > FadeStartTime)
		{
			LightBrightness-=FadeSpeed*Delta;
			if (LightBrightness<=0)
			{
				LightBrightness = Default.LightBrightness;
				gotoState('Invisible');
			}
		}
	}

Begin:
	Enable('Tick');
}	


// Decompiled with UE Explorer.
defaultproperties
{
    SustainTime=0.1000000
    FadeStartTime=100000.0000000
    LightType=1
    LightEffect=13
    LightBrightness=222.0000000
    LightRadius=11.0000000
    LightHue=46
    LightSaturation=192
    bHidden=true
    bDynamicLight=true
    bAcceptsProjectors=false
}