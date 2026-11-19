class SkyInteractionStickWiggleCountRequest extends SkyInteractionButtonMashCountRequest
    native
    editinlinenew;

enum EWiggleState
{
    WiggleState_Invalid,            // 0
    WiggleState_Left,               // 1
    WiggleState_Right,              // 2
    WiggleState_MAX                 // 3
};

var transient SkyInteractionStickWiggleCountRequest.EWiggleState LeftWiggleState;
var transient SkyInteractionStickWiggleCountRequest.EWiggleState RightWiggleState;
var transient int LeftWiggleCount;
var transient int RightWiggleCount;
var() float Tolerance;
var() name HUDInteractionName;
var() name HUDInteractionNameKB;
var() bool bLeftStick;
var() bool bRightStick;

function name GetHUDInteractionName(optional bool bKeyboard)
{
    // End:0x13
    if(bKeyboard)
    {
        return HUDInteractionNameKB;        
    }
    else
    {
        return HUDInteractionName;
    }
    //return ReturnValue;    
}
