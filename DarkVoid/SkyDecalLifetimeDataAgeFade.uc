class SkyDecalLifetimeDataAgeFade extends DecalLifetimeDataAge;

var float FadeTime;

function MaterialInstanceConstant CreateMatInstance(Object NewOuter, MaterialInterface NewMaterial)
{
    local MaterialInstanceConstant MatInst;

    MatInst = new (NewOuter) Class'Engine.MaterialInstanceConstant';
    // End:0x9E
    if(MatInst != none)
    {
        MatInst.SetParent(NewMaterial);
        MatInst.SetScalarParameterValue('DecalFade_0to1', 0.0000000);
        MatInst.SetScalarParameterValue('DecalFade_1to0', 1.0000000);
        MatInst.SetScalarParameterValue('DecalLife', 0.0000000);
    }
    return MatInst;
    //return ReturnValue;    
}
