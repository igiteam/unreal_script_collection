class MOHASkelControlTwistLean extends SkelControlBase
    native
    hidecategories(Object);

struct native TwistBoneData
{
    var() name BoneName;
    var int BoneIndex;
    var int BoneYawOffset;
    var int BoneAdj;
    var int BoneYawTolerance;
    var bool bInMotion;

    structdefaultproperties
    {
        BoneName="None"
        BoneIndex=0
        BoneYawOffset=0
        BoneAdj=0
        BoneYawTolerance=0
        bInMotion=false
    }
};

struct native LeanBoneData
{
    var() name BoneName;
    var() int BonePitchLowerTolerance;
    var() int BonePitchUpperTolerance;
    var int BoneIndex;

    structdefaultproperties
    {
        BoneName="None"
        BonePitchLowerTolerance=0
        BonePitchUpperTolerance=0
        BoneIndex=0
    }
};

var(Twist) array<TwistBoneData> TwistData;
var(Twist) array<LeanBoneData> LeanData;
var transient int HeadYaw;
var transient int LastHeadYaw;
var transient float LastZeroed;
var transient bool bInitialized;
var transient bool bDormant;
var bool bForcedLookAt;
var bool bRecentering;
var Vector ForceFocalPoint;
var Actor ForceFocalActor;
var string debugstr;
//var delegate<OwnerNotification> __OwnerNotification__Delegate;

delegate OwnerNotification(name BoneName, int Offset)
{
    //return;    
}

function Reset(int NewYaw)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x54 [Loop If]
    if(I < TwistData.Length)
    {
        TwistData[I].BoneYawOffset = NewYaw;
        TwistData[I].bInMotion = false;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function ResetAbove(name BoneName, int NewYaw)
{
    local int I, J;

    I = 0;
    J0x07:

    // End:0xA0 [Loop If]
    if(I < TwistData.Length)
    {
        // End:0x96
        if(TwistData[I].BoneName == BoneName)
        {
            J = I;
            J = I;
            J0x4C:

            // End:0x94 [Loop If]
            if(J >= 0)
            {
                TwistData[J].BoneYawOffset = NewYaw;
                TwistData[J].bInMotion = false;
                J--;
                // [Loop Continue]
                goto J0x4C;
            }
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function int Fix(int Num)
{
    Num = Num & 65535;
    // End:0x2D
    if(Num > 32767)
    {
        Num -= 65535;
    }
    return Num;
    //return ReturnValue;    
}

simulated function TwistDisplayDebug(HUD HUD, out float out_YL, out float out_YPos, MOHAPawn PawnOwner)
{
    local int I, X, Y;

    HUD.Canvas.SetDrawColor(byte(255), byte(2255), 200);
    HUD.Canvas.SetPos(4.0000000, out_YPos);
    out_YPos += out_YL;
    I = 0;
    J0x5B:

    // End:0x23A [Loop If]
    if(I < TwistData.Length)
    {
        HUD.Canvas.SetPos(4.0000000, out_YPos);
        // End:0xE2
        if(I > 0)
        {
            X = TwistData[I - 1].BoneYawOffset - TwistData[I].BoneYawOffset;
            Y = X & 65535;            
        }
        else
        {
            X = 0;
            Y = 0;
        }
        HUD.Canvas.__NFUN_465__(((((((((((((((("  [" $ string(TwistData[I].BoneName)) $ " (") $ string(TwistData[I].BoneIndex)) $ ") ] Yaw:") @ string(TwistData[I].BoneYawOffset)) @ "(") $ string(Fix(TwistData[I].BoneYawOffset))) $ ")  Adj:") @ string(Fix(TwistData[I].BoneAdj))) @ "  Tol:") @ string(Fix(TwistData[I].BoneYawTolerance))) @ "  [") $ string(TwistData[I].bInMotion)) $ "]") @ string(X)) @ string(Y));
        out_YPos += out_YL;
        I++;
        // [Loop Continue]
        goto J0x5B;
    }
    // End:0x34C
    if(bForcedLookAt)
    {
        // End:0x2D3
        if(ForceFocalActor != none)
        {
            HUD.Canvas.SetPos(4.0000000, out_YPos);
            HUD.Canvas.__NFUN_465__((("  [FORCED] " @ string(ForceFocalActor)) @ ":") @ string(Rotator(ForceFocalActor.Location - PawnOwner.Location).Yaw));            
        }
        else
        {
            HUD.Canvas.SetPos(4.0000000, out_YPos);
            HUD.Canvas.__NFUN_465__((("  [FORCED] " @ string(ForceFocalPoint)) @ ":") @ string(Rotator(PawnOwner.Location - ForceFocalPoint).Yaw));
        }
    }
    //return;    
}

simulated function ForceLookAt(optional Actor FocalActor, optional Vector FocalPoint)
{
    bForcedLookAt = true;
    ForceFocalPoint = FocalPoint;
    ForceFocalActor = FocalActor;
    //return;    
}

simulated function UnlockLook()
{
    bRecentering = true;
    //return;    
}

defaultproperties
{
    TwistData[0]=(BoneName="Spine2",BoneIndex=0,BoneYawOffset=0,BoneAdj=0,BoneYawTolerance=0,bInMotion=false)
    TwistData[1]=(BoneName="Spine1",BoneIndex=0,BoneYawOffset=0,BoneAdj=0,BoneYawTolerance=3072,bInMotion=false)
    TwistData[2]=(BoneName="Spine",BoneIndex=0,BoneYawOffset=0,BoneAdj=0,BoneYawTolerance=2048,bInMotion=false)
    TwistData[3]=(BoneName="Hips",BoneIndex=0,BoneYawOffset=0,BoneAdj=0,BoneYawTolerance=1024,bInMotion=false)
    LeanData[0]=(BoneName="Neck",BonePitchLowerTolerance=-6144,BonePitchUpperTolerance=6144,BoneIndex=0)
    LeanData[1]=(BoneName="Spine2",BonePitchLowerTolerance=-4096,BonePitchUpperTolerance=2048,BoneIndex=0)
    LeanData[2]=(BoneName="LeftArm",BonePitchLowerTolerance=-2048,BonePitchUpperTolerance=6144,BoneIndex=0)
    LeanData[3]=(BoneName="RightArm",BonePitchLowerTolerance=-2048,BonePitchUpperTolerance=6144,BoneIndex=0)
    LeanData[4]=(BoneName="LeftShoulder",BonePitchLowerTolerance=-2048,BonePitchUpperTolerance=6144,BoneIndex=0)
    LeanData[5]=(BoneName="RightShoulder",BonePitchLowerTolerance=-2048,BonePitchUpperTolerance=6144,BoneIndex=0)
}