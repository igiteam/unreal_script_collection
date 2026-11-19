class AdvPicPuzzle_base extends AdvPuzzle_Base
    abstract
    config(Game)
    hidecategories(Navigation);

struct PuzzlePiece
{
    var bool bSelected;
    var bool bPlaced;
    var Vector Position;
    var Vector BasePos;

    structdefaultproperties
    {
        bSelected=false
        bPlaced=false
        Position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        BasePos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct CheckpointRecord
{
    var Vector Location;
    var Rotator Rotation;
    var array<PuzzlePiece> Pieces;
    var array<Rotator> ModelPiecesRotations;
    var bool bPuzzleResult;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        Pieces=none
        ModelPiecesRotations=none
        bPuzzleResult=false
    }
};

var int CurrentPiece;
var export editinline StaticMeshComponent BackgroundMesh;
var Vector CursorPos;
var export editinline array<export editinline StaticMeshComponent> ModelPieces;
var array<Vector> PiecesPositions;
var bool bPuzzleResult;
var bool bGameEnded;
var SoundCue WrongSound;
var SoundCue CorrectSound;
var SoundCue RotateSound;
var SoundCue PickupSound;
var export editinline StaticMeshComponent SelectionMesh;
var Vector LocalCursorPosition;
var array<PuzzlePiece> Pieces;

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    local int I;

    Record.Pieces.Remove(0, Record.Pieces.Length);    
    Record.ModelPiecesRotations.Remove(0, Record.ModelPiecesRotations.Length);    
    Record.ModelPiecesRotations.Add(ModelPieces.Length);    
    I = 0;
    J0xAB:

    // End:0x160 [Loop If]
    if(I < Pieces.Length)
    {
        Record.Pieces.AddItem(self.Pieces[I]);        
        Record.ModelPiecesRotations[I] = ModelPieces[I].Rotation;
        ++I;
        // [Loop Continue]
        goto J0xAB;
    }
    Record.bPuzzleResult = self.bPuzzleResult;
    Record.Location = self.Location;
    Record.Rotation = self.Rotation;
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    local int I;
    local Rotator emptyRotator;

    self.bPuzzleResult = Record.bPuzzleResult;
    self.SetLocation(Record.Location);
    self.SetRotation(Record.Rotation);
    // End:0x1B9
    if(Record.bPuzzleResult)
    {
        I = 0;
        J0xB8:

        // End:0x1AC [Loop If]
        if(I < Record.Pieces.Length)
        {
            Pieces[I].Position = PiecesPositions[I];
            ModelPieces[I].SetTranslation(Pieces[I].Position);
            ModelPieces[I].SetRotation(emptyRotator);
            ++I;
            // [Loop Continue]
            goto J0xB8;
        }
        SetupEnding();        
    }
    else
    {
        I = 0;
        J0x1C4:

        // End:0x293 [Loop If]
        if(I < Record.Pieces.Length)
        {
            self.Pieces[I] = Record.Pieces[I];
            ModelPieces[I].SetRotation(Record.ModelPiecesRotations[I]);
            ++I;
            // [Loop Continue]
            goto J0x1C4;
        }
        ManualInitialPositioning();
        BackgroundMesh.SetMaterial(0, MaterialInstanceConstant'adv_PuzzleGame.Materials.mi_it_PuzzleGame_01_01');
    }
    //return;    
}

function PostBeginPlay()
{
    Presetup();
    //return;    
}

function ManualInitialPositioning()
{
    local int I;

    Pieces[9].Position.X = 41.0000000;
    Pieces[9].Position.Y = 29.5000000;
    Pieces[8].Position.X = 28.3500000;
    Pieces[8].Position.Y = 11.5000000;
    Pieces[7].Position.X = 42.2507000;
    Pieces[7].Position.Y = -3.7484000;
    Pieces[6].Position.X = 26.0000000;
    Pieces[6].Position.Y = -15.0000000;
    Pieces[5].Position.X = 40.7738000;
    Pieces[5].Position.Y = -29.2576000;
    Pieces[0].Position.X = -37.3982000;
    Pieces[0].Position.Y = -29.0000000;
    Pieces[1].Position.X = -27.0000000;
    Pieces[1].Position.Y = -7.6866000;
    Pieces[2].Position.X = -43.0172000;
    Pieces[2].Position.Y = 5.6000000;
    Pieces[3].Position.X = -25.3000000;
    Pieces[3].Position.Y = 15.7697000;
    Pieces[4].Position.X = -41.0000000;
    Pieces[4].Position.Y = 27.0000000;
    I = 0;
    J0x467:

    // End:0x59D [Loop If]
    if(I < 10)
    {
        Pieces[I].BasePos = Pieces[I].Position;
        ModelPieces[I].SetTranslation(Pieces[I].Position);
        Pieces[I].bPlaced = false;
        Pieces[I].bSelected = false;
        ModelPieces[I].SetHidden(false);
        ++I;
        // [Loop Continue]
        goto J0x467;
    }
    //return;    
}

