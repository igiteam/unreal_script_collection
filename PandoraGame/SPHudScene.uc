class SPHudScene extends SPUIScene;

const Epsilon = 0.0001;
const WhiteToRedSeconds = 0.5;

enum EScreenTextType
{
    ESTT_None,                      // 0
    ESTT_Siphon,                    // 1
    ESTT_SwapWeapon,                // 2
    ESTT_PickupItem,                // 3
    ESTT_UsedTrigger,               // 4
    ESTT_Info,                      // 5
    ESTT_SubTitle,                  // 6
    ESTT_Max                        // 7
};

enum EUIObjectType
{
    EUIT_None,                      // 0
    EUIT_Image,                     // 1
    EUIT_Label,                     // 2
    EUIT_Button,                    // 3
    EUIT_ProgressBar,               // 4
    EUIT_MAX                        // 5
};

struct native ReticleSpreadStruct
{
    var Vector2D Location[4];
    var float Spread;

    structdefaultproperties
    {
        Location[0]=(X=0.0000000,Y=0.0000000)
        Location[1]=(X=0.0000000,Y=0.0000000)
        Location[2]=(X=0.0000000,Y=0.0000000)
        Location[3]=(X=0.0000000,Y=0.0000000)
        Spread=0.0000000
    }
};

struct native ScreenTextInfo
{
    var string ScreenText;
    var SPHudScene.EScreenTextType TextType;
    var float TimeDisplayed;
    var float TimeToRemove;
    var bool bOnDisplay;
    var int LabelId;

    structdefaultproperties
    {
        ScreenText=""
        TextType=ESTT_None
        TimeDisplayed=0.0000000
        TimeToRemove=0.0000000
        bOnDisplay=false
        LabelId=0
    }
};

struct native MonsterMachineBarInfo
{
    var float holdAtMaxGlowTime;
    var float currGlowValue;
    var float destGlowValue;
    var MaterialInstanceConstant matInstance;

    structdefaultproperties
    {
        holdAtMaxGlowTime=0.0000000
        currGlowValue=0.0000000
        destGlowValue=0.0000000
        matInstance=none
    }
};

struct native HudElementInfo
{
    var() string UIObjName;
    var UIObject UIObj;
    var() SPHudScene.EUIObjectType UIObjType;
    var MaterialInstanceConstant matInstance;
    /** How long it takes for this element to turn off. */
    var() float TurnOffTime;

    structdefaultproperties
    {
        UIObjName=""
        UIObj=none
        UIObjType=EUIT_None
        matInstance=none
        TurnOffTime=0.0000000
    }
};

struct native GrenadeMolotovHudElementInfo
{
    var() string UIObjName;
    var UIObject UIObj;
    var() SPHudScene.EUIObjectType UIObjType;
    var MaterialInstanceConstant MatInstancePickup;
    var() string PickupImageName;

    structdefaultproperties
    {
        UIObjName=""
        UIObj=none
        UIObjType=EUIT_None
        MatInstancePickup=none
        PickupImageName=""
    }
};

struct native PickupHudElementInfo
{
    var() string UIObjName;
    var UIObject UIObj;
    var() SPHudScene.EUIObjectType UIObjType;
    var MaterialInstanceConstant MatInstancePickup;
    var() string PickupImageName;
    var UILabel PickupText;
    var() string PickupTextName;
    /** How long it takes for this element to turn off. */
    var() float TurnOffTime;

    structdefaultproperties
    {
        UIObjName=""
        UIObj=none
        UIObjType=EUIT_None
        MatInstancePickup=none
        PickupImageName=""
        PickupText=none
        PickupTextName=""
        TurnOffTime=0.0000000
    }
};

struct native WeaponPickupHudElementInfo
{
    var() string UIObjName;
    var UIObject UIObj;
    var() SPHudScene.EUIObjectType UIObjType;
    var MaterialInstanceConstant MatInstancePickupWeapon;
    var() string PickupWeaponImageName;
    var UILabel PickupText;
    var() string PickupTextName;
    /** How long it takes for this element to turn off. */
    var() float TurnOffTime;

    structdefaultproperties
    {
        UIObjName=""
        UIObj=none
        UIObjType=EUIT_None
        MatInstancePickupWeapon=none
        PickupWeaponImageName=""
        PickupText=none
        PickupTextName=""
        TurnOffTime=0.0000000
    }
};

struct native WeaponSwapHudElementInfo
{
    var() string UIObjName;
    var UIObject UIObj;
    var() SPHudScene.EUIObjectType UIObjType;
    var MaterialInstanceConstant MatInstanceRightWeapon;
    var() string RightWeaponImageName;
    var MaterialInstanceConstant MatInstanceLeftWeapon;
    var() string LeftWeaponImageName;
    var MaterialInstanceConstant MatInstanceBottomWeapon;
    var() string BottomWeaponImageName;
    var MaterialInstanceConstant MatInstanceTopWeapon;
    var() string TopWeaponImageName;
    var UIObject DPad;
    var() string DPadName;
    /** How long it takes for this element to turn off. */
    var() float TurnOffTime;

    structdefaultproperties
    {
        UIObjName=""
        UIObj=none
        UIObjType=EUIT_None
        MatInstanceRightWeapon=none
        RightWeaponImageName=""
        MatInstanceLeftWeapon=none
        LeftWeaponImageName=""
        MatInstanceBottomWeapon=none
        BottomWeaponImageName=""
        MatInstanceTopWeapon=none
        TopWeaponImageName=""
        DPad=none
        DPadName=""
        TurnOffTime=0.0000000
    }
};

var ReticleSpreadStruct reticleSpread;
var private float reticleHitCounter;
var private int reticleCanvasX;
var private int reticleCanvasY;
var private int reticleSizeX;
var private int reticleSizeY;
var private int reticlePosX;
var private int reticlePosY;
var private int reticleOffset;
var private int maxReticleOffset;
var private bool bFired;
var bool bStartFadeIn;
var bool bStartFadeOut;
var bool m_bAnimusFullFadeRedGlow;
var bool m_bInitAnimusParams;
var bool m_bAnimusFullFadingIn;
var bool bShowHealthBar;
var bool bShowAmmoBar;
var bool bShowPickupWeaponBar;
var bool bShowWeaponPickupBar;
var bool bShowWeaponSwapBar;
var bool bShowCrouchPanel;
var bool bShowReticle;
var bool bShowPickupPanel1;
var bool bUsingPickupSlot1;
var bool bShowPickupPanel2;
var bool bUsingPickupSlot2;
var bool bShowPickupPanel3;
var bool bUsingPickupSlot3;
var bool bApplyGlowForPickupChange;
var bool bFadeWhenInactive;
var bool bMMPosInit;
var bool bEnableAimDot;
var private int retSize;
var private int retLineSize;
var SPProgressBar health_fill;
var SPProgressBar healthBar_Red;
var SPProgressBar healthBar_RedGlow;
var SPUIImage animusBar;
var SPUIImage animusBar_Red;
var SPUIImage animusBar_RedGlow;
var SPUIImage reticleImage;
var SPUIImage aimDot;
var SPUIImage reticle_Left;
var SPUIImage reticle_Right;
var SPUIImage reticle_Top;
var SPUIImage reticle_Bottom;
var float prevAmmo;
var float ammoRemained;
var float m_fGrenadeFadeOutOpacity;
var SPUILabel ammoTotal;
var SPUILabel ammoInMagazine;
var SPUILabel grenadeNo;
var SPUIImage grenadeIcon;
var SPUIImage flareIcon;
var SPUIImage molotovIcon;
var SPUIImage stunIcon;
var SPUIImage grenadeIconGlow;
var float oldAmmoInmagazine;
var float oldAmmoTotal;
var int showHitTargetTime;
var float hitTargetFadeOutRate;
var SPUIImage hitTargetImage;
var SPUIImage gradient_backing;
var SPUIImage gradient_backing_r;
var float FadeInOpacity;
var float fadeInAmount;
var int FadeInTime;
var float FadeOutOpacity;
var float fadeOutAmount;
var int sprintBarFadeOutTime;
var int prevPH;
var float prevAnimus;
var int lostHealth;
var int gainHealth;
var int lostHealthDelayTime;
var int gainHealthDelayTime;
var float whiteToRedTime;
var Font ImpactFontGlow22;
var Font ImpactFontGlow18;
var LinearColor Red;
var LinearColor White;
var LinearColor reticleColor;
var int frame;
var float redPulses[40];
var int pulseCounter;
var int grenadeIconGlowTime;
var float grenadeIconGlowFadeOutRate;
var int oldGrenadeCount;
var int oldMolotovCount;
var int animusBarRedGlowFadeInTime;
var int animusBarRedGlowFadeOutTime;
var float animusBarRedGlowFadeInRate;
var float animusBarRedGlowFadeOutRate;
var float m_AnimusFullFadeMax;
var float m_animusBarRedGlowCachedValue;
var float m_animusFullFadeInRate;
var int m_animusFullFadeInTime;
var float healthBarIdleTime;
var float ammoBarIdleTime;
var float pickupWeaponBarIdleTime;
var float WeaponPickupBarIdleTime;
var float WeaponSwapBarIdleTime;
var float CrouchPanelIdleTime;
var float maxHealthBarIdleTime;
var float maxAmmoBarIdleTime;
var float maxPickupWeaponBarIdleTime;
var float maxWeaponPickupBarIdleTime;
var float maxWeaponSwapBarIdleTime;
var int m_fadeOutWeaponMessageAlpha;
var float HudFadeInTime;
var SPUILabel PickupPanelSlot1;
var name PickupPanelSlot1WeapID;
var float PickupPanelSlot1FadeTime;
var string PickupPanelSlot1Message;
var SPUILabel PickupPanelSlot2;
var name PickupPanelSlot2WeapID;
var float PickupPanelSlot2FadeTime;
var string PickupPanelSlot2Message;
var SPUILabel PickupPanelSlot3;
var name PickupPanelSlot3WeapID;
var SPUILabel healthBarPanel;
var SPUILabel AmmoBarPanel;
var SPUILabel MolotovBarPanel;
var SPUILabel GrenadeBarPanel;
var SPUILabel PickupWeaponPanel;
var SPUILabel WeaponPickupPanel;
var SPUILabel WeaponSwapPanel;
var SPUILabel CrouchPanel;
var SPUILabel ReticlePanel;
var int reticleFadeOutTime;
var int reticleFadeOutDelayTime;
var float reticleFadeOutRate;
var float reticleFadeOutSpreadRate;
var MaterialInstanceConstant healthBar_Red_matInstance;
var UILabel lblInteractiveText[2];
var UILabel lblInfoText;
var UILabel lblSubTitle;
var array<ScreenTextInfo> ScreenTextBuffer;
var int InteractiveCount;
var int InfoCount;
var int SubTitleCount;
var float mm1Pos0;
var float mm1Pos1;
var float mm1Pos2;
var float mm1Pos3;
var float mm2Pos0;
var float mm2Pos1;
var float mm2Pos2;
var float mm2Pos3;
var SPProgressBar team1MonsterMachineProgressBar;
var SPProgressBar team2MonsterMachineProgressBar;
var MonsterMachineBarInfo MonsterMachineGlowStatus[2];
var float GlowValueChangRate;
var float GlowHoldTime;
var float GlowMaxValue;
var(SPHudElements) array<HudElementInfo> GrenadeInventoryList;
var(SPHudElements) array<HudElementInfo> MolotovInventoryList;
var(SPHudElements) HudElementInfo AnimusSensor;
var(SPHudElements) HudElementInfo EmailIcon;
var(SPHudElements) GrenadeMolotovHudElementInfo GrenadeAmmoLabel;
var(SPHudElements) GrenadeMolotovHudElementInfo MolotovAmmoLabel;
var(SPHudElements) WeaponPickupHudElementInfo WeaponPickupLabel;
var(SPHudElements) WeaponSwapHudElementInfo WeaponSwapLabel;
var(SPHudElements) PickupHudElementInfo PickupSlot1SwapLabel;
var(SPHudElements) PickupHudElementInfo PickupSlot2SwapLabel;
var(SPHudElements) PickupHudElementInfo PickupSlot3SwapLabel;
var SPHud HudSceneOwner;
var UILabel lblSwapKey;

