class UIAction_GetWeaponImage extends UIAction_GetValue
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

var() UIAction_GetWeaponImage.EWeapon Weapon;

function Activated()
{
    local MOHAIncludeClass.EWeaponType WeaponType;
    local MOHAPlayerController PlayerController;
    local MOHAPlayerPawn PlayerPawn;

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
            WeaponType = MOHAInventoryManager(PlayerPawn.InvManager).GammonGrenadeWeapon.WeaponType;
            // End:0x15A
            break;
        // End:0x157
        case 4:
            WeaponType = MOHAInventoryManager(PlayerPawn.InvManager).StickGrenadeWeapon.WeaponType;
            // End:0x15A
            break;
        // End:0xFFFF
        default:
            break;
    }
    switch(WeaponType)
    {
        // End:0x1BB
        case 1:
            SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = "<Images:UI_Weapons_Art.thompson_color_side_01>";
            // End:0x6E3
            break;
        // End:0x20C
        case 2:
            SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = "<Images:UI_Weapons_Art.question_mark>";
            // End:0x6E3
            break;
        // End:0x25D
        case 11:
            SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = "<Images:UI_Weapons_Art.question_mark>";
            // End:0x6E3
            break;
        // End:0x2B3
        case 3:
            SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = "<Images:UI_Weapons_Art.mp40_color_side_01>";
            // End:0x6E3
            break;
        // End:0x304
        case 5:
            SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = "<Images:UI_Weapons_Art.question_mark>";
            // End:0x6E3
            break;
        // End:0x355
        case 6:
            SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = "<Images:UI_Weapons_Art.question_mark>";
            // End:0x6E3
            break;
        // End:0x3AD
        case 7:
            SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = "<Images:UI_Weapons_Art.garand_color_side_01>";
            // End:0x6E3
            break;
        // End:0x405
        case 4:
            SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = "<Images:UI_Weapons_Art.sniper_color_side_01>";
            // End:0x6E3
            break;
        // End:0x45D
        case 17:
            SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = "<Images:UI_Weapons_Art.sniper_color_side_01>";
            // End:0x6E3
            break;
        // End:0x4AE
        case 8:
            SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = "<Images:UI_Weapons_Art.question_mark>";
            // End:0x6E3
            break;
        // End:0x4FF
        case 9:
            SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = "<Images:UI_Weapons_Art.question_mark>";
            // End:0x6E3
            break;
        // End:0x550
        case 19:
            SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = "<Images:UI_Weapons_Art.question_mark>";
            // End:0x6E3
            break;
        // End:0x5A1
        case 18:
            SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = "<Images:UI_Weapons_Art.question_mark>";
            // End:0x6E3
            break;
        // End:0x5F2
        case 13:
            SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = "<Images:UI_Weapons_Art.question_mark>";
            // End:0x6E3
            break;
        // End:0x643
        case 20:
            SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = "<Images:UI_Weapons_Art.question_mark>";
            // End:0x6E3
            break;
        // End:0x694
        case 14:
            SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = "<Images:UI_Weapons_Art.question_mark>";
            // End:0x6E3
            break;
        // End:0xFFFF
        default:
            SeqVar_String(VariableLinks[0].LinkedVariables[0]).StrValue = "<Images:UI_Weapons_Art.question_mark>";
            // End:0x6E3
            break;
            break;
    }
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Player Index",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Gamepad Id",LinkVar="None",PropertyName="GamepadID",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[3]=(ExpectedType=Class'Engine.SeqVar_String',LinkedVariables=none,LinkDesc="Weapon",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    ObjName="Get Weapon Image"
}