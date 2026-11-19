class RPG18Projectile extends ImpactProjectile;

var(TrailFx)	class<Emitter>	TrailEffectClass;
var				Emitter			TrailEffect;  
var(TrailFX)	float		SpawnInterval; // also used for dynamic light
//var				int			EffectCycleCounter;

var class<MuzzleLight> LightFlashClass;
var MuzzleLight lightFlash;
var bool bUseDynamicLight;

function PostBeginPlay()
{
	Super.PostBeginPlay(); 
	doSubduedLightFlash();

	TrailEffect = Spawn(TrailEffectClass,,,Location,Rotation);
	TrailEffect.SetBase(self);
	TrailEffect.SetRelativeLocation(vect(0,0,0));

	SetTimer(SpawnInterval*2.0, false); 

	if( Level.Game == None || Level.NetMode != NM_Standalone 
	 || (ClassIsChildOf( Level.Game.Class, class'ZombieGame.SFRMMultiPlayer' )) )
		bUseDynamicLight = false;
	else
		bUseDynamicLight = true;

	// Multiplayer has different damage radii than single-player
	if( Level.NetMode == NM_StandAlone && SFRMSinglePlayer(Level.Game) != None )
	{
		DamageRadius /= 1.5;
		FringeDamageRadius /= 1.5;
	}
}

function doLightFlash()
{
	if (LightFlashClass!=None && bUseDynamicLight)
	{
		if (lightFlash==None)
			lightFlash = Spawn(LightFlashClass);
		lightFlash.SetBase(self);
		lightFlash.SetRelativeLocation(vect(0,0,0));
		lightFlash.LightBrightness = lightFlash.default.LightBrightness * 1.3;
		lightFlash.LightRadius = lightFlash.default.LightRadius * 1.4;
		lightFlash.Flash();
	}
}

function doSubduedLightFlash()
{
	if (LightFlashClass!=None && bUseDynamicLight)
	{
		if (lightFlash==None)
			lightFlash = Spawn(LightFlashClass);
		lightFlash.SetLocation(Location);
		lightFlash.LightBrightness = lightFlash.default.LightBrightness * 0.40;
		lightFlash.LightRadius = lightFlash.default.LightRadius * 0.9;
		lightFlash.Flash();
	}
}

simulated function BlowUp(vector HitLocation)
{
	TrailEffect.Kill();
	doLightFlash();
	Super.BlowUp(HitLocation);
}

function Timer()
{
	if( VSize(Velocity) < 40 )			// If projectile has almost stopped, then blow it up
		Explode(Location, Normal(Velocity));
	else if( VSize(Velocity) < default.speed )		// If it is slow, accelerate it
		Velocity *= 1.0 + 0.6*SpawnInterval*(default.speed / VSize(Velocity));

	doSubduedLightFlash();

	SetTimer(SpawnInterval*0.2, false); 
}

function Destroyed()
{
	// This call to TrailEffect.Kill is here to take care 
	// of times when we hit the skybox
	if( TrailEffect != None )
		TrailEffect.Kill();

	AmbientSound=None;
	Super.Destroyed();
}


// Decompiled with UE Explorer.
defaultproperties
{
    TrailEffectClass=Class'ZombieEffects.rpg_trail_redux'
    SpawnInterval=0.0500000
    LightFlashClass=Class'GrenadeLightFlash'
    IPExplosionSound=Sound'CBW_DYN_weapons.explosions.AT4_explosion1'
    ProjectileFireSound=Sound'CBW_DYN_weapons.AT4.At4_fire1'
    ImpactDamage=25
    Speed=3000.0000000
    MaxSpeed=5000.0000000
    Damage=400.0000000
    BotDamage=50.0000000
    DamageRadius=750.0000000
    InnerDamageRadius=85.0000000
    FringeDamageRadius=810.0000000
    MyDamageType=Class'DamageTypeRPG'
    DrawType=8
    AmbientSound=Sound'CBW_DYN_weapons.AT4.AT4_loop'
    SoundRadius=100.0000000
    SoundVolume=250
    bFixedRotationDir=false
}