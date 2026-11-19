class UIScene_WeaponAdjustment extends UIScene_BaseFrontEnd
    config(MPWeaponConfig);

enum TEditBoxes
{
    EB_DAMAGE,                      // 0
    EB_NORMALSTOPPED,               // 1
    EB_CROUCHEDSTOPPED,             // 2
    EB_DOWNSITESTOPPED,             // 3
    EB_CROUCHEDDOWNSITESTOPPED,     // 4
    EB_FIRSTSHOTDOWNSITESTOPPED,    // 5
    EB_NORMALFS,                    // 6
    EB_CROUCHEDFS,                  // 7
    EB_DOWNSITEFS,                  // 8
    EB_CROUCHEDDOWNSITEFS,          // 9
    EB_FIRSTSHOTDOWNSITEFS,         // 10
    EB_MAX                          // 11
};

var SPWeapon CurrentWeapon;
var UILabel WeaponTextLabel;
var UILabelButton ApplyButton;
var UILabelButton cancelbutton;
var UILabelButton WriteToFileButton;
var config string WeaponName;
var config float Damage;
var config float NormalStopped;
var config float CrouchedStopped;
var config float DownSiteStopped;
var config float CrouchedDownSiteStopped;
var config float FirstShotDownSiteStopped;
var config float NormalFullspeed;
var config float CrouchedFullspeed;
var config float DownSiteFullspeed;
var config float CrouchedDownSiteFullspeed;
var config float FirstShotDownSiteFullspeed;

event InitScene()
{
    super.InitScene();
    WeaponTextLabel = UILabel(FindChild('WeaponTextLabel', true));
    ApplyButton = UILabelButton(FindChild('Apply', true));
    cancelbutton = UILabelButton(FindChild('Cancel', true));
    WriteToFileButton = UILabelButton(FindChild('WriteToFile', true));
    ApplyButton.__OnPressed__Delegate = Clicked;
    cancelbutton.__OnPressed__Delegate = Clicked;
    WriteToFileButton.__OnPressed__Delegate = Clicked;
    UpdateWeaponInfo();
    CurrMenuItemIdx = 0;
    RestoreFocus();
    //return;    
}

