class MOHASkelControlPeekLean extends SkelControlBase
    native
    hidecategories(Object);

struct native IronsightLeanBoneData
{
    var() name BoneName;
    var int BoneIndex;
    var int BoneMotionOffset;
    var int BoneAdj;
    var() int BoneMotionTolerance;
    var bool bInMotion;

    structdefaultproperties
    {
        BoneName="None"
        BoneIndex=0
        BoneMotionOffset=0
        BoneAdj=0
        BoneMotionTolerance=0
        bInMotion=false
    }
};

var(Lean) array<IronsightLeanBoneData> LeanData;
var(Lean) array<IronsightLeanBoneData> VerticalLeanData;
var transient bool bInitialized;
var transient bool bDormant;
//var delegate<OwnerNotification> __OwnerNotification__Delegate;

delegate OwnerNotification(name BoneName, int Offset)
{
    //return;    
}

function Reset(int NewRoll)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x54 [Loop If]
    if(I < LeanData.Length)
    {
        LeanData[I].BoneMotionOffset = NewRoll;
        LeanData[I].bInMotion = false;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    I = 0;
    J0x5B:

    // End:0xA8 [Loop If]
    if(I < VerticalLeanData.Length)
    {
        VerticalLeanData[I].BoneMotionOffset = NewRoll;
        VerticalLeanData[I].bInMotion = false;
        I++;
        // [Loop Continue]
        goto J0x5B;
    }
    //return;    
}

function ResetAbove(name BoneName, int NewRoll)
{
    local int I, J;

    I = 0;
    J0x07:

    // End:0xA0 [Loop If]
    if(I < LeanData.Length)
    {
        // End:0x96
        if(LeanData[I].BoneName == BoneName)
        {
            J = I;
            J = I;
            J0x4C:

            // End:0x94 [Loop If]
            if(J >= 0)
            {
                LeanData[J].BoneMotionOffset = NewRoll;
                LeanData[J].bInMotion = false;
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
    I = 0;
    J0xA7:

    // End:0x140 [Loop If]
    if(I < VerticalLeanData.Length)
    {
        // End:0x136
        if(VerticalLeanData[I].BoneName == BoneName)
        {
            J = I;
            J = I;
            J0xEC:

            // End:0x134 [Loop If]
            if(J >= 0)
            {
                VerticalLeanData[J].BoneMotionOffset = NewRoll;
                VerticalLeanData[J].bInMotion = false;
                J--;
                // [Loop Continue]
                goto J0xEC;
            }
            return;
        }
        I++;
        // [Loop Continue]
        goto J0xA7;
    }
    //return;    
}

defaultproperties
{
    LeanData[0]=(BoneName="Neck",BoneIndex=0,BoneMotionOffset=0,BoneAdj=0,BoneMotionTolerance=4096,bInMotion=false)
    LeanData[1]=(BoneName="Spine2",BoneIndex=0,BoneMotionOffset=0,BoneAdj=0,BoneMotionTolerance=4096,bInMotion=false)
    LeanData[2]=(BoneName="Spine1",BoneIndex=0,BoneMotionOffset=0,BoneAdj=0,BoneMotionTolerance=6144,bInMotion=false)
    LeanData[3]=(BoneName="Spine",BoneIndex=0,BoneMotionOffset=0,BoneAdj=0,BoneMotionTolerance=4096,bInMotion=false)
    LeanData[4]=(BoneName="Hips",BoneIndex=0,BoneMotionOffset=0,BoneAdj=0,BoneMotionTolerance=0,bInMotion=false)
    VerticalLeanData[0]=(BoneName="Neck",BoneIndex=0,BoneMotionOffset=0,BoneAdj=0,BoneMotionTolerance=-4096,bInMotion=false)
    VerticalLeanData[1]=(BoneName="Spine2",BoneIndex=0,BoneMotionOffset=0,BoneAdj=0,BoneMotionTolerance=-8096,bInMotion=false)
    VerticalLeanData[2]=(BoneName="Spine1",BoneIndex=0,BoneMotionOffset=0,BoneAdj=0,BoneMotionTolerance=4048,bInMotion=false)
    VerticalLeanData[3]=(BoneName="Spine",BoneIndex=0,BoneMotionOffset=0,BoneAdj=0,BoneMotionTolerance=8096,bInMotion=false)
    VerticalLeanData[4]=(BoneName="LeftArm",BoneIndex=0,BoneMotionOffset=0,BoneAdj=0,BoneMotionTolerance=-8096,bInMotion=false)
    VerticalLeanData[5]=(BoneName="RightArm",BoneIndex=0,BoneMotionOffset=0,BoneAdj=0,BoneMotionTolerance=-8096,bInMotion=false)
    VerticalLeanData[6]=(BoneName="Hips",BoneIndex=0,BoneMotionOffset=0,BoneAdj=0,BoneMotionTolerance=0,bInMotion=false)
}