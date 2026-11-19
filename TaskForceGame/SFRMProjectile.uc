class SFRMProjectile extends Projectile;

struct ScorchMarkDef
{
	var()	class<Projector>	ProjectorClass; 
}; 

var(ImpactEffect) class<Actor>			ImpactEffect;
var(ImpactEffect) array<ScorchMarkDef>	ScorchMarkArray; 
var(ImpactEffect) float EffectScale;
var RumbleDescription ExplosionRumbleDes;
var float RumbleRadiusMultiplier;

var Sound ProjectileFireSound;
var float LifespanAfterPHYSNone;
var Material	MyHitMaterial;

var float MinDestructibleBreakSpeed;  // min speed at which projectile itself (not the explosion) will inflict damage to destructible (e.g. glass window)
var int   ImpactDamage;        // damage that projectile itself (not explosion) will do to destructible (e.g. glass)

simulated function PostBeginPlay()
{
	//Log("SFRMProjectile.PostBeginPlay   entered function ");
	Super.PostBeginPlay();

	SetTimer(0.8, true);
	if ( Level.NetMode == NM_Client )
		LifeSpan = 2.0;
	else
		Velocity = Speed * vector(Rotation);

	//Log(" SFRMProjectile.PostBeginPlay   Velocity: " $Velocity $"  Speed: " $Speed );
//	Log(" SFRMProjectile.PostBeginPlay   (Level.NetMode == NM_Client): "$(Level.NetMode == NM_Client) 
//		$"  (Level.NetMode: " $Level.NetMode $")" );
	if ( Level.bDropDetail )
	{
		LightType = LT_None;
		bDynamicLight = false;
	}
	if ( Level.NetMode != NM_DedicatedServer )
	{
	}
}

function SetProjectileProps(float fLife, float fSpeed)
{
	LifeSpan=fLife; 
	Speed=fSpeed;
}

simulated function Timer()
{
	Super.Timer(); 

	if ( Level.bDropDetail )
	{
		LightType = LT_None;
		bDynamicLight = false;
	}

	if ( (Physics == PHYS_None) && (LifeSpan > LifespanAfterPHYSNone) )
		LifeSpan = LifespanAfterPHYSNone;
}

simulated function HitWall (vector HitNormal, actor Wall)
{
	// Handle impact with destructible (may need to break the destructible and keep going)
	if( DestructibleMesh(Wall) != None && VSize(Velocity) > MinDestructibleBreakSpeed )
	{
		Wall.TakeDamage( ImpactDamage, instigator, Location, vect(0,0,0), class'DamageTypeProjectile', InstigatorController );

		// If victim is being destroyed by the impact, then don't bounce 
		// (let projectile pass through).
		if( DestructibleMesh(Wall).HitPoints <= 0 )
		{
			return;
		}
	}

	Super.HitWall( HitNormal, Wall );
}

simulated function RumbleBystanders(vector HitLocation)
{
	local ZombiePlayerPawn sfp;
	local PlayerController pc;

	if (ExplosionRumbleDes != none)
	{	
		foreach VisibleCollidingActors (class'ZombieGame.ZombiePlayerPawn', sfp, DamageRadius*RumbleRadiusMultiplier, HitLocation)
		{
			if (sfp != None && sfp.Health > 0)
			{
				ExplosionRumbleDes.InnerAttenuateRadius=DamageRadius;
				ExplosionRumbleDes.OuterAttenuateRadius=DamageRadius*RumbleRadiusMultiplier;
				pc = PlayerController(sfp.controller);
				if( pc != None )
					pc.PlayRumble(ExplosionRumbleDes, HitLocation);
			}
		}
	}
}

simulated function BlowUp(vector HitLocation)
{
	local bool IsMP;

	IsMP = (Level.NetMode != NM_Standalone) || (Level.Game == none) || 
			ClassIsChildOf(Level.Game.class, class'ZombieGame.SFRMMultiPlayer');

	// If projectile was launched by player, use Damage, otherwise use BotDamage in call to HurtRadius
	// (If this is non-CoOp multiplayer, automatically assume it's a player-launched projectile)
	if( IsMP || (ZombiePlayerPawn(Instigator) != None) || (PlayerController(InstigatorController) != None) )
		HurtRadius(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation, InnerDamageRadius, FringeDamageRadius, InstigatorController);
	else
		HurtRadius(BotDamage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation, InnerDamageRadius, FringeDamageRadius, InstigatorController);

	if ( Role == ROLE_Authority )
		MakeNoise(2.5);
}

simulated event Explode(vector HitLocation, vector HitNormal)
{
	//local rotator			DecalRotatioin; 
	local class<Projector>	ScorchProjector; 
	local vector			TempHL,
							TempHN;

	// Find what the projectile is hitting
	Trace ( TempHL, TempHN, Location - 128.0*HitNormal, Location + 14.0*HitNormal, True, , MyHitMaterial, true );

	// If hitting the sky (material is none), then just destroy projectile (no explosion)
	if ( MyHitMaterial != None && MyHitMaterial.MaterialType == EMATERIALTYPE_SKY ) 
	{
		Destroy ( );
		return;
	}

	Spawn(ImpactEffect,,,HitLocation + HitNormal,rotator(HitNormal));

	if ( ScorchMarkArray.Length > 0 )
	{
		ScorchProjector = ScorchMarkArray[Rand(ScorchMarkArray.Length)].ProjectorClass; 
		Spawn(ScorchMarkArray[Rand(ScorchMarkArray.Length)].ProjectorClass,,,HitLocation + (vect(200, 200, 200) * HitNormal), rotator(-HitNormal));
	}

//	RumbleBystanders(HitLocation);  // MAT 2/20/05
	BlowUp(HitLocation); 
	Super.Explode(HitLocation, HitNormal);
}

auto State Flying
{
Begin:
	LifeSpan = 0;
}

function Sound GetProjectileFireSound()
{
	return ProjectileFireSound;
}


// Decompiled with UE Explorer.
defaultproperties
{
    ImpactEffect=Class'ZombieEffects.explosion_grenade'
    ScorchMarkArray[0]=(ProjectorClass=Class'ZombieEffects.explosiondecal_scorcha')
    EffectScale=1.0000000
    // Reference: RumbleSawtooth'SFRMProjectile.ProjRumble'
    begin object name=ProjRumble class=Class'RumbleSawtooth'
        Frequency=0.3500000
        MaxStrength=0.8000000
        Duration=0.3500000
    end object
    ExplosionRumbleDes=ProjRumble
    RumbleRadiusMultiplier=2.0000000
    LifespanAfterPHYSNone=0.5000000
    MinDestructibleBreakSpeed=400.0000000
    ImpactDamage=5
    Speed=1000.0000000
    MaxSpeed=10000.0000000
    Damage=15.0000000
    BotDamage=10.0000000
    MomentumTransfer=40000.0000000
    MyDamageType=none
    ExploWallOut=10.0000000
    LifeSpan=0.5000000
    SoundRadius=10.0000000
    SoundVolume=218
    bFixedRotationDir=true
    Mass=5000.0000000
    ForceType=1
    ForceRadius=100.0000000
    ForceScale=5.0000000
}