class TurokHudMessage extends TurokHudElement
    transient
    native;

enum EMessageType
{
    MSGTYPE_Commentary,             // 0
    MSGTYPE_GameEvent,              // 1
    MSGTYPE_MAX                     // 2
};

struct native MessageBlock
{
    var name mMsgType;
    var array mMsgBuffer;
    var int mMaxNumMsgs;
    var int mHead;
    var @NULL mPos;
    var int mSpacing;

    structdefaultproperties
    {
        mMsgType="None"
        mMsgBuffer=none
        mMaxNumMsgs=0
        mHead=0
        mPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mSpacing=0
    }
};

var @NULL mMsgBlocks[2];

function AddMessage(@NULL Message)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x118 [Loop If]
    if(I < 2)
    {
        // End:0x10E
        if(Message.IsA(mMsgBlocks[I].mMsgType))
        {
            // End:0x92
            if(mMsgBlocks[I].mMsgBuffer.Length < mMsgBlocks[I].mMaxNumMsgs)
            {
                mMsgBlocks[I].mMsgBuffer.Length = mMsgBlocks[I].mMaxNumMsgs;
            }
            mMsgBlocks[I].mMsgBuffer[mMsgBlocks[I].mHead] = Message;
            mMsgBlocks[I].mHead = int(float(mMsgBlocks[I].mHead + 1) % float(mMsgBlocks[I].mMaxNumMsgs));
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function Draw()
{
    local int I, N, msgIndex, X, Y;

    I = 0;
    J0x07:

    // End:0x22E [Loop If]
    if(I < 2)
    {
        // End:0x224
        if(mMsgBlocks[I].mMsgBuffer.Length > 0)
        {
            X = int(mMsgBlocks[I].mPos.X * float(mHud.Canvas.SizeX));
            Y = int(mMsgBlocks[I].mPos.Y * float(mHud.Canvas.SizeY));
            msgIndex = mMsgBlocks[I].mHead - 1;
            N = 0;
            J0xD8:

            // End:0x224 [Loop If]
            if(N < mMsgBlocks[I].mMaxNumMsgs)
            {
                // End:0x120
                if(msgIndex < 0)
                {
                    msgIndex = mMsgBlocks[I].mMaxNumMsgs - 1;
                }
                // End:0x1F7
                if(mMsgBlocks[I].mMsgBuffer[msgIndex] != none)
                {
                    // End:0x18D
                    if(mMsgBlocks[I].mMsgBuffer[msgIndex].HasExpired())
                    {
                        mMsgBlocks[I].mMsgBuffer[msgIndex] = none;                        
                    }
                    else
                    {
                        mMsgBlocks[I].mMsgBuffer[msgIndex].SetMaxOpacity(1.0000000);
                        mMsgBlocks[I].mMsgBuffer[msgIndex].Draw(mHud, float(X), float(Y));
                    }
                }
                Y += mMsgBlocks[I].mSpacing;
                msgIndex--;
                N++;
                // [Loop Continue]
                goto J0xD8;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

defaultproperties
{
    mMsgBlocks[0]=(mMsgType="TurokCommentaryMessage",mMsgBuffer=none,mMaxNumMsgs=2,mHead=0,mPos=(X=0.0750000,Y=0.6600000,Z=0.0000000),mSpacing=24)
    mMsgBlocks[1]=(mMsgType="TurokGameEventMessage",mMsgBuffer=none,mMaxNumMsgs=1,mHead=0,mPos=(X=0.5000000,Y=0.1500000,Z=0.0000000),mSpacing=0)
}