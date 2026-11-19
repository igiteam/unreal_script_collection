class SkyAnimNotify_CleanupIK extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() array<name> SkelControls;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn SP;
    local int I;
    local SkySkelControl_SocketIK IKControl;

    SP = SkyPawn(Owner);
    // End:0x1D
    if(SP == none)
    {
        return;
    }
    I = 0;
    J0x24:

    // End:0x90 [Loop If]
    if(I < SkelControls.Length)
    {
        IKControl = SkySkelControl_SocketIK(SP.Mesh.FindSkelControl(SkelControls[I]));
        // End:0x72
        if(IKControl == none)
        {
            // [Explicit Continue]
            goto J0x86;
        }
        IKControl.Disconnect();
        J0x86:

        ++I;
        // [Loop Continue]
        goto J0x24;
    }
    //return;    
}
