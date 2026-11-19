class MOHAHUDMessageQueue extends MOHAHUDObj
    native;

const maxSize = 15;

enum InstantShowMode
{
    INSTANT_SHOW_OFF,               // 0
    INSTANT_SHOW_ADD_TO_FRONT,      // 1
    INSTANT_SHOW_REPLACE_CURRENT,   // 2
    INSTANT_SHOW_MAX                // 3
};

struct native NotifyData
{
    var string TopText;
    var string BottomText;
    var Texture2D Image;
    var float U;
    var float V;
    var float uw;
    var float vh;
    var float fDisplayTime;
    var float fFadeInTime;
    var float fFadeOutTime;
    var float fDelayTime;
    var float time_active;
    var float fSizeX;
    var float fSizeY;
    var float fPosX;
    var float fPosY;
    var SoundCue notifySound;
    var Font MessageFont;
    var EALAObjective NewObj;

    structdefaultproperties
    {
        TopText=""
        BottomText=""
        Image=none
        U=0.0000000
        V=0.0000000
        uw=0.0000000
        vh=0.0000000
        fDisplayTime=0.0000000
        fFadeInTime=0.0000000
        fFadeOutTime=0.0000000
        fDelayTime=0.0000000
        time_active=0.0000000
        fSizeX=0.0000000
        fSizeY=0.0000000
        fPosX=0.0000000
        fPosY=0.0000000
        notifySound=none
        MessageFont=none
        NewObj=none
    }
};

var const localized array<localized NotifyData> GenericNotifyInfoNew;
var const localized string UpgradeAwardedText;
var const localized string CheckpointReachedText;
var array<NotifyData> messages;
var int CurrentIndex;
var int numActive;
var Vector2D GrenadeKillNotifyIconLoc;
var Vector2D GunKillNotifyIconLoc;
var int MedalMomentIconSize;
var() float DefaultDisplayTime;
var() float DefaultFadeInTime;
var() float DefaultFadeoutTime;
var() float DefaultDelayTime;
var() Font DefaultFont;
var() Font UpgradeMsgFont;
var() Font MedalMsgFont;
var() float fMedalIconPixelSize;
var() float fUpgradeIconScaleFactor;
var SoundCue UpgradeFoundSound;
var SoundCue LeveledWeaponSound;
var() array<Texture2D> ExperienceIcons;
var() const localized array<localized string> ExperienceCommendations;
var() Font ObjectiveMsgFont;
var() Texture2D ObjectiveIconImg;
var() Vector2D ObjectiveIconUV;
var() Vector2D ObjectiveIconUVSize;
var() Vector2D ObjectiveIconPixelSize;
var() Vector2D ObjectivePos;
var EALAObjective CurrentNewObj;
var MOHAHUDStr TopString;
var MOHAHUDImg MiddleImg;
var MOHAHUDStr BottomString;
var float fUpgradePosX;
var float fUpgradePosY;
var float fUpgradeBenefitPosYAdjust;
var array<MOHAHUDObj> HUDObjects;
var float fAirDropLandingPosY;

// Export UMOHAHUDMessageQueue::execRender(FFrame&, void* const)
native function bool Render(Canvas Canvas);

// Export UMOHAHUDMessageQueue::execDisplayCurrentNotification(FFrame&, void* const)
native function DisplayCurrentNotification();

// Export UMOHAHUDMessageQueue::execStartFade(FFrame&, void* const)
native function StartFade(float new_fFadeInTime, float new_fMaxAlpha, float new_fFadeOutTime);

// Export UMOHAHUDMessageQueue::execOnResolutionChange(FFrame&, void* const)
native function OnResolutionChange(float resolutionScale);

// Export UMOHAHUDMessageQueue::execSetRenderInMode(FFrame&, void* const)
native function SetRenderInMode(MOHAHUD.EHUDRenderMode RenderMode);

