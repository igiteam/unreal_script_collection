class UIScene_WeaponConfig extends UIScene_BaseFrontEnd;

struct ReportedDamageInfo
{
    /** Stats are all based out of 100 */
    var() int Damage;
    /** Stats are all based out of 100 */
    var() int RateOfFire;
    /** Stats are all based out of 100 */
    var() int ShortRange;
    /** Stats are all based out of 100 */
    var() int LongRange;

    structdefaultproperties
    {
        Damage=0
        RateOfFire=0
        ShortRange=0
        LongRange=0
    }
};

struct PrimaryWeaponData
{
    var string WeaponName;
    var string WeaponDescription;
    var class<Inventory> WeaponClass;
    /** These are weapons that go into slot A / B */
    var() ReportedDamageInfo DamageReportInfo;
    /** These are weapons that go into slot A / B */
    var() Texture2D Tex;

    structdefaultproperties
    {
        WeaponName=""
        WeaponDescription=""
        WeaponClass=none
        DamageReportInfo=(Damage=0,RateOfFire=0,ShortRange=0,LongRange=0)
        Tex=none
    }
};

struct SecondaryWeaponData
{
    var string WeaponName;
    var string WeaponDescription;
    var SPInventoryManager.GrenadeTypes Type;
    var() ReportedDamageInfo DamageReportInfo;
    var() Texture2D Tex;

    structdefaultproperties
    {
        WeaponName=""
        WeaponDescription=""
        Type=GrenadeType_Flare
        DamageReportInfo=(Damage=0,RateOfFire=0,ShortRange=0,LongRange=0)
        Tex=none
    }
};

struct StatBarInfo
{
    var float CurVal;
    var float TargetVal;
    var SPProgressBar Bar;

    structdefaultproperties
    {
        CurVal=0.0000000
        TargetVal=0.0000000
        Bar=none
    }
};

var() array<PrimaryWeaponData> PriWeapons;
var() array<SecondaryWeaponData> SecWeapons;
var int CurProfile;
var UILabel lblWeapon[3];
var UILabel lblWpnDescription[3];
var UIImage imgWeapon[3];
var UILabel lblWeaponCount;
var UIImage imgBackground;
var SPPlayerReplicationInfo SPPRI;
var PandoraGRI PGRI;
var Controller theController;
var StatBarInfo DamageBar[3];
var StatBarInfo RateOfFireBar[3];
var StatBarInfo ShortRangeBar[3];
var StatBarInfo LongRangeBar[3];
var byte bOrigIgnoreMovementFlag;

function float GetNewStatVal(float DeltaTime, float CurVal, float TargetVal)
{
    // End:0x88
    if(CurVal != TargetVal)
    {
        // End:0x4D
        if(CurVal < TargetVal)
        {
            CurVal += (float(150) * DeltaTime);
            // End:0x4A
            if(CurVal > TargetVal)
            {
                CurVal = TargetVal;
            }            
        }
        else
        {
            // End:0x88
            if(CurVal > TargetVal)
            {
                CurVal -= (float(150) * DeltaTime);
                // End:0x88
                if(CurVal < TargetVal)
                {
                    CurVal = TargetVal;
                }
            }
        }
    }
    return CurVal;
    //return ReturnValue;    
}

