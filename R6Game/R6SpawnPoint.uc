class R6SpawnPoint extends R6InfoPoint
    native
    hidecategories(lighting,Object,Actor,Advanced,Attachment,Collision,Display,Fire,Heat,CubemapSample,Reticule,Region,R6Sound,R6SoundPropagation);

enum ECivilPose
{
    CIVILPOSE_RANDOM,               // 0
    CIVILPOSE_STAND,                // 1
    CIVILPOSE_CROUCH,               // 2
    CIVILPOSE_COWER,                // 3
    CIVILPOSE_MAX                   // 4
};

struct R6InventoryAmmo
{
    var() class<Inventory> m_Inventory;
    var() float m_iAmmo;

    structdefaultproperties
    {
        m_Inventory=none
        m_iAmmo=2.0000000
    }
};

var bool m_bToSpawn;
var bool m_bDisable;
var(SpawnConfiguration) bool m_bStartAtLaunch;
var(SpawnConfiguration) bool m_bAlwaysSpawnInWave;
var(SpawnConfiguration) bool m_bDeactivateWhilePreviousAlive;
var(SpawnConfiguration) bool m_bForceSpawning;
var(SpawnConfiguration) bool m_bAlwaysActive;
var(SpawnConfiguration) bool m_bDontIdleChat;
var(SpawnConfiguration) bool m_bDisableCollision;
var(SpawnConfiguration) bool m_bStopSpawningWhenSeen;
var bool m_bNightvision;
var() bool bCanCrouch;
var(AI) bool bLOSHearing;
var(AI) bool bSameZoneHearing;
var(AI) bool bAdjacentZoneHearing;
var(AI) bool bMuffledHearing;
var(AI) bool bAroundCornerHearing;
var(AI) bool bDontPossess;
var() bool m_bLeaderPawn;
var() bool m_bDisableSenses;
var(Special) bool m_bPawnDebug;
var(SpecialCivil) bool m_bIsHostage;
var(SpecialCivil) bool m_bIsSpecialRainbow;
var(SpecialCivil) bool m_bKeepMood;
var R6Character m_pSpawnedCharacter;
var(SpawnConfiguration) class<R6Character> m_eTypeClass;
var(SpawnConfiguration) array<R6WakeInfo> m_ZombieWakeEvents;
var array<R6InventoryAmmo> m_aGrenades;
var StaticMesh m_pNVGMesh;
var array<R6ActionSpot> m_aSpotMember;
var array<string> m_aExternalSpotMember;
var int m_iZoneID;
var() float RBPushRadius;
var() float RBPushStrength;
var() float ViewPitchMin;
var() float ViewPitchMax;
var() Weapon Weapon;
var(AI) float HearingThreshold;
var(AI) float Alertness;
var(AI) float SightRadius;
var(AI) float PeripheralVision;
var(Eyes) float BaseEyeHeight;
var(Eyes) float EyeHeight;
var() editinline R6EquipmentTemplate m_EquipmentTemplate;
var() editinline R6AITemplate m_AITemplate;
var() R6GameEnums.EMentalState m_eMentalState;
var() R6GameEnums.EDetectionAction m_eDetectionAction;
var() R6Pawn.EAlliance m_eAlliance;
var(AI) R6Pawn.R6AIControllerState InitialAIState;
var(Special) R6CivilController.ePROFILETYPE m_eCurrentProfile;
var(SpecialCivil) R6SpawnPoint.ECivilPose m_eStartPose;
var() StaticMesh m_pouchMesh;
var() R6CharacterTemplate m_CharacterTemplate;
var() export editinline SkeletalMeshComponent m_FPMesh;
var int m_iTeamTemplateFlags;
var R6TeamManager m_pTeamManager;
var sObjective m_sDefaultObjective;
var(SpecialCivil) int m_iCivilZoneID;
var(Anim) array<AnimSet> m_ExtraAnimSets;

defaultproperties
{
    m_bForceSpawning=true
    bCanCrouch=true
    bLOSHearing=true
    bMuffledHearing=true
    bDontPossess=true
    m_pNVGMesh=StaticMesh'RS5MPCharacters_Gear_Boots.Male.RS5MPC_NV_Goggles'
    RBPushRadius=10.0000000
    RBPushStrength=50.0000000
    ViewPitchMin=-16384.0000000
    ViewPitchMax=16383.0000000
    HearingThreshold=15000.0000000
    SightRadius=12000.0000000
    BaseEyeHeight=60.0000000
    EyeHeight=60.0000000
    m_EquipmentTemplate=R6EquipmentTemplate'EquipmentTemplates.DefaultPawnEquipment'
    m_AITemplate=R6AITemplate'RS5CharacterAITemplate.DefaultAITemplate'
    m_eStartPose=1
    m_CharacterTemplate=R6CharacterTemplate'RS5Rainbow.Template.LoganTemplate'
    m_iTeamTemplateFlags=15
    m_sDefaultObjective=(m_eObjectiveType=2,m_nNameId="None",m_fMaxDistanceFromStartLocation=0.0000000,m_aActors=none,m_bIsMobile=false,m_bCanBeLeader=false,m_bFollowInFormation=false,m_fFormationDistance=0.0000000,m_fFormationAngle=0.0000000,m_fAttackTimeDelay=1.0000000)
    bHidden=true
    bNoDelete=true
    bStasis=true
    // Reference: SpriteComponent'Default__R6SpawnPoint.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__R6InfoPoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'AIIcons.AISpawnPoint_Pic'
    end object
    Components[0]=Sprite
    // Reference: ArrowComponent'Default__R6SpawnPoint.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="Arrow" class=Class'Engine.ArrowComponent'
        ArrowColor=(R=150,G=200,B=255,A=255)
        ArrowSize=1.5000000
    end object
    Components[1]=Arrow
    SupportedEvents=/* Array type was not detected. */
}