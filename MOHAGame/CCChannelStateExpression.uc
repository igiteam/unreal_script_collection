class CCChannelStateExpression extends CCChannelState
    native
    hidecategories(Object,Object);

function PostBeginPlay(CCPerformanceState InPS, int TeamIndex)
{
    local editinline SkeletalMeshComponent OwnerMesh;

    super.PostBeginPlay(InPS, TeamIndex);
    OwnerMesh = PS.CCP.Owner_GetSkeletalMeshComponent();
    // End:0x7D
    if(none != OwnerMesh)
    {
        CCDirector(PS.CCP.GetCCDirector()).DeclareFaceFXRegisters(OwnerMesh);
        OwnerMesh.SetAllowFaceFXNonAnimTick(true);
    }
    //return;    
}

function BeginKey(int KeyIndex, float PerformanceLocalTime_sec)
{
    local CCKeyExpression Key;
    local editinline SkeletalMeshComponent OwnerMesh;

    OwnerMesh = PS.CCP.Owner_GetSkeletalMeshComponent();
    // End:0xA0
    if(none != OwnerMesh)
    {
        Key = CCKeyExpression(CurrentKeys[KeyIndex]);
        // End:0xA0
        if((none != Key) && Key.ExpressionName != "")
        {
            OwnerMesh.SetFaceFXRegister(Key.ExpressionName, Key.Strength, 2, Key.EaseInTime_sec);
        }
    }
    //return;    
}

function EndKey(int KeyIndex, float PerformanceLocalTime_sec)
{
    local CCKeyExpression Key;
    local editinline SkeletalMeshComponent OwnerMesh;

    OwnerMesh = PS.CCP.Owner_GetSkeletalMeshComponent();
    // End:0x97
    if(none != OwnerMesh)
    {
        Key = CCKeyExpression(CurrentKeys[KeyIndex]);
        // End:0x97
        if((none != Key) && Key.ExpressionName != "")
        {
            OwnerMesh.SetFaceFXRegister(Key.ExpressionName, 0.0000000, 2, Key.EaseOutTime_sec);
        }
    }
    //return;    
}
