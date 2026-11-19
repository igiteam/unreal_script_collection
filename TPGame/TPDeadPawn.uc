class TPDeadPawn extends KAsset
    native;

struct native FixedBoneType
{
    var() bool bEnable;
    var() name BoneName;
};

var() float                   NewLifeSpan;
var() float                   FreezeTime;
var() array<FixedBoneType>	  FixedBoneNames;
var   array<name>	          FixedBones;


simulated function PostBeginPlay()
{
    local int i;
    local int j;

	Super.PostBeginPlay();
    
    LifeSpan=NewLifeSpan;

    j = 0;
    FixedBones.Length = 0;
    for(i = 0; i < FixedBoneNames.Length; i++)
    {
        if (FixedBoneNames[i].bEnable)
        {
            FixedBones[j] = FixedBoneNames[i].BoneName;
            j++;
        }
    }

    if (j > 0)
    {
        SkeletalMeshComponent.PhysicsAssetInstance.SetNamedBodiesFixed(true,FixedBones,SkeletalMeshComponent,true);
    }
}

event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    SetPhysics(PHYS_RigidBody);

    if (FixedBones.Length > 0)
        SkeletalMeshComponent.PhysicsAssetInstance.SetNamedBodiesFixed(true,FixedBones,SkeletalMeshComponent,true);

	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

    if (FreezeTime > 0)
    {
        ClearTimer('StopTwitching');
        SetTimer  (FreezeTime,,'StopTwitching');
    }
}

simulated function TakeRadiusDamage
(
	Controller			InstigatedBy,
	float				BaseDamage,
	float				DamageRadius,
	class<DamageType>	DamageType,
	float				Momentum,
	vector				HurtOrigin,
	bool				bFullDamage,
	Actor DamageCauser
)
{
    SetPhysics(PHYS_RigidBody);

    if (FixedBones.Length > 0)
        SkeletalMeshComponent.PhysicsAssetInstance.SetNamedBodiesFixed(true,FixedBones,SkeletalMeshComponent,true);

    Super.TakeRadiusDamage (InstigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser);

    if (FreezeTime > 0)
    {
        ClearTimer('StopTwitching');
        SetTimer  (FreezeTime,,'StopTwitching');
    }
}

function StopTwitching()
{
    SetPhysics(PHYS_None);
}

