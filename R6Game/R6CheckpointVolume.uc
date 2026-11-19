class R6CheckpointVolume extends Volume
    native
    hidecategories(lighting,Object,Movement,Display);

var(checkpoint) Vector m_avLocations[3];
var(checkpoint) /*0x20000000-0x00000000*/ int m_arRotation[3];
var(checkpoint) bool m_bValidForNormal;
var(checkpoint) bool m_bValidForVeteran;
var(checkpoint) bool m_bValidForElite;
var(checkpoint) bool m_bSceneLocation;
var(checkpoint) int m_iIdx;
var(checkpoint) string m_strDescId;
var(checkpoint) ZoneInfo m_ZoneInfo;
var(Streaming) array<string> m_arrKismetStreamsToPreload;
var transient bool m_bDisabled;
var transient bool m_bPendingSave;
var transient bool m_bUsed;
var transient bool m_bEventSent;
var transient R6Pawn m_pPendingSavePawn;

function OnR6ToggleCheckpoint(SeqAct_R6ToggleCheckpoint Action)
{
    // End:0x24
    if(Action.InputLinks[0].bHasImpulse)
    {
        m_bDisabled = false;        
    }
    else
    {
        // End:0x45
        if(Action.InputLinks[1].bHasImpulse)
        {
            m_bDisabled = true;
        }
    }
    return;
}

defaultproperties
{
    m_avLocations[0]=(X=-100.0000000,Y=0.0000000,Z=0.0000000)
    m_avLocations[2]=(X=100.0000000,Y=0.0000000,Z=0.0000000)
    m_arRotation[0]=16384
    m_arRotation[1]=16384
    m_arRotation[2]=16384
    m_bValidForNormal=true
    m_bValidForVeteran=true
    m_bValidForElite=true
    BrushColor=(R=100,G=255,B=255,A=255)
    bColored=true
    bStatic=false
    SupportedEvents=/* Array type was not detected. */
}