class R6AIInfo extends Object
    native;

var array<R6TeamManager> m_aLevelTeamManager;
var R6CivilManager m_pCivilManager;
var R6RainbowManager m_pRainbowAIManager;
var R6HostageManager m_pHostageManager;
var R6ScriptedNPCManager m_pScriptedNPCManager;
var R6AIServiceManager m_pAIServiceManager;
var R6ActionManager m_pActionManager;
var R6CorpseManager m_pCorpseManager;
var R6CommunicationManager m_pCommunicationManager;
var R6MusicIntensityManager m_pMusicIntensityManager;
var R6TerroHuntManager m_pTerroHuntManager;
var R6AIPawnActivationManager m_pAIPawnActivationManager;
var R6FightManager m_pFightManager;

// Export UR6AIInfo::execReset(FFrame&, void* const)
native final function Reset();