function Setup()
{
    JustifyXCenter();
    JustifyYCenter();
    TopString = new Class'MOHAHUDStr';
    TopString.MOHAHUD = MOHAHUD;
    TopString.UpdateFont(MOHAHUD.GetMediumTextFont());
    TopString.Link(self, 0, 1);
    TopString.JustifyXCenter();
    TopString.EnableElement(true);
    MiddleImg = new Class'MOHAHUDImg';
    MiddleImg.MOHAHUD = MOHAHUD;
    MiddleImg.Link(TopString, 0, 2);
    MiddleImg.JustifyXCenter();
    MiddleImg.EnableElement(true);
    BottomString = new Class'MOHAHUDStr';
    BottomString.MOHAHUD = MOHAHUD;
    BottomString.UpdateFont(MOHAHUD.GetMediumTextFont());
    BottomString.Link(MiddleImg, 0, 2);
    BottomString.JustifyXCenter();
    BottomString.EnableElement(true);
    HUDObjects[0] = TopString;
    HUDObjects[1] = MiddleImg;
    HUDObjects[2] = BottomString;
    SetRenderInMode(1);
    SetRenderInMode(2);
    messages.Length = 15;
    //return;    
}

event ShowCheckpointReachedText()
{
    AddNotification(DefaultFont, CheckpointReachedText, "", none, 0.0000000, 0.0000000, 0.0000000, 0.0000000, 0.0000000, 0.0000000, DefaultDisplayTime, DefaultFadeInTime, DefaultFadeoutTime, DefaultDelayTime, SoundCue'Aud_GCm_FakeWAV.Items.Checkpoint_Reached_PC', 0, default.ObjectivePos.X, default.ObjectivePos.Y);
    //return;    
}

function ShowMedalText(int upgrade, float fLevelUpDisplayTime, float fLevelUpFadeInTime, float fLevelUpFadeOutTime, float fLevelUpDelayTime)
{
    AddNotification(MedalMsgFont, ExperienceCommendations[upgrade], "", ExperienceIcons[upgrade], 0.0000000, 0.0000000, 128.0000000, 128.0000000, fMedalIconPixelSize * fUpgradeIconScaleFactor, fMedalIconPixelSize * fUpgradeIconScaleFactor, fLevelUpDisplayTime, fLevelUpFadeInTime, fLevelUpFadeOutTime, fLevelUpDelayTime, LeveledWeaponSound, 1, fUpgradePosX, fUpgradePosY);
    //return;    
}

function ShowUpgradeText(class<MOHAHUDWeaponInfo> info_class, int upgrade, string upgrade_name, float fUpgradeDisplayTime, float fUpgradeFadeInTime, float fUpgradeFadeOutTime, float fUpgradeDelayTime, bool bShowUpgradeBenefit)
{
    local array<string> LocalizedStringVars;
    local string UpgradeText;

    LocalizedStringVars[LocalizedStringVars.Length] = upgrade_name;
    UpgradeText = Class'Engine.FormattedString'.static.FormatLocalizedStringVars(UpgradeAwardedText, LocalizedStringVars);
    // End:0x1AC
    if(bShowUpgradeBenefit)
    {
        AddNotification(UpgradeMsgFont, UpgradeText, info_class.default.Info[upgrade].UpgradeBenefit, info_class.default.UpgradeIconsImage, info_class.default.Info[upgrade].IconUV.X, info_class.default.Info[upgrade].IconUV.Y, info_class.default.Info[upgrade].IconUVSize.X, info_class.default.Info[upgrade].IconUVSize.Y, info_class.default.Info[upgrade].IconPixelSize.X * fUpgradeIconScaleFactor, info_class.default.Info[upgrade].IconPixelSize.Y * fUpgradeIconScaleFactor, fUpgradeDisplayTime, fUpgradeFadeInTime, fUpgradeFadeOutTime, fUpgradeDelayTime, UpgradeFoundSound, 1, fUpgradePosX, fUpgradePosY - fUpgradeBenefitPosYAdjust);        
    }
    else
    {
        AddNotification(UpgradeMsgFont, UpgradeText, "", info_class.default.UpgradeIconsImage, info_class.default.Info[upgrade].IconUV.X, info_class.default.Info[upgrade].IconUV.Y, info_class.default.Info[upgrade].IconUVSize.X, info_class.default.Info[upgrade].IconUVSize.Y, info_class.default.Info[upgrade].IconPixelSize.X * fUpgradeIconScaleFactor, info_class.default.Info[upgrade].IconPixelSize.Y * fUpgradeIconScaleFactor, fUpgradeDisplayTime, fUpgradeFadeInTime, fUpgradeFadeOutTime, fUpgradeDelayTime, UpgradeFoundSound, 1, fUpgradePosX, fUpgradePosY - fUpgradeBenefitPosYAdjust);
    }
    //return;    
}

