class EvilFamilyInfoBase extends Object
    abstract;

var Texture DefaultHeadPortrait;
var array<Texture> DefaultTeamHeadPortrait;
var string FamilyID;
var string Faction;
var SkeletalMesh CharacterMesh;
var array<MaterialInterface> CharacterTeamBodyMaterials;
var array<MaterialInterface> CharacterTeamHeadMaterials;
var string ArmMeshPackageName;
var SkeletalMesh ArmMesh;
var string ArmSkinPackageName;
var MaterialInterface RedArmMaterial;
var MaterialInterface BlueArmMaterial;
var string NeckStumpName;
var Vector PortraitExtraOffset;
var PhysicsAsset PhysAsset;
var array<AnimSet> AnimSets;
var name LeftFootBone;
var name RightFootBone;
var array<name> TakeHitPhysicsFixedBones;
var class<EvilPawnSoundGroup_Base> SoundGroupClass;
var class<UTVoice> VoiceClass;
var MaterialInstanceConstant BaseMICParent;
var MaterialInstanceConstant BioDeathMICParent;
var MaterialInstance BloodSplatterDecalMaterial;
var LinearColor NonTeamEmissiveColor;
var LinearColor NonTeamTintColor;
var array<EmoteInfo> FamilyEmotes;
var array<GibInfo> Gibs;
var GibInfo HeadGib;
var SkeletalMesh DeathMeshSkelMesh;
var PhysicsAsset DeathMeshPhysAsset;
var int DeathMeshNumMaterialsToSetResident;
var array<name> DeathMeshBreakableJoints;
var array<MaterialInstanceTimeVarying> SkeletonBurnOutMaterials;
var ParticleSystem HeadShotEffect;
var name HeadShotGoreSocketName;
var StaticMesh HeadShotNeckGoreAttachment;
var class<UTEmit_HitEffect> BloodEmitterClass;
var array<DistanceBasedParticleTemplate> BloodEffects;
var ParticleSystem GibExplosionTemplate;
var float DrivingDrawScale;
var bool bIsFemale;
var float DefaultMeshScale;
var float BaseTranslationOffset;

static function SkeletalMesh GetFirstPersonArms()
{
    // End:0x0F
    if(default.ArmMesh == none)
    {
    }
    return default.ArmMesh;
    //return ReturnValue;    
}

static function MaterialInterface GetFirstPersonArmsMaterial(int TeamNum)
{
    local MaterialInterface ArmMaterial;

    // End:0x80
    if((TeamNum == 0) || TeamNum == 1)
    {
        // End:0x45
        if(TeamNum == 0)
        {
            ArmMaterial = default.RedArmMaterial;            
        }
        else
        {
            // End:0x67
            if(TeamNum == 1)
            {
                ArmMaterial = default.BlueArmMaterial;
            }
        }
        // End:0x76
        if(ArmMaterial == none)
        {
        }
        return ArmMaterial;
    }
    return GetFirstPersonArms().Materials[0];
    //return ReturnValue;    
}

static function GetTeamMaterials(int TeamNum, out MaterialInterface TeamMaterialHead, out MaterialInterface TeamMaterialBody)
{
    TeamMaterialHead = ((TeamNum < default.CharacterTeamHeadMaterials.Length) ? default.CharacterTeamHeadMaterials[TeamNum] : default.CharacterMesh.Materials[0]);
    TeamMaterialBody = ((TeamNum < default.CharacterTeamBodyMaterials.Length) ? default.CharacterTeamBodyMaterials[TeamNum] : default.CharacterMesh.Materials[1]);
    //return;    
}

static function Texture GetCharPortrait(int TeamNum)
{
    return ((TeamNum < default.DefaultTeamHeadPortrait.Length) ? default.DefaultTeamHeadPortrait[TeamNum] : default.DefaultHeadPortrait);
    //return ReturnValue;    
}

