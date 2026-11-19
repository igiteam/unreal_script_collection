class Sprinkler extends Actor
					placeable;

var() int Health;
var() SoundCue EffectSound;
var() float    SoundDuration;
var() ParticleSystem EffectTemplate;
var(Visual) const editconst LightEnvironmentComponent LightEnvironment;

var StaticMeshComponent StaticMeshComponent;
var AudioComponent AudioEffectComponent;
var bool bIsOn;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if (EffectSound != none)
	{
		AudioEffectComponent.SoundCue = EffectSound;
		AttachComponent(AudioEffectComponent);
	}
}

function OnFinished()
{
	AudioEffectComponent.FadeOut(0.3, 0);
	bIsOn = false;
	Health = default.Health;
}

simulated function bool CanSplash()
{
	local EmitterSpawnable E;

	if (bIsOn)
		return true;

	Health = 0;

	if (EffectTemplate != none)
	{
		E = Spawn(class'EmitterSpawnable',,,Location,rot(0,0,0));
		E.SetTemplate( EffectTemplate, true);

		// Hack for Sprinkler Time since we know the emitter duration is 20, fade it out one second before
		SetTimer(SoundDuration, false, 'OnFinished');
		E.ParticleSystemComponent.ActivateSystem();
	}
	AudioEffectComponent.Play();

	bIsOn = true;

	return true;
}

simulated event TakeDamage( int Damage, Controller instigatedBy, Vector hitlocation, Vector momentum,
					class<DamageType> damageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	Health -= Damage;
	if (Health <= 0)
	{
		Health = 0;
		CanSplash();
	}
}

