class AdvMapInfo extends EvilMapInfo
    editinlinenew;

struct FlashLightParamsStruct
{
    var() float Brightness;

    structdefaultproperties
    {
        Brightness=12.0000000
    }
};

var() array<Actor> StartViewPointsMP;
var(Skins) string MultiplayerSkinType;
var(Skins) class<EvilFamilyInfoBase> PlayerSkinClass;
var(Survival) array<AdvTypes.EAITypes> WeakEnemiesTypes;
var(Survival) array<AdvTypes.EAITypes> MediumEnemiesTypes;
var(Survival) array<AdvTypes.EAITypes> HardEnemiesTypes;
var(Survival) array<AdvTypes.EAITypes> BossEnemiesTypes;
var(Decals) array<MaterialInstanceTimeVarying> BloodDecalMaterials;
var() editinline FlashLightParamsStruct FlashLightParams;
var() SwfMovie TreasureMapMovie;
var() array<MapNote> MapNotes;
var() class<WeaponSinglePlayerReferences_Base> WeaponReferences;

defaultproperties
{
    MultiplayerSkinType="Normal"
    BloodDecalMaterials[0]=MaterialInstanceTimeVarying'ps_Blood.Decals.m_ps_BloodDecal_Ver1'
    BloodDecalMaterials[1]=MaterialInstanceTimeVarying'ps_Blood.Decals.m_ps_BloodDecal_Ver2'
    BloodDecalMaterials[2]=MaterialInstanceTimeVarying'ps_Blood.Decals.m_ps_BloodDecal_Ver3'
    BloodDecalMaterials[3]=MaterialInstanceTimeVarying'ps_Blood.Decals.m_ps_BloodDecal_Ver4'
    FlashLightParams=(Brightness=12.0000000)
}