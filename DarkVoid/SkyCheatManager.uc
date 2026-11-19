class SkyCheatManager extends CheatManager within PlayerController
    native;

struct native StatsListEntry
{
    var Actor EntryActor;
    var float EntryRatio;

    structdefaultproperties
    {
        EntryActor=none
        EntryRatio=0.0000000
    }
};

var transient bool bInfiniteStamina;
var transient bool bCameraOnly;
var transient Actor.EPhysics SavedPhysicsMode;
var transient byte SavedbLockMoveInput;

// Export USkyCheatManager::execGetGameEngine(FFrame&, void* const)
native final function GameEngine GetGameEngine();

exec function ToggleCoverSearchOpt()
{
    local SkyPawnCoverUser SPCU;

    SPCU = SkyPawnCoverUser(Outer.Pawn);
    // End:0x48
    if(SPCU != none)
    {
        SPCU.bUseCoverSearchOptimization = !SPCU.bUseCoverSearchOptimization;
    }
    //return;    
}

exec function SuperWeapon()
{
    local int I;

    // End:0x21
    if(Outer.Pawn.Weapon == none)
    {
        return;
    }
    I = 0;
    J0x28:

    // End:0x8F [Loop If]
    if(I < Outer.Pawn.Weapon.InstantHitDamage.Length)
    {
        Outer.Pawn.Weapon.InstantHitDamage[I] += float(200);
        ++I;
        // [Loop Continue]
        goto J0x28;
    }
    //return;    
}

exec function ToggleTracer()
{
    // End:0x26
    if(SkyWeapon(Outer.Pawn.Weapon) == none)
    {
        return;
    }
    SkyWeapon(Outer.Pawn.Weapon).bTracerEffectsOnly = !SkyWeapon(Outer.Pawn.Weapon).bTracerEffectsOnly;
    //return;    
}

exec function ToggleCacheTrace()
{
    // End:0x5B
    if(SkyPawn(Outer.Pawn) != none)
    {
        SkyPawn(Outer.Pawn).bCacheInstantHitTrace = !SkyPawn(Outer.Pawn).bCacheInstantHitTrace;
    }
    //return;    
}

exec function HurtMe(int HealthPercentage)
{
    local int DamageAmount, TargetHealth;

    TargetHealth = int((float(HealthPercentage) / 100.0000000) * float(Outer.Pawn.default.Health));
    DamageAmount = Outer.Pawn.Health - TargetHealth;
    // End:0x11A
    if(DamageAmount != 0)
    {
        // End:0xA2
        if(SkyPawn(Outer.Pawn) != none)
        {
            SkyPawn(Outer.Pawn).HealthAutoRegenRate = 0.0000000;
        }
        // End:0xF3
        if(DamageAmount > 0)
        {
            Outer.Pawn.TakeDamage(DamageAmount, none, Outer.Location, vect(0.0000000, 0.0000000, 0.0000000), none);            
        }
        else
        {
            Outer.Pawn.HealDamage(-DamageAmount, none, none);
        }
    }
    //return;    
}

exec function CameraOnly()
{
    bCameraOnly = !bCameraOnly;
    Outer.WorldInfo.bPlayersOnly = bCameraOnly;
    Outer.Pawn.Mesh.bPauseAnims = bCameraOnly;
    // End:0x169
    if(bCameraOnly)
    {
        SavedPhysicsMode = Outer.Pawn.Physics;
        Outer.Pawn.SetPhysics(7);
        // End:0xFF
        if(SkeletalMeshComponent(Outer.Pawn.Weapon.Mesh) != none)
        {
            SkeletalMeshComponent(Outer.Pawn.Weapon.Mesh).bPauseAnims = true;
        }
        Outer.Pawn.StopFire(0);
        Outer.Pawn.StopFire(1);
        SavedbLockMoveInput = Outer.bLockMoveInput;
        Outer.bLockMoveInput = 0;        
    }
    else
    {
        Outer.Pawn.SetPhysics(SavedPhysicsMode);
        // End:0x1E8
        if(SkeletalMeshComponent(Outer.Pawn.Weapon.Mesh) != none)
        {
            SkeletalMeshComponent(Outer.Pawn.Weapon.Mesh).bPauseAnims = false;
        }
        Outer.bLockMoveInput = SavedbLockMoveInput;
    }
    //return;    
}

