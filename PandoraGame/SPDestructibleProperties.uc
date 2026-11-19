class SPDestructibleProperties extends Object
    native
    editinlinenew;

struct native FireParamsInfo
{
    /** Defaults to be zero to indicate its not flammable. */
    var() float FireFlammability;
    /** Defaults to be zero to indicate its not flammable. */
    var() float FireStrength;
    /** Defaults to be zero to indicate its not flammable. */
    var() float FireSpreadSpeed;
    /** Defaults to be zero to indicate its not flammable. */
    var() float FireBurnTime;
    /** Defaults to be zero to indicate its not flammable. */
    var() float FireDamage;
    /** How much fire damages me. */
    var() float FireDamagedByScale;
    /** How much fire attached to me damages me. */
    var() float FireDamagedByChildScale;
    /** How much fire attached to me damages me. */
    var() float FireCylRadiusOverride;
    /** How much fire attached to me damages me. */
    var() float FireCylHeightOverride;
    /** How much fire attached to me damages me. */
    var() float FireScale;
    /** Default location (relative to object) to create fire. */
    var() Vector FireCatchOffset;
    var bool FireIsTempFire;

    structdefaultproperties
    {
        FireFlammability=0.0000000
        FireStrength=0.0000000
        FireSpreadSpeed=0.0000000
        FireBurnTime=0.0000000
        FireDamage=0.0000000
        FireDamagedByScale=1.0000000
        FireDamagedByChildScale=1.0000000
        FireCylRadiusOverride=0.0000000
        FireCylHeightOverride=0.0000000
        FireScale=1.0000000
        FireCatchOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        FireIsTempFire=false
    }
};

struct native OverriddenLightingParams
{
    var() bool bOverrideLighting;
    /** If bOverrideLighting == false, don't inherit lighting settings from base actor (if it exists). */
    var() bool bDisableInheritBaseLighting;
    /** If bOverrideLighting == false, don't inherit lighting settings from base actor (if it exists). */
    var() bool CastShadow;
    /** If bOverrideLighting == false, don't inherit lighting settings from base actor (if it exists). */
    var() const bool bForceDirectLightMap;
    /** If bOverrideLighting == false, don't inherit lighting settings from base actor (if it exists). */
    var() bool bCastDynamicShadow;
    /** If bOverrideLighting == false, don't inherit lighting settings from base actor (if it exists). */
    var() const bool bAcceptsLights;
    /** If bOverrideLighting == false, don't inherit lighting settings from base actor (if it exists). */
    var() const bool bAcceptsDynamicLights;
    /** If bOverrideLighting == false, don't inherit lighting settings from base actor (if it exists). */
    var() const bool bUsePrecomputedShadows;
    /** If bOverrideLighting == false, don't inherit lighting settings from base actor (if it exists). */
    var() const LightingChannelContainer LightingChannels;

    structdefaultproperties
    {
        bOverrideLighting=false
        bDisableInheritBaseLighting=false
        CastShadow=false
        bForceDirectLightMap=false
        bCastDynamicShadow=false
        bAcceptsLights=false
        bAcceptsDynamicLights=false
        bUsePrecomputedShadows=false
        LightingChannels=(bInitialized=false,BSP=false,Static=false,Dynamic=false,CompositeDynamic=false,Skybox=false,Unnamed_1=false,Unnamed_2=false,Unnamed_3=false,Unnamed_4=false,Unnamed_5=false,Unnamed_6=false,Cinematic_1=false,Cinematic_2=false,Cinematic_3=false,Cinematic_4=false,Cinematic_5=false,Cinematic_6=false,Gameplay_1=false,Gameplay_2=false,Gameplay_3=false,Gameplay_4=false,Crowd=false)
    }
};

/** VARIABLE DECLARATIONS */
var(InitialState) int HitPoints;
var(InitialState) float MinCollisionVelocity;
var(InitialState) float MaxCollisionVelocity;
var(InitialState) StaticMesh StaticMesh;
var(InitialState) float Sharpness;
var(InitialState) Vector DrawScale3D;
var(InitialState) SkeletalMesh SkeletalMesh;
var(InitialState) PhysicsAsset PhysicsAsset;
var(SPDAction) float PhysicsWeight;
var(InitialState) AnimSet AnimSet;
var(InitialState) name AnimSequenceName;
var(InitialState) bool bStartAwake;
var(InitialState) bool bDamageAppliesImpulse;
var(InitialState) bool bEnableCommands;
var(Targetting) bool IsAPlayerTarget;
var(InitialState) float Scale;
var(InitialState) OverriddenLightingParams Lighting;
var(FireParamsInfo) FireParamsInfo FireParams;
var(CollisionSounds) SoundCue CollisionSound[2];
var(OnBreak) export editinline array<export editinline SPDOnBreakActionList> OnBreakActionLists;
var(OnBreak) export editinline array<export editinline SPDGenericActionList> OnBreakAlwaysRunActionLists;
var(OnSpawn) export editinline array<export editinline SPDGenericActionList> OnSpawnActionList;
var export editinline array<export editinline SPAITag> OATStags;
var(OATStags) export editinline array<export editinline SPAITag2> OATStags2;

// Export USPDestructibleProperties::execCanHandleDamageType(FFrame&, void* const)
native function bool CanHandleDamageType(class<DamageType> Type);
