class AdvGhostingEffectComponent extends ActorComponent;

struct GhostMesh
{
    var() export editinline SkeletalMeshComponent Mesh;
    var() editconst editinline array<editconst editinline MaterialInstanceConstant> Materials;
    var() export editinline ParticleSystemComponent GhostEffectPSC;

    structdefaultproperties
    {
        Mesh=none
        Materials=none
        GhostEffectPSC=none
    }
};

var() editconst editinline array<editconst editinline GhostMesh> GhostMeshes;
var() int GhostCount;
var() float GhostFadeTime;
var() float GhostInitialOpacity;
var transient bool bGhostingEnabled;
var transient int GhostIndex;
var transient float NextGhostSpawnTime;
var export editinline transient SkeletalMeshComponent OwnerMesh;
var() ParticleSystem GhostEffect;

function CacheOwnerMesh()
{
    local Pawn PawnOwner;
    local SkeletalMeshActor SMAOwner;

    PawnOwner = Pawn(Owner);
    SMAOwner = SkeletalMeshActor(Owner);
    OwnerMesh = ((PawnOwner != none) ? PawnOwner.Mesh : SMAOwner.SkeletalMeshComponent);
    //return;    
}

function Init(SkeletalMeshComponent SkelComp)
{
    local int SavedGhostIndex;
    local editinline SkeletalMeshComponent SMC;
    local GhostMesh GM;

    // End:0x11
    if(Owner == none)
    {
        return;
    }
    SavedGhostIndex = GhostIndex;
    // End:0x30F
    if((GhostMeshes.Length == 0) && GhostCount > 0)
    {
        CacheOwnerMesh();
        GhostIndex = 0;
        J0x5A:

        // End:0x30F [Loop If]
        if(GhostIndex < GhostCount)
        {
            GM.Mesh = none;
            GM.Materials.Length = 0;
            SMC = new (Owner) Class'Engine.SkeletalMeshComponent';
            SMC.SetSkeletalMesh(SkelComp.SkeletalMesh);
            SMC.SetAnimTreeTemplate(AnimTree'adv_fx_Ghosting.Anim.at_SkeletonCopy');
            SMC.bUpdateSkelWhenNotRendered = false;
            SMC.bIgnoreControllersWhenNotRendered = true;
            SMC.bOverrideAttachmentOwnerVisibility = true;
            SMC.SetOwnerNoSee(false);
            SMC.SetOnlyOwnerSee(false);
            SMC.SetAbsolute(true, true, true);
            SMC.SetHidden(true);
            SMC.CastShadow = false;
            SMC.SetLightEnvironment(SkelComp.LightEnvironment);
            GM.Mesh = SMC;
            SetGhostMaterials(GM);
            Owner.AttachComponent(SMC);
            GhostMeshes.AddItem(GM);            
            SetGhostEffects(GhostIndex);
            ++GhostIndex;
            // [Loop Continue]
            goto J0x5A;
        }
    }
    GhostIndex = SavedGhostIndex;
    //return;    
}

function Destroy()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0xBE [Loop If]
    if(I < GhostCount)
    {
        GhostMeshes[I].Mesh.SetHidden(true);
        GhostMeshes[I].Mesh = none;
        GhostMeshes[I].Materials.Length = 0;
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    GhostMeshes.Length = 0;
    OwnerMesh = none;
    //return;    
}

static simulated function bool IsMaterialChildOf(MaterialInterface Child, MaterialInterface Parent)
{
    // End:0x19
    if(Child == Parent)
    {
        return true;
    }
    // End:0xA3
    if(MaterialInstance(Child) != none)
    {
        // End:0x68
        if(MaterialInstance(Child).Parent == Parent)
        {
            return true;
        }
        return IsMaterialChildOf(MaterialInstance(Child).Parent, Parent);
    }
    return false;
    //return ReturnValue;    
}

function SetGhostEffects(int InGhostIndex)
{
    // End:0x11C
    if(GhostEffect != none)
    {
        GhostMeshes[InGhostIndex].GhostEffectPSC = new (self) Class'Engine.ParticleSystemComponent';
        GhostMeshes[InGhostIndex].GhostEffectPSC.SetTemplate(GhostEffect);
        Owner.AttachComponent(GhostMeshes[InGhostIndex].GhostEffectPSC);
        GhostMeshes[InGhostIndex].GhostEffectPSC.SetActorParameter('BoneSocketActor', Owner);
    }
    //return;    
}

