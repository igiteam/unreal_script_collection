class AdvPerk_Base extends Actor
    config(Perks)
    notplaceable
    hidecategories(Navigation);

enum EActivationType
{
    EAT_KillsinRow,                 // 0
    EAT_Treasures,                  // 1
    EAT_MatchScore,                 // 2
    EAT_MAX                         // 3
};

struct PerkActivationMethod
{
    var config AdvPerk_Base.EActivationType ActivationType;
    var config int Value;

    structdefaultproperties
    {
        ActivationType=EActivationType.EAT_KillsinRow
        Value=0
    }
};

var int GetTime;
var string PerkName;
var config PerkActivationMethod ActivationMethod;
var SoundCue ActivationSound;
var SoundCue ActivationAccentSound;
var string ActivationStringKey;
var SoundCue StartSoundTeam;
var string StartTeamStringKey;
var SoundCue StartSoundEnemy;
var string StartEnemyStringKey;
var SoundCue PerkMusic;
var bool bDestroyAfterUse;
var bool bPlayPerkMusic;
var config int IconIndex;

function bool ActivatePerk(Controller PC)
{
    local PlayerController C;

    // End:0x21B
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', C)
    {
        // End:0x16B
        if(C.Pawn.IsSameTeam(PC.Pawn) || class<AdvGameSurvivalBase>(WorldInfo.GetGameClass()) != none)
        {
            // End:0xF9
            if(StartSoundTeam != none)
            {
                AdvPlayerControllerMP(C).ClientPlaySound(StartSoundTeam);
            }
            AdvPlayerControllerMP(C).SetSecondaryAnnouncerMessage(Class'ADVGame'.static.ConvertToLocalizedString("MultiplayerAnnouncer", StartTeamStringKey, "AdvGame"));
            // End:0x21A
            continue;
        }
        // End:0x1AB
        if(StartSoundEnemy != none)
        {
            AdvPlayerControllerMP(C).ClientPlaySound(StartSoundEnemy);
        }
        AdvPlayerControllerMP(C).SetSecondaryAnnouncerMessage(Class'ADVGame'.static.ConvertToLocalizedString("MultiplayerAnnouncer", StartEnemyStringKey, "AdvGame"));        
    }    
    // End:0x296
    if(bPlayPerkMusic && WorldInfo.Game != none)
    {
        AdvGameMP_Base(WorldInfo.Game).UpdateMummyMusic(true, PerkMusic);
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    ActivationSound=SoundCue'a_GameplaySounds.Treasure.a_treasure_pick'
    ActivationAccentSound=SoundCue'a_Accents.Cue.a_KillPerk'
}