class TurokLocalizedMessage extends LocalMessage
    abstract;

var @NULL mController;
var @NULL mPRI1;
var @NULL mPRI2;
var @NULL mObject;
var int mSwitch;
var @NULL mFont;
var string mText;
var float mEndOfLife;
var float mMaxOpacity;
var array mSubMessages;

static function ReceiveMessage(class<Class> messagetype, @NULL Controller, @NULL PRI_1, @NULL PRI_2, @NULL Object, optional int Switch)
{
    local @NULL Message, HUD;

    // End:0x87
    if(messagetype != none)
    {
        HUD = TurokHud(Controller.myHUD);
        // End:0x84
        if(HUD != none)
        {
            Message = new messagetype;
            Message.Init(Controller, PRI_1, PRI_2, Object, Switch);
            Message.Show(HUD);
        }        
    }
    //return;    
}

function Init(@NULL Controller, @NULL PRI1, @NULL PRI2, @NULL Object, optional int Switch = 0)
{
    mController = Controller;
    mPRI1 = PRI1;
    mPRI2 = PRI2;
    mObject = Object;
    mSwitch = Switch;
    mText = GetText();
    DrawColor = GetDrawColor();
    mEndOfLife = float(Lifetime) + mController.WorldInfo.TimeSeconds;
    // End:0x99
    if(GetIsValid())
    {
        GenerateSubMessages();
    }
    //return;    
}

function Show(@NULL HUD)
{
    // End:0x3D
    if((HUD != none) && GetIsValid())
    {
        HUD.AddMessage(self);
        ShowSubMessages(HUD);
    }
    //return;    
}

function ShowSubMessages(@NULL HUD)
{
    local int I;

    // End:0x4A
    if(HUD != none)
    {
        I = 0;
        J0x12:

        // End:0x4A [Loop If]
        if(I < mSubMessages.Length)
        {
            mSubMessages[I].Show(HUD);
            I++;
            // [Loop Continue]
            goto J0x12;
        }
    }
    //return;    
}

function bool GetIsValid()
{
    return true;
    //return ReturnValue;    
}

function string GetText()
{
    return "Error - TurokLocalizedMessage::GetText() not overridden";
    //return ReturnValue;    
}

function @NULL GetDrawColor()
{
    return DrawColor;
    //return ReturnValue;    
}

function bool HasExpired()
{
    return mEndOfLife < mController.WorldInfo.TimeSeconds;
    //return ReturnValue;    
}

function SetMaxOpacity(float Opacity)
{
    mMaxOpacity = Opacity;
    //return;    
}

function float GetOpacity()
{
    // End:0x13
    if(HasExpired())
    {
        return 0.0000000;
    }
    return ((255.0000000 * mMaxOpacity) * (mEndOfLife - mController.WorldInfo.TimeSeconds)) / float(Lifetime);
    //return ReturnValue;    
}

function GenerateSubMessages()
{
    //return;    
}

function Draw(@NULL HUD, float X, float Y)
{
    //return;    
}

protected function bool IsClientForPlayer(@NULL PRI)
{
    return mController.PlayerReplicationInfo == PRI;
    //return ReturnValue;    
}

defaultproperties
{
    mFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mMaxOpacity=1.0000000
    Lifetime=5
    DrawColor=(R=235,G=235,B=235,A=255)
}