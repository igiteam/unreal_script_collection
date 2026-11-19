class EvilPawnClothAssetSM extends StaticMeshComponent
    editinlinenew
    hidecategories(Object)
    implements(EvilPawnClothAssetInterface);

var() EvilTypes.EClothAssetSpecialActionOnTakeDamage SpecialClothActionOnTakeDamage;
var() EvilTypes.EClothAssetSpecialActionOnZeroHealth SpecialClothActionOnZeroHealth;
var() EvilTypes.EClothAssetSpecialActionOnRagdoll SpecialClothActionOnRagdoll;
var() bool bInheritLightEnvironmentFromPawn;
var() bool bDisableDynamic;
var() bool bDestroyOnDestroyParticle;
var() bool bUseDestroyParticleOnRagdoll;
var() bool bAttachDestroyParticle;
var() bool bCreateAndSetConstMaterials;
var() int Health;
var() int HealthStep;
var int LastHealthStep;
var() array<DecalData> DecalMaterials;
var() ParticleSystem HealthStepParticle;
var() ParticleSystem DestroyParticle;
var() SoundCue DestroySound;
var() float DamageScaleFactor;
var() float ZeroHealthFactor;
var() float RagdollFactor;
var() array<MaterialInterface> RandomMaterials;
var() name SocketName;
var() name ParticleBoneOrSocketName;
var() export editinline ParticleSystemComponent ParticleComponent;
var EvilLightActor LightActor;
var() EvilLightActor LightActorArchetype;
var() array<MaterialInstanceConstant> MaterialsInstances;
var EvilPawnClothingAssetReplicator Replicator;

simulated function Object ObjectGetObjectArchetype()
{
    return ObjectArchetype;
    //return ReturnValue;    
}

simulated function bool PreValidateMaterials(EvilPawn P)
{
    //return ReturnValue;    
}

simulated function bool ValidateComponent(EvilPawn P, const out array<EvilPawnClothAssetInterface> validateAssets)
{
    return true;
    //return ReturnValue;    
}

function int GetHealth()
{
    return Health;
    //return ReturnValue;    
}

function int GetMaxHealth()
{
    return default.Health;
    //return ReturnValue;    
}

function ISetMaterial(int ElementIndex, MaterialInterface Mat)
{
    SetMaterial(ElementIndex, Mat);
    //return;    
}

function ISetMaterialFromRandomMaterials(int ElementIndex)
{
    SetMaterial(0, RandomMaterials[ElementIndex]);
    //return;    
}

function int GetRandomMaterialsAmount()
{
    return RandomMaterials.Length;
    //return ReturnValue;    
}

function ReduceDamage(out int Damage, class<DamageType> DamageType, Vector HitLocation, Vector Momentum)
{
    local bool bGenerateHealthStep;
    local int decalIndex;

    // End:0x7F
    if((EvilPawn(Owner) != none) && EvilPawn(Owner).bIsInvulnerable || !EvilPawn(Owner).bSpawnDone)
    {
        Damage = 0;
    }
    Health -= Damage;
    Damage *= DamageScaleFactor;
    bGenerateHealthStep = false;
    // End:0x350
    if((int(SpecialClothActionOnTakeDamage) != int(0)) && EvilPawn(Owner) != none)
    {
        // End:0x2BD
        if((LastHealthStep - Health) > HealthStep)
        {
            bGenerateHealthStep = true;
            // End:0x188
            if(HealthStepParticle != none)
            {
                Owner.WorldInfo.MyEmitterPool.SpawnEmitter(HealthStepParticle, GetPosition(), GetRotation());
            }
            // End:0x2AA
            if(bAcceptsDynamicDecals && DecalMaterials.Length > 0)
            {
                decalIndex = Rand(DecalMaterials.Length);
                EvilPawn(Owner).WorldInfo.MyDecalManager.SpawnDecal(DecalMaterials[decalIndex].DecalMaterial, HitLocation, Rotator(Momentum), 20.0000000, DecalMaterials[decalIndex].Width, DecalMaterials[decalIndex].Height, false,, self, false, false,,,, 999.0000000);
            }
            LastHealthStep = Health;
        }
        // End:0x30B
        if(Replicator != none)
        {
            Replicator.DoSpecialClothActionOnTakeDamage(SpecialClothActionOnTakeDamage, EvilPawnClothAssetInterface(self), bGenerateHealthStep);            
        }
        else
        {
            EvilPawn(Owner).DoSpecialClothActionOnTakeDamage(SpecialClothActionOnTakeDamage, EvilPawnClothAssetInterface(self), bGenerateHealthStep);
        }
    }
    // End:0x3EC
    if(Health <= 0)
    {
        Damage -= Health;
        TryDropOnZeroHealth(DamageType, HitLocation, Momentum);
        // End:0x3EC
        if(Replicator != none)
        {
            Replicator.TryDropOnZeroHealth(DamageType, HitLocation, Momentum, EvilPawnClothAssetInterface(self));
        }
    }
    //return;    
}

simulated function TryDropOnZeroHealth(class<DamageType> DamageType, Vector HitLocation, Vector Momentum, optional bool bForce)
{
    local EvilKActorFromStatic KAct;
    local editinline ParticleSystemComponent PSC;

    // End:0x294
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
        // End:0x25E
        if(DestroyParticle != none)
        {
            // End:0x130
            if(DestroySound != none)
            {
                Owner.PlaySound(DestroySound,,,, GetPosition());
            }
            PSC = Owner.WorldInfo.MyEmitterPool.SpawnEmitter(DestroyParticle, GetPosition(), GetRotation());
            // End:0x244
            if((((PSC != none) && EvilPawn(Owner) != none) && bAttachDestroyParticle) && SocketName != 'None')
            {
                EvilPawn(Owner).Mesh.AttachComponentToSocket(PSC, SocketName);
            }
            // End:0x25B
            if(bDestroyOnDestroyParticle)
            {
                DetachFromAny();
            }            
        }
        else
        {
            KAct = MakeDynamic(self);
            KAct.RemoteRole = ROLE_None;
        }
    }
    //return;    
}

