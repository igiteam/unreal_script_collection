class AdvCharacterStore extends Object
    native;

enum ESkinCategory
{
    SKIN_Normal,                    // 0
    SKIN_Arctic,                    // 1
    SKIN_Tropic,                    // 2
    SKIN_Special,                   // 3
    SKIN_MAX                        // 4
};

struct native FamilyInfoToPackageName
{
    var string FamilyInfoPath;
    var string PackageName;
    var string IconPath;
    var AdvCharacterStore.ESkinCategory SkinCategory;
    var int DLCIndex;
    var int UnlockLevel;
    var bool bVisibleInMenu;
    var bool bAvailableInSurvival;

    structdefaultproperties
    {
        FamilyInfoPath=""
        PackageName=""
        IconPath=""
        SkinCategory=ESkinCategory.SKIN_Normal
        DLCIndex=0
        UnlockLevel=0
        bVisibleInMenu=false
        bAvailableInSurvival=false
    }
};

var array< class<AdvFamilyInfoBase> > LoadedClasses;
var array<string> PendingClasses;
var string SkinCategory[ESkinCategory];
var array<FamilyInfoToPackageName> FamilyInfosToPackages;
//var delegate<LoadComplete> __LoadComplete__Delegate;

// Export UAdvCharacterStore::execLoadFamilyInfoClass(FFrame&, void* const)
native final function LoadFamilyInfoClass(string ClassPath);

delegate LoadComplete(class<AdvFamilyInfoBase> LoadedClass)
{
    //return;    
}

static function int FindSkinIndexForGivenSkinName(string skinName)
{
    local int SkinIndex, I;

    SkinIndex = -1;
    I = 0;
    J0x1A:

    // End:0x8A [Loop If]
    if(I < default.FamilyInfosToPackages.Length)
    {
        // End:0x7C
        if(default.FamilyInfosToPackages[I].FamilyInfoPath ~= skinName)
        {
            SkinIndex = I;
            // [Explicit Break]
            goto J0x8A;
        }
        I++;
        // [Loop Continue]
        goto J0x1A;
    }
    J0x8A:

    return SkinIndex;
    //return ReturnValue;    
}

