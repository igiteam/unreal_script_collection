class CustomScenarioCreatorData extends Core.Object
    config(CustomScenarioCreator);

var config string                       ScenariosPath;  //the relative path, from the executable directory, to the directory containing ScenarioPacks
var config string                       PackExtension;   //filename extension for ScenarioPack files.

var config array<name>                  AvailableObjective;
var config array<string>                AvailableObjectiveClass;

var config localized array<string>      PredefinedRedOneLoadOut;
var config localized array<string>      PredefinedRedTwoLoadOut;
var config localized array<string>      PredefinedBlueOneLoadOut;
var config localized array<string>      PredefinedBlueTwoLoadOut;

struct ArchetypePresentation
{
    var config name                     Archetype;
    var config bool                     ByDefault;  //should this Archetype be "selected" by default
};
var config array<ArchetypePresentation> HostageArchetype;
var config array<ArchetypePresentation> EnemyArchetype;

var config array<name>                  PrimaryWeaponCategory;
var config localized array<string>      PrimaryWeaponCategoryDescription;
var config array<name>                  BackupWeaponCategory;
var config localized array<string>      BackupWeaponCategoryDescription;

struct WeaponPresentation
{
    var config name                     Category;
    var config string                   Weapon;     //the path name of the weapon class, ripe for DLO'ing
};
var config array<WeaponPresentation>    PrimaryWeapon;
var config array<WeaponPresentation>    BackupWeapon;

var config localized string             AnyString;      //the localized word "Any"
var config localized string             AnyLoadoutString;      //the localized words "Any Loadout"
var config localized string             NoneString;     //the localized word "None"
var config localized string             CopyOfString;   //the localized words "Copy of"
var config localized string             NewScenarioString;   //the localized words "New Scenario"
var config localized string             DefaultPackString;   //the localized word "Default"
var config localized string             UnavailableString;  //the localized string "[ Unavailable ]"
var config localized string             LowString;  //the localized word "Low"
var config localized string             MediumString;  //the localized word "Medium"
var config localized string             HighString;  //the localized word "High"
var config localized string             EasyString;  //the localized word "Easy"
var config localized string             NormalString;  //the localized word "Normal"
var config localized string             HardString;  //the localized word "Hard"
var config localized string             EliteString;  //the localized word "Elite"
var config localized string             NumberOfHostagesString; //The localized words "Number of hostages"
var config localized string             NumberOfEnemiesString;  //The localized words "Number of enemies"
var config localized string             CommaIncludingString;   //The localized string ", including"
var config localized string             CampaignObjectivesString;   //The localized localized words "Campaign Objectives" for the end of a sentence

var config float                        DefaultTimeLimit;

var private SwatGUIConfig               GC;
var private bool                        bCurrentMissionDirty;

var array<CustomScenarioCreatorMissionSpecificData> MissionData;

function bool IsCurrentMisisonDirty()
{
    return bCurrentMissionDirty;
}

function SetCurrentMissionDirty()
{
    bCurrentMissionDirty = true;
}

function ClearCurrentMissionDirty()
{
    bCurrentMissionDirty = false;
}


function Init(SwatGUIConfig inGC)
{
    local int i;

    GC = inGC;
    assert(GC != None);

    for (i=0; i<GC.MissionName.length; ++i)
    {
        MissionData[i] = new (None, string(GC.MissionName[i])) class'CustomScenarioCreatorMissionSpecificData';
        assert(MissionData[i] != None);
    }
}

//TMC TODO optimize this by using a hashmap
function CustomScenarioCreatorMissionSpecificData GetMissionData_Slow(name inMission)
{
    local int i;

    for (i=0; i<GC.MissionName.length; ++i)
    {
        if (GC.MissionName[i] == inMission)
        {
            assert(MissionData.length > i);     //it should have been initialized in construct()
            return MissionData[i];
        }
    }

    assertWithDescription(false,
        "[tcohen] CustomScenarioCreatorData::GetMissionData_Slow() the specified Mission named "$inMission
        $" was not found.");
}

