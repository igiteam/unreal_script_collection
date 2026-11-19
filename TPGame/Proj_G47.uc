class Proj_G47 extends TPProjectile;

var TPG47Beam beam;

function Init(vector Direction)
{
    Super.TPInit(Direction, true);

	if (WorldInfo.NetMode == NM_Standalone)
	{
		beam = Spawn(class'TPG47Beam');
		beam.Init(Location);
	}
}

simulated function SpawnHitEffects(vector TraceLoc)
{
    Super.SpawnHitEffects(TraceLoc);
    
	if (beam != none)
		beam.SpawnHitEffects(TraceLoc);
}

