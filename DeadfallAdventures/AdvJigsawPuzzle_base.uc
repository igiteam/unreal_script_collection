class AdvJigsawPuzzle_base extends AdvPuzzle_Base
    abstract
    config(Game)
    hidecategories(Navigation);

enum Direction
{
    Left,                           // 0
    Right,                          // 1
    Up,                             // 2
    Down,                           // 3
    Direction_MAX                   // 4
};

enum Groups
{
    InitializingPlate,              // 0
    ScrewingPlatesAndBackground,    // 1
    BackgroundFrame,                // 2
    FrameIn,                        // 3
    FrameOut,                       // 4
    Groups_MAX                      // 5
};

struct Plate
{
    var bool bIsSelected;
    var Vector PositionI;
    var Vector PositionO;
    var Vector Offset;
    var int LogicPosition;

    structdefaultproperties
    {
        bIsSelected=false
        PositionI=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        PositionO=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Offset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        LogicPosition=-1
    }
};

struct CheckpointRecord
{
    var Vector Location;
    var Rotator Rotation;
    var array<Plate> Plates;
    var AdvJigsawPuzzle_base.Groups GroupsToFinalMove;
    var bool bPuzzleResult;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        Plates=none
        GroupsToFinalMove=Groups.InitializingPlate
        bPuzzleResult=false
    }
};

var int PlateAmount;
var export editinline StaticMeshComponent SelectionMesh;
var export editinline array<export editinline StaticMeshComponent> PlateModelsInside;
var export editinline array<export editinline StaticMeshComponent> PlateModelsOutside;
var export editinline StaticMeshComponent FrameInside;
var export editinline StaticMeshComponent FrameOutside;
var export editinline array<export editinline StaticMeshComponent> Backgrounds;
var array<MaterialInstanceConstant> HighlightingMaterials;
var int AxisSize;
var bool bIsPlateMoving;
var bool bPuzzleResult;
var bool bInitialized;
var int plateSize;
var SoundCue SmallBlockSound;
var SoundCue CircleSound;
var SoundCue MachinerySound;
var SoundCue PlateMovesInSound;
var SoundCue PlateMovesOutSound;
var Rotator NewRotation;
var array<Plate> Plates;
var AdvJigsawPuzzle_base.Direction MoveDirection;
var AdvJigsawPuzzle_base.Groups GroupsToFinalMove;
var int which;
var float From;
var float To;
var int plateMovePhase;
var float plateMoveSpeed;
var int plateRotationSpeed;
var Rotator plateRotation;
var int J;
var Vector PositionAfterRotation;

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    local int I;

    Record.Plates.Remove(0, Record.Plates.Length);    
    I = 0;
    J0x47:

    // End:0xBA [Loop If]
    if(I < self.Plates.Length)
    {
        Record.Plates.AddItem(self.Plates[I]);        
        ++I;
        // [Loop Continue]
        goto J0x47;
    }
    Record.GroupsToFinalMove = self.GroupsToFinalMove;
    Record.bPuzzleResult = self.bPuzzleResult;
    Record.Location = self.Location;
    Record.Rotation = self.Rotation;
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    local int I;
    local Vector tmp;

    // End:0x3E7
    if(!Record.bPuzzleResult)
    {
        tmp.X = 0.0000000;
        tmp.Y = 0.0000000;
        tmp.Z = 0.0000000;
        I = 0;
        J0x93:

        // End:0x1B8 [Loop If]
        if(I < Plates.Length)
        {
            self.Plates[I] = Record.Plates[I];
            self.PlateModelsOutside[I].SetTranslation(Plates[I].PositionO);
            self.PlateModelsInside[I].SetTranslation(Plates[I].PositionI);
            ++I;
            // [Loop Continue]
            goto J0x93;
        }
        I = 0;
        J0x1C3:

        // End:0x228 [Loop If]
        if(I < Backgrounds.Length)
        {
            self.Backgrounds[I].SetTranslation(tmp);
            ++I;
            // [Loop Continue]
            goto J0x1C3;
        }
        FrameInside.SetTranslation(tmp);
        FrameOutside.SetTranslation(tmp);
        self.GroupsToFinalMove = Record.GroupsToFinalMove;
        I = 0;
        J0x2B6:

        // End:0x3E7 [Loop If]
        if(I < PlateAmount)
        {
            // End:0x3D9
            if(Plates[I].bIsSelected)
            {
                Plates[I].bIsSelected = false;
                // End:0x378
                if(HighlightingMaterials[2 * I] != none)
                {
                    HighlightingMaterials[2 * I].SetScalarParameterValue('Selected', 0.0000000);
                }
                // End:0x3D6
                if(HighlightingMaterials[(2 * I) + 1] != none)
                {
                    HighlightingMaterials[(2 * I) + 1].SetScalarParameterValue('Selected', 0.0000000);
                }
                // [Explicit Break]
                goto J0x3E7;
            }
            ++I;
            // [Loop Continue]
            goto J0x2B6;
        }
    }
    J0x3E7:

    self.bPuzzleResult = Record.bPuzzleResult;
    AuxiliarySetLocation(Record.Location);
    self.SetRotation(Record.Rotation);
    //return;    
}

