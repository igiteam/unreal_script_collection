class Proj_AirplaneRocket extends TPProjectile;

var ParticleSystem FlightEffectTemplate;


function Init(vector Direction)
{
    Super.TPInit(Direction, false);
}

simulated function PostBeginPlay()
{
	local EmitterSpawnable E;
	super.PostBeginPlay();
	E = Spawn(class'EmitterSpawnable');
	E.SetTemplate(FlightEffectTemplate,false);
	AttachComponent(E.ParticleSystemComponent);
}

