class R6InteractiveDepotStation extends R6InteractiveSimpleObject
    native
    config(Game)
    placeable
    hidecategories(lighting);

const DEFAULT_OBJECTDELIVERYTIME = 2.0f;
const DEFAULT_DEPOTOPENEDTIME = 1.2f;

enum EObjectDeliveryStep
{
    OBJECTDELIVERYSTEP_None,        // 0
    OBJECTDELIVERYSTEP_OpenDepot,   // 1
    OBJECTDELIVERYSTEP_CloseDepot,  // 2
    OBJECTDELIVERYSTEP_MAX          // 3
};

struct DeliveryInfo
{
    var float m_fTimeLength;
    var export editinline StaticMeshComponent m_pMeshComponent;

    structdefaultproperties
    {
        m_fTimeLength=0.0000000
        m_pMeshComponent=none
    }
};

var() SpotLightToggleable m_pSpotLight;
var array<MaterialInstance> m_arrMaterials;
var array<Color> m_arrColors;
var DeliveryInfo m_DeliveryInfo;
var R6Canister m_pDeliveredObject;
var R6InteractiveDepotStation.EObjectDeliveryStep m_eDeliveryStep;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_eDeliveryStep, m_pDeliveredObject;
}

// Export UR6InteractiveDepotStation::execUpdateLook(FFrame&, void* const)
native function UpdateLook(bool bFriendly);

// Export UR6InteractiveDepotStation::execUpdateLight(FFrame&, void* const)
native function UpdateLight();

// Export UR6InteractiveDepotStation::execGetAttachmentSocketName(FFrame&, void* const)
native function name GetAttachmentSocketName();

// Export UR6InteractiveDepotStation::execAttachObject(FFrame&, void* const)
native function AttachObject();

// Export UR6InteractiveDepotStation::execDetachObject(FFrame&, void* const)
native function DetachObject();

// Export UR6InteractiveDepotStation::execResetDeliveryAnim(FFrame&, void* const)
native function ResetDeliveryAnim();

simulated function MatchStarting()
{
    // End:0x50
    if((WorldInfo.GRI != none) && WorldInfo.GRI.OnSameTeam(GetGameManager().GetLocalPlayer(), self))
    {
        UpdateLook(true);        
    }
    else
    {
        UpdateLook(false);
    }
    return;
}

function InteractSuccesful(Pawn pInteractor)
{
    // End:0x84
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x5A
        if((m_pUser != none) && m_pUser.PlayerReplicationInfo != none)
        {
            m_pDeliveredObject = R6Canister(R6PlayerReplicationInfo(m_pUser.PlayerReplicationInfo).GetCarriedObject());
        }
        AttachObject();
        m_eDeliveryStep = 2;
        NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
    }
    InteractSuccesful(pInteractor);
    return;
}

function float GetDeliveryTimeLength()
{
    return m_DeliveryInfo.m_fTimeLength;
    return;
}

simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
{
    return false;
    return;
}

defaultproperties
{
    m_arrColors[0]=none
    m_arrColors[1]=none
    m_AnimNameTP="StandReadyMG_Canister_Delivery"
    m_fInteractingTime=3.0000000
    m_eRadarIcon=17
    m_ActorName="Interactive DEPOT STATION"
    m_bCheckInteractRotation=true
    m_bInteractRotPawnRot=false
    // Reference: SkeletalMeshComponent'Default__R6InteractiveDepotStation.DepotBaseMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DepotBaseMesh" class=Class'Engine.SkeletalMeshComponent'
        bSpecialForceDynamicShadow=true
        BlockActors=true
        BlockNonZeroExtent=true
    end object
    m_Mesh=DepotBaseMesh
    m_bUnloadForDeathMatch=true
    m_bUnloadForTeamDeathMatch=true
    m_bUnloadForAttackDefend=true
    m_bUnloadForConquest=true
    m_bUnloadForAssassination=true
    m_bUnloadForStory=true
    m_bUnloadForTerroristHunt=true
    m_bUnloadForSoloStory=true
    m_bUnloadForSoloTerroristHunt=true
    Components[0]=DepotBaseMesh
    CollisionComponent=DepotBaseMesh
}