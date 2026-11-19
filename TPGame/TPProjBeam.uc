class TPProjBeam extends Actor;

var vector StartLoc;
var name BeamLengthName;
var ParticleSystem beamParticle;

function Init(vector Direction)
{
    StartLoc = Location;
}

simulated function SpawnHitEffects(vector TraceLoc)
{
    local Emitter BeamEmitter;

    BeamEmitter = Spawn(class'EmitterSpawnable');
	BeamEmitter.ParticleSystemComponent.bAutoActivate = FALSE;
	BeamEmitter.ParticleSystemComponent.SetFloatParameter(BeamLengthName, VSize(TraceLoc - StartLoc));
	BeamEmitter.SetTemplate(beamParticle, TRUE); // we don't cache sniper trails so go ahead and nuke this on finish
	BeamEmitter.ParticleSystemComponent.ActivateSystem();

    SetTimer(3.0,,'Destroy');
}

