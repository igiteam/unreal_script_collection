class CCChannelStatePALookAt extends CCChannelState
    native
    hidecategories(Object,Object);

var SkelControlLookAtRules LAControl;
var SkelControlPA PAControl;

function PostBeginPlay(CCPerformanceState InPS, int TeamIndex)
{
    super.PostBeginPlay(InPS, TeamIndex);
    InitializeSkelControls();
    //return;    
}

function InitializeSkelControls()
{
    local editinline SkeletalMeshComponent OwnerMesh;

    // End:0x1A
    if((LAControl != none) || PAControl != none)
    {
        return;
    }
    OwnerMesh = PS.CCP.Owner_GetSkeletalMeshComponent();
    // End:0x103
    if(none != OwnerMesh)
    {
        LAControl = SkelControlLookAtRules(OwnerMesh.FindSkelControl('LA'));
        PAControl = none;
        // End:0x103
        if(none != LAControl)
        {
            LAControl.PostBeginPlay(PS.CCP);
            LAControl.SetSkelControlActive(true);
            PAControl = SkelControlPA(OwnerMesh.FindSkelControl(LAControl.PAControlName));
            // End:0x103
            if(none != PAControl)
            {
                PAControl.PostBeginPlay();
                PAControl.SetSkelControlActive(true);
            }
        }
    }
    //return;    
}

event float StartChannel(CCChannel Channel, float StartTime_sec)
{
    InitializeSkelControls();
    return super.StartChannel(Channel, StartTime_sec);
    //return ReturnValue;    
}

function BeginKey(int KeyIndex, float PerformanceLocalTime_sec)
{
    local CCKeyPALookAt Key;

    // End:0x72
    if(none != LAControl)
    {
        Key = CCKeyPALookAt(CurrentKeys[KeyIndex]);
        // End:0x62
        if((none != Key) && none != Key.LookAtRule)
        {
            LAControl.LookAtRule = Key.LookAtRule;            
        }
        else
        {
            LAControl.LookAtRule = none;
        }
    }
    //return;    
}

function EndKey(int KeyIndex_UNUSED, float PerformanceLocalTime_sec)
{
    // End:0x1B
    if(none != LAControl)
    {
        LAControl.LookAtRule = none;
    }
    //return;    
}
