class AdvPuzzle_Base extends Pawn
    abstract
    config(Game)
    hidecategories(Navigation)
    implements(EvilUsableInfoInterface,EvilPlayer_interface);

var Pawn User;
var Actor.ECollisionType PlayerCollision;
var GFxObject TextField;
var GFxObject TextFieldBG;
var() export editinline EvilCaptionComponent CaptionComponent;
var() const editconst export editinline DynamicLightEnvironmentComponent LightEnvironment;
var AdvPlayerPawn tmpAPP_T;
var string HintString;
var bool bLastUsingGamepad;
//var delegate<OnArmAnimEnd> __OnArmAnimEnd__Delegate;

function bool ShouldSaveForCheckpoint()
{
    return true;
    //return ReturnValue;    
}

function PostBeginPlay()
{
    local PlayerController PC;

    super.PostBeginPlay();
    // End:0xD3
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x8C
        if(!PC.bIsPlayer || PC.myHUD == none)
        {
            continue;            
        }
        EvilGFxHudWrapper(PC.myHUD).AddPostRenderedComponent(CaptionComponent);        
    }    
    //return;    
}

function AuxiliarySetLocation(Vector Destination)
{
    self.SetLocation(Destination);
    // End:0xAB
    if(self.Location != Destination)
    {
        // End:0x74
        if(self.MoveSmooth(Destination - self.Location))
        {            
        }
        else
        {
            // End:0xAB
            if(self.Move(Destination - self.Location))
            {                
            }
        }
    }
    //return;    
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    //return;    
}

function HideWeapons(AdvPlayerPawn APP)
{
    // End:0x53
    if(APP != none)
    {
        APP.QuickHideCurrentWeapon(true,, true);
        APP.QuickHideCurrentWeapon(true,, false);
    }
    //return;    
}

function HideGamePlayObject_T()
{
    AdvPlayerController(tmpAPP_T.Controller).HideGameplayObject();
    tmpAPP_T = none;
    //return;    
}

function RestoreWeapons(AdvPlayerPawn APP)
{
    // End:0x79
    if(APP != none)
    {
        APP.EndQuickHideCurrentWeapon(true,, true);
        APP.EndQuickHideCurrentWeapon(true,, false);
        tmpAPP_T = APP;
        SetTimer(0.1000000, false, 'HideGamePlayObject_T');
    }
    //return;    
}

function bool SetPawn(Pawn P)
{
    // End:0x44
    if(!AdvPlayerController(P.Controller).CheckIfPlayerCanEnter())
    {
        return false;
    }
    FireIOevent(true);
    PlayerCollision = P.CollisionType;
    P.SetCollisionType(1);
    P.SetHidden(true);
    User = P;
    HideWeapons(AdvPlayerPawn(P));
    return true;
    //return ReturnValue;    
}

function SetTextfield()
{
    CaptionComponent.SetCaptionLoc("ExitPuzzle");
    TextField = AdvGFxHud(AdvGFxHudWrapper(AdvPlayerController(self.Controller).myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.TreasureTipMC_g.textField");
    TextFieldBG = AdvGFxHud(AdvGFxHudWrapper(AdvPlayerController(self.Controller).myHUD).HudMovie).GetVariableObject("_root.HUD.TreasureTipMC.bg");
    TextFieldBG.GotoAndStop("show");
    TextField.SetBool("html", true);
    //return;    
}

function Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x2C
    if(User != none)
    {
        SetTextfield();
    }
    //return;    
}

function LeaveThePuzzle()
{
    local PlayerController PC;

    FireIOevent(false);
    PC = User.GetALocalPlayerController();
    EvilPlayerController(PC).EnterStartState();
    EvilPlayerController(PC).UnPossess();
    SetPhysics(7);
    EvilPlayerController(User.GetALocalPlayerController()).Possess(User, false);
    User.SetCollisionType(PlayerCollision);
    User.SetHidden(false);
    RestoreWeapons(AdvPlayerPawn(User));
    User = none;
    TextFieldBG.GotoAndStop("hide");
    TextField.SetString("htmlText", "");
    //return;    
}

function FireIOevent(bool entered)
{
    local Sequence GameSeq;
    local array<SequenceObject> ExecutionEvents;
    local SequenceObject ExecutionEvent;
    local SeqEvent_IOpuzzle FireEvent;
    local array<int> ActivateIndices;

    GameSeq = WorldInfo.GetGameSequence();
    // End:0x119
    if(GameSeq != none)
    {
        // End:0x55
        if(entered)
        {
            ActivateIndices[0] = 0;            
        }
        else
        {
            ActivateIndices[0] = 1;
        }
        GameSeq.FindSeqObjectsByClass(Class'SeqEvent_IOpuzzle', true, ExecutionEvents);
        // End:0x118
        foreach ExecutionEvents(ExecutionEvent)
        {
            FireEvent = SeqEvent_IOpuzzle(ExecutionEvent);
            // End:0x117
            if(FireEvent.Originator == self)
            {
                FireEvent.CheckActivate(self, none, false, ActivateIndices);
            }            
        }        
    }
    //return;    
}

simulated function bool IsUsable()
{
    return true;
    //return ReturnValue;    
}

simulated function bool IsUsableAndActive()
{
    return false;
    //return ReturnValue;    
}

simulated function bool CanBeUsedNow(PlayerController PC)
{
    return false;
    //return ReturnValue;    
}

simulated function float GetInteractRange()
{
    return CaptionComponent.ReferenceDistance;
    //return ReturnValue;    
}

delegate OnArmAnimEnd(bool RightHand, optional AnimNodeSequence SeqNode, optional float PlayedTime, optional float ExcessTime)
{
    //return;    
}

function SetOnArmAnimEndDelegate(delegate<OnArmAnimEnd> InDelegate, bool bLeftArm)
{
    //return;    
}

function ResetOnArmAnimEndDelegate(bool bLeftHand)
{
    //return;    
}

function EvilPawn GetPlayerPawn()
{
    //return ReturnValue;    
}

function EvilPlayerController GetPC()
{
    //return ReturnValue;    
}

function Weapon GetWeaponLeft()
{
    //return ReturnValue;    
}

function Weapon GetWeapon()
{
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: EvilCaptionComponent'Default__AdvPuzzle_Base.CaptionComp'
    begin object name=CaptionComp class=Class'EvilGame.EvilCaptionComponent'
        LocString="PuzzleExit"
        bVisible=false
    end object
    CaptionComponent=CaptionComp
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPuzzle_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: CylinderComponent'Default__AdvPuzzle_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=none
    Components[2]=CaptionComp
    Components[3]=MyLightEnvironment
    bEdShouldSnap=true
    CollisionComponent=CollisionCylinder
    SupportedEvents=/* Array type was not detected. */
}