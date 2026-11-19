class SkyAnimNotify_WeaponAttachment extends AnimNotify_Scripted
    config(Engine)
    editinlinenew
    collapsecategories;

enum EWeaponAttachment
{
    WEAPONATTACH_Primary,           // 0
    WEAPONATTACH_Secondary,         // 1
    WEAPONATTACH_MAX                // 2
};

struct native IKControlInfo
{
    var() name ControlName;
    var() bool bEnable;

    structdefaultproperties
    {
        ControlName="None"
        bEnable=false
    }
};

var() SkyAnimNotify_WeaponAttachment.EWeaponAttachment Type;
var() name SocketName;
var() bool bUpdateIK;
var() bool bUpdateWeaponAttach;
var() bool bDropWeapon;
var() bool bPickupWeapon;
var() bool bEnabled;
var() array<IKControlInfo> EnableIKControls;
var() array<name> PrioritizedSkelBranches;

simulated event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local SkyPawn SP;
    local SkyWeaponAttachment Attachment;
    local int I;
    local editinline SkySkelMeshComponent SkelComponent;
    local AnimTree Tree;
    local bool bUpdateSkelBranches, bUsingSecondaryItem;

    bUpdateSkelBranches = false;
    SP = SkyPawn(Owner);
    // End:0x25
    if(!bEnabled)
    {
        return;
    }
    // End:0x4C3
    if(SP != none)
    {
        // End:0x65
        if(SP.bPickupState_NonWeapon == true)
        {
            // End:0x63
            if(bPickupWeapon)
            {
                SP.ReadyToPickupItem();
            }
            return;
        }
        // End:0xB1
        if((SP.PrimaryWSM.AllowAttachmentNotifies() == false) && SP.SecondaryWSM.AllowAttachmentNotifies() == false)
        {
            return;
        }
        // End:0xFE
        if((SkySecondaryItem(SP.SecondaryWeapon) != none) && int(SkySecondaryItem(SP.SecondaryWeapon).Using) != int(0))
        {
            bUsingSecondaryItem = true;
        }
        // End:0x12A
        if(bDropWeapon)
        {
            SkyPlayerController(SP.Controller).NotifyDrop();
        }
        // End:0x147
        if(bPickupWeapon)
        {
            SP.ReadyToPickup();
        }
        // End:0x16F
        if(int(Type) == int(0))
        {
            Attachment = SP.CurrWeaponAttachment;            
        }
        else
        {
            Attachment = SP.CurrSecondaryWeaponAttachment;
        }
        // End:0x1B3
        if((int(Type) == int(1)) && SkyItem_Dynamite(SP.SecondaryWeapon) != none)
        {            
        }
        else
        {
            // End:0x235
            if(((Attachment != none) && bUpdateWeaponAttach == true) && (((bUsingSecondaryItem == false) || int(Type) != int(0)) || SocketName == 'skt_2h_pri_weapon_l') || SocketName == 'skt_2h_pri_weapon')
            {
                SP.SetupWeapon(Attachment, SocketName, 0);
            }
        }
        // End:0x4C3
        if((SP.IKEnabled && bUpdateIK) && Attachment != none)
        {
            I = 0;
            J0x267:

            // End:0x3CF [Loop If]
            if(I < EnableIKControls.Length)
            {
                // End:0x39B
                if(EnableIKControls[I].bEnable)
                {
                    // End:0x398
                    if((bUsingSecondaryItem == false) || (EnableIKControls[I].ControlName != 'l_arm_IK') && EnableIKControls[I].ControlName != 'r_arm_IK')
                    {
                        Attachment.SetupIK(EnableIKControls[I].ControlName);
                        // End:0x357
                        if(EnableIKControls[I].ControlName == 'l_arm_IK')
                        {
                            Attachment.CleanupIK('r_arm_IK');                            
                        }
                        else
                        {
                            // End:0x398
                            if(EnableIKControls[I].ControlName == 'r_arm_IK')
                            {
                                Attachment.CleanupIK('l_arm_IK');
                            }
                        }
                    }
                    // [Explicit Continue]
                    goto J0x3C5;
                }
                Attachment.CleanupIK(EnableIKControls[I].ControlName);
                J0x3C5:

                ++I;
                // [Loop Continue]
                goto J0x267;
            }
            // End:0x4C3
            if(PrioritizedSkelBranches.Length > 0)
            {
                SkelComponent = SkySkelMeshComponent(SP.Mesh);
                Tree = AnimTree(SkelComponent.Animations);
                // End:0x47E
                if(Tree.PrioritizedSkelBranches.Length == PrioritizedSkelBranches.Length)
                {
                    I = 0;
                    J0x431:

                    // End:0x47B [Loop If]
                    if(I < PrioritizedSkelBranches.Length)
                    {
                        // End:0x471
                        if(Tree.PrioritizedSkelBranches[I] != PrioritizedSkelBranches[I])
                        {
                            bUpdateSkelBranches = true;
                            // [Explicit Break]
                            goto J0x47B;
                        }
                        ++I;
                        // [Loop Continue]
                        goto J0x431;
                    }
                    J0x47B:
                    
                }
                else
                {
                    bUpdateSkelBranches = true;
                }
                // End:0x4C3
                if(bUpdateSkelBranches)
                {
                    Tree.PrioritizedSkelBranches = PrioritizedSkelBranches;
                    SkelComponent.BuildComposePriorityList(Tree.PriorityList);
                }
            }
        }
    }
    //return;    
}
