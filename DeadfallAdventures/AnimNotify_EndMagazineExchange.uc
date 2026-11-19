class AnimNotify_EndMagazineExchange extends AnimNotify_MagazineExchange_Base
    editinlinenew
    collapsecategories
    hidecategories(Object);

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local editinline SkeletalMeshComponent SMC;
    local AdvSkelControl_Magazine MagSkelControl;

    SMC = GetWeaponMeshComponent(Owner, AnimSeqInstigator.SkelComponent, true, MagSkelControl);
    // End:0x56
    if(SMC == none)
    {
        return;
    }
    SMC.UnHideBoneByName(MagazineBoneName);
    // End:0x8F
    if(MagSkelControl == none)
    {
        return;
    }
    MagSkelControl.UnglueFromHand();
    //return;    
}