function UpdateStatBars(float DeltaTime)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x245 [Loop If]
    if(I < 3)
    {
        DamageBar[I].CurVal = GetNewStatVal(DeltaTime, DamageBar[I].CurVal, DamageBar[I].TargetVal);
        RateOfFireBar[I].CurVal = GetNewStatVal(DeltaTime, RateOfFireBar[I].CurVal, RateOfFireBar[I].TargetVal);
        ShortRangeBar[I].CurVal = GetNewStatVal(DeltaTime, ShortRangeBar[I].CurVal, ShortRangeBar[I].TargetVal);
        LongRangeBar[I].CurVal = GetNewStatVal(DeltaTime, LongRangeBar[I].CurVal, LongRangeBar[I].TargetVal);
        DamageBar[I].Bar.SetValue(DamageBar[I].CurVal);
        RateOfFireBar[I].Bar.SetValue(RateOfFireBar[I].CurVal);
        ShortRangeBar[I].Bar.SetValue(ShortRangeBar[I].CurVal);
        LongRangeBar[I].Bar.SetValue(LongRangeBar[I].CurVal);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function UpdateDisplay()
{
    local int PriWeaponA, PriWeaponB, SecWeapon, Quantity;

    PriWeaponA = int(PGRI.WeaponProfiles[CurProfile].PriWeaponA);
    PriWeaponB = int(PGRI.WeaponProfiles[CurProfile].PriWeaponB);
    SecWeapon = int(PGRI.WeaponProfiles[CurProfile].SecWeapon);
    Quantity = PGRI.WeaponProfiles[CurProfile].SecWeaponQuantity;
    DamageBar[0].TargetVal = float(PriWeapons[PriWeaponA].DamageReportInfo.Damage);
    RateOfFireBar[0].TargetVal = float(PriWeapons[PriWeaponA].DamageReportInfo.RateOfFire);
    ShortRangeBar[0].TargetVal = float(PriWeapons[PriWeaponA].DamageReportInfo.ShortRange);
    LongRangeBar[0].TargetVal = float(PriWeapons[PriWeaponA].DamageReportInfo.LongRange);
    DamageBar[1].TargetVal = float(PriWeapons[PriWeaponB].DamageReportInfo.Damage);
    RateOfFireBar[1].TargetVal = float(PriWeapons[PriWeaponB].DamageReportInfo.RateOfFire);
    ShortRangeBar[1].TargetVal = float(PriWeapons[PriWeaponB].DamageReportInfo.ShortRange);
    LongRangeBar[1].TargetVal = float(PriWeapons[PriWeaponB].DamageReportInfo.LongRange);
    DamageBar[2].TargetVal = float(PriWeapons[SecWeapon].DamageReportInfo.Damage);
    RateOfFireBar[2].TargetVal = float(PriWeapons[SecWeapon].DamageReportInfo.RateOfFire);
    ShortRangeBar[2].TargetVal = float(PriWeapons[SecWeapon].DamageReportInfo.ShortRange);
    LongRangeBar[2].TargetVal = float(PriWeapons[SecWeapon].DamageReportInfo.LongRange);
    // End:0x39A
    if(PriWeaponA == 5)
    {
        lblWeapon[0].SetValue("<Strings:PandoraGame.Weapons.none>");
        imgWeapon[0].SetVisibility(false);
        lblWpnDescription[0].SetValue("");        
    }
    else
    {
        lblWpnDescription[0].SetValue(PriWeapons[PriWeaponA].WeaponDescription);
        lblWeapon[0].SetValue(PriWeapons[PriWeaponA].WeaponName);
        imgWeapon[0].SetValue(PriWeapons[PriWeaponA].Tex);
        imgWeapon[0].SetVisibility(true);
    }
    // End:0x499
    if(PriWeaponB == 5)
    {
        lblWpnDescription[1].SetValue("");
        lblWeapon[1].SetValue("<Strings:PandoraGame.Weapons.none>");
        imgWeapon[1].SetVisibility(false);        
    }
    else
    {
        lblWpnDescription[1].SetValue(PriWeapons[PriWeaponB].WeaponDescription);
        lblWeapon[1].SetValue(PriWeapons[PriWeaponB].WeaponName);
        imgWeapon[1].SetValue(PriWeapons[PriWeaponB].Tex);
        imgWeapon[1].SetVisibility(true);
    }
    // End:0x59B
    if(SecWeapon == 5)
    {
        lblWpnDescription[2].SetValue("");
        lblWeapon[2].SetValue("<Strings:PandoraGame.Weapons.none>");
        imgWeapon[2].SetVisibility(false);        
    }
    else
    {
        lblWpnDescription[2].SetValue(SecWeapons[SecWeapon].WeaponDescription);
        lblWeapon[2].SetValue(SecWeapons[SecWeapon].WeaponName);
        imgWeapon[2].SetValue(SecWeapons[SecWeapon].Tex);
        imgWeapon[2].SetVisibility(true);
    }
    lblWeaponCount.SetValue("x" @ string(Quantity));
    //return;    
}

function WeaponConfigSceneActivated(UIScene ActivatedScene, bool bInitialActivation)
{
    local PandoraPlayerController PC;
    local SPGameUISceneClient theSceneClient;

    lblWeapon[0] = UILabel(FindChild('lblWeaponConfigA', true));
    lblWeapon[1] = UILabel(FindChild('lblWeaponConfigB', true));
    lblWeapon[2] = UILabel(FindChild('lblWeaponConfigC', true));
    lblWpnDescription[0] = UILabel(FindChild('lblDescriptionA', true));
    lblWpnDescription[1] = UILabel(FindChild('lblDescriptionB', true));
    lblWpnDescription[2] = UILabel(FindChild('lblDescriptionC', true));
    imgWeapon[0] = UIImage(FindChild('imgWeaponA', true));
    imgWeapon[1] = UIImage(FindChild('imgWeaponB', true));
    imgWeapon[2] = UIImage(FindChild('imgWeaponC', true));
    imgBackground = UIImage(FindChild('Menu_box', true));
    PriWeapons[0].WeaponName = "<Strings:PandoraGame.Weapons.DesertEagle>";
    PriWeapons[0].WeaponDescription = "<Strings:PandoraGame.Weapons.DesertEagleDesc>";
    PriWeapons[1].WeaponName = "<Strings:PandoraGame.Weapons.MachineGun>";
    PriWeapons[1].WeaponDescription = "<Strings:PandoraGame.Weapons.MachineGunDesc>";
    PriWeapons[2].WeaponName = "<Strings:PandoraGame.Weapons.Pistol>";
    PriWeapons[2].WeaponDescription = "<Strings:PandoraGame.Weapons.9mmDesc>";
    PriWeapons[3].WeaponName = "<Strings:PandoraGame.Weapons.AssaultRifle>";
    PriWeapons[3].WeaponDescription = "<Strings:PandoraGame.Weapons.AssaultRifleDesc>";
    PriWeapons[4].WeaponName = "<Strings:PandoraGame.Weapons.Shotgun>";
    PriWeapons[4].WeaponDescription = "<Strings:PandoraGame.Weapons.ShotgunDesc>";
    SecWeapons[0].WeaponName = "<Strings:PandoraGame.Weapons.Grenade>";
    SecWeapons[0].WeaponDescription = "<Strings:PandoraGame.Weapons.GrenadeDesc>";
    DamageBar[0].Bar = SPProgressBar(FindChild('scbDamage1', true));
    RateOfFireBar[0].Bar = SPProgressBar(FindChild('scbRateOfFire1', true));
    ShortRangeBar[0].Bar = SPProgressBar(FindChild('scbShortRange1', true));
    LongRangeBar[0].Bar = SPProgressBar(FindChild('scbLongRange1', true));
    DamageBar[1].Bar = SPProgressBar(FindChild('scbDamage2', true));
    RateOfFireBar[1].Bar = SPProgressBar(FindChild('scbRateOfFire2', true));
    ShortRangeBar[1].Bar = SPProgressBar(FindChild('scbShortRange2', true));
    LongRangeBar[1].Bar = SPProgressBar(FindChild('scbLongRange2', true));
    DamageBar[2].Bar = SPProgressBar(FindChild('scbDamage3', true));
    RateOfFireBar[2].Bar = SPProgressBar(FindChild('scbRateOfFire3', true));
    ShortRangeBar[2].Bar = SPProgressBar(FindChild('scbShortRange3', true));
    LongRangeBar[2].Bar = SPProgressBar(FindChild('scbLongRange3', true));
    lblWeaponCount = UILabel(FindChild('lblWeaponCCount', true));
    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x635
    if(PGRI == none)
    {
    }
    SPPRI = SPPlayerReplicationInfo(GetPC().PlayerReplicationInfo);
    CurProfile = SPPRI.WeaponConfigIdx;
    PC = GetPC();
    // End:0x76F
    if(PC != none)
    {
        // End:0x6C1
        if(PandoraPlayerInput(PC.PlayerInput) != none)
        {
            PandoraPlayerInput(PC.PlayerInput).ForceFlushOfInput();
        }
        theSceneClient = PC.GetSceneClient();
        // End:0x748
        if(theSceneClient != none)
        {
            // End:0x721
            if(theSceneClient.GetActiveUIScene('UIScene_MPMenu') != none)
            {
                imgBackground.SetVisibility(true);                
            }
            else
            {
                imgBackground.SetVisibility(false);
                PC.m_bAllowInteractTextDisplay = false;
            }
        }
        bOrigIgnoreMovementFlag = PC.bIgnoreMoveInput;
        PC.bIgnoreMoveInput = 1;
    }
    UpdateDisplay();
    //return;    
}

function bool OnBackButtonClicked(UIScreenObject EventObject, int PlayerIndex)
{
    SceneClient.CloseScene(self);
    return true;
    //return ReturnValue;    
}

function UpdateProfile(int Idx)
{
    // End:0x21
    if(Idx >= PGRI.WeaponProfiles.Length)
    {
        Idx = 0;
    }
    // End:0x45
    if(Idx < 0)
    {
        Idx = PGRI.WeaponProfiles.Length - 1;
    }
    CurProfile = Idx;
    UpdateDisplay();
    //return;    
}

function UpdatePlayerInfo()
{
    local PandoraPlayerController PPC;

    PPC = GetPC();
    SPPRI = SPPlayerReplicationInfo(PPC.PlayerReplicationInfo);
    // End:0x37
    if(SPPRI == none)
    {
        return;
    }
    SPPRI.WeaponConfigIdx = CurProfile;
    SPPRI.RequestWeaponConfigChange(CurProfile);
    PPC.GiveLoadoutInventory(CurProfile);
    //return;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    UpDateUsingGamePadForPC(EventParms);
    // End:0x49
    if((IsInputCancel(EventParms)) || IsInputEscape(EventParms))
    {
        SceneClient.CloseScene(self);
        return true;
    }
    // End:0x79
    if(IsInputAccept(EventParms))
    {
        UpdatePlayerInfo();
        SceneClient.CloseScene(self);
        return true;
    }
    // End:0xCD
    if((IsInputNavLeft(EventParms)) || IsPCBuild() && IsInputLeftMouseDown(EventParms))
    {
        PlayUISound('NavigateLeft');
        UpdateProfile(--CurProfile);
        return true;
    }
    // End:0x121
    if((IsInputNavRight(EventParms)) || IsPCBuild() && IsInputRightMouseDown(EventParms))
    {
        PlayUISound('NavigateRight');
        UpdateProfile(++CurProfile);
        return true;
    }
    // End:0x139
    if(IsPCBuild())
    {
        HandleBackButtonInput(EventParms);
    }
    return true;
    //return ReturnValue;    
}

event InitScene()
{
    __OnSceneActivated__Delegate = WeaponConfigSceneActivated;
    super.InitScene();
    //return;    
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
    UpdateStatBars(DeltaTime);
    super.UpdateScene(DeltaTime, WorldInfo);
    //return;    
}

event SceneDeactivated()
{
    local PandoraPlayerController PC;

    PC = GetPC();
    // End:0x2D
    if(PC != none)
    {
        PC.m_bAllowInteractTextDisplay = true;
    }
    PC.bIgnoreMoveInput = bOrigIgnoreMovementFlag;
    super.SceneDeactivated();
    //return;    
}
