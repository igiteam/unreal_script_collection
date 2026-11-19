class EvilSkelControlLimb extends SkelControlLimb
    hidecategories(Object,Object);

var(Effector) name EffectorWeaponSocket;
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

simulated function EditorTick(SkeletalMeshComponent SkelComp)
{
    local SkeletalMeshSocket SMS, S;
    local Vector Loc;
    local Rotator Rot;

    // End:0x1BA
    filtereditoronly
    {
        SMS = SkelComp.GetSocketByName('WeaponPoint');
        // End:0x6C
        if((SMS == none) || SMS.PreviewSkelMesh == none)
        {
            return;
        }
        // End:0x1B9
        foreach SMS.PreviewSkelMesh.Sockets(S)
        {
            // End:0x1B8
            if(S.SocketName == EffectorWeaponSocket)
            {
                SkelComp.GetSocketWorldLocationAndRotation('WeaponPoint', Loc, Rot);
                EffectorLocation = Loc + (((S.RelativeLocation - SMS.PreviewSkelMesh.Origin) >> SMS.RelativeRotation) >> Rot);
                EffectorLocationSpace = 0;                
                return;
            }            
        }        
    }
    //return;    
}

event TickSkelControl(float DeltaTime, SkeletalMeshComponent SkelComp)
{
    // End:0x35
    if(Class'Engine.Engine'.static.IsEditor())
    {
        EditorTick(SkelComp);
    }
    InitCachedOwner(EvilPawn(SkelComp.Owner));
    // End:0xAD
    if(ControlStrength ~= 0.0000000)
    {
        // End:0x8D
        if(!bShouldUseIK)
        {
            return;            
        }
        else
        {
            CachedOwner.SetHandIKEnabled(true);
        }
    }
    // End:0x11C
    if((!bHasSocket || CachedOwner.CurrentWeaponAttachment == none) || !bShouldUseIK)
    {
        // End:0x11A
        if(ControlStrength > 0.0000000)
        {
            SetSkelControlStrength(0.0000000, 0.0000000);
        }
        return;
    }
    CachedOwner.CurrentWeaponAttachment.Mesh.GetSocketWorldLocationAndRotation(EffectorWeaponSocket, EffectorLocation);
    EffectorLocationSpace = 0;
    //return;    
}

defaultproperties
{
    bShouldTickInScript=true
}