class TurokHudLivesRemaining extends TurokHudElement
    transient
    native;

enum eHUDLivesMode
{
    HUD_LIVES_None,                 // 0
    HUD_LIVES_Solo,                 // 1
    HUD_LIVES_Team,                 // 2
    HUD_LIVES_Coop,                 // 3
    HUD_LIVES_MAX                   // 4
};

var @NULL mBackgroundTexture;
var @NULL mCornerTexture;
var @NULL mScoreboardTex;
var @NULL mOwnLivesTex;
var @NULL mTeamLivesTex;
var @NULL mFont;
var float mTextScale;
var int mWidth;
var int mHeight;
var int mSpacing;
var int mTextureSpacing;
var int mStartOffset;
var float mSafezoneBufferX;
var float mSafezoneBufferY;
var int mTextWidth;
var @NULL mTeamIcon0UVStart;
var @NULL mTeamIcon1UVStart;
var int mTeamIconWidth;
var int mTeamIconHeight;
var @NULL mRedTeamColor;
var @NULL mBlueTeamColor;
var @NULL mTextFlashColor;
var float mTextFlashLength;
var float mTextFlashTime0;
var float mTextFlashTime1;
var int mLastLives0;
var int mLastLives1;
var byte mMode;
var bool mbInitialized;
var @NULL mOwnLivesColor;
var @NULL mOwnLivesTexColor;
var @NULL mOwnLivesIconUVStart;
var int mOwnLivesIconWidth;
var int mOwnLivesIconHeight;
var @NULL mTeamLivesTexColor;
var @NULL mTeamLivesUVStart;
var int mTeamLivesWidth;
var int mTeamLivesHeight;
var int mIconSpacing;
var @NULL mBackgroundColor;
var @NULL mTeamIconsColor;
var @NULL mPlayerRepInfo;

// Export UTurokHudLivesRemaining::execDraw(FFrame&, void* const)
native function Draw();

// Export UTurokHudLivesRemaining::execInit(FFrame&, void* const)
native function Init(@NULL kHudRef);

defaultproperties
{
    mBackgroundTexture=Texture2D'EngineResources.Black'
    mCornerTexture=Texture2D'TurokHud.AmmoDisplay.AmmoTankRoundedCorner_HD'
    mScoreboardTex=Texture2D'TurokHudMultiplayer.MiniScoreboard.MiniScoreboard_Pieces_HD'
    mOwnLivesTex=Texture2D'TurokHudMultiplayer.LivesRemaining.LivesIcon_Individual'
    mTeamLivesTex=Texture2D'TurokHudMultiplayer.LivesRemaining.LivesIcon_Team'
    mFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mTextScale=0.3280000
    mWidth=75
    mHeight=30
    mSpacing=3
    mTextureSpacing=4
    mStartOffset=10
    mSafezoneBufferX=3.0000000
    mSafezoneBufferY=59.0000000
    mTextWidth=31
    mTeamIcon0UVStart=(X=100.0000000,Y=5.0000000)
    mTeamIcon1UVStart=(X=74.0000000,Y=5.0000000)
    mTeamIconWidth=24
    mTeamIconHeight=22
    mRedTeamColor=(R=218,G=125,B=0,A=255)
    mBlueTeamColor=(R=2,G=115,B=195,A=255)
    mTextFlashColor=(R=255,G=255,B=255,A=255)
    mTextFlashLength=0.1250000
    mTextFlashTime0=10.0000000
    mTextFlashTime1=10.0000000
    mOwnLivesColor=(R=181,G=18,B=9,A=255)
    mOwnLivesTexColor=(R=215,G=177,B=122,A=204)
    mOwnLivesIconUVStart=(X=3.0000000,Y=2.0000000)
    mOwnLivesIconWidth=24
    mOwnLivesIconHeight=27
    mTeamLivesTexColor=(R=215,G=177,B=122,A=204)
    mTeamLivesUVStart=(X=4.0000000,Y=4.0000000)
    mTeamLivesWidth=23
    mTeamLivesHeight=23
    mBackgroundColor=(R=255,G=255,B=255,A=179)
    mTeamIconsColor=(R=255,G=255,B=255,A=204)
}