class EvilPawnClothAsset extends SkeletalMeshComponent
    config(Engine)
    editinlinenew
    hidecategories(Object)
    implements(EvilPawnClothAssetInterface);

var() const EvilTypes.EClothAssetSpecialActionOnTakeDamage SpecialClothActionOnTakeDamage;
var() const EvilTypes.EClothAssetSpecialActionOnZeroHealth SpecialClothActionOnZeroHealth;
var() const EvilTypes.EClothAssetSpecialActionOnRagdoll SpecialClothActionOnRagdoll;
var() const bool bInheritLightEnvironmentFromPawn;
var() bool bCreateAndSetConstMaterials;
var() bool bHideRandomMaterials;
var() bool bGetBaseSkeletalMeshFromFamilyInfo;
var() bool bSwitchBaseSkeletalmesh;
var() const int HealthStep;
var int LastHealthStep;
var() int Health;
var() const float DamageScaleFactor;
var() const float ZeroHealthFactor;
var() const float RagdollFactor;
var() const array<int> AlwaysHiddenMaterialsIndices;
var() const array<MaterialInterface> RandomMaterials;
var() const name SocketName;
var() const name ParticleBoneOrSocketName;
var() export editinline ParticleSystemComponent ParticleComponent;
var EvilLightActor LightActor;
var() EvilLightActor LightActorArchetype;
var() array<MaterialInstanceConstant> MaterialsInstances;
var() ParticleSystem HealthStepParticle;
var() ParticleSystem DestroyParticle;
var() array<int> RelyOnParentMaterialIndices;
var() array<EvilPawnClothAssetInterface> RelyOnClothAssets;

simulated function Object ObjectGetObjectArchetype()
{
    return ObjectArchetype;
    //return ReturnValue;    
}

simulated function bool PreValidateMaterials(EvilPawn P)
{
    local bool bValidIndex, bMaterialIsHidden, bResult;
    local int I;

    bResult = true;
    // End:0x168
    if(RelyOnParentMaterialIndices.Length > 0)
    {
        I = 0;
        J0x27:

        // End:0x168 [Loop If]
        if((I < RelyOnParentMaterialIndices.Length) && bResult == true)
        {
            bValidIndex = P.GetSkeletalMeshComponent().LODInfo[0].HiddenMaterials.Length > RelyOnParentMaterialIndices[I];
            // End:0x130
            if(bValidIndex)
            {
                bMaterialIsHidden = P.GetSkeletalMeshComponent().LODInfo[0].HiddenMaterials[RelyOnParentMaterialIndices[I]];
            }
            // End:0x15A
            if(!bValidIndex || bMaterialIsHidden)
            {
                bResult = false;
            }
            I++;
            // [Loop Continue]
            goto J0x27;
        }
    }
    return bResult;
    //return ReturnValue;    
}

