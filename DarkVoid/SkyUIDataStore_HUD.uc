class SkyUIDataStore_HUD extends UIDataStore
    transient
    native;

enum EInteractAction
{
    NoAction,                       // 0
    Pickup,                         // 1
    SwapWeapon,                     // 2
    Ammo,                           // 3
    AmmoFull,                       // 4
    CoverEnterVU,                   // 5
    CoverEnterVD,                   // 6
    CoverEnterH,                    // 7
    CoverSlip,                      // 8
    CoverSwatVU,                    // 9
    CoverSwatVD,                    // 10
    CoverSwatH,                     // 11
    CoverDive,                      // 12
    CoverMantleVU,                  // 13
    CoverMantleVD,                  // 14
    CoverMantleH,                   // 15
    CoverStepUp,                    // 16
    EInteractAction_MAX             // 17
};

var private native const noexport Pointer VfTable_FCallbackEventDevice;
var transient SkyUIDataStore_HUD.EInteractAction ia;
var transient SkyPawn PawnThisFrame;
var transient SkyPlayerController ControllerThisFrame;
var transient SkyHUD HUDThisFrame;
var transient SkyVehicle VehicleThisFrame;
var transient SkyWeaponBase PrimaryThisFrame;
var transient SkyWeaponBase SecondaryThisFrame;
var Texture2D button_y;
var Texture2D button_x;
var Texture2D button_b;
var Texture2D button_a;
var Texture2D button_y_quad;
var Texture2D button_x_quad;
var Texture2D button_b_quad;
var Texture2D button_a_quad;
var Texture2D icon_weapon_machinegun;
var Texture2D icon_weapon_shotgun;
var Texture2D icon_weapon_dynOmite;
var Texture2D icon_weapon_radar;
var Texture2D button_rightbumper;
var Texture2D button_lefttrigger;
var Texture2D button_righttrigger;

// Export USkyUIDataStore_HUD::execGetFieldValue(FFrame&, void* const)
native event bool GetFieldValue(string FieldName, out UIProviderScriptFieldValue FieldValue, optional int ArrayIndex = -1);

// Export USkyUIDataStore_HUD::execCacheActors(FFrame&, void* const)
native function CacheActors();

event RefreshSubscribers(optional name PropertyTag, optional bool bInvalidateValues = true, optional UIDataProvider SourceProvider, optional int ArrayIndex = -1)
{
    CacheActors();
    super.RefreshSubscribers(PropertyTag, bInvalidateValues, SourceProvider, ArrayIndex);
    //return;    
}

event string GetObjectiveText(SkyPlayerController PC)
{
    local SkyPlayerReplicationInfo PRI;

    // End:0x0E
    if(PC == none)
    {
        return "";
    }
    PRI = SkyPlayerReplicationInfo(PC.PlayerReplicationInfo);
    // End:0x43
    if(PRI != none)
    {
        return PRI.CurrentObjectiveText;
    }
    return "";
    //return ReturnValue;    
}

event string GetInteractionText(SkyPlayerController PC)
{
    local SkyHUD SHud;

    // End:0x12
    if(PC == none)
    {
        return "None";
    }
    SHud = SkyHUD(PC.myHUD);
    // End:0x47
    if(SHud != none)
    {
        return SHud.CurrentInteractionText;
    }
    return "None";
    //return ReturnValue;    
}

event string GetEquippedWeaponName(SkyPlayerController PC)
{
    local SkyHUD SHud;

    // End:0x0E
    if(PC == none)
    {
        return "";
    }
    SHud = SkyHUD(PC.myHUD);
    // End:0x43
    if(SHud != none)
    {
        return SHud.EquippedWeaponName;
    }
    return "";
    //return ReturnValue;    
}

event Texture2D GetEquippedWeaponTexture(SkyPlayerController PC)
{
    local SkyHUD SHud;

    // End:0x0D
    if(PC == none)
    {
        return none;
    }
    SHud = SkyHUD(PC.myHUD);
    // End:0x47
    if(SHud != none)
    {
        return Texture2D(SHud.TexEquippedWeapon);
    }
    return none;
    //return ReturnValue;    
}

event string GetGroundWeaponName(SkyPlayerController PC)
{
    local SkyHUD SHud;

    // End:0x0E
    if(PC == none)
    {
        return "";
    }
    SHud = SkyHUD(PC.myHUD);
    // End:0x43
    if(SHud != none)
    {
        return SHud.GroundWeaponName;
    }
    return "";
    //return ReturnValue;    
}

event Texture2D GetGroundWeaponTexture(SkyPlayerController PC)
{
    local SkyHUD SHud;

    // End:0x0D
    if(PC == none)
    {
        return none;
    }
    SHud = SkyHUD(PC.myHUD);
    // End:0x47
    if(SHud != none)
    {
        return Texture2D(SHud.TexGroundWeapon);
    }
    return none;
    //return ReturnValue;    
}

event string GetWeaponSwapCost(SkyPlayerController PC)
{
    local SkyHUD SHud;

    // End:0x0E
    if(PC == none)
    {
        return "";
    }
    SHud = SkyHUD(PC.myHUD);
    // End:0x43
    if(SHud != none)
    {
        return SHud.WeaponSwapCost;
    }
    return "";
    //return ReturnValue;    
}
