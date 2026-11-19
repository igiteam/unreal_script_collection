class EvilSkelControlLimb extends SkelControlLimb
    hidecategories(Object,Object);

var(Effector) name EffectorWeaponSocket;
var(Effector) name EffectorActualBoneName;
var EvilPawn CachedOwner;
var bool bHasSocket;
var bool bShouldUseIK;

function bool InitCachedOwner(EvilPawn Instigator)
{
    // End:0x33
    if(CachedOwner == none)
    {
        CachedOwner = Instigator;
        // End:0x33
        if(CachedOwner == none)
        {
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

simulated function OnWeaponAttachmentChanged(EvilPawn Instigator)
{
    // End:0x1A
    if(!InitCachedOwner(Instigator))
    {
        return;
    }
    bHasSocket = ((none != CachedOwner) && none != CachedOwner.CurrentWeaponAttachment) && none != CachedOwner.CurrentWeaponAttachment.Mesh.GetSocketByName(EffectorWeaponSocket);
    //return;    
}

simulated function OnIKStatusUpdate(bool ZoomIn)
{
    // End:0x1E2
    if(bHasSocket)
    {
        bShouldUseIK = (((((CachedOwner != none) && CachedOwner.CurrentWeaponAttachment != none) && CachedOwner.CurrentWeaponAttachment.bEnableIK) && !(!CachedOwner.CurrentWeaponAttachment.bEnableIKOnAim && EvilWeap_Base(CachedOwner.Weapon) != none) && ZoomIn) && !CachedOwner.IsDoingAPawnAction() && CachedOwner.PawnActions[int(CachedOwner.PawnAction)].bDisableIK) && !(CachedOwner.CurrentNavPointAction != none) && CachedOwner.CurrentNavPointAction.bDisableIK;        
    }
    else
    {
        bShouldUseIK = false;
    }
    //return;    
}

function FixEffectorLocationForHand()
{
    // End:0x19
    if(EffectorActualBoneName == 'None')
    {
        return;
    }
    EffectorLocation += (SkelComponent.GetBoneLocation('LeftHand') - SkelComponent.GetBoneLocation(EffectorActualBoneName));
    //return;    
}

event TickSkelControl(float DeltaTime, SkeletalMeshComponent SkelComp)
{
    local SkeletalMeshSocket SMSWeapon;
    local int I;

    // End:0x3A0
    filtereditoronly
    {
        // End:0x3A0
        if(Class'Engine.Engine'.static.IsEditor() && !Class'Engine.Engine'.static.IsGame())
        {
            SMSWeapon = SkelComp.GetSocketByName('WeaponPoint');
            // End:0xC0
            if((SMSWeapon == none) || SMSWeapon.PreviewSkelMesh == none)
            {
                bHasSocket = false;
                return;
            }
            I = 0;
            J0xCB:

            // End:0x2D3 [Loop If]
            if(I < SkelComp.Attachments.Length)
            {
                // End:0x2C5
                if(((((SkelComp.Attachments[I].BoneName == SMSWeapon.BoneName) && SkelComp.Attachments[I].RelativeLocation == SMSWeapon.RelativeLocation) && SkelComp.Attachments[I].RelativeRotation == SMSWeapon.RelativeRotation) && SkelComp.Attachments[I].RelativeScale == SMSWeapon.RelativeScale) && SkeletalMeshComponent(SkelComp.Attachments[I].Component) != none)
                {
                    // [Explicit Break]
                    goto J0x2D3;
                }
                ++I;
                // [Loop Continue]
                goto J0xCB;
            }
            J0x2D3:

            // End:0x30E
            if(I >= SkelComp.Attachments.Length)
            {
                bHasSocket = false;
                return;
            }
            bHasSocket = true;
            SkeletalMeshComponent(SkelComp.Attachments[I].Component).GetSocketWorldLocationAndRotation(EffectorWeaponSocket, EffectorLocation);
            FixEffectorLocationForHand();
            EffectorLocationSpace = 0;
            return;
        }
    }
    InitCachedOwner(EvilPawn(SkelComp.Owner));
    // End:0x418
    if(ControlStrength ~= 0.0000000)
    {
        // End:0x3F8
        if(!bShouldUseIK)
        {
            return;            
        }
        else
        {
            CachedOwner.SetHandIKEnabled(true);
        }
    }
    // End:0x487
    if((!bHasSocket || CachedOwner.CurrentWeaponAttachment == none) || !bShouldUseIK)
    {
        // End:0x485
        if(ControlStrength > 0.0000000)
        {
            SetSkelControlStrength(0.0000000, 0.0000000);
        }
        return;
    }
    CachedOwner.CurrentWeaponAttachment.Mesh.GetSocketWorldLocationAndRotation(EffectorWeaponSocket, EffectorLocation);
    FixEffectorLocationForHand();
    EffectorLocationSpace = 0;
    //return;    
}

defaultproperties
{
    bShouldTickInScript=true
}