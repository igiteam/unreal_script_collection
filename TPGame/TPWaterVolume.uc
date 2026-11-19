class TPWaterVolume extends WaterVolume
	placeable;

var() float SmallEffectThreshold;
var() class<EmitterSpawnable> SmallSplash;
var() class<EmitterSpawnable> LargeSplash;
var() class<EmitterSpawnable> PanzerSplash;

simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local float OtherSize;
	super.Touch(Other, OtherComp, HitLocation, HitNormal);

	OtherSize = VSize(Other.CollisionComponent.Bounds.BoxExtent);
	//`log("Extents are"@OtherSize);
	if (Other.IsA('Proj_PanzerStrike'))
	{
		//`log("Spawning panzer effect!");
		Spawn(PanzerSplash, , , HitLocation);
	}
	else if (OtherSize < SmallEffectThreshold)
	{
		//`log("Spawning small effect!");
		Spawn(SmallSplash, , , HitLocation);
	}
	else
	{
		//`log("Spawning large effect!");
		Spawn(LargeSplash, , , HitLocation);
	}
}