simulated function bool ValidateComponent(EvilPawn P, const out array<EvilPawnClothAssetInterface> validateAssets)
{
    local int I, J;
    local bool bResultFromMaterials, bResultFromRelyingClothAssets;

    bResultFromMaterials = PreValidateMaterials(P);
    // End:0x120
    if(bResultFromMaterials)
    {
        // End:0x114
        if(RelyOnClothAssets.Length > 0)
        {
            J = 0;
            J0x46:

            // End:0x111 [Loop If]
            if((J < RelyOnClothAssets.Length) && bResultFromRelyingClothAssets == false)
            {
                I = 0;
                J0x7B:

                // End:0x103 [Loop If]
                if((I < validateAssets.Length) && bResultFromRelyingClothAssets == false)
                {
                    // End:0xF5
                    if(validateAssets[I].ObjectGetObjectArchetype() == RelyOnClothAssets[J])
                    {
                        bResultFromRelyingClothAssets = true;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x7B;
                }
                J++;
                // [Loop Continue]
                goto J0x46;
            }            
        }
        else
        {
            bResultFromRelyingClothAssets = true;
        }
    }
    // End:0x14A
    if(!bResultFromMaterials || !bResultFromRelyingClothAssets)
    {
        DetachFromAny();
    }
    return bResultFromMaterials && bResultFromRelyingClothAssets;
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

    Health -= Damage;
    Damage *= DamageScaleFactor;
    bGenerateHealthStep = false;
    // End:0x161
    if((int(SpecialClothActionOnTakeDamage) != int(0)) && EvilPawn(Owner) != none)
    {
        // End:0x11C
        if((LastHealthStep - Health) > HealthStep)
        {
            // End:0xFD
            if(HealthStepParticle != none)
            {
                Owner.WorldInfo.MyEmitterPool.SpawnEmitter(HealthStepParticle, GetPosition(), GetRotation());
            }
            bGenerateHealthStep = true;
            LastHealthStep = Health;
        }
        EvilPawn(Owner).DoSpecialClothActionOnTakeDamage(SpecialClothActionOnTakeDamage, EvilPawnClothAssetInterface(self), bGenerateHealthStep);
    }
    // End:0x1A9
    if(Health <= 0)
    {
        Damage -= Health;
        TryDropOnZeroHealth(DamageType, HitLocation, Momentum);
    }
    //return;    
}

function TryDropOnZeroHealth(class<DamageType> DamageType, Vector HitLocation, Vector Momentum)
{
    //return;    
}

function TryDropOnRagdoll(class<DamageType> DamageType, Vector HitLocation, Vector Momentum, bool bPlayingDeath)
{
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
    local int I, visibleMaterials;

    visibleMaterials = 0;
    // End:0x89
    if(bHideRandomMaterials)
    {
        I = 0;
        J0x23:

        // End:0x78 [Loop If]
        if(I < (GetNumElements()))
        {
            // End:0x5F
            if(FRand() > 0.5000000)
            {
                ShowMaterialSection(I, false, 0);                
            }
            else
            {
                visibleMaterials++;
            }
            I++;
            // [Loop Continue]
            goto J0x23;
        }
        // End:0x89
        if(visibleMaterials == 0)
        {
            return;
        }
    }
    I = 0;
    J0x94:

    // End:0xD9 [Loop If]
    if(I < AlwaysHiddenMaterialsIndices.Length)
    {
        ShowMaterialSection(AlwaysHiddenMaterialsIndices[I], false, 0);
        I++;
        // [Loop Continue]
        goto J0x94;
    }
    // End:0x10E
    if(bInheritLightEnvironmentFromPawn)
    {
        SetLightEnvironment(P.LightEnvironment);
    }
    SetShadowParent(P.Mesh);
    // End:0x25B
    if(SocketName != 'None')
    {
        P.Mesh.AttachComponentToSocket(self, SocketName);
        // End:0x1B6
        if(ParticleComponent != none)
        {
            AttachComponentToSocket(ParticleComponent, ParticleBoneOrSocketName);
        }
        // End:0x258
        if(LightActorArchetype != none)
        {
            LightActor = P.Spawn(Class'EvilLightActor', P,,,, LightActorArchetype);
            LightActor.SetBase(P,, self, ParticleBoneOrSocketName);
            LightActor.Activate();
        }        
    }
    else
    {
        // End:0x4F4
        if(bSwitchBaseSkeletalmesh)
        {
            // End:0x387
            if(bGetBaseSkeletalMeshFromFamilyInfo)
            {
                SetSkeletalMesh(P.static.GetFamilyInfo().default.CharacterMesh);
                P.Mesh.SetSkeletalMesh(default.SkeletalMesh);
                P.Mesh.SkeletalMesh.Sockets = P.static.GetFamilyInfo().default.CharacterMesh.Sockets;                
            }
            else
            {
                SetSkeletalMesh(P.Mesh.default.SkeletalMesh);
                P.Mesh.SetSkeletalMesh(default.SkeletalMesh);
                P.Mesh.SkeletalMesh.Sockets = P.Mesh.default.SkeletalMesh.Sockets;
            }
            P.BaseSkeletalMeshComp = self;
            P.HeadSkeletalMeshComp = P.Mesh;            
        }
        SetParentAnimComponent(P.Mesh);
        P.AttachComponent(self);
        // End:0x56A
        if(ParticleComponent != none)
        {
            AttachComponent(ParticleComponent, ParticleBoneOrSocketName);
        }
    }
    PostAttachComponent();
    //return;    
}

defaultproperties
{
    bInheritLightEnvironmentFromPawn=true
    Health=100
    DamageScaleFactor=1.0000000
    ZeroHealthFactor=-1.0000000
    RagdollFactor=-1.0000000
    bUseBoundsFromParentAnimComponent=true
    ReplacementPrimitive=none
}