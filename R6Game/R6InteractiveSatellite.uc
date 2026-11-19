class R6InteractiveSatellite extends R6InteractiveSimpleObject
    native
    config(Game)
    editinlinenew
    placeable
    hidecategories(lighting,Object);

enum ESatelliteIdentifier
{
    SATELLITE_A,                    // 0
    SATELLITE_B,                    // 1
    SATELLITE_C,                    // 2
    SATELLITE_MAX                   // 3
};

var array<MaterialInstance> m_arrMaterials;
var float m_fSatelliteCaptureTime;
var float m_fSatelliteStartupTime;
var float m_fSatellitePulseRadius;
var float m_fSatellitePulseTime;
var float m_fSatelliteSpottedTime;
var repnotify bool m_bSatelliteEnabled;
var repnotify bool m_bSatellitePulsing;
var repnotify byte m_eControllingTeam;
var() R6InteractiveSatellite.ESatelliteIdentifier m_eSatelliteIdentifier;
var() SpotLightToggleable m_pSpotLight;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_bSatelliteEnabled, m_bSatellitePulsing, 
        m_eControllingTeam;
}

// Export UR6InteractiveSatellite::execRadarPulse(FFrame&, void* const)
native final function RadarPulse();

// Export UR6InteractiveSatellite::execUpdateLook(FFrame&, void* const)
native final function UpdateLook();

function SetControllingTeam(byte eTeam)
{
    m_eControllingTeam = eTeam;
    NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
    UpdateLook();
    return;
}

simulated function bool IsControlledBy(R6GameEnums.ETEAMIDENTITY eTeam)
{
    return int(m_eControllingTeam) == int(eTeam);
    return;
}

function EnableSatellite()
{
    StartRadarSignal();
    m_bSatelliteEnabled = true;
    NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
    UpdateLook();
    return;
}

function DisableSatellite()
{
    StopRadarSignal();
    m_bSatelliteEnabled = false;
    NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
    UpdateLook();
    return;
}

simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
{
    return false;
    return;
}

simulated function PostBeginPlay()
{
    PostBeginPlay();
    SetControllingTeam(byte(255));
    m_fInteractingTime = m_fSatelliteStartupTime;
    SetTimer(m_fSatellitePulseTime, true, 'RadarPulse');
    return;
}

function ResetOriginalData()
{
    ResetOriginalData();
    SetControllingTeam(byte(255));
    m_fInteractingTime = m_fSatelliteStartupTime;
    SetTimer(m_fSatellitePulseTime, true, 'RadarPulse');
    return;
}

function InteractSuccesful(Pawn pInteractor)
{
    local R6GameEnums.ETEAMIDENTITY ePlayerTeam;

    // End:0x96
    if((pInteractor != none) && pInteractor.Controller != none)
    {
        ePlayerTeam = R6PlayerController(pInteractor.Controller).GetTeamNum();
        // End:0x96
        if(!IsControlledBy(ePlayerTeam))
        {
            // End:0x8B
            if(int(Role) == int(ROLE_Authority))
            {
                SetControllingTeam(ePlayerTeam);
                NetUpdateTime = WorldInfo.TimeSeconds - float(1);
            }
            m_fInteractingTime = m_fSatelliteCaptureTime;
        }
    }
    InteractSuccesful(pInteractor);
    return;
}

simulated function byte GetTeamNum()
{
    return m_eControllingTeam;
    return;
}

defaultproperties
{
    m_fSatelliteCaptureTime=8.0000000
    m_fSatelliteStartupTime=5.0000000
    m_fSatellitePulseRadius=2000.0000000
    m_fSatellitePulseTime=3.0000000
    m_fSatelliteSpottedTime=2.0000000
    m_eRadarIcon=11
    m_ActorName="Interactive Satellite"
    // Reference: StaticMeshComponent'Default__R6InteractiveSatellite.SatelliteBaseMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="SatelliteBaseMesh" class=Class'Engine.StaticMeshComponent'
        bSpecialForceDynamicShadow=true
    end object
    m_Mesh=SatelliteBaseMesh
    m_bUnloadForDeathMatch=true
    m_bUnloadForTeamDeathMatch=true
    m_bUnloadForAttackDefend=true
    m_bUnloadForAssassination=true
    m_bUnloadForRetrieval=true
    m_bUnloadForStory=true
    m_bUnloadForTerroristHunt=true
    m_bUnloadForSoloStory=true
    m_bUnloadForSoloTerroristHunt=true
    // Reference: SpriteComponent'Default__R6InteractiveSatellite.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__R6InteractiveSimpleObject.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    // Reference: StaticMeshComponent'Default__R6InteractiveSatellite.InteractiveActorMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: StaticMeshComponent'Default__R6InteractiveSimpleObject.InteractiveActorMesh'
    begin object name="InteractiveActorMesh"
    end object
    Components[1]=InteractiveActorMesh
    // Reference: CylinderComponent'Default__R6InteractiveSatellite.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="CollisionCylinder" class=Class'Engine.CylinderComponent'
        CollisionHeight=60.0000000
        CollisionRadius=45.0000000
        CollideActors=true
        BlockActors=true
        Translation=(X=0.0000000,Y=0.0000000,Z=55.0000000)
    end object
    Components[2]=CollisionCylinder
    Components[3]=SatelliteBaseMesh
    CollisionComponent=CollisionCylinder
}