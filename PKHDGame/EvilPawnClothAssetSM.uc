class EvilPawnClothAssetSM extends StaticMeshComponent
    editinlinenew
    hidecategories(Object)
    implements(EvilPawnClothAssetInterface);

var() EvilTypes.EClothAssetSpecialActionOnTakeDamage SpecialClothActionOnTakeDamage;
var() EvilTypes.EClothAssetSpecialActionOnZeroHealth SpecialClothActionOnZeroHealth;
var() EvilTypes.EClothAssetSpecialActionOnRagdoll SpecialClothActionOnRagdoll;
var() bool bInheritLightEnvironmentFromPawn;
var() bool bDisableDynamic;
var() bool bCreateAndSetConstMaterials;
var() int Health;
var() int HealthStep;
var int LastHealthStep;
var() array<DecalData> DecalMaterials;
var() ParticleSystem HealthStepParticle;
var() ParticleSystem DestroyParticle;
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

    Health -= Damage;
    Damage *= DamageScaleFactor;
    bGenerateHealthStep = false;
    // End:0x283
    if((int(SpecialClothActionOnTakeDamage) != int(0)) && EvilPawn(Owner) != none)
    {
        // End:0x23E
        if((LastHealthStep - Health) > HealthStep)
        {
            bGenerateHealthStep = true;
            // End:0x109
            if(HealthStepParticle != none)
            {
                Owner.WorldInfo.MyEmitterPool.SpawnEmitter(HealthStepParticle, GetPosition(), GetRotation());
            }
            // End:0x22B
            if(bAcceptsDynamicDecals && DecalMaterials.Length > 0)
            {
                decalIndex = Rand(DecalMaterials.Length);
                EvilPawn(Owner).WorldInfo.MyDecalManager.SpawnDecal(DecalMaterials[decalIndex].DecalMaterial, HitLocation, Rotator(Momentum), 20.0000000, DecalMaterials[decalIndex].Width, DecalMaterials[decalIndex].Height, false,, self, false, false,,,, 999.0000000);
            }
            LastHealthStep = Health;
        }
        EvilPawn(Owner).DoSpecialClothActionOnTakeDamage(SpecialClothActionOnTakeDamage, EvilPawnClothAssetInterface(self), bGenerateHealthStep);
    }
    // End:0x2CB
    if(Health <= 0)
    {
        Damage -= Health;
        TryDropOnZeroHealth(DamageType, HitLocation, Momentum);
    }
    //return;    
}

function TryDropOnZeroHealth(class<DamageType> DamageType, Vector HitLocation, Vector Momentum)
{
    // End:0x10A
    if(FRand() < ZeroHealthFactor)
    {
        // End:0x79
        if((int(SpecialClothActionOnZeroHealth) != int(0)) && EvilPawn(Owner) != none)
        {
            EvilPawn(Owner).DoSpecialClothActionOnZeroHealth(SpecialClothActionOnZeroHealth, EvilPawnClothAssetInterface(self));
        }
        // End:0xFF
        if(DestroyParticle != none)
        {
            Owner.WorldInfo.MyEmitterPool.SpawnEmitter(DestroyParticle, GetPosition(), GetRotation());
            DetachFromAny();            
        }
        else
        {
            MakeDynamic(self);
        }
    }
    //return;    
}

function TryDropOnRagdoll(class<DamageType> DamageType, Vector HitLocation, Vector Momentum, bool bPlayingDeath)
{
    // End:0x12A
    if((FRand() < RagdollFactor) || bPlayingDeath)
    {
        // End:0x99
        if(((int(SpecialClothActionOnRagdoll) != int(0)) && EvilPawn(Owner) != none) && !bPlayingDeath)
        {
            EvilPawn(Owner).DoSpecialClothActionOnRagdoll(SpecialClothActionOnRagdoll, EvilPawnClothAssetInterface(self));
        }
        // End:0x11F
        if(DestroyParticle != none)
        {
            Owner.WorldInfo.MyEmitterPool.SpawnEmitter(DestroyParticle, GetPosition(), GetRotation());
            DetachFromAny();            
        }
        else
        {
            MakeDynamic(self);
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

defaultproperties
{
    bInheritLightEnvironmentFromPawn=true
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