function SetGhostMaterials(out GhostMesh GM)
{
    local int I, J;
    local MaterialInstanceConstant Original, MIC;

    I = 0;
    J0x0B:

    // End:0x424 [Loop If]
    if(I < GM.Mesh.GetNumElements())
    {
        Original = MaterialInstanceConstant(GM.Mesh.GetMaterial(I));
        // End:0xAB
        if(Original == none)
        {            
        }
        else
        {
            MIC = new (self) Class'Engine.MaterialInstanceConstant';
            MIC.SetParent(Original);
            J = 0;
            J0xF6:

            // End:0x1C6 [Loop If]
            if(J < Original.ScalarParameterValues.Length)
            {
                MIC.SetScalarParameterValue(Original.ScalarParameterValues[J].ParameterName, Original.ScalarParameterValues[J].ParameterValue);
                ++J;
                // [Loop Continue]
                goto J0xF6;
            }
            J = 0;
            J0x1D1:

            // End:0x2A1 [Loop If]
            if(J < Original.TextureParameterValues.Length)
            {
                MIC.SetTextureParameterValue(Original.TextureParameterValues[J].ParameterName, Original.TextureParameterValues[J].ParameterValue);
                ++J;
                // [Loop Continue]
                goto J0x1D1;
            }
            J = 0;
            J0x2AC:

            // End:0x37C [Loop If]
            if(J < Original.VectorParameterValues.Length)
            {
                MIC.SetVectorParameterValue(Original.VectorParameterValues[J].ParameterName, Original.VectorParameterValues[J].ParameterValue);
                ++J;
                // [Loop Continue]
                goto J0x2AC;
            }
            MIC.SetScalarParameterValue('DissolveAmount', 1.0000000);
            GM.Mesh.SetMaterial(I, MIC);
            GM.Materials.AddItem(MIC);            
        }
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function CreateTeleportTrail(Vector LocationFrom, Vector LocationTo, Rotator RotationFrom, Rotator RotationTo)
{
    local Vector LocationDelta;
    local Rotator RotationDelta;

    // End:0x1AB
    if(GhostCount > 0)
    {
        // End:0x4F
        if(GhostCount == 1)
        {
            LocationDelta = vect(0.0000000, 0.0000000, 0.0000000);
            RotationDelta = MakeRotator(0, 0, 0);            
        }
        else
        {
            LocationDelta = (LocationTo - LocationFrom) / float(GhostCount + 1);
            RotationDelta = (RotationTo - RotationFrom) / float(GhostCount + 1);
        }
        GhostIndex = 0;
        J0xB8:

        // End:0x158 [Loop If]
        if(GhostIndex < GhostCount)
        {
            SpawnGhost((GhostInitialOpacity * float(GhostIndex + 1)) / float(GhostCount), LocationFrom + (LocationDelta * float(GhostIndex + 1)), RotationFrom + (RotationDelta * float(GhostIndex + 1)));
            ++GhostIndex;
            // [Loop Continue]
            goto J0xB8;
        }
        GhostIndex = 0;
        NextGhostSpawnTime = Owner.WorldInfo.TimeSeconds + GhostFadeTime;
    }
    //return;    
}

private final function SpawnGhost(optional float Opacity = GhostInitialOpacity, optional Vector InLocation = Owner.Location + OwnerMesh.Translation, optional Rotator InRotation = Owner.Rotation + OwnerMesh.Rotation, optional float InScale = Owner.DrawScale * OwnerMesh.Scale)
{
    local MaterialInstanceConstant MIC;
    local AdvAnim_SkeletonSnapshot SnapNode;
    local AnimTree AT;

    // End:0xE5
    if(GhostCount < 1)
    {
        return;
    }
    // End:0x107
    if(GhostIndex > GhostCount)
    {
        GhostIndex = 0;
    }
    GhostMeshes[GhostIndex].Mesh.SetHidden(false);
    GhostMeshes[GhostIndex].Mesh.SetTranslation(InLocation);
    GhostMeshes[GhostIndex].Mesh.SetRotation(InRotation);
    GhostMeshes[GhostIndex].Mesh.SetScale(InScale);
    // End:0x279
    foreach GhostMeshes[GhostIndex].Materials(MIC)
    {
        MIC.SetScalarParameterValue('DissolveAmount', Opacity);        
    }    
    AT = AnimTree(GhostMeshes[GhostIndex].Mesh.Animations);
    // End:0x373
    if(AT != none)
    {
        SnapNode = AdvAnim_SkeletonSnapshot(AT.Children[0].Anim);
        // End:0x373
        if(SnapNode != none)
        {
            SnapNode.TakeSnapshot(AnimTree(OwnerMesh.Animations));
        }
    }
    // End:0x403
    if(GhostMeshes[GhostIndex].GhostEffectPSC != none)
    {
        GhostMeshes[GhostIndex].GhostEffectPSC.DeactivateSystem();
        GhostMeshes[GhostIndex].GhostEffectPSC = none;
    }
    SetGhostEffects(GhostIndex);
    // End:0x47F
    if(GhostMeshes[GhostIndex].GhostEffectPSC != none)
    {
        GhostMeshes[GhostIndex].GhostEffectPSC.ActivateSystem();
    }
    //return;    
}

function Tick(float DeltaTime)
{
    local MaterialInstanceConstant MIC;
    local float FadeDelta, F;
    local int I, Index;

    // End:0x19
    if(OwnerMesh == none)
    {
        CacheOwnerMesh();
    }
    // End:0xFC
    if(GhostCount > 0)
    {
        // End:0xFC
        if(Owner.WorldInfo.TimeSeconds >= NextGhostSpawnTime)
        {
            // End:0x84
            if(bGhostingEnabled)
            {
                SpawnGhost();
            }
            // End:0xFC
            if(GhostCount > 0)
            {
                NextGhostSpawnTime = Owner.WorldInfo.TimeSeconds + GhostFadeTime;
                GhostIndex = (GhostIndex + 1) % GhostCount;
            }
        }
    }
    // End:0x2BF
    if(GhostCount > 0)
    {
        FadeDelta = (GhostInitialOpacity * DeltaTime) / (GhostFadeTime * float(GhostCount));
        I = 0;
        J0x14C:

        // End:0x2BF [Loop If]
        if(I < GhostMeshes.Length)
        {
            // End:0x1A6
            if(GhostMeshes[I].Mesh.HiddenGame)
            {                
            }
            else
            {
                // End:0x2B0
                foreach GhostMeshes[I].Materials(MIC)
                {
                    Index = MIC.ScalarParameterValues.Find('ParameterName', 'DissolveAmount');                    
                    // End:0x2AF
                    if(Index >= 0)
                    {
                        F = MIC.ScalarParameterValues[Index].ParameterValue;
                        MIC.SetScalarParameterValue('DissolveAmount', FMax(0.0000000, F - FadeDelta));
                    }                    
                }                
            }
            ++I;
            // [Loop Continue]
            goto J0x14C;
        }
    }
    //return;    
}