exec function ToggleSMV(int Index)
{
    local SkyBotControllerPilot C;

    // End:0x4B
    foreach Outer.WorldInfo.AllControllers(Class'SkyBotControllerPilot', C)
    {
        C.bSpecialManeauverDebugOn = !C.bSpecialManeauverDebugOn;        
    }    
    //return;    
}

exec function TogglePilotPerf(int Index)
{
    local SkyBotControllerPilot C;
    local bool bAlreadyLogged;

    // End:0x88
    foreach Outer.WorldInfo.AllControllers(Class'SkyBotControllerPilot', C)
    {
        // End:0x5C
        if(C.PilotPerf[Index] == 1)
        {
            C.PilotPerf[Index] = 0;            
        }
        else
        {
            C.PilotPerf[Index] = 1;
        }
        // End:0x87
        if(bAlreadyLogged == false)
        {
            bAlreadyLogged = true;
        }        
    }    
    //return;    
}

exec function SetPilotTethers(int bOn)
{
    local SkyBotControllerPilot C;

    // End:0x40
    foreach Outer.WorldInfo.AllControllers(Class'SkyBotControllerPilot', C)
    {
        C.bTetherEnabled = bool(bOn);        
    }    
    //return;    
}

exec function AllWeapons()
{
    // End:0x3D
    if((int(Outer.WorldInfo.NetMode) != int(NM_Standalone)) || Outer.Pawn == none)
    {
        return;
    }
    GiveWeapon("SkyWeap_DesertEagle");
    //return;    
}

exec function AllAmmo()
{
    // End:0x94
    if((Outer.Pawn != none) && SkyInventoryManager(Outer.Pawn.InvManager) != none)
    {
        SkyInventoryManager(Outer.Pawn.InvManager).AllAmmo();
        SkyInventoryManager(Outer.Pawn.InvManager).bInfiniteAmmo = true;
    }
    //return;    
}

exec function NoAmmo()
{
    // End:0x68
    if((Outer.Pawn != none) && SkyInventoryManager(Outer.Pawn.InvManager) != none)
    {
        SkyInventoryManager(Outer.Pawn.InvManager).NoAmmo();
    }
    //return;    
}

exec function ToggleStamina()
{
    bInfiniteStamina = !bInfiniteStamina;
    //return;    
}

exec function FullHealth()
{
    // End:0xB3
    if(Outer.Pawn != none)
    {
        Outer.Pawn.Health = Outer.Pawn.default.Health;
        // End:0xB3
        if(Vehicle(Outer.Pawn) != none)
        {
            Vehicle(Outer.Pawn).Driver.Health = Vehicle(Outer.Pawn).Driver.default.Health;
        }
    }
    //return;    
}

exec function ViewPlane()
{
    local SkyBotControllerBase first;
    local bool bFound;
    local SkyBotControllerBase C;
    local SkyPlayerController SPC;

    // End:0x120
    if(Outer.Pawn != none)
    {
        SPC = SkyPlayerController(Outer.Pawn.Controller);
        // End:0x120
        if(SPC != none)
        {
            // End:0xF0
            foreach Outer.WorldInfo.AllControllers(Class'SkyBotControllerBase', C)
            {
                // End:0xEF
                if((C.Pawn != none) && C.PlayerReplicationInfo != none)
                {
                    // End:0xC4
                    if(bFound || first == none)
                    {
                        first = C;
                        // End:0xC4
                        if(bFound)
                        {
                            // End:0xF0
                            break;
                        }
                    }
                    // End:0xEF
                    if(C.Pawn == SPC.ViewTargetAirVehicle)
                    {
                        bFound = true;
                    }
                }                
            }            
            // End:0x120
            if(first != none)
            {
                SPC.ViewTargetAirVehicle = SkyAirVehicle(first.Pawn);
            }
        }
    }
    //return;    
}

exec function Invisible(bool B)
{
    Outer.Pawn.SetHidden(B);
    // End:0x60
    if(SkyPawn(Outer.Pawn) != none)
    {
        SkyPawn(Outer.Pawn).bIsInvisible = B;
    }
    //return;    
}

