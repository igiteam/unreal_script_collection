class MOHAWeaponUpgradeManager extends ActorComponent
    native;

struct native WeaponUpgradeInfo
{
    var EALAWeapon Weapon;
    var int iNumUpgradeLevels;

    structdefaultproperties
    {
        Weapon=none
        iNumUpgradeLevels=0
    }
};

var private array<int> iUpgradeLevel;
var(UpgradeSequence) float fLevelUpDisplayTime;
var(UpgradeSequence) float fLevelUpFadeInTime;
var(UpgradeSequence) float fLevelUpFadeOutTime;
var(UpgradeSequence) float fUpgradeDisplayTime;
var(UpgradeSequence) float fUpgradeFadeInTime;
var(UpgradeSequence) float fUpgradeFadeOutTime;
var(UpgradeSequence) float fBlurInTime;
var(UpgradeSequence) float fBlurOutTime;
var(UpgradeSequence) float fUpgradeMessageDelay;
var(UpgradeSequence) float fUpgradeTimeDilation;
var(UpgradeSequence) float fUpgradeBenefitDelay;
var(Sound) SoundCue MagicBulletSound;
var(Sound) SoundCue MagicBulletOutSound;
var(Sound) SoundRiotMixSelect MagicBulletMixSelect;
var array<WeaponUpgradeInfo> PendingUpgrades;
var EALAWeapon UpgradeWeapon;
var int iNumUpgradeLevels;
var bool bGodModeInitialValue;

simulated function Init()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x2E [Loop If]
    if(I < 24)
    {
        iUpgradeLevel[I] = -1;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    //return;    
}

simulated function InitUpgradesOnWeaponAttachmentInstance(WeaponAttachment W, optional bool bApplyExistingUpgrades)
{
    local int I;
    local MOHAIncludeClass.EWeaponType WeaponType;

    I = W.WeaponClass.default.WeaponUpgradeClasses.Length - 1;
    J0x22:

    // End:0x8A [Loop If]
    if(I >= 0)
    {
        // End:0x80
        if(W.WeaponClass.default.WeaponUpgradeClasses[I] != none)
        {
            W.WeaponClass.default.WeaponUpgradeClasses[I].StaticInitWeaponAttachmentUpgrade(W);
        }
        I--;
        // [Loop Continue]
        goto J0x22;
    }
    // End:0x12C
    if(bApplyExistingUpgrades)
    {
        WeaponType = W.WeaponClass.default.WeaponType;
        I = 0;
        J0xB7:

        // End:0x12C [Loop If]
        if((I <= iUpgradeLevel[int(WeaponType)]) && I < W.WeaponClass.default.WeaponUpgradeClasses.Length)
        {
            W.WeaponClass.default.WeaponUpgradeClasses[I].StaticUpgradeWeaponAttachment(W);
            I++;
            // [Loop Continue]
            goto J0xB7;
        }
    }
    //return;    
}

function PreUpgrade(MOHAIncludeClass.EWeaponType WeaponType, int UpgradeLevel, EALAWeapon W)
{
    local int I;

    // End:0x6D
    if(W != none)
    {
        I = 0;
        J0x12:

        // End:0x6D [Loop If]
        if((I < UpgradeLevel) && I < W.WeaponUpgradeClasses.Length)
        {
            W.WeaponUpgradeClasses[I].static.StaticPreUpgradeWeapon(W);
            I++;
            // [Loop Continue]
            goto J0x12;
        }
    }
    //return;    
}

function upgrade(MOHAIncludeClass.EWeaponType WeaponType, int UpgradeLevel, EALAWeapon W)
{
    local int I;
    local WeaponAttachment Attachment;

    // End:0x118
    if(W != none)
    {
        Attachment = W.GetWeaponAttachment();
        I = W.CurrentUpgradeLevel + 1;
        J0x3B:

        // End:0xEB [Loop If]
        if((I <= UpgradeLevel) && I < W.WeaponUpgradeClasses.Length)
        {
            W.WeaponUpgradeClasses[I].static.StaticUpgradeWeapon(W);
            // End:0xE1
            if((Attachment != none) && Attachment.WeaponClass == W.Class)
            {
                W.WeaponUpgradeClasses[I].static.StaticUpgradeWeaponAttachment(Attachment);
            }
            I++;
            // [Loop Continue]
            goto J0x3B;
        }
        // End:0x115
        if(iUpgradeLevel[int(WeaponType)] < UpgradeLevel)
        {
            iUpgradeLevel[int(WeaponType)] = UpgradeLevel;
        }        
    }
    else
    {
        // End:0x142
        if(iUpgradeLevel[int(WeaponType)] < UpgradeLevel)
        {
            iUpgradeLevel[int(WeaponType)] = UpgradeLevel;
        }
    }
    //return;    
}

