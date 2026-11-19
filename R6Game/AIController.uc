class AIController extends Controller
    native
    notplaceable
    hidecategories(lighting);

var bool bHunting;
var bool bAdjustFromWalls;
var bool bReverseScriptedRoute;
var float Skill;
var Actor ScriptedMoveTarget;
var Route ScriptedRoute;
var int ScriptedRouteIndex;
var Actor ScriptedFocus;

event PreBeginPlay()
{
    PreBeginPlay();
    // End:0x12
    if(bDeleteMe)
    {
        return;
    }
    // End:0x44
    if(WorldInfo.Game != none)
    {
        Skill += WorldInfo.Game.GameDifficulty;
    }
    Skill = FClamp(Skill, 0.0000000, 3.0000000);
    return;
}

function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local int I;
    local string T;
    local Canvas Canvas;

    Canvas = HUD.Canvas;
    DisplayDebug(HUD, out_YL, out_YPos);
    // End:0x367
    if(HUD.ShouldDisplayDebug("AI"))
    {
        Canvas.DrawColor.B = byte(255);
        // End:0xFD
        if(((Pawn != none) && MoveTarget != none) && Pawn.ReachedDestination(MoveTarget))
        {
            Canvas.__NFUN_465__((((("     Skill " $ string(Skill)) $ " NAVIGATION MoveTarget ") $ (GetItemName(string(MoveTarget)))) $ "(REACHED) MoveTimer ") $ string(MoveTimer), false);            
        }
        else
        {
            Canvas.__NFUN_465__((((("     Skill " $ string(Skill)) $ " NAVIGATION MoveTarget ") $ (GetItemName(string(MoveTarget)))) $ " MoveTimer ") $ string(MoveTimer), false);
        }
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.__NFUN_465__((((("      Destination " $ string(Destination)) $ " Focus ") $ (GetItemName(string(Focus)))) $ " Preparing Move ") $ string(bPreparingMove), false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.__NFUN_465__((("     RouteGoal " $ (GetItemName(string(RouteGoal)))) $ " RouteDist ") $ string(RouteDist), false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        I = 0;
        J0x282:

        // End:0x31B [Loop If]
        if(I < RouteCache.Length)
        {
            // End:0x2DF
            if(RouteCache[I] == none)
            {
                // End:0x2D9
                if(I > 5)
                {
                    T = (T $ "--") $ (GetItemName(string(RouteCache[I - 1])));
                }
                // [Explicit Break]
                goto J0x31B;
                // [Explicit Continue]
                goto J0x311;
            }
            // End:0x311
            if(I < 5)
            {
                T = (T $ (GetItemName(string(RouteCache[I])))) $ "-";
            }
            J0x311:

            I++;
            // [Loop Continue]
            goto J0x282;
        }
        J0x31B:

        Canvas.__NFUN_465__("     RouteCache: " $ T, false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    return;
}

function AdjustView(float DeltaTime)
{
    local float TargetYaw, TargetPitch;
    local Rotator OldViewRotation, ViewRotation;

    AdjustView(DeltaTime);
    // End:0x22
    if(!Pawn.bUpdateEyeheight)
    {
        return;
    }
    ViewRotation = Rotation;
    OldViewRotation = Rotation;
    // End:0x211
    if(Enemy == none)
    {
        ViewRotation.Roll = 0;
        // End:0x211
        if(DeltaTime < 0.2000000)
        {
            OldViewRotation.Yaw = OldViewRotation.Yaw & 65535;
            OldViewRotation.Pitch = OldViewRotation.Pitch & 65535;
            TargetYaw = float(Rotation.Yaw & 65535);
            // End:0x105
            if(Abs(TargetYaw - float(OldViewRotation.Yaw)) > float(32768))
            {
                // End:0xF7
                if(TargetYaw < float(OldViewRotation.Yaw))
                {
                    TargetYaw += float(65536);                    
                }
                else
                {
                    TargetYaw -= float(65536);
                }
            }
            TargetYaw = (float(OldViewRotation.Yaw) * (float(1) - (float(5) * DeltaTime))) + ((TargetYaw * float(5)) * DeltaTime);
            ViewRotation.Yaw = int(TargetYaw);
            TargetPitch = float(Rotation.Pitch & 65535);
            // End:0x1BE
            if(Abs(TargetPitch - float(OldViewRotation.Pitch)) > float(32768))
            {
                // End:0x1B0
                if(TargetPitch < float(OldViewRotation.Pitch))
                {
                    TargetPitch += float(65536);                    
                }
                else
                {
                    TargetPitch -= float(65536);
                }
            }
            TargetPitch = (float(OldViewRotation.Pitch) * (float(1) - (float(5) * DeltaTime))) + ((TargetPitch * float(5)) * DeltaTime);
            ViewRotation.Pitch = int(TargetPitch);
            SetRotation(ViewRotation);
        }
    }
    return;
}

function SetOrders(name NewOrders, Controller OrderGiver)
{
    return;
}

function Actor GetOrderObject()
{
    return none;
    return;
}

function name GetOrders()
{
    return 'None';
    return;
}

function bool PriorityObjective()
{
    return false;
    return;
}

event SetTeam(int inTeamIdx)
{
    WorldInfo.Game.ChangeTeam(self, inTeamIdx, true);
    return;
}

function OnAIMoveToActor(SeqAct_AIMoveToActor Action)
{
    local Actor destActor;
    local SeqVar_Object ObjVar;

    ClearLatentAction(Class'SeqAct_AIMoveToActor', true, Action);
    // End:0x63
    foreach Action.LinkedVariables(Class'SeqVar_Object', ObjVar, "Destination")
    {
        destActor = Actor(ObjVar.ObjValue);
        // End:0x62
        if(destActor != none)
        {
            // End:0x63
            break;
        }        
    }    
    // End:0x17A
    if(destActor != none)
    {
        ScriptedRoute = Route(destActor);
        // End:0xFD
        if(ScriptedRoute != none)
        {
            // End:0xD9
            if(ScriptedRoute.MoveList.Length == 0)
            {
                WarnInternal("Invalid route with empty MoveList for scripted move");                
            }
            else
            {
                ScriptedRouteIndex = 0;
                // End:0xFA
                if(!IsInState('ScriptedRouteMove'))
                {
                    PushState('ScriptedRouteMove');
                }
            }            
        }
        else
        {
            ScriptedMoveTarget = destActor;
            // End:0x122
            if(!IsInState('ScriptedMove'))
            {
                PushState('ScriptedMove');
            }
        }
        ScriptedFocus = none;
        // End:0x176
        foreach Action.LinkedVariables(Class'SeqVar_Object', ObjVar, "Look At")
        {
            ScriptedFocus = Actor(ObjVar.ObjValue);
            // End:0x175
            if(ScriptedFocus != none)
            {
                // End:0x176
                break;
            }            
        }                
    }
    else
    {
        WarnInternal("Invalid destination for scripted move");
    }
    return;
}

state ScriptedMove
{
    function PoppedState()
    {
        // End:0x20
        if(ScriptedRoute == none)
        {
            ClearLatentAction(Class'SeqAct_AIMoveToActor', ScriptedMoveTarget == none);
        }
        ScriptedMoveTarget = none;
        return;
    }

    function PushedState()
    {
        // End:0x1B
        if(Pawn != none)
        {
            Pawn.SetMovementPhysics();
        }
        return;
    }
    J0x00:
    // End:0xAC [Loop If]
    if(((Pawn != none) && ScriptedMoveTarget != none) && !Pawn.ReachedDestination(ScriptedMoveTarget))
    {
        // End:0x52
        if(ActorReachable(ScriptedMoveTarget))
        {
            MoveToward(ScriptedMoveTarget, ScriptedFocus);            
        }
        else
        {
            MoveTarget = FindPathToward(ScriptedMoveTarget);
            // End:0x7F
            if(MoveTarget != none)
            {
                MoveToward(MoveTarget, ScriptedFocus);                
            }
            else
            {
                WarnInternal("Failed to find path to" @ string(ScriptedMoveTarget));
                ScriptedMoveTarget = none;
            }
        }
        // [Loop Continue]
        goto J0x00;
    }
    PopState();
    stop;                
}

state ScriptedRouteMove
{
    event PoppedState()
    {
        ClearLatentAction(Class'SeqAct_AIMoveToActor', ScriptedRoute == none);
        ScriptedRoute = none;
        return;
    }
    J0x00:
    // End:0xEE [Loop If]
    if((((Pawn != none) && ScriptedRoute != none) && ScriptedRouteIndex < ScriptedRoute.MoveList.Length) && ScriptedRouteIndex >= 0)
    {
        ScriptedMoveTarget = ScriptedRoute.MoveList[ScriptedRouteIndex];
        // End:0x71
        if(ScriptedMoveTarget != none)
        {
            PushState('ScriptedMove');
        }
        // End:0xC2
        if((Pawn != none) && Pawn.ReachedDestination(ScriptedRoute.MoveList[ScriptedRouteIndex]))
        {
            // End:0xB8
            if(bReverseScriptedRoute)
            {
                ScriptedRouteIndex--;                
            }
            else
            {
                ScriptedRouteIndex++;
            }            
        }
        else
        {
            WarnInternal("Aborting scripted route");
            ScriptedRoute = none;
            PopState();
        }
        // [Loop Continue]
        goto J0x00;
    }
    // End:0x184
    if((Pawn != none) && ScriptedRoute != none)
    {
        switch(ScriptedRoute.RouteType)
        {
            // End:0x125
            case 0:
                PopState();
                // End:0x181
                break;
            // End:0x142
            case 1:
                bReverseScriptedRoute = !bReverseScriptedRoute;
                goto 'Begin';
                // End:0x181
                break;
            // End:0x157
            case 2:
                ScriptedRouteIndex = 0;
                goto 'Begin';
                // End:0x181
                break;
            // End:0xFFFF
            default:
                WarnInternal("Unknown route type");
                ScriptedRoute = none;
                PopState();
                // End:0x181
                break;
                break;
        }        
    }
    else
    {
        ScriptedRoute = none;
        PopState();
    }
    WarnInternal("Reached end of state execution");
    ScriptedRoute = none;
    PopState();
    stop;    
}

defaultproperties
{
    bAdjustFromWalls=true
    bCanDoSpecial=true
    MinHitWall=-0.5000000
}