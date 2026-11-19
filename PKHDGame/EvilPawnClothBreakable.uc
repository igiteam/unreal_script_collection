class EvilPawnClothBreakable extends EvilPawnClothAsset
    config(Engine)
    editinlinenew
    hidecategories(Object);

var() StaticMesh DropStaticMesh;
var() name DropBoneName;
var() PhysicalMaterial NewPhysicalMaterial;
var() bool bNeverDropClothAsset;

function Vector GetSpawnPosition()
{
    local EvilPawn P;
    local Vector ret;
    local int OrientationBodyIndex;
    local Matrix BodyTM;

    ret = GetPosition();
    P = EvilPawn(Owner);
    // End:0x1E4
    if(P != none)
    {
        // End:0x185
        if((int(P.Physics) == int(10)) && DropBoneName != 'None')
        {
            OrientationBodyIndex = P.Mesh.PhysicsAsset.FindBodyIndex(DropBoneName);
            // End:0x182
            if(OrientationBodyIndex != -1)
            {
                BodyTM = P.Mesh.PhysicsAssetInstance.Bodies[OrientationBodyIndex].GetUnrealWorldTM();
                ret = MatrixGetOrigin(BodyTM);                
            }            
        }
        else
        {
            // End:0x1E4
            if(DropBoneName != 'None')
            {
                ret = P.Mesh.GetBoneLocation(DropBoneName);
            }
        }
    }
    return ret;
    //return ReturnValue;    
}

function TryDropOnZeroHealth(class<DamageType> DamageType, Vector HitLocation, Vector Momentum)
{
    local KActorFromSkeletal KAct;
    local KActor Kact_;

    // End:0x2C3
    if((FRand() < ZeroHealthFactor) && !bNeverDropClothAsset)
    {
        // End:0x8A
        if((int(SpecialClothActionOnZeroHealth) != int(0)) && EvilPawn(Owner) != none)
        {
            EvilPawn(Owner).DoSpecialClothActionOnZeroHealth(SpecialClothActionOnZeroHealth, EvilPawnClothAssetInterface(self));
        }
        // End:0x110
        if(DestroyParticle != none)
        {
            Owner.WorldInfo.MyEmitterPool.SpawnEmitter(DestroyParticle, GetSpawnPosition(), GetRotation());
            DetachFromAny();            
        }
        else
        {
            // End:0x211
            if(DropStaticMesh != none)
            {
                Kact_ = MakeDynamicFromStaticMesh(DropStaticMesh);
                // End:0x188
                if(NewPhysicalMaterial != none)
                {
                    Kact_.StaticMeshComponent.SetPhysMaterialOverride(NewPhysicalMaterial);
                }
                Kact_.StaticMeshComponent.WakeRigidBody();
                Kact_.StaticMeshComponent.AddImpulse(Momentum / float(1000), HitLocation);                
            }
            else
            {
                KAct = MakeDynamic(self);
                // End:0x272
                if(NewPhysicalMaterial != none)
                {
                    KAct.SkelMesh.SetPhysMaterialOverride(NewPhysicalMaterial);
                }
                KAct.SkelMesh.AddImpulse(Momentum / float(1000), HitLocation);
            }
        }
    }
    //return;    
}

function TryDropOnRagdoll(class<DamageType> DamageType, Vector HitLocation, Vector Momentum, bool bPlayingDeath)
{
    local KActorSpawnable Kact_;
    local KActorFromSkeletal KAct;

    // End:0x281
    if(((FRand() < RagdollFactor) || bPlayingDeath) && !bNeverDropClothAsset)
    {
        // End:0xAA
        if(((int(SpecialClothActionOnRagdoll) != int(0)) && EvilPawn(Owner) != none) && !bPlayingDeath)
        {
            EvilPawn(Owner).DoSpecialClothActionOnRagdoll(SpecialClothActionOnRagdoll, EvilPawnClothAssetInterface(self));
        }
        // End:0x1CF
        if(DropStaticMesh != none)
        {
            Kact_ = MakeDynamicFromStaticMesh(DropStaticMesh);
            Kact_.StaticMeshComponent.WakeRigidBody();
            Kact_.StaticMeshComponent.AddImpulse(Momentum / float(1000), HitLocation);
            // End:0x1A8
            if(NewPhysicalMaterial != none)
            {
                Kact_.StaticMeshComponent.SetPhysMaterialOverride(NewPhysicalMaterial);
            }
            Kact_.LifeSpan = 10.0000000;            
        }
        else
        {
            KAct = MakeDynamic(self);
            // End:0x230
            if(NewPhysicalMaterial != none)
            {
                KAct.SkelMesh.SetPhysMaterialOverride(NewPhysicalMaterial);
            }
            KAct.SkelMesh.AddImpulse(Momentum / float(1000), HitLocation);
        }
    }
    //return;    
}

function KActorSpawnable MakeDynamicFromStaticMesh(StaticMesh NewMesh)
{
    local KActorSpawnable ret;

    ret = Owner.Spawn(Class'Engine.KActorSpawnable',,, GetSpawnPosition());
    ret.SetCollision(true, false, true);
    ret.StaticMeshComponent.SetTraceBlocking(false, false);
    ret.SetStaticMesh(NewMesh);
    DetachFromAny();
    return ret;
    //return ReturnValue;    
}

function KActorFromSkeletal MakeDynamic(SkeletalMeshComponent MovableMesh)
{
    local KActorFromSkeletal ret;

    ret = MovableMesh.Owner.Spawn(Class'KActorFromSkeletal',,, GetSpawnPosition(), MovableMesh.GetRotation());
    MovableMesh.Owner.DetachComponent(MovableMesh);
    MovableMesh.SetParentAnimComponent(none);
    MovableMesh.SetShadowParent(none);
    ret.SkelMesh = MovableMesh;
    MovableMesh.SetPhysicsAsset(MovableMesh.default.PhysicsAsset);
    ret.AttachComponent(MovableMesh);
    ret.CollisionComponent = MovableMesh;
    MovableMesh.SetHasPhysicsAssetInstance(true);
    ret.SetPhysics(10);
    return ret;
    //return ReturnValue;    
}

defaultproperties
{
    PhysicsWeight=1.0000000
    bUpdateSkelWhenNotRendered=false
    bHasPhysicsAssetInstance=true
    ReplacementPrimitive=none
    CollideActors=true
    BlockActors=true
    BlockZeroExtent=true
    BlockNonZeroExtent=true
    BlockRigidBody=true
    RBCollideWithChannels=(Default=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true,BlockingVolume=true)
}