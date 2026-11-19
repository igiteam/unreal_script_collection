class MOHAHUDWeaponInfo extends Object
    native;

struct native UpgradeInfo
{
    var string UpgradeName;
    var string UpgradeBenefit;
    var Vector2D IconUV;
    var Vector2D IconUVSize;
    var Vector2D IconPixelSize;

    structdefaultproperties
    {
        UpgradeName=""
        UpgradeBenefit=""
        IconUV=(X=0.0000000,Y=0.0000000)
        IconUVSize=(X=0.0000000,Y=0.0000000)
        IconPixelSize=(X=0.0000000,Y=0.0000000)
    }
};

var Texture2D UpgradeIconsImage;
var const localized array<localized UpgradeInfo> Info;
var Texture2D WeaponIconImage;
var float OutlineWidth;
var float OutlineMatchOffset;
var float WeaponIconSizeX;
var float WeaponIconSizeY;
var float WeaponIconWidth;
var float WeaponIconHeight;
var float WeaponIconU;
var float WeaponIconV;

defaultproperties
{
    UpgradeIconsImage=Texture2D'HUD.HUD_WeaponsUpgrade01'
    Info[0]=(UpgradeName="Upgrade 1",UpgradeBenefit="",IconUV=(X=0.0000000,Y=0.0000000),IconUVSize=(X=0.0000000,Y=0.0000000),IconPixelSize=(X=0.0000000,Y=0.0000000))
    Info[1]=(UpgradeName="Upgrade 2",UpgradeBenefit="",IconUV=(X=0.0000000,Y=0.0000000),IconUVSize=(X=0.0000000,Y=0.0000000),IconPixelSize=(X=0.0000000,Y=0.0000000))
    Info[2]=(UpgradeName="Upgrade 3",UpgradeBenefit="",IconUV=(X=0.0000000,Y=0.0000000),IconUVSize=(X=0.0000000,Y=0.0000000),IconPixelSize=(X=0.0000000,Y=0.0000000))
    WeaponIconImage=Texture2D'HUD.HUDWeapon02'
    WeaponIconSizeX=64.0000000
    WeaponIconSizeY=241.0000000
    WeaponIconWidth=64.0000000
    WeaponIconHeight=256.0000000
    WeaponIconV=257.0000000
}