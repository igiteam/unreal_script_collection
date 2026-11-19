class UTCharInfo extends Object
    config(CharInfo);

struct CustomAIData
{
    var float Tactics;
    var float StrafingAbility;
    var float Accuracy;
    var float Aggressiveness;
    var float CombatStyle;
    var float Jumpiness;
    var float ReactionTime;
    var string FavoriteWeapon;

    structdefaultproperties
    {
        Tactics=0.0000000
        StrafingAbility=0.0000000
        Accuracy=0.0000000
        Aggressiveness=0.4000000
        CombatStyle=0.2000000
        Jumpiness=0.0000000
        ReactionTime=0.0000000
        FavoriteWeapon=""
    }
};

struct CharacterInfo
{
    var string CharID;
    var string FamilyID;
    var const localized string CharName;
    var const localized string Description;
    var string PreviewImageMarkup;
    var string Faction;
    var CustomAIData AIData;

    structdefaultproperties
    {
        CharID=""
        FamilyID=""
        CharName=""
        Description=""
        PreviewImageMarkup=""
        Faction=""
        AIData=(Tactics=0.0000000,StrafingAbility=0.0000000,Accuracy=0.0000000,Aggressiveness=0.4000000,CombatStyle=0.2000000,Jumpiness=0.0000000,ReactionTime=0.0000000,FavoriteWeapon="")
    }
};

var() config array<config CharacterInfo> Characters;
var() array< class<EvilFamilyInfoBase> > Families;
var() config float LOD1DisplayFactor;
var() config float LOD2DisplayFactor;
var() config float LOD3DisplayFactor;

