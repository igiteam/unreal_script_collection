class R6VoiceChatManagerInterface extends Object
    native
    config(Game);

var config float m_fVoiceRadius;
var config int m_iVoicePort;

// Export UR6VoiceChatManagerInterface::execPreAudioStartVoiceChatEngine(FFrame&, void* const)
native final function bool PreAudioStartVoiceChatEngine();

// Export UR6VoiceChatManagerInterface::execPostAudioStartVoiceChatEngine(FFrame&, void* const)
native final function bool PostAudioStartVoiceChatEngine();

// Export UR6VoiceChatManagerInterface::execStopVoiceChatEngine(FFrame&, void* const)
native final function bool StopVoiceChatEngine();

// Export UR6VoiceChatManagerInterface::execSetLocalChatter(FFrame&, void* const)
native final function bool SetLocalChatter(byte byId, byte byControllerID);

// Export UR6VoiceChatManagerInterface::execAddChatter(FFrame&, void* const)
native final function bool AddChatter(byte byId, string xuid, string xnaddr);

// Export UR6VoiceChatManagerInterface::execRemoveChatter(FFrame&, void* const)
native final function bool RemoveChatter(byte byId);

// Export UR6VoiceChatManagerInterface::execActivateChatter(FFrame&, void* const)
native final function bool ActivateChatter(byte byControllerID, byte byId);

// Export UR6VoiceChatManagerInterface::execDeactivateChatter(FFrame&, void* const)
native final function bool DeactivateChatter(byte byControllerID, byte byId);

// Export UR6VoiceChatManagerInterface::execMuteChatter(FFrame&, void* const)
native final function bool MuteChatter(byte byId);

// Export UR6VoiceChatManagerInterface::execUnMuteChatter(FFrame&, void* const)
native final function bool UnMuteChatter(byte byId);

// Export UR6VoiceChatManagerInterface::execIsTalking(FFrame&, void* const)
native final function bool IsTalking(byte byId);

// Export UR6VoiceChatManagerInterface::execHasVoiceChat(FFrame&, void* const)
native final function bool HasVoiceChat(byte byId);

defaultproperties
{
    m_fVoiceRadius=1500.0000000
    m_iVoicePort=1011
}