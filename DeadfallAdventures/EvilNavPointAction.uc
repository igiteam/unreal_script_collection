class EvilNavPointAction extends Object
    abstract
    editinlinenew
    collapsecategories
    hidecategories(Object);

var EvilAIController AIController;
var EvilAICommand AICommand;
var class<EvilAICommand> DefaultAICommand;
var EvilPawn MyEvilPawn;
var transient name Status;
var transient name VerboseStatus;
var() bool bDisableIK;

function bool InitNavAction(EvilPawn InMyEvilPawn)
{
    MyEvilPawn = InMyEvilPawn;
    AIController = EvilAIController(MyEvilPawn.Controller);
    return MyEvilPawn != none;
    //return ReturnValue;    
}

function PushDefaultCommand()
{
    // End:0x77
    if((AIController != none) && DefaultAICommand != none)
    {
        AICommand = new (AIController) DefaultAICommand;
        // End:0x77
        if(AICommand != none)
        {
            AIController.PushCommand(AICommand);
        }
    }
    //return;    
}

function StartNavAction()
{
    PushDefaultCommand();
    MyEvilPawn.CurrentNavPointAction = self;
    Status = 'Active';
    MyEvilPawn.OnIKStatusUpdate();
    //return;    
}

function FinishNavAction()
{
    // End:0xB9
    if(((AIController != none) && DefaultAICommand != none) && AICommand != none)
    {
        // End:0xAE
        if(AIController.GetActiveCommand() == AICommand)
        {
            AICommand.Status = 'Success';
            AIController.PopCommand(AICommand);
        }
        AICommand = none;
    }
    //return;    
}

function bool IsNavActionActive()
{
    return IsNavActionSettedAtPawn() && Status == 'Active';
    //return ReturnValue;    
}

final function bool IsNavActionSettedAtPawn()
{
    return (MyEvilPawn != none) && MyEvilPawn.CurrentNavPointAction == self;
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
    FinishNavAction();
    // End:0x39
    if(Status != 'Active')
    {
        ExitWithFailure(string(Status));        
    }
    else
    {
        ExitWithSuccess();
    }
    // End:0x72
    if(MyEvilPawn != none)
    {
        MyEvilPawn.OnIKStatusUpdate();
    }
    Cleanup();
    //return;    
}

function OnNavActionAbort()
{
    ExitWithFailure("Aborted");
    // End:0x42
    if(MyEvilPawn != none)
    {
        MyEvilPawn.OnIKStatusUpdate();
    }
    Cleanup();
    //return;    
}

function Cleanup()
{
    AICommand = none;
    AIController = none;
    MyEvilPawn = none;
    //return;    
}

defaultproperties
{
    bDisableIK=true
}