function ShowAirdropLandingIcon(MOHAPlayerPawn.EAirDropLandingType landingType)
{
    local MOHAIncludeClass.EHUDNotifications eNotification;

    switch(landingType)
    {
        // End:0x0C
        case 0:
        // End:0x1C
        case 6:
            eNotification = 5;
            // End:0x3A
            break;
        // End:0x2C
        case 5:
            eNotification = 6;
            // End:0x3A
            break;
        // End:0xFFFF
        default:
            eNotification = 7;
            // End:0x3A
            break;
            break;
    }
    AddNotification(DefaultFont, GenericNotifyInfoNew[int(eNotification)].TopText, GenericNotifyInfoNew[int(eNotification)].BottomText, GenericNotifyInfoNew[int(eNotification)].Image, GenericNotifyInfoNew[int(eNotification)].U, GenericNotifyInfoNew[int(eNotification)].V, GenericNotifyInfoNew[int(eNotification)].uw, GenericNotifyInfoNew[int(eNotification)].vh, GenericNotifyInfoNew[int(eNotification)].fSizeX, GenericNotifyInfoNew[int(eNotification)].fSizeY, DefaultDisplayTime, DefaultFadeInTime, DefaultFadeoutTime, DefaultDelayTime, GenericNotifyInfoNew[int(eNotification)].notifySound, 0,, fAirDropLandingPosY);
    //return;    
}

function SetObjectiveText(string NewText, string newTitle, float FadeInTime, float MaxAlphaTime, float FadeOutTime, optional SoundCue SoundCue = none, optional EALAObjective NewObj = none)
{
    AddNotification(ObjectiveMsgFont, newTitle, NewText, ObjectiveIconImg, ObjectiveIconUV.X, ObjectiveIconUV.Y, ObjectiveIconUVSize.X, ObjectiveIconUVSize.Y, ObjectiveIconPixelSize.X, ObjectiveIconPixelSize.Y, MaxAlphaTime, FadeInTime, FadeOutTime, DefaultDelayTime, SoundCue, 0, ObjectivePos.X, ObjectivePos.Y, NewObj);
    //return;    
}

function ShowSkillDropText(int NumFound, int MaxSkillDrops)
{
    local string ParseText, NumFoundString, MaxSkillDropsString;

    NumFoundString = "" $ string(NumFound);
    MaxSkillDropsString = "" $ string(MaxSkillDrops);
    ParseText = GenericNotifyInfoNew[8].TopText;
    Class'Engine.FormattedString'.static.ReplaceText(ParseText, "%1", NumFoundString);
    Class'Engine.FormattedString'.static.ReplaceText(ParseText, "%2", MaxSkillDropsString);
    AddNotification(DefaultFont, ParseText, GenericNotifyInfoNew[8].BottomText, GenericNotifyInfoNew[8].Image, GenericNotifyInfoNew[8].U, GenericNotifyInfoNew[8].V, GenericNotifyInfoNew[8].uw, GenericNotifyInfoNew[8].vh, GenericNotifyInfoNew[8].fSizeX, GenericNotifyInfoNew[8].fSizeY, DefaultDisplayTime, DefaultFadeInTime, DefaultFadeoutTime, DefaultDelayTime, GenericNotifyInfoNew[8].notifySound);
    //return;    
}

function MedalMomentNotify(MOHAIncludeClass.EHUDNotifications Type, bool IsGrenadeKill)
{
    AddNotification(DefaultFont, GenericNotifyInfoNew[int(Type)].TopText, GenericNotifyInfoNew[int(Type)].BottomText, GenericNotifyInfoNew[int(Type)].Image, GenericNotifyInfoNew[int(Type)].U, GenericNotifyInfoNew[int(Type)].V, GenericNotifyInfoNew[int(Type)].uw, GenericNotifyInfoNew[int(Type)].vh, float(MedalMomentIconSize), float(MedalMomentIconSize), DefaultDisplayTime, DefaultFadeInTime, DefaultFadeoutTime, DefaultDelayTime, GenericNotifyInfoNew[int(Type)].notifySound, (((int(Type) == int(3)) || int(Type) == int(4)) ? 2 : 0), ((IsGrenadeKill) ? GrenadeKillNotifyIconLoc.X : GunKillNotifyIconLoc.X), ((IsGrenadeKill) ? GrenadeKillNotifyIconLoc.Y : GunKillNotifyIconLoc.Y));
    // End:0x194
    if(MOHAHUD != none)
    {
        MOHAHUD.ToggleWeaponInfo(false,, ((IsGrenadeKill) ? 1 : 0));
    }
    //return;    
}

