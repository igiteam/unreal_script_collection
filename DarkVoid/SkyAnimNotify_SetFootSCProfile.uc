class SkyAnimNotify_SetFootSCProfile extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() array<name> SkelControls;
var() int Profile;
var() bool bSetEnableFootPlacement;
var() bool bEnableFootPlacement;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local editinline SkeletalMeshComponent SkelMesh;
    local int I;
    local SkySkelControl_FootPlacementProfiles curskelcontrol;

    // End:0x37
    if(bSetEnableFootPlacement && SkyPawnBase(Owner) != none)
    {
        SkyPawnBase(Owner).bEnableFootPlacement = bEnableFootPlacement;
    }
    // End:0x64
    if(SkyPawn(Owner) != none)
    {
        SkelMesh = SkyPawn(Owner).Mesh;        
    }
    else
    {
        // End:0x91
        if(SkyVehicle(Owner) != none)
        {
            SkelMesh = SkyVehicle(Owner).Mesh;            
        }
        else
        {
            return;
        }
    }
    I = 0;
    J0x9A:

    // End:0x101 [Loop If]
    if(I < SkelControls.Length)
    {
        curskelcontrol = SkySkelControl_FootPlacementProfiles(SkelMesh.FindSkelControl(SkelControls[I]));
        // End:0xDE
        if(curskelcontrol == none)
        {
            // [Explicit Continue]
            goto J0xF7;
        }
        curskelcontrol.SetProfile(Profile);
        J0xF7:

        ++I;
        // [Loop Continue]
        goto J0x9A;
    }
    //return;    
}