exec function ToggleInvisible()
{
    local SkyPawn MyPawn;

    MyPawn = SkyPawn(Outer.Pawn);
    // End:0xE0
    if(MyPawn != none)
    {
        // End:0x8E
        if(MyPawn.bIsInvisible)
        {
            MyPawn.SetHidden(false);
            MyPawn.bIsInvisible = false;
            Outer.ClientMessage("-- Invisible Mode OFF --");            
        }
        else
        {
            MyPawn.SetHidden(true);
            MyPawn.bIsInvisible = true;
            Outer.ClientMessage("-- Invisible Mode ON --");
        }
    }
    //return;    
}

exec function Medusa(bool bInMedusa)
{
    // End:0x40
    if(SkyPawn(Outer.Pawn) != none)
    {
        SkyPawn(Outer.Pawn).bMedusa = bInMedusa;
    }
    //return;    
}

exec function AspectRatio(float NewRatio)
{
    Outer.PlayerCamera.bConstrainAspectRatio = true;
    Outer.PlayerCamera.ConstrainedAspectRatio = NewRatio;
    //return;    
}

exec function ViewAI(optional string BotName, optional bool MoveCamera)
{
    local Actor first;
    local AIController C;
    local Pawn P;
    local SkyPlayerController SPC;
    local bool LeaveCamera;

    SPC = SkyPlayerController(Outer.Pawn.Controller);
    LeaveCamera = !MoveCamera;
    // End:0x51
    if(!LeaveCamera)
    {
        SPC.SkyAIDebugTarget = none;
    }
    Outer.ReplaceText(BotName, "bot_", "SkyBot_");
    Outer.ReplaceText(BotName, "grunt_", "SkyPawnGrunt_");
    // End:0x10F
    foreach Outer.WorldInfo.AllControllers(Class'Engine.AIController', C)
    {
        // End:0x10E
        if(C.Pawn != none)
        {
            // End:0x10E
            if(C.Name == name(BotName))
            {
                first = C;
                // End:0x10F
                break;
            }
        }        
    }    
    // End:0x16F
    if(first == none)
    {
        // End:0x16E
        foreach Outer.WorldInfo.AllPawns(Class'Engine.Pawn', P)
        {
            // End:0x16D
            if(P.Name == name(BotName))
            {
                first = P;
                // End:0x16E
                break;
            }            
        }        
    }
    // End:0x26A
    if(first != none)
    {
        // End:0x1A7
        if(Pawn(first) == none)
        {
            SPC.SkyAIDebugTarget = SkyAIController(first);            
        }
        else
        {
            SPC.SkyAIDebugTarget = SkyAIController(Pawn(first).Controller);
        }
        // End:0x267
        if(!LeaveCamera)
        {
            // End:0x217
            if(Pawn(first) == none)
            {
                Outer.SetViewTarget(AIController(first).Pawn);                
            }
            else
            {
                Outer.SetViewTarget(Pawn(first));
            }
            Outer.SetCameraMode('ThirdPerson');
            Outer.FixFOV();
        }        
    }
    else
    {
        SPC.SkyAIDebugTarget = none;
    }
    // End:0x29C
    if((first == none) || LeaveCamera)
    {
        ViewSelf(true);
    }
    //return;    
}

exec function VTC()
{
    local Vector HitLocation, HitNormal, TraceStart, TraceEnd;
    local TraceHitInfo HitInfo;
    local Actor A;
    local string Command;

    // End:0x17D
    if(Outer.PlayerCamera != none)
    {
        TraceStart = Outer.PlayerCamera.Location;
        TraceEnd = TraceStart + (Vector(Outer.PlayerCamera.Rotation) * float(1000000));
        A = Outer.WorldInfo.Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true, vect(0.0000000, 0.0000000, 0.0000000), HitInfo, 1);
        // End:0x17D
        if(A != none)
        {
            // End:0xF2
            if(Pawn(A) != none)
            {
                Command = "" $ string(A.Name);
                VT(Command);                
            }
            else
            {
                // End:0x12F
                if(SkyWeaponBase(A) != none)
                {
                    Command = "" $ string(A.Name);
                    VT(Command);                    
                }
                else
                {
                    // End:0x17D
                    if(Pawn(A.Owner) != none)
                    {
                        Command = "" $ string(A.Owner.Name);
                        VT(Command);
                    }
                }
            }
        }
    }
    //return;    
}

