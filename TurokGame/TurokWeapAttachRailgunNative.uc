class TurokWeapAttachRailgunNative extends TurokWeaponAttachment
    config(WeapRailgun);

var(Animations) name m3PAltReloadAnim;
var(Animations) name m3POverheatAnim;
var name m3PStartReloadAnim;
var name m3PLoopReloadAnim;
var name m3PEndReloadAnim;

simulated function ThirdPersonDoPhaseReloading(bool bBeginning)
{
    local float ReloadTime;
    local name ReloadAnim;

    // End:0x52
    if(bBeginning)
    {
        ReloadTime = WeaponClass.default.mAltReloadStartTime;
        ReloadAnim = m3PStartReloadAnim;
        Play3PCannedAnimation(mCannedControllerName, ReloadAnim, ReloadTime, ReloadTime * 0.1000000, 0.0000000, true);        
    }
    else
    {
        ReloadTime = WeaponClass.default.mReloadEndTime;
        ReloadAnim = m3PEndReloadAnim;
        Play3PCannedAnimation(mCannedControllerName, ReloadAnim, ReloadTime, 0.0000000, ReloadTime * 0.1000000, false);
    }
    //return;    
}

simulated function ThirdPersonDoReload()
{
    local float ReloadTime;
    local byte FiringMode;
    local name ReloadAnim;

    FiringMode = mHumanOwner.GetFiringMode();
    // End:0x76
    if(int(FiringMode) == 0)
    {
        ReloadAnim = m3PReloadAnim;
        ReloadTime = WeaponClass.default.mReloadStartTime;
        Play3PCannedAnimation(mCannedControllerName, ReloadAnim, ReloadTime, ReloadTime * 0.1000000, ReloadTime * 0.1000000, false);        
    }
    else
    {
        ReloadAnim = m3PLoopReloadAnim;
        ReloadTime = WeaponClass.default.mReloadTime;
        Play3PCannedAnimation(mCannedControllerName, ReloadAnim, ReloadTime, 0.0000000, 0.0000000, true);
        // End:0xD9
        if(!mHumanOwner.IsFirstPerson())
        {
            PlayLimitedWeaponSound(mReloadSndCue, false);
        }
    }
    //return;    
}

simulated function RailgunAttachmentThirdPersonDoOverheat(bool isOverheating)
{
    ThirdPersonDoOverheat(isOverheating);
    //return;    
}

simulated function ThirdPersonDoOverheat(bool isOverheating)
{
    local float OverheatTime;

    // End:0x50
    if(isOverheating)
    {
        OverheatTime = class<TurokWeapRailgunNative>(WeaponClass).default.mOverheatTime;
        Play3PCannedAnimation(mCannedControllerName, m3POverheatAnim, OverheatTime, OverheatTime * 0.1000000, OverheatTime * 0.1000000, false);
    }
    //return;    
}

simulated function FinishedThirdPersonReload()
{
    Stop3PCannedAnimations(mCannedControllerName);
    //return;    
}

simulated function OnReplicatedStateChanged(int State)
{
    // End:0x1D
    if((State & (1 << 9)) > 0)
    {
        ThirdPersonDoOverheat(true);
    }
    // End:0x3A
    if((State & (1 << 10)) > 0)
    {
        ThirdPersonDoOverheat(false);
    }
    super.OnReplicatedStateChanged(State);
    //return;    
}
