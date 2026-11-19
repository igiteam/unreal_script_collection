class Proj_G47Sniper extends TPProjectile;

var TPG47SniperBeam beam;

function Init(vector Direction)
{
    Super.Init(Direction);

    if (WorldInfo.NetMode == NM_Standalone)
	{
		beam = Spawn(class'TPG47SniperBeam');
		beam.Init(Location);
	}
}

simulated function SpawnHitEffects(vector TraceLoc)
{
    Super.SpawnHitEffects(TraceLoc);
    
	if (beam != none)
		beam.SpawnHitEffects(TraceLoc);
}

