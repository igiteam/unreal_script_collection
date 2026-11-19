class SkyAnimNodeSequenceByBoneRotation extends SkyAnimNodeSequence
    native
    editinlinenew;

struct native AnimByRotation
{
    var() Rotator DesiredRotation;
    var() name AnimName;

    structdefaultproperties
    {
        DesiredRotation=(Pitch=0,Yaw=0,Roll=0)
        AnimName="None"
    }
};

var() name BoneName;
var() Object.EAxis BoneAxis;
var() array<AnimByRotation> AnimList;

event OnBecomeRelevant()
{
    local Vector BoneDirection;
    local int I;
    local float Diff, BestDiff;
    local name BestAnim;

    // End:0x18
    if(SkelComponent.Owner == none)
    {        
    }
    else
    {
        // End:0x3D
        if((int(BoneAxis) == int(0)) || int(BoneAxis) == int(3))
        {            
        }
        else
        {
            BoneDirection = SkelComponent.GetBoneAxis(BoneName, BoneAxis);
            BestDiff = -1.0000000;
            I = 0;
            J0x6F:

            // End:0xE4 [Loop If]
            if(I < AnimList.Length)
            {
                Diff = BoneDirection Dot Vector(AnimList[I].DesiredRotation);
                // End:0xDA
                if(Diff > BestDiff)
                {
                    BestAnim = AnimList[I].AnimName;
                    BestDiff = Diff;
                }
                I++;
                // [Loop Continue]
                goto J0x6F;
            }
            SetAnim(BestAnim);
            SetPosition(0.0000000, false);
            // End:0x140
            if(SkyPawn(SkelComponent.Owner) != none)
            {
                SkyPawn(SkelComponent.Owner).SequenceByBoneRotationOnBecomeRelevant();
            }
        }
    }
    //return;    
}
