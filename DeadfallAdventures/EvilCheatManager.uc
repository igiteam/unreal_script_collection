class EvilCheatManager extends CheatManager within PlayerController
    config(Game);

var class<LocalMessage> LMC;
var SpeechRecognition RecogObject;
var DebugCameraController DebugCameraControllerRef;
var class<DebugCameraController> DebugCameraControllerClass;
var config string DebugCameraControllerClassName;
var transient bool bWeapSetPosMode;

function PatchDebugCameraController()
{
    local class<DebugCameraController> TempCameraControllerClass;

    // End:0x62
    if(DebugCameraControllerClassName != "")
    {
        TempCameraControllerClass = class<DebugCameraController>(DynamicLoadObject(DebugCameraControllerClassName, Class'Core.Class'));
        // End:0x62
        if(TempCameraControllerClass != none)
        {
            DebugCameraControllerClass = TempCameraControllerClass;
        }
    }
    //return;    
}

exec function ToggleDebugCamera(optional bool bDrawDebugText = true)
{
    local PlayerController PC;
    local DebugCameraController DCC;

    // End:0xED
    foreach Outer.WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0xEC
        if(PC.bIsPlayer && PC.IsLocalPlayerController())
        {
            DCC = DebugCameraController(PC);
            // End:0xE9
            if((DCC != none) && DCC.OriginalControllerRef == none)
            {
                continue;                
            }
            // End:0xED
            break;
        }        
    }    
    // End:0x168
    if((DCC != none) && DCC.OriginalControllerRef != none)
    {
        DCC.DisableDebugCamera();
        DCC.Destroy();
        DCC = none;        
    }
    else
    {
        // End:0x18B
        if(PC != none)
        {
            EnableDebugCamera(bDrawDebugText);
        }
    }
    //return;    
}

function EnableDebugCamera(bool bEnableDebugText)
{
    local Player P;
    local Vector eyeLoc;
    local Rotator eyeRot;
    local float CameraFOVAngle;

    P = Outer.Player;
    // End:0x366
    if(((P != none) && Outer.Pawn != none) && Outer.IsLocalPlayerController())
    {
        PatchDebugCameraController();
        // End:0xB2
        if(DebugCameraControllerRef != none)
        {
            DebugCameraControllerRef.Destroy();
        }
        CameraFOVAngle = Outer.GetFOVAngle();
        DebugCameraControllerRef = Outer.Spawn(DebugCameraControllerClass);
        DebugCameraControllerRef.PlayerInput = none;
        DebugCameraControllerRef.OriginalPlayer = P;
        DebugCameraControllerRef.OriginalControllerRef = Outer;
        Outer.GetPlayerViewPoint(eyeLoc, eyeRot);
        DebugCameraControllerRef.SetLocation(eyeLoc);
        DebugCameraControllerRef.SetRotation(eyeRot);
        DebugCameraControllerRef.bDrawDebugText = bEnableDebugText;
        P.SwitchController(DebugCameraControllerRef);
        DebugCameraControllerRef.OnActivate(Outer);
        DebugCameraControllerRef.GetPlayerViewPoint(eyeLoc, eyeRot);
        // End:0x33E
        if(DebugCameraControllerRef.PlayerCamera != none)
        {
            DebugCameraControllerRef.PlayerCamera.SetFOV(CameraFOVAngle);
            DebugCameraControllerRef.PlayerCamera.UpdateCamera(0.0000000);            
        }
        else
        {
            DebugCameraControllerRef.FOVAngle = CameraFOVAngle;
        }
    }
    //return;    
}

exec function ViewFlag()
{
    local AIController C;

    // End:0xFA
    foreach Outer.WorldInfo.AllControllers(Class'Engine.AIController', C)
    {
        // End:0xF9
        if((EvilPlayerReplicationInfo(C.PlayerReplicationInfo) != none) && EvilPlayerReplicationInfo(C.PlayerReplicationInfo).bHasFlag)
        {
            Outer.SetViewTarget(C.Pawn);            
            return;
        }        
    }    
    //return;    
}

