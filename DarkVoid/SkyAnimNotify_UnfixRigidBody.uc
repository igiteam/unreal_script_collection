class SkyAnimNotify_UnfixRigidBody extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() name Bone;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local Pawn P;
    local RB_BodyInstance BodyInst;

    P = Pawn(Owner);
    // End:0x51
    if(P != none)
    {
        BodyInst = P.Mesh.FindBodyInstanceNamed(Bone);
        BodyInst.SetFixed(false);
    }
    //return;    
}
