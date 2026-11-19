class R6TeamActor extends R6InfoPoint
    native
    hidecategories(lighting,Object,Actor,Advanced,Attachment,Collision,Display,Fire,Heat,CubemapSample,Reticule,Region,R6Sound,R6SoundPropagation)
    autoexpandcategories(R6TeamActor);

var() Color m_Color;
var R6AreaOfOperation m_pAreaOfOperation;
var R6AreaOfOperation m_pTriggerArea;
var R6TeamManager m_pTeamManager;
var() float m_fTimeBeforePawnIsConsideredAware;
var() float m_fTimeBeforePawnIsConsideredInCombat;

function OnR6KillTeam(SeqAct_R6KillTeam Action)
{
    local int I;

    // End:0xA4
    if(Action.m_bStopWave)
    {
        I = 0;
        J0x19:

        // End:0x5A [Loop If]
        if(I < m_pTeamManager.m_aWaves.Length)
        {
            m_pTeamManager.m_aWaves[I].StopWave();
            ++I;
            // [Loop Continue]
            goto J0x19;
        }
        I = 0;
        J0x61:

        // End:0xA4 [Loop If]
        if(I < m_pTeamManager.m_aWavePoints.Length)
        {
            m_pTeamManager.m_aWavePoints[I].m_bToSpawn = false;
            ++I;
            // [Loop Continue]
            goto J0x61;
        }
    }
    I = 0;
    J0xAB:

    // End:0xEE [Loop If]
    if(I < m_pTeamManager.m_aSpawnPoints.Length)
    {
        m_pTeamManager.m_aSpawnPoints[I].m_bToSpawn = false;
        ++I;
        // [Loop Continue]
        goto J0xAB;
    }
    GotoState('s_KillTeam');
    return;
}

simulated state s_KillTeam
{
    simulated function BeginState(name PreviousStateName)
    {
        SetTimer(0.1000000, false);
        return;
    }

    simulated event Timer()
    {
        // End:0x3D
        if(m_pTeamManager.m_aTeamMember.Length > 0)
        {
            m_pTeamManager.m_aTeamMember[0].GotoState('s_Obsolete');
            SetTimer(0.1000000, false);
        }
        return;
    }
    stop;
}

defaultproperties
{
    m_Color=(R=100,G=100,B=150,A=0)
    m_fTimeBeforePawnIsConsideredAware=1.0000000
    m_fTimeBeforePawnIsConsideredInCombat=2.0000000
    // Reference: SpriteComponent'Default__R6TeamActor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__R6InfoPoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'AIIcons.AITeamActor_Pic'
    end object
    Components[0]=Sprite
    SupportedEvents=/* Array type was not detected. */
}