exec function KillAllEnemyAIPawns()
{
    local EvilPawn P;
    local EvilPlayer_interface EPI;

    EPI = EvilPlayer_interface(Outer.Pawn);
    // End:0x53
    if(EqualEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
    {
        return;
    }
    // End:0x155
    foreach Outer.DynamicActors(Class'EvilPawn', P)
    {
        // End:0x154
        if(!P.IsPlayerPawn() && !EPI.GetPlayerPawn().IsSameTeam(P))
        {
            // End:0x13C
            if(P.Controller != none)
            {
                P.Controller.Destroy();
            }
            P.Destroy();
        }        
    }    
    //return;    
}

exec function Glow(float F)
{
    local EvilVehicle_Base V;

    // End:0x8D
    foreach Outer.DynamicActors(Class'EvilVehicle_Base', V)
    {
        V.LightEnvironment.AmbientGlow = MakeLinearColor(F, F, F, 1.0000000);        
    }    
    //return;    
}

exec function LM(string MessageClassName)
{
    LMC = class<LocalMessage>(DynamicLoadObject(MessageClassName, Class'Core.Class'));
    //return;    
}

exec function LMS(int Switch)
{
    Outer.ReceiveLocalizedMessage(LMC, Switch, Outer.PlayerReplicationInfo, Outer.PlayerReplicationInfo);
    //return;    
}

exec function SummonV(string ClassName)
{
    local class<Actor> NewClass;
    local Vector SpawnLoc;

    NewClass = class<Actor>(DynamicLoadObject("EvilGameContent.EvilVehicle_" $ ClassName, Class'Core.Class'));
    // End:0xBB
    if(NewClass == none)
    {
        NewClass = class<Actor>(DynamicLoadObject(("EvilGameContent.EvilVehicle_" $ ClassName) $ "_Content", Class'Core.Class'));
    }
    // End:0x1C9
    if(NewClass != none)
    {
        // End:0x12E
        if(Outer.Pawn != none)
        {
            SpawnLoc = Outer.Pawn.Location;            
        }
        else
        {
            SpawnLoc = Outer.Location;
        }
        Outer.Spawn(NewClass,,, (SpawnLoc + (float(72) * Vector(Outer.Rotation))) + (vect(0.0000000, 0.0000000, 1.0000000) * float(15)));
    }
    //return;    
}

exec function TeleportToPlayerStart(int Index)
{
    local PlayerStart PlayerStart;
    local int I;

    // End:0xBA
    foreach Outer.WorldInfo.AllNavigationPoints(Class'Engine.PlayerStart', PlayerStart)
    {
        // End:0xAE
        if(Index == I)
        {
            Outer.ViewTarget.SetLocation(PlayerStart.Location);
            // End:0xBA
            break;
        }
        I++;        
    }    
    //return;    
}

exec function SummonOtherPlayers()
{
    local int tries;
    local Vector pos;
    local PlayerController PC;

    // End:0x388
    foreach Outer.WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x387
        if((PC != Outer) && PC.Pawn != none)
        {
            tries = 0;
            J0x91:

            // End:0x290 [Loop If]
            if(tries < 10)
            {
                pos = Outer.Pawn.Location + (Normal(VRand() * vect(1.0000000, 1.0000000, 0.0000000)) * ((PC.Pawn.CylinderComponent.CollisionRadius + Outer.Pawn.CylinderComponent.CollisionRadius) + 10.0000000));
                // End:0x282
                if(PC.Pawn.FindSpot((vect(1.0000000, 1.0000000, 0.0000000) * PC.Pawn.CylinderComponent.CollisionRadius) + (vect(0.0000000, 0.0000000, 1.0000000) * PC.Pawn.CylinderComponent.CollisionHeight), pos))
                {
                    // [Explicit Break]
                    goto J0x290;
                }
                ++tries;
                // [Loop Continue]
                goto J0x91;
            }
            J0x290:

            // End:0x30D
            if(tries < 10)
            {
                PC.Pawn.ZeroMovementVariables();
                PC.Pawn.SetLocation(pos);
                // End:0x387
                continue;
            }
            Outer.myHUD.AddConsoleMessage("Could not find a spot to teleport player" @ string(PC), Class'Engine.LocalMessage', none, 3.0000000);
        }        
    }    
    //return;    
}