exec function VT(optional string acName)
{
    local Actor first;
    local Controller C;
    local Actor Other;
    local bool bFound;
    local name myName;
    local Pawn P;

    // End:0x60
    if(first == none)
    {
        // End:0x5F
        foreach Outer.WorldInfo.AllPawns(Class'Engine.Pawn', P)
        {
            // End:0x5E
            if(P.Name == name(acName))
            {
                first = P;
                // End:0x5F
                break;
            }            
        }        
    }
    // End:0xDC
    if(first == none)
    {
        // End:0xDB
        foreach Outer.WorldInfo.AllControllers(Class'Engine.Controller', C)
        {
            // End:0xDA
            if(C.Name == name(acName))
            {
                // End:0xDA
                if(C.Pawn != none)
                {
                    first = C.Pawn;
                    // End:0xDB
                    break;
                }
            }            
        }        
    }
    // End:0x1FB
    if(first == none)
    {
        myName = name(acName);
        // End:0x1FA
        foreach Outer.WorldInfo.AllActors(Class'Engine.Actor', Other)
        {
            // End:0x1AD
            if(bFound || first == none)
            {
                // End:0x1AD
                if(Other.IsA(myName))
                {
                    // End:0x160
                    if(Controller(Other) == none)
                    {
                        first = Other;                        
                    }
                    else
                    {
                        // End:0x194
                        if(Controller(Other).Pawn != none)
                        {
                            first = Controller(Other).Pawn;
                        }
                    }
                    // End:0x1AD
                    if((first != none) && bFound)
                    {
                        // End:0x1FA
                        break;
                    }
                }
            }
            // End:0x1F9
            if((SkyHUD(Outer.myHUD) != none) && Other == SkyHUD(Outer.myHUD).DebugTargetActor)
            {
                bFound = true;
            }            
        }        
    }
    // End:0x22D
    if(first != none)
    {
        SkyHUD(Outer.myHUD).DebugTargetActor = first;        
    }
    else
    {
        SkyHUD(Outer.myHUD).DebugTargetActor = Outer.Pawn;
    }
    //return;    
}

simulated exec function ToggleKismetLogging()
{
    local GameEngine GE;

    GE = GetGameEngine();
    // End:0x3A
    if(GE != none)
    {
        GE.bKismetDebugLogging = !GE.bKismetDebugLogging;
    }
    //return;    
}

simulated exec function SetPlayerSpeed(float F)
{
    local SkyPawn SP;

    SP = SkyPawn(Outer.Pawn);
    // End:0xB3
    if((Outer.CheatManager != none) && SP != none)
    {
        SP.SpeedByTargetMode[0] = 450.0000000 * F;
        SP.SpeedByTargetMode[1] = 337.0000000 * F;
        SP.SpeedByTargetMode[2] = 337.0000000 * F;
        SP.SprintSpeed = 850.0000000 * F;
    }
    //return;    
}

simulated exec function SetAISpeed(float F)
{
    local Actor A;

    // End:0x4C
    foreach Outer.AllActors(Class'Engine.Actor', A)
    {
        // End:0x4B
        if(SkyNPC(A) != none)
        {
            SkyNPC(A).GroundSpeed = 450.0000000 * F;
        }        
    }    
    //return;    
}

simulated exec function SetPawnSpeed(float F)
{
    SetPlayerSpeed(F);
    SetAISpeed(F);
    //return;    
}

exec function Inventory GiveInventory(string InventoryClassStr)
{
    local Inventory Inv;
    local class<Inventory> InvClass;

    InvClass = class<Inventory>(DynamicLoadObject(InventoryClassStr, Class'Core.Class'));
    Inv = Outer.Pawn.FindInventoryType(InvClass);
    // End:0x53
    if(Inv != none)
    {
        return Inv;
    }
    return Outer.Pawn.CreateInventory(InvClass);
    //return ReturnValue;    
}

exec function EnableThrust(bool bEnable)
{
    local SkyPlayerController SPC;

    SPC = SkyPlayerController(Outer.Pawn.Controller);
    // End:0x76
    if(SPC != none)
    {
        // End:0x54
        if(bEnable == false)
        {
            SPC.ChangeDisableThrustCount(true);            
        }
        else
        {
            // End:0x76
            if(bEnable == true)
            {
                SPC.ChangeDisableThrustCount(false, true);
            }
        }
    }
    //return;    
}

exec function SetMaxPhysDeltaPercent(float NewMaxPhysDeltaPercent)
{
    Outer.WorldInfo.MaxPhysDeltaPercent = NewMaxPhysDeltaPercent;
    //return;    
}

