class ZoneInfo extends Info
    native
    placeable
    hidecategories(lighting,Movement,Collision);

struct InterLevelZoneVisInfo
{
    var() name m_ZoneTagName;
    var() bool m_bRecursive;

    structdefaultproperties
    {
        m_ZoneTagName="None"
        m_bRecursive=true
    }
};

struct StreamingResource
{
    var() const editconst Object m_pObject;
    var const transient Pointer m_pResourceLoader;
    var() const editconst int m_iSizeNonStreamed;
    var() const editconst int m_iSizeStreamed;
    var const int m_iDataSize;
    var const bool m_bSticky;

    structdefaultproperties
    {
        m_pObject=none
        m_pResourceLoader=none
        m_iSizeNonStreamed=0
        m_iSizeStreamed=0
        m_iDataSize=0
        m_bSticky=false
    }
};

struct StreamingZone
{
    var() ZoneInfo m_pZoneInfo;

    structdefaultproperties
    {
        m_pZoneInfo=none
    }
};

struct StreamingZoneOutside
{
    var() name m_pZoneInfoName;

    structdefaultproperties
    {
        m_pZoneInfoName="None"
    }
};

var() name ZoneTag;
var() array<InterLevelZoneVisInfo> m_InterLevelVisibleZones;
var() const localized string LocationName;
var() float KillZ;
var() float SoftKill;
var() class<KillZDamageType> KillZDamageType;
var() bool bSoftKillZ;
var() array<name> ForceCullZones;
var() name CullTag;
var(R6Sound) /*0x04000000-0x00000000*/ export editinline R6SoundZoneInfo m_SoundZoneInfo;
var(R6Sound) /*0x04000000-0x00000000*/ name SoundZoneTag;
var(ColorGel) /*0x40000000-0x00000000*/ R6ColorGelParams m_ColorGelParams;
var array<Actor> m_AmbientSplitters;
var(Fog) /*0x40000000-0x00000000*/ R6DistanceFogParams m_FogParams;
var(AmbiantLight) LinearColor m_AmbiantLight;
var const array<StreamingResource> m_StreamingResources;
var(ResourceStreaming) array<StreamingZone> m_StreamingZones;
var(ResourceStreaming) array<StreamingZoneOutside> m_StreamingZonesOutside;
var(ResourceStreaming) array<MaterialInstance> m_StreamingMaterials;
var(BankSetLoading) /*0x04000000-0x00000000*/ array<ZoneInfo> m_SoundAdjascentZones;
var(BankSetLoading) /*0x04000000-0x00000000*/ array<StreamingZoneOutside> m_SoundStreamingZonesOutside;
var /*0x04000000-0x00000000*/ array<ZoneInfo> m_StreamingSoundZoneOutside;
var const string m_DataFilename;
var const int m_iFileOffset;
var const Guid m_FileGUID;
var const ZoneInfo m_pSharedResourcesZoneInfo;
var const int m_iSharedResourcesStartIndex;
var const int m_iSharedFileOffset;
var(Display) array<StaticMeshActor> m_ForcedShowSMActors;
var(Display) array<DynamicSMActor> m_ForcedShowDSMActors;
var(Display) float m_fMaxFarPlane;
var(Display) float m_fMinPortalPixelsRecursive;

// Export UZoneInfo::execZoneActors(FFrame&, void* const)
native(308) final iterator function ZoneActors(class<Actor> BaseClass, out Actor Actor);

simulated event ActorEntered(Actor other)
{
    return;
}

simulated event ActorLeaving(Actor other)
{
    return;
}

simulated function string GetLocationStringFor(PlayerReplicationInfo PRI)
{
    return LocationName;
    return;
}

defaultproperties
{
    KillZ=-1000000.0000000
    SoftKill=2500.0000000
    KillZDamageType=Class'KillZDamageType'
    // Reference: R6SoundZoneInfo'Default__ZoneInfo.SoundZoneInfo'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="SoundZoneInfo" class=Class'R6SoundZoneInfo'
    end object
    m_SoundZoneInfo=SoundZoneInfo
    m_AmbiantLight=(R=0.0000000,G=0.0000000,B=0.0000000,A=0.0000000)
    m_fMaxFarPlane=65000.0000000
    m_fMinPortalPixelsRecursive=64.0000000
    bStatic=true
    bNoDelete=true
    bGameRelevant=true
    // Reference: SpriteComponent'Default__ZoneInfo.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Info.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_ZoneInfo'
    end object
    Components[0]=Sprite
    Components[1]=SoundZoneInfo
}