class SkyAnimNotify_SetFirstPersonMode extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() bool bFirstPersonMode;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    Owner.SetHidden(bFirstPersonMode);
    // End:0x97
    if((SkyPawn(Owner) != none) && SkyPawn(Owner).DrivenVehicle != none)
    {
        SkyPawn(Owner).DrivenVehicle.SetHidden(bFirstPersonMode);
        SkyPawn(Owner).DrivenVehicle.Mesh.bForceTick = bFirstPersonMode;
    }
    //return;    
}
