class AnimNotify_BeginMagazineExchange extends AnimNotify_MagazineExchange_Base
    editinlinenew
    collapsecategories
    hidecategories(Object);

var(MagazineExchange) bool bDropMagazine;
var transient bool bMagazineWasDropped;
var(MagazineExchange) name MagazineDropSocketName;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local Vector DropLoc;
    local Rotator DropRot;
    local AdvDroppedMagazine Mag;
    local StaticMesh Mesh;
    local editinline SkeletalMeshComponent SMC;
    local int Idx;

    SMC = GetWeaponMeshComponent(Owner, AnimSeqInstigator.SkelComponent);
    // End:0x4E
    if(SMC == none)
    {
        return;
    }
    // End:0x3EE
    if(bDropMagazine)
    {
        Mesh = GetMagazineMesh(AdvPawn(Owner));
        // End:0x3EE
        if(Mesh != none)
        {
            // End:0x3EB
            if(GetMagazineDropLocation(SMC, DropLoc, DropRot))
            {
                Mag = Owner.Spawn(Class'AdvDroppedMagazine',,, DropLoc, DropRot);
                Mag.SetDrawScale(SMC.Scale * Owner.DrawScale);
                Mag.SetDrawScale3D(SMC.Scale3D * Owner.DrawScale3D);
                // End:0x32B
                if(SMC.AttachedToSkelComponent != none)
                {
                    Idx = 0;
                    J0x1EA:

                    // End:0x32B [Loop If]
                    if(Idx < SMC.AttachedToSkelComponent.Attachments.Length)
                    {
                        // End:0x31D
                        if(SMC.AttachedToSkelComponent.Attachments[Idx].Component == SMC)
                        {
                            Mag.SetDrawScale3D(Mag.DrawScale3D * SMC.AttachedToSkelComponent.Attachments[Idx].RelativeScale);
                            // [Explicit Break]
                            goto J0x32B;
                        }
                        ++Idx;
                        // [Loop Continue]
                        goto J0x1EA;
                    }
                }
                J0x32B:

                Mag.SetStaticMesh(Mesh);
                Mag.Velocity = Owner.Velocity;
                Mag.Initialize();
                SMC.HideBoneByName(MagazineBoneName, 0);
                bMagazineWasDropped = true;                
            }            
        }
    }
    GlueMagazineToHand(Owner, AnimSeqInstigator.SkelComponent);
    //return;    
}

event NotifyEnd(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local editinline SkeletalMeshComponent SMC;

    // End:0x7E
    if(bMagazineWasDropped)
    {
        SMC = GetWeaponMeshComponent(Owner, AnimSeqInstigator.SkelComponent);
        SMC.UnHideBoneByName(MagazineBoneName);
        bMagazineWasDropped = false;
    }
    //return;    
}

protected function bool GetMagazineDropLocation(SkeletalMeshComponent SkelComponent, out Vector Location, out Rotator Rotation)
{
    local int MagBoneIndex;
    local Matrix MagBone;

    // End:0x11
    if(SkelComponent == none)
    {
        return false;
    }
    // End:0x81
    if((SkelComponent.GetSocketByName(MagazineDropSocketName) != none) && SkelComponent.GetSocketWorldLocationAndRotation(MagazineDropSocketName, Location, Rotation))
    {
        return true;
    }
    MagBoneIndex = SkelComponent.MatchRefBone(MagazineBoneName);
    // End:0xC8
    if(MagBoneIndex == -1)
    {
        return false;
    }
    MagBone = SkelComponent.GetBoneMatrix(MagBoneIndex);
    Location = MatrixGetOrigin(MagBone);
    Rotation = MatrixGetRotator(MagBone);
    return true;
    //return ReturnValue;    
}

protected function StaticMesh GetMagazineMesh(AdvPawn Owner)
{
    local AdvAttachment_Weap_Base Attachment;

    Attachment = AdvAttachment_Weap_Base(Owner.CurrentWeaponAttachment);
    // End:0x85
    if((Attachment != none) && Attachment.DroppedMagazineMesh != none)
    {
        return Attachment.DroppedMagazineMesh;
    }
    // End:0xB4
    filtereditoronly
    {
        // End:0xB4
        if(Class'Engine.Engine'.static.IsEditor())
        {
            return StaticMesh'wp_mp38_01.Mesh.sm_wp_mp38_magazine';
        }
    }
    return none;
    //return ReturnValue;    
}

protected function GlueMagazineToHand(Actor Owner, SkeletalMeshComponent OwnerMesh)
{
    local AdvSkelControl_Magazine MagSkelControl;
    local AdvPawn P;

    GetWeaponMeshComponent(Owner, OwnerMesh, true, MagSkelControl);
    // End:0xB1
    if(MagSkelControl != none)
    {
        P = AdvPawn(Owner);
        MagSkelControl.GlueToHand(OwnerMesh, ((P != none) ? P.GrenadeSocket : 'LeftHand'));
    }
    //return;    
}

defaultproperties
{
    MagazineDropSocketName="MagazineDrop"
}