function Init_Widgets()
{
    local UIObject theMonsterScene, theMonsterScene1, theMonsterScene2;
    local PandoraPlayerController PC;
    local int I;

    health_fill = SPProgressBar(FindChild('health_fill', true));
    healthBar_RedGlow = SPProgressBar(FindChild('healthBar_RedGlow', true));
    healthBar_RedGlow.SetVisibility(false);
    healthBar_Red = SPProgressBar(FindChild('Health_fill_Red', true));
    gradient_backing = SPUIImage(FindChild('gradient_backing', true));
    animusBar = SPUIImage(FindChild('Circle_Animus', true));
    animusBar_Red = SPUIImage(FindChild('Circle_Animus_Red', true));
    animusBar_RedGlow = SPUIImage(FindChild('Circle_Animus_Glow', true));
    animusBar_RedGlow.SetVisibility(false);
    gradient_backing_r = SPUIImage(FindChild('gradient_backing_r', true));
    ammoTotal = SPUILabel(FindChild('Ammo_Total', true));
    ammoInMagazine = SPUILabel(FindChild('Ammo_InMagazine', true));
    grenadeNo = SPUILabel(FindChild('Grenade_Number', true));
    grenadeIcon = SPUIImage(FindChild('Grenade_Image', true));
    flareIcon = SPUIImage(FindChild('Flare_Image', true));
    molotovIcon = SPUIImage(FindChild('Molotov_icon', true));
    stunIcon = SPUIImage(FindChild('TazerGrenade_Image', true));
    grenadeIconGlow = SPUIImage(FindChild('grenade_icon_Glow', true));
    grenadeIconGlow.SetVisibility(false);
    healthBarPanel = SPUILabel(FindChild('Health', true));
    AmmoBarPanel = SPUILabel(FindChild('Ammo', true));
    MolotovBarPanel = SPUILabel(FindChild('MolotovPanel', true));
    GrenadeBarPanel = SPUILabel(FindChild('GrenadePanel', true));
    PickupWeaponPanel = SPUILabel(FindChild('Pickup_weapons', true));
    WeaponPickupPanel = SPUILabel(FindChild('WeaponPickupDisp', true));
    WeaponSwapPanel = SPUILabel(FindChild('WeaponSwapDisp', true));
    CrouchPanel = SPUILabel(FindChild('CrouchDisp', true));
    WeaponPickupBarFadeOut(0.0000000);
    ChildFadeOut(WeaponSwapPanel, 0.0000000);
    CrouchPanelFadeOut(0.0000000);
    PickupPanelSlot1 = SPUILabel(FindChild('PickupSlot1Disp', true));
    PickupPanelSlot2 = SPUILabel(FindChild('PickupSlot2Disp', true));
    PickupPanelSlot3 = SPUILabel(FindChild('PickupSlot3Disp', true));
    PickupPanel1FadeOut(0.0000000);
    PickupPanel2FadeOut(0.0000000);
    PickupPanel3FadeOut(0.0000000);
    ReticlePanel = SPUILabel(FindChild('reticle', true));
    reticleImage = SPUIImage(FindChild('Reticle_center', true));
    aimDot = SPUIImage(FindChild('aim_dot', true));
    reticle_Left = SPUIImage(FindChild('reticle_Left', true));
    reticle_Right = SPUIImage(FindChild('reticle_Right', true));
    reticle_Top = SPUIImage(FindChild('reticle_Top', true));
    reticle_Bottom = SPUIImage(FindChild('reticle_Bottom', true));
    hitTargetImage = SPUIImage(FindChild('Hit_target', true));
    lblInteractiveText[0] = UILabel(FindChild('lblInteractiveText0', true));
    lblInteractiveText[1] = UILabel(FindChild('lblInteractiveText1', true));
    lblInfoText = UILabel(FindChild('lblInfoText', true));
    lblSubTitle = UILabel(FindChild('lblSubTitle', true));
    InteractiveCount = 0;
    InfoCount = 0;
    SubTitleCount = 0;
    PC = GetPC();
    // End:0x515
    if(PC != none)
    {
        bFadeWhenInactive = PC.ProfileSettings.GetHUDOption();
    }
    I = 0;
    J0x51C:

    // End:0x5D6 [Loop If]
    if(I < GrenadeInventoryList.Length)
    {
        GrenadeInventoryList[I].UIObj = FindChild(name(GrenadeInventoryList[I].UIObjName), true);
        switch(GrenadeInventoryList[I].UIObjType)
        {
            // End:0x5C9
            case 1:
                GrenadeInventoryList[I].matInstance = ConvertImageTextureToMaterialInstanceConstant(UIImage(GrenadeInventoryList[I].UIObj).ImageComponent);
                // End:0x5CC
                break;
            // End:0xFFFF
            default:
                break;
        }
        I++;
        // [Loop Continue]
        goto J0x51C;
    }
    I = 0;
    J0x5DD:

    // End:0x697 [Loop If]
    if(I < MolotovInventoryList.Length)
    {
        MolotovInventoryList[I].UIObj = FindChild(name(MolotovInventoryList[I].UIObjName), true);
        switch(MolotovInventoryList[I].UIObjType)
        {
            // End:0x68A
            case 1:
                MolotovInventoryList[I].matInstance = ConvertImageTextureToMaterialInstanceConstant(UIImage(MolotovInventoryList[I].UIObj).ImageComponent);
                // End:0x68D
                break;
            // End:0xFFFF
            default:
                break;
        }
        I++;
        // [Loop Continue]
        goto J0x5DD;
    }
    AnimusSensor.UIObj = FindChild(name(AnimusSensor.UIObjName), true);
    AnimusSensor.matInstance = ConvertImageTextureToMaterialInstanceConstant(UIImage(AnimusSensor.UIObj).ImageComponent);
    EmailIcon.UIObj = FindChild(name(EmailIcon.UIObjName), true);
    EmailIcon.matInstance = ConvertImageTextureToMaterialInstanceConstant(UIImage(EmailIcon.UIObj).ImageComponent);
    GrenadeAmmoLabel.UIObj = FindChild(name(GrenadeAmmoLabel.PickupImageName), true);
    GrenadeAmmoLabel.MatInstancePickup = ConvertImageTextureToMaterialInstanceConstant(UIImage(GrenadeAmmoLabel.UIObj).ImageComponent);
    MolotovAmmoLabel.UIObj = FindChild(name(MolotovAmmoLabel.PickupImageName), true);
    MolotovAmmoLabel.MatInstancePickup = ConvertImageTextureToMaterialInstanceConstant(UIImage(MolotovAmmoLabel.UIObj).ImageComponent);
    // End:0x858
    if(GrenadeAmmoLabel.MatInstancePickup != none)
    {
        FadeOutGrenadeMolotovBox(true, GrenadeAmmoLabel.MatInstancePickup);
    }
    // End:0x889
    if(MolotovAmmoLabel.MatInstancePickup != none)
    {
        FadeOutGrenadeMolotovBox(true, MolotovAmmoLabel.MatInstancePickup);
    }
    WeaponPickupLabel.PickupText = UILabel(FindChild(name(WeaponPickupLabel.PickupTextName), true));
    WeaponPickupLabel.UIObj = FindChild(name(WeaponPickupLabel.PickupWeaponImageName), true);
    WeaponPickupLabel.MatInstancePickupWeapon = ConvertImageTextureToMaterialInstanceConstant(UIImage(WeaponPickupLabel.UIObj).ImageComponent);
    WeaponSwapLabel.DPad = FindChild(name(WeaponSwapLabel.DPadName), true);
    WeaponSwapLabel.UIObj = FindChild(name(WeaponSwapLabel.BottomWeaponImageName), true);
    WeaponSwapLabel.MatInstanceBottomWeapon = ConvertImageTextureToMaterialInstanceConstant(UIImage(WeaponSwapLabel.UIObj).ImageComponent);
    WeaponSwapLabel.UIObj = FindChild(name(WeaponSwapLabel.TopWeaponImageName), true);
    WeaponSwapLabel.MatInstanceTopWeapon = ConvertImageTextureToMaterialInstanceConstant(UIImage(WeaponSwapLabel.UIObj).ImageComponent);
    WeaponSwapLabel.UIObj = FindChild(name(WeaponSwapLabel.LeftWeaponImageName), true);
    WeaponSwapLabel.MatInstanceLeftWeapon = ConvertImageTextureToMaterialInstanceConstant(UIImage(WeaponSwapLabel.UIObj).ImageComponent);
    WeaponSwapLabel.UIObj = FindChild(name(WeaponSwapLabel.RightWeaponImageName), true);
    WeaponSwapLabel.MatInstanceRightWeapon = ConvertImageTextureToMaterialInstanceConstant(UIImage(WeaponSwapLabel.UIObj).ImageComponent);
    lblSwapKey = FindChild('lblSwapKey', true);
    PickupSlot1SwapLabel.PickupText = UILabel(FindChild(name(PickupSlot1SwapLabel.PickupTextName), true));
    PickupSlot1SwapLabel.UIObj = FindChild(name(PickupSlot1SwapLabel.PickupImageName), true);
    PickupSlot1SwapLabel.MatInstancePickup = ConvertImageTextureToMaterialInstanceConstant(UIImage(PickupSlot1SwapLabel.UIObj).ImageComponent);
    PickupSlot2SwapLabel.PickupText = UILabel(FindChild(name(PickupSlot2SwapLabel.PickupTextName), true));
    PickupSlot2SwapLabel.UIObj = FindChild(name(PickupSlot2SwapLabel.PickupImageName), true);
    PickupSlot2SwapLabel.MatInstancePickup = ConvertImageTextureToMaterialInstanceConstant(UIImage(PickupSlot2SwapLabel.UIObj).ImageComponent);
    PickupSlot3SwapLabel.PickupText = UILabel(FindChild(name(PickupSlot3SwapLabel.PickupTextName), true));
    PickupSlot3SwapLabel.UIObj = FindChild(name(PickupSlot3SwapLabel.PickupImageName), true);
    PickupSlot3SwapLabel.MatInstancePickup = ConvertImageTextureToMaterialInstanceConstant(UIImage(PickupSlot3SwapLabel.UIObj).ImageComponent);
    // End:0x1130
    if(ShouldDisplayMultiplayerHud())
    {
        SetProgressBar(health_fill);
        SetProgressBar(healthBar_RedGlow);
        healthBar_RedGlow.SetVisibility(false);
        SetProgressBar(healthBar_Red);
        SetImage(gradient_backing);
        SetImage(animusBar);
        SetImage(animusBar_Red);
        SetImage(animusBar_RedGlow);
        animusBar_RedGlow.SetVisibility(false);
        SetImage(gradient_backing_r);
        UpdateTeamColors();
        theMonsterScene = FindChild('MonsterMachine1', true);
        theMonsterScene.SetVisibility(true);
        team1MonsterMachineProgressBar = SPProgressBar(theMonsterScene.FindChild('MonsterMachine_fill'));
        theMonsterScene.FindChild('MonsterMachine_fill').SetVisibility(true);
        theMonsterScene.FindChild('MonsterMachine_frame').SetVisibility(true);
        MonsterMachineGlowStatus[0].matInstance = new (none) Class'Engine.MaterialInstanceConstant';
        MonsterMachineGlowStatus[0].matInstance.SetParent(Material(team1MonsterMachineProgressBar.FillImageComponent.ImageRef.ImageTexture));
        team1MonsterMachineProgressBar.FillImageComponent.ImageRef.ImageTexture = MonsterMachineGlowStatus[0].matInstance;
        theMonsterScene = FindChild('MonsterMachine2', true);
        theMonsterScene.SetVisibility(true);
        team2MonsterMachineProgressBar = SPProgressBar(theMonsterScene.FindChild('MonsterMachine_fill'));
        theMonsterScene.FindChild('MonsterMachine_fill').SetVisibility(true);
        theMonsterScene.FindChild('MonsterMachine_frame').SetVisibility(true);
        MonsterMachineGlowStatus[1].matInstance = new (none) Class'Engine.MaterialInstanceConstant';
        MonsterMachineGlowStatus[1].matInstance.SetParent(Material(team2MonsterMachineProgressBar.FillImageComponent.ImageRef.ImageTexture));
        team2MonsterMachineProgressBar.FillImageComponent.ImageRef.ImageTexture = MonsterMachineGlowStatus[1].matInstance;
        theMonsterScene1 = FindChild('MonsterMachine1', true);
        theMonsterScene2 = FindChild('MonsterMachine2', true);
        mm1Pos0 = theMonsterScene1.Position.Value[0];
        mm1Pos1 = theMonsterScene1.Position.Value[1];
        mm1Pos2 = theMonsterScene1.Position.Value[2];
        mm1Pos3 = theMonsterScene1.Position.Value[3];
        mm2Pos0 = theMonsterScene2.Position.Value[0];
        mm2Pos1 = theMonsterScene2.Position.Value[1];
        mm2Pos2 = theMonsterScene2.Position.Value[2];
        mm2Pos3 = theMonsterScene2.Position.Value[3];
        bMMPosInit = true;
        UpdateTeamColors();
    }
    //return;    
}

