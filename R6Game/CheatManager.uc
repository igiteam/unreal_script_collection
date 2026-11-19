class CheatManager extends Object within PlayerController
    native;

exec function ListDynamicActors()
{
    local Actor A;
    local int I;

    // End:0x35
    foreach Outer.DynamicActors(Class'Actor', A)
    {
        I++;
        LogInternal(string(I) @ string(A));        
    }    
    LogInternal("Num dynamic actors: " $ string(I));
    return;
}

exec function FreezeFrame(float delay)
{
    Outer.WorldInfo.Game.SetPause(true, Outer);
    Outer.WorldInfo.PauseDelay = Outer.WorldInfo.TimeSeconds + delay;
    return;
}

exec function WriteToLog(string Param)
{
    LogInternal("NOW! " $ Param);
    return;
}

exec function KillViewedActor()
{
    // End:0x9C
    if(Outer.ViewTarget != none)
    {
        // End:0x74
        if((Pawn(Outer.ViewTarget) != none) && Pawn(Outer.ViewTarget).Controller != none)
        {
            Pawn(Outer.ViewTarget).Controller.Destroy();
        }
        Outer.ViewTarget.Destroy();
        Outer.SetViewTarget(none);
    }
    return;
}

exec function Teleport()
{
    local Actor HitActor;
    local Vector HitNormal, HitLocation, ViewLocation;
    local Rotator ViewRotation;

    Outer.GetPlayerViewPoint(ViewLocation, ViewRotation);
    HitActor = Outer.Trace(HitLocation, HitNormal, ViewLocation + (float(1000000) * Vector(ViewRotation)), ViewLocation, true);
    // End:0x74
    if(HitActor != none)
    {
        HitLocation += (HitNormal * 4.0000000);
    }
    Outer.ViewTarget.SetLocation(HitLocation);
    return;
}

exec function ChangeSize(float F)
{
    Outer.Pawn.CylinderComponent.SetSize(Outer.Pawn.default.CylinderComponent.CollisionHeight * F, Outer.Pawn.default.CylinderComponent.CollisionRadius * F);
    Outer.Pawn.SetDrawScale(F);
    Outer.Pawn.SetLocation(Outer.Pawn.Location);
    return;
}

exec function EndPath()
{
    return;
}

exec function Amphibious()
{
    Outer.Pawn.UnderWaterTime = 999999.0000000;
    return;
}

exec function Fly()
{
    // End:0x7F
    if((Outer.Pawn != none) && Outer.Pawn.CheatFly())
    {
        Outer.ClientMessage("You feel much lighter");
        Outer.bCheatFlying = true;
        Outer.GotoState('PlayerFlying');
    }
    return;
}

exec event Walk()
{
    Outer.bCheatFlying = false;
    // End:0x74
    if((Outer.Pawn != none) && Outer.Pawn.CheatWalk())
    {
        Outer.GotoState('PlayerWalking');
        Outer.ClientRestart(Outer.Pawn);
    }
    return;
}

exec event Ghost()
{
    // End:0x59
    if((Outer.Pawn != none) && Outer.Pawn.CheatGhost())
    {
        Outer.bCheatFlying = true;
        Outer.GotoState('PlayerFlying');        
    }
    else
    {
        Outer.bCollideWorld = false;
    }
    Outer.ClientMessage("You feel ethereal");
    return;
}

exec event ToggleGhost()
{
    // End:0x37
    if(Outer.Pawn != none)
    {
        // End:0x30
        if(Outer.bCheatFlying)
        {
            Walk();            
        }
        else
        {
            Ghost();
        }
    }
    return;
}

exec function AllAmmo()
{
    return;
}

exec function Invisible(bool B)
{
    Outer.Pawn.bHidden = B;
    // End:0x45
    if(B)
    {
        Outer.Pawn.Visibility = 0;        
    }
    else
    {
        Outer.Pawn.Visibility = Outer.Pawn.default.Visibility;
    }
    return;
}

exec event God()
{
    // End:0x45
    if(Outer.bGodMode)
    {
        Outer.bGodMode = false;
        Outer.ClientMessage("God mode off");
        return;
    }
    Outer.bGodMode = true;
    Outer.ClientMessage("God Mode on");
    return;
}

exec function SloMo(float T)
{
    Outer.WorldInfo.Game.SetGameSpeed(T);
    Outer.WorldInfo.Game.SaveConfig();
    Outer.WorldInfo.Game.GameReplicationInfo.SaveConfig();
    return;
}