defaultproperties
{
    SkinCategory[0]="Skin_Normal"
    SkinCategory[1]="Skin_Arctic"
    SkinCategory[2]="Skin_Tropic"
    SkinCategory[3]="Skin_Special"
    FamilyInfosToPackages[0]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_ArmageddonMummy",PackageName="ch_mp_mummy_01_01",IconPath="UI_AdvCommon.Textures.Blank",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=0,UnlockLevel=1,bVisibleInMenu=false,bAvailableInSurvival=false)
    FamilyInfosToPackages[1]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Conquistador_01",PackageName="ch_mp_conquistador_01_01",IconPath="ui_advmultiplayer.sk_ch_conquistador_01_01",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=666,UnlockLevel=1,bVisibleInMenu=false,bAvailableInSurvival=false)
    FamilyInfosToPackages[2]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Devastator",PackageName="ch_mp_devastator_01_01",IconPath="UI_AdvCommon.Textures.Blank",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=0,UnlockLevel=1,bVisibleInMenu=false,bAvailableInSurvival=false)
    FamilyInfosToPackages[3]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Devastator_01",PackageName="ch_mp_devastator_01_01",IconPath="UI_AdvCommon.Textures.Blank",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=0,UnlockLevel=1,bVisibleInMenu=false,bAvailableInSurvival=false)
    FamilyInfosToPackages[4]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Hagen_01",PackageName="ch_mp_Hagen_01_01",IconPath="ui_advmultiplayer.sk_ch_Hagen_01_01",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=0,UnlockLevel=1,bVisibleInMenu=true,bAvailableInSurvival=true)
    FamilyInfosToPackages[5]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Hagen_02",PackageName="ch_mp_Hagen_02_01",IconPath="ui_advmultiplayer.sk_ch_Hagen_02_01",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=666,UnlockLevel=1,bVisibleInMenu=false,bAvailableInSurvival=true)
    FamilyInfosToPackages[6]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Hagen_03",PackageName="ch_mp_Hagen_03_01",IconPath="ui_advmultiplayer.sk_ch_Hagen_03_01",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=0,UnlockLevel=32,bVisibleInMenu=true,bAvailableInSurvival=true)
    FamilyInfosToPackages[7]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Jacobs_01",PackageName="ch_mp_jacobs_01_01",IconPath="ui_advmultiplayer.sk_ch_jacobs_01_01",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=0,UnlockLevel=3,bVisibleInMenu=true,bAvailableInSurvival=true)
    FamilyInfosToPackages[8]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Jennifer_01",PackageName="ch_mp_Jennifer_01_01",IconPath="ui_advmultiplayer.sk_ch_Jennifer_01_02",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=0,UnlockLevel=1,bVisibleInMenu=true,bAvailableInSurvival=true)
    FamilyInfosToPackages[9]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Jennifer_02",PackageName="ch_mp_Jennifer_02_01",IconPath="ui_advmultiplayer.sk_ch_Jennifer_02_01",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=666,UnlockLevel=1,bVisibleInMenu=false,bAvailableInSurvival=true)
    FamilyInfosToPackages[10]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Jennifer_03",PackageName="ch_mp_Jennifer_01_02",IconPath="ui_advmultiplayer.sk_ch_Jennifer_01_01",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=0,UnlockLevel=22,bVisibleInMenu=true,bAvailableInSurvival=true)
    FamilyInfosToPackages[11]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Jungle_01",PackageName="ch_mp_jungle_01_01",IconPath="ui_advmultiplayer.sk_ch_jungle_01_01",SkinCategory=ESkinCategory.SKIN_Tropic,DLCIndex=0,UnlockLevel=1,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[12]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Jungle_02",PackageName="ch_mp_jungle_02_01",IconPath="ui_advmultiplayer.sk_ch_jungle_02_01",SkinCategory=ESkinCategory.SKIN_Tropic,DLCIndex=0,UnlockLevel=1,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[13]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Jungle_03",PackageName="ch_mp_jungle_01_02",IconPath="ui_advmultiplayer.sk_ch_jungle_01_02",SkinCategory=ESkinCategory.SKIN_Tropic,DLCIndex=0,UnlockLevel=1,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[14]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Jungle_04",PackageName="ch_mp_jungle_02_02",IconPath="ui_advmultiplayer.sk_ch_jungle_02_02",SkinCategory=ESkinCategory.SKIN_Tropic,DLCIndex=0,UnlockLevel=19,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[15]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Koshkin_01",PackageName="ch_mp_Koshkin_01_01",IconPath="ui_advmultiplayer.sk_ch_Koshkin_01_01",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=666,UnlockLevel=1,bVisibleInMenu=false,bAvailableInSurvival=true)
    FamilyInfosToPackages[16]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Koshkin_02",PackageName="ch_mp_Koshkin_02_01",IconPath="ui_advmultiplayer.sk_ch_Koshkin_02_01",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=0,UnlockLevel=26,bVisibleInMenu=true,bAvailableInSurvival=true)
    FamilyInfosToPackages[17]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Kriegsmarine_01",PackageName="ch_mp_kriegsmarine_01_01",IconPath="ui_advmultiplayer.sk_ch_kriegsmarine_01_01",SkinCategory=ESkinCategory.SKIN_Normal,DLCIndex=666,UnlockLevel=1,bVisibleInMenu=false,bAvailableInSurvival=false)
    FamilyInfosToPackages[18]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Mercenary_01",PackageName="ch_mp_Mercenary_01_01",IconPath="ui_advmultiplayer.sk_ch_Mercenary_01_01",SkinCategory=ESkinCategory.SKIN_Tropic,DLCIndex=10,UnlockLevel=1,bVisibleInMenu=false,bAvailableInSurvival=true)
    FamilyInfosToPackages[19]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Mercenary_02",PackageName="ch_mp_Mercenary_01_02",IconPath="ui_advmultiplayer.sk_ch_Mercenary_01_02",SkinCategory=ESkinCategory.SKIN_Tropic,DLCIndex=0,UnlockLevel=1,bVisibleInMenu=false,bAvailableInSurvival=false)
    FamilyInfosToPackages[20]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Mercenary_03",PackageName="ch_mp_Mercenary_02_01",IconPath="ui_advmultiplayer.sk_ch_Mercenary_02_01",SkinCategory=ESkinCategory.SKIN_Tropic,DLCIndex=10,UnlockLevel=1,bVisibleInMenu=false,bAvailableInSurvival=true)
    FamilyInfosToPackages[21]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Mummy",PackageName="ch_mp_mummy_01_01",IconPath="UI_AdvCommon.Textures.Blank",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=0,UnlockLevel=1,bVisibleInMenu=false,bAvailableInSurvival=false)
    FamilyInfosToPackages[22]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Mummy_02",PackageName="ch_mp_mummy_02_01",IconPath="ui_advmultiplayer.sk_ch_multiplayer_mummy_02_01",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=0,UnlockLevel=1,bVisibleInMenu=false,bAvailableInSurvival=false)
    FamilyInfosToPackages[23]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Nazi_01",PackageName="ch_mp_afrika_korps_01_01",IconPath="ui_advmultiplayer.sk_ch_afrika_korps_01_01",SkinCategory=ESkinCategory.SKIN_Normal,DLCIndex=0,UnlockLevel=1,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[24]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Nazi_02",PackageName="ch_mp_afrika_korps_02_01",IconPath="ui_advmultiplayer.sk_ch_afrika_korps_02_01",SkinCategory=ESkinCategory.SKIN_Normal,DLCIndex=0,UnlockLevel=21,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[25]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Nazi_03",PackageName="ch_mp_afrika_korps_03_01",IconPath="ui_advmultiplayer.sk_ch_afrika_korps_03_01",SkinCategory=ESkinCategory.SKIN_Normal,DLCIndex=0,UnlockLevel=4,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[26]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Nazi_05",PackageName="ch_mp_afrika_korps_05_01",IconPath="ui_advmultiplayer.sk_ch_afrrika_korps_05_01",SkinCategory=ESkinCategory.SKIN_Normal,DLCIndex=0,UnlockLevel=31,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[27]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Nazi_06",PackageName="ch_mp_afrika_korps_06_01",IconPath="ui_advmultiplayer.sk_ch_afrrika_korps_06_01",SkinCategory=ESkinCategory.SKIN_Normal,DLCIndex=0,UnlockLevel=14,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[28]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Nazi_07",PackageName="ch_mp_afrika_korps_07_01",IconPath="ui_advmultiplayer.sk_ch_afrika_korps_07_01",SkinCategory=ESkinCategory.SKIN_Normal,DLCIndex=0,UnlockLevel=1,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[29]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_NaziArctic_01",PackageName="ch_mp_arctic_SS_01_01",IconPath="ui_advmultiplayer.sk_ch_arctic_SS_01_01",SkinCategory=ESkinCategory.SKIN_Arctic,DLCIndex=0,UnlockLevel=1,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[30]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_NaziArctic_02",PackageName="ch_mp_arctic_SS_02_01",IconPath="ui_advmultiplayer.sk_ch_arctic_SS_02_01",SkinCategory=ESkinCategory.SKIN_Arctic,DLCIndex=0,UnlockLevel=28,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[31]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_NaziArctic_03",PackageName="ch_mp_arctic_SS_03_01",IconPath="ui_advmultiplayer.sk_ch_arctic_SS_03_01",SkinCategory=ESkinCategory.SKIN_Arctic,DLCIndex=0,UnlockLevel=9,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[32]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_NKVD_01",PackageName="ch_mp_nkvd_01_01",IconPath="ui_advmultiplayer.sk_ch_nkvd_01_01",SkinCategory=ESkinCategory.SKIN_Normal,DLCIndex=0,UnlockLevel=12,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[33]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_NKVD_02",PackageName="ch_mp_nkvd_02_01",IconPath="ui_advmultiplayer.sk_ch_nkvd_02_01",SkinCategory=ESkinCategory.SKIN_Normal,DLCIndex=0,UnlockLevel=1,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[34]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_NKVD_03",PackageName="ch_mp_nkvd_03_01",IconPath="ui_advmultiplayer.sk_ch_nkvd_03_01",SkinCategory=ESkinCategory.SKIN_Normal,DLCIndex=0,UnlockLevel=1,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[35]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_NKVD_04",PackageName="ch_mp_nkvd_04_01",IconPath="ui_advmultiplayer.sk_ch_nkvd_04_01",SkinCategory=ESkinCategory.SKIN_Normal,DLCIndex=0,UnlockLevel=29,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[36]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_NKVD_05",PackageName="ch_mp_nkvd_05_01",IconPath="ui_advmultiplayer.sk_ch_nkvd_05_01",SkinCategory=ESkinCategory.SKIN_Normal,DLCIndex=0,UnlockLevel=6,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[37]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_NKVD_06",PackageName="ch_mp_nkvd_06_01",IconPath="ui_advmultiplayer.sk_ch_nkvd_06_01",SkinCategory=ESkinCategory.SKIN_Normal,DLCIndex=0,UnlockLevel=24,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[38]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_NKVDArctic_01",PackageName="ch_mp_arctic_NKVD_01_01",IconPath="ui_advmultiplayer.sk_ch_arctic_NKVD_01_01",SkinCategory=ESkinCategory.SKIN_Arctic,DLCIndex=0,UnlockLevel=1,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[39]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_NKVDArctic_02",PackageName="ch_mp_arctic_NKVD_03_01",IconPath="ui_advmultiplayer.sk_ch_arctic_NKVD_03_01",SkinCategory=ESkinCategory.SKIN_Arctic,DLCIndex=0,UnlockLevel=1,bVisibleInMenu=true,bAvailableInSurvival=false)
    FamilyInfosToPackages[40]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_NKVDArctic_03",PackageName="ch_mp_arctic_NKVD_04_01",IconPath="ui_advmultiplayer.sk_ch_arctic_NKVD_04_01",SkinCategory=ESkinCategory.SKIN_Arctic,DLCIndex=0,UnlockLevel=33,bVisibleInMenu=true,bAvailableInSurvival=true)
    FamilyInfosToPackages[41]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Quatermine_01",PackageName="ch_mp_quatermine_01_01",IconPath="ui_advmultiplayer.sk_ch_quatermine_01_01",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=0,UnlockLevel=35,bVisibleInMenu=true,bAvailableInSurvival=true)
    FamilyInfosToPackages[42]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Quatermine_02",PackageName="ch_mp_quatermine_02_01",IconPath="ui_advmultiplayer.sk_ch_quatermine_02_01",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=666,UnlockLevel=1,bVisibleInMenu=false,bAvailableInSurvival=true)
    FamilyInfosToPackages[43]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Quatermine_03",PackageName="ch_mp_quatermine_03_01",IconPath="ui_advmultiplayer.sk_ch_quatermine_03_01",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=0,UnlockLevel=16,bVisibleInMenu=true,bAvailableInSurvival=true)
    FamilyInfosToPackages[44]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Skeleton_01",PackageName="ch_mp_skeleton_01_01",IconPath="ui_advmultiplayer.sk_ch_skeleton_01_01",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=10,UnlockLevel=1,bVisibleInMenu=false,bAvailableInSurvival=true)
    FamilyInfosToPackages[45]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Stein_01",PackageName="ch_mp_Stein_01_01",IconPath="ui_advmultiplayer.sk_ch_Stein_01_01",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=0,UnlockLevel=7,bVisibleInMenu=false,bAvailableInSurvival=true)
    FamilyInfosToPackages[46]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Stein_02",PackageName="ch_mp_Stein_02_01",IconPath="ui_advmultiplayer.sk_ch_Stein_02_01",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=666,UnlockLevel=1,bVisibleInMenu=false,bAvailableInSurvival=true)
    FamilyInfosToPackages[47]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Werewolf_01",PackageName="ch_mp_Werwolf_01_01",IconPath="ui_advmultiplayer.sk_ch_Werwolf_01_01",SkinCategory=ESkinCategory.SKIN_Special,DLCIndex=0,UnlockLevel=11,bVisibleInMenu=true,bAvailableInSurvival=true)
    FamilyInfosToPackages[48]=(FamilyInfoPath="AdvGameContent.AdvFamilyInfo_MP_Worker_01",PackageName="ch_mp_worker_01_01",IconPath="ui_advmultiplayer.sk_ch_worker_01_01",SkinCategory=ESkinCategory.SKIN_Tropic,DLCIndex=0,UnlockLevel=18,bVisibleInMenu=true,bAvailableInSurvival=false)
}