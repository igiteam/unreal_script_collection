class MOHACSA extends Trigger
    native
    hidecategories(Navigation);

var(csa) string csaText;
var(csa) name csaName;
var(csa) bool bLookAt;
var(csa) bool bEnabled;
var(csa) bool bOneShot;
var(csa) bool bForceRender;
var bool bDirty;
var bool bDisplayed;
var(csa) float fLookAtThreshold;
var float fWeight;
var float fWeightScale;

function LoadLocalizedStrings()
{
    csaText = GetLocalizedStr(csaText, string(csaName), "csaText", "CSAs");
    //return;    
}

function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    LoadLocalizedStrings();
    //return;    
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local MOHAPawn localPawn;
    local MOHAPlayerController LocalPlayer;

    // End:0x8D
    if(!bRecentlyTriggered && bEnabled)
    {
        localPawn = MOHAPlayerPawn(Other);
        // End:0x8D
        if(localPawn != none)
        {
            LocalPlayer = MOHAPlayerController(localPawn.Controller);
            // End:0x69
            if(LocalPlayer != none)
            {
                LocalPlayer.AddCSA(self);
            }
            bDisplayed = false;
            bRecentlyTriggered = true;
            SetTimer(AITriggerDelay, false, 'UnTrigger');
        }
    }
    //return;    
}

simulated function Vector GetPosition()
{
    return Location;
    //return ReturnValue;    
}

simulated function Rotator GetRotation()
{
    return Rotation;
    //return ReturnValue;    
}

function UsedByPlayer(MOHAPlayerController Player)
{
    //return;    
}

event bool UsedBy(Pawn User)
{
    local MOHAPlayerController LocalPlayer;

    // End:0x0B
    if(bDirty)
    {
        return false;
    }
    LocalPlayer = MOHAPlayerController(User.Controller);
    // End:0xB1
    if(LocalPlayer != none)
    {
        LocalPlayer.RemoveCSA(self);
        // End:0x75
        if(bDisplayed)
        {
            MOHAHUD(LocalPlayer.myHUD).RemoveCSA();
            bDisplayed = false;
        }
        // End:0x86
        if(bOneShot)
        {
            bEnabled = false;
        }
        UsedByPlayer(LocalPlayer);
        TriggerEventClass(Class'SeqEvent_CSAUsed', User, -1);
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x2C
    if(Action.InputLinks[0].bHasImpulse)
    {
        SetEnabled(true);        
    }
    else
    {
        // End:0x58
        if(Action.InputLinks[1].bHasImpulse)
        {
            SetEnabled(false);            
        }
        else
        {
            // End:0x89
            if(Action.InputLinks[2].bHasImpulse)
            {
                SetEnabled(!bEnabled);
            }
        }
    }
    //return;    
}

simulated function SetEnabled(bool CSAEnabled)
{
    bEnabled = CSAEnabled;
    //return;    
}

simulated function string GetCSAText(MOHAPlayerController mpc)
{
    local string ReplacedString;

    ReplacedString = csaText;
    ReplaceText(ReplacedString, "%b", mpc.GetUseButtonToken());
    return ReplacedString;
    //return ReturnValue;    
}

simulated function bool IsUsableBy(MOHAPlayerController PlayerController)
{
    local MOHAPlayerPawn PlayerPawn;

    PlayerPawn = MOHAPlayerPawn(PlayerController.Pawn);
    // End:0x3C
    if((PlayerPawn != none) && PlayerPawn.Health <= 0)
    {
        return false;
    }
    // End:0x71
    if((EALAGrenade(PlayerPawn.Weapon) != none) && !PlayerPawn.IsIdle())
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    csaText="Press [$A] to Use"
    bLookAt=true
    bEnabled=true
    bOneShot=true
    fLookAtThreshold=0.7000000
    // Reference: CylinderComponent'Default__MOHACSA.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHACSA.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    TickGroup=1
    ActorType=17
    CollisionComponent=CollisionCylinder
    SupportedEvents=/* Array type was not detected. */
}