function Initialize()
{
    local Plate OnePlate;
    local int I;

    plateSize = 26;
    PlateAmount = 8;
    AxisSize = int(Sqrt(float(PlateAmount + 1)));
    bIsPlateMoving = false;
    bPuzzleResult = false;
    plateRotation.Pitch = 0;
    plateRotation.Roll = 0;
    plateRotation.Yaw = 0;
    I = 0;
    J0xB1:

    // End:0xEF [Loop If]
    if(I < (PlateAmount + 1))
    {
        Plates.AddItem(OnePlate);        
        ++I;
        // [Loop Continue]
        goto J0xB1;
    }
    Plates[0].Offset.X = float(-plateSize);
    Plates[0].Offset.Z = float(-plateSize);
    Plates[1].Offset.Z = float(-plateSize);
    Plates[2].Offset.X = float(plateSize);
    Plates[2].Offset.Z = float(-plateSize);
    Plates[3].Offset.X = float(-plateSize);
    Plates[5].Offset.X = float(plateSize);
    Plates[6].Offset.X = float(-plateSize);
    Plates[6].Offset.Z = float(plateSize);
    Plates[7].Offset.Z = float(plateSize);
    Plates[8].Offset.X = float(-plateSize);
    Plates[8].Offset.Z = float(-plateSize);
    PseudoRandomizePlatePositions(11);
    SetPlateModelsOntoPositions();
    I = 0;
    J0x405:

    // End:0x498 [Loop If]
    if(I < PlateAmount)
    {
        HighlightingMaterials.AddItem(PlateModelsInside[I].CreateAndSetMaterialInstanceConstant(0));        
        HighlightingMaterials.AddItem(PlateModelsOutside[I].CreateAndSetMaterialInstanceConstant(0));        
        ++I;
        // [Loop Continue]
        goto J0x405;
    }
    bInitialized = true;
    //return;    
}

function PseudoRandomizePlatePositions(int Steps)
{
    local int I, recentlyMoved;

    Plates[0].LogicPosition = 3;
    Plates[1].LogicPosition = 0;
    Plates[2].LogicPosition = 2;
    Plates[3].LogicPosition = 1;
    Plates[4].LogicPosition = 5;
    Plates[5].LogicPosition = 8;
    Plates[6].LogicPosition = 7;
    Plates[7].LogicPosition = 4;
    Plates[PlateAmount].LogicPosition = 6;
    recentlyMoved = 6;
    I = 0;
    J0x14C:

    // End:0x194 [Loop If]
    if(I < Steps)
    {
        // End:0x186
        if(!IfPossibleTryMovePlate(recentlyMoved))
        {
            --I;
        }
        ++I;
        // [Loop Continue]
        goto J0x14C;
    }
    recentlyMoved = 8;
    J0x1A0:

    // End:0x1E2 [Loop If]
    if(Plates[PlateAmount].LogicPosition != 0)
    {
        IfPossibleTryMovePlate(recentlyMoved);
        // [Loop Continue]
        goto J0x1A0;
    }
    //return;    
}

