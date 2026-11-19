class TPGrappleNode extends TPPathNode
    hidecategories(NavigationPoint);

var() float StruggleTime;

event Touch(Actor Other, PrimitiveComponent OtherComponent, vector HitLocation, vector HitNormal)
{
    local PlayerPawn player;
    player = PlayerPawn(Other);

    if (player != None)
    {
        TPPlayerController(player.Controller).GrapInt_v2.GrappleNode = self;
    }
}

event Untouch(Actor Other)
{
    local PlayerPawn player;
    player = PlayerPawn(Other);

    if (player != None)
    {
        TPPlayerController(player.Controller).GrapInt_v2.GrappleNode = None;
    }
}

function OnStartEnvironmentGrapple(SeqAct_StartEnvironmentGrapple action)
{
    // Do nothing...extracting information from SeqAct_StartEnvironmentGrapple
    // done in GrappleInteraction_v2.uc
}

function TriggerGrappleEvent()
{
    TriggerEventClass(class'SeqEvent_EnvironmentGrapple', self);
}

function FinishGrappleEvent()
{
    ClearLatentAction(class'SeqAct_StartEnvironmentGrapple');
}

