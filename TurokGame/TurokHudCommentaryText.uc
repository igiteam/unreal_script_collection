class TurokHudCommentaryText extends TurokHudElement
    transient
    native;

const mMaxMessages = 4;

enum eCommentaryMsgType
{
    eCommentaryMsg_Kill,            // 0
    eCommentaryMsg_HeadShot,        // 1
    eCommentaryMsg_Suicide,         // 2
    eCommentaryMsg_Joined,          // 3
    eCommentaryMsg_Left,            // 4
    eCommentaryMsg_NumTypes,        // 5
    eCommentaryMsg_MAX              // 6
};

enum eTurokTeamValue
{
    COMMENTARY_TEAM_NONE,           // 0
    COMMENTARY_TEAM_WHISKEY,        // 1
    COMMENTARY_TEAM_WOLFPACK,       // 2
    COMMENTARY_TEAM_MAX             // 3
};

struct native CommentaryTextMsg
{
    var string mPlayer1;
    var string mPlayer2;
    var byte mTeam1;
    var byte mTeam2;
    var float mLife;
    var byte mMsgType;
    var byte mDmgType;

    structdefaultproperties
    {
        mPlayer1=""
        mPlayer2=""
        mTeam1=0
        mTeam2=0
        mLife=0.0000000
        mMsgType=0
        mDmgType=0
    }
};

struct native WeaponTexture
{
    var float mX;
    var float mY;
    var float mWidth;
    var float mHeight;

    structdefaultproperties
    {
        mX=0.0000000
        mY=0.0000000
        mWidth=0.0000000
        mHeight=0.0000000
    }
};

var array mWeaponTextures;
var @NULL mHeadShotTexture;
var @NULL mSuicideTexture;
var @NULL mTexture;
var @NULL mTextFont;
var float mTextScale;
var @NULL mMessages[4];
var @NULL mDeathColorNoTeam;
var @NULL mDeathColorWhiskey;
var @NULL mDeathColorWolfpack;
var @NULL mStatusColor;
var float mWaitBeforeFade;
var float mFadeTime;
var float mDefaultMsgLife;
var int mNewestMsg;
var bool mIsCoopGame;

// Export UTurokHudCommentaryText::execGetMsgHeight(FFrame&, void* const)
native function float GetMsgHeight(@NULL Msg);

// Export UTurokHudCommentaryText::execDrawNative(FFrame&, void* const)
native function DrawNative();

// Export UTurokHudCommentaryText::execDrawTexture(FFrame&, void* const)
native function DrawTexture(@NULL Texture, float X, float Y);

// Export UTurokHudCommentaryText::execDrawDeathMessage(FFrame&, void* const)
native function DrawDeathMessage(@NULL Msg, float X, float Y, float Alpha, out float Height);

// Export UTurokHudCommentaryText::execDrawStatusMessage(FFrame&, void* const)
native function DrawStatusMessage(@NULL Msg, float X, float Y, float Alpha, out float Height);

event Init(@NULL hudRef)
{
    super.Init(hudRef);
    // End:0x23
    if(TurokCoopGameHud(hudRef) != none)
    {
        mIsCoopGame = true;
    }
    //return;    
}

function Draw()
{
    Update();
    DrawMessages();
    //return;    
}

function AddTurokLocalizedMessage(@NULL Message)
{
    // End:0x3C7
    if(Message.IsA('TurokAdminMessage') || Message.IsA('TurokDeathMessage'))
    {
        mNewestMsg = int(float(mNewestMsg + 1) % float(4));
        // End:0xB9
        if(Message.IsA('TurokAdminMessage'))
        {
            switch(TurokAdminMessage(Message).mSwitch)
            {
                // End:0x93
                case 1:
                    mMessages[mNewestMsg].mMsgType = 3;
                    // End:0xB6
                    break;
                // End:0xB3
                case 4:
                    mMessages[mNewestMsg].mMsgType = 4;
                    // End:0xB6
                    break;
                // End:0xFFFF
                default:
                    break;
            }            
        }
        else
        {
            // End:0x1B4
            if(Message.IsA('TurokDeathMessage'))
            {
                mMessages[mNewestMsg].mMsgType = 0;
                // End:0x117
                if((Message.mSwitch & 1) != 0)
                {
                    mMessages[mNewestMsg].mMsgType = 1;
                }
                // End:0x162
                if(class<TurokDamageType>(Message.mObject) != none)
                {
                    mMessages[mNewestMsg].mDmgType = class<TurokDamageType>(Message.mObject).default.mDamageType;
                }
                // End:0x1B1
                if((Message.mPRI1 == none) || Message.mPRI1 == Message.mPRI2)
                {
                    mMessages[mNewestMsg].mMsgType = 2;
                }                
            }
        }
        // End:0x2B0
        if(Message.mPRI1 != none)
        {
            mMessages[mNewestMsg].mPlayer1 = Message.mPRI1.PlayerName;
            // End:0x22D
            if(Message.mPRI1.Team == none)
            {
                mMessages[mNewestMsg].mTeam1 = 0;                
            }
            else
            {
                // End:0x270
                if(int(Message.mPRI1.Team.TeamIndex) == 0)
                {
                    mMessages[mNewestMsg].mTeam1 = 1;                    
                }
                else
                {
                    // End:0x2B0
                    if(int(Message.mPRI1.Team.TeamIndex) == 1)
                    {
                        mMessages[mNewestMsg].mTeam1 = 2;
                    }
                }
            }
        }
        // End:0x3AC
        if(Message.mPRI2 != none)
        {
            mMessages[mNewestMsg].mPlayer2 = Message.mPRI2.PlayerName;
            // End:0x329
            if(Message.mPRI2.Team == none)
            {
                mMessages[mNewestMsg].mTeam2 = 0;                
            }
            else
            {
                // End:0x36C
                if(int(Message.mPRI2.Team.TeamIndex) == 0)
                {
                    mMessages[mNewestMsg].mTeam2 = 1;                    
                }
                else
                {
                    // End:0x3AC
                    if(int(Message.mPRI2.Team.TeamIndex) == 1)
                    {
                        mMessages[mNewestMsg].mTeam2 = 2;
                    }
                }
            }
        }
        mMessages[mNewestMsg].mLife = mDefaultMsgLife;
    }
    //return;    
}

function Update()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x5F [Loop If]
    if(I < 4)
    {
        // End:0x55
        if(mMessages[I].mLife > float(0))
        {
            mMessages[I].mLife -= mHud.RenderDelta;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function DrawMessages()
{
    DrawNative();
    //return;    
}

function Reset()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(I < 4)
    {
        mMessages[I].mLife = 0.0000000;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

defaultproperties
{
    mWeaponTextures=/* Array type was not detected. */
    mHeadShotTexture=(mX=398.0000000,mY=87.0000000,mWidth=28.0000000,mHeight=28.0000000)
    mSuicideTexture=(mX=5.0000000,mY=5.0000000,mWidth=38.0000000,mHeight=36.0000000)
    mTexture=Texture2D'TurokHudMultiplayer.MP_CommentaryIcons_HD'
    mTextFont=TurokFont'TurokFontsNew.TurokConduitTCBold'
    mTextScale=0.8100000
    mDeathColorNoTeam=(R=255,G=255,B=255,A=255)
    mDeathColorWhiskey=(R=255,G=163,B=0,A=255)
    mDeathColorWolfpack=(R=92,G=181,B=246,A=255)
    mStatusColor=(R=215,G=161,B=94,A=255)
    mWaitBeforeFade=5.0000000
    mFadeTime=2.0000000
    mDefaultMsgLife=7.0000000
}