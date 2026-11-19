class Proj_ZeppelinBullet extends Projectile;

var	TPPhysicalMaterial	DefaultPhysMaterial;
//var SPDLightActor ALight;
var	ParticleSystem TracerImpactTemplate;

//simulated function PostBeginPlay()
//{
//    super.PostBeginPlay();
//	ALight = Spawn(class'SPDLightActor',,,Location);
//	ALight.SetRadius(500);
//	ALight.SetBrightness(10);
//	AttachComponent(ALight.PointLight);
//}
simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	if ( Other == Instigator )
		return;

	if ( !Other.IsA('Projectile') || Other.bProjTarget )
	{
		if ( Other != Instigator )
		{
			if ( !Other.IsA('Pawn') )
			{
				// Don't spawn bullet impact effect on pawns.
				SpawnEffects(HitLocation, HitNormal);
			}
			else
			{
				Explode(Location, HitNormal);
			}
		}
	}
}

function Ricochet(vector HitNormal)
{
	local vector Reflection;

	Reflection = MirrorVectorByNormal(Normal(Velocity),HitNormal);
	SetRotation(rotator(Reflection));
	Velocity = Normal(Reflection) * Speed;
}

simulated function HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	local int RandomInt;

	RandomInt = Rand(10);

	SpawnEffects(Location, HitNormal);
	if (RandomInt > 1)
		Explode(Location, HitNormal);
	else
		Ricochet(HitNormal);
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
	// Trace out and find the material
	local vector HitLoc, HitNorm;
	//local TPPawn tppawn;
	local actor HitActor;
	local TraceHitInfo HitInfo;
	local ImpactInfo Impact;
    local vector StartTrace, EndTrace;
	local TPPhysicalMaterial tpphysmat;
	local EmitterSpawnable E;
 
	StartTrace = HitLocation + (HitNormal * 3);
	EndTrace = HitLocation + (HitNormal * -3);

	HitActor = Trace(HitLoc, HitNorm, EndTrace, StartTrace, true, vect(0,0,0), HitInfo, TRACEFLAG_Bullet );

	Impact.HitActor		= HitActor;
	Impact.HitLocation	= HitLocation;
	Impact.HitNormal	= HitNormal;
	Impact.RayDir		= Normal(HitLocation-StartTrace);
	Impact.HitInfo		= HitInfo;

	tpphysmat = TPPhysicalMaterial(HitInfo.PhysMaterial);

	// Spawn Tracer Impact Particles
	E = Spawn(class'EmitterSpawnable',,,HitLocation, rotator(HitNormal));
	E.SetTemplate( TracerImpactTemplate, true);
	E.ParticleSystemComponent.ActivateSystem();

    HandleImpactParticles( tpphysmat, MyDamageType, Impact);

	HandleImpactSound( tpphysmat, MyDamageType, self, Impact.HitLocation );
}

function HandleImpactParticles( TPPhysicalMaterial PhysMaterial, class<DamageType> ImpactDamageType, ImpactInfo Impact)
{
	if( PhysMaterial == None )
	{
		PhysMaterial = DefaultPhysMaterial;
	}

	PhysMaterial.SpawnImpactParticles( ImpactDamageType, Impact );
}

function HandleImpactSound( TPPhysicalMaterial	PhysMaterial,
								   class<DamageType>	ImpactDamageType,
								   Actor				dummyActor,
								   Vector				soundPos )
{
	if( PhysMaterial == None )
	{
		PhysMaterial = DefaultPhysMaterial;
	}

	PhysMaterial.PlayImpactSound( ImpactDamageType, dummyActor, soundPos );
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	HurtRadius(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	Destroy();
}