static final function class<EvilFamilyInfoBase> FindFamilyInfo(string InFamilyID)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x96 [Loop If]
    if(I < default.Families.Length)
    {
        // End:0x88
        if((default.Families[I] != none) && default.Families[I].default.FamilyID == InFamilyID)
        {
            return default.Families[I];
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    return none;
    //return ReturnValue;    
}

static final function string GetRandomCharClassName()
{
    return "EvilGame." $ string(default.Families[Rand(default.Families.Length - 1)].Name);
    //return ReturnValue;    
}

defaultproperties
{
    Characters[0]=(CharID="A",FamilyID="LIAM",CharName="Matrix",Description="<Strings:UTGameUI.CharLocData.Matrix_Description>",PreviewImageMarkup="<Images:UI_Portrait.Character.UI_Portrait_Character_Liandri_Male_Head04>",Faction="Liandri",AIData=(Tactics=1.0000000,StrafingAbility=1.0000000,Accuracy=0.4000000,Aggressiveness=0.4000000,CombatStyle=0.2000000,Jumpiness=0.2500000,ReactionTime=0.0000000,FavoriteWeapon="UTGameContent.UTWeap_RocketLauncher_Content"))
    Characters[1]=(CharID="C",FamilyID="LIAM",CharName="Aspect",Description="<Strings:UTGameUI.CharLocData.Aspect_Description>",PreviewImageMarkup="<Images:UI_Portrait.Character.UI_Portrait_Character_Liandri_Male_Head02>",Faction="Liandri",AIData=(Tactics=0.0000000,StrafingAbility=0.0000000,Accuracy=0.0000000,Aggressiveness=0.4000000,CombatStyle=0.2000000,Jumpiness=0.0000000,ReactionTime=0.0000000,FavoriteWeapon=""))
    Characters[2]=(CharID="B",FamilyID="LIAM",CharName="Cathode",Description="<Strings:UTGameUI.CharLocData.Cathode_Description>",PreviewImageMarkup="<Images:UI_Portrait.Character.UI_Portrait_Character_Liandri_Male_Head01>",Faction="Liandri",AIData=(Tactics=0.0000000,StrafingAbility=0.0000000,Accuracy=0.0000000,Aggressiveness=0.4000000,CombatStyle=0.2000000,Jumpiness=0.0000000,ReactionTime=0.0000000,FavoriteWeapon=""))
    Characters[3]=(CharID="D",FamilyID="LIAM",CharName="Enigma",Description="<Strings:UTGameUI.CharLocData.Enigma_Description>",PreviewImageMarkup="<Images:UI_Portrait.Character.UI_Portrait_Character_Liandri_Male_Head03>",Faction="Liandri",AIData=(Tactics=0.0000000,StrafingAbility=0.0000000,Accuracy=0.0000000,Aggressiveness=0.4000000,CombatStyle=0.2000000,Jumpiness=0.0000000,ReactionTime=0.0000000,FavoriteWeapon=""))
    Characters[4]=(CharID="F",FamilyID="LIAM",CharName="Collossus",Description="<Strings:UTGameUI.CharLocData.Collossus_Description>",PreviewImageMarkup="<Images:UI_Portrait.Character.UI_Portrait_Character_Liandri_Male_Head02>",Faction="Liandri",AIData=(Tactics=0.0000000,StrafingAbility=0.0000000,Accuracy=0.0000000,Aggressiveness=0.4000000,CombatStyle=0.2000000,Jumpiness=0.0000000,ReactionTime=0.0000000,FavoriteWeapon=""))
    Characters[5]=(CharID="I",FamilyID="LIAM",CharName="Entropy",Description="<Strings:UTGameUI.CharLocData.Entropy_Description>",PreviewImageMarkup="<Images:UI_Portrait.Character.UI_Portrait_Character_Liandri_Male_Head01>",Faction="Liandri",AIData=(Tactics=0.0000000,StrafingAbility=0.0000000,Accuracy=0.0000000,Aggressiveness=0.5000000,CombatStyle=0.2000000,Jumpiness=0.0000000,ReactionTime=0.0000000,FavoriteWeapon="UTGame.UTWeap_LinkGun"))
    Characters[6]=(CharID="H",FamilyID="LIAM",CharName="Monarch",Description="<Strings:UTGameUI.CharLocData.Monarch_Description>",PreviewImageMarkup="<Images:UI_Portrait.Character.UI_Portrait_Character_Liandri_Male_Head04>",Faction="Liandri",AIData=(Tactics=0.0000000,StrafingAbility=0.0000000,Accuracy=0.0000000,Aggressiveness=0.4000000,CombatStyle=0.2000000,Jumpiness=0.0000000,ReactionTime=0.0000000,FavoriteWeapon=""))
    Characters[7]=(CharID="K",FamilyID="LIAM",CharName="OSC",Description="<Strings:UTGameUI.CharLocData.OSC_Description>",PreviewImageMarkup="<Images:UI_Portrait.Character.UI_Portrait_Character_Liandri_Male_Head03>",Faction="Liandri",AIData=(Tactics=0.0000000,StrafingAbility=0.0000000,Accuracy=0.0000000,Aggressiveness=0.4000000,CombatStyle=0.2000000,Jumpiness=0.0000000,ReactionTime=0.0000000,FavoriteWeapon=""))
    Characters[8]=(CharID="J",FamilyID="LIAM",CharName="Evolution",Description="<Strings:UTGameUI.CharLocData.Evolution_Description>",PreviewImageMarkup="<Images:UI_Portrait.Character.UI_Portrait_Character_Liandri_Male_Head02>",Faction="Liandri",AIData=(Tactics=0.0000000,StrafingAbility=0.0000000,Accuracy=0.0000000,Aggressiveness=0.4000000,CombatStyle=0.2000000,Jumpiness=0.0000000,ReactionTime=0.0000000,FavoriteWeapon=""))
    Characters[9]=(CharID="G",FamilyID="LIAM",CharName="Mihr",Description="<Strings:UTGameUI.CharLocData.Mihr_Description>",PreviewImageMarkup="<Images:UI_Portrait.Character.UI_Portrait_Character_Liandri_Male_Head03>",Faction="Liandri",AIData=(Tactics=0.0000000,StrafingAbility=0.0000000,Accuracy=0.0000000,Aggressiveness=0.4000000,CombatStyle=0.2000000,Jumpiness=0.0000000,ReactionTime=0.0000000,FavoriteWeapon=""))
    Characters[10]=(CharID="E",FamilyID="LIAM",CharName="Raptor",Description="<Strings:UTGameUI.CharLocData.Raptor_Description>",PreviewImageMarkup="<Images:UI_Portrait.Character.UI_Portrait_Character_Liandri_Male_Head01>",Faction="Liandri",AIData=(Tactics=0.0000000,StrafingAbility=0.0000000,Accuracy=0.0000000,Aggressiveness=0.7000000,CombatStyle=0.2000000,Jumpiness=0.0000000,ReactionTime=0.0000000,FavoriteWeapon="UTGameContent.UTWeap_Shockrifle"))
    Characters[11]=(CharID="L",FamilyID="LIAM",CharName="Syntax",Description="<Strings:UTGameUI.CharLocData.Syntax_Description>",PreviewImageMarkup="<Images:UI_Portrait.Character.UI_Portrait_Character_Liandri_Male_Head04>",Faction="Liandri",AIData=(Tactics=0.0000000,StrafingAbility=0.0000000,Accuracy=0.0000000,Aggressiveness=0.4000000,CombatStyle=0.2000000,Jumpiness=0.0000000,ReactionTime=0.0000000,FavoriteWeapon=""))
    Characters[12]=(CharID="M",FamilyID="LIAM",CharName="Torque",Description="<Strings:UTGameUI.CharLocData.Torque_Description>",PreviewImageMarkup="<Images:UI_Portrait.Character.UI_Portrait_Character_Liandri_Male_Head04>",Faction="Liandri",AIData=(Tactics=0.0000000,StrafingAbility=0.0000000,Accuracy=0.0000000,Aggressiveness=0.4000000,CombatStyle=0.2000000,Jumpiness=0.0000000,ReactionTime=0.0000000,FavoriteWeapon=""))
    LOD1DisplayFactor=0.4000000
    LOD2DisplayFactor=0.2000000
    LOD3DisplayFactor=0.0750000
}