function SkillDropDiscovered(string msg)
{
    GenericNotify(9);
    AddNotification(DefaultFont, msg, "", GenericNotifyInfoNew[9].Image, GenericNotifyInfoNew[9].U, GenericNotifyInfoNew[9].V, GenericNotifyInfoNew[9].uw, GenericNotifyInfoNew[9].vh, GenericNotifyInfoNew[9].fSizeX, GenericNotifyInfoNew[9].fSizeY, DefaultDisplayTime, DefaultFadeInTime, DefaultFadeoutTime, DefaultDelayTime, GenericNotifyInfoNew[9].notifySound);
    //return;    
}

function GenericNotify(MOHAIncludeClass.EHUDNotifications Type)
{
    AddNotification(DefaultFont, GenericNotifyInfoNew[int(Type)].TopText, GenericNotifyInfoNew[int(Type)].BottomText, GenericNotifyInfoNew[int(Type)].Image, GenericNotifyInfoNew[int(Type)].U, GenericNotifyInfoNew[int(Type)].V, GenericNotifyInfoNew[int(Type)].uw, GenericNotifyInfoNew[int(Type)].vh, GenericNotifyInfoNew[int(Type)].fSizeX, GenericNotifyInfoNew[int(Type)].fSizeY, DefaultDisplayTime, DefaultFadeInTime, DefaultFadeoutTime, DefaultDelayTime, GenericNotifyInfoNew[int(Type)].notifySound);
    //return;    
}

function AddNotification(Font MessageFont, string TopText, string BottomText, Texture2D T, float U, float V, float uw, float vh, float fSizeX, float fSizeY, float fDisplayTime, float fFadeIn_Time, float fFadeOut_Time, float fDelayTime, optional SoundCue Sound = none, optional MOHAHUDMessageQueue.InstantShowMode instantShow = 0, optional float fPosX = 0.5000000, optional float fPosY = 0.8200000, optional EALAObjective NewObj = none)
{
    local int Index;
    local float resScale;

    // End:0x30
    if(numActive >= 15)
    {
        return;
    }
    // End:0xB8
    if(int(instantShow) == int(1))
    {
        // End:0x83
        if((numActive > 0) && messages[CurrentIndex].time_active > 0.0000000)
        {
            messages[CurrentIndex].notifySound = none;
        }
        Index = ((CurrentIndex > 0) ? CurrentIndex - 1 : 15 - 1);
        CurrentIndex = Index;
        numActive++;        
    }
    else
    {
        // End:0xE3
        if((int(instantShow) == int(2)) && numActive > 0)
        {
            Index = CurrentIndex;            
        }
        else
        {
            Index = int(float(CurrentIndex + numActive) % float(15));
            numActive++;
        }
    }
    // End:0x125
    if(MOHAHUD != none)
    {
        resScale = MOHAHUD.resolutionScale;
    }
    messages[Index].MessageFont = MessageFont;
    messages[Index].TopText = TopText;
    messages[Index].BottomText = BottomText;
    messages[Index].Image = T;
    messages[Index].U = U;
    messages[Index].V = V;
    messages[Index].uw = uw;
    messages[Index].vh = vh;
    messages[Index].fDisplayTime = fDisplayTime;
    messages[Index].fFadeInTime = fFadeIn_Time;
    messages[Index].fFadeOutTime = fFadeOut_Time;
    messages[Index].fDelayTime = fDelayTime;
    messages[Index].fSizeX = fSizeX * resScale;
    messages[Index].fSizeY = fSizeY * resScale;
    messages[Index].notifySound = Sound;
    messages[Index].fPosX = fPosX;
    messages[Index].fPosY = fPosY;
    messages[Index].NewObj = NewObj;
    // End:0x340
    if((numActive == 1) || int(instantShow) != int(0))
    {
        DisplayCurrentNotification();
    }
    //return;    
}

