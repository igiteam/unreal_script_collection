class R6ExtractionZone extends NavigationPoint
    native
    hidecategories(lighting,lighting,LightColor,Force,Object,Advanced,Attachment,Display,Heat,Movement,NavigationPoint,R6Sound,R6SoundPropagation);

var R6Radar.ERadarIcon m_eRadarIcon;
var(TeamGame) R6GameEnums.ETEAMIDENTITY m_eAllowedTeam;
var R6RadarObjectiveRepInfo m_pRadarInfo;
var bool m_bRadarSignalEnabled;

simulated function byte GetTeamNum()
{
    return m_eAllowedTeam;
    return;
}

// Export UR6ExtractionZone::execIsValidInteractor(FFrame&, void* const)
native function bool IsValidInteractor(Actor other);

function EnableRadarSignal(bool bEnable)
{
    m_bRadarSignalEnabled = bEnable;
    // End:0x5D
    if(bEnable)
    {
        // End:0x5A
        if(GetGameManager().IsMultiplayer())
        {
            // End:0x5A
            if(m_pRadarInfo == none)
            {
                m_pRadarInfo = __NFUN_278__(Class'R6RadarObjectiveRepInfo');
                m_pRadarInfo.Init(self);
            }
        }        
    }
    else
    {
        // End:0x7B
        if(m_pRadarInfo != none)
        {
            m_pRadarInfo.Destroy();
            m_pRadarInfo = none;
        }
    }
    return;
}

function ResetOriginalData()
{
    ResetOriginalData();
    EnableRadarSignal(false);
    return;
}

simulated function byte GetRadarIcon()
{
    return m_eRadarIcon;
    return;
}

defaultproperties
{
    m_eRadarIcon=16
    m_eAllowedTeam=2
    // Reference: CylinderComponent'Default__R6ExtractionZone.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Engine.Default__NavigationPoint.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=200.0000000
        CollisionRadius=200.0000000
        CollideActors=true
    end object
    CylinderComponent=CollisionCylinder
    bStatic=false
    bCollideActors=true
    bCollideWorld=true
    // Reference: SpriteComponent'Default__R6ExtractionZone.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__NavigationPoint.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__R6ExtractionZone.PathRenderer'
    // Archetype: PathRenderingComponent'Engine.Default__NavigationPoint.PathRenderer'
    begin object name="PathRenderer"
    end object
    Components[2]=PathRenderer
    CollisionComponent=CollisionCylinder
}