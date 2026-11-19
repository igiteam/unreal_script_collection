class EvilKAsset extends KAsset
    native(Physics)
    nativereplication
    hidecategories(Navigation)
    classgroup(Physics);

var() name AnimationName;
var() array<name> FixedBodies;

function EnableRagdoll(bool bEnable)
{
    // End:0xD4
    if(bEnable)
    {
        // End:0xD4
        if(int(Physics) != int(10))
        {
            SkeletalMeshComponent.bUpdateKinematicBonesFromAnimation = false;
            SetPhysics(10);
            SkeletalMeshComponent.PhysicsWeight = 1.0000000;
            SkeletalMeshComponent.WakeRigidBody();
            SkeletalMeshComponent.PhysicsAssetInstance.SetNamedBodiesFixed(true, FixedBodies, SkeletalMeshComponent);
        }
    }
    //return;    
}

simulated event PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    SkeletalMeshComponent.PlayAnim(AnimationName, 0.0000000, true);
    // End:0x53
    if(bWakeOnLevelStart)
    {
        EnableRagdoll(true);
    }
    ReplicatedMesh = SkeletalMeshComponent.SkeletalMesh;
    ReplicatedPhysAsset = SkeletalMeshComponent.PhysicsAsset;
    //return;    
}

simulated event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local Vector ApplyImpulse;

    EnableRagdoll(true);
    super(Actor).TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    // End:0x18A
    if(bDamageAppliesImpulse && DamageType.default.KDamageImpulse > float(0))
    {
        // End:0xA2
        if(VSize(Momentum) < 0.0010000)
        {
            return;
        }
        CheckHitInfo(HitInfo, SkeletalMeshComponent, Normal(Momentum), HitLocation);
        ApplyImpulse = Normal(Momentum) * DamageType.default.KDamageImpulse;
        // End:0x18A
        if(HitInfo.HitComponent != none)
        {
            HitInfo.HitComponent.AddImpulse(ApplyImpulse, HitLocation, HitInfo.BoneName);
        }
    }
    //return;    
}

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0000000)
{
    // End:0xCF
    if((bDamageAppliesImpulse && DamageType.default.RadialDamageImpulse > float(0)) && int(Role) == int(ROLE_Authority))
    {
        EnableRagdoll(true);
        CollisionComponent.AddRadialImpulse(HurtOrigin, DamageRadius, DamageType.default.RadialDamageImpulse, 1, DamageType.default.bRadialDamageVelChange);
    }
    //return;    
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x42
    if(Action.InputLinks[0].bHasImpulse)
    {
        EnableRagdoll(true);
    }
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__EvilKAsset.KAssetSkelMeshComponent'
    begin object name=KAssetSkelMeshComponent
        Animations=AnimNodeSequence'Default__EvilKAsset.AnimNodeSeq0'
        PhysicsWeight=0.0000000
        bSkipAllUpdateWhenPhysicsAsleep=false
        bUpdateKinematicBonesFromAnimation=true
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilKAsset.MyLightEnvironment'
    end object
    SkeletalMeshComponent=KAssetSkelMeshComponent
    // Reference: DynamicLightEnvironmentComponent'Default__EvilKAsset.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[0]=MyLightEnvironment
    Components[1]=KAssetSkelMeshComponent
    Components[2]=KAssetSkelMeshComponent
    Physics=EPhysics.PHYS_Flying
    CollisionComponent=KAssetSkelMeshComponent
}