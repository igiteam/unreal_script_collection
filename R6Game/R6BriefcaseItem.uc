class R6BriefcaseItem extends R6ExtractionItem
    native
    hidecategories(lighting);

var Vector m_vLastValidLocation;
var int m_iLastValidNMTriangleIndex;
var ENavMesh m_pLastValidNM;

// Export UR6BriefcaseItem::execSetValidDroppingLocation(FFrame&, void* const)
native function SetValidDroppingLocation();

state s_Dropped
{
    function BeginState(name PreviousStateName)
    {
        SetValidDroppingLocation();
        BeginState(PreviousStateName);
        return;
    }
    stop;
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__R6BriefcaseItem.StaticMeshBriefcase'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="StaticMeshBriefcase" class=Class'Engine.StaticMeshComponent'
        CollideActors=false
        BlockActors=false
        Rotation=(Pitch=32768,Yaw=0,Roll=0)
    end object
    m_pObjectMesh=StaticMeshBriefcase
    m_szItemName="BRIEFCASE"
    m_bUnloadForDeathMatch=true
    m_bUnloadForTeamDeathMatch=true
    m_bUnloadForConquest=true
    m_bUnloadForAssassination=true
    m_bUnloadForRetrieval=true
    m_bUnloadForStory=true
    m_bUnloadForTerroristHunt=true
    m_bUnloadForSoloStory=true
    m_bUnloadForSoloTerroristHunt=true
    // Reference: CylinderComponent'Default__R6BriefcaseItem.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__R6ExtractionItem.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionRadius=20.0000000
    end object
    Components[0]=CollisionCylinder
    Components[1]=StaticMeshBriefcase
    CollisionComponent=CollisionCylinder
}