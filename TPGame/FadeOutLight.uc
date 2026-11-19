class FadeOutLight extends Actor;

var PointLightComponent Light;
var float LightFadeOutTime;

function simulated PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer( LightFadeOutTime );
}

simulated function Tick( float DeltaTime )
{
	local float TimerCount, pct;

	TimerCount = GetTimerCount();
	if( TimerCount >= 0 )
	{
		pct = (LightFadeOutTime-TimerCount) / LightFadeOutTime;
		Light.SetLightProperties(Light.default.Brightness * pct * pct, , );
	}
	else
	{
		Destroy();
	}
}

