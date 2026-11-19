class UIAction_GetWeaponProficiencyLevel extends UIAction_GetValue
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

var() UIAction_GetWeaponProficiencyLevel.EWeapon Weapon;
var int WeaponLevel;
var() int WeaponTypeIndex;

function Activated()
{
    local MOHAIncludeClass.EWeaponType WeaponType;
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
    // End:0x5E
    if(PlayerPawn == none)
    {
        return;
    }
    // End:0x7D
    if(WeaponTypeIndex != -1)
    {
        WeaponType = byte(WeaponTypeIndex);        
    }
    else
    {
        switch(Weapon)
        {
            // End:0xB7
            case 0:
                WeaponType = MOHAInventoryManager(PlayerPawn.InvManager).PrimaryWeapon.WeaponType;
                // End:0x186
                break;
            // End:0xEA
            case 1:
                WeaponType = MOHAInventoryManager(PlayerPawn.InvManager).SecondaryWeapon.WeaponType;
                // End:0x186
                break;
            // End:0x11D
            case 2:
                WeaponType = MOHAInventoryManager(PlayerPawn.InvManager).FragGrenadeWeapon.WeaponType;
                // End:0x186
                break;
            // End:0x150
            case 3:
                WeaponType = MOHAInventoryManager(PlayerPawn.InvManager).StickGrenadeWeapon.WeaponType;
                // End:0x186
                break;
            // End:0x183
            case 4:
                WeaponType = MOHAInventoryManager(PlayerPawn.InvManager).GammonGrenadeWeapon.WeaponType;
                // End:0x186
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    WeaponLevel = 0;
    experienceComponent = PlayerController.playerStats.GetWeaponExpComponentByType(WeaponType);
    // End:0x1D3
    if(experienceComponent != none)
    {
        WeaponLevel = experienceComponent.ExperienceLevel;
    }
    //return;    
}

defaultproperties
{
    WeaponLevel=-1
    WeaponTypeIndex=-1
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Player Index",LinkVar="None",PropertyName="None",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Gamepad Id",LinkVar="None",PropertyName="GamepadID",bWriteable=true,bHidden=true,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[3]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Level",LinkVar="None",PropertyName="WeaponLevel",bWriteable=true,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none)
    VariableLinks[4]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="WeaponType",LinkVar="None",PropertyName="WeaponTypeIndex",bWriteable=false,bHidden=true,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none)
    ObjName="Get Weapon Proficiency Level"
}