exec function AILogOn()
{
    local GameAIController GAIC;

    // End:0x8C
    foreach Outer.WorldInfo.AllControllers(Class'GameFramework.GameAIController', GAIC)
    {
        GAIC.bAILogging = true;
        GAIC.bAILogToWindow = true;        
    }    
    //return;    
}

exec function AllWeapons()
{
    //return;    
}

exec function GiveNext(int invGroup)
{
    //return;    
}

exec function AddOneKillPerk()
{
    //return;    
}

exec function DemoWeapons()
{
    //return;    
}

exec function DoubleUp()
{
    //return;    
}

exec function PhysicsGun()
{
    // End:0x4A
    if(Outer.Pawn != none)
    {
        GiveWeapon("EvilGame.UTWeap_PhysicsGun");
    }
    //return;    
}

exec function AllAmmo()
{
    // End:0x10F
    if((Outer.Pawn != none) && EvilInventoryManager(Outer.Pawn.InvManager) != none)
    {
        EvilInventoryManager(Outer.Pawn.InvManager).AllAmmo(true);
        EvilInventoryManager(Outer.Pawn.InvManager).bInfiniteAmmo = true;
    }
    //return;    
}

exec function Invisible(bool B)
{
    // End:0x74
    if(UTPawn(Outer.Pawn) != none)
    {
        UTPawn(Outer.Pawn).SetInvisible(B);
    }
    //return;    
}

exec function FreeCamera()
{
    UTPlayerController(Outer).bFreeCamera = !UTPlayerController(Outer).bFreeCamera;
    UTPlayerController(Outer).SetBehindView(UTPlayerController(Outer).bFreeCamera);
    //return;    
}

exec function ViewBot()
{
    local Controller first;
    local bool bFound;
    local AIController C;

    // End:0x122
    foreach Outer.WorldInfo.AllControllers(Class'Engine.AIController', C)
    {
        // End:0x121
        if((C.Pawn != none) && C.PlayerReplicationInfo != none)
        {
            // End:0xD4
            if(bFound || first == none)
            {
                first = C;
                // End:0xD4
                if(bFound)
                {
                    // End:0x122
                    break;
                }
            }
            // End:0x121
            if(C.PlayerReplicationInfo == Outer.RealViewTarget)
            {
                bFound = true;
            }
        }        
    }    
    // End:0x1D0
    if(first != none)
    {
        Outer.SetViewTarget(first);
        UTPlayerController(Outer).SetBehindView(true);
        UTPlayerController(Outer).bFreeCamera = true;
        Outer.FixFOV();        
    }
    else
    {
        ViewSelf(true);
    }
    //return;    
}

