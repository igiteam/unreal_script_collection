class SkyCorpse extends KAsset
    native;

var() const editconst export editinline LightEnvironmentComponent LightEnvironment;
var(Mesh) export editinline SkeletalMeshComponent LegMesh;
var(Mesh) export editinline SkeletalMeshComponent HeadMesh;
var(Mesh) export editinline SkeletalMeshComponent HairMesh;
var(Mesh) array<BodyParts> PossibleHairMeshes;
var(Mesh) array<BodyParts> PossibleBodyMeshes;
var(Mesh) array<BodyParts> PossibleLegsMeshes;
var(Mesh) array<HeadMorphs> PossibleHeadMorphs;
var name HeadMorphName;
var transient int HeadMorphIndex;
var(Mesh) SkeletalMesh HeadSkelMesh;
var init transient array<init MaterialInstanceConstant> MatInstConsts;
var transient MaterialInstanceConstant ActiveMaterialInstanceConstant;

simulated event bool PickFaceMorph()
{
    local int I, J;
    local float maxRand, curRand;

    // End:0x0E
    if(PossibleHeadMorphs.Length <= 0)
    {
        return false;
    }
    maxRand = 0.0000000;
    I = 0;
    J0x20:

    // End:0x57 [Loop If]
    if(I < PossibleHeadMorphs.Length)
    {
        maxRand += PossibleHeadMorphs[I].Chance;
        I++;
        // [Loop Continue]
        goto J0x20;
    }
    curRand = FRand() * maxRand;
    I = 0;
    J0x6D:

    // End:0x1AB [Loop If]
    if(I < PossibleHeadMorphs.Length)
    {
        // End:0x184
        if(curRand <= PossibleHeadMorphs[I].Chance)
        {
            HeadMorphName = PossibleHeadMorphs[I].MorphNodeName;
            J = 0;
            J0xC0:

            // End:0x142 [Loop If]
            if(J < PossibleHeadMorphs[I].MorphMaterials.Length)
            {
                // End:0x138
                if(PossibleHeadMorphs[I].MorphMaterials[J] != none)
                {
                    HeadMesh.SetMaterial(J, PossibleHeadMorphs[I].MorphMaterials[J]);
                }
                J++;
                // [Loop Continue]
                goto J0xC0;
            }
            HeadMorphIndex = I;
            // End:0x182
            if((HeadMesh != none) && HeadMorphName != 'None')
            {
                HeadMesh.BaseMorphTargetName = HeadMorphName;
            }
            return true;
        }
        curRand -= PossibleHeadMorphs[I].Chance;
        I++;
        // [Loop Continue]
        goto J0x6D;
    }
    //return ReturnValue;    
}

event CreateMaterialInstanceConstant(SkeletalMeshComponent OwnerMesh)
{
    local int NewIdx, I, NumMaterials;
    local MaterialInterface MatInterface;

    // End:0x15F
    if((OwnerMesh != none) && OwnerMesh.SkeletalMesh != none)
    {
        NumMaterials = OwnerMesh.SkeletalMesh.Materials.Length;
        NewIdx = MatInstConsts.Add(NumMaterials);
        I = 0;
        J0x5A:

        // End:0x15F [Loop If]
        if(I < NumMaterials)
        {
            MatInstConsts[NewIdx + I] = new (Outer) Class'Engine.MaterialInstanceConstant';
            // End:0xDF
            if((I < OwnerMesh.Materials.Length) && OwnerMesh.Materials[I] != none)
            {
                MatInterface = OwnerMesh.Materials[I];                
            }
            else
            {
                MatInterface = OwnerMesh.SkeletalMesh.Materials[I];
            }
            MatInstConsts[NewIdx + I].SetParent(MatInterface);
            OwnerMesh.SetMaterial(I, MatInstConsts[NewIdx + I]);
            ++I;
            // [Loop Continue]
            goto J0x5A;
        }
    }
    //return;    
}

// Export USkyCorpse::execSetupParentAnim(FFrame&, void* const)
native function SetupParentAnim(SkeletalMeshComponent Comp);

