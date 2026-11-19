class SkySkeletalMeshActor extends SkeletalMeshActor
    native;

var(SkelControl) bool bActivateSkelControlsOnStart;
var(SkelControl) array<name> ActiveSkelControls;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x1A
    if(bActivateSkelControlsOnStart)
    {
        SetSkelControlsActive(true);
    }
    //return;    
}

simulated function SetSkelControlsActive(bool bNowActive)
{
    local int I;
    local SkelControlBase SkelControl;

    I = 0;
    J0x07:

    // End:0x63 [Loop If]
    if(I < ActiveSkelControls.Length)
    {
        SkelControl = SkeletalMeshComponent.FindSkelControl(ActiveSkelControls[I]);
        // End:0x59
        if(SkelControl != none)
        {
            SkelControl.SetSkelControlActive(bNowActive);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}
