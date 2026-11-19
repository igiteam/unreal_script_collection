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

simulated function TryDropOnZeroHealth(class<DamageType> DamageType, Vector HitLocation, Vector Momentum, optional bool bForce)
{
    local KActorFromSkeletal KAct;
    local KActor Kact_;

    // End:0x3AB
    if((FRand() < ZeroHealthFactor) || bForce)
    {
        // End:0x73
        if(Replicator != none)
        {
            Replicator.TryDropOnZeroHealth(DamageType, HitLocation, Momentum, EvilPawnClothAssetInterface(self));
        }
        // End:0xDC
        if((int(SpecialClothActionOnZeroHealth) != int(0)) && EvilPawn(Owner) != none)
        {
            EvilPawn(Owner).DoSpecialClothActionOnZeroHealth(SpecialClothActionOnZeroHealth, EvilPawnClothAssetInterface(self));
        }
        // End:0x1A7
        if(DestroyParticle != none)
        {
            // End:0x130
            if(DestroySound != none)
            {
                Owner.PlaySound(DestroySound,,,, GetPosition());
            }
            Owner.WorldInfo.MyEmitterPool.SpawnEmitter(DestroyParticle, GetSpawnPosition(), GetRotation());
            DetachFromAny();            
        }
        else
        {
            // End:0x3AB
            if(!bNeverDropClothAsset)
            {
                // End:0x2D8
                if(DropStaticMesh != none)
                {
                    Kact_ = MakeDynamicFromStaticMesh(DropStaticMesh);
                    Kact_.RemoteRole = ROLE_None;
                    // End:0x24F
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
                    KAct.RemoteRole = ROLE_None;
                    // End:0x35A
                    if(NewPhysicalMaterial != none)
                    {
                        KAct.SkelMesh.SetPhysMaterialOverride(NewPhysicalMaterial);
                    }
                    KAct.SkelMesh.AddImpulse(Momentum / float(1000), HitLocation);
                }
            }
        }
    }
    //return;    
}

simulated function TryDropOnRagdoll(class<DamageType> DamageType, Vector HitLocation, Vector Momentum, bool bPlayingDeath, optional bool bForce)
{
    local KActorSpawnable Kact_;
    local KActorFromSkeletal KAct;

    // End:0x32E
    if(((FRand() < RagdollFactor) || bPlayingDeath) || bForce)
    {
        // End:0x8C
        if(Replicator != none)
        {
            Replicator.TryDropOnRagdoll(DamageType, HitLocation, Momentum, bPlayingDeath, EvilPawnClothAssetInterface(self));
        }
        // End:0x106
        if(((int(SpecialClothActionOnRagdoll) != int(0)) && EvilPawn(Owner) != none) && !bPlayingDeath)
        {
            EvilPawn(Owner).DoSpecialClothActionOnRagdoll(SpecialClothActionOnRagdoll, EvilPawnClothAssetInterface(self));
        }
        // End:0x32E
        if(!bNeverDropClothAsset)
        {
            // End:0x25B
            if(DropStaticMesh != none)
            {
                Kact_ = MakeDynamicFromStaticMesh(DropStaticMesh);
                Kact_.RemoteRole = ROLE_None;
                Kact_.StaticMeshComponent.WakeRigidBody();
                Kact_.StaticMeshComponent.AddImpulse(Momentum / float(1000), HitLocation);
                // End:0x234
                if(NewPhysicalMaterial != none)
                {
                    Kact_.StaticMeshComponent.SetPhysMaterialOverride(NewPhysicalMaterial);
                }
                Kact_.LifeSpan = 10.0000000;                
            }
            else
            {
                KAct = MakeDynamic(self);
                KAct.RemoteRole = ROLE_None;
                // End:0x2DD
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