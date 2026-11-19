class MOHACheatWidget extends UIButton
    native
    hidecategories(Object,UIRoot,Object);

const MAX_CHEAT_ENTRY_KEYS = 6;

var bool bPressedEnterCheatL;
var bool bPressedEnterCheatR;
var bool bEnterCheatListen;
var array<name> EnterCheatBuffer;
var string CheatCommand;
var name UnlockMissionsCheatKeys[6];
var name BulletShieldCheatKeys[6];
var name FullAmmoCheatKeys[6];
var name InfiniteAmmoCheatKeys[6];
var name UnlockWeaponsCheatKeys[6];
var name WeaponUpgradeCheatKeys[6];
var name HeadShotsOnlyCheatKeys[6];
var name HealthCheatKeys[6];

defaultproperties
{
    UnlockMissionsCheatKeys[0]="XboxTypeS_X"
    UnlockMissionsCheatKeys[1]="XboxTypeS_X"
    UnlockMissionsCheatKeys[2]="XboxTypeS_Y"
    UnlockMissionsCheatKeys[3]="XboxTypeS_Y"
    UnlockMissionsCheatKeys[4]="XboxTypeS_A"
    UnlockMissionsCheatKeys[5]="XboxTypeS_Y"
    BulletShieldCheatKeys[0]="XboxTypeS_X"
    BulletShieldCheatKeys[1]="XboxTypeS_B"
    BulletShieldCheatKeys[2]="XboxTypeS_X"
    BulletShieldCheatKeys[3]="XboxTypeS_Y"
    BulletShieldCheatKeys[4]="XboxTypeS_B"
    BulletShieldCheatKeys[5]="XboxTypeS_A"
    FullAmmoCheatKeys[0]="XboxTypeS_A"
    FullAmmoCheatKeys[1]="XboxTypeS_A"
    FullAmmoCheatKeys[2]="XboxTypeS_X"
    FullAmmoCheatKeys[3]="XboxTypeS_Y"
    FullAmmoCheatKeys[4]="XboxTypeS_X"
    FullAmmoCheatKeys[5]="XboxTypeS_B"
    InfiniteAmmoCheatKeys[0]="XboxTypeS_B"
    InfiniteAmmoCheatKeys[1]="XboxTypeS_B"
    InfiniteAmmoCheatKeys[2]="XboxTypeS_Y"
    InfiniteAmmoCheatKeys[3]="XboxTypeS_X"
    InfiniteAmmoCheatKeys[4]="XboxTypeS_A"
    InfiniteAmmoCheatKeys[5]="XboxTypeS_Y"
    UnlockWeaponsCheatKeys[0]="XboxTypeS_A"
    UnlockWeaponsCheatKeys[1]="XboxTypeS_B"
    UnlockWeaponsCheatKeys[2]="XboxTypeS_X"
    UnlockWeaponsCheatKeys[3]="XboxTypeS_Y"
    UnlockWeaponsCheatKeys[4]="XboxTypeS_A"
    UnlockWeaponsCheatKeys[5]="XboxTypeS_B"
    WeaponUpgradeCheatKeys[0]="XboxTypeS_Y"
    WeaponUpgradeCheatKeys[1]="XboxTypeS_B"
    WeaponUpgradeCheatKeys[2]="XboxTypeS_Y"
    WeaponUpgradeCheatKeys[3]="XboxTypeS_Y"
    WeaponUpgradeCheatKeys[4]="XboxTypeS_A"
    WeaponUpgradeCheatKeys[5]="XboxTypeS_X"
    HeadShotsOnlyCheatKeys[0]="XboxTypeS_B"
    HeadShotsOnlyCheatKeys[1]="XboxTypeS_Y"
    HeadShotsOnlyCheatKeys[2]="XboxTypeS_X"
    HeadShotsOnlyCheatKeys[3]="XboxTypeS_Y"
    HeadShotsOnlyCheatKeys[4]="XboxTypeS_Y"
    HeadShotsOnlyCheatKeys[5]="XboxTypeS_A"
    HealthCheatKeys[0]="XboxTypeS_Y"
    HealthCheatKeys[1]="XboxTypeS_X"
    HealthCheatKeys[2]="XboxTypeS_X"
    HealthCheatKeys[3]="XboxTypeS_Y"
    HealthCheatKeys[4]="XboxTypeS_A"
    HealthCheatKeys[5]="XboxTypeS_B"
    // Reference: UIComp_DrawImage'Default__MOHACheatWidget.BackgroundImageTemplate'
    begin object name=BackgroundImageTemplate
    end object
    BackgroundImageComponent=BackgroundImageTemplate
    // Reference: UIComp_Event'Default__MOHACheatWidget.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}