function Presetup()
{
    local int I;
    local Rotator BaseRot;
    local PuzzlePiece Piece;
    local Vector NewPos;

    CursorPos.X = 0.0000000;
    CursorPos.Y = 0.0000000;
    CursorPos.Z = 5.0000000;
    CurrentPiece = -1;
    bGameEnded = false;
    bPuzzleResult = false;
    BaseRot.Pitch = 0;
    BaseRot.Roll = 0;
    BaseRot.Yaw = 0;
    I = 0;
    J0xF2:

    // End:0x251 [Loop If]
    if(I < 10)
    {
        BaseRot.Yaw = (1 + Rand(7)) * 8192;
        ModelPieces[I].SetRotation(BaseRot);
        Pieces.AddItem(Piece);        
        Pieces[I].Position = ModelPieces[I].GetPosition();
        Pieces[I].Position.Y = 0.0000000;
        Pieces[I].Position.Z = 0.0000000;
        ++I;
        // [Loop Continue]
        goto J0xF2;
    }
    ManualInitialPositioning();
    NewPos.Z = -2.0000000;
    NewPos.X = 0.0000000;
    BaseRot.Yaw = 0;
    BackgroundMesh.SetRotation(BaseRot);
    BackgroundMesh.SetTranslation(NewPos);
    SetRotation(BaseRot);
    BaseRot.Yaw -= 8192;
    SelectionMesh.SetScale(1.1000000);
    SelectionMesh.SetHidden(true);
    //return;    
}

function bool SetPawn(Pawn P)
{
    local Controller C;
    local int I;

    // End:0x134
    if(!bPuzzleResult)
    {
        // End:0x29
        if(!super.SetPawn(P))
        {
            return false;
        }
        Presetup();
        C = P.Controller;
        // End:0xDF
        if(EvilPlayerController(C) != none)
        {
            C.UnPossess();
            C.Possess(self, false);
            EvilPlayerController(C).GotoState('PicPuzzleControlling');
        }
        I = 0;
        J0xEA:

        // End:0x132 [Loop If]
        if(I < 10)
        {
            ModelPieces[I].SetHidden(false);
            ++I;
            // [Loop Continue]
            goto J0xEA;
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function SetTextfield()
{
    super.SetTextfield();
    // End:0x2E3
    if(AdvPlayerController(self.Controller).PlayerInput.bUsingGamepad)
    {
        HintString = "" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "PicPuzzleMove", "EvilGame"), PlayerController(self.Controller));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "PicPuzzlePick", "EvilGame"), PlayerController(self.Controller)));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "PicPuzzleRR", "EvilGame"), PlayerController(self.Controller)));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "PicPuzzleRL", "EvilGame"), PlayerController(self.Controller)));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "PicPuzzleExit", "EvilGame"), PlayerController(self.Controller)));        
    }
    else
    {
        HintString = "" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "PicPuzzleMove_PC", "EvilGame"), PlayerController(self.Controller));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "PicPuzzlePick_PC", "EvilGame"), PlayerController(self.Controller)));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "PicPuzzleRR_PC", "EvilGame"), PlayerController(self.Controller)));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "PicPuzzleExit_PC", "EvilGame"), PlayerController(self.Controller)));
    }
    TextField.SetBool("html", true);
    TextField.SetString("htmlText", HintString);
    //return;    
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Rotator tempRot;
    local Vector zoomOutVector;

    tempRot = Rotation;
    tempRot.Pitch += 13380;
    tempRot.Yaw += 16384;
    zoomOutVector.Z = 23.0000000;
    out_CamLoc = (Location + zoomOutVector) + (Normal(Vector(tempRot)) * float(70));
    out_CamRot = Rotator(Location - out_CamLoc);
    out_CamRot.Roll = 0;
    return true;
    //return ReturnValue;    
}