function OnValueChanged(UIObject Sender, int PlayerIndex)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x59 [Loop If]
    if(I < MenuItems.Length)
    {
        // End:0x4F
        if(Sender == MenuItems[I].EditBoxObj)
        {
            CurrMenuItemIdx = I;
            RestoreFocus();
            // [Explicit Break]
            goto J0x59;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x59:

    //return;    
}

function Clicked(UIScreenObject EventObject, int PlayerIndex)
{
    // End:0x1D
    if(EventObject == ApplyButton)
    {
        UpdateWeaponParam(false);        
    }
    else
    {
        // End:0x37
        if(EventObject == WriteToFileButton)
        {
            UpdateWeaponParam(true);
        }
    }
    SceneClient.CloseScene(self);
    //return;    
}

function bool UpdateWeaponInfo()
{
    // End:0x3B7
    if((GetPC().Pawn != none) && GetPC().Pawn.Weapon != none)
    {
        CurrentWeapon = SPWeapon(GetPC().Pawn.Weapon);
        WeaponTextLabel.SetDataStoreBinding(string(CurrentWeapon.Class));
        // End:0xCB
        if(CurrentWeapon.m_DamageValue == float(0))
        {
            CurrentWeapon.m_DamageValue = CurrentWeapon.BulletProjectileClass.default.Damage;
        }
        MenuItems[0].EditBoxObj.SetDataStoreBinding(string(CurrentWeapon.m_DamageValue));
        MenuItems[1].EditBoxObj.SetDataStoreBinding(string(CurrentWeapon.SpreadInfo.Normal.StoppedSpreadValue));
        MenuItems[2].EditBoxObj.SetDataStoreBinding(string(CurrentWeapon.SpreadInfo.Crouched.StoppedSpreadValue));
        MenuItems[3].EditBoxObj.SetDataStoreBinding(string(CurrentWeapon.SpreadInfo.DownSite.StoppedSpreadValue));
        MenuItems[4].EditBoxObj.SetDataStoreBinding(string(CurrentWeapon.SpreadInfo.CrouchedDownSite.StoppedSpreadValue));
        MenuItems[5].EditBoxObj.SetDataStoreBinding(string(CurrentWeapon.SpreadInfo.FirstShotDownSite.StoppedSpreadValue));
        MenuItems[6].EditBoxObj.SetDataStoreBinding(string(CurrentWeapon.SpreadInfo.Normal.FullSpeedSpreadValue));
        MenuItems[7].EditBoxObj.SetDataStoreBinding(string(CurrentWeapon.SpreadInfo.Crouched.FullSpeedSpreadValue));
        MenuItems[8].EditBoxObj.SetDataStoreBinding(string(CurrentWeapon.SpreadInfo.DownSite.FullSpeedSpreadValue));
        MenuItems[9].EditBoxObj.SetDataStoreBinding(string(CurrentWeapon.SpreadInfo.CrouchedDownSite.FullSpeedSpreadValue));
        MenuItems[10].EditBoxObj.SetDataStoreBinding(string(CurrentWeapon.SpreadInfo.FirstShotDownSite.FullSpeedSpreadValue));
        return true;
    }
    return false;
    //return ReturnValue;    
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
    local PandoraPlayerController PC;

    super.UpdateScene(DeltaTime, WorldInfo);
    PC = GetPC();
    // End:0x8C
    if(((PC == none) || PC.Pawn == none) || (PC.Pawn != none) && PC.Pawn.Weapon == none)
    {
        SceneClient.CloseScene(self);
    }
    //return;    
}

function bool OnSubmitText(UIEditBox Sender, int PlayerIndex)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x59 [Loop If]
    if(I < MenuItems.Length)
    {
        // End:0x4F
        if(Sender == MenuItems[I].EditBoxObj)
        {
            CurrMenuItemIdx = I;
            RestoreFocus();
            // [Explicit Break]
            goto J0x59;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x59:

    return false;
    //return ReturnValue;    
}

function UpdateWeaponParam(bool bWriteToFile)
{
    local int I;
    local float Value;

    WeaponName = string(CurrentWeapon.Class);
    I = 0;
    J0x1E:

    // End:0x303 [Loop If]
    if(I < (MenuItems.Length - 2))
    {
        Value = float(MenuItems[I].EditBoxObj.GetValue());
        switch(I)
        {
            // End:0x8B
            case 0:
                CurrentWeapon.m_DamageValue = Value;
                Damage = Value;
                // End:0x2F9
                break;
            // End:0xC8
            case 1:
                CurrentWeapon.SpreadInfo.Normal.StoppedSpreadValue = Value;
                NormalStopped = Value;
                // End:0x2F9
                break;
            // End:0x106
            case 2:
                CurrentWeapon.SpreadInfo.Crouched.StoppedSpreadValue = Value;
                CrouchedStopped = Value;
                // End:0x2F9
                break;
            // End:0x144
            case 3:
                CurrentWeapon.SpreadInfo.DownSite.StoppedSpreadValue = Value;
                DownSiteStopped = Value;
                // End:0x2F9
                break;
            // End:0x182
            case 4:
                CurrentWeapon.SpreadInfo.CrouchedDownSite.StoppedSpreadValue = Value;
                CrouchedDownSiteStopped = Value;
                // End:0x2F9
                break;
            // End:0x1C0
            case 5:
                CurrentWeapon.SpreadInfo.FirstShotDownSite.StoppedSpreadValue = Value;
                FirstShotDownSiteStopped = Value;
                // End:0x2F9
                break;
            // End:0x1FE
            case 6:
                CurrentWeapon.SpreadInfo.Normal.FullSpeedSpreadValue = Value;
                NormalFullspeed = Value;
                // End:0x2F9
                break;
            // End:0x23C
            case 7:
                CurrentWeapon.SpreadInfo.Crouched.FullSpeedSpreadValue = Value;
                CrouchedFullspeed = Value;
                // End:0x2F9
                break;
            // End:0x27A
            case 8:
                CurrentWeapon.SpreadInfo.DownSite.FullSpeedSpreadValue = Value;
                DownSiteFullspeed = Value;
                // End:0x2F9
                break;
            // End:0x2B8
            case 9:
                CurrentWeapon.SpreadInfo.CrouchedDownSite.FullSpeedSpreadValue = Value;
                CrouchedDownSiteFullspeed = Value;
                // End:0x2F9
                break;
            // End:0x2F6
            case 10:
                CurrentWeapon.SpreadInfo.FirstShotDownSite.FullSpeedSpreadValue = Value;
                FirstShotDownSiteFullspeed = Value;
                // End:0x2F9
                break;
            // End:0xFFFF
            default:
                break;
        }
        I++;
        // [Loop Continue]
        goto J0x1E;
    }
    // End:0x30F
    if(bWriteToFile)
    {
        SaveConfig();
    }
    //return;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    UpDateUsingGamePadForPC(EventParms);
    // End:0x8B
    if(!bInputDisabled)
    {
        // End:0x8B
        if(MenuItems.Length > 0)
        {
            // End:0x8B
            if(MenuItems[CurrMenuItemIdx].EditBoxObj != none)
            {
                // End:0x8B
                if((!IsInputEscape(EventParms) && !GetWorldInfo().IsConsoleBuild()) && !IsInputAccept(EventParms))
                {
                    return false;
                }
            }
        }
    }
    return super.CustomInputKey(EventParms);
    //return ReturnValue;    
}
