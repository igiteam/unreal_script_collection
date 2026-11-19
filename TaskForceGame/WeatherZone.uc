
class WeatherZone extends ZoneInfo; 

struct WeatherEmitterInfo
{
	var() class<Emitter>	EmitterClass; 
	var() vector			Offset; 
}; 

struct WeatherZonePawnEffects
{
	var() class<Emitter>	EmitterClass; 
	var() name				BoneName; 
	var() vector			RelativeOffset; 
	var() rotator			RelativeRotation; 
};

var(WeatherZone) array<WeatherEmitterInfo>		EmmiterInfo; 
var(WeatherZone) array<WeatherZonePawnEffects>	PawnEffects; 

// When an actor enters this zone.
event ActorEntered( actor Other )
{
	local int i; 
	Super.ActorEntered(Other); 
	
	if (ZombiePlayerPawn(Other)!= None)
	{
		for ( i = 0; i < EmmiterInfo.Length; i++ ) 
		{
			ZombiePlayerPawn(Other).AttachWeatherEffect(EmmiterInfo[i].EmitterClass,EmmiterInfo[i].Offset); 
		}
	}
}

// When an actor leaves this zone.
event ActorLeaving( actor Other )
{
	if ( ZombiePlayerPawn ( Other ) != None )
	{
		ZombiePlayerPawn(Other).DetachWeatherEffects();
	}
	
	Super.ActorLeaving(Other); 
}