exec function KillBadGuys()
{
    local PlayerController PC;
    local UTPawn P;

    PC = UTPlayerController(Outer);
    // End:0x172
    if(PC != none)
    {
        // End:0x171
        foreach Outer.DynamicActors(Class'UTPawn', P)
        {
            // End:0x170
            if(!Outer.WorldInfo.GRI.OnSameTeam(P, PC) && (PC.Pawn != none) && PC.Pawn != P)
            {
                P.TakeDamage(20000, PC, P.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilDmgType_Base');
            }            
        }        
    }
    //return;    
}

exec function RBGrav(float NewGravityScaling)
{
    Outer.WorldInfo.RBPhysicsGravityScaling = NewGravityScaling;
    //return;    
}

exec function SuicideBy(string Type, optional int DeathHealth)
{
    local class<DamageType> DamageType;

    // End:0x247
    if(Outer.Pawn != none)
    {
        // End:0x60
        if(InStr(Type, ".") == -1)
        {
            Type = "EvilGame." $ Type;
        }
        DamageType = class<DamageType>(DynamicLoadObject(Type, Class'Core.Class'));
        // End:0x247
        if(DamageType != none)
        {
            Outer.Pawn.Health = DeathHealth;
            // End:0x1CE
            if(Outer.Pawn.IsA('UTPawn'))
            {
                UTPawn(Outer.Pawn).AccumulateDamage = float(-DeathHealth);
                UTPawn(Outer.Pawn).AccumulationTime = Outer.WorldInfo.TimeSeconds;
            }
            Outer.Pawn.Died(Outer, DamageType, Outer.Pawn.Location);
        }
    }
    //return;    
}

exec function EditWeapon(string WhichWeapon)
{
    local EvilWeap_Base Weapon;
    local array<string> weaps;
    local string S;
    local int I;

    // End:0x59
    if(WhichWeapon != "")
    {        
        Outer.ConsoleCommand("Editactor class=" $ WhichWeapon);        
    }
    else
    {
        // End:0x10B
        foreach Outer.AllActors(Class'EvilWeap_Base', Weapon)
        {
            S = "" $ string(Weapon.Class);
            // End:0x10A
            if(weaps.Find(S) < )
            {                
                weaps.Length = weaps.Length + 1;
                weaps[weaps.Length - 1] = S;
            }            
        }        
        I = 0;
        J0x117:

        // End:0x13D [Loop If]
        if(I < weaps.Length)
        {
            I++;
            // [Loop Continue]
            goto J0x117;
        }
    }
    //return;    
}

exec function SpawnABloodDecal()
{
    LeaveADecal(Outer.Pawn.Location, vect(0.0000000, 0.0000000, 0.0000000));
    //return;    
}

simulated function LeaveADecal(Vector HitLoc, Vector HitNorm)
{
    local MaterialInstance MIC_Decal;
    local Actor TraceActor;
    local Vector out_HitLocation, out_HitNormal, TraceDest, TraceStart, TraceExtent;

    local TraceHitInfo HitInfo;

    TraceStart = HitLoc + vect(0.0000000, 0.0000000, 15.0000000);
    TraceDest = HitLoc - vect(0.0000000, 0.0000000, 100.0000000);
    /* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
        
    */

    /*@Error*/;
}

exec function TiltIt(bool bActive)
{
    Outer.SetControllerTiltActive(bActive);
    //return;    
}

exec function ShowStickBindings()
{
    local int BindIndex;

    BindIndex = 0;
    J0x0B:

    // End:0x239 [Loop If]
    if(BindIndex < Outer.PlayerInput.Bindings.Length)
    {
        // End:0x22B
        if(((((Outer.PlayerInput.Bindings[BindIndex].Name == 'XboxTypeS_LeftX') || Outer.PlayerInput.Bindings[BindIndex].Name == 'XboxTypeS_LeftY') || Outer.PlayerInput.Bindings[BindIndex].Name == 'XboxTypeS_RightX') || Outer.PlayerInput.Bindings[BindIndex].Name == 'XboxTypeS_RightY') || Outer.PlayerInput.Bindings[BindIndex].Name == 'GBA_Look_Gamepad')
        {
        }
        ++BindIndex;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

exec function SetStickBind(float val)
{
    local int BindIndex;
    local string Cmd;

    BindIndex = 0;
    J0x0B:

    // End:0x1B0 [Loop If]
    if(BindIndex < Outer.PlayerInput.Bindings.Length)
    {
        // End:0x1A2
        if((Outer.PlayerInput.Bindings[BindIndex].Name == 'XboxTypeS_RightY') || Outer.PlayerInput.Bindings[BindIndex].Name == 'GBA_Look_Gamepad')
        {
            Cmd = ("Axis aLookup Speed=" $ string(val)) $ " DeadZone=0.3";
            Outer.PlayerInput.Bindings[BindIndex].Command = Cmd;
        }
        ++BindIndex;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

exec function KillAll(class<Actor> aClass)
{
    local Actor A;
    local PlayerController PC;

    // End:0x85
    foreach Outer.WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        PC.ClientMessage("Killed all " $ string(aClass));        
    }    
    // End:0xA0
    if(ClassIsChildOf(aClass, Class'Engine.AIController'))
    {
        return;
    }
    // End:0xBA
    if(ClassIsChildOf(aClass, Class'Engine.Pawn'))
    {
        return;
    }
    // End:0x12E
    foreach Outer.DynamicActors(Class'Engine.Actor', A)
    {
        // End:0x12D
        if(ClassIsChildOf(A.Class, aClass))
        {
            A.Destroy();
        }        
    }    
    //return;    
}

function KillAllPawns(class<Pawn> aClass)
{
    local Pawn P;

    // End:0xEB
    foreach Outer.DynamicActors(Class'Engine.Pawn', P)
    {
        // End:0xEA
        if(ClassIsChildOf(P.Class, aClass) && !P.IsPlayerPawn())
        {
            // End:0xD2
            if(P.Controller != none)
            {
                P.Controller.Destroy();
            }
            P.Destroy();
        }        
    }    
    //return;    
}

exec function GiveNextTest(int invGroup)
{
    GiveNext(invGroup);
    Outer.ClientMessage(("Giving next group [" $ string(invGroup)) $ "]");
    //return;    
}

exec function Evilution()
{
    God();
    // End:0xEA
    if(EvilInventoryManager(Outer.Pawn.InvManager).bInfiniteAmmo)
    {
        EvilInventoryManager(Outer.Pawn.InvManager).bInfiniteAmmo = false;
        Outer.ClientMessage("Infinite ammo OFF");        
    }
    else
    {
        EvilInventoryManager(Outer.Pawn.InvManager).bInfiniteAmmo = true;
        Outer.ClientMessage("Infinite ammo ON");
    }
    //return;    
}

exec function DetachFromRailCar()
{
    // End:0x6A
    if((Outer.Pawn == none) || EvilRailCar_Base(Outer.Pawn.Base) == none)
    {
        return;
    }
    EvilRailCar_Base(Outer.Pawn.Base).DetachPawn(((Outer.Pawn.IsA('EvilPawn')) ? EvilPawn(Outer.Pawn) : EvilPawn(Vehicle(Outer.Pawn).Driver)));
    //return;    
}

exec function HitMe(optional int Amount = 10)
{
    local EvilPlayer_interface EPI;

    EPI = EvilPlayerController(Outer).GetPlayer();
    // End:0xE3
    if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
    {
        EPI.GetPlayerPawn().TakeDamage(Amount, none, Outer.Pawn.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilDmgType_Base');
    }
    //return;    
}

exec function Step(optional float Amount = 0.0010000)
{
    // End:0x83
    if(Outer.WorldInfo.bPlayersOnly || Outer.WorldInfo.bPlayersOnlyPending)
    {
        PlayersOnly();
    }
    Outer.SetTimer(Amount, false, 'PlayersOnly', self);
    //return;    
}

exec function Behave(string Mode)
{
    local EvilTypesNative.EBehaviorMode bm;
    local string S;
    local Vector POV, HitLoc, HitNorm;
    local Rotator Rot;
    local EvilPawn P;

    bm = 0;
    J0x0C:

    // End:0x7A [Loop If]
    if(int(bm) < int(4))
    {
        S = string(bm);
        // End:0x5A
        if(Locs(S) == Locs("BM_" $ Mode))
        {
            // [Explicit Break]
            goto J0x7A;
        }
        bm = byte(int(bm) + int(1));
        // [Loop Continue]
        goto J0x0C;
    }
    J0x7A:

    // End:0x90
    if(int(bm) >= int(4))
    {
        return;
    }
    Outer.GetPlayerViewPoint(POV, Rot);
    P = EvilPawn(Outer.Trace(HitLoc, HitNorm, POV + (Vector(Rot) * float(16384)), POV, true));
    // End:0x13B
    if(P == none)
    {
        return;
    }
    // End:0x16A
    if(EvilAIController(P.Controller) == none)
    {
        return;
    }
    EvilAIController(P.Controller).ChangeBehaviorMode(bm);
    //return;    
}

exec function SlomoNonPlayers(float T)
{
    local PlayerController PC;

    Outer.WorldInfo.Game.SetGameSpeed(T);
    // End:0x141
    foreach Outer.WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        PC.CustomTimeDilation = 1.0000000 / T;
        // End:0x140
        if(PC.Pawn != none)
        {
            PC.Pawn.CustomTimeDilation = PC.CustomTimeDilation;
        }        
    }    
    //return;    
}

exec function ForceCompatLevel(int CompatLevel)
{
    local EvilEngine Engine;

    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    Engine.ResetVideoSetting(CompatLevel);
    //return;    
}

exec function SetAA(int Level)
{
    local EvilLocalPlayer LP;
    local UberPostProcessEffect UPE;

    LP = EvilLocalPlayer(Outer.Player);
    // End:0x1ED
    if(LP != none)
    {
        UPE = LP.GetPPManager().FindUberPostProcess();
        // End:0x1ED
        if(UPE != none)
        {
            switch(Level)
            {
                // End:0xC9
                case 0:
                    UPE.PostProcessAAType = 0;
                    // End:0x1EA
                    break;
                // End:0xF1
                case 1:
                    UPE.PostProcessAAType = 1;
                    // End:0x1EA
                    break;
                // End:0x11A
                case 2:
                    UPE.PostProcessAAType = 2;
                    // End:0x1EA
                    break;
                // End:0x143
                case 3:
                    UPE.PostProcessAAType = 3;
                    // End:0x1EA
                    break;
                // End:0x16C
                case 4:
                    UPE.PostProcessAAType = 4;
                    // End:0x1EA
                    break;
                // End:0x195
                case 5:
                    UPE.PostProcessAAType = 5;
                    // End:0x1EA
                    break;
                // End:0x1BE
                case 6:
                    UPE.PostProcessAAType = 6;
                    // End:0x1EA
                    break;
                // End:0x1E7
                case 7:
                    UPE.PostProcessAAType = 7;
                    // End:0x1EA
                    break;
                // End:0xFFFF
                default:
                    break;
            }            
        }
    }
    //return;    
}

exec function SetTextureQuality(int Level)
{
    local EvilEngine Engine;

    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    Engine.SetTextureQuality(Level);
    Engine.UpdateVideoSettings();
    //return;    
}

exec function SetShadowQuality(int Level)
{
    local EvilEngine Engine;

    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    Engine.SetShadowQuality(Level);
    Engine.UpdateVideoSettings();
    //return;    
}

exec function SetGeometryQuality(int Level)
{
    local EvilEngine Engine;

    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    Engine.SetGeometryQuality(Level);
    Engine.UpdateVideoSettings();
    //return;    
}

exec function SetLightingQuality(int Level)
{
    local EvilEngine Engine;

    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    Engine.SetLightingQuality(Level);
    Engine.UpdateVideoSettings();
    //return;    
}

exec function SetEffectsQuality(int Level)
{
    local EvilEngine Engine;

    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    Engine.SetEffectsQuality(Level);
    Engine.UpdateVideoSettings();
    //return;    
}

exec function SetPostprocessQuality(int Level)
{
    local EvilEngine Engine;

    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    Engine.SetPostprocessQuality(Level);
    Engine.UpdateVideoSettings();
    //return;    
}

exec function SetVSync(bool bEnabled)
{
    local EvilEngine Engine;

    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    Engine.SetVSync(bEnabled);
    Engine.UpdateVideoSettings();
    //return;    
}

exec function SetFramerateSmoothing(bool bEnabled)
{
    local EvilEngine Engine;

    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    Engine.SetFramerateSmoothing(bEnabled);
    //return;    
}

exec function WeaponPosEditor()
{
    // End:0x3C
    if(bWeapSetPosMode)
    {
        bWeapSetPosMode = false;
        Outer.PopState();        
    }
    else
    {
        bWeapSetPosMode = true;
        Outer.PushState('WeaponSetPosMode');
    }
    //return;    
}

defaultproperties
{
    DebugCameraControllerClass=Class'EvilDebugCameraController'
    DebugCameraControllerClassName="EvilGame.EvilDebugCameraController"
}