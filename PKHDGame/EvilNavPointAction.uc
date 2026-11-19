class EvilNavPointAction extends Object
    abstract
    editinlinenew
    collapsecategories
    hidecategories(Object);

var EvilPawn MyEvilPawn;
var transient name Status;
var transient name VerboseStatus;
var() bool bDisableIK;

function bool InitNavAction(EvilPawn InMyEvilPawn)
{
    MyEvilPawn = InMyEvilPawn;
    return MyEvilPawn != none;
    //return ReturnValue;    
}

function StartNavAction()
{
    MyEvilPawn.CurrentNavPointAction = self;
    Status = 'Active';
    MyEvilPawn.OnIKStatusUpdate();
    //return;    
}

function bool IsNavActionActive()
{
    return IsNavActionSettedAtPawn() && Status == 'Active';
    //return ReturnValue;    
}

final function bool IsNavActionSettedAtPawn()
{
    return MyEvilPawn.CurrentNavPointAction == self;
    //return ReturnValue;    
}

function ExitWithSuccess()
{
    // End:0x2D
    if(IsNavActionSettedAtPawn())
    {
        MyEvilPawn.CurrentNavPointAction = none;
    }
    Status = 'Success';
    //return;    
}

function ExitWithFailure(coerce optional string Reason)
{
    // End:0x2E
    if(IsNavActionSettedAtPawn())
    {
        MyEvilPawn.CurrentNavPointAction = none;
    }
    VerboseStatus = name(Reason);
    Status = 'Failure';
    //return;    
}

function OnNavActionFinish()
{
    // End:0x2F
    if(Status != 'Active')
    {
        ExitWithFailure(string(Status));        
    }
    else
    {
        ExitWithSuccess();
    }
    MyEvilPawn.OnIKStatusUpdate();
    //return;    
}

function OnNavActionAbort()
{
    ExitWithFailure("Aborted");
    MyEvilPawn.OnIKStatusUpdate();
    //return;    
}

defaultproperties
{
    bDisableIK=true
}