exec function SetJumpZ(float F)
{
    Outer.Pawn.JumpZ = F;
    return;
}

exec function SetGravity(float F)
{
    Outer.WorldInfo.WorldGravityZ = F;
    return;
}

exec function SetSpeed(float F)
{
    Outer.Pawn.GroundSpeed = Outer.Pawn.default.GroundSpeed * F;
    Outer.Pawn.WaterSpeed = Outer.Pawn.default.WaterSpeed * F;
    return;
}

exec function KillAll(class<Actor> aClass)
{
    local Actor A;
    local PlayerController PC;

    // End:0x4E
    foreach Outer.WorldInfo.AllControllers(Class'PlayerController', PC)
    {
        PC.ClientMessage("Killed all " $ string(aClass));        
    }    
    // End:0x83
    if(ClassIsChildOf(aClass, Class'AIController'))
    {
        Outer.WorldInfo.Game.KillBots();
        return;
    }
    // End:0xA6
    if(ClassIsChildOf(aClass, Class'Pawn'))
    {
        KillAllPawns(class<Pawn>(aClass));
        return;
    }
    // End:0xE5
    foreach Outer.DynamicActors(Class'Actor', A)
    {
        // End:0xE4
        if(ClassIsChildOf(A.Class, aClass))
        {
            A.Destroy();
        }        
    }    
    return;
}

function KillAllPawns(class<Pawn> aClass)
{
    local Pawn P;

    Outer.WorldInfo.Game.KillBots();
    // End:0xA1
    foreach Outer.DynamicActors(Class'Pawn', P)
    {
        // End:0xA0
        if(ClassIsChildOf(P.Class, aClass) && !P.IsPlayerPawn())
        {
            // End:0x94
            if(P.Controller != none)
            {
                P.Controller.Destroy();
            }
            P.Destroy();
        }        
    }    
    return;
}

exec function KillPawns()
{
    KillAllPawns(Class'Pawn');
    return;
}

exec function Avatar(name ClassName)
{
    local Pawn TargetPawn, FirstPawn, OldPawn;
    local bool bPickNextPawn;

    // End:0x72
    foreach Outer.DynamicActors(Class'Pawn', TargetPawn)
    {
        // End:0x3C
        if(TargetPawn == Outer.Pawn)
        {
            bPickNextPawn = true;
            // End:0x71
            continue;
        }
        // End:0x71
        if(TargetPawn.IsA(ClassName))
        {
            // End:0x65
            if(FirstPawn == none)
            {
                FirstPawn = TargetPawn;
            }
            // End:0x71
            if(bPickNextPawn)
            {
                // End:0x72
                break;
            }
        }        
    }    
    // End:0x89
    if(TargetPawn == none)
    {
        TargetPawn = FirstPawn;
    }
    // End:0xFC
    if(TargetPawn != none)
    {
        TargetPawn.DetachFromController(true);
        OldPawn = Outer.Pawn;
        Outer.Pawn.DetachFromController();
        Outer.Possess(TargetPawn, false);
        OldPawn.SpawnDefaultController();        
    }
    else
    {
        LogInternal(("Avatar: Couldn't find any Pawn to possess of class '" $ string(ClassName)) $ "'");
    }
    return;
}

exec function Summon(string ClassName)
{
    local class<Actor> NewClass;
    local Vector SpawnLoc;

    LogInternal("Fabricate " $ ClassName);
    NewClass = class<Actor>(DynamicLoadObject(ClassName, Class'Core.Class'));
    // End:0xCE
    if(NewClass != none)
    {
        // End:0x72
        if(Outer.Pawn != none)
        {
            SpawnLoc = Outer.Pawn.Location;            
        }
        else
        {
            SpawnLoc = Outer.Location;
        }
        Outer.__NFUN_278__(NewClass,,, (SpawnLoc + (float(72) * Vector(Outer.Rotation))) + (vect(0.0000000, 0.0000000, 1.0000000) * float(15)));
    }
    return;
}

function Weapon GiveWeapon(string WeaponClassStr)
{
    local Weapon Weap;
    local class<Weapon> WeaponClass;

    WeaponClass = class<Weapon>(DynamicLoadObject(WeaponClassStr, Class'Core.Class'));
    Weap = Weapon(Outer.Pawn.FindInventoryType(WeaponClass));
    // End:0x55
    if(Weap != none)
    {
        return Weap;
    }
    return Weapon(Outer.Pawn.CreateInventory(WeaponClass));
    return;
}

