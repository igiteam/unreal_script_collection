class PKMaterialAtlas extends Object;

struct PKMaterialAtlasElement
{
    var() PKPawn.EPainMaterialType MaterialType;
    var() Material MaterialReference;

    structdefaultproperties
    {
        MaterialType=EPainMaterialType.PKMT_Default
        MaterialReference=none
    }
};

var() array<PKMaterialAtlasElement> PKMaterialAtlas;

function Material GetBaseMaterial(PKPawn.EPainMaterialType MaterialType)
{
    local int I;
    local Material Mat;

    I = 0;
    J0x0B:

    // End:0x9C [Loop If]
    if(I < PKMaterialAtlas.Length)
    {
        // End:0x8E
        if(int(PKMaterialAtlas[I].MaterialType) == int(MaterialType))
        {
            Mat = PKMaterialAtlas[I].MaterialReference;
            // [Explicit Break]
            goto J0x9C;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    J0x9C:

    return Mat;
    //return ReturnValue;    
}
