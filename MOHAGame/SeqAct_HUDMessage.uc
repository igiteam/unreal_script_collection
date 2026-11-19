class SeqAct_HUDMessage extends SequenceAction
    native
    hidecategories(Object);

var() string Message;
var() name LocalizedName;
var() float fDisplayTime;
var() float fPosX;
var() float fPosY;
var() bool bRenderEvenWhenHUDOff;

event LoadLocalizedStrings()
{
    Message = GetLocalizedStr(Message, string(LocalizedName), "Message", "UIStrings");
    //return;    
}

defaultproperties
{
    fDisplayTime=3.0000000
    fPosX=0.5000000
    fPosY=0.7500000
    InputLinks[0]=(LinkDesc="Activate",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    InputLinks[1]=(LinkDesc="Deactivate",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    ObjName="HUD Message"
    ObjCategory="HUD"
}