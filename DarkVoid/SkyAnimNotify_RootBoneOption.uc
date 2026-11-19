class SkyAnimNotify_RootBoneOption extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool RootBoneChangeX;
var() bool RootBoneChangeY;
var() bool RootBoneChangeZ;
var() AnimNodeSequence.ERootBoneAxis RootBoneOption[3];

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    // End:0x22
    if(RootBoneChangeX)
    {
        AnimSeqInstigator.RootBoneOption[0] = RootBoneOption[0];
    }
    // End:0x44
    if(RootBoneChangeY)
    {
        AnimSeqInstigator.RootBoneOption[1] = RootBoneOption[1];
    }
    // End:0x68
    if(RootBoneChangeZ)
    {
        AnimSeqInstigator.RootBoneOption[2] = RootBoneOption[2];
    }
    //return;    
}