function bool IfPossibleTryMovePlate(out int recentlyMoved)
{
    local int Randomized;

    J0x00:
    Randomized = Rand(PlateAmount - 1);
    // End:0x00
    if(!(Randomized != recentlyMoved))
        goto J0x00;
    // End:0x1AA
    if((((Plates[PlateAmount].LogicPosition == (Plates[Randomized].LogicPosition - 1)) || Plates[PlateAmount].LogicPosition == (Plates[Randomized].LogicPosition + 1)) || Plates[PlateAmount].LogicPosition == (Plates[Randomized].LogicPosition - AxisSize)) || Plates[PlateAmount].LogicPosition == (Plates[Randomized].LogicPosition + AxisSize))
    {
        TryMovePlate(Randomized);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function RandomizePlatePositions()
{
    local int I, Randomized;

    I = 1;
    J0x0B:

    Randomized = Rand(PlateAmount);
    // End:0x8B
    if(Plates[Randomized].LogicPosition == -1)
    {
        Plates[Randomized].LogicPosition = I;
        ++I;
    }
    // End:0x0B
    if(!(I == (PlateAmount + 1)))
        goto J0x0B;
    Plates[PlateAmount].LogicPosition = 0;
    //return;    
}

function SetPlateModelsOntoPositions()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x2BE [Loop If]
    if(I <= PlateAmount)
    {
        Plates[I].PositionO.X = float(-((Plates[I].LogicPosition % AxisSize) * plateSize) - plateSize);
        Plates[I].PositionO.Z = float(-((Plates[I].LogicPosition / AxisSize) * plateSize) - plateSize);
        Plates[I].PositionO.Y = 0.0000000;
        Plates[I].PositionI = Plates[I].PositionO + Plates[I].Offset;
        // End:0x248
        if(PlateModelsInside[I] != none)
        {
            PlateModelsInside[I].SetTranslation(Plates[I].PositionI);
        }
        // End:0x2B0
        if(PlateModelsOutside[I] != none)
        {
            PlateModelsOutside[I].SetTranslation(Plates[I].PositionO);
        }
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    Plates[PlateAmount].PositionO.Y = 4.0000000;
    Plates[PlateAmount].PositionI = Plates[PlateAmount].PositionO + Plates[PlateAmount].Offset;
    PlateModelsInside[PlateAmount].SetTranslation(Plates[PlateAmount].PositionI);
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

    // End:0x1A
    if(!super.SetPawn(P))
    {
        return false;
    }
    C = P.Controller;
    // End:0xC6
    if(EvilPlayerController(C) != none)
    {
        C.UnPossess();
        C.Possess(self, false);
        EvilPlayerController(C).GotoState('JigsawPuzzleControlling');
    }
    return true;
    //return ReturnValue;    
}

function SetTextfield()
{
    super.SetTextfield();
    // End:0x1F1
    if(AdvPlayerController(self.Controller).PlayerInput.bUsingGamepad)
    {
        HintString = "\n";        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "PicPuzzleMove", "EvilGame"), PlayerController(self.Controller)));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "JigsawMoveP", "EvilGame"), PlayerController(self.Controller)));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "JigsawExit", "EvilGame"), PlayerController(self.Controller)));        
    }
    else
    {
        HintString = "\n";        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "JigsawMoveC", "EvilGame"), PlayerController(self.Controller)));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "JigsawMoveP_PC", "EvilGame"), PlayerController(self.Controller)));        
        HintString @= ("\n" @ Class'AdvGFxHud'.static.ParseString(Localize("Captions", "JigsawExit_PC", "EvilGame"), PlayerController(self.Controller)));
    }
    TextField.SetBool("html", true);
    TextField.SetString("htmlText", HintString);
    //return;    
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Vector NewPosition;

    NewPosition.Y = -220.0000000;
    NewPosition.X = 0.0000000;
    NewPosition.Z = 0.0000000;
    NewPosition = TransformVectorByRotation(Rotation, NewPosition);
    NewRotation = Rotation;
    NewRotation.Yaw += (182 * 90);
    out_CamLoc = Location + NewPosition;
    out_CamRot = NewRotation;
    return true;
    //return ReturnValue;    
}

