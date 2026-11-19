class SeqAct_AttachMainHeroHead extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() export editinline EvilPawnClothAsset Head;
var() SkeletalMeshActor MainHero;
var() SkeletalMesh BaseSkeletalMesh;

event Activated()
{
    local int I;
    local array<int> HiddenMaterialIndices;

    // End:0x30C
    if(((MainHero != none) && Head != none) && BaseSkeletalMesh != none)
    {
        I = 0;
        J0x3C:

        // End:0x10F [Loop If]
        if(I < MainHero.SkeletalMeshComponent.LODInfo[0].HiddenMaterials.Length)
        {
            // End:0x101
            if(MainHero.SkeletalMeshComponent.LODInfo[0].HiddenMaterials[I] == true)
            {
                HiddenMaterialIndices.AddItem(I);
            }
            I++;
            // [Loop Continue]
            goto J0x3C;
        }
        Head.SetLightEnvironment(MainHero.LightEnvironment);
        Head.SetSkeletalMesh(BaseSkeletalMesh);
        MainHero.SkeletalMeshComponent.SetSkeletalMesh(Head.default.SkeletalMesh);
        MainHero.ReattachComponent(MainHero.SkeletalMeshComponent);
        Head.SetShadowParent(MainHero.SkeletalMeshComponent);
        Head.SetParentAnimComponent(MainHero.SkeletalMeshComponent);
        MainHero.AttachComponent(Head);
        I = 0;
        J0x2B2:

        // End:0x30C [Loop If]
        if(I < HiddenMaterialIndices.Length)
        {
            Head.ShowMaterialSection(HiddenMaterialIndices[I], false, 0);
            I++;
            // [Loop Continue]
            goto J0x2B2;
        }
    }
    //return;    
}

defaultproperties
{
    bCallHandler=false
    ObjName="Attach MainHero Head"
}