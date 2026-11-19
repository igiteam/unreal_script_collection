class AdvScalesPuzzle_base extends AdvPuzzle_Base
    abstract
    config(Game)
    hidecategories(Navigation);

enum ScalesResult
{
    Unknown,                        // 0
    Solved,                         // 1
    NotEnoughFailed,                // 2
    TooMuchFailed,                  // 3
    ScalesResult_MAX                // 4
};

struct Coin
{
    var AdvScalesPuzzle_PCoin CustomCoinActor;
    var Vector InitialPosition;
    var Vector Position;
    var bool bIsOnScales;

    structdefaultproperties
    {
        CustomCoinActor=none
        InitialPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        bIsOnScales=false
    }
};

struct CheckpointRecord
{
    var Vector Location;
    var Rotator Rotation;
    var AdvScalesPuzzle_base.ScalesResult PuzzleResult;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        PuzzleResult=ScalesResult.Unknown
    }
};

var int CoinsHeld;
var int CoinsRequired;
var int CoinsAtScales;
var export editinline StaticMeshComponent OuterBowlMesh;
var() export editinline StaticMeshComponent InnerBowlMesh;
var() export editinline StaticMeshComponent PouchMesh;
var() Vector PositionOverScales;
var() Vector PositionOverPouch;
var() SoundCue CoinPickedUp;
var int CurrentCoin;
var() float coinScaleFactor;
var array<Coin> Coins;
var AdvScalesPuzzle_base.ScalesResult PuzzleResult;

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.PuzzleResult = self.PuzzleResult;
    Record.Location = self.Location;
    Record.Rotation = self.Rotation;
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    // End:0x43
    if(int(Record.PuzzleResult) != int(1))
    {
        self.PuzzleResult = 0;        
    }
    else
    {
        self.PuzzleResult = Record.PuzzleResult;
    }
    self.SetLocation(Record.Location);
    self.SetRotation(Record.Rotation);
    //return;    
}

function Initialize()
{
    PuzzleResult = 0;
    PositionOverScales.X = 0.0000000;
    PositionOverScales.Y = 0.0000000;
    PositionOverScales.Z = 30.0000000;
    PositionOverPouch.X = 30.0000000;
    PositionOverPouch.Y = 59.0000000;
    PositionOverPouch.Z = 25.0000000;
    CurrentCoin = -1;
    //return;    
}

function PostBeginPlay()
{
    Initialize();
    //return;    
}

function bool SetPawn(Pawn P)
{
    local Controller C;
    local int I;

    // End:0x1A
    if(!super.SetPawn(P))
    {
        return false;
    }
    // End:0x5E
    if((int(PuzzleResult) == int(0)) || Coins.Length != CoinsHeld)
    {
        CreateCoins();
        PuzzleResult = 2;
    }
    CoinsAtScales = 0;
    // End:0xDD
    if(CoinsRequired > 0)
    {
        I = 0;
        J0x83:

        // End:0xDD [Loop If]
        if(I < CoinsHeld)
        {
            // End:0xCF
            if(Coins[I].bIsOnScales)
            {
                ++CoinsAtScales;
            }
            ++I;
            // [Loop Continue]
            goto J0x83;
        }
    }
    I = 0;
    J0xE8:

    // End:0x15F [Loop If]
    if(I < CoinsHeld)
    {
        Coins[I].CustomCoinActor.StaticMeshComponent.SetHidden(false);
        ++I;
        // [Loop Continue]
        goto J0xE8;
    }
    C = P.Controller;
    // End:0x20B
    if(EvilPlayerController(C) != none)
    {
        C.UnPossess();
        C.Possess(self, false);
        EvilPlayerController(C).GotoState('ScalesPuzzleControlling');
    }
    return true;
    //return ReturnValue;    
}