function bool IsOverPlate(Vector Position)
{
    local int I;
    local bool Result;
    local Vector LocalCursorPosition;

    LocalCursorPosition = (Position - self.Location) << self.Rotation;
    Result = false;
    I = 0;
    J0x5B:

    // End:0x34B [Loop If]
    if(I < PlateAmount)
    {
        // End:0x25E
        if((((Abs(Plates[I].PositionO.X - LocalCursorPosition.X) < float(plateSize / 2)) && Abs(Plates[I].PositionO.Z - LocalCursorPosition.Z) < float(plateSize / 2)) && !bIsPlateMoving) && !bPuzzleResult)
        {
            Plates[I].bIsSelected = true;
            // End:0x1F1
            if(HighlightingMaterials[2 * I] != none)
            {
                HighlightingMaterials[2 * I].SetScalarParameterValue('Selected', 1.0000000);
            }
            // End:0x24F
            if(HighlightingMaterials[(2 * I) + 1] != none)
            {
                HighlightingMaterials[(2 * I) + 1].SetScalarParameterValue('Selected', 1.0000000);
            }
            Result = true;            
        }
        else
        {
            Plates[I].bIsSelected = false;
            // End:0x2DF
            if(HighlightingMaterials[2 * I] != none)
            {
                HighlightingMaterials[2 * I].SetScalarParameterValue('Selected', 0.0000000);
            }
            // End:0x33D
            if(HighlightingMaterials[(2 * I) + 1] != none)
            {
                HighlightingMaterials[(2 * I) + 1].SetScalarParameterValue('Selected', 0.0000000);
            }
        }
        ++I;
        // [Loop Continue]
        goto J0x5B;
    }
    return Result;
    //return ReturnValue;    
}

function TryMovePlate(int I)
{
    // End:0xAF
    if((Plates[PlateAmount].LogicPosition == (Plates[I].LogicPosition - 1)) && (Plates[I].LogicPosition % AxisSize) != 0)
    {
        MoveDirection = 0;
        MovePlate(I);        
    }
    else
    {
        // End:0x169
        if((Plates[PlateAmount].LogicPosition == (Plates[I].LogicPosition + 1)) && (Plates[I].LogicPosition % AxisSize) != (AxisSize - 1))
        {
            MoveDirection = 1;
            MovePlate(I);            
        }
        else
        {
            // End:0x220
            if((Plates[PlateAmount].LogicPosition == (Plates[I].LogicPosition - AxisSize)) && (Plates[I].LogicPosition / AxisSize) != 0)
            {
                MoveDirection = 2;
                MovePlate(I);                
            }
            else
            {
                // End:0x2DF
                if((Plates[PlateAmount].LogicPosition == (Plates[I].LogicPosition + AxisSize)) && (Plates[I].LogicPosition / AxisSize) != (AxisSize - 1))
                {
                    MoveDirection = 3;
                    MovePlate(I);
                }
            }
        }
    }
    //return;    
}

function Click()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x70 [Loop If]
    if(I < PlateAmount)
    {
        // End:0x62
        if(Plates[I].bIsSelected)
        {
            TryMovePlate(I);
            // [Explicit Break]
            goto J0x70;
        }
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    J0x70:

    //return;    
}

function MovePlate(int currentPlate)
{
    local int tempLogicalPosition;

    switch(currentPlate % 2)
    {
        // End:0x54
        case 0:
            // End:0x51
            if((PlateMovesInSound != none) && bInitialized)
            {
                PlaySound(PlateMovesInSound);
            }
            // End:0x90
            break;
        // End:0xFFFF
        default:
            // End:0x8D
            if((PlateMovesOutSound != none) && bInitialized)
            {
                PlaySound(PlateMovesOutSound);
            }
            // End:0x90
            break;
            break;
    }
    switch(MoveDirection)
    {
        // End:0xA8
        case 0:
        // End:0x136
        case 1:
            From = Plates[currentPlate].PositionO.X;
            To = Plates[PlateAmount].PositionO.X;
            // End:0x1CC
            break;
        // End:0x13B
        case 2:
        // End:0x1C9
        case 3:
            From = Plates[currentPlate].PositionO.Z;
            To = Plates[PlateAmount].PositionO.Z;
            // End:0x1CC
            break;
        // End:0xFFFF
        default:
            break;
    }
    Plates[PlateAmount].PositionO = Plates[currentPlate].PositionO;
    which = currentPlate;
    plateMovePhase = 0;
    bIsPlateMoving = true;
    tempLogicalPosition = Plates[currentPlate].LogicPosition;
    Plates[currentPlate].LogicPosition = Plates[PlateAmount].LogicPosition;
    Plates[PlateAmount].LogicPosition = tempLogicalPosition;
    //return;    
}

