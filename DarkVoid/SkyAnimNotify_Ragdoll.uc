class SkyAnimNotify_Ragdoll extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bFeignDeath;
var() PhysicsAsset Asset;
var deprecated float Weight;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn SP;

    SP = SkyPawn(Owner);
    // End:0x81
    if(SP != none)
    {
        // End:0x3B
        if(bFeignDeath)
        {
            SP.ForceRagdoll();            
        }
        else
        {
            SP.Mesh.SetPhysicsAsset(Asset);
            SP.InitRagdoll();
            SP.bBlendOutTakeHitPhysics = false;
        }
    }
    //return;    
}