simulated function UpgradeAttachment(WeaponAttachment W, int UpgradeLevel)
{
    local MOHAIncludeClass.EWeaponType WeaponType;

    // End:0xA6
    if((W != none) && W.WeaponClass.default.WeaponUpgradeClasses.Length > UpgradeLevel)
    {
        W.WeaponClass.default.WeaponUpgradeClasses[UpgradeLevel].StaticUpgradeWeaponAttachment(W);
        WeaponType = W.WeaponClass.default.WeaponType;
        // End:0xA6
        if(iUpgradeLevel[int(WeaponType)] < UpgradeLevel)
        {
            iUpgradeLevel[int(WeaponType)] = UpgradeLevel;
        }
    }
    //return;    
}

function int GetAppliedUpgradeLevel(MOHAIncludeClass.EWeaponType WeaponType)
{
    // End:0x23
    if(iUpgradeLevel.Length > int(WeaponType))
    {
        return iUpgradeLevel[int(WeaponType)];        
    }
    else
    {
        return -1;
    }
    //return ReturnValue;    
}

function string GetUpgradeName(EALAWeapon Weap, int UpgradeLevel)
{
    // End:0x47
    if((Weap != none) && Weap.WeaponUpgradeClasses.Length > UpgradeLevel)
    {
        return Weap.WeaponUpgradeClasses[UpgradeLevel].default.WeaponUpgradeName;        
    }
    else
    {
        return "UNNAMED WEAPON UPGRADE";
    }
    //return ReturnValue;    
}

function StartUpgradeSequence(EALAWeapon W, int iNumLevelsGained)
{
    local WeaponUpgradeInfo UpgradeInfo;

    // End:0x116
    if(W.CurrentUpgradeLevel < W.GetMaxUpgradeLevel())
    {
        UpgradeInfo.Weapon = W;
        UpgradeInfo.iNumUpgradeLevels = Clamp(iNumLevelsGained, 1, W.GetMaxUpgradeLevel() - W.CurrentUpgradeLevel);
        PendingUpgrades.AddItem(UpgradeInfo);
        // End:0x9E
        if(!IsUpgradeSequenceActive())
        {
            GotoState('UpgradeSequence');
        }
        Class'Engine.JuiceSubsystem'.static.LevelEventD(2, 0, 5, "Gameplay", "UpgradedWeapon", string(UpgradeWeapon.Class.Name), 0, float(W.CurrentUpgradeLevel + iNumUpgradeLevels), "", Pawn(Owner).Location);
    }
    //return;    
}

simulated function CheckUpgradeQueue()
{
    // End:0x1A
    if(PendingUpgrades.Length > 0)
    {
        GotoState('UpgradeSequence');
    }
    //return;    
}

simulated function bool IsUpgradeSequenceActive()
{
    return false;
    //return ReturnValue;    
}