exec function DumpCollisionStats(optional float SummaryIncrement, optional float PrintThreshold)
{
    local StaticMeshActor TestActor;
    local array<StatsListEntry> MyArray;
    local array<int> Buckets;
    local float ratio;
    local int BucketIndex, I, BucketValue;

    // End:0x17
    if(SummaryIncrement > float(0))
    {
        Buckets.Add(10);
    }
    // End:0xE8
    foreach Outer.AllActors(Class'Engine.StaticMeshActor', TestActor)
    {
        ratio = FindCollisionRatio(TestActor);
        // End:0xA5
        if(ratio >= PrintThreshold)
        {
            MyArray.Length = MyArray.Length + 1;
            MyArray[MyArray.Length - 1].EntryActor = TestActor;
            MyArray[MyArray.Length - 1].EntryRatio = ratio;
        }
        // End:0xE7
        if(SummaryIncrement > float(0))
        {
            BucketIndex = int(ratio / SummaryIncrement);
            // End:0xDA
            if(BucketIndex > 9)
            {
                BucketIndex = 9;
            }
            Buckets[BucketIndex]++;
        }        
    }    
    SortStatsList(MyArray);
    I = 0;
    J0xFF:

    // End:0x119 [Loop If]
    if(I < MyArray.Length)
    {
        I++;
        // [Loop Continue]
        goto J0xFF;
    }
    // End:0x184
    if(SummaryIncrement > float(0))
    {
        BucketValue = 0;
        // End:0x13F
        if(BucketValue == 0)
        {
            BucketValue = 0;
        }
        I = 0;
        J0x146:

        // End:0x184 [Loop If]
        if(I < Buckets.Length)
        {
            // End:0x16C
            if(I == (Buckets.Length - 1))
            {                
            }
            BucketValue += int(SummaryIncrement);
            I++;
            // [Loop Continue]
            goto J0x146;
        }
    }
    //return;    
}

// Export USkyCheatManager::execFindCollisionRatio(FFrame&, void* const)
native function float FindCollisionRatio(StaticMeshActor TestActor);

exec function DumpRenderStats(optional float SummaryIncrement, optional float PrintThreshold)
{
    local StaticMeshActor TestActor;
    local array<StatsListEntry> MyArray;
    local array<int> Buckets;
    local float ratio;
    local int BucketIndex, I, BucketValue;

    // End:0x17
    if(SummaryIncrement > float(0))
    {
        Buckets.Add(10);
    }
    // End:0xE8
    foreach Outer.AllActors(Class'Engine.StaticMeshActor', TestActor)
    {
        ratio = FindRenderRatio(TestActor);
        // End:0xA5
        if(ratio >= PrintThreshold)
        {
            MyArray.Length = MyArray.Length + 1;
            MyArray[MyArray.Length - 1].EntryActor = TestActor;
            MyArray[MyArray.Length - 1].EntryRatio = ratio;
        }
        // End:0xE7
        if(SummaryIncrement > float(0))
        {
            BucketIndex = int(ratio / SummaryIncrement);
            // End:0xDA
            if(BucketIndex > 9)
            {
                BucketIndex = 9;
            }
            Buckets[BucketIndex]++;
        }        
    }    
    SortStatsList(MyArray);
    I = 0;
    J0xFF:

    // End:0x119 [Loop If]
    if(I < MyArray.Length)
    {
        I++;
        // [Loop Continue]
        goto J0xFF;
    }
    // End:0x184
    if(SummaryIncrement > float(0))
    {
        BucketValue = 0;
        // End:0x13F
        if(BucketValue == 0)
        {
            BucketValue = 0;
        }
        I = 0;
        J0x146:

        // End:0x184 [Loop If]
        if(I < Buckets.Length)
        {
            // End:0x16C
            if(I == (Buckets.Length - 1))
            {                
            }
            BucketValue += int(SummaryIncrement);
            I++;
            // [Loop Continue]
            goto J0x146;
        }
    }
    //return;    
}

// Export USkyCheatManager::execFindRenderRatio(FFrame&, void* const)
native function float FindRenderRatio(StaticMeshActor TestActor);

// Export USkyCheatManager::execSortStatsList(FFrame&, void* const)
native function SortStatsList(out array<StatsListEntry> MyArray);
