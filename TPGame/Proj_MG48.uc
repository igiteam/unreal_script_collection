class Proj_MG48 extends TPProjectile;

var TPMG48Beam beam;

function Init(vector Direction)
{
    Super.TPInit(Direction, false, true);

    beam = Spawn(class'TPMG48Beam');
    beam.Init(Location);
}

simulated function SpawnHitEffects(vector TraceLoc)
{
    Super.SpawnHitEffects(TraceLoc);
    beam.SpawnHitEffects(TraceLoc);
}

