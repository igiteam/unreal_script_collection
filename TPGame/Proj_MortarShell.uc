class Proj_MortarShell extends TPProjectile;

function Init(vector Direction)
{
	super.TPInit(Direction, false);
	SetPhysics(PHYS_Falling);
	LifeSpan = 180.0;
}

simulated function Landed(vector HitNormal, Actor FloorActor)
{
	;
	HitWall(HitNormal, FloorActor, None);
}
simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	StaticMeshComponent.SetHidden(true);
	SpawnHitEffects(HitLocation);
	Other.TakeDamage(Damage,InstigatorController,Location,MomentumTransfer * Normal(Velocity), MyDamageType, HitInfo);
	Shutdown();
}

simulated singular function HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	StaticMeshComponent.SetHidden(true);
	SpawnHitEffects(Location);
	Wall.TakeDamage(Damage,InstigatorController,Location,MomentumTransfer * Normal(Velocity), MyDamageType, HitInfo);
	Shutdown();
}

simulated function SpawnHitEffects(Vector TraceLoc)
{
	local EmitterSpawnable emitter;
	emitter = spawn(class'EmitterSpawnable',,,TraceLoc);
	emitter.SetTemplate( ParticleSystem'FX_EXP_shelBlast.Particles.FX_Exp_Projectile', true );
	emitter.bDestroyOnSystemFinish = true;
	emitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0f;
	emitter.ParticleSystemComponent.ActivateSystem();
	PlaySound(SoundCue'S_Dst_Explosions.Combo.Explosion_Grenade_ACue');

}

simulated function Destroyed()
{
	SetPhysics(PHYS_None);
}

function OnParticleSystemFinished(ParticleSystemComponent FinishedComponent)
{
	Destroy();
}

simulated function Shutdown()
{
	SetPhysics(PHYS_None);
	TracerEmitter.ParticleSystemComponent.DeactivateSystem();
}

