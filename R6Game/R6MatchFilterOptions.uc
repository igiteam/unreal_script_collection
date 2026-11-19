class R6MatchFilterOptions extends Object
    native
    config(ServerOptions);

var config int m_iGameMode;
var config int m_iGameType;
var config int m_iServerType;
var config int m_iMinPlayers;
var config int m_iMaxPlayers;
var config int m_iAllowVoice;
var config int m_iLanguage;
var config int m_iPunkBuster;

defaultproperties
{
    m_iGameType=1
    m_iMaxPlayers=14
}