class R6MPBriefingRetrieval extends R6MPBriefing
    native;

var array<R6InteractiveDepotStation> m_apDepotStation;

defaultproperties
{
    m_aVoiceOffTeamA[0]=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_01NARR001'
    m_aVoiceOffTeamA[1]=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_01NARR002'
    m_aVoiceOffTeamB[0]=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_01NARR003'
    m_aVoiceOffTeamB[1]=SoundCue'Dare.VO_Multiplayer.VO_MPB_RTVL_01NARR004'
    m_szGameModeExtention="Retri"
    m_aBriefingNode[0]=(EType=0,fTime=2.0000000,iObjective=0)
    m_aBriefingNode[1]=(EType=1,fTime=0.0000000,iObjective=0)
    m_aBriefingNode[2]=(EType=2,fTime=5.0000000,iObjective=0)
    m_aBriefingNode[3]=(EType=3,fTime=0.0000000,iObjective=0)
    m_aBriefingNode[4]=(EType=1,fTime=0.0000000,iObjective=1)
    m_aBriefingNode[5]=(EType=2,fTime=5.0000000,iObjective=1)
    m_aBriefingNode[6]=(EType=5,fTime=0.0000000,iObjective=0)
}