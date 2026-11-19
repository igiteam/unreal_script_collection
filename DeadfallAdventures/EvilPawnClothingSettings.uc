class EvilPawnClothingSettings extends Object;

struct ClothPart
{
    var() editoronly string Description;
    var() float ChanceToShow;
    var() array<EvilPawnClothAssetInterface> ClothParts;

    structdefaultproperties
    {
        Description=""
        ChanceToShow=1.0000000
        ClothParts=none
    }
};

struct MaterialInfo
{
    var() int MaterialIndexes;
    var() array<MaterialInterface> RandomMaterials;
    var() array<int> AddInMaterials;

    structdefaultproperties
    {
        MaterialIndexes=0
        RandomMaterials=none
        AddInMaterials=none
    }
};

struct MaterialPart
{
    var() editoronly string Description;
    var() float ChanceToShow;
    var() array<MaterialInfo> MaterialsInfo;

    structdefaultproperties
    {
        Description=""
        ChanceToShow=1.0000000
        MaterialsInfo=none
    }
};

struct WeaponsInfo
{
    var() EvilPawnClothAssetInterface WeaponAsset;
    var() class<Inventory> WeaponClass;

    structdefaultproperties
    {
        WeaponAsset=none
        WeaponClass=none
    }
};

struct ShieldsInfo
{
    var() EvilPawnClothAssetInterface ShieldAsset;
    var() class<Inventory> ShieldClass;

    structdefaultproperties
    {
        ShieldAsset=none
        ShieldClass=none
    }
};

struct SwitchMaterialInfo
{
    var() int MaterialIndex;
    var() MaterialInterface NewMaterial;

    structdefaultproperties
    {
        MaterialIndex=0
        NewMaterial=none
    }
};

var() array<ClothPart> Clothes;
var() float EquipmentChance;
var() array<ClothPart> Equipment;
var() array<ClothPart> Heads;
var() array<MaterialPart> Materials;
var() array<WeaponsInfo> Weapons;
var() array<ShieldsInfo> Shields;
var() array<SwitchMaterialInfo> SwitchMaterials;
