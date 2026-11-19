class SkyAnimNotify_SetSkelControls extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

var() array<name> SkelControls;
var() array<float> NewStrengths;
var() array<float> NewBlendInTimes;
var() bool OnRocketPack;
var deprecated bool OnEhbenBlade;
var() bool OnPrimaryWeapon;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local editinline SkeletalMeshComponent SkelMesh;
    local int I;
    local SkelControlBase curskelcontrol;
    local SkyPawn SP;

    SP = SkyPawn(Owner);
    // End:0x94
    if(SP != none)
    {
        // End:0x49
        if(OnRocketPack == true)
        {
            SkelMesh = SP.RocketPack.Mesh;            
        }
        else
        {
            // End:0x7C
            if(OnPrimaryWeapon == true)
            {
                SkelMesh = SkeletalMeshComponent(SP.CurrWeaponAttachment.Mesh);                
            }
            else
            {
                SkelMesh = SP.Mesh;
            }
        }        
    }
    else
    {
        // End:0xC1
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
    J0xCA:

    // End:0x139 [Loop If]
    if(I < SkelControls.Length)
    {
        curskelcontrol = SkelMesh.FindSkelControl(SkelControls[I]);
        // End:0x109
        if(curskelcontrol == none)
        {
            // [Explicit Continue]
            goto J0x12F;
        }
        curskelcontrol.SetSkelControlStrength(NewStrengths[I], NewBlendInTimes[I]);
        J0x12F:

        ++I;
        // [Loop Continue]
        goto J0xCA;
    }
    //return;    
}
