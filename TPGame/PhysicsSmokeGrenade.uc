class PhysicsSmokeGrenade extends KAsset
    placeable;

var() float CookTime;					// How much time before the grenade blows up
var() float ImpulseForce;				// How much force to apply to nearby objects
var() float AffectedRadius;				// What radius the zone effects

var AudioComponent  CollideAudioCmpt;
var AudioComponent  SmokeAudioCmpt;
var() soundcue      GrenadeLandingCue;
var() soundcue      SmokeCue;

var  EmitterSpawnable  E;
var() ParticleSystem  SmokeParticle;

var() float SetSmokingTime;

var bool bActivateSmoke;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

	CollideAudioCmpt.SoundCue = GrenadeLandingCue;
	AttachComponent(CollideAudioCmpt);

	SmokeAudioCmpt.SoundCue = SmokeCue;
	AttachComponent(SmokeAudioCmpt);

	SkeletalMeshComponent.WakeRigidBody();
	SkeletalMeshComponent.SetNotifyRigidBodyCollision(true);
}

simulated event RigidBodyCollision( PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent,
					const out CollisionImpactData RigidCollisionData, int ContactIndex )
{
    if (!CollideAudioCmpt.bWasPlaying)
		CollideAudioCmpt.Play();

	bActivateSmoke=true;
}


auto state Cooking
{
    function Tick (float DeltaTime)
    {
        if(bActivateSmoke)
		{
            SetTimer(CookTime,false,'CreateSmoke');
            bActivateSmoke=false;
		}
	}

    simulated function CreateSmoke()
    {
        local vector socketlocation;

	   if (SmokeParticle != none)
	   {
          SmokeAudioCmpt.Play();
          SkeletalMeshComponent.GetSocketWorldLocationAndRotation('SmokeEmit', socketlocation);
          E = Spawn(class'EmitterSpawnable',,,socketlocation,rot(0,0,0));
		  E.SetTemplate( SmokeParticle, true);
		  E.ParticleSystemComponent.ActivateSystem();
		  SetTimer(SetSmokingTime,false,'StopSmoke');
	   }
    }


    simulated function StopSmoke()
    {
        SmokeAudioCmpt.Stop();
        E.ParticleSystemComponent.DeactivateSystem();
    }
}

