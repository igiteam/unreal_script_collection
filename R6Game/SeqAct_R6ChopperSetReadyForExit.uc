class SeqAct_R6ChopperSetReadyForExit extends SequenceAction
    native
    hidecategories(Object);

var() bool m_bPlayerReadyToExit;
var() bool m_bTeammatesReadyToExit;
var() bool m_bForceTeammateFastRopeYaw;
var() /*0x20000000-0x00000000*/ int m_iForcedTeammateFastRopeYaw;

defaultproperties
{
    m_bPlayerReadyToExit=true
    m_bTeammatesReadyToExit=true
    ObjName="Set Ready For Exit"
    ObjCategory="Helicopter"
}