class UIAction_GetWeaponUpgradeImages extends UIAction_GetValue
    hidecategories(Object);

enum EWeapon
{
    PRIMARY_WEAPON,                 // 0
    SECONDARY_WEAPON,               // 1
    Grenade_1,                      // 2
    Grenade_2,                      // 3
    Grenade_3,                      // 4
    EWeapon_MAX                     // 5
};

var() UIAction_GetWeaponUpgradeImages.EWeapon Weapon;

function Activated()
{
    local int AllowedWeaponUpgradeLevel, I;
    local MOHAIncludeClass.EWeaponType WeaponType;
    local string textureNames[3];
    local MOHAPlayerController PlayerController;
    local MOHAPlayerPawn PlayerPawn;
    local editinline MOHAWeaponExperienceComponent experienceComponent;

    // End:0x37
    foreach GetWorldInfo().DynamicActors(Class'MOHAPlayerController', PlayerController)
    {
        // End:0x36
        if(NetConnection(PlayerController.Player) == none)
        {
            // End:0x37
            break;
        }        
    }    
    PlayerPawn = MOHAPlayerPawn(PlayerController.Pawn);
    switch(Weapon)
    {
        // End:0x8B
        case 0:
            WeaponType = MOHAInventoryManager(PlayerPawn.InvManager).PrimaryWeapon.WeaponType;
            // End:0x15A
            break;
        // End:0xBE
        case 1:
            WeaponType = MOHAInventoryManager(PlayerPawn.InvManager).SecondaryWeapon.WeaponType;
            // End:0x15A
            break;
        // End:0xF1
        case 2:
            WeaponType = MOHAInventoryManager(PlayerPawn.InvManager).FragGrenadeWeapon.WeaponType;
            // End:0x15A
            break;
        // End:0x124
        case 3:
            WeaponType = MOHAInventoryManager(PlayerPawn.InvManager).StickGrenadeWeapon.WeaponType;
            // End:0x15A
            break;
        // End:0x157
        case 4:
            WeaponType = MOHAInventoryManager(PlayerPawn.InvManager).GammonGrenadeWeapon.WeaponType;
            // End:0x15A
            break;
        // End:0xFFFF
        default:
            break;
    }
    switch(WeaponType)
    {
        // End:0x1B6
        case 1:
            textureNames[0] = "pistol_grip";
            textureNames[1] = "cutts_compensator";
            textureNames[2] = "50_round_ammo_drum";
            // End:0x46F
            break;
        // End:0x1DD
        case 2:
            textureNames[0] = "";
            textureNames[1] = "";
            textureNames[2] = "";
            // End:0x46F
            break;
        // End:0x204
        case 11:
            textureNames[0] = "";
            textureNames[1] = "";
            textureNames[2] = "";
            // End:0x46F
            break;
        // End:0x242
        case 3:
            textureNames[0] = "taped_round";
            textureNames[1] = "mp40_64round";
            textureNames[2] = "";
            // End:0x46F
            break;
        // End:0x269
        case 5:
            textureNames[0] = "";
            textureNames[1] = "";
            textureNames[2] = "";
            // End:0x46F
            break;
        // End:0x290
        case 6:
            textureNames[0] = "";
            textureNames[1] = "";
            textureNames[2] = "";
            // End:0x46F
            break;
        // End:0x2CE
        case 7:
            textureNames[0] = "garand_grenade_launcher";
            textureNames[1] = "";
            textureNames[2] = "";
            // End:0x46F
            break;
        // End:0x312
        case 4:
            textureNames[0] = "bolt";
            textureNames[1] = "sniper_scope";
            textureNames[2] = "stripper_clip";
            // End:0x46F
            break;
        // End:0x339
        case 17:
            textureNames[0] = "";
            textureNames[1] = "";
            textureNames[2] = "";
            // End:0x46F
            break;
        // End:0x360
        case 8:
            textureNames[0] = "";
            textureNames[1] = "";
            textureNames[2] = "";
            // End:0x46F
            break;
        // End:0x387
        case 18:
            textureNames[0] = "";
            textureNames[1] = "";
            textureNames[2] = "";
            // End:0x46F
            break;
        // End:0x3AE
        case 13:
            textureNames[0] = "";
            textureNames[1] = "";
            textureNames[2] = "";
            // End:0x46F
            break;
        // End:0x3D5
        case 9:
            textureNames[0] = "";
            textureNames[1] = "";
            textureNames[2] = "";
            // End:0x46F
            break;
        // End:0x3FC
        case 19:
            textureNames[0] = "";
            textureNames[1] = "";
            textureNames[2] = "";
            // End:0x46F
            break;
        // End:0x423
        case 20:
            textureNames[0] = "";
            textureNames[1] = "";
            textureNames[2] = "";
            // End:0x46F
            break;
        // End:0x44A
        case 14:
            textureNames[0] = "";
            textureNames[1] = "";
            textureNames[2] = "";
            // End:0x46F
            break;
        // End:0xFFFF
        default:
            textureNames[0] = "";
            textureNames[1] = "";
            textureNames[2] = "";
            // End:0x46F
            break;
            break;
    }
    experienceComponent = PlayerController.playerStats.GetWeaponExpComponentByType(WeaponType);
    AllowedWeaponUpgradeLevel = experienceComponent.ExperienceLevel - 1;
    I = 0;
    J0x4B4:

    // End:0x60B [Loop If]
    if(I < 3)
    {
        // End:0x4E2
        if(VariableLinks[I].LinkedVariables.Length == 0)
        {
            // [Explicit Continue]
            goto J0x601;
            // [Explicit Continue]
            goto J0x601;
        }
        // End:0x544
        if(textureNames[I] == "")
        {
            SeqVar_String(VariableLinks[I].LinkedVariables[0]).StrValue = "<Images:UI_Weapons_Art.question_mark>";
            // [Explicit Continue]
            goto J0x601;
        }
        // End:0x5AD
        if(I <= AllowedWeaponUpgradeLevel)
        {
            SeqVar_String(VariableLinks[I].LinkedVariables[0]).StrValue = ("<Images:UI_Weapons_Art." $ textureNames[I]) $ "_color>";
            // [Explicit Continue]
            goto J0x601;
        }
        SeqVar_String(VariableLinks[I].LinkedVariables[0]).StrValue = ("<Images:UI_Weapons_Art." $ textureNames[I]) $ "_bw>";
        J0x601:

        I++;
        // [Loop Continue]
        goto J0x4B4;
    }
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Upgrade1",LinkVar="None",PropertyName="Targets",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Upgrade2",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Upgrade3",LinkVar="None",PropertyName="GamepadID",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Get Weapon Upgrade Images"
}