simulated function TryDropOnRagdoll(class<DamageType> DamageType, Vector HitLocation, Vector Momentum, bool bPlayingDeath, optional bool bForce)
{
    local EvilKActorFromStatic KAct;
    local editinline ParticleSystemComponent PSC;

    // End:0x2CD
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
        // End:0x297
        if((DestroyParticle != none) && bUseDestroyParticleOnRagdoll)
        {
            // End:0x169
            if(DestroySound != none)
            {
                Owner.PlaySound(DestroySound,,,, GetPosition());
            }
            PSC = Owner.WorldInfo.MyEmitterPool.SpawnEmitter(DestroyParticle, GetPosition(), GetRotation());
            // End:0x27D
            if((((PSC != none) && EvilPawn(Owner) != none) && bAttachDestroyParticle) && SocketName != 'None')
            {
                EvilPawn(Owner).Mesh.AttachComponentToSocket(PSC, SocketName);
            }
            // End:0x294
            if(bDestroyOnDestroyParticle)
            {
                DetachFromAny();
            }            
        }
        else
        {
            KAct = MakeDynamic(self);
            KAct.RemoteRole = ROLE_None;
        }
    }
    //return;    
}

simulated function SetScalarParameterForMaterials(name InParamName, float InValue)
{
    local int I, numElems;

    // End:0x8F
    if(bCreateAndSetConstMaterials)
    {
        numElems = GetNumElements();
        I = 0;
        J0x2C:

        // End:0x8C [Loop If]
        if(I < numElems)
        {
            MaterialsInstances[I].SetScalarParameterValue(InParamName, InValue);
            ++I;
            // [Loop Continue]
            goto J0x2C;
        }        
    }
    //return;    
}

simulated function PostAttachComponent()
{
    local int I, numElems;
    local EvilPawn PawnOwner;

    numElems = GetNumElements();
    // End:0x71
    if(bCreateAndSetConstMaterials)
    {
        I = 0;
        J0x2C:

        // End:0x71 [Loop If]
        if(I < numElems)
        {
            MaterialsInstances.AddItem(CreateAndSetMaterialInstanceConstant(I));            
            ++I;
            // [Loop Continue]
            goto J0x2C;
        }
    }
    LastHealthStep = Health;
    PawnOwner = EvilPawn(Owner);
    // End:0xD8
    if(PawnOwner != none)
    {
        PawnOwner.PostAttachedClothComponent(EvilPawnClothAssetInterface(self));
    }
    //return;    
}

simulated function AttachCloth(EvilPawn P)
{
    // End:0x35
    if(bInheritLightEnvironmentFromPawn)
    {
        SetLightEnvironment(P.LightEnvironment);
    }
    SetShadowParent(P.Mesh);
    // End:0xB5
    if(SocketName != 'None')
    {
        P.Mesh.AttachComponentToSocket(self, SocketName);        
    }
    else
    {
        P.AttachComponent(self);
    }
    PostAttachComponent();
    //return;    
}

function EvilKActorFromStatic MakeDynamic(StaticMeshComponent MovableMesh)
{
    local EvilKActorFromStatic ret;

    // End:0x0F
    if(bDisableDynamic)
    {
        return none;
    }
    ret = MovableMesh.Owner.Spawn(Class'EvilKActorFromStatic',,, MovableMesh.GetPosition(), MovableMesh.GetRotation());
    ret.SetCollision(true, false);
    ret.bDamageAppliesImpulse = false;
    ret.SetStaticMesh(MovableMesh.StaticMesh);
    TransferDecalsToOtherComponent(ret.StaticMeshComponent);
    ret.CollisionComponent.WakeRigidBody();
    ret.SetPhysics(10);
    DetachFromAny();
    return ret;
    //return ReturnValue;    
}

simulated function SetReplicator(EvilPawnClothingAssetReplicator InEvilPawnClothingAssetReplicator)
{
    Replicator = InEvilPawnClothingAssetReplicator;
    //return;    
}

simulated function EvilPawnClothingAssetReplicator GetReplicator()
{
    return Replicator;
    //return ReturnValue;    
}

simulated function Object GetObject()
{
    return self;
    //return ReturnValue;    
}

simulated function bool IsShield()
{
    return ((int(SpecialClothActionOnTakeDamage) == int(1)) || int(SpecialClothActionOnRagdoll) == int(1)) || int(SpecialClothActionOnZeroHealth) == int(1);
    //return ReturnValue;    
}

simulated function bool IsHeart()
{
    return (int(SpecialClothActionOnZeroHealth) == int(5)) || int(SpecialClothActionOnRagdoll) == int(3);
    //return ReturnValue;    
}

defaultproperties
{
    bInheritLightEnvironmentFromPawn=true
    bDestroyOnDestroyParticle=true
    bUseDestroyParticleOnRagdoll=true
    Health=100
    DamageScaleFactor=1.0000000
    ZeroHealthFactor=-1.0000000
    RagdollFactor=-1.0000000
    WireframeColor=(R=0,G=255,B=128,A=255)
    ReplacementPrimitive=none
    RBChannel=ERBCollisionChannel.RBCC_GameplayPhysics
    BlockActors=false
    bBlockFootPlacement=false
    RBCollideWithChannels=(Default=true,GameplayPhysics=true,EffectPhysics=true,BlockingVolume=true)
}