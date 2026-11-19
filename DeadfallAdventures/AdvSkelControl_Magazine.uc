class AdvSkelControl_Magazine extends SkelControlSingleBone
    hidecategories(Object,Object);

var protected export editinline transient SkeletalMeshComponent MeshToFollow;
var protected transient name SocketToFollow;
var protected transient bool bJustStarted;

event TickSkelControl(float DeltaTime, SkeletalMeshComponent SkelComp)
{
    super(SkelControlBase).TickSkelControl(DeltaTime, SkelComp);
    // End:0x111
    if(MeshToFollow != none)
    {
        // End:0x5D
        if(!bJustStarted && ControlStrength <= 0.1000000)
        {
            MeshToFollow = none;            
        }
        else
        {
            MeshToFollow.GetSocketWorldLocationAndRotation(SocketToFollow, BoneTranslation, BoneRotation);
            BoneTranslation += (2.5000000 * Vector(BoneRotation));
            BoneRotation = RTransform(MakeRotator(16384, 0, 16384), BoneRotation);
            bJustStarted = bJustStarted && ControlStrength <= 0.1000000;
        }
    }
    //return;    
}

simulated function GlueToHand(SkeletalMeshComponent Other, name SocketName)
{
    // End:0x11
    if(Other == none)
    {
        return;
    }
    // End:0x7C
    if(Other.GetSocketByName(SocketName) != none)
    {
        MeshToFollow = Other;
        SocketToFollow = SocketName;
        SetSkelControlActive(true);
        bJustStarted = true;
    }
    //return;    
}

simulated function UnglueFromHand()
{
    SetSkelControlActive(false);
    //return;    
}

defaultproperties
{
    bApplyTranslation=true
    bApplyRotation=true
    bShouldTickInScript=true
}