function PlateMovement(float DeltaTime)
{
    switch(plateMovePhase)
    {
        // End:0x34
        case 0:
            plateMoveSpeed = 70.0000000 * DeltaTime;
            // End:0x58
            break;
        // End:0x55
        case 1:
            plateMoveSpeed = 50.0000000 * DeltaTime;
            // End:0x58
            break;
        // End:0xFFFF
        default:
            break;
    }
    switch(MoveDirection)
    {
        // End:0x220
        case 0:
            Plates[which].PositionO.X += plateMoveSpeed;
            Plates[which].PositionI.X += plateMoveSpeed;
            From = Plates[which].PositionO.X;
            // End:0x21D
            if(From >= To)
            {
                Plates[which].PositionO.X = To;
                Plates[which].PositionI.X = To + Plates[which].Offset.X;
                CheckEndPuzzle();
            }
            // End:0x742
            break;
        // End:0x3D5
        case 1:
            Plates[which].PositionO.X -= plateMoveSpeed;
            Plates[which].PositionI.X -= plateMoveSpeed;
            From = Plates[which].PositionO.X;
            // End:0x3D2
            if(From <= To)
            {
                Plates[which].PositionO.X = To;
                Plates[which].PositionI.X = To + Plates[which].Offset.X;
                CheckEndPuzzle();
            }
            // End:0x742
            break;
        // End:0x58A
        case 2:
            Plates[which].PositionO.Z += plateMoveSpeed;
            Plates[which].PositionI.Z += plateMoveSpeed;
            From = Plates[which].PositionO.Z;
            // End:0x587
            if(From >= To)
            {
                Plates[which].PositionO.Z = To;
                Plates[which].PositionI.Z = To + Plates[which].Offset.Z;
                CheckEndPuzzle();
            }
            // End:0x742
            break;
        // End:0x73F
        case 3:
            Plates[which].PositionO.Z -= plateMoveSpeed;
            Plates[which].PositionI.Z -= plateMoveSpeed;
            From = Plates[which].PositionO.Z;
            // End:0x73C
            if(From <= To)
            {
                Plates[which].PositionO.Z = To;
                Plates[which].PositionI.Z = To + Plates[which].Offset.Z;
                CheckEndPuzzle();
            }
            // End:0x742
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x7AA
    if(PlateModelsInside[which] != none)
    {
        PlateModelsInside[which].SetTranslation(Plates[which].PositionI);
    }
    PlateModelsOutside[which].SetTranslation(Plates[which].PositionO);
    // End:0x823
    if(Abs(From - To) < float(6))
    {
        plateMovePhase = 1;
    }
    //return;    
}

function WaitForMachinery()
{
    bPuzzleResult = true;
    // End:0x33
    if(MachinerySound != none)
    {
        PlaySound(MachinerySound);
    }
    //return;    
}

function FinalMovement(float DeltaTime)
{
    switch(GroupsToFinalMove)
    {
        // End:0x1A0
        case 0:
            Plates[PlateAmount].PositionI.Y -= (3.0000000 * DeltaTime);
            PlateModelsInside[PlateAmount].SetTranslation(Plates[PlateAmount].PositionI);
            // End:0x19D
            if(Plates[PlateAmount].PositionI.Y <= float(0))
            {
                Plates[PlateAmount].PositionI.Y = 0.0000000;
                GroupsToFinalMove = 1;
                plateMoveSpeed = 2.5000000 * DeltaTime;
                plateRotationSpeed = int(float(13250) * DeltaTime);
                // End:0x19D
                if(CircleSound != none)
                {
                    PlaySound(CircleSound);
                }
            }
            // End:0x9A8
            break;
        // End:0x521
        case 1:
            plateMoveSpeed = 2.5000000 * DeltaTime;
            plateRotationSpeed = int(float(13250) * DeltaTime);
            plateRotation.Pitch += plateRotationSpeed;
            J = 0;
            J0x20F:

            // End:0x326 [Loop If]
            if(J < PlateModelsInside.Length)
            {
                // End:0x318
                if(PlateModelsInside[J] != none)
                {
                    PlateModelsInside[J].SetRotation(plateRotation);
                    Plates[J].PositionI.Y += plateMoveSpeed;
                    PositionAfterRotation = Plates[J].PositionI;
                    PlateModelsInside[J].SetTranslation(PositionAfterRotation);
                }
                ++J;
                // [Loop Continue]
                goto J0x20F;
            }
            PlateModelsOutside[4].SetRotation(plateRotation);
            Plates[4].PositionO.Y += plateMoveSpeed;
            PositionAfterRotation = Plates[4].PositionO;
            PlateModelsOutside[4].SetTranslation(PositionAfterRotation);
            Backgrounds[0].SetTranslation(PositionAfterRotation);
            // End:0x51E
            if((plateRotation.Pitch >= 32568) || PositionAfterRotation.Y >= (Plates[0].PositionO.Y + float(4)))
            {
                GroupsToFinalMove = 2;
                plateMovePhase = 0;
                plateMoveSpeed = 30.0000000 * DeltaTime;
                To = Plates[4].PositionO.Y + float(13);
                bPuzzleResult = false;
                SetTimer(1.5000000, false, 'WaitForMachinery');
            }
            // End:0x9A8
            break;
        // End:0x5AE
        case 3:
            plateMoveSpeed = 30.0000000 * DeltaTime;
            PositionAfterRotation.Y -= 17.0000000;
            FrameInside.SetTranslation(PositionAfterRotation);
            PositionAfterRotation.Y += 17.0000000;
        // End:0x99D
        case 2:
            plateMoveSpeed = 30.0000000 * DeltaTime;
            J = 0;
            J0x5D8:

            // End:0x6CF [Loop If]
            if(J < PlateModelsOutside.Length)
            {
                // End:0x6C1
                if((PlateModelsOutside[J] != none) && J != 4)
                {
                    Plates[J].PositionO.Y += plateMoveSpeed;
                    PositionAfterRotation = Plates[J].PositionO;
                    PlateModelsOutside[J].SetTranslation(PositionAfterRotation);
                }
                ++J;
                // [Loop Continue]
                goto J0x5D8;
            }
            J = 0;
            J0x6DA:

            // End:0x7BF [Loop If]
            if(J < PlateModelsInside.Length)
            {
                // End:0x7B1
                if(PlateModelsInside[J] != none)
                {
                    Plates[J].PositionI.Y += plateMoveSpeed;
                    PositionAfterRotation = Plates[J].PositionI;
                    PlateModelsInside[J].SetTranslation(PositionAfterRotation);
                }
                ++J;
                // [Loop Continue]
                goto J0x6DA;
            }
            Plates[4].PositionO.Y += plateMoveSpeed;
            PositionAfterRotation = Plates[4].PositionO;
            PlateModelsOutside[4].SetTranslation(PositionAfterRotation);
            Backgrounds[0].SetTranslation(PositionAfterRotation);
            PositionAfterRotation.Y -= 6.0000000;
            Backgrounds[1].SetTranslation(PositionAfterRotation);
            PositionAfterRotation.Y += 6.0000000;
            // End:0x99A
            if(PositionAfterRotation.Y >= To)
            {
                // End:0x979
                if(int(GroupsToFinalMove) == int(2))
                {
                    GroupsToFinalMove = 3;
                    To = Plates[4].PositionO.Y + float(11);                    
                }
                else
                {
                    GroupsToFinalMove = 4;
                    SetPlacesAfterFinalMovement(int(To));
                }
            }
            // End:0x9A8
            break;
        // End:0x9A5
        case 4:
            // End:0x9A8
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function SetPlacesAfterFinalMovement(int pos)
{
    J = 0;
    J0x0B:

    // End:0x107 [Loop If]
    if(J < PlateModelsOutside.Length)
    {
        // End:0xF9
        if((PlateModelsOutside[J] != none) && J != 4)
        {
            Plates[J].PositionO.Y = float(pos - 4);
            PositionAfterRotation = Plates[J].PositionO;
            PlateModelsOutside[J].SetTranslation(PositionAfterRotation);
        }
        ++J;
        // [Loop Continue]
        goto J0x0B;
    }
    J = 0;
    J0x112:

    // End:0x1F8 [Loop If]
    if(J < PlateModelsInside.Length)
    {
        // End:0x1EA
        if(PlateModelsInside[J] != none)
        {
            Plates[J].PositionI.Y = float(pos);
            PositionAfterRotation = Plates[J].PositionI;
            PlateModelsInside[J].SetTranslation(PositionAfterRotation);
        }
        ++J;
        // [Loop Continue]
        goto J0x112;
    }
    Plates[4].PositionO.Y = float(pos);
    PositionAfterRotation = Plates[4].PositionO;
    PlateModelsOutside[4].SetTranslation(PositionAfterRotation);
    Backgrounds[0].SetTranslation(PositionAfterRotation);
    PositionAfterRotation.Y -= 6.0000000;
    Backgrounds[1].SetTranslation(PositionAfterRotation);
    PositionAfterRotation.Y += 6.0000000;
    PositionAfterRotation.Y -= (17.0000000 + float(1));
    FrameInside.SetTranslation(PositionAfterRotation);
    PositionAfterRotation.Y += (17.0000000 + float(1));
    //return;    
}

function CheckEndPuzzle()
{
    local int I;

    bPuzzleResult = true;
    bIsPlateMoving = false;
    plateMovePhase = 0;
    I = 0;
    J0x2E:

    // End:0x95 [Loop If]
    if(I < PlateAmount)
    {
        // End:0x87
        if(Plates[I].LogicPosition != I)
        {
            bPuzzleResult = false;
            return;
        }
        ++I;
        // [Loop Continue]
        goto J0x2E;
    }
    SetTimer(0.1000000, false, 'WaitEnding');
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
    // End:0x14A
    if(GameSeq != none)
    {
        // End:0x86
        if(bPuzzleResult)
        {
            ActivateIndices[0] = 0;
            // End:0x83
            if(SmallBlockSound != none)
            {
                PlaySound(SmallBlockSound);
            }            
        }
        else
        {
            ActivateIndices[0] = 1;
        }
        GameSeq.FindSeqObjectsByClass(Class'EvilGame.SeqEvent_Activated', true, ExecutionEvents);
        // End:0x149
        foreach ExecutionEvents(ExecutionEvent)
        {
            FireEvent = SeqEvent_Activated(ExecutionEvent);
            // End:0x148
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
    I = 0;
    J0x15:

    // End:0x119 [Loop If]
    if(I < PlateAmount)
    {
        Plates[I].bIsSelected = false;
        // End:0xAD
        if(HighlightingMaterials[2 * I] != none)
        {
            HighlightingMaterials[2 * I].SetScalarParameterValue('Selected', 0.0000000);
        }
        // End:0x10B
        if(HighlightingMaterials[(2 * I) + 1] != none)
        {
            HighlightingMaterials[(2 * I) + 1].SetScalarParameterValue('Selected', 0.0000000);
        }
        ++I;
        // [Loop Continue]
        goto J0x15;
    }
    //return;    
}

event Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
    // End:0x36
    if(bIsPlateMoving)
    {
        PlateMovement(DeltaTime);        
    }
    else
    {
        // End:0x56
        if(bPuzzleResult)
        {
            FinalMovement(DeltaTime);
        }
    }
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.MeshInside0'
    begin object name=MeshInside0 class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    PlateModelsInside[0]=MeshInside0
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.MeshInside1'
    begin object name=MeshInside1 class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    PlateModelsInside[1]=MeshInside1
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.MeshInside2'
    begin object name=MeshInside2 class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    PlateModelsInside[2]=MeshInside2
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.MeshInside3'
    begin object name=MeshInside3 class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    PlateModelsInside[3]=MeshInside3
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.MeshInside4Hidden'
    begin object name=MeshInside4Hidden class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    PlateModelsInside[4]=MeshInside4Hidden
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.MeshInside5'
    begin object name=MeshInside5 class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    PlateModelsInside[5]=MeshInside5
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.MeshInside6'
    begin object name=MeshInside6 class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    PlateModelsInside[6]=MeshInside6
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.MeshInside7'
    begin object name=MeshInside7 class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    PlateModelsInside[7]=MeshInside7
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.MeshInside8'
    begin object name=MeshInside8 class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    PlateModelsInside[8]=MeshInside8
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.MeshOutside0'
    begin object name=MeshOutside0 class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    PlateModelsOutside[0]=MeshOutside0
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.MeshOutside1'
    begin object name=MeshOutside1 class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    PlateModelsOutside[1]=MeshOutside1
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.MeshOutside2'
    begin object name=MeshOutside2 class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    PlateModelsOutside[2]=MeshOutside2
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.MeshOutside3'
    begin object name=MeshOutside3 class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    PlateModelsOutside[3]=MeshOutside3
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.MeshInside4'
    begin object name=MeshInside4 class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    PlateModelsOutside[4]=MeshInside4
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.MeshOutside4'
    begin object name=MeshOutside4 class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    PlateModelsOutside[5]=MeshOutside4
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.MeshOutside5'
    begin object name=MeshOutside5 class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    PlateModelsOutside[6]=MeshOutside5
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.MeshOutside6'
    begin object name=MeshOutside6 class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    PlateModelsOutside[7]=MeshOutside6
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.MeshOutside7Hidden'
    begin object name=MeshOutside7Hidden class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    PlateModelsOutside[8]=MeshOutside7Hidden
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.FInside'
    begin object name=FInside class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    FrameInside=FInside
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.FOutside'
    begin object name=FOutside class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    FrameOutside=FOutside
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.InBackgr'
    begin object name=InBackgr class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    Backgrounds[0]=InBackgr
    // Reference: StaticMeshComponent'Default__AdvJigsawPuzzle_base.OutBackgr'
    begin object name=OutBackgr class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
        LightingChannels=(Dynamic=true)
    end object
    Backgrounds[1]=OutBackgr
    // Reference: EvilCaptionComponent'Default__AdvJigsawPuzzle_base.CaptionComp'
    begin object name=CaptionComp
        Offset=(X=0.0000000,Y=0.0000000,Z=80.0000000)
    end object
    CaptionComponent=CaptionComp
    // Reference: DynamicLightEnvironmentComponent'Default__AdvJigsawPuzzle_base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WalkingPhysics=EPhysics.PHYS_Flying
    // Reference: CylinderComponent'Default__AdvJigsawPuzzle_base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=none
    Components[2]=CaptionComp
    Components[3]=MyLightEnvironment
    Components[4]=FInside
    Components[5]=FOutside
    Components[6]=InBackgr
    Components[7]=OutBackgr
    Components[8]=MeshInside0
    Components[9]=MeshInside1
    Components[10]=MeshInside2
    Components[11]=MeshInside3
    Components[12]=MeshInside4Hidden
    Components[13]=MeshInside5
    Components[14]=MeshInside6
    Components[15]=MeshInside7
    Components[16]=MeshInside8
    Components[17]=MeshOutside0
    Components[18]=MeshOutside1
    Components[19]=MeshOutside2
    Components[20]=MeshOutside3
    Components[21]=MeshInside4
    Components[22]=MeshOutside4
    Components[23]=MeshOutside5
    Components[24]=MeshOutside6
    Components[25]=MeshOutside7Hidden
    Physics=EPhysics.PHYS_Interpolating
    CollisionComponent=CollisionCylinder
}