function DisSelectPiece()
{
    // End:0xBA
    if(CurrentPiece >= 0)
    {
        Pieces[CurrentPiece].Position = Pieces[CurrentPiece].BasePos;
        ModelPieces[CurrentPiece].SetTranslation(Pieces[CurrentPiece].Position);
        CurrentPiece = -1;
    }
    //return;    
}

function SelectPiece()
{
    local int I;
    local bool Finish;
    local Vector NewPos;

    Finish = true;
    // End:0x1B
    if(bGameEnded)
    {
        return;
    }
    // End:0x371
    if(CurrentPiece >= 0)
    {
        Pieces[CurrentPiece].bSelected = false;
        // End:0x28D
        if(((ModelPieces[CurrentPiece].Rotation.Yaw == 0) && Abs(Pieces[CurrentPiece].Position.X - PiecesPositions[CurrentPiece].X) < float(3)) && Abs(Pieces[CurrentPiece].Position.Y - PiecesPositions[CurrentPiece].Y) < float(3))
        {
            NewPos = PiecesPositions[CurrentPiece];
            Pieces[CurrentPiece].bPlaced = true;
            ModelPieces[CurrentPiece].SetTranslation(NewPos);
            // End:0x20F
            if(CorrectSound != none)
            {
                PlaySound(CorrectSound);
            }
            I = 0;
            J0x21A:

            // End:0x273 [Loop If]
            if(I < 10)
            {
                // End:0x265
                if(!Pieces[I].bPlaced)
                {
                    Finish = false;
                    // [Explicit Break]
                    goto J0x273;
                }
                ++I;
                // [Loop Continue]
                goto J0x21A;
            }
            J0x273:

            // End:0x28A
            if(Finish)
            {
                EndPuzzle();
            }            
        }
        else
        {
            // End:0x2B4
            if(WrongSound != none)
            {
                PlaySound(WrongSound);
            }
            Pieces[CurrentPiece].Position = Pieces[CurrentPiece].BasePos;
            ModelPieces[CurrentPiece].SetTranslation(Pieces[CurrentPiece].Position);
            CurrentPiece = -1;
        }
        CurrentPiece = -1;        
    }
    else
    {
        I = 0;
        J0x37C:

        // End:0x578 [Loop If]
        if(I < 10)
        {
            // End:0x56A
            if((!Pieces[I].bPlaced && Abs(Pieces[I].Position.X - LocalCursorPosition.X) < float(9)) && Abs(Pieces[I].Position.Y - LocalCursorPosition.Y) < float(9))
            {
                // End:0x4A7
                if(PickupSound != none)
                {
                    PlaySound(PickupSound);
                }
                Pieces[I].bSelected = true;
                CurrentPiece = I;
                NewPos = Pieces[CurrentPiece].Position;
                NewPos.Z += float(20);
                ModelPieces[I].SetTranslation(NewPos);
                // [Explicit Break]
                goto J0x578;
            }
            ++I;
            // [Loop Continue]
            goto J0x37C;
        }
    }
    J0x578:

    //return;    
}

function SetupEnding()
{
    local int I;
    local Vector NewPos;

    bGameEnded = true;
    I = 0;
    J0x17:

    // End:0x5F [Loop If]
    if(I < 10)
    {
        ModelPieces[I].SetHidden(true);
        ++I;
        // [Loop Continue]
        goto J0x17;
    }
    BackgroundMesh.SetMaterial(0, MaterialInstanceConstant'adv_PuzzleGame.Materials.mi_it_PuzzleGame_01_02');
    NewPos.X = 0.0000000;
    NewPos.Y = 0.0000000;
    NewPos.Z = -1.0000000;
    BackgroundMesh.SetTranslation(NewPos);
    bPuzzleResult = true;
    //return;    
}

function EndPuzzle()
{
    SetupEnding();
    SetTimer(0.5000000, false, 'WaitEnding');
    //return;    
}

