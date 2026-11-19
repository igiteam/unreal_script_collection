class Proj_FG44 extends TPProjectile;

var TPFG44Beam beam;

function Init(vector Direction)
{
    Super.TPInit(Direction, true, false);

	if (WorldInfo.NetMode == NM_Standalone)
	{
		beam = Spawn(class'TPFG44Beam');
		beam.Init(Location);
	}
}

simulated function SpawnHitEffects(vector TraceLoc)
{
    Super.SpawnHitEffects(TraceLoc);
	
	if (beam != none)
		beam.SpawnHitEffects(TraceLoc);
}