event UpdateObjectiveFont(Font NewObjectiveMsgFont)
{
    ObjectiveMsgFont = NewObjectiveMsgFont;
    //return;    
}

defaultproperties
{
    GenericNotifyInfoNew[0]=(TopText="",BottomText="",Image=Texture2D'HUD.HUDMultiIcons02',U=288.0000000,V=190.0000000,uw=32.0000000,vh=32.0000000,fDisplayTime=0.0000000,fFadeInTime=0.0000000,fFadeOutTime=0.0000000,fDelayTime=0.0000000,time_active=0.0000000,fSizeX=32.0000000,fSizeY=32.0000000,fPosX=0.0000000,fPosY=0.0000000,notifySound=SoundCue'Aud_GCm_FakeWAV.Items.Medal_Earned',MessageFont=none,NewObj=none)
    GenericNotifyInfoNew[1]=(TopText="",BottomText="",Image=Texture2D'HUD.HUDMultiIcons02',U=256.0000000,V=448.0000000,uw=64.0000000,vh=64.0000000,fDisplayTime=0.0000000,fFadeInTime=0.0000000,fFadeOutTime=0.0000000,fDelayTime=0.0000000,time_active=0.0000000,fSizeX=75.0000000,fSizeY=75.0000000,fPosX=0.0000000,fPosY=0.0000000,notifySound=SoundCue'Aud_GCm_FakeWAV.Items.Medal_Earned',MessageFont=none,NewObj=none)
    GenericNotifyInfoNew[2]=(TopText="",BottomText="",Image=Texture2D'HUD.HUDMultiIcons02',U=320.0000000,V=448.0000000,uw=64.0000000,vh=64.0000000,fDisplayTime=0.0000000,fFadeInTime=0.0000000,fFadeOutTime=0.0000000,fDelayTime=0.0000000,time_active=0.0000000,fSizeX=75.0000000,fSizeY=75.0000000,fPosX=0.0000000,fPosY=0.0000000,notifySound=SoundCue'Aud_GCm_FakeWAV.Items.Medal_Earned',MessageFont=none,NewObj=none)
    GenericNotifyInfoNew[3]=(TopText="",BottomText="",Image=Texture2D'HUD.HUDMultiIcons02',U=192.0000000,V=448.0000000,uw=64.0000000,vh=64.0000000,fDisplayTime=0.0000000,fFadeInTime=0.0000000,fFadeOutTime=0.0000000,fDelayTime=0.0000000,time_active=0.0000000,fSizeX=75.0000000,fSizeY=75.0000000,fPosX=0.0000000,fPosY=0.0000000,notifySound=SoundCue'Aud_GCm_FakeWAV.Items.HeadShot',MessageFont=none,NewObj=none)
    GenericNotifyInfoNew[4]=(TopText="",BottomText="",Image=Texture2D'HUD.HUDMultiIcons02',U=446.0000000,V=128.0000000,uw=64.0000000,vh=64.0000000,fDisplayTime=0.0000000,fFadeInTime=0.0000000,fFadeOutTime=0.0000000,fDelayTime=0.0000000,time_active=0.0000000,fSizeX=75.0000000,fSizeY=75.0000000,fPosX=0.0000000,fPosY=0.0000000,notifySound=SoundCue'Aud_GCm_FakeWAV.Items.Medal_Earned',MessageFont=none,NewObj=none)
    GenericNotifyInfoNew[5]=(TopText="Greased Landing!",BottomText="",Image=Texture2D'HUD.HUDMultiIcons02',U=256.0000000,V=192.0000000,uw=64.0000000,vh=64.0000000,fDisplayTime=0.0000000,fFadeInTime=0.0000000,fFadeOutTime=0.0000000,fDelayTime=0.0000000,time_active=0.0000000,fSizeX=64.0000000,fSizeY=64.0000000,fPosX=0.0000000,fPosY=0.0000000,notifySound=SoundCue'Aud_GCm_FakeWAV.Items.Medal_Earned',MessageFont=none,NewObj=none)
    GenericNotifyInfoNew[6]=(TopText="Flared Landing!",BottomText="",Image=Texture2D'HUD.HUDMultiIcons02',U=192.0000000,V=256.0000000,uw=64.0000000,vh=64.0000000,fDisplayTime=0.0000000,fFadeInTime=0.0000000,fFadeOutTime=0.0000000,fDelayTime=0.0000000,time_active=0.0000000,fSizeX=64.0000000,fSizeY=64.0000000,fPosX=0.0000000,fPosY=0.0000000,notifySound=SoundCue'Aud_GCm_FakeWAV.Items.Medal_Earned',MessageFont=none,NewObj=none)
    GenericNotifyInfoNew[7]=(TopText="Botched Landing!",BottomText="",Image=Texture2D'HUD.HUDMultiIcons02',U=256.0000000,V=256.0000000,uw=64.0000000,vh=64.0000000,fDisplayTime=0.0000000,fFadeInTime=0.0000000,fFadeOutTime=0.0000000,fDelayTime=0.0000000,time_active=0.0000000,fSizeX=64.0000000,fSizeY=64.0000000,fPosX=0.0000000,fPosY=0.0000000,notifySound=SoundCue'Aud_GCm_FakeWAV.Items.Medal_Earned',MessageFont=none,NewObj=none)
    GenericNotifyInfoNew[8]=(TopText="%1 of %2 Skill Drops Complete!",BottomText="",Image=Texture2D'HUD.HUDMultiIcons02',U=320.0000000,V=192.0000000,uw=64.0000000,vh=64.0000000,fDisplayTime=0.0000000,fFadeInTime=0.0000000,fFadeOutTime=0.0000000,fDelayTime=0.0000000,time_active=0.0000000,fSizeX=64.0000000,fSizeY=64.0000000,fPosX=0.0000000,fPosY=0.0000000,notifySound=SoundCue'Aud_GCm_FakeWAV.Items.Medal_Earned',MessageFont=none,NewObj=none)
    GenericNotifyInfoNew[9]=(TopText="Skill Drop Discovered",BottomText="",Image=Texture2D'HUD.HUDMultiIcons02',U=320.0000000,V=192.0000000,uw=64.0000000,vh=64.0000000,fDisplayTime=0.0000000,fFadeInTime=0.0000000,fFadeOutTime=0.0000000,fDelayTime=0.0000000,time_active=0.0000000,fSizeX=64.0000000,fSizeY=64.0000000,fPosX=0.0000000,fPosY=0.0000000,notifySound=SoundCue'Aud_GCm_FakeWAV.Items.Medal_Earned',MessageFont=none,NewObj=none)
    UpgradeAwardedText="%1 Awarded"
    CheckpointReachedText="Checkpoint Reached"
    GrenadeKillNotifyIconLoc=(X=0.7950000,Y=0.8800000)
    GunKillNotifyIconLoc=(X=0.9300000,Y=0.8800000)
    MedalMomentIconSize=60
    DefaultDisplayTime=3.0000000
    DefaultFadeInTime=0.2500000
    DefaultFadeoutTime=1.0000000
    fMedalIconPixelSize=150.0000000
    fUpgradeIconScaleFactor=0.8330000
    UpgradeFoundSound=SoundCue'Aud_GCm_FakeWAV.Items.Upgrade_Found'
    LeveledWeaponSound=SoundCue'Aud_GCm_FakeWAV.Items.Upgrade_ExperienceLevelUp'
    ExperienceIcons[0]=Texture2D'HUD.Weapon_1'
    ExperienceIcons[1]=Texture2D'HUD.Weapon_2'
    ExperienceIcons[2]=Texture2D'HUD.Weapon_3'
    ExperienceCommendations[0]="Marksman Commendation Awarded"
    ExperienceCommendations[1]="Sharpshooter Commendation Awarded"
    ExperienceCommendations[2]="Expert Commendation Awarded"
    ObjectiveIconImg=Texture2D'HUD.HUDMultiIcons02'
    ObjectiveIconUV=(X=450.0000000,Y=225.0000000)
    ObjectiveIconUVSize=(X=62.0000000,Y=62.0000000)
    ObjectiveIconPixelSize=(X=62.0000000,Y=62.0000000)
    ObjectivePos=(X=0.5000000,Y=0.1000000)
    fUpgradePosX=0.5000000
    fUpgradePosY=0.1130000
    fUpgradeBenefitPosYAdjust=0.0130000
    fAirDropLandingPosY=0.8350000
}