function SetAnimusSensor(bool bTurnOn)
{
    local float Value;

    // End:0xDB
    if(AnimusSensor.matInstance != none)
    {
        // End:0xAE
        if(bTurnOn && prevPH > 0)
        {
            healthBarIdleTime = 0.0000000;
            HealthBarFadeIn();
            AnimusSensor.matInstance.GetScalarParameterValue('Detect_Animus', Value);
            // End:0xAB
            if(Value != 1.0000000)
            {
                AnimusSensor.matInstance.SetScalarParameterValue('Detect_Animus', 1.0000000);
            }            
        }
        else
        {
            AnimusSensor.matInstance.SetScalarParameterValue('Detect_Animus', 0.0000000);
        }
    }
    //return;    
}

function SetEMailIcon(bool bTurnOn)
{
    // End:0x21
    if(int(GetWorldInfo().NetMode) != int(NM_Standalone))
    {
        return;
    }
    // End:0xB3
    if(EmailIcon.matInstance != none)
    {
        // End:0x86
        if(bTurnOn)
        {
            AmmoBarFadeIn();
            PickupWeaponBarFadeIn();
            EmailIcon.matInstance.SetScalarParameterValue('ReceiveMessage', 1.0000000);            
        }
        else
        {
            EmailIcon.matInstance.SetScalarParameterValue('ReceiveMessage', 0.0000000);
        }
    }
    //return;    
}

