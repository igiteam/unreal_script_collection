class EvilAnimDef extends AnimDefProxy
    native(Anim);

var() EvilAnimDef ParentAnimDef;
var() array<AnimSet> AnimSets;
var() array<AnimDefInfo> AnimDefsList;
var() array<EvilFaceFXEmotionInfo> FaceFXEmotionList;

// Export UEvilAnimDef::execGetAnimCount(FFrame&, void* const)
native final function int GetAnimCount(EvilTypesNative.EAnimationSetType InAnimType);

// Export UEvilAnimDef::execGetAnimDefInfo(FFrame&, void* const)
native final function bool GetAnimDefInfo(EvilTypesNative.EAnimationSetType InAnimType, out AnimDefInfo OutAnimDefInfo);

function bool GetFaceFXEmotionInfo(EvilTypesNative.EFaceFXEmotionSetType InAnimType, out EvilFaceFXEmotionInfo FaceFXEmotionInfo)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x88 [Loop If]
    if(I < FaceFXEmotionList.Length)
    {
        // End:0x7A
        if(int(FaceFXEmotionList[I].FaceFXEmotionSetType) == int(InAnimType))
        {
            FaceFXEmotionInfo = FaceFXEmotionList[I];
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    return false;
    //return ReturnValue;    
}

function int GetFaceFXEmotionAnimCount(EvilTypesNative.EFaceFXEmotionSetType InAnimType)
{
    local EvilFaceFXEmotionInfo FaceFXEmotionInfo;

    GetFaceFXEmotionInfo(InAnimType, FaceFXEmotionInfo);
    return FaceFXEmotionInfo.FaceFXAnimInfoList.Length;
    //return ReturnValue;    
}