function WaitEnding()
{
    local Sequence GameSeq;
    local array<SequenceObject> ExecutionEvents;
    local SequenceObject ExecutionEvent;
    local SeqEvent_Activated FireEvent;
    local array<int> ActivateIndices;

    SetTimer(0.0000000, false, 'WaitEnding');
    LeaveThePuzzle();
    GameSeq = WorldInfo.GetGameSequence();
    // End:0x136
    if(GameSeq != none)
    {
        // End:0x72
        if(bPuzzleResult)
        {
            ActivateIndices[0] = 0;            
        }
        else
        {
            ActivateIndices[0] = 1;
        }
        GameSeq.FindSeqObjectsByClass(Class'EvilGame.SeqEvent_Activated', true, ExecutionEvents);
        // End:0x135
        foreach ExecutionEvents(ExecutionEvent)
        {
            FireEvent = SeqEvent_Activated(ExecutionEvent);
            // End:0x134
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
    super.LeaveThePuzzle();
    // End:0x23
    if(!bPuzzleResult)
    {
        ManualInitialPositioning();
    }
    //return;    
}

function RotatePiece(bool Right)
{
    local Rotator OldRotation;

    // End:0x0F
    if(bGameEnded)
    {
        return;
    }
    // End:0x1C4
    if(CurrentPiece >= 0)
    {
        OldRotation = ModelPieces[CurrentPiece].Rotation;
        OldRotation.Yaw = OldRotation.Yaw + ((Right) ? 8192 : -8192);
        OldRotation.Pitch = 0;
        OldRotation.Roll = 0;
        // End:0x127
        if(OldRotation.Yaw >= 65536)
        {
            OldRotation.Yaw = 0;            
        }
        else
        {
            // End:0x16B
            if(OldRotation.Yaw < 0)
            {
                OldRotation.Yaw = 57344;
            }
        }
        ModelPieces[CurrentPiece].SetRotation(OldRotation);
        // End:0x1C4
        if(RotateSound != none)
        {
            PlaySound(RotateSound);
        }
    }
    //return;    
}

function bool IsOverPiece(Vector Position)
{
    local int I;

    // End:0x0F
    if(bGameEnded)
    {
        return false;
    }
    LocalCursorPosition = (Position - self.Location) << self.Rotation;
    I = 0;
    J0x5E:

    // End:0x2A1 [Loop If]
    if(I < 10)
    {
        // End:0x273
        if(((!Pieces[I].bPlaced && Abs(Pieces[I].Position.X - LocalCursorPosition.X) < float(9)) && Abs(Pieces[I].Position.Y - LocalCursorPosition.Y) < float(9)) && CurrentPiece == -1)
        {
            SelectionMesh.SetStaticMesh(ModelPieces[I].StaticMesh);
            SelectionMesh.SetTranslation(Pieces[I].Position);
            SelectionMesh.SetRotation(ModelPieces[I].Rotation);
            SelectionMesh.SetHidden(false);
            return true;
            // [Explicit Break]
            goto J0x2A1;            
        }
        else
        {
            SelectionMesh.SetHidden(true);
        }
        ++I;
        // [Loop Continue]
        goto J0x5E;
    }
    J0x2A1:

    // End:0x3EA
    if(CurrentPiece >= 0)
    {
        Pieces[CurrentPiece].Position.Y = LocalCursorPosition.Y;
        Pieces[CurrentPiece].Position.X = LocalCursorPosition.X;
        Pieces[CurrentPiece].Position.Z = 4.0000000;
        ModelPieces[CurrentPiece].SetTranslation(Pieces[CurrentPiece].Position);
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    CurrentPiece=-1
    PiecesPositions[0]=none
    PiecesPositions[1]=none
    PiecesPositions[2]=none
    PiecesPositions[3]=none
    PiecesPositions[4]=none
    PiecesPositions[5]=none
    PiecesPositions[6]=none
    PiecesPositions[7]=none
    PiecesPositions[8]=none
    PiecesPositions[9]=none
    // Reference: EvilCaptionComponent'Default__AdvPicPuzzle_base.CaptionComp'
    begin object name=CaptionComp
        Offset=(X=0.0000000,Y=0.0000000,Z=60.0000000)
    end object
    CaptionComponent=CaptionComp
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPicPuzzle_base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WalkingPhysics=EPhysics.PHYS_Flying
    // Reference: CylinderComponent'Default__AdvPicPuzzle_base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=none
    Components[2]=CaptionComp
    Components[3]=MyLightEnvironment
    Physics=EPhysics.PHYS_Interpolating
    CollisionComponent=CollisionCylinder
}