class AnimNotify_SwitchWeaponSocket extends AnimNotify_Scripted
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() name SocketName;
var name SavedSocketName;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local EvilPawn EP;

    EP = EvilPawn(Owner);
    // End:0xBC
    if((EP != none) && EP.WeaponSocket != SocketName)
    {
        SavedSocketName = EP.WeaponSocket;
        EP.WeaponSocket = SocketName;
        ReattachCurrentWeaponAttachment(EP);
    }
    //return;    
}

event NotifyEnd(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local EvilPawn EP;

    EP = EvilPawn(Owner);
    // End:0x7F
    if((EP != none) && SavedSocketName != 'None')
    {
        EP.WeaponSocket = SavedSocketName;
        ReattachCurrentWeaponAttachment(EP);
    }
    //return;    
}

function ReattachCurrentWeaponAttachment(EvilPawn EP)
{
    // End:0xC5
    if((EP != none) && EP.CurrentWeaponAttachment != none)
    {
        EP.CurrentWeaponAttachment.DetachFrom(EP.Mesh);
        EP.CurrentWeaponAttachment.AttachTo(EP);
    }
    //return;    
}
