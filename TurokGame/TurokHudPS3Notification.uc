class TurokHudPS3Notification extends TurokHudElement
    transient
    native;

enum ePS3NotificationMsgType
{
    ePS3NotificationMsg_Achievement,// 0
    ePS3NotificationMsg_GameInvite, // 1
    ePS3NotificationMsg_NumTypes,   // 2
    ePS3NotificationMsg_MAX         // 3
};

struct native PS3NotificationMsg
{
    var string mMsg;
    var float mLife;
    var int mHashId1;
    var int mHashId2;
    var byte mMsgType;

    structdefaultproperties
    {
        mMsg=""
        mLife=0.0000000
        mHashId1=0
        mHashId2=0
        mMsgType=0
    }
};

var @NULL mSideTexture;
var @NULL mMiddleTexture;
var @NULL mAchievementTexture;
var @NULL mInviteTexture;
var @NULL mTitleFont;
var @NULL mBodyFont;
var @NULL mTitleColor;
var @NULL mBodyColor;
var array mMessages;
var private float mFadeTime;
var private float mCurrentFade;
var private float mFadeDir;
var private float mFadeInRate;
var private float mFadeOutRate;

// Export UTurokHudPS3Notification::execReset(FFrame&, void* const)
native function Reset();

// Export UTurokHudPS3Notification::execAddAchievement(FFrame&, void* const)
native function AddAchievement(int Hash);

// Export UTurokHudPS3Notification::execAddInvite(FFrame&, void* const)
native function AddInvite(string Str);

// Export UTurokHudPS3Notification::execAddMessage(FFrame&, void* const)
private native final function AddMessage(@NULL Msg);

// Export UTurokHudPS3Notification::execDraw(FFrame&, void* const)
native function Draw();

// Export UTurokHudPS3Notification::execDrawBG(FFrame&, void* const)
native function DrawBG(float X, float Y, float Width);

// Export UTurokHudPS3Notification::execTick(FFrame&, void* const)
native function Tick(float elapsed);

defaultproperties
{
    mSideTexture=Texture2D'TurokHud.PS3Accomplishments_BG_Side'
    mMiddleTexture=Texture2D'TurokHud.PS3Accomplishments_BG'
    mAchievementTexture=Texture2D'TurokHud.PS3Accomplishments_Icon'
    mInviteTexture=Texture2D'TurokHud.PS3GameInvite_Icon'
    mTitleFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mBodyFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mTitleColor=(R=44,G=222,B=98,A=230)
    mBodyColor=(R=255,G=255,B=255,A=204)
    mFadeTime=1.0000000
    mFadeDir=4.0000000
    mFadeInRate=4.0000000
    mFadeOutRate=-0.5000000
}