// Decompiled with UE Explorer.
defaultproperties
{
    ScenariosPath="..\\..\\Content\\Scenarios\\"
    PackExtension="pak"
    PredefinedRedOneLoadOut[0]="Assaulter_JHP"
    PredefinedRedOneLoadOut[1]="Assaulter_FMJ"
    PredefinedRedOneLoadOut[2]="CQB_Specialist"
    PredefinedRedOneLoadOut[3]="Breacher"
    PredefinedRedOneLoadOut[4]="Scout"
    PredefinedRedOneLoadOut[5]="Pacifier"
    PredefinedRedOneLoadOut[6]="LessLethal"
    PredefinedRedTwoLoadOut[0]="Assaulter_JHP"
    PredefinedRedTwoLoadOut[1]="Assaulter_FMJ"
    PredefinedRedTwoLoadOut[2]="CQB_Specialist"
    PredefinedRedTwoLoadOut[3]="Breacher"
    PredefinedRedTwoLoadOut[4]="Scout"
    PredefinedRedTwoLoadOut[5]="Pacifier"
    PredefinedRedTwoLoadOut[6]="LessLethal"
    PredefinedBlueOneLoadOut[0]="Assaulter_JHP"
    PredefinedBlueOneLoadOut[1]="Assaulter_FMJ"
    PredefinedBlueOneLoadOut[2]="CQB_Specialist"
    PredefinedBlueOneLoadOut[3]="Breacher"
    PredefinedBlueOneLoadOut[4]="Scout"
    PredefinedBlueOneLoadOut[5]="Pacifier"
    PredefinedBlueOneLoadOut[6]="LessLethal"
    PredefinedBlueTwoLoadOut[0]="Assaulter_JHP"
    PredefinedBlueTwoLoadOut[1]="Assaulter_FMJ"
    PredefinedBlueTwoLoadOut[2]="CQB_Specialist"
    PredefinedBlueTwoLoadOut[3]="Breacher"
    PredefinedBlueTwoLoadOut[4]="Scout"
    PredefinedBlueTwoLoadOut[5]="Pacifier"
    PredefinedBlueTwoLoadOut[6]="LessLethal"
    HostageArchetype[0]=(Archetype="Custom_Terrorists",ByDefault=false)
    HostageArchetype[1]=(Archetype="Custom_TerroristsWithBodyArmor",ByDefault=false)
    HostageArchetype[2]=(Archetype="Custom_MaleCasual_BodyArmor",ByDefault=false)
    HostageArchetype[3]=(Archetype="Custom_GangMembers",ByDefault=false)
    HostageArchetype[4]=(Archetype="Custom_FatGuy",ByDefault=false)
    HostageArchetype[5]=(Archetype="Custom_MaleSuit1",ByDefault=false)
    HostageArchetype[6]=(Archetype="Custom_MaleSuit2",ByDefault=false)
    HostageArchetype[7]=(Archetype="Custom_MaleCasual1",ByDefault=false)
    HostageArchetype[8]=(Archetype="Custom_MaleCasual2",ByDefault=false)
    HostageArchetype[9]=(Archetype="Custom_MaleCasual3",ByDefault=false)
    HostageArchetype[10]=(Archetype="Custom_MaleCasual4",ByDefault=false)
    HostageArchetype[11]=(Archetype="Custom_LeoMel",ByDefault=false)
    HostageArchetype[12]=(Archetype="Custom_MaleCasual_Beefy",ByDefault=false)
    HostageArchetype[13]=(Archetype="Custom_Doctor",ByDefault=false)
    HostageArchetype[14]=(Archetype="Custom_Janitor",ByDefault=false)
    HostageArchetype[15]=(Archetype="Custom_Homeless_Male",ByDefault=false)
    HostageArchetype[16]=(Archetype="Custom_PoliceCadet",ByDefault=false)
    HostageArchetype[17]=(Archetype="Custom_FemaleCasual1",ByDefault=true)
    HostageArchetype[18]=(Archetype="Custom_FemaleCasual2",ByDefault=false)
    HostageArchetype[19]=(Archetype="Custom_FemaleCasual3",ByDefault=false)
    HostageArchetype[20]=(Archetype="Custom_FemaleOffice",ByDefault=false)
    HostageArchetype[21]=(Archetype="Custom_Female_Heavy",ByDefault=false)
    HostageArchetype[22]=(Archetype="Custom_Nurse",ByDefault=false)
    HostageArchetype[23]=(Archetype="Custom_Female_Homeless",ByDefault=false)
    HostageArchetype[24]=(Archetype="Silence_Mother",ByDefault=false)
    HostageArchetype[25]=(Archetype="RedLibrary_Rooney",ByDefault=false)
    HostageArchetype[26]=(Archetype="Hotel_Adams",ByDefault=false)
    HostageArchetype[27]=(Archetype="Hotel_Bettencourt",ByDefault=false)
    HostageArchetype[28]=(Archetype="Hospital_Diplomat",ByDefault=false)
    HostageArchetype[29]=(Archetype="DNA_Sterling",ByDefault=false)
    HostageArchetype[30]=(Archetype="Silence_Victim1",ByDefault=false)
    HostageArchetype[31]=(Archetype="Training_SWATInstructor",ByDefault=false)
    EnemyArchetype[0]=(Archetype="Custom_Terrorists",ByDefault=false)
    EnemyArchetype[1]=(Archetype="Custom_TerroristsWithBodyArmor",ByDefault=false)
    EnemyArchetype[2]=(Archetype="Custom_Terrorist_GasMask",ByDefault=false)
    EnemyArchetype[3]=(Archetype="Custom_Terrorist_HockeyMask",ByDefault=false)
    EnemyArchetype[4]=(Archetype="Custom_MaleCasual_BodyArmor",ByDefault=false)
    EnemyArchetype[5]=(Archetype="Custom_GangMembers",ByDefault=true)
    EnemyArchetype[6]=(Archetype="Custom_FatGuy",ByDefault=false)
    EnemyArchetype[7]=(Archetype="Custom_MaleSuit1",ByDefault=false)
    EnemyArchetype[8]=(Archetype="Custom_MaleSuit2",ByDefault=false)
    EnemyArchetype[9]=(Archetype="Custom_MaleCasual1",ByDefault=false)
    EnemyArchetype[10]=(Archetype="Custom_MaleCasual2",ByDefault=false)
    EnemyArchetype[11]=(Archetype="Custom_MaleCasual3",ByDefault=false)
    EnemyArchetype[12]=(Archetype="Custom_MaleCasual4",ByDefault=false)
    EnemyArchetype[13]=(Archetype="Custom_LeoMel",ByDefault=false)
    EnemyArchetype[14]=(Archetype="Custom_MaleCasual_Beefy",ByDefault=false)
    EnemyArchetype[15]=(Archetype="Custom_Doctor",ByDefault=false)
    EnemyArchetype[16]=(Archetype="Custom_Janitor",ByDefault=false)
    EnemyArchetype[17]=(Archetype="Custom_Homeless_Male",ByDefault=false)
    EnemyArchetype[18]=(Archetype="Custom_PoliceCadet",ByDefault=false)
    EnemyArchetype[19]=(Archetype="Custom_FemaleCasual1",ByDefault=false)
    EnemyArchetype[20]=(Archetype="Custom_FemaleCasual2",ByDefault=false)
    EnemyArchetype[21]=(Archetype="Custom_FemaleCasual3",ByDefault=false)
    EnemyArchetype[22]=(Archetype="Custom_FemaleOffice",ByDefault=false)
    EnemyArchetype[23]=(Archetype="Custom_Female_Heavy",ByDefault=false)
    EnemyArchetype[24]=(Archetype="Custom_Nurse",ByDefault=false)
    EnemyArchetype[25]=(Archetype="Custom_Female_Homeless",ByDefault=false)
    EnemyArchetype[26]=(Archetype="Custom_Training_SWATInstructor",ByDefault=false)
    EnemyArchetype[27]=(Archetype="FoodWall_Jimenez",ByDefault=false)
    EnemyArchetype[28]=(Archetype="Silence_Killer",ByDefault=false)
    EnemyArchetype[29]=(Archetype="Conv_Alice_Jenkins",ByDefault=false)
    EnemyArchetype[30]=(Archetype="Tenement_Cult_Leader",ByDefault=false)
    EnemyArchetype[31]=(Archetype="DNA_Terror_Leader",ByDefault=false)
    EnemyArchetype[32]=(Archetype="Custom_MelindaKline",ByDefault=false)
    PrimaryWeaponCategory[0]="MachineGun"
    PrimaryWeaponCategory[1]="SubMachineGun"
    PrimaryWeaponCategory[2]="Shotgun"
    PrimaryWeaponCategory[3]="Handgun"
    PrimaryWeaponCategoryDescription[0]="Machineguns"
    PrimaryWeaponCategoryDescription[1]="Submachineguns"
    PrimaryWeaponCategoryDescription[2]="Shotguns"
    PrimaryWeaponCategoryDescription[3]="Handguns"
    BackupWeaponCategory[0]="MachineGun"
    BackupWeaponCategory[1]="SubMachineGun"
    BackupWeaponCategory[2]="Shotgun"
    BackupWeaponCategory[3]="Handgun"
    BackupWeaponCategoryDescription[0]="Machineguns"
    BackupWeaponCategoryDescription[1]="Submachineguns"
    BackupWeaponCategoryDescription[2]="Shotguns"
    BackupWeaponCategoryDescription[3]="Handguns"
    PrimaryWeapon[0]=(category="Handgun",Weapon="SwatEquipment.ColtM1911HG")
    PrimaryWeapon[1]=(category="Handgun",Weapon="SwatEquipment.BerettaM9HG")
    PrimaryWeapon[2]=(category="Handgun",Weapon="SwatEquipment.ScorpionHG")
    PrimaryWeapon[3]=(category="Handgun",Weapon="SwatEquipment.USP40HG")
    PrimaryWeapon[4]=(category="Handgun",Weapon="SwatEquipment.PythonRevolverHG")
    PrimaryWeapon[5]=(category="Handgun",Weapon="SwatEquipment.IngramHG")
    PrimaryWeapon[6]=(category="SubMachineGun",Weapon="SwatEquipment.BadguyMP5SMG")
    PrimaryWeapon[7]=(category="SubMachineGun",Weapon="SwatEquipment.BadguySilencedMP5SMG")
    PrimaryWeapon[8]=(category="SubMachineGun",Weapon="SwatEquipment.HK53SMG")
    PrimaryWeapon[9]=(category="SubMachineGun",Weapon="SwatEquipment.UMP45SMG")
    PrimaryWeapon[10]=(category="SubMachineGun",Weapon="SwatEquipment.UZISMG")
    PrimaryWeapon[11]=(category="MachineGun",Weapon="SwatEquipment.AK47MG")
    PrimaryWeapon[12]=(category="MachineGun",Weapon="SwatEquipment.AK74MG")
    PrimaryWeapon[13]=(category="MachineGun",Weapon="SwatEquipment.AK74suMG")
    PrimaryWeapon[14]=(category="MachineGun",Weapon="SwatEquipment.G36KMG")
    PrimaryWeapon[15]=(category="MachineGun",Weapon="SwatEquipment.M4MG")
    PrimaryWeapon[16]=(category="Shotgun",Weapon="SwatEquipment.BadguyM4Super90SG")
    PrimaryWeapon[17]=(category="Shotgun",Weapon="SwatEquipment.M1Super90SG")
    PrimaryWeapon[18]=(category="Shotgun",Weapon="SwatEquipment.Pump1SG")
    PrimaryWeapon[19]=(category="Shotgun",Weapon="SwatEquipment.Pump2RifleGripSG")
    PrimaryWeapon[20]=(category="Shotgun",Weapon="SwatEquipment.SawedOffSG")
    BackupWeapon[0]=(category="Handgun",Weapon="SwatEquipment.ColtM1911HG")
    BackupWeapon[1]=(category="Handgun",Weapon="SwatEquipment.BerettaM9HG")
    BackupWeapon[2]=(category="Handgun",Weapon="SwatEquipment.ScorpionHG")
    BackupWeapon[3]=(category="Handgun",Weapon="SwatEquipment.USP40HG")
    BackupWeapon[4]=(category="Handgun",Weapon="SwatEquipment.PythonRevolverHG")
    BackupWeapon[5]=(category="Handgun",Weapon="SwatEquipment.IngramHG")
    BackupWeapon[6]=(category="SubMachineGun",Weapon="SwatEquipment.BadguyMP5SMG")
    BackupWeapon[7]=(category="SubMachineGun",Weapon="SwatEquipment.BadguySilencedMP5SMG")
    BackupWeapon[8]=(category="SubMachineGun",Weapon="SwatEquipment.HK53SMG")
    BackupWeapon[9]=(category="SubMachineGun",Weapon="SwatEquipment.UMP45SMG")
    BackupWeapon[10]=(category="SubMachineGun",Weapon="SwatEquipment.UZISMG")
    BackupWeapon[11]=(category="MachineGun",Weapon="SwatEquipment.AK47MG")
    BackupWeapon[12]=(category="MachineGun",Weapon="SwatEquipment.AK74MG")
    BackupWeapon[13]=(category="MachineGun",Weapon="SwatEquipment.AK74suMG")
    BackupWeapon[14]=(category="MachineGun",Weapon="SwatEquipment.G36KMG")
    BackupWeapon[15]=(category="MachineGun",Weapon="SwatEquipment.M4MG")
    BackupWeapon[16]=(category="Shotgun",Weapon="SwatEquipment.BadguyM4Super90SG")
    BackupWeapon[17]=(category="Shotgun",Weapon="SwatEquipment.M1Super90SG")
    BackupWeapon[18]=(category="Shotgun",Weapon="SwatEquipment.Pump1SG")
    BackupWeapon[19]=(category="Shotgun",Weapon="SwatEquipment.Pump2RifleGripSG")
    BackupWeapon[20]=(category="Shotgun",Weapon="SwatEquipment.SawedOffSG")
    AnyString="Any"
    AnyLoadoutString="Any Loadout"
    NoneString="None"
    CopyOfString="Copy of"
    NewScenarioString="New Scenario"
    DefaultPackString="Default"
    UnavailableString="[ Unavailable ]"
    LowString="Low"
    MediumString="Medium"
    HighString="High"
    EasyString="Easy"
    NormalString="Normal"
    HardString="Hard"
    EliteString="Elite"
    NumberOfHostagesString="NUMBER OF HOSTAGES"
    NumberOfEnemiesString="NUMBER OF SUSPECTS"
    CommaIncludingString=", INCLUDING"
    CampaignObjectivesString="CAMPAIGN OBJECTIVES."
    DefaultTimeLimit=5.0000000
}