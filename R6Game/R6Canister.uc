class R6Canister extends R6CarriedObject
    native
    hidecategories(lighting);

var R6GameEnums.ETEAMIDENTITY m_eAllowedTeam;
var R6InteractiveDepotStation m_pContainer;
var repnotify bool m_bDelivered;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_bDelivered;
}

// Export UR6Canister::execAttachedToContainer(FFrame&, void* const)
native function AttachedToContainer();

// Export UR6Canister::execDetachedFromContainer(FFrame&, void* const)
native function DetachedFromContainer();

// Export UR6Canister::execDeliverTo(FFrame&, void* const)
native function DeliverTo(R6InteractiveDepotStation pStation);

simulated function byte GetTeamNum()
{
    return m_eAllowedTeam;
    return;
}

state s_Delivered
{
    function BeginState(name PreviousStateName)
    {
        m_bDelivered = true;
        NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
        AttachedToContainer();
        return;
    }

    function EndState(name NextStateName)
    {
        // End:0x5D
        if(NextStateName == 's_Started')
        {
            // End:0x5D
            if((WorldInfo.Game != none) && R6GameInfo(WorldInfo.Game) != none)
            {
                R6GameInfo(WorldInfo.Game).Respawned(self);
            }
        }
        m_bDelivered = false;
        NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
        return;
    }
    stop;
}

defaultproperties
{
    m_eAllowedTeam=2
    // Reference: StaticMeshComponent'Default__R6Canister.StaticMeshCanister'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="StaticMeshCanister" class=Class'Engine.StaticMeshComponent'
        CollideActors=false
        BlockActors=false
    end object
    m_pObjectMesh=StaticMeshCanister
    m_szItemName="CANISTER"
    m_bUnloadForDeathMatch=true
    m_bUnloadForTeamDeathMatch=true
    m_bUnloadForAttackDefend=true
    m_bUnloadForConquest=true
    m_bUnloadForAssassination=true
    m_bUnloadForStory=true
    m_bUnloadForTerroristHunt=true
    m_bUnloadForSoloStory=true
    m_bUnloadForSoloTerroristHunt=true
    // Reference: CylinderComponent'Default__R6Canister.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__R6CarriedObject.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=20.0000000
        Translation=(X=0.0000000,Y=0.0000000,Z=18.0000000)
    end object
    Components[0]=CollisionCylinder
    Components[1]=StaticMeshCanister
    CollisionComponent=CollisionCylinder
}