function SetTextfield()
{
    super.SetTextfield();
    // End:0x25A
    if(AdvPlayerController(self.Controller).PlayerInput.bUsingGamepad)
    {
        HintString = "\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "PicPuzzleMove", "EvilGame"), PlayerController(self.Controller));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "ScalesPick", "EvilGame"), PlayerController(self.Controller)));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "ScalesExit", "EvilGame"), PlayerController(self.Controller)));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "ScalesDrop", "EvilGame"), PlayerController(self.Controller)));        
    }
    else
    {
        HintString = "\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "ScalesMove", "EvilGame"), PlayerController(self.Controller));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "ScalesPick_PC", "EvilGame"), PlayerController(self.Controller)));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "ScalesExit_PC", "EvilGame"), PlayerController(self.Controller)));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "ScalesDrop", "EvilGame"), PlayerController(self.Controller)));
    }
    TextField.SetBool("html", true);
    TextField.SetString("htmlText", HintString);
    //return;    
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Vector NewPosition;

    NewPosition.Y = 60.0000000;
    NewPosition.X = -49.0000000;
    NewPosition.Z = 85.0000000;
    out_CamRot.Roll = 0;
    out_CamRot.Pitch = -7615;
    out_CamRot.Yaw = 56840;
    out_CamLoc = Location + NewPosition;
    return true;
    //return ReturnValue;    
}

function CreateCoins()
{
    local int I;
    local Coin OneCoin;
    local Vector tmpPos;
    local Rotator RotationOffset;

    RotationOffset = self.Rotation;
    RotationOffset.Yaw += int(float(18) * 182.0444000);
    RotationOffset.Yaw -= int(float(Coins.Length * 12) * 182.0444000);
    I = Coins.Length;
    J0x96:

    // End:0x293 [Loop If]
    if(I < CoinsHeld)
    {
        Coins.AddItem(OneCoin);        
        tmpPos = TransformVectorByRotation(RotationOffset, PositionOverPouch * 0.8500000);
        Coins[I].InitialPosition = tmpPos;
        Coins[I].Position = tmpPos;
        Coins[I].CustomCoinActor = Spawn(Class'AdvScalesPuzzle_PCoin',,, InnerBowlMesh.GetPosition() + Coins[I].Position);
        Coins[I].CustomCoinActor.StaticMeshComponent.SetScale(coinScaleFactor);
        Coins[I].bIsOnScales = false;
        RotationOffset.Yaw -= int(float(12) * 182.0444000);
        ++I;
        // [Loop Continue]
        goto J0x96;
    }
    //return;    
}