function bool UpdateTeamColors()
{
    local int RedOrBlueVal;
    local MaterialInstanceConstant dummyMatInst1, dummyMatInst2;
    local UIObject theMonsterScene1, theMonsterScene2;

    RedOrBlueVal = GetRedOrBlueTeamValue();
    // End:0x3F9
    if(RedOrBlueVal != -1)
    {
        switch(RedOrBlueVal)
        {
            // End:0x2E
            case 0:
                // End:0x38
                break;
            // End:0x35
            case 1:
                // End:0x38
                break;
            // End:0xFFFF
            default:
                break;
        }
        SetProgressBarTeamColor(health_fill, RedOrBlueVal);
        SetProgressBarTeamColor(healthBar_RedGlow, RedOrBlueVal);
        SetProgressBarTeamColor(healthBar_Red, RedOrBlueVal, dummyMatInst1, dummyMatInst2, healthBar_Red_matInstance);
        SetImageTeamColor(gradient_backing, RedOrBlueVal);
        SetImageTeamColor(animusBar, RedOrBlueVal);
        SetImageTeamColor(animusBar_Red, RedOrBlueVal);
        SetImageTeamColor(animusBar_RedGlow, RedOrBlueVal);
        SetImageTeamColor(gradient_backing_r, RedOrBlueVal);
        // End:0x17E
        if((GrenadeAmmoLabel.MatInstancePickup != none) && MolotovAmmoLabel.MatInstancePickup != none)
        {
            GrenadeAmmoLabel.MatInstancePickup.SetScalarParameterValue('RedOrBlueTeam', float(RedOrBlueVal));
            MolotovAmmoLabel.MatInstancePickup.SetScalarParameterValue('RedOrBlueTeam', float(RedOrBlueVal));
        }
        theMonsterScene1 = FindChild('MonsterMachine1', true);
        theMonsterScene2 = FindChild('MonsterMachine2', true);
        // End:0x3F4
        if(bMMPosInit)
        {
            // End:0x2D5
            if(RedOrBlueVal == 1)
            {
                theMonsterScene2.Position.Value[0] = mm1Pos0;
                theMonsterScene2.Position.Value[1] = mm1Pos1;
                theMonsterScene2.Position.Value[2] = mm1Pos2;
                theMonsterScene2.Position.Value[3] = mm1Pos3;
                theMonsterScene1.Position.Value[0] = mm2Pos0;
                theMonsterScene1.Position.Value[1] = mm2Pos1;
                theMonsterScene1.Position.Value[2] = mm2Pos2;
                theMonsterScene1.Position.Value[3] = mm2Pos3;                
            }
            else
            {
                // End:0x3F4
                if(RedOrBlueVal == 0)
                {
                    theMonsterScene1.Position.Value[0] = mm1Pos0;
                    theMonsterScene1.Position.Value[1] = mm1Pos1;
                    theMonsterScene1.Position.Value[2] = mm1Pos2;
                    theMonsterScene1.Position.Value[3] = mm1Pos3;
                    theMonsterScene2.Position.Value[0] = mm2Pos0;
                    theMonsterScene2.Position.Value[1] = mm2Pos1;
                    theMonsterScene2.Position.Value[2] = mm2Pos2;
                    theMonsterScene2.Position.Value[3] = mm2Pos3;
                }
            }
        }
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function int GetRedOrBlueTeamValue()
{
    local PlayerController PC;

    PC = PlayerOwner.Actor;
    // End:0x68
    if(PC != none)
    {
        // End:0x41
        if(int(PC.GetTeamNum()) == int(1))
        {
            return 0;
        }
        // End:0x62
        if(int(PC.GetTeamNum()) == int(2))
        {
            return 1;
        }
        return -1;
    }
    return -1;
    //return ReturnValue;    
}

function MaterialInstanceConstant GetMaterialInstanceConstant(UIComp_DrawImage Image)
{
    return MaterialInstanceConstant(Image.ImageRef.ImageTexture);
    //return ReturnValue;    
}

function MaterialInstanceConstant CreateMaterialInstanceConstant(UIComp_DrawImage Image)
{
    local MaterialInstanceConstant MaterialInstanceConstant;
    local MaterialInterface MaterialInterface;

    // End:0x98
    if((Image != none) && Image.ImageRef.ImageTexture != none)
    {
        MaterialInterface = MaterialInterface(Image.ImageRef.ImageTexture);
        // End:0x95
        if(MaterialInterface != none)
        {
            MaterialInstanceConstant = new (none) Class'Engine.MaterialInstanceConstant';
            // End:0x92
            if(MaterialInstanceConstant != none)
            {
                MaterialInstanceConstant.SetParent(MaterialInterface);                
            }            
        }        
    }
    return MaterialInstanceConstant;
    //return ReturnValue;    
}

function MaterialInstanceConstant ConvertImageTextureToMaterialInstanceConstant(UIComp_DrawImage Image)
{
    local MaterialInstanceConstant MaterialInstanceConstant;

    // End:0x67
    if((Image != none) && Image.ImageRef != none)
    {
        MaterialInstanceConstant = CreateMaterialInstanceConstant(Image);
        // End:0x64
        if(MaterialInstanceConstant != none)
        {
            Image.ImageRef.ImageTexture = MaterialInstanceConstant;            
        }        
    }
    return MaterialInstanceConstant;
    //return ReturnValue;    
}

function SetImage(SPUIImage Image)
{
    // End:0x3E
    if((Image != none) && Image.ImageComponent != none)
    {
        ConvertImageTextureToMaterialInstanceConstant(Image.ImageComponent);        
    }
    //return;    
}

function SetProgressBar(SPProgressBar theProgressBar)
{
    // End:0x59
    if((theProgressBar.BackgroundImageComponent != none) && theProgressBar.BackgroundImageComponent.ImageRef.ImageTexture != none)
    {
        ConvertImageTextureToMaterialInstanceConstant(theProgressBar.BackgroundImageComponent);
    }
    // End:0xB2
    if((theProgressBar.FillImageComponent != none) && theProgressBar.FillImageComponent.ImageRef.ImageTexture != none)
    {
        ConvertImageTextureToMaterialInstanceConstant(theProgressBar.FillImageComponent);
    }
    // End:0x10B
    if((theProgressBar.OverlayImageComponent != none) && theProgressBar.OverlayImageComponent.ImageRef.ImageTexture != none)
    {
        ConvertImageTextureToMaterialInstanceConstant(theProgressBar.OverlayImageComponent);
    }
    //return;    
}

function SetImageTeamColor(SPUIImage Image, int RedOrBlueVal, optional out MaterialInstanceConstant ImageComponent)
{
    local MaterialInstanceConstant MaterialInstanceConstant;

    // End:0xA7
    if(((Image != none) && Image.ImageComponent != none) && Image.ImageComponent.ImageRef != none)
    {
        MaterialInstanceConstant = MaterialInstanceConstant(Image.ImageComponent.ImageRef.ImageTexture);
        // End:0xA4
        if(MaterialInstanceConstant != none)
        {
            MaterialInstanceConstant.SetScalarParameterValue('RedOrBlueTeam', float(RedOrBlueVal));            
        }        
    }
    ImageComponent = MaterialInstanceConstant;
    //return;    
}

function SetProgressBarTeamColor(SPProgressBar theProgressBar, int RedOrBlueVal, optional out MaterialInstanceConstant BackgroundImageComponent, optional out MaterialInstanceConstant FillImageComponent, optional out MaterialInstanceConstant OverlayImageComponent)
{
    // End:0xA0
    if((theProgressBar.BackgroundImageComponent != none) && theProgressBar.BackgroundImageComponent.ImageRef.ImageTexture != none)
    {
        BackgroundImageComponent = MaterialInstanceConstant(theProgressBar.BackgroundImageComponent.ImageRef.ImageTexture);
        // End:0xA0
        if(BackgroundImageComponent != none)
        {
            BackgroundImageComponent.SetScalarParameterValue('RedOrBlueTeam', float(RedOrBlueVal));
        }
    }
    // End:0x13D
    if((theProgressBar.FillImageComponent != none) && theProgressBar.FillImageComponent.ImageRef.ImageTexture != none)
    {
        FillImageComponent = MaterialInstanceConstant(theProgressBar.FillImageComponent.ImageRef.ImageTexture);
        // End:0x13D
        if(FillImageComponent != none)
        {
            FillImageComponent.SetScalarParameterValue('RedOrBlueTeam', float(RedOrBlueVal));
        }
    }
    // End:0x1DA
    if((theProgressBar.OverlayImageComponent != none) && theProgressBar.OverlayImageComponent.ImageRef.ImageTexture != none)
    {
        OverlayImageComponent = MaterialInstanceConstant(theProgressBar.OverlayImageComponent.ImageRef.ImageTexture);
        // End:0x1DA
        if(OverlayImageComponent != none)
        {
            OverlayImageComponent.SetScalarParameterValue('RedOrBlueTeam', float(RedOrBlueVal));
        }
    }
    //return;    
}

function Tick_Widgets(float Time)
{
    local float currHealth, currOpacity;
    local bool bUpdateRedGlow;

    reticleHitCounter -= Time;
    bUpdateRedGlow = true;
    PickupPanelSlot1FadeTime -= Time;
    PickupPanelSlot2FadeTime -= Time;
    // End:0x48
    if(reticleHitCounter < -0.0001000)
    {
        reticleHitCounter = 0.0000000;
    }
    pulseCounter++;
    healthBarIdleTime += Time;
    // End:0x87
    if((healthBarIdleTime > maxHealthBarIdleTime) && prevPH >= 30)
    {
        HealthBarFadeOut(0.5000000);
    }
    ammoBarIdleTime += Time;
    // End:0xD1
    if((ammoBarIdleTime > maxAmmoBarIdleTime) && ammoRemained >= 0.0000000)
    {
        AmmoBarFadeOut(0.5000000);
        PickupWeaponBarFadeOut(0.5000000);
    }
    // End:0xDE
    if(animusBar_Red == none)
    {
        return;
    }
    // End:0x12C
    if(!HudSceneOwner.bShowHUD)
    {
        animusBar_RedGlow.SetVisibility(false);
        animusBarRedGlowFadeOutTime = 0;
        healthBar_RedGlow.SetVisibility(false);
        bUpdateRedGlow = false;
    }
    // End:0x1F7
    if(animusBar_Red.IsScaling() && bUpdateRedGlow)
    {
        animusBar_Red.SetOpacity(redPulses[int(float(pulseCounter) % float(40))]);
        // End:0x1CB
        if(animusBarRedGlowFadeInTime > 0)
        {
            currOpacity = animusBar_RedGlow.GetOpacity();
            currOpacity += animusBarRedGlowFadeInRate;
            animusBar_RedGlow.SetOpacity(currOpacity);
            animusBarRedGlowFadeInTime--;            
        }
        else
        {
            animusBar_RedGlow.SetOpacity(redPulses[int(float(pulseCounter) % float(40))]);
        }        
    }
    else
    {
        // End:0x28B
        if((animusBarRedGlowFadeOutTime > 0) && bUpdateRedGlow)
        {
            currOpacity = animusBar_RedGlow.GetOpacity();
            currOpacity -= animusBarRedGlowFadeOutRate;
            animusBar_RedGlow.SetOpacity(currOpacity);
            animusBarRedGlowFadeOutTime--;
            // End:0x28B
            if((animusBarRedGlowFadeOutTime == 0) || currOpacity <= 0.0000000)
            {
                animusBar_RedGlow.SetVisibility(false);
                animusBarRedGlowFadeOutTime = 0;
            }
        }
    }
    // End:0x385
    if(m_bAnimusFullFadeRedGlow && bUpdateRedGlow)
    {
        // End:0x2E7
        if(m_bInitAnimusParams)
        {
            m_bInitAnimusParams = false;
            animusBar_RedGlow.SetVisibility(true);
            m_bAnimusFullFadingIn = true;
            m_animusBarRedGlowCachedValue = animusBar_RedGlow.GetOpacity();
        }
        currOpacity = animusBar_RedGlow.GetOpacity();
        // End:0x349
        if(m_bAnimusFullFadingIn)
        {
            currOpacity += m_animusFullFadeInRate;
            animusBar_RedGlow.SetOpacity(currOpacity);
            // End:0x346
            if(currOpacity >= m_AnimusFullFadeMax)
            {
                m_bAnimusFullFadingIn = false;
            }            
        }
        else
        {
            currOpacity -= m_animusFullFadeInRate;
            animusBar_RedGlow.SetOpacity(currOpacity);
            // End:0x385
            if(currOpacity <= m_animusBarRedGlowCachedValue)
            {
                m_bAnimusFullFadeRedGlow = false;
            }
        }
    }
    // End:0x3DE
    if(lostHealthDelayTime <= 0)
    {
        // End:0x3DB
        if((lostHealth > 0) && (float(pulseCounter) % float(2)) == float(0))
        {
            lostHealth--;
            healthBar_Red.SetOverlay(float(prevPH), float(lostHealth));
        }        
    }
    else
    {
        lostHealthDelayTime--;
        whiteToRedTime -= Time;
        // End:0x409
        if(whiteToRedTime < float(0))
        {
            whiteToRedTime = 0.0000000;
        }
        // End:0x43D
        if(healthBar_Red_matInstance != none)
        {
            healthBar_Red_matInstance.SetScalarParameterValue('Red_or_White', whiteToRedTime / 0.5000000);
        }
    }
    // End:0x50E
    if((gainHealthDelayTime <= 0) && gainHealth > 0)
    {
        gainHealth--;
        // End:0x4BA
        if(gainHealth > 16)
        {
            currHealth = health_fill.GetValue();
            currHealth += 1.0000000;
            healthBar_RedGlow.SetValue(currHealth);
            health_fill.SetValue(currHealth);            
        }
        else
        {
            currOpacity = float(gainHealth);
            currOpacity /= float(16);
            healthBar_RedGlow.SetOpacity(currOpacity);
            // End:0x50B
            if(gainHealth == 0)
            {
                healthBar_RedGlow.SetVisibility(false);
            }
        }        
    }
    else
    {
        gainHealthDelayTime--;
    }
    UpdateGrenadeIconGlow();
    // End:0x539
    if(bFadeIn)
    {
        bFadeIn = IsFadeIn();
    }
    // End:0x553
    if(bFadeOut)
    {
        bFadeOut = IsFadeOut();
    }
    UpdateHitTargetIndicator();
    UpdateScreenText(Time);
    // End:0x59A
    if(ShouldDisplayMultiplayerHud())
    {
        UpdateMonsterMachineBarGlow(1, Time);
        UpdateMonsterMachineBarGlow(2, Time);
    }
    HudFadeInTime -= Time;
    // End:0x5C0
    if(HudFadeInTime < 0.0001000)
    {
        HudFadeInTime = 0.0001000;
    }
    // End:0x5ED
    if((prevPH <= 0) && !bFadeIn)
    {
        ChildFadeOut(ReticlePanel, 0.0000000);
    }
    //return;    
}

function SetAnimusBarOpacityFadeTime()
{
    // End:0x1B
    if(!m_bAnimusFullFadeRedGlow)
    {
        m_bInitAnimusParams = true;
        m_bAnimusFullFadeRedGlow = true;
    }
    //return;    
}

function ShowReticle()
{
    // End:0x12
    if(reticleFadeOutTime != 0)
    {
        reticleFadeOutTime = 0;
    }
    ReticlePanel.SetVisibility(true);
    aimDot.SetVisibility(true);
    aimDot.SetWidgetScale(1.0000000, 0.0000000);
    aimDot.SetOpacity(1.0000000);
    reticle_Left.SetOpacity(1.0000000);
    reticle_Right.SetOpacity(1.0000000);
    reticle_Top.SetOpacity(1.0000000);
    reticle_Bottom.SetOpacity(1.0000000);
    //return;    
}

function HideReticle(HUD H, name WeaponName, optional int FadeOutTime = 30, optional int DelayTime = 0, optional bool bAimDownSite = false)
{
    // End:0x5F
    if((reticleFadeOutTime == 0) && FadeOutTime > 0)
    {
        reticleFadeOutTime = FadeOutTime;
        reticleFadeOutRate = 0.0000000;
        reticleFadeOutDelayTime = DelayTime;
        reticleFadeOutSpreadRate = reticleSpread.Spread;
    }
    // End:0xC9
    if(WeaponName == 'shotgun')
    {
        reticle_Left.SetVisibility(false);
        reticle_Right.SetVisibility(false);
        reticle_Top.SetVisibility(false);
        reticle_Bottom.SetVisibility(false);        
    }
    else
    {
        reticle_Left.SetVisibility(true);
        reticle_Right.SetVisibility(true);
        reticle_Top.SetVisibility(true);
        reticle_Bottom.SetVisibility(true);
    }
    // End:0x248
    if(reticleFadeOutDelayTime <= 0)
    {
        // End:0x245
        if(reticleFadeOutTime > 0)
        {
            reticleFadeOutTime--;
            // End:0x15A
            if(FadeOutTime != 0)
            {
                reticleFadeOutRate += (1.0000000 / float(FadeOutTime));
            }
            reticleImage.SetOpacity(1.0000000 - reticleFadeOutRate);
            reticle_Left.SetOpacity(1.0000000 - reticleFadeOutRate);
            reticle_Right.SetOpacity(1.0000000 - reticleFadeOutRate);
            reticle_Top.SetOpacity(1.0000000 - reticleFadeOutRate);
            reticle_Bottom.SetOpacity(1.0000000 - reticleFadeOutRate);
            // End:0x245
            if(reticleFadeOutTime == 0)
            {
                ReticlePanel.SetVisibility(false);
                // End:0x23A
                if(!bEnableAimDot)
                {
                    aimDot.SetVisibility(false);
                }
                reticleFadeOutRate = 0.0000000;
            }
        }        
    }
    else
    {
        reticleFadeOutDelayTime--;
    }
    //return;    
}

function FadeIn(float InHudFadeInTime, optional float FadeInDelay = 0.0000000)
{
    // End:0x20
    if(!HudSceneOwner.bShowHUD)
    {
        return;
    }
    SetVisibility(true);
    HealthBarFadeIn(InHudFadeInTime);
    AmmoBarFadeIn(InHudFadeInTime);
    PickupWeaponBarFadeIn(InHudFadeInTime);
    ReticlePanelFadeIn(InHudFadeInTime);
    HideHitTargetIndicator();
    //return;    
}

function FadeOut(float hudFadeOutTime, optional float FadeOutDelay = 0.0000000)
{
    // End:0x2B
    if(!bFadeWhenInactive && HudSceneOwner.bShowHUD)
    {
        return;
    }
    HealthBarFadeOut(hudFadeOutTime);
    AmmoBarFadeOut(hudFadeOutTime);
    PickupWeaponBarFadeOut(hudFadeOutTime);
    ReticlePanelFadeOut(hudFadeOutTime);
    MolotovBarPanelFadeOut(hudFadeOutTime);
    GrenadeBarPanelFadeOut(hudFadeOutTime);
    FadeOutCrouchPanelFromToggleHud();
    FadeOutWeaponPickupPanelFromToggleHud();
    FadeOutWeaponSwapPanelFromToggleHud();
    FadeOutWeaponPickupItemsPanelFromToggleHud();
    RemoveTextFromBuffer(,, true);
    //return;    
}

function bool IsHudFadeIn()
{
    return HudFadeInTime > 0.0001000;
    //return ReturnValue;    
}

function HealthBarFadeIn(optional float InFadeInTime = 0.5000000)
{
    // End:0x20
    if(!HudSceneOwner.bShowHUD)
    {
        return;
    }
    // End:0x65
    if(!bShowHealthBar)
    {
        healthBarIdleTime = 0.0000000;
        HudFadeInTime = FMax(HudFadeInTime, InFadeInTime);
        ChildFadeIn(healthBarPanel, HudFadeInTime);
        bShowHealthBar = true;
    }
    //return;    
}

function AmmoBarFadeIn(optional float InFadeInTime = 0.5000000)
{
    local PandoraPlayerController PC;

    // End:0x20
    if(!HudSceneOwner.bShowHUD)
    {
        return;
    }
    PC = GetPC();
    // End:0x78
    if(!bShowAmmoBar)
    {
        ammoBarIdleTime = 0.0000000;
        HudFadeInTime = FMax(HudFadeInTime, InFadeInTime);
        ChildFadeIn(AmmoBarPanel, InFadeInTime);
        bShowAmmoBar = true;        
    }
    else
    {
        InFadeInTime = 0.0000000;
    }
    // End:0x1CC
    if(PC != none)
    {
        // End:0x108
        if(PC.GetTopWeapID() == 'Explosive')
        {
            PC.FadeOutGrenadeMolotovBoxTimer(true, MolotovAmmoLabel.MatInstancePickup);
            m_fGrenadeFadeOutOpacity = 0.0000000;
            PC.FadeInGrenadeMolotovBoxTimer(false, GrenadeAmmoLabel.MatInstancePickup);            
        }
        else
        {
            // End:0x182
            if(PC.GetTopWeapID() == 'Molotov')
            {
                PC.FadeOutGrenadeMolotovBoxTimer(true, GrenadeAmmoLabel.MatInstancePickup);
                m_fGrenadeFadeOutOpacity = 0.0000000;
                PC.FadeInGrenadeMolotovBoxTimer(false, MolotovAmmoLabel.MatInstancePickup);                
            }
            else
            {
                PC.FadeOutGrenadeMolotovBoxTimer(true, GrenadeAmmoLabel.MatInstancePickup);
                PC.FadeOutGrenadeMolotovBoxTimer(true, MolotovAmmoLabel.MatInstancePickup);
            }
        }
    }
    //return;    
}

function MolotovBarPanelFadeIn(float InFadeInTime)
{
    ChildFadeIn(MolotovBarPanel, InFadeInTime);
    //return;    
}

function GrenadeBarPanelFadeIn(float InFadeInTime)
{
    ChildFadeIn(GrenadeBarPanel, InFadeInTime);
    //return;    
}

function PickupWeaponBarFadeIn(optional float pickupWeaponBarFadeInTime = 0.5000000)
{
    // End:0x20
    if(!HudSceneOwner.bShowHUD)
    {
        return;
    }
    ammoBarIdleTime = 0.0000000;
    // End:0x65
    if(!bShowPickupWeaponBar)
    {
        HudFadeInTime = FMax(HudFadeInTime, pickupWeaponBarFadeInTime);
        ChildFadeIn(PickupWeaponPanel, pickupWeaponBarFadeInTime);
        bShowPickupWeaponBar = true;
    }
    //return;    
}

function FadeOutCrouchPanelFromToggleHud()
{
    CrouchPanelFadeOut(0.0000000);
    //return;    
}

function FadeOutWeaponPickupPanelFromToggleHud()
{
    WeaponPickupBarFadeOut();
    ResetWeaponPickupMaterialParams(WeaponPickupLabel.MatInstancePickupWeapon);
    //return;    
}

function FadeOutWeaponSwapPanelFromToggleHud()
{
    ChildFadeOut(WeaponSwapPanel, 0.0000000);
    ResetWeaponSwapMaterialParamsT(WeaponSwapLabel.MatInstanceTopWeapon);
    ResetWeaponSwapMaterialParams(WeaponSwapLabel.MatInstanceRightWeapon);
    ResetWeaponSwapMaterialParamsB(WeaponSwapLabel.MatInstanceBottomWeapon);
    ResetWeaponSwapMaterialParams(WeaponSwapLabel.MatInstanceLeftWeapon);
    //return;    
}

function FadeOutWeaponPickupItemsPanelFromToggleHud()
{
    // End:0x4D
    if(PickupPanelSlot1 != none)
    {
        ChildFadeOut(PickupPanelSlot1, 0.0000000);
        PickupSlot1SwapLabel.MatInstancePickup.SetScalarParameterValue('Reset', 0.0000000);
    }
    // End:0x9A
    if(PickupPanelSlot2 != none)
    {
        ChildFadeOut(PickupPanelSlot2, 0.0000000);
        PickupSlot2SwapLabel.MatInstancePickup.SetScalarParameterValue('Reset', 0.0000000);
    }
    // End:0xE7
    if(PickupPanelSlot3 != none)
    {
        ChildFadeOut(PickupPanelSlot3, 0.0000000);
        PickupSlot3SwapLabel.MatInstancePickup.SetScalarParameterValue('Reset', 0.0000000);
    }
    //return;    
}

function SetWeaponPickupPanel(name WeapID, string Message)
{
    local PandoraPlayerInput PPI;
    local PandoraPlayerController PPC;
    local string newMessage;

    PPC = GetPC();
    // End:0x35
    if(PPC != none)
    {
        PPI = PandoraPlayerInput(PPC.PlayerInput);
    }
    ResetWeaponPickupMaterialParams(WeaponPickupLabel.MatInstancePickupWeapon);
    WeaponPickupLabel.MatInstancePickupWeapon.SetScalarParameterValue(WeapID, 1.0000000);
    // End:0xA6
    if(PPI != none)
    {
        newMessage = PPI.ProcessButtonToFontMapping(Message);        
    }
    else
    {
        newMessage = Message;
    }
    WeaponPickupLabel.PickupText.SetValue(newMessage);
    //return;    
}

function ReSetWeaponPickupPanel()
{
    ResetWeaponPickupMaterialParams(WeaponPickupLabel.MatInstancePickupWeapon);
    //return;    
}

function bool WeaponSwapMaterialFade()
{
    local float panelOpacity, opac;

    // End:0x1A9
    if(WeaponSwapPanel != none)
    {
        // End:0x83
        if(((((WeaponSwapLabel.MatInstanceTopWeapon == none) || WeaponSwapLabel.MatInstanceRightWeapon == none) || WeaponSwapLabel.MatInstanceLeftWeapon == none) || WeaponSwapLabel.MatInstanceBottomWeapon == none) || WeaponSwapLabel.DPad == none)
        {
            return true;
        }
        panelOpacity = WeaponSwapLabel.DPad.GetOpacity();
        WeaponSwapLabel.MatInstanceTopWeapon.SetScalarParameterValue('ResetT', panelOpacity);
        WeaponSwapLabel.MatInstanceRightWeapon.SetScalarParameterValue('Reset', panelOpacity);
        WeaponSwapLabel.MatInstanceLeftWeapon.SetScalarParameterValue('Reset', panelOpacity);
        WeaponSwapLabel.MatInstanceBottomWeapon.GetScalarParameterValue('FireAxe', opac);
        // End:0x198
        if(opac > 0.0000000)
        {
            WeaponSwapLabel.MatInstanceBottomWeapon.SetScalarParameterValue('FireAxe', panelOpacity);
        }
        // End:0x1A9
        if(panelOpacity <= 0.0000000)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function SPUILabel GetPickupSlot1Panel()
{
    return PickupPanelSlot1;
    //return ReturnValue;    
}

function SPUILabel GetPickupSlot2Panel()
{
    return PickupPanelSlot2;
    //return ReturnValue;    
}

function SPUILabel GetPickupSlot3Panel()
{
    return PickupPanelSlot3;
    //return ReturnValue;    
}

function PickupHudElementInfo GetPickupSlot1Label()
{
    return PickupSlot1SwapLabel;
    //return ReturnValue;    
}

function PickupHudElementInfo GetPickupSlot2Label()
{
    return PickupSlot2SwapLabel;
    //return ReturnValue;    
}

function PickupHudElementInfo GetPickupSlot3Label()
{
    return PickupSlot3SwapLabel;
    //return ReturnValue;    
}

function bool PickupSlotMaterialFade(SPUILabel PickupSlotPanel, PickupHudElementInfo PickupSlotLabel)
{
    local float panelOpacity, materialOpacity;

    // End:0x17F
    if(PickupSlotPanel != none)
    {
        // End:0x3B
        if((PickupSlotLabel.MatInstancePickup == none) || PickupSlotLabel.PickupText == none)
        {
            return true;
        }
        panelOpacity = PickupSlotLabel.PickupText.GetOpacity();
        PickupSlotLabel.MatInstancePickup.GetScalarParameterValue('Reset', materialOpacity);
        // End:0xD8
        if(panelOpacity <= 0.0000000)
        {
            materialOpacity -= 0.0200000;
            PickupSlotLabel.MatInstancePickup.SetScalarParameterValue('Reset', materialOpacity);            
        }
        else
        {
            PickupSlotLabel.MatInstancePickup.SetScalarParameterValue('Reset', panelOpacity + 0.4000000);
        }
        // End:0x17F
        if((panelOpacity <= 0.0000000) && materialOpacity <= 0.0000000)
        {
            PickupSlotLabel.MatInstancePickup.SetScalarParameterValue('Reset', 0.0000000);
            PickupSlotLabel.PickupText.SetOpacity(0.0000000);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function SetOpacityForSlot(float slotOpacity, name WeapID, MaterialInstanceConstant MatInstancePickup, UILabel PickupText, string Message)
{
    MatInstancePickup.SetScalarParameterValue(WeapID, slotOpacity + 0.4000000);
    PickupText.SetValue(Message);
    PickupText.SetOpacity(slotOpacity);
    //return;    
}

function string GetPickupSlot1Message()
{
    return PickupPanelSlot1Message;
    //return ReturnValue;    
}

function string GetPickupSlot2Message()
{
    return PickupPanelSlot2Message;
    //return ReturnValue;    
}

function name GetPickupSlot1WeapID()
{
    return PickupPanelSlot1WeapID;
    //return ReturnValue;    
}

function name GetPickupSlot2WeapID()
{
    return PickupPanelSlot2WeapID;
    //return ReturnValue;    
}

function name GetPickupSlot3WeapID()
{
    return PickupPanelSlot3WeapID;
    //return ReturnValue;    
}

function float GetPickupSlot1FadeTime()
{
    // End:0x26
    if((PickupPanelSlot1FadeTime > 2.0000000) || PickupPanelSlot1FadeTime < 0.0000000)
    {
        return 1.0000000;
    }
    return PickupPanelSlot1FadeTime;
    //return ReturnValue;    
}

function float GetPickupSlot2FadeTime()
{
    // End:0x26
    if((PickupPanelSlot2FadeTime > 2.0000000) || PickupPanelSlot2FadeTime < 0.0000000)
    {
        return 1.0000000;
    }
    return PickupPanelSlot2FadeTime;
    //return ReturnValue;    
}

function float GetPickupSlotOpacity(SPUILabel PickupPanelSlot, PickupHudElementInfo PickupSlotLabel)
{
    // End:0x47
    if(PickupPanelSlot != none)
    {
        // End:0x27
        if(PickupSlotLabel.PickupText == none)
        {
            return 0.0000000;
        }
        return PickupSlotLabel.PickupText.GetOpacity();
    }
    return 0.0000000;
    //return ReturnValue;    
}

function ResetWeaponPickupMaterialParams(MaterialInstanceConstant inst)
{
    // End:0x15F
    if(inst != none)
    {
        inst.SetScalarParameterValue('AssaultRifle', 0.0000000);
        inst.SetScalarParameterValue('DesertEagle', 0.0000000);
        inst.SetScalarParameterValue('Flame', 0.0000000);
        inst.SetScalarParameterValue('9MM', 0.0000000);
        inst.SetScalarParameterValue('RocketLauncher', 0.0000000);
        inst.SetScalarParameterValue('Saw', 0.0000000);
        inst.SetScalarParameterValue('shotgun', 0.0000000);
        inst.SetScalarParameterValue('HK_UMP', 0.0000000);
        inst.SetScalarParameterValue('Grenade', 0.0000000);
        inst.SetScalarParameterValue('Molotov', 0.0000000);
    }
    //return;    
}

function ResetPickupMaterialParams(MaterialInstanceConstant inst)
{
    // End:0x15F
    if(inst != none)
    {
        inst.SetScalarParameterValue('AssaultRifle', 0.0000000);
        inst.SetScalarParameterValue('DesertEagle', 0.0000000);
        inst.SetScalarParameterValue('Flame', 0.0000000);
        inst.SetScalarParameterValue('9MM', 0.0000000);
        inst.SetScalarParameterValue('RocketLauncher', 0.0000000);
        inst.SetScalarParameterValue('Saw', 0.0000000);
        inst.SetScalarParameterValue('shotgun', 0.0000000);
        inst.SetScalarParameterValue('HK_UMP', 0.0000000);
        inst.SetScalarParameterValue('Grenade', 0.0000000);
        inst.SetScalarParameterValue('Molotov', 0.0000000);
    }
    //return;    
}

function ResetWeaponSwapMaterialParams(MaterialInstanceConstant inst)
{
    // End:0x15F
    if(inst != none)
    {
        inst.SetScalarParameterValue('AssaultRifle', 0.0000000);
        inst.SetScalarParameterValue('DesertEagle', 0.0000000);
        inst.SetScalarParameterValue('Flame', 0.0000000);
        inst.SetScalarParameterValue('9MM', 0.0000000);
        inst.SetScalarParameterValue('RocketLauncher', 0.0000000);
        inst.SetScalarParameterValue('Saw', 0.0000000);
        inst.SetScalarParameterValue('shotgun', 0.0000000);
        inst.SetScalarParameterValue('HK_UMP', 0.0000000);
        inst.SetScalarParameterValue('Reset', 1.0000000);
        inst.SetScalarParameterValue('PickupHL', 0.0000000);
    }
    //return;    
}

function ResetWeaponSwapMaterialParamsB(MaterialInstanceConstant inst)
{
    // End:0x4F
    if(inst != none)
    {
        inst.SetScalarParameterValue('FireAxe', 0.0000000);
        inst.SetScalarParameterValue('PickupHLB', 0.0000000);
    }
    //return;    
}

function ResetWeaponSwapMaterialParamsT(MaterialInstanceConstant inst)
{
    // End:0x93
    if(inst != none)
    {
        inst.SetScalarParameterValue('Molotov', 0.0000000);
        inst.SetScalarParameterValue('Explosive', 0.0000000);
        inst.SetScalarParameterValue('ResetT', 1.0000000);
        inst.SetScalarParameterValue('PickupHLT', 0.0000000);
    }
    //return;    
}

function SetWeaponSwapPanel(name TopWeapID, name RightWeapID, name LeftWeapID, name BottomWeapID, int slot)
{
    // End:0x60
    if((((WeaponSwapLabel.MatInstanceTopWeapon == none) || WeaponSwapLabel.MatInstanceRightWeapon == none) || WeaponSwapLabel.MatInstanceLeftWeapon == none) || WeaponSwapLabel.MatInstanceBottomWeapon == none)
    {
        return;
    }
    ResetWeaponSwapMaterialParamsT(WeaponSwapLabel.MatInstanceTopWeapon);
    WeaponSwapLabel.MatInstanceTopWeapon.SetScalarParameterValue(TopWeapID, 1.0000000);
    ResetWeaponSwapMaterialParams(WeaponSwapLabel.MatInstanceRightWeapon);
    WeaponSwapLabel.MatInstanceRightWeapon.SetScalarParameterValue(RightWeapID, 1.0000000);
    ResetWeaponSwapMaterialParamsB(WeaponSwapLabel.MatInstanceBottomWeapon);
    WeaponSwapLabel.MatInstanceBottomWeapon.SetScalarParameterValue(BottomWeapID, 1.0000000);
    ResetWeaponSwapMaterialParams(WeaponSwapLabel.MatInstanceLeftWeapon);
    WeaponSwapLabel.MatInstanceLeftWeapon.SetScalarParameterValue(LeftWeapID, 1.0000000);
    // End:0x1A7
    if(slot == 0)
    {
        WeaponSwapLabel.MatInstanceTopWeapon.SetScalarParameterValue('PickupHLT', 2.0000000);        
    }
    else
    {
        // End:0x1E2
        if(slot == 1)
        {
            WeaponSwapLabel.MatInstanceRightWeapon.SetScalarParameterValue('PickupHL', 2.0000000);            
        }
        else
        {
            // End:0x21E
            if(slot == 2)
            {
                WeaponSwapLabel.MatInstanceBottomWeapon.SetScalarParameterValue('PickupHLB', 2.0000000);                
            }
            else
            {
                // End:0x257
                if(slot == 3)
                {
                    WeaponSwapLabel.MatInstanceLeftWeapon.SetScalarParameterValue('PickupHL', 2.0000000);
                }
            }
        }
    }
    // End:0x2B2
    if(!GetWorldInfo().IsConsoleBuild())
    {
        WeaponSwapLabel.DPad.SetVisibility(false);
        // End:0x2B2
        if(lblSwapKey != none)
        {
            lblSwapKey.SetVisibility(false);
        }
    }
    //return;    
}

function WeaponPickupBarFadeIn(float weaponPickupBarFadeInTime, name WeapID, string Message)
{
    SetWeaponPickupPanel(WeapID, Message);
    ChildFadeIn(WeaponPickupPanel, weaponPickupBarFadeInTime);
    //return;    
}

function WeaponSwapFade()
{
    WeaponSwapBarFadeOut();
    //return;    
}

function PickupPanelSlot1Fade()
{
    PickupPanel1FadeOut();
    //return;    
}

function WeaponSwapBarFadeIn(float weaponSwapBarFadeInTime, name TopWeapID, name RightWeapID, name LeftWeapID, name BottomWeapID, int slot)
{
    // End:0x17
    if(!HudSceneOwner.bShowHUD)
    {
        return;
    }
    SetWeaponSwapPanel(TopWeapID, RightWeapID, LeftWeapID, BottomWeapID, slot);
    ChildFadeIn(WeaponSwapPanel, weaponSwapBarFadeInTime);
    bShowWeaponSwapBar = true;
    //return;    
}

function CrouchPanelFadeIn(optional float crouchPanelFadeInTime = 0.0000000)
{
    // End:0x20
    if(!HudSceneOwner.bShowHUD)
    {
        return;
    }
    ChildFadeIn(CrouchPanel, crouchPanelFadeInTime);
    bShowCrouchPanel = true;
    //return;    
}

function PickupPanelSlot1FadeIn(name WeapID, float pickupPanelFadeInTime, string Message)
{
    // End:0xBF
    if(!bShowPickupPanel1)
    {
        AmmoBarFadeIn(0.1000000);
        PickupWeaponBarFadeIn(0.1000000);
        PickupPanelSlot1WeapID = WeapID;
        ResetPickupMaterialParams(PickupSlot1SwapLabel.MatInstancePickup);
        PickupSlot1SwapLabel.MatInstancePickup.SetScalarParameterValue(WeapID, 1.0000000);
        PickupSlot1SwapLabel.PickupText.SetValue(Message);
        PickupPanelSlot1Message = Message;
        ChildFadeIn(PickupPanelSlot1, pickupPanelFadeInTime);
        bShowPickupPanel1 = true;
    }
    //return;    
}

function PickupPanelSlot2FadeIn(name WeapID, float slotOpacity)
{
    // End:0x91
    if(!bShowPickupPanel2)
    {
        PickupPanelSlot2WeapID = WeapID;
        ResetPickupMaterialParams(PickupSlot2SwapLabel.MatInstancePickup);
        SetOpacityForSlot(slotOpacity, WeapID, PickupSlot2SwapLabel.MatInstancePickup, PickupSlot2SwapLabel.PickupText, GetPickupSlot1Message());
        bShowPickupPanel2 = true;
        PickupPanelSlot2Message = GetPickupSlot1Message();
        PickupPanel2FadeOut();
    }
    //return;    
}

function PickupPanelSlot3FadeIn(name WeapID, float slotOpacity)
{
    // End:0x76
    if(!bShowPickupPanel3)
    {
        ResetPickupMaterialParams(PickupSlot3SwapLabel.MatInstancePickup);
        SetOpacityForSlot(slotOpacity, WeapID, PickupSlot3SwapLabel.MatInstancePickup, PickupSlot3SwapLabel.PickupText, GetPickupSlot2Message());
        bShowPickupPanel3 = true;
        PickupPanel3FadeOut();
    }
    //return;    
}

function ReticlePanelFadeIn(optional float InFadeInTime = 0.5000000)
{
    // End:0x20
    if(!HudSceneOwner.bShowHUD)
    {
        return;
    }
    // End:0x5A
    if(!bShowReticle)
    {
        HudFadeInTime = FMax(HudFadeInTime, InFadeInTime);
        ChildFadeIn(ReticlePanel, HudFadeInTime);
        bShowReticle = true;
    }
    //return;    
}

function HealthBarFadeOut(optional float FadeOutTime = 2.0000000)
{
    // End:0x2B
    if(!bFadeWhenInactive && HudSceneOwner.bShowHUD)
    {
        return;
    }
    // End:0x51
    if(bShowHealthBar)
    {
        ChildFadeOut(healthBarPanel, FadeOutTime);
        bShowHealthBar = false;
    }
    //return;    
}

function bool FadeOutGrenadeMolotovBox(bool bSnapOut, MaterialInstanceConstant MatInst)
{
    // End:0x0D
    if(MatInst == none)
    {
        return true;
    }
    // End:0x56
    if(bSnapOut || m_fGrenadeFadeOutOpacity <= 0.1000000)
    {
        MatInst.SetScalarParameterValue('Opacity', 0.0000000);
        m_fGrenadeFadeOutOpacity = 0.0000000;
        return true;
    }
    MatInst.SetScalarParameterValue('Opacity', m_fGrenadeFadeOutOpacity);
    m_fGrenadeFadeOutOpacity -= 0.1000000;
    return false;
    //return ReturnValue;    
}

function bool FadeInGrenadeMolotovBox(bool bSnapIn, MaterialInstanceConstant MatInst)
{
    // End:0x0D
    if(MatInst == none)
    {
        return true;
    }
    // End:0x56
    if(bSnapIn || Opacity >= 0.9000000)
    {
        MatInst.SetScalarParameterValue('Opacity', 1.0000000);
        m_fGrenadeFadeOutOpacity = 1.0000000;
        return true;
    }
    MatInst.SetScalarParameterValue('Opacity', Opacity);
    m_fGrenadeFadeOutOpacity += 0.1000000;
    return false;
    //return ReturnValue;    
}

function AmmoBarFadeOut(optional float FadeOutTime = 2.0000000)
{
    local PandoraPlayerController PC;

    // End:0x2B
    if(!bFadeWhenInactive && HudSceneOwner.bShowHUD)
    {
        return;
    }
    // End:0x14A
    if(bShowAmmoBar)
    {
        PC = GetPC();
        // End:0x12D
        if(PC != none)
        {
            // End:0x99
            if(PC.GetTopWeapID() == 'Explosive')
            {
                PC.FadeOutGrenadeMolotovBoxTimer(false, GrenadeAmmoLabel.MatInstancePickup);                
            }
            else
            {
                // End:0xE3
                if(PC.GetTopWeapID() == 'Molotov')
                {
                    PC.FadeOutGrenadeMolotovBoxTimer(false, MolotovAmmoLabel.MatInstancePickup);                    
                }
                else
                {
                    PC.FadeOutGrenadeMolotovBoxTimer(true, GrenadeAmmoLabel.MatInstancePickup);
                    PC.FadeOutGrenadeMolotovBoxTimer(true, MolotovAmmoLabel.MatInstancePickup);
                }
            }
        }
        ChildFadeOut(AmmoBarPanel, FadeOutTime);
        bShowAmmoBar = false;
    }
    //return;    
}

function MolotovBarPanelFadeOut(float FadeOutTime)
{
    ChildFadeOut(MolotovBarPanel, FadeOutTime);
    //return;    
}

function GrenadeBarPanelFadeOut(float FadeOutTime)
{
    ChildFadeOut(GrenadeBarPanel, FadeOutTime);
    //return;    
}

function PickupWeaponBarFadeOut(optional float FadeOutTime = 2.0000000)
{
    // End:0x2B
    if(!bFadeWhenInactive && HudSceneOwner.bShowHUD)
    {
        return;
    }
    // End:0x51
    if(bShowPickupWeaponBar)
    {
        ChildFadeOut(PickupWeaponPanel, FadeOutTime);
        bShowPickupWeaponBar = false;
    }
    //return;    
}

function WeaponPickupBarFadeOut(optional float FadeOutTime = 0.0000000)
{
    ReSetWeaponPickupPanel();
    ChildFadeOut(WeaponPickupPanel, FadeOutTime);
    //return;    
}

function WeaponSwapBarFadeOut(optional float FadeOutTime = 0.4000000)
{
    // End:0x20
    if(!HudSceneOwner.bShowHUD)
    {
        return;
    }
    ChildFadeOut(WeaponSwapPanel, FadeOutTime);
    bShowWeaponSwapBar = false;
    //return;    
}

function PickupPanel1FadeOut(optional float FadeOutTime = 2.0000000)
{
    // End:0x3A
    if(bShowPickupPanel1)
    {
        PickupPanelSlot1FadeTime = FadeOutTime;
        ChildFadeOut(PickupPanelSlot1, PickupPanelSlot1FadeTime);
        bShowPickupPanel1 = false;
    }
    //return;    
}

function PickupPanel2FadeOut(optional float FadeOutTime = 0.4000000)
{
    // End:0x66
    if(bShowPickupPanel2)
    {
        PickupPanelSlot2FadeTime = (GetPickupSlotOpacity(GetPickupSlot1Panel(), GetPickupSlot1Label())) + ((GetPickupSlot1FadeTime()) * 0.5000000);
        ChildFadeOut(PickupPanelSlot2, PickupPanelSlot2FadeTime);
        bShowPickupPanel2 = false;
    }
    //return;    
}

function PickupPanel3FadeOut(optional float FadeOutTime = 0.4000000)
{
    // End:0x5B
    if(bShowPickupPanel3)
    {
        ChildFadeOut(PickupPanelSlot3, (GetPickupSlotOpacity(GetPickupSlot2Panel(), GetPickupSlot2Label())) + ((GetPickupSlot2FadeTime()) * 0.5000000));
        bShowPickupPanel3 = false;
    }
    //return;    
}

function CrouchPanelFadeOut(optional float FadeOutTime = 0.4000000)
{
    ChildFadeOut(CrouchPanel, FadeOutTime);
    bShowCrouchPanel = false;
    //return;    
}

function ReticlePanelFadeOut(optional float InFadeOutTime = 2.0000000)
{
    // End:0x2F
    if(bShowReticle)
    {
        ChildFadeOut(ReticlePanel, InFadeOutTime);
        bShowReticle = false;
    }
    //return;    
}

function SetReticleColor(LinearColor NewColor)
{
    reticleColor = NewColor;
    reticleImage.SetColor(NewColor);
    aimDot.SetColor(NewColor);
    reticle_Left.SetColor(NewColor);
    reticle_Right.SetColor(NewColor);
    reticle_Top.SetColor(NewColor);
    reticle_Bottom.SetColor(NewColor);
    //return;    
}

simulated function ShowHitTargetIndicator()
{
    showHitTargetTime = 30;
    hitTargetFadeOutRate = 1.0000000 / float(showHitTargetTime);
    hitTargetImage.SetOpacity(1.0000000);
    hitTargetImage.SetVisibility(true);
    hitTargetImage.SetWidgetScale(1.0000000 + (reticleSpread.Spread * float(3)), 0.0000000);
    //return;    
}

simulated function HideHitTargetIndicator()
{
    hitTargetImage.SetOpacity(0.0000000);
    hitTargetImage.SetVisibility(false);
    //return;    
}

function UpdateHitTargetIndicator()
{
    local float currOpacity;

    // End:0x71
    if(showHitTargetTime > 0)
    {
        currOpacity = hitTargetImage.GetOpacity();
        currOpacity -= hitTargetFadeOutRate;
        hitTargetImage.SetOpacity(currOpacity);
        showHitTargetTime--;
        // End:0x71
        if(showHitTargetTime == 0)
        {
            hitTargetImage.SetVisibility(false);
        }
    }
    //return;    
}

function UpdateGrenadeCount(int Count, optional int Type = 1, optional int SelectedGrenade = 1)
{
    local int I;
    local array<HudElementInfo> GrenadeInv;

    bApplyGlowForPickupChange = false;
    SetGrenadeIconGlow();
    AmmoBarFadeIn(0.1000000);
    PickupWeaponBarFadeIn(0.1000000);
    switch(Type)
    {
        // End:0x54
        case 1:
            GrenadeInv = GrenadeInventoryList;
            // End:0x6A
            break;
        // End:0x67
        case 2:
            GrenadeInv = MolotovInventoryList;
            // End:0x6A
            break;
        // End:0xFFFF
        default:
            break;
    }
    I = 0;
    J0x71:

    // End:0x1E1 [Loop If]
    if(I < GrenadeInv.Length)
    {
        // End:0x171
        if(I < Count)
        {
            // End:0x108
            if(Type == SelectedGrenade)
            {
                GrenadeInv[I].matInstance.SetScalarParameterValue('selected', 1.0000000);
                GrenadeInv[I].matInstance.SetScalarParameterValue('Brightness', 1.0000000);                
            }
            else
            {
                GrenadeInv[I].matInstance.SetScalarParameterValue('selected', 0.0000000);
                GrenadeInv[I].matInstance.SetScalarParameterValue('Brightness', 0.7000000);
            }
            // [Explicit Continue]
            goto J0x1D7;
        }
        GrenadeInv[I].matInstance.SetScalarParameterValue('selected', 0.0000000);
        GrenadeInv[I].matInstance.SetScalarParameterValue('Brightness', 0.3000000);
        J0x1D7:

        I++;
        // [Loop Continue]
        goto J0x71;
    }
    //return;    
}

function UpdateGrenadeCountChanged(int Count, optional int Type = 1, optional int SelectedGrenade = 1)
{
    local bool NeedToFadeIn;

    NeedToFadeIn = false;
    switch(Type)
    {
        // End:0x43
        case 1:
            // End:0x40
            if(Count != oldGrenadeCount)
            {
                NeedToFadeIn = true;
                oldGrenadeCount = Count;
            }
            // End:0x70
            break;
        // End:0x6D
        case 2:
            // End:0x6A
            if(Count != oldMolotovCount)
            {
                NeedToFadeIn = true;
                oldMolotovCount = Count;
            }
            // End:0x70
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x92
    if(NeedToFadeIn)
    {
        UpdateGrenadeCount(Count, Type, SelectedGrenade);
    }
    //return;    
}

function EnableGrenadeIcon(bool flareEnable, bool grenadeEnable, bool molotovEnable, bool stunEnable)
{
    // End:0x27
    if(flareIcon != none)
    {
        flareIcon.SetVisibility(!flareEnable);
    }
    // End:0x4E
    if(grenadeIcon != none)
    {
        grenadeIcon.SetVisibility(!grenadeEnable);
    }
    // End:0x75
    if(molotovIcon != none)
    {
        molotovIcon.SetVisibility(!molotovEnable);
    }
    // End:0x9C
    if(stunIcon != none)
    {
        stunIcon.SetVisibility(!stunEnable);
    }
    //return;    
}

function SetGrenadeIconGlow()
{
    grenadeIconGlowTime = 90;
    grenadeIconGlowFadeOutRate = 1.0000000 / float(grenadeIconGlowTime);
    // End:0x55
    if(grenadeIconGlow != none)
    {
        grenadeIconGlow.SetVisibility(true);
        grenadeIconGlow.SetOpacity(1.0000000);
    }
    //return;    
}

function UpdateGrenadeIconGlow()
{
    local float currOpacity;

    // End:0x87
    if(grenadeIconGlowTime > 0)
    {
        // End:0x55
        if(grenadeIconGlow != none)
        {
            currOpacity = grenadeIconGlow.GetOpacity();
            currOpacity -= grenadeIconGlowFadeOutRate;
            grenadeIconGlow.SetOpacity(currOpacity);
        }
        grenadeIconGlowTime--;
        // End:0x87
        if(grenadeIconGlowTime == 0)
        {
            // End:0x87
            if(grenadeIconGlow != none)
            {
                grenadeIconGlow.SetVisibility(false);
            }
        }
    }
    //return;    
}

function WriteAmmoCount(HUD H, float AmmoInMag, float AmmoCount, optional float magazineSize, optional bool bFiring)
{
    local string ammoInMagazineStr, ammoTotalStr;
    local LinearColor flashColor;
    local float textOpacity;

    ammoInMagazineStr = "" $ string(int(AmmoInMag));
    ammoTotalStr = "" $ string(int(AmmoCount));
    // End:0x47
    if(magazineSize > float(0))
    {
        ammoRemained = AmmoInMag / magazineSize;
    }
    frame++;
    // End:0x5D
    if(IsHudFadeIn())
    {
        return;
    }
    // End:0x19F
    if(ammoInMagazine != none)
    {
        // End:0x109
        if(AmmoInMag == 0.0000000)
        {
            flashColor = Red;
            AmmoBarFadeIn(0.1000000);
            PickupWeaponBarFadeIn(0.1000000);
            ammoInMagazine.SetGlowFont(ImpactFontGlow18);
            ammoInMagazine.SetColor(flashColor);
            textOpacity = redPulses[int(float(frame) % float(40))];
            ammoInMagazine.SetOpacity(textOpacity);            
        }
        else
        {
            // End:0x186
            if(oldAmmoInmagazine != AmmoInMag)
            {
                AmmoBarFadeIn(0.1000000);
                PickupWeaponBarFadeIn(0.1000000);
                ammoInMagazine.SetGlow(0.5000000, 0.0000000);
                ammoInMagazine.SetGlowFont(ImpactFontGlow18);
                ammoInMagazine.SetOpacity(1.0000000);
            }
        }
        ammoInMagazine.SetCaption(ammoInMagazineStr);
    }
    oldAmmoInmagazine = AmmoInMag;
    // End:0x23D
    if(oldAmmoTotal != AmmoCount)
    {
        AmmoBarFadeIn(0.1000000);
        PickupWeaponBarFadeIn(0.1000000);
        // End:0x232
        if(ammoTotal != none)
        {
            ammoTotal.SetCaption(ammoTotalStr);
            ammoTotal.SetGlow(0.5000000, 0.0000000);
            ammoTotal.SetGlowFont(ImpactFontGlow18);
        }
        oldAmmoTotal = AmmoCount;
    }
    //return;    
}

function UpdateAnimus(float Animus)
{
    // End:0x0F
    if(IsHudFadeIn())
    {
        return;
    }
    // End:0xE1
    if(prevAnimus != Animus)
    {
        healthBarIdleTime = 0.0000000;
        HealthBarFadeIn();
        prevAnimus = Animus;
        animusBar_RedGlow.SetVisibility(true);
        animusBar_RedGlow.SetOpacity(0.5000000);
        animusBar_RedGlow.SetWidgetScale(Animus, 0.5000000);
        animusBarRedGlowFadeOutTime = 30;
        animusBarRedGlowFadeOutRate = 1.0000000 / float(animusBarRedGlowFadeOutTime);
        animusBarRedGlowFadeInTime = 10;
        animusBarRedGlowFadeInRate = 0.5000000 / float(animusBarRedGlowFadeInTime);
        animusBar_Red.SetWidgetScale(Animus, 0.5000000);
    }
    //return;    
}

function UpdateReticleWeaponSpread(HUD H, float Spread, float reticleOpacity, int ammoLeft, bool bWeaponSwitched, name WeaponName)
{
    local float widgetScale;

    reticleSpread.Spread = Spread;
    widgetScale = 1.0000000 + (Spread * float(6));
    // End:0x80
    if(reticleImage != none)
    {
        reticleImage.SetWidgetScale(widgetScale, 0.0000000);
        reticleImage.SetOpacity(1.0000000 - (reticleOpacity * float(4)));        
    }
    else
    {
        return;
    }
    // End:0xA8
    if((oldAmmoInmagazine != float(ammoLeft)) && !bWeaponSwitched)
    {
        bFired = true;
    }
    // End:0x122
    if(bFired)
    {
        // End:0x11F
        if(reticleOffset <= maxReticleOffset)
        {
            // End:0xF4
            if((WeaponName == 'DesertEagle') || WeaponName == 'NineMMPistol')
            {
                reticleOffset += 5;                
            }
            else
            {
                reticleOffset += 2;
            }
            // End:0x11F
            if(reticleOffset >= maxReticleOffset)
            {
                bFired = false;
                reticleOffset = maxReticleOffset;
            }
        }        
    }
    else
    {
        // End:0x17C
        if(reticleOffset > 0)
        {
            // End:0x161
            if((WeaponName == 'DesertEagle') || WeaponName == 'NineMMPistol')
            {
                reticleOffset -= 5;                
            }
            else
            {
                reticleOffset -= 2;
            }
            // End:0x17C
            if(reticleOffset <= 0)
            {
                reticleOffset = 0;
            }
        }
    }
    reticleImage.GetPositionExtents(reticleSpread.Location[2].X, reticleSpread.Location[1].X, reticleSpread.Location[0].Y, reticleSpread.Location[3].Y, true);
    reticleSizeX = int(reticle_Right.GetPositionExtent(2, true) - reticle_Right.GetPositionExtent(0, true));
    reticleSizeY = int(reticle_Bottom.GetPositionExtent(3, true) - reticle_Bottom.GetPositionExtent(1, true));
    reticleSpread.Location[0].X = H.CenterX;
    reticleSpread.Location[0].Y -= float(reticleOffset);
    reticleSpread.Location[1].X += float((reticleOffset - reticleSizeX) + 4);
    reticleSpread.Location[1].Y = H.CenterY;
    reticleSpread.Location[2].X -= float(reticleOffset);
    reticleSpread.Location[2].Y = H.CenterY;
    reticleSpread.Location[3].X = H.CenterX;
    reticleSpread.Location[3].Y += float(reticleOffset - reticleSizeY);
    //return;    
}

function DrawReticleWeaponSpread(HUD H)
{
    reticle_Left.SetPosition(reticleSpread.Location[2].X, 0);
    reticle_Top.SetPosition(reticleSpread.Location[0].Y, 1);
    reticle_Right.SetPosition(reticleSpread.Location[1].X, 0);
    reticle_Bottom.SetPosition(reticleSpread.Location[3].Y, 1);
    //return;    
}

function WriteHealthCount(HUD H, int playerHealth)
{
    // End:0x0F
    if(IsHudFadeIn())
    {
        return;
    }
    // End:0x15B
    if(prevPH != playerHealth)
    {
        playerHealth = Max(playerHealth, 0);
        // End:0x42
        if(playerHealth > 0)
        {
            HealthBarFadeIn();
        }
        // End:0xD4
        if(prevPH > playerHealth)
        {
            health_fill.SetValue(float(playerHealth));
            // End:0x9C
            if(lostHealth == 0)
            {
                lostHealthDelayTime = 45;
                whiteToRedTime = 0.5000000;
                lostHealth = prevPH - playerHealth;                
            }
            else
            {
                lostHealth += (prevPH - playerHealth);
            }
            healthBar_Red.SetOverlay(float(playerHealth), float(lostHealth));            
        }
        else
        {
            gainHealthDelayTime = 45;
            gainHealth = (playerHealth - prevPH) + 16;
            healthBar_RedGlow.SetVisibility(true);
            healthBar_RedGlow.SetOpacity(1.0000000);
            healthBar_RedGlow.SetValue(float(prevPH));
            health_fill.SetValue(float(prevPH));
        }
        prevPH = playerHealth;
    }
    //return;    
}

function ResetHud()
{
    prevPH = default.prevPH;
    prevAnimus = default.prevAnimus;
    lostHealth = 0;
    gainHealth = 0;
    lostHealthDelayTime = 0;
    gainHealthDelayTime = 0;
    whiteToRedTime = 0.0000000;
    InteractiveCount = 0;
    InfoCount = 0;
    SubTitleCount = 0;
    healthBar_Red.SetOverlay(0.0000000, 0.0000000);
    //return;    
}

function int AddTextToBuffer(string NewText, SPHudScene.EScreenTextType Type, optional float DisplayTime = 2.0000000)
{
    local int LabelId, Index, I;

    Index = -1;
    // End:0x26C
    if(Len(NewText) > 0)
    {
        I = 0;
        J0x28:

        // End:0x128 [Loop If]
        if(I < ScreenTextBuffer.Length)
        {
            // End:0x11E
            if(((int(ScreenTextBuffer[I].TextType) != int(5)) && int(ScreenTextBuffer[I].TextType) == int(Type)) && ScreenTextBuffer[I].ScreenText ~= NewText)
            {
                Index = I;
                ScreenTextBuffer[I].TimeDisplayed = 0.0000000;
                ScreenTextBuffer[I].TimeToRemove = DisplayTime;
                LabelId = ScreenTextBuffer[I].LabelId;
                lblInteractiveText[LabelId].SetVisibility(true);
                // [Explicit Break]
                goto J0x128;
            }
            I++;
            // [Loop Continue]
            goto J0x28;
        }
        J0x128:

        // End:0x26C
        if(Index == -1)
        {
            Index = ScreenTextBuffer.Length;
            ScreenTextBuffer.Length = Index + 1;
            ScreenTextBuffer[Index].ScreenText = NewText;
            ScreenTextBuffer[Index].TimeToRemove = DisplayTime;
            ScreenTextBuffer[Index].TimeDisplayed = 0.0000000;
            ScreenTextBuffer[Index].TextType = Type;
            ScreenTextBuffer[Index].bOnDisplay = false;
            // End:0x26C
            if(!ScreenTextBuffer[Index].bOnDisplay)
            {
                // End:0x26C
                if(DisplayText(ScreenTextBuffer[Index].ScreenText, int(ScreenTextBuffer[I].TextType), LabelId))
                {
                    ScreenTextBuffer[Index].bOnDisplay = true;
                    ScreenTextBuffer[Index].LabelId = LabelId;
                }
            }
        }
    }
    return Index;
    //return ReturnValue;    
}

function RemoveTextFromBuffer(optional SPHudScene.EScreenTextType Type = 0, optional bool bClearAllText = false)
{
    local int LabelId, Index;

    Index = 0;
    J0x12:

    // End:0x179 [Loop If]
    if(Index < ScreenTextBuffer.Length)
    {
        LabelId = ScreenTextBuffer[Index].LabelId;
        // End:0x16F
        if(((int(ScreenTextBuffer[Index].TextType) == int(Type)) || ScreenTextBuffer[Index].TimeDisplayed > ScreenTextBuffer[Index].TimeToRemove) || bClearAllText)
        {
            switch(ScreenTextBuffer[Index].TextType)
            {
                // End:0xBE
                case 1:
                // End:0xC3
                case 2:
                // End:0xC8
                case 3:
                // End:0xF2
                case 4:
                    lblInteractiveText[LabelId].SetVisibility(false);
                    InteractiveCount--;
                    // End:0x161
                    break;
                // End:0x128
                case 5:
                    InfoCount--;
                    // End:0x125
                    if(InfoCount <= 0)
                    {
                        lblInfoText.SetVisibility(false);
                        InfoCount = 0;
                    }
                    // End:0x161
                    break;
                // End:0x15E
                case 6:
                    SubTitleCount--;
                    // End:0x15B
                    if(SubTitleCount <= 0)
                    {
                        lblSubTitle.SetVisibility(false);
                        SubTitleCount = 0;
                    }
                    // End:0x161
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            ScreenTextBuffer.Remove(Index--, 1);
        }
        Index++;
        // [Loop Continue]
        goto J0x12;
    }
    //return;    
}

function UpdateScreenText(float Time)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x58 [Loop If]
    if(I < ScreenTextBuffer.Length)
    {
        // End:0x4E
        if(ScreenTextBuffer[I].bOnDisplay)
        {
            ScreenTextBuffer[I].TimeDisplayed += Time;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    RemoveTextFromBuffer();
    //return;    
}

function bool DisplayText(string Text, int Type, out int LabelId)
{
    local bool bDisplayed;
    local string TextOnScreen, NewText, strToProcess, strModified;
    local PandoraPlayerInput PanInput;
    local PandoraPlayerController myPC;

    bDisplayed = false;
    TextOnScreen = "";
    myPC = GetPC();
    // End:0x45
    if(myPC != none)
    {
        PanInput = PandoraPlayerInput(myPC.PlayerInput);
    }
    switch(Type)
    {
        // End:0x51
        case 1:
        // End:0x56
        case 2:
        // End:0x5B
        case 3:
        // End:0x132
        case 4:
            // End:0x12F
            if(InteractiveCount < 2)
            {
                lblInteractiveText[InteractiveCount].SetVisibility(true);
                lblInteractiveText[InteractiveCount].SetValue(Text);
                strToProcess = lblInteractiveText[InteractiveCount].GetValue();
                // End:0x115
                if((myPC != none) && PanInput != none)
                {
                    strModified = PanInput.ProcessButtonToFontMapping(strToProcess);
                    lblInteractiveText[InteractiveCount].SetValue(strModified);
                }
                LabelId = InteractiveCount;
                InteractiveCount++;
                bDisplayed = true;
            }
            // End:0x223
            break;
        // End:0x1CD
        case 5:
            lblInfoText.SetVisibility(true);
            // End:0x171
            if(InfoCount > 0)
            {
                TextOnScreen = lblInfoText.GetValue();
            }
            // End:0x1CA
            if(InfoCount < 2)
            {
                NewText = TextOnScreen @ "\n";                
                NewText @= Text;
                lblInfoText.SetValue(NewText);
                bDisplayed = true;
                LabelId = 0;
                InfoCount++;
            }
            // End:0x223
            break;
        // End:0x220
        case 6:
            // End:0x21D
            if(SubTitleCount == 0)
            {
                lblSubTitle.SetVisibility(true);
                lblSubTitle.SetValue(Text);
                bDisplayed = true;
                LabelId = 0;
                SubTitleCount++;
            }
            // End:0x223
            break;
        // End:0xFFFF
        default:
            break;
    }
    return bDisplayed;
    //return ReturnValue;    
}

function PandoraPlayerController GetPC()
{
    local PandoraPlayerController PC;
    local LocalPlayer LP;

    LP = GetPlayerOwner();
    // End:0x49
    if((LP != none) && LP.Actor != none)
    {
        PC = PandoraPlayerController(LP.Actor);
    }
    return PC;
    //return ReturnValue;    
}

simulated function bool ShouldDisplayMultiplayerHud()
{
    // End:0x42
    if((int(GetWorldInfo().NetMode) == int(NM_ListenServer)) || int(GetWorldInfo().NetMode) == int(NM_Client))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function UpdateMonsterMachineBarGlow(int TeamID, float DeltaTime)
{
    local bool isAtMax;
    local int Index;

    Index = TeamID - 1;
    // End:0x39
    if(MonsterMachineGlowStatus[Index].currGlowValue == GlowMaxValue)
    {
        isAtMax = true;        
    }
    else
    {
        isAtMax = false;
    }
    // End:0xDD
    if(isAtMax)
    {
        MonsterMachineGlowStatus[Index].holdAtMaxGlowTime -= DeltaTime;
        // End:0xBD
        if(MonsterMachineGlowStatus[Index].holdAtMaxGlowTime < float(0))
        {
            MonsterMachineGlowStatus[Index].holdAtMaxGlowTime = 0.0000000;
            MonsterMachineGlowStatus[Index].destGlowValue = 0.0000000;
        }
        // End:0xDD
        if(MonsterMachineGlowStatus[Index].holdAtMaxGlowTime > float(0))
        {
            return;
        }
    }
    // End:0x1AF
    if(MonsterMachineGlowStatus[Index].currGlowValue < MonsterMachineGlowStatus[Index].destGlowValue)
    {
        MonsterMachineGlowStatus[Index].currGlowValue += (GlowValueChangRate * DeltaTime);
        // End:0x1AC
        if(MonsterMachineGlowStatus[Index].currGlowValue >= MonsterMachineGlowStatus[Index].destGlowValue)
        {
            MonsterMachineGlowStatus[Index].currGlowValue = MonsterMachineGlowStatus[Index].destGlowValue;
            MonsterMachineGlowStatus[Index].holdAtMaxGlowTime = GlowHoldTime;
        }        
    }
    else
    {
        // End:0x262
        if(MonsterMachineGlowStatus[Index].currGlowValue > MonsterMachineGlowStatus[Index].destGlowValue)
        {
            MonsterMachineGlowStatus[Index].currGlowValue -= (GlowValueChangRate * DeltaTime);
            // End:0x262
            if(MonsterMachineGlowStatus[Index].currGlowValue <= MonsterMachineGlowStatus[Index].destGlowValue)
            {
                MonsterMachineGlowStatus[Index].currGlowValue = MonsterMachineGlowStatus[Index].destGlowValue;
            }
        }
    }
    MonsterMachineGlowStatus[Index].matInstance.SetScalarParameterValue('glow', MonsterMachineGlowStatus[Index].currGlowValue);
    //return;    
}