exec function PlayersOnly()
{
    Outer.WorldInfo.bPlayersOnly = !Outer.WorldInfo.bPlayersOnly;
    return;
}

exec function RememberSpot()
{
    // End:0x3D
    if(Outer.Pawn != none)
    {
        Outer.Destination = Outer.Pawn.Location;        
    }
    else
    {
        Outer.Destination = Outer.Location;
    }
    return;
}

exec function ViewSelf(optional bool bQuiet)
{
    Outer.ResetCameraMode();
    // End:0x48
    if(Outer.Pawn != none)
    {
        Outer.SetViewTarget(Outer.Pawn);        
    }
    else
    {
        Outer.SetViewTarget(Outer);
    }
    // End:0x8E
    if(!bQuiet)
    {
        Outer.ClientMessage(Outer.OwnCamera, 'Event');
    }
    Outer.FixFOV();
    return;
}

exec function ViewPlayer(string S)
{
    local Controller P;

    // End:0x74
    foreach Outer.WorldInfo.AllControllers(Class'Controller', P)
    {
        // End:0x73
        if((P.bIsPlayer && P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo.PlayerName ~= S)
        {
            // End:0x74
            break;
        }        
    }    
    // End:0xE6
    if(P.Pawn != none)
    {
        Outer.ClientMessage(Outer.ViewingFrom @ P.PlayerReplicationInfo.PlayerName, 'Event');
        Outer.SetViewTarget(P.Pawn);
    }
    return;
}

exec function ViewActor(name ActorName)
{
    local Actor A;

    // End:0x61
    foreach Outer.AllActors(Class'Actor', A)
    {
        // End:0x60
        if(A.Name == ActorName)
        {
            Outer.SetViewTarget(A);
            Outer.SetCameraMode('ThirdPerson');            
            return;
        }        
    }    
    return;
}

exec function ViewFlag()
{
    local AIController C;

    // End:0x7A
    foreach Outer.WorldInfo.AllControllers(Class'AIController', C)
    {
        // End:0x79
        if((C.PlayerReplicationInfo != none) && C.PlayerReplicationInfo.bHasFlag)
        {
            Outer.SetViewTarget(C.Pawn);            
            return;
        }        
    }    
    return;
}

exec function ViewBot()
{
    local Actor first;
    local bool bFound;
    local AIController C;

    // End:0xA6
    foreach Outer.WorldInfo.AllControllers(Class'AIController', C)
    {
        // End:0xA5
        if((C.Pawn != none) && C.PlayerReplicationInfo != none)
        {
            // End:0x7C
            if(bFound || first == none)
            {
                first = C;
                // End:0x7C
                if(bFound)
                {
                    // End:0xA6
                    break;
                }
            }
            // End:0xA5
            if(C.PlayerReplicationInfo == Outer.RealViewTarget)
            {
                bFound = true;
            }
        }        
    }    
    // End:0x105
    if(first != none)
    {
        LogInternal("view " $ string(first));
        Outer.SetViewTarget(first);
        Outer.SetCameraMode('ThirdPerson');
        Outer.FixFOV();        
    }
    else
    {
        ViewSelf(true);
    }
    return;
}

exec function ViewClass(class<Actor> aClass)
{
    local Actor other, first;
    local bool bFound;

    first = none;
    // End:0x6E
    foreach Outer.AllActors(aClass, other)
    {
        // End:0x4D
        if(bFound || first == none)
        {
            first = other;
            // End:0x4D
            if(bFound)
            {
                // End:0x6E
                break;
            }
        }
        // End:0x6D
        if(other == Outer.ViewTarget)
        {
            bFound = true;
        }        
    }    
    // End:0x11A
    if(first != none)
    {
        // End:0xC3
        if(Pawn(first) != none)
        {
            Outer.ClientMessage(Outer.ViewingFrom @ first.GetHumanReadableName(), 'Event');            
        }
        else
        {
            Outer.ClientMessage(Outer.ViewingFrom @ string(first), 'Event');
        }
        Outer.SetViewTarget(first);
        Outer.FixFOV();        
    }
    else
    {
        ViewSelf(false);
    }
    return;
}

exec function Loaded()
{
    // End:0x24
    if(int(Outer.WorldInfo.NetMode) != int(NM_Standalone))
    {
        return;
    }
    AllWeapons();
    AllAmmo();
    return;
}

exec function AllWeapons()
{
    return;
}