simulated event PostBeginPlay()
{
    local int HairIdx;
    local array<BodyParts> CombinedHairMeshes;
    local int I;

    // End:0x21
    if(PossibleBodyMeshes.Length > 0)
    {
        PickBodyPartMesh(SkeletalMeshComponent, PossibleBodyMeshes);
    }
    // End:0x41
    if(LegMesh != none)
    {
        PickBodyPartMesh(LegMesh, PossibleLegsMeshes);
    }
    SkeletalMeshComponent.MorphChildComponent = HeadMesh;
    PickFaceMorph();
    // End:0x181
    if(HairMesh != none)
    {
        CombinedHairMeshes.Add(PossibleHairMeshes.Length);
        // End:0xB1
        if((HeadMorphIndex >= 0) && HeadMorphIndex < PossibleHeadMorphs.Length)
        {
            CombinedHairMeshes.Add(PossibleHeadMorphs[HeadMorphIndex].AdditionalPossibleHairMeshes.Length);
        }
        I = 0;
        J0xB8:

        // End:0xE9 [Loop If]
        if(I < PossibleHairMeshes.Length)
        {
            CombinedHairMeshes[I] = PossibleHairMeshes[I];
            I++;
            // [Loop Continue]
            goto J0xB8;
        }
        // End:0x168
        if((HeadMorphIndex >= 0) && HeadMorphIndex < PossibleHeadMorphs.Length)
        {
            I = 0;
            J0x10D:

            // End:0x168 [Loop If]
            if(I < PossibleHeadMorphs[HeadMorphIndex].AdditionalPossibleHairMeshes.Length)
            {
                CombinedHairMeshes[PossibleHairMeshes.Length + I] = PossibleHeadMorphs[HeadMorphIndex].AdditionalPossibleHairMeshes[I];
                I++;
                // [Loop Continue]
                goto J0x10D;
            }
        }
        PickBodyPartMesh(HairMesh, CombinedHairMeshes, HairIdx);
    }
    // End:0x201
    if(LightEnvironment != none)
    {
        SkeletalMeshComponent.SetLightEnvironment(LightEnvironment);
        // End:0x1C1
        if(HeadMesh != none)
        {
            HeadMesh.SetLightEnvironment(LightEnvironment);
        }
        // End:0x1E1
        if(LegMesh != none)
        {
            LegMesh.SetLightEnvironment(LightEnvironment);
        }
        // End:0x201
        if(HairMesh != none)
        {
            HairMesh.SetLightEnvironment(LightEnvironment);
        }
    }
    // End:0x221
    if(LegMesh != none)
    {
        LegMesh.SetShadowParent(SkeletalMeshComponent);
    }
    // End:0x241
    if(HeadMesh != none)
    {
        HeadMesh.SetShadowParent(SkeletalMeshComponent);
    }
    // End:0x261
    if(HairMesh != none)
    {
        HairMesh.SetShadowParent(SkeletalMeshComponent);
    }
    SkeletalMeshComponent.CastShadow = true;
    SkeletalMeshComponent.bCastDynamicShadow = true;
    // End:0x2B4
    if(LegMesh != none)
    {
        LegMesh.CastShadow = true;
        LegMesh.bCastDynamicShadow = true;
    }
    // End:0x2E3
    if(HairMesh != none)
    {
        HairMesh.CastShadow = true;
        HairMesh.bCastDynamicShadow = true;
    }
    // End:0x312
    if(HeadMesh != none)
    {
        HeadMesh.CastShadow = true;
        HeadMesh.bCastDynamicShadow = true;
    }
    SetupParentAnim(HeadMesh);
    SetupParentAnim(LegMesh);
    // End:0x429
    if(HairMesh != none)
    {
        // End:0x3C1
        if((HairIdx < PossibleHairMeshes.Length) && PossibleHairMeshes[HairIdx].Socket != 'None')
        {
            HairMesh.SetParentAnimComponent(none);
            HairMesh.bTransformFromAnimParent = 0;
            SkeletalMeshComponent.AttachComponentToSocket(HairMesh, PossibleHairMeshes[HairIdx].Socket);            
        }
        else
        {
            SetupParentAnim(HairMesh);
        }
        // End:0x429
        if((HairIdx < PossibleHairMeshes.Length) && PossibleHairMeshes[HairIdx].PhysAsset != none)
        {
            HairMesh.EnablePhysics(PossibleHairMeshes[HairIdx].PhysAsset, 1.0000000);
        }
    }
    ActiveMaterialInstanceConstant = MaterialInstanceConstant(SkeletalMeshComponent.GetMaterial(0));
    CreateMaterialInstanceConstant(SkeletalMeshComponent);
    CreateMaterialInstanceConstant(LegMesh);
    CreateMaterialInstanceConstant(HairMesh);
    CreateMaterialInstanceConstant(HeadMesh);
    super.PostBeginPlay();
    //return;    
}

simulated function PickBodyPartMesh(SkeletalMeshComponent InOutMesh, array<BodyParts> PossibleMeshes, optional out int MeshIdx)
{
    local int I, J;
    local float maxRand, curRand;

    // End:0x0F
    if(PossibleMeshes.Length <= 0)
    {
        return;
    }
    maxRand = 0.0000000;
    I = 0;
    J0x21:

    // End:0x58 [Loop If]
    if(I < PossibleMeshes.Length)
    {
        maxRand += PossibleMeshes[I].Chance;
        I++;
        // [Loop Continue]
        goto J0x21;
    }
    curRand = FRand() * maxRand;
    I = 0;
    J0x6E:

    // End:0x161 [Loop If]
    if(I < PossibleMeshes.Length)
    {
        // End:0x13A
        if(curRand <= PossibleMeshes[I].Chance)
        {
            MeshIdx = I;
            InOutMesh.SetSkeletalMesh(PossibleMeshes[I].SkelMesh);
            J = 0;
            J0xD8:

            // End:0x138 [Loop If]
            if(J < PossibleMeshes[I].MeshMaterials.Length)
            {
                InOutMesh.SetMaterial(J, PossibleMeshes[I].MeshMaterials[J]);
                ++J;
                // [Loop Continue]
                goto J0xD8;
            }
            return;
        }
        curRand -= PossibleMeshes[I].Chance;
        I++;
        // [Loop Continue]
        goto J0x6E;
    }
    //return;    
}