state UpgradeSequence
{
    simulated function BeginState(name PreviousStateName)
    {
        UpgradeWeapon = PendingUpgrades[0].Weapon;
        iNumUpgradeLevels = PendingUpgrades[0].iNumUpgradeLevels;
        PendingUpgrades.Remove(0, 1);
        Owner.WorldInfo.ToggleDOF(true);
        Owner.WorldInfo.GameModified_DOF_FocusDistance = 0.0000000;
        Owner.WorldInfo.GameModified_DOF_FocusInnerRadius = 0.0000000;
        Owner.WorldInfo.GameModified_DOF_MaxNearBlurAmount = 0.0000000;
        Owner.WorldInfo.GameModified_DOF_MaxFarBlurAmount = 0.0000000;
        MagicBulletMixSelect.ActiveAsMixFader();
        Owner.PlaySound(MagicBulletSound);
        bGodModeInitialValue = Pawn(Owner).Controller.bGodMode;
        Pawn(Owner).Controller.bGodMode = true;
        UpgradeWeapon.AddUpgradeSequenceAmmo();
        Owner.SetTimer(fBlurInTime, false, 'BlurInDone', self, true);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        Owner.WorldInfo.ToggleDOF(false);
        Owner.WorldInfo.TimeDilation = 1.0000000;
        MagicBulletMixSelect.DeActivate();
        Pawn(Owner).Controller.bGodMode = bGodModeInitialValue;
        MOHAHUD(PlayerController(Pawn(Owner).Controller).myHUD).ToggleWeaponInfo(false, 5.0000000);
        Owner.PlaySound(MagicBulletOutSound);
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        local float fPerc;

        // End:0xC5
        if(Owner.IsTimerActive('BlurInDone', self))
        {
            fPerc = FClamp(Owner.GetTimerCount('BlurInDone', self) / Owner.GetTimerRate('BlurInDone', self), 0.0000000, 1.0000000);
            Owner.WorldInfo.GameModified_DOF_MaxNearBlurAmount = fPerc;
            Owner.WorldInfo.GameModified_DOF_MaxFarBlurAmount = fPerc;
            Owner.WorldInfo.TimeDilation = Lerp(1.0000000, fUpgradeTimeDilation, fPerc);
        }
        // End:0x198
        if(Owner.IsTimerActive('BlendOutDone', self))
        {
            fPerc = FClamp(Owner.GetTimerCount('BlendOutDone', self) / Owner.GetTimerRate('BlendOutDone', self), 0.0000000, 1.0000000);
            Owner.WorldInfo.GameModified_DOF_MaxNearBlurAmount = 1.0000000 - fPerc;
            Owner.WorldInfo.GameModified_DOF_MaxFarBlurAmount = 1.0000000 - fPerc;
            Owner.WorldInfo.TimeDilation = Lerp(fUpgradeTimeDilation, 1.0000000, fPerc);
        }
        //return;        
    }

    simulated function BlurInDone()
    {
        local int iUpgradeNum;
        local string UpgradeName;
        local float fRemainingDisplayTime, InitialUpgradeDisplayTime;
        local bool bShowUpgradeBenefit;

        iUpgradeNum = UpgradeWeapon.CurrentUpgradeLevel + iNumUpgradeLevels;
        UpgradeName = GetUpgradeName(UpgradeWeapon, iUpgradeNum);
        bShowUpgradeBenefit = fUpgradeBenefitDelay < fUpgradeDisplayTime;
        InitialUpgradeDisplayTime = ((bShowUpgradeBenefit) ? fUpgradeBenefitDelay : fUpgradeDisplayTime);
        // End:0xE8
        if(bShowUpgradeBenefit)
        {
            fRemainingDisplayTime = fUpgradeDisplayTime - fUpgradeBenefitDelay;
            MOHAHUD(PlayerController(Pawn(Owner).Controller).myHUD).hud_messageQueue.ShowUpgradeText(UpgradeWeapon.HUDInfoClass, iUpgradeNum, UpgradeName, fRemainingDisplayTime, 0.0000000, fUpgradeFadeOutTime, 0.0000000, true);
        }
        MOHAHUD(PlayerController(Pawn(Owner).Controller).myHUD).hud_messageQueue.ShowUpgradeText(UpgradeWeapon.HUDInfoClass, iUpgradeNum, UpgradeName, InitialUpgradeDisplayTime, fUpgradeFadeInTime, 0.0000000, 0.0000000, false);
        MOHAHUD(PlayerController(Pawn(Owner).Controller).myHUD).hud_messageQueue.ShowMedalText(iUpgradeNum, fLevelUpDisplayTime, fLevelUpFadeInTime, fLevelUpFadeOutTime, fUpgradeMessageDelay);
        Owner.SetTimer(((fLevelUpDisplayTime + fLevelUpFadeInTime) + fLevelUpFadeOutTime) + fUpgradeMessageDelay, false, 'UpgradeTheWeapon', self, true);
        //return;        
    }

    simulated function UpgradeTheWeapon()
    {
        upgrade(UpgradeWeapon.WeaponType, UpgradeWeapon.CurrentUpgradeLevel + iNumUpgradeLevels, UpgradeWeapon);
        Owner.SetTimer(fUpgradeFadeInTime + fUpgradeDisplayTime, false, 'StartBlendingOutBlur', self, true);
        //return;        
    }

    simulated function StartBlendingOutBlur()
    {
        Owner.SetTimer(fBlurOutTime, false, 'BlendOutDone', self, true);
        //return;        
    }

    simulated function BlendOutDone()
    {
        GotoState('None');
        CheckUpgradeQueue();
        //return;        
    }

    simulated function bool IsUpgradeSequenceActive()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

defaultproperties
{
    fLevelUpDisplayTime=2.5000000
    fLevelUpFadeInTime=0.2500000
    fLevelUpFadeOutTime=0.5000000
    fUpgradeDisplayTime=3.5000000
    fUpgradeFadeInTime=0.2500000
    fUpgradeFadeOutTime=0.5000000
    fBlurInTime=0.2500000
    fBlurOutTime=0.5000000
    fUpgradeMessageDelay=0.2500000
    fUpgradeTimeDilation=0.1500000
    fUpgradeBenefitDelay=2.0000000
    MagicBulletSound=SoundCue'Aud_GCm_FakeWAV.Items.MagicBullet'
    MagicBulletOutSound=SoundCue'Aud_GCm_FakeWAV.Items.MagicBullet_Out'
    MagicBulletMixSelect=SoundRiotMixSelect'Aud_GCm_MixSnapshot.MagicBullet_Fader'
}