static function int GetEmoteGroupCnt(name Category)
{
    local int I, Cnt;

    I = 0;
    J0x0B:

    // End:0x70 [Loop If]
    if(I < default.FamilyEmotes.Length)
    {
        // End:0x62
        if(default.FamilyEmotes[I].CategoryName == Category)
        {
            Cnt++;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    return Cnt;
    //return ReturnValue;    
}

static function class<UTVoice> GetVoiceClass()
{
    return default.VoiceClass;
    //return ReturnValue;    
}

static function GetEmotes(name Category, out array<string> Captions, out array<name> EmoteTags)
{
    local int I, Cnt;

    I = 0;
    J0x0B:

    // End:0xE4 [Loop If]
    if(I < default.FamilyEmotes.Length)
    {
        // End:0xD6
        if(default.FamilyEmotes[I].CategoryName == Category)
        {
            Captions[Cnt] = default.FamilyEmotes[I].EmoteName;
            EmoteTags[Cnt] = default.FamilyEmotes[I].EmoteTag;
            Cnt++;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

static function int GetEmoteIndex(name EmoteTag)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x6F [Loop If]
    if(I < default.FamilyEmotes.Length)
    {
        // End:0x61
        if(default.FamilyEmotes[I].EmoteTag == EmoteTag)
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    return -1;
    //return ReturnValue;    
}

defaultproperties
{
    LeftFootBone="b_LeftAnkle"
    RightFootBone="b_RightAnkle"
    TakeHitPhysicsFixedBones[0]="b_LeftAnkle"
    TakeHitPhysicsFixedBones[1]="b_RightAnkle"
    SoundGroupClass=Class'EvilPawnSoundGroup_Base'
    BloodSplatterDecalMaterial=MaterialInstanceTimeVarying'ps_Blood.Decals.m_ps_BloodDecal_Ver1'
    NonTeamEmissiveColor=(R=10.0000000,G=0.2000000,B=0.2000000,A=1.0000000)
    NonTeamTintColor=(R=4.0000000,G=2.0000000,B=0.5000000,A=1.0000000)
    FamilyEmotes[0]=(CategoryName="Taunt",EmoteTag="TauntA",EmoteName="",EmoteAnim="Taunt_FB_BringItOn",bVictoryEmote=false,bTopHalfEmote=false,Command="None",bRequiresPlayer=false)
    FamilyEmotes[1]=(CategoryName="Taunt",EmoteTag="TauntB",EmoteName="",EmoteAnim="Taunt_FB_Hoolahoop",bVictoryEmote=false,bTopHalfEmote=false,Command="None",bRequiresPlayer=false)
    FamilyEmotes[2]=(CategoryName="Taunt",EmoteTag="TauntC",EmoteName="",EmoteAnim="Taunt_FB_Pelvic_Thrust_A",bVictoryEmote=false,bTopHalfEmote=false,Command="None",bRequiresPlayer=false)
    FamilyEmotes[3]=(CategoryName="Taunt",EmoteTag="TauntD",EmoteName="",EmoteAnim="Taunt_UB_BulletToTheHead",bVictoryEmote=false,bTopHalfEmote=true,Command="None",bRequiresPlayer=false)
    FamilyEmotes[4]=(CategoryName="Taunt",EmoteTag="TauntE",EmoteName="",EmoteAnim="Taunt_UB_ComeHere",bVictoryEmote=false,bTopHalfEmote=true,Command="None",bRequiresPlayer=false)
    FamilyEmotes[5]=(CategoryName="Taunt",EmoteTag="TauntF",EmoteName="",EmoteAnim="Taunt_UB_Slit_Throat",bVictoryEmote=false,bTopHalfEmote=true,Command="None",bRequiresPlayer=false)
    FamilyEmotes[6]=(CategoryName="Order",EmoteTag="OrderA",EmoteName="",EmoteAnim="Taunt_UB_Flag_Pickup",bVictoryEmote=false,bTopHalfEmote=true,Command="Attack",bRequiresPlayer=true)
    FamilyEmotes[7]=(CategoryName="Order",EmoteTag="OrderB",EmoteName="",EmoteAnim="Taunt_UB_Flag_Pickup",bVictoryEmote=false,bTopHalfEmote=true,Command="Defend",bRequiresPlayer=true)
    FamilyEmotes[8]=(CategoryName="Order",EmoteTag="OrderC",EmoteName="",EmoteAnim="Taunt_UB_Flag_Pickup",bVictoryEmote=false,bTopHalfEmote=true,Command="Hold",bRequiresPlayer=true)
    FamilyEmotes[9]=(CategoryName="Order",EmoteTag="OrderD",EmoteName="",EmoteAnim="Taunt_UB_Flag_Pickup",bVictoryEmote=false,bTopHalfEmote=true,Command="Follow",bRequiresPlayer=true)
    FamilyEmotes[10]=(CategoryName="Order",EmoteTag="OrderE",EmoteName="",EmoteAnim="Taunt_UB_Flag_Pickup",bVictoryEmote=false,bTopHalfEmote=true,Command="Freelance",bRequiresPlayer=true)
    FamilyEmotes[11]=(CategoryName="Order",EmoteTag="OrderF",EmoteName="",EmoteAnim="Taunt_UB_Flag_Pickup",bVictoryEmote=false,bTopHalfEmote=true,Command="DropFlag",bRequiresPlayer=false)
    FamilyEmotes[12]=(CategoryName="Status",EmoteTag="ENCOURAGEMENT",EmoteName="",EmoteAnim="Taunt_UB_Flag_Pickup",bVictoryEmote=false,bTopHalfEmote=true,Command="None",bRequiresPlayer=false)
    FamilyEmotes[13]=(CategoryName="Status",EmoteTag="ACK",EmoteName="",EmoteAnim="Taunt_UB_Flag_Pickup",bVictoryEmote=false,bTopHalfEmote=true,Command="None",bRequiresPlayer=false)
    FamilyEmotes[14]=(CategoryName="Status",EmoteTag="InPosition",EmoteName="",EmoteAnim="Taunt_UB_Flag_Pickup",bVictoryEmote=false,bTopHalfEmote=true,Command="None",bRequiresPlayer=false)
    FamilyEmotes[15]=(CategoryName="Status",EmoteTag="UnderAttack",EmoteName="",EmoteAnim="Taunt_UB_Flag_Pickup",bVictoryEmote=false,bTopHalfEmote=true,Command="None",bRequiresPlayer=false)
    FamilyEmotes[16]=(CategoryName="Status",EmoteTag="AreaSecure",EmoteName="",EmoteAnim="Taunt_UB_Flag_Pickup",bVictoryEmote=false,bTopHalfEmote=true,Command="None",bRequiresPlayer=false)
    FamilyEmotes[17]=(CategoryName="Inventory",EmoteTag="UseArmor",EmoteName="",EmoteAnim="Taunt_FB_BringItOn",bVictoryEmote=false,bTopHalfEmote=true,Command="None",bRequiresPlayer=false)
    FamilyEmotes[18]=(CategoryName="Inventory",EmoteTag="UseHealth",EmoteName="",EmoteAnim="Taunt_UB_Flag_Pickup",bVictoryEmote=false,bTopHalfEmote=true,Command="None",bRequiresPlayer=false)
    HeadShotGoreSocketName="HeadShotGoreSocket"
    DrivingDrawScale=1.0000000
    DefaultMeshScale=1.0000000
}