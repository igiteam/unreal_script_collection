class AnimNotify_MagazineExchange_Base extends AnimNotify_Scripted
    abstract
    editinlinenew
    collapsecategories
    hidecategories(Object);

var(MagazineExchange) name MagazineBoneName;

protected function SkeletalMeshComponent GetWeaponMeshComponent(Actor Owner, SkeletalMeshComponent OwnerMesh, optional bool bGetMagSkelControl = false, optional out AdvSkelControl_Magazine MagSkelControl)
{
    local AdvPawn P;
    local AdvAttachment_Weap_Base Attachment;
    local int Idx;
    local editinline SkeletalMeshComponent SMC;

    P = AdvPawn(Owner);
    // End:0xC7
    if(P != none)
    {
        Attachment = AdvAttachment_Weap_Base(P.CurrentWeaponAttachment);
        // End:0x73
        if(Attachment == none)
        {
            return none;
        }
        // End:0xA8
        if(bGetMagSkelControl)
        {
            MagSkelControl = Attachment.MagSkelControl;
        }
        return Attachment.Mesh;
    }
    // End:0x278
    filtereditoronly
    {
        // End:0x278
        if(OwnerMesh != none)
        {
            Idx = 0;
            J0xE4:

            // End:0x278 [Loop If]
            if(Idx < OwnerMesh.Attachments.Length)
            {
                // End:0x26A
                if(OwnerMesh.Attachments[Idx].BoneName == Class'AdvPawn'.default.WeaponSocket)
                {
                    SMC = SkeletalMeshComponent(OwnerMesh.Attachments[Idx].Component);
                    // End:0x26A
                    if(SMC != none)
                    {
                        // End:0x260
                        if(bGetMagSkelControl)
                        {
                            // End:0x225
                            if(SMC.Animations == none)
                            {
                                SMC.SetAnimTreeTemplate(AnimTree'an_human.AnimTree.AT_WeaponAttachmentMagazine');
                            }
                            MagSkelControl = AdvSkelControl_Magazine(SMC.FindSkelControl('Magazine'));
                        }
                        return SMC;
                    }
                }
                ++Idx;
                // [Loop Continue]
                goto J0xE4;
            }
        }
    }
    return none;
    //return ReturnValue;    
}

defaultproperties
{
    MagazineBoneName="magazinen"
}