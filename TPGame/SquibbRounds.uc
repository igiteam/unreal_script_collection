class SquibbRounds extends Actor
							native
							placeable;
		
// User Input
var() float Distance;
var() bool bCauseDamage;
var() float DamageRadiusPerRound;
var() int DamageAmount;

// Internal
var SeqAct_SquibbRounds Action;
var vector OffsetDistVect;
var int FireCount;
var float RefireTimer, FireTimer;
var ArrowComponent RotationArrow, DirectionArrow;
var	const protected TPPhysicalMaterial DefaultPhysMaterial;

var(Decals) bool bUseDecalMaterial;
var(Decals) float DecalWidth;
var(Decals) float DecalHeight;
var(Decals) DecalMaterial DecalMaterial;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function OnSquibbRounds(SeqAct_SquibbRounds inAction)
{
	Action = inAction;
	FireCount=0;
	FireTimer=0;
	RefireTimer = Action.TotalFireTime / Action.NumberOfRounds;
	OffsetDistVect = vector(Rotation) * (Distance / Action.NumberOfRounds);
	
	GotoState('Firing');
}

function SpawnEffect()
{
	//local EmitterSpawnable E;
	local Actor HitActor;
	local ImpactInfo Impact;
	local vector Start, End, OffsetVect;
	local vector HitLoc, HitNorm;
	local vector X, Y, Z;
	local TraceHitInfo HitInfo;
	local TPPhysicalMaterial PhysMaterial;
	//local DecalLifetimeDataAge LifetimeData;

	GetAxes(Rotation, X, Y, Z);
	OffsetVect = Y * (FRand() * Action.Spread);
	
	Start = Location+(OffsetDistVect * FireCount)+OffsetVect;
	End = Start + (Z * -1000);

	HitActor = Trace(HitLoc, HitNorm, End, Start, false, vect(0,0,0), HitInfo);
	
	Impact.HitActor		= HitActor;
	Impact.HitLocation	= HitLoc;
	Impact.HitNormal	= HitNorm;
	Impact.RayDir		= Normal(HitLoc-Start);
	Impact.HitInfo		= HitInfo;

	if (bUseDecalMaterial && DecalMaterial != none)
	{
		//LifetimeData = new(Owner) class'DecalLifetimeDataAge';
		//LifetimeData.LifeSpan = 99999.0;
		//Impact.HitActor.AddDecal(DecalMaterial,Impact.HitLocation,rotator(-Impact.HitNormal),Rand(40)-20, DecalWidth,DecalHeight,20,false,HitInfo.HitComponent,/*LifetimeData*/None, true, false, HitInfo.BoneName, HitInfo.Item, HitInfo.LevelIndex);
		WorldInfo.MyDecalManager.SpawnDecal(DecalMaterial,Impact.HitLocation,rotator(-Impact.HitNormal),DecalWidth,DecalHeight,20,false,Rand(40)-20, HitInfo.HitComponent, true, false, HitInfo.BoneName, HitInfo.Item, HitInfo.LevelIndex);
		if (Action.DamageType == none)
			return;
	}

	if (Impact.HitInfo.PhysMaterial == none)
		Impact.HitInfo.PhysMaterial = DefaultPhysMaterial;

	PhysMaterial = TPPhysicalMaterial(Impact.HitInfo.PhysMaterial);

	PhysMaterial.SpawnImpactParticles( Action.DamageType, Impact );

	PhysMaterial.PlayImpactSound( Action.DamageType, self, Impact.HitLocation );
}

state Firing
{
	function Tick(float dt)
	{
		FireTimer += dt;
		
		if (RefireTimer < FireTimer)
		{
			SpawnEffect();
			FireCount++;
			FireTimer = 0;
		}

		if (FireCount >= Action.NumberOfRounds)
			GotoState('');
	}
}

