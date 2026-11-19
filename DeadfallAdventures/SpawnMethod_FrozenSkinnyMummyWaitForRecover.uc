class SpawnMethod_FrozenSkinnyMummyWaitForRecover extends SpawnMethod_WaitForRecover
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() MaterialInterface FrozenMaterial;
var() StaticMeshActor IceBlock;

function PostCreateActor(Actor NewActor)
{
    local AdvPawn_SkinnyMummy_Base MummyPawn;

    super.PostCreateActor(NewActor);
    MummyPawn = AdvPawn_SkinnyMummy_Base(NewActor);
    // End:0x8F
    if(MummyPawn != none)
    {
        MummyPawn.SetupIceBlockMICArray(IceBlock);
        MummyPawn.SetFrozenEffect(true, FrozenMaterial);
    }
    //return;    
}

defaultproperties
{
    FrozenMaterial=MaterialInstanceConstant'ch_skinny_mummy_01.Materials.mi_ch_skinny_mummy_01Frozen'
    bEnableMotionDelta=true
    bEnableTakeDamage=true
    SightSenseLength=0.0000000
    HearSenseLength=0.0000000
}