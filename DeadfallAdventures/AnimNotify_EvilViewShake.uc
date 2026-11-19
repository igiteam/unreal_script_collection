class AnimNotify_EvilViewShake extends AnimNotify_ViewShake
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() float ShakeFalloff;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local Vector ViewShakeOrigin;
    local Pawn P;
    local PlayerController PC;

    // End:0xCF
    if(ShakeRadius == float(0))
    {
        P = Pawn(Owner);
        // End:0xCC
        if((P != none) && P.IsLocallyControlled())
        {
            PC = PlayerController(P.Controller);
            // End:0xCC
            if(PC != none)
            {
                PC.ClientPlayCameraShake(ShakeParams);
            }
        }        
    }
    else
    {
        // End:0x15E
        if((bUseBoneLocation && AnimSeqInstigator != none) && AnimSeqInstigator.SkelComponent != none)
        {
            ViewShakeOrigin = AnimSeqInstigator.SkelComponent.GetBoneLocation(BoneName);            
        }
        else
        {
            ViewShakeOrigin = Owner.Location;
        }
        // End:0x1F1
        if(Owner != none)
        {
            Class'Engine.Camera'.static.PlayWorldCameraShake(ShakeParams, Owner, ViewShakeOrigin, 0.0000000, ShakeRadius, ShakeFalloff, bDoControllerVibration);
        }
    }
    //return;    
}

defaultproperties
{
    ShakeFalloff=1.0000000
}