function DisableCoinsPhysics()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x67 [Loop If]
    if(I < CoinsHeld)
    {
        Coins[I].CustomCoinActor.SetPhysics(0);
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function ReturnCoin()
{
    // End:0x18F
    if(CurrentCoin >= 0)
    {
        // End:0x76
        if(Coins[CurrentCoin].bIsOnScales)
        {
            Coins[CurrentCoin].Position = RandomizePositionAround(PositionOverScales);            
        }
        else
        {
            Coins[CurrentCoin].Position = Coins[CurrentCoin].InitialPosition;
        }
        Coins[CurrentCoin].CustomCoinActor.SetLocation(InnerBowlMesh.GetPosition() + Coins[CurrentCoin].Position);
        Coins[CurrentCoin].CustomCoinActor.SetPhysics(2);
        CurrentCoin = -1;
        UpdateCoinsFireEvent();
    }
    //return;    
}

function PlaceCurrentCoinCorrectly()
{
    Coins[CurrentCoin].CustomCoinActor.SetPhysics(10);
    Coins[CurrentCoin].CustomCoinActor.StaticMeshComponent.SetRBPosition(InnerBowlMesh.GetPosition() + Coins[CurrentCoin].Position);
    CurrentCoin = -1;
    //return;    
}

function CurrentCoinPhysOff()
{
    Coins[CurrentCoin].CustomCoinActor.SetPhysics(0);
    CurrentCoin = -1;
    //return;    
}

function Click(Actor ActorHit, Vector HitLocation)
{
    local int I;
    local float operatingRange;

    operatingRange = 30.0000000;
    // End:0x102
    if(CurrentCoin < 0)
    {
        I = 0;
        J0x29:

        // End:0xFF [Loop If]
        if(I < CoinsHeld)
        {
            // End:0xF1
            if(AdvScalesPuzzle_PCoin(ActorHit) == Coins[I].CustomCoinActor)
            {
                // End:0xA4
                if(CoinPickedUp != none)
                {
                    PlaySound(CoinPickedUp);
                }
                CurrentCoin = I;
                Coins[CurrentCoin].CustomCoinActor.SetPhysics(0);
                // [Explicit Break]
                goto J0xFF;
            }
            ++I;
            // [Loop Continue]
            goto J0x29;
        }
        J0xFF:
        
    }
    else
    {
        // End:0x352
        if(AdvScalesPuzzle_base(ActorHit) == self)
        {
            // End:0x2E8
            if(((Abs((self.Location.X + PositionOverPouch.X) - HitLocation.X) < operatingRange) && Abs((self.Location.Y + PositionOverPouch.Y) - HitLocation.Y) < operatingRange) && Abs((self.Location.Z + PositionOverPouch.Z) - HitLocation.Z) < operatingRange)
            {
                // End:0x2B2
                if(Coins[CurrentCoin].bIsOnScales)
                {
                    --CoinsAtScales;
                }
                Coins[CurrentCoin].bIsOnScales = false;
                ReturnCoin();                
            }
            else
            {
                // End:0x31F
                if(!Coins[CurrentCoin].bIsOnScales)
                {
                    ++CoinsAtScales;
                }
                Coins[CurrentCoin].bIsOnScales = true;
                ReturnCoin();
            }
        }
    }
    //return;    
}

function bool CursorMove(Vector CoinLoc, Vector HitLocation, Actor ActorHit)
{
    local int I;
    local bool Result;

    Result = false;
    // End:0x77
    if(CurrentCoin >= 0)
    {
        // End:0x36
        if(ActorHit == self)
        {
            Result = true;
        }
        Coins[CurrentCoin].CustomCoinActor.SetLocation(CoinLoc);        
    }
    else
    {
        I = 0;
        J0x82:

        // End:0xF0 [Loop If]
        if(I < CoinsHeld)
        {
            // End:0xE2
            if(AdvScalesPuzzle_PCoin(ActorHit) == Coins[I].CustomCoinActor)
            {
                Result = true;
            }
            ++I;
            // [Loop Continue]
            goto J0x82;
        }
    }
    return Result;
    //return ReturnValue;    
}

function CheckEndPuzzle()
{
    // End:0x67
    if(CoinsRequired > 0)
    {
        // End:0x35
        if(CoinsAtScales > CoinsRequired)
        {
            PuzzleResult = 3;            
        }
        else
        {
            // End:0x5B
            if(CoinsAtScales == CoinsRequired)
            {
                PuzzleResult = 1;                
            }
            else
            {
                PuzzleResult = 2;
            }
        }
    }
    WaitEnding();
    //return;    
}

function WaitEnding()
{
    local Sequence GameSeq;
    local array<SequenceObject> ExecutionEvents;
    local SequenceObject ExecutionEvent;
    local SeqEvent_Activated FireEvent;
    local array<int> ActivateIndices;

    LeaveThePuzzle();
    GameSeq = WorldInfo.GetGameSequence();
    // End:0x143
    if(GameSeq != none)
    {
        switch(PuzzleResult)
        {
            // End:0x6A
            case 1:
                ActivateIndices[0] = 0;
                // End:0x8C
                break;
            // End:0x6F
            case 0:
            // End:0x74
            case 3:
            // End:0x89
            case 2:
                ActivateIndices[0] = 1;
                // End:0x8C
                break;
            // End:0xFFFF
            default:
                break;
        }
        GameSeq.FindSeqObjectsByClass(Class'EvilGame.SeqEvent_Activated', true, ExecutionEvents);
        // End:0x142
        foreach ExecutionEvents(ExecutionEvent)
        {
            FireEvent = SeqEvent_Activated(ExecutionEvent);
            // End:0x141
            if(FireEvent.Originator == self)
            {
                FireEvent.CheckActivate(self, none, false, ActivateIndices);
            }            
        }        
    }
    //return;    
}

function UpdateCoinsFireEvent()
{
    local Sequence GameSeq;
    local array<SequenceObject> ExecutionEvents;
    local SequenceObject ExecutionEvent;
    local SeqEvent_TakeDamage FireEvent;
    local array<int> ActivateIndices;

    GameSeq = WorldInfo.GetGameSequence();
    // End:0xFC
    if(GameSeq != none)
    {
        ActivateIndices[0] = 0;
        GameSeq.FindSeqObjectsByClass(Class'Engine.SeqEvent_TakeDamage', true, ExecutionEvents);
        // End:0xFB
        foreach ExecutionEvents(ExecutionEvent)
        {
            FireEvent = SeqEvent_TakeDamage(ExecutionEvent);
            // End:0xFA
            if(FireEvent.Originator == self)
            {
                FireEvent.CheckActivate(self, none, false, ActivateIndices);
            }            
        }        
    }
    //return;    
}

function LeaveThePuzzle()
{
    local int I;

    super.LeaveThePuzzle();
    // End:0x23
    if(CurrentCoin >= 0)
    {
        ReturnCoin();
    }
    I = 0;
    J0x2E:

    // End:0xD1 [Loop If]
    if(I < CoinsHeld)
    {
        // End:0xC3
        if(!Coins[I].bIsOnScales)
        {
            Coins[I].CustomCoinActor.StaticMeshComponent.SetHidden(true);
        }
        ++I;
        // [Loop Continue]
        goto J0x2E;
    }
    //return;    
}

function Vector RandomizePositionAround(Vector pos)
{
    local Vector iTmpPos, randPos;
    local bool bColliding;
    local int I;

    J0x00:
    bColliding = false;
    randPos.X = RandRange(-16.0000000, 16.0000000);
    randPos.Y = RandRange(6.0000000, 16.0000000);
    I = 0;
    J0x79:

    // End:0x1A3 [Loop If]
    if(I < Coins.Length)
    {
        iTmpPos = Coins[I].Position;
        // End:0x195
        if((Abs((iTmpPos.X - pos.X) + randPos.X) < float(16)) && Abs((iTmpPos.Y - pos.Y) + randPos.Y) < float(16))
        {
            bColliding = true;
        }
        ++I;
        // [Loop Continue]
        goto J0x79;
    }
    // End:0x00
    if(!(!bColliding))
        goto J0x00;
    pos.X += randPos.X;
    pos.Y += randPos.Y;
    return pos;
    //return ReturnValue;    
}

defaultproperties
{
    PositionOverScales=(X=0.0000000,Y=0.0000000,Z=30.0000000)
    PositionOverPouch=(X=30.0000000,Y=59.0000000,Z=25.0000000)
    coinScaleFactor=0.7000000
    // Reference: EvilCaptionComponent'Default__AdvScalesPuzzle_base.CaptionComp'
    begin object name=CaptionComp
        Offset=(X=0.0000000,Y=0.0000000,Z=50.0000000)
    end object
    CaptionComponent=CaptionComp
    // Reference: DynamicLightEnvironmentComponent'Default__AdvScalesPuzzle_base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WalkingPhysics=EPhysics.PHYS_Flying
    // Reference: CylinderComponent'Default__AdvScalesPuzzle_base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=none
    Components[2]=CaptionComp
    Components[3]=MyLightEnvironment
    Physics=EPhysics.PHYS_Interpolating
    CollisionType=ECollisionType.COLLIDE_BlockAll
    bHardAttach=true
    CollisionComponent=CollisionCylinder
}