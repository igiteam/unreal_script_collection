class TurokUICredits extends UIObject
    native
    config(Credits)
    hidecategories(Object,UIRoot,Object);

enum eCreditType
{
    eCreditType_Cast,               // 0
    eCreditType_Title,              // 1
    eCreditType_SubTitle,           // 2
    eCreditType_Developer,          // 3
    eCreditType_PlainText,          // 4
    eCreditType_Blank,              // 5
    eCreditType_NumTypes,           // 6
    eCreditType_MAX                 // 7
};

struct native CreditDefinition
{
    var byte mType;
    var string mStringID;

    structdefaultproperties
    {
        mType=0
        mStringID=""
    }
};

struct native CreditInstance
{
    var byte mType;
    var int mHashID;
    var float mPosX;
    var float mPosY;
    var float mHeight;
    var float mScale;
    var @NULL mColor;

    structdefaultproperties
    {
        mType=0
        mHashID=0
        mPosX=0.0000000
        mPosY=0.0000000
        mHeight=0.0000000
        mScale=0.0000000
        mColor=(R=0,G=0,B=0,A=0)
    }
};

var array mCredits;
var config array mCreditDefinitions;
var int mLastDisplayedCredit;
var config float mVertSpacing;
var config float mHorSpacing;
var config float mScrollSpeedMax;
var config float mScrollSpeedNorm;
var config float mScrollSpeedMin;
var float mScrollSpeed;
var @NULL mFont;
var @NULL mTitleFont;
var @NULL mCastColor;
var @NULL mTitleColor;
var @NULL mSubTitleColor;
var @NULL mDeveloperColor;
var @NULL mPlainTextColor;
//var delegate<@NULL> __OnCreditsFinished__Delegate;

delegate OnCreditsFinished()
{
    //return;    
}

// Export UTurokUICredits::execTick(FFrame&, void* const)
native function Tick(float tickAmount);

event bool ProcessInput(int ControllerId, name Key, byte Event, float AmountDepressed)
{
    // End:0xA6
    if((int(Event) == int(0)) || int(Event) == int(2))
    {
        switch(Key)
        {
            // End:0x35
            case 'Gamepad_RightStick_Up':
            // End:0x41
            case 'Gamepad_LeftStick_Up':
            // End:0x4D
            case 'XboxTypeS_DPad_Up':
            // End:0x66
            case 'Up':
                mScrollSpeed = mScrollSpeedMax;
                return true;
            // End:0x72
            case 'Gamepad_RightStick_Down':
            // End:0x7E
            case 'Gamepad_LeftStick_Down':
            // End:0x8A
            case 'XboxTypeS_DPad_Down':
            // End:0xA3
            case 'Down':
                mScrollSpeed = mScrollSpeedMin;
                return true;
            // End:0xFFFF
            default:
                break;
            }
    }
    else
    {
        // End:0x12D
        if(int(Event) == int(1))
        {
            switch(Key)
            {
                // End:0xC9
                case 'Gamepad_RightStick_Up':
                // End:0xD5
                case 'Gamepad_RightStick_Down':
                // End:0xE1
                case 'Gamepad_LeftStick_Up':
                // End:0xED
                case 'Gamepad_LeftStick_Down':
                // End:0xF9
                case 'XboxTypeS_DPad_Up':
                // End:0x105
                case 'XboxTypeS_DPad_Down':
                // End:0x111
                case 'Up':
                // End:0x12A
                case 'Down':
                    mScrollSpeed = mScrollSpeedNorm;
                    return true;
                // End:0xFFFF
                default:
                    break;
                }
        }
        else
        {
            return false;
            //return ReturnValue;            
        }
    }
}

defaultproperties
{
    mFont=TurokFont'TurokFontsNew.TurokConduitTCBold'
    mTitleFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mCastColor=(R=217,G=157,B=63,A=255)
    mTitleColor=(R=205,G=137,B=0,A=255)
    mSubTitleColor=(R=205,G=137,B=0,A=255)
    mDeveloperColor=(R=177,G=123,B=63,A=255)
    mPlainTextColor=(R=177,G=123,B=63,A=255)
    // Reference: UIComp_Event'Default__TurokUICredits.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}