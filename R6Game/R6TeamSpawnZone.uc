class R6TeamSpawnZone extends NavigationPoint
    native
    hidecategories(lighting,lighting,LightColor,Force,Object,Advanced,Attachment,Collision,Display,Heat,Movement,NavigationPoint,R6Sound,R6SoundPropagation);

enum ESPAWNZONE_STATE
{
    ESPAWNZONE_STATE_NONE,          // 0
    ESPAWNZONE_STATE_ENABLED,       // 1
    ESPAWNZONE_STATE_DISABLED,      // 2
    ESPAWNZONE_STATE_DESTROYED,     // 3
    ESPAWNZONE_STATE_MAX            // 4
};

var() const localized string m_szDescription;
var() const localized string m_szFullDescription;
var() R6GameEnums.ETEAMIDENTITY m_eTeamNumber;
var repnotify R6TeamSpawnZone.ESPAWNZONE_STATE m_eState;
var() bool m_bEnabled;
var() bool m_bPrimaryZone;
var() bool m_bDestructibleZone;
var bool m_bAutoAssignStarts;
var() array<R6PlayerStart> m_arrPlayerStarts;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        m_eState;
}

// Export UR6TeamSpawnZone::execIsDestructible(FFrame&, void* const)
native function bool IsDestructible();

// Export UR6TeamSpawnZone::execIsAvailable(FFrame&, void* const)
native function bool IsAvailable();

// Export UR6TeamSpawnZone::execIsDestroyed(FFrame&, void* const)
native function bool IsDestroyed();

// Export UR6TeamSpawnZone::execGetDescription(FFrame&, void* const)
native function string GetDescription(optional bool bFull);

// Export UR6TeamSpawnZone::execOnZoneDestroyed(FFrame&, void* const)
native function OnZoneDestroyed();

simulated event PostBeginPlay()
{
    PostBeginPlay();
    OnEnableZone(m_bEnabled);
    return;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    OnToggle(Action);
    // End:0x30
    if(Action.InputLinks[0].bHasImpulse)
    {
        m_bEnabled = true;        
    }
    else
    {
        // End:0x54
        if(Action.InputLinks[1].bHasImpulse)
        {
            m_bEnabled = false;            
        }
        else
        {
            // End:0x7D
            if(Action.InputLinks[2].bHasImpulse)
            {
                m_bEnabled = !m_bEnabled;
            }
        }
    }
    OnEnableZone(m_bEnabled);
    return;
}

simulated function byte GetTeamNum()
{
    return m_eTeamNumber;
    return;
}

simulated function SaveOriginalData()
{
    SaveOriginalData();
    return;
}

simulated function ResetOriginalData()
{
    m_bEnabled = true;
    OnEnableZone(m_bEnabled);
    ResetOriginalData();
    return;
}

event OnEnableZone(bool bEnable)
{
    local int iStart;

    iStart = 0;
    J0x07:

    // End:0x4E [Loop If]
    if(iStart < m_arrPlayerStarts.Length)
    {
        // End:0x44
        if(m_arrPlayerStarts[iStart] != none)
        {
            m_arrPlayerStarts[iStart].bEnabled = bEnable;
        }
        ++iStart;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0x62
    if(bEnable)
    {
        m_eState = 1;        
    }
    else
    {
        m_eState = ((IsDestructible()) ? 3 : 2);
        // End:0x8F
        if(int(m_eState) == int(3))
        {
            OnZoneDestroyed();
        }
    }
    NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
    return;
}

defaultproperties
{
    m_szDescription="[ZONE]"
    m_szFullDescription="DEFAULT ZONE"
    m_bEnabled=true
    m_bAutoAssignStarts=true
    m_bUnloadForDeathMatch=true
    m_bUnloadForStory=true
    m_bUnloadForTerroristHunt=true
    m_bUnloadForSoloStory=true
    m_bUnloadForSoloTerroristHunt=true
    bStatic=false
    bReplicateMovement=false
    m_bDeleteOnReset=false
    // Reference: SpriteComponent'Default__R6TeamSpawnZone.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__NavigationPoint.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__R6TeamSpawnZone.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Engine.Default__NavigationPoint.CollisionCylinder'
    begin object name="CollisionCylinder"
    end object
    Components[1]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__R6TeamSpawnZone.PathRenderer'
    // Archetype: PathRenderingComponent'Engine.Default__NavigationPoint.PathRenderer'
    begin object name="PathRenderer"
    end object
    Components[2]=PathRenderer
    // Reference: ArrowComponent'Default__R6TeamSpawnZone.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="Arrow" class=Class'Engine.ArrowComponent'
        ArrowColor=(R=150,G=200,B=255,A=255)
        ArrowSize=1.5000000
    end object
    Components[3]=Arrow
    RemoteRole=1
    NetUpdateFrequency=0.1000000
}