class SkyAnimNotify_FaceRotTime extends SkyAnimNotify_Reversible
    config(Engine)
    editinlinenew
    collapsecategories;

var() float FaceRotationTime;
var() bool bRestoreToDefault;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn P;

    P = SkyPawn(Owner);
    // End:0x5B
    if(P != none)
    {
        // End:0x46
        if(bRestoreToDefault)
        {
            P.FaceRotationTime = P.default.FaceRotationTime;            
        }
        else
        {
            P.FaceRotationTime = FaceRotationTime;
        }
    }
    super(AnimNotify_Scripted).Notify(Owner, AnimSeqInstigator);
    //return;    
}

event Reverse(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn P;

    P = SkyPawn(Owner);
    // End:0x3A
    if(P != none)
    {
        P.FaceRotationTime = P.default.FaceRotationTime;
    }
    super.Reverse(Owner, AnimSeqInstigator);
    //return;    
}
