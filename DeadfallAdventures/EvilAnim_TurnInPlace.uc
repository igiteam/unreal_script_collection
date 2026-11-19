class EvilAnim_TurnInPlace extends AnimNodeBlend
    native(Anim)
    hidecategories(Object,Object,Object,Object);

enum EOwnerType
{
    EOT_Owner,                      // 0
    EOT_Base,                       // 1
    EOT_MAX                         // 2
};

struct native RotTransitionInfo
{
    var() float RotationOffset;
    var() name TransName;

    structdefaultproperties
    {
        RotationOffset=0.0000000
        TransName="None"
    }
};

var const transient bool bInitialized;
var const transient bool bRootRotInitialized;
var() bool bDelayBlendOutToPlayAnim;
var() const bool bUseAimOffsets;
var const bool bPlayingTurnTransition;
var() bool bEnableSmallTurns;
var() bool bAutoRealign;
var const transient bool bRealigning;
var transient int LastPawnYaw;
var const transient int LastDesiredYaw;
var const transient float PawnRotationRate;
var const transient int LastRootBoneYaw;
var() const transient int YawOffset;
var const transient float RelativeOffset;
var const transient EvilPawn EvilPawnOwner;
var const transient EvilPawn CachedBaseEvilPawn;
var() EvilAnim_TurnInPlace.EOwnerType OwnerType;
var array<EvilAnim_AimOffset> OffsetNodes;
var const transient SkelControlSingleBone SpineRotator;
var() array<RotTransitionInfo> RotTransitions;
var() float TransitionBlendInTime;
var() float TransitionBlendOutTime;
var const int CurrentTransitionIndex;
var() float TransitionThresholdAngle;
var array<EvilAnim_TurnInPlace_Player> PlayerNodes;
var() float SmallTurnThresholdRate;
var const transient int LastYawToFocus;
var() float AutoRealignTimeout;
var() int AutoRealignThreshold;
var const transient float LastActionTime;

// Export UEvilAnim_TurnInPlace::execSetUseAimOffsets(FFrame&, void* const)
native final function SetUseAimOffsets(bool bNewUseAimOffsets);

static function bool CheckAimNode(EvilPawn P, out AnimNodeAimOffset AimNode)
{
    local AnimNodeAimOffset TempAimNode;

    // End:0x85
    if((P.RelevantAimNode != none) && P.RelevantAimNode.bRelevant)
    {
        AimNode = P.RelevantAimNode;
    }
    // End:0x13F
    if(AimNode == none)
    {
        // End:0xF6
        foreach P.EvilAimNodes(TempAimNode)
        {
            // End:0xF5
            if(TempAimNode.bRelevant)
            {
                AimNode = TempAimNode;
            }            
        }        
        // End:0x13F
        if(AimNode == none)
        {
            AimNode = P.AimNode;
            // End:0x13F
            if(AimNode == none)
            {
                return false;
            }
        }
    }
    return true;
    //return ReturnValue;    
}

static function int CheckYawDelta(EvilPawn P, int DesiredYaw, optional out AnimNodeAimOffset AimNode)
{
    CheckAimNode(P, AimNode);
    return NormalizeRotAxis(DesiredYaw - P.Rotation.Yaw);
    //return ReturnValue;    
}

static function int CheckPitchDelta(EvilPawn P, int DesiredPitch, optional out AnimNodeAimOffset AimNode)
{
    return NormalizeRotAxis(DesiredPitch - P.Rotation.Pitch);
    //return ReturnValue;    
}

function int GetYawRate()
{
    local EvilAnim_TurnInPlace_Player TIPP;
    local float YawDelta;

    // End:0x41
    if(!bPlayingTurnTransition)
    {
        return EvilPawnOwner.default.RotationRate.Yaw;
    }
    YawDelta = float(NormalizeRotAxis(EvilPawnOwner.DesiredRotation.Yaw - EvilPawnOwner.Rotation.Yaw));
    // End:0x1A7
    foreach PlayerNodes(TIPP)
    {
        // End:0x146
        if((!TIPP.bPlaying || !TIPP.bRelevant) || TIPP.AnimSeq == none)
        {
            continue;            
        }
        else
        {            
            return FCeil(FMax(YawDelta, Abs(RotTransitions[CurrentTransitionIndex].RotationOffset)) / TIPP.GetAnimPlaybackLength());            
        }
    }    
    return EvilPawnOwner.default.RotationRate.Yaw;
    //return ReturnValue;    
}

defaultproperties
{
    bUseAimOffsets=true
    bEnableSmallTurns=true
    RotTransitions[0]=(RotationOffset=16384.0000000,TransName="Rt_90")
    RotTransitions[1]=(RotationOffset=32768.0000000,TransName="Rt_180")
    RotTransitions[2]=(RotationOffset=-16384.0000000,TransName="Lt_90")
    RotTransitions[3]=(RotationOffset=-32768.0000000,TransName="Lt_180")
    TransitionBlendInTime=0.1500000
    TransitionBlendOutTime=0.1500000
    TransitionThresholdAngle=4096.0000000
    SmallTurnThresholdRate=32768.0000000
    AutoRealignThreshold=1024
    Children=/* Array type was not detected. */
    BlendType=AlphaBlendType.ABT_Cubic
}