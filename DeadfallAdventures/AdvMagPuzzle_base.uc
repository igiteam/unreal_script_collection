class AdvMagPuzzle_base extends AdvPuzzle_Base
    abstract
    config(Game)
    hidecategories(Navigation);

struct MGText
{
    var bool bSelected;
    var string Letter;
    var int bVisibilityTime;
    var bool bDecrypted;
    var bool bIsAnswer;

    structdefaultproperties
    {
        bSelected=false
        Letter=""
        bVisibilityTime=5
        bDecrypted=false
        bIsAnswer=false
    }
};

var SoundCue LetterFoundSound;
var() SoundCue VictorySound;
var() SoundCue WrongSound;
var() SoundCue LineDecryptedSound;
var() Texture Background;
var int DecryptTime;
var int DrawCount;
var int Line1;
var int Line2;
var int Line3;
var int Line4;
var int LettersCount;
var() int LineLength;
var bool bDecryptTime;
var bool bSuccess;
var bool bDecrypting;
var bool bFinalize;
var() bool bInfiniteTime;
var bool bDrawMagPuzzle;
var bool bMarkCurrent;
var() int RotationY;
var array<string> SearchLetters1;
var array<string> SearchLetters2;
var array<string> SearchLetters3;
var array<string> SearchLetters4;
var array<string> FinalText1;
var array<string> FinalText2;
var array<string> FinalText3;
var array<string> FinalText4;
var int rotationcount;
var() array<Texture> letters;
var() array<Texture> altletters;
var int CorrectCount;
var int LastFound;
var array<int> SelectionCount;
var int CurrentLine;
var int CurrentLetter;
var() Font RegularFont;
var() int PuzzleTime;
var Vector MagGlassPosition;
var float SinTimer;
var export editinline StaticMeshComponent MagGlassMesh;
var() const export editinline StaticMeshComponent Surface;
var MaterialInstanceConstant CanvasMaterial;
var MaterialInstanceConstant GlassMaterial;
var() int CanvasMaterialIndex;
var() name CanvasMaterialParameterName;
var Color TextColor;
var ScriptedTexture STexture;
var ScriptedTexture GlassTexture;
var Rotator BaseRotation;
var int DecryptLine;
var array<MGText> TextLine1;
var array<MGText> TextLine2;
var array<MGText> TextLine3;
var array<MGText> TextLine4;
var() Vector2D MagGlassOffsetMin;
var() Vector2D MagGlassOffsetMax;

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Rotator tempRot;
    local Vector NewLoc, Offset;
    local Rotator surfacerot, magrot;

    magrot.Pitch = 32768;
    magrot.Yaw = 32768 + (RotationY * 16384);
    // End:0x93
    if(RotationY == 2)
    {
        magrot.Roll -= (49152 - 10384);        
    }
    else
    {
        magrot.Roll -= 38768;
    }
    surfacerot.Pitch = 32768;
    surfacerot.Roll = 49152;
    surfacerot.Yaw = 49152 + (RotationY * 16384);
    tempRot = Rotation;
    tempRot.Pitch += 32768;
    tempRot.Yaw += (RotationY * 16384);
    tempRot.Roll += (49152 * 2);
    // End:0x1ED
    if(RotationY == 0)
    {
        Offset.Y = -4.0000000;        
    }
    else
    {
        Offset.Y = 4.0000000;
    }
    Offset.X = 4.0000000;
    // End:0x2E3
    if(RotationY == 0)
    {
        NewLoc.Z = MagGlassPosition.Z * float(4);
        NewLoc.Y = MagGlassPosition.X * float(4);
        NewLoc.X = -5.0000000;        
    }
    else
    {
        // End:0x397
        if(RotationY == 1)
        {
            NewLoc.Z = MagGlassPosition.Z * float(4);
            NewLoc.X = -MagGlassPosition.X * float(4);
            NewLoc.Y = -17.0000000;            
        }
        else
        {
            // End:0x44C
            if(RotationY == 2)
            {
                NewLoc.Z = MagGlassPosition.Z * float(4);
                NewLoc.Y = -MagGlassPosition.X * float(4);
                NewLoc.X = 17.0000000;                
            }
            else
            {
                // End:0x4FC
                if(RotationY == 3)
                {
                    NewLoc.Z = MagGlassPosition.Z * float(4);
                    NewLoc.X = MagGlassPosition.X * float(4);
                    NewLoc.Y = 17.0000000;
                }
            }
        }
    }
    out_CamLoc = ((Location + NewLoc) + Offset) + (Normal(Vector(tempRot)) * float(70));
    out_CamRot = Rotator(((Location + NewLoc) + Offset) - out_CamLoc);
    out_CamRot.Roll = 0;
    Surface.SetRotation(surfacerot);
    MagGlassMesh.SetRotation(magrot);
    return true;
    //return ReturnValue;    
}

function bool SetPawn(Pawn P)
{
    local Controller C;
    local AdvGFxHudWrapper GFXHUD;

    return false;
    Presetup();
    P.SetHidden(true);
    P.SetPhysics(0);
    C = P.Controller;
    User = P;
    C.SetPhysics(0);
    C.SetCollisionType(1);
    // End:0x1BB
    if(EvilPlayerController(C) != none)
    {
        C.UnPossess();
        C.Possess(self, false);
        EvilPlayerController(C).GotoState('MagPuzzleControlling');
        GFXHUD = AdvGFxHudWrapper(EvilPlayerController(C).myHUD);
        GFXHUD.MagPuzzle = self;
        GFXHUD.bDrawTimer = true;
    }
    //return ReturnValue;    
}

function Presetup()
{
    STexture = ScriptedTexture(Class'Engine.ScriptedTexture'.static.Create(2048, 1024,, MakeLinearColor(0.0000000, 0.0000000, 0.0000000, 0.0000000), false));
    GlassTexture = ScriptedTexture(Class'Engine.ScriptedTexture'.static.Create(512, 256,, MakeLinearColor(0.0000000, 0.0000000, 0.0000000, 0.0000000), false));
    STexture.__Render__Delegate = OnRender;
    GlassTexture.__Render__Delegate = OnGlassRender;
    CanvasMaterial = new Class'Engine.MaterialInstanceConstant';
    GlassMaterial = new Class'Engine.MaterialInstanceConstant';
    // End:0x2C0
    if(CanvasMaterial != none)
    {
        CanvasMaterial.SetParent(Surface.GetMaterial(CanvasMaterialIndex));
        GlassMaterial.SetParent(MagGlassMesh.GetMaterial(CanvasMaterialIndex));
        // End:0x25E
        if(CanvasMaterialParameterName != 'None')
        {
            CanvasMaterial.SetTextureParameterValue(CanvasMaterialParameterName, STexture);
            GlassMaterial.SetTextureParameterValue(CanvasMaterialParameterName, GlassTexture);
        }
        Surface.SetMaterial(CanvasMaterialIndex, CanvasMaterial);
        MagGlassMesh.SetMaterial(CanvasMaterialIndex, GlassMaterial);
    }
    Start();
    //return;    
}

function OnGlassRender(Canvas C)
{
    local float xm, ym;

    xm = (((MagGlassPosition.X - MagGlassOffsetMin.X) * float(1050)) / (MagGlassOffsetMax.X - MagGlassOffsetMin.X)) / float(2048);
    ym = (150.0000000 + (((MagGlassPosition.Y - MagGlassOffsetMin.Y) * float(550)) / (MagGlassOffsetMax.Y - MagGlassOffsetMin.Y))) / float(1024);
    C.SetPos(0.0000000, 0.0000000, 0.0000000);
    C.DrawMaterialTile(CanvasMaterial, 1024.0000000, 512.0000000, xm, ym, 0.1000000, 0.2000000);
    GlassTexture.bNeedsUpdate = true;
    //return;    
}

function OnRender(Canvas C)
{
    local int I;

    C.SetPos(0.0000000, 0.0000000, 0.0000000);
    C.Font = RegularFont;
    C.SetDrawColor(byte(int(255) - int(TextColor.R)), byte(int(255) - int(TextColor.G)), byte(int(255) - int(TextColor.B)));
    // End:0x221
    if(DecryptTime > 50)
    {
        I = 0;
        J0x103:

        // End:0x221 [Loop If]
        if(I < DrawCount)
        {
            C.SetDrawColor(255, 0, 0);
            C.SetPos(((630.0000000 - float((LineLength / 2) * 100)) + float(100 * I)) + float(200), 75.0000000, 0.0000000);
            // End:0x1EB
            if(DecryptLine != 3)
            {
                C.DrawTexture(findletter(GetSearchedLetter(I)), 0.5000000);
            }
            C.Font = RegularFont;
            I++;
            // [Loop Continue]
            goto J0x103;
        }
    }
    DrawMagPuzzleText(C);
    // End:0x243
    if(bFinalize)
    {
        return;
    }
    C.SetDrawColor(byte(int(255) - int(TextColor.R)), byte(int(255) - int(TextColor.G)), byte(int(255) - int(TextColor.B)));
    // End:0x303
    if(bSuccess)
    {
        STexture.bNeedsUpdate = true;
    }
    //return;    
}

function Tick(float DeltaTime)
{
    local Rotator NewRotation;

    // End:0x166
    if(User != none)
    {
        SinTimer += DeltaTime;
        NewRotation.Pitch = int(float(MagGlassMesh.Rotation.Pitch) + (float(200) * Cos(SinTimer)));
        NewRotation.Roll = int(float(MagGlassMesh.Rotation.Roll) + (float(300) * Sin(SinTimer)));
        NewRotation.Yaw = MagGlassMesh.Rotation.Yaw;
        MagGlassMesh.SetRotation(NewRotation);
    }
    //return;    
}

function DrawMagPuzzleText(Canvas C)
{
    local int I, drawlength;

    // End:0x1E
    if(DecryptLine >= 0)
    {
        drawlength = 40;        
    }
    else
    {
        drawlength = LineLength;
    }
    I = 0;
    J0x3C:

    // End:0xB4 [Loop If]
    if(I < drawlength)
    {
        TextLine1[I].bSelected = DrawLine(C, TextLine1, 250.0000000, I, 0);
        I++;
        // [Loop Continue]
        goto J0x3C;
    }
    // End:0xD2
    if(DecryptLine >= 1)
    {
        drawlength = 40;        
    }
    else
    {
        drawlength = LineLength;
    }
    I = 0;
    J0xF0:

    // End:0x168 [Loop If]
    if(I < drawlength)
    {
        TextLine2[I].bSelected = DrawLine(C, TextLine2, 400.0000000, I, 1);
        I++;
        // [Loop Continue]
        goto J0xF0;
    }
    // End:0x187
    if(DecryptLine >= 2)
    {
        drawlength = 40;        
    }
    else
    {
        drawlength = LineLength;
    }
    I = 0;
    J0x1A5:

    // End:0x21E [Loop If]
    if(I < drawlength)
    {
        TextLine3[I].bSelected = DrawLine(C, TextLine3, 550.0000000, I, 2);
        I++;
        // [Loop Continue]
        goto J0x1A5;
    }
    // End:0x23D
    if(DecryptLine >= 3)
    {
        drawlength = 40;        
    }
    else
    {
        drawlength = LineLength;
    }
    I = 0;
    J0x25B:

    // End:0x2D4 [Loop If]
    if(I < drawlength)
    {
        TextLine4[I].bSelected = DrawLine(C, TextLine4, 700.0000000, I, 3);
        I++;
        // [Loop Continue]
        goto J0x25B;
    }
    rotationcount++;
    bMarkCurrent = false;
    // End:0x32A
    if((CorrectCount == LettersCount) && bDecrypting == false)
    {
        EndPuzzle();
        bDecryptTime = true;
    }
    //return;    
}

function bool DrawLine(Canvas C, array<MGText> Text, float Y, int I, int R)
{
    local bool Select;
    local float Scale;
    local int X, Size;
    local array<string> temptext;

    Select = false;
    temptext[0] = "a";
    temptext[1] = "b";
    temptext[2] = "c";
    temptext[3] = "d";
    temptext[4] = "e";
    temptext[5] = "f";
    temptext[6] = "g";
    temptext[7] = "h";
    temptext[8] = "i";
    temptext[9] = "j";
    temptext[10] = "k";
    temptext[11] = "l";
    temptext[12] = "m";
    temptext[13] = "n";
    temptext[14] = "o";
    temptext[15] = "p";
    temptext[16] = "q";
    temptext[17] = "r";
    temptext[18] = "s";
    temptext[19] = "t";
    temptext[20] = "u";
    temptext[21] = "w";
    temptext[22] = "x";
    temptext[23] = "y";
    temptext[24] = "z";
    // End:0x1CB
    if(R > DecryptLine)
    {
        Size = I * 100;        
    }
    else
    {
        Size = I * 25;
    }
    X = 100;
    // End:0x227
    if(R > DecryptLine)
    {
        X = 630 - ((LineLength / 2) * 100);
    }
    // End:0x2AE
    if(Text[I].bSelected)
    {
        Select = true;
        C.SetDrawColor(255, 0, 0);
        C.Font = RegularFont;        
    }
    else
    {
        C.SetDrawColor(255, 255, 255);
    }
    C.Font = RegularFont;
    // End:0x7BF
    if((CurrentLine == R) && CheckIfInsideGlass(float(X + Size), Y, 70.0000000, 70.0000000))
    {
        // End:0x634
        if(CheckIfInsideGlass(float(X + Size), Y, 40.0000000, 50.0000000))
        {
            // End:0x433
            if((Text[I].bSelected == false) && bMarkCurrent)
            {
                // End:0x429
                if(LetterFound(Text[I].Letter, R))
                {
                    Select = true;
                    bMarkCurrent = false;
                    SelectLetter();
                    CorrectCount++;                    
                }
                else
                {
                    WrongLetter();
                }
            }
            C.SetPos(float(X + Size), Y, 0.0000000);
            // End:0x4C8
            if(!Text[I].bSelected)
            {
                C.SetDrawColor(200, 255, 0);
            }
            // End:0x5DD
            if(R > DecryptLine)
            {
                // End:0x586
                if(Text[I].bSelected)
                {
                    C.SetDrawColor(255, 0, 0);
                    C.DrawTexture(findletter(Text[I].Letter), 0.6000000);                    
                }
                else
                {
                    C.DrawTexture(findletter(Text[I].Letter), 0.6000000);
                }                
            }
            else
            {
                C.DrawTexture(findletter(Text[I].Letter), 0.6000000);
            }            
        }
        else
        {
            C.SetPos(float(X + Size), Y, 0.0000000);
            // End:0x768
            if(R > DecryptLine)
            {
                // End:0x711
                if(!Text[I].bSelected)
                {
                    C.DrawTexture(findaltletter(Text[I].Letter), 0.4000000);                    
                }
                else
                {
                    C.DrawTexture(findletter(Text[I].Letter), 0.4000000);
                }                
            }
            else
            {
                C.DrawTexture(findletter(Text[I].Letter), 0.4000000);
            }
        }        
    }
    else
    {
        // End:0x823
        if(Text[I].bDecrypted)
        {
            C.Font = RegularFont;
            Scale = 3.0000000;            
        }
        else
        {
            Scale = 1.0000000;
            C.Font = RegularFont;
        }
        C.SetPos(float(X + Size), Y, 0.0000000);
        // End:0x8F3
        if((DecryptLine - R) == 0)
        {
            C.SetDrawColor(byte(int(15) + (rotationcount * 3)), 0, 0);            
        }
        else
        {
            // End:0x94C
            if(((DecryptLine - R) > 0) && R < CurrentLine)
            {
                C.SetDrawColor(255, 0, 0);
            }
        }
        // End:0xAB7
        if((DecryptLine - R) == 0)
        {
            // End:0xA35
            if((rotationcount <= 80) && Text[I].Letter != " ")
            {
                C.SetPos(100.0000000 + float(I * 25), Y, 0.0000000);
                // End:0xA32
                if(rotationcount <= 80)
                {
                    C.DrawText(temptext[Rand(25)], false, 3.0000000, 3.0000000);
                }                
            }
            else
            {
                C.SetDrawColor(255, 0, 0);
                C.DrawText(Text[I].Letter, false, Scale, Scale);
            }            
        }
        else
        {
            // End:0xBAB
            if((DecryptLine - R) < 0)
            {
                // End:0xB54
                if(!Text[I].bSelected)
                {
                    C.DrawTexture(findaltletter(Text[I].Letter), 0.4000000);                    
                }
                else
                {
                    C.DrawTexture(findletter(Text[I].Letter), 0.4000000);
                }                
            }
            else
            {
                // End:0xC1E
                if((DecryptLine - R) > 0)
                {
                    C.DrawText(Text[I].Letter, false, Scale, Scale);
                }
            }
        }
    }
    C.SetDrawColor(0, 0, 0);
    return Select;
    //return ReturnValue;    
}

function Texture findaltletter(string Letter)
{
    // End:0x20
    if(Letter == "a")
    {
        return altletters[0];        
    }
    else
    {
        // End:0x40
        if(Letter == "b")
        {
            return altletters[1];            
        }
        else
        {
            // End:0x61
            if(Letter == "c")
            {
                return altletters[2];                
            }
            else
            {
                // End:0x82
                if(Letter == "d")
                {
                    return altletters[3];                    
                }
                else
                {
                    // End:0xA3
                    if(Letter == "e")
                    {
                        return altletters[4];                        
                    }
                    else
                    {
                        // End:0xC4
                        if(Letter == "f")
                        {
                            return altletters[5];                            
                        }
                        else
                        {
                            // End:0xE5
                            if(Letter == "g")
                            {
                                return altletters[6];                                
                            }
                            else
                            {
                                // End:0x106
                                if(Letter == "h")
                                {
                                    return altletters[7];                                    
                                }
                                else
                                {
                                    // End:0x127
                                    if(Letter == "i")
                                    {
                                        return altletters[8];                                        
                                    }
                                    else
                                    {
                                        // End:0x148
                                        if(Letter == "j")
                                        {
                                            return altletters[9];                                            
                                        }
                                        else
                                        {
                                            // End:0x169
                                            if(Letter == "k")
                                            {
                                                return altletters[10];                                                
                                            }
                                            else
                                            {
                                                // End:0x18A
                                                if(Letter == "l")
                                                {
                                                    return altletters[11];                                                    
                                                }
                                                else
                                                {
                                                    // End:0x1AB
                                                    if(Letter == "m")
                                                    {
                                                        return altletters[12];                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x1CC
                                                        if(Letter == "n")
                                                        {
                                                            return altletters[13];                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x1ED
                                                            if(Letter == "o")
                                                            {
                                                                return altletters[14];                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x20E
                                                                if(Letter == "p")
                                                                {
                                                                    return altletters[15];                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // End:0x22F
                                                                    if(Letter == "r")
                                                                    {
                                                                        return altletters[16];                                                                        
                                                                    }
                                                                    else
                                                                    {
                                                                        // End:0x250
                                                                        if(Letter == "s")
                                                                        {
                                                                            return altletters[17];                                                                            
                                                                        }
                                                                        else
                                                                        {
                                                                            // End:0x271
                                                                            if(Letter == "t")
                                                                            {
                                                                                return altletters[18];                                                                                
                                                                            }
                                                                            else
                                                                            {
                                                                                // End:0x292
                                                                                if(Letter == "u")
                                                                                {
                                                                                    return altletters[19];                                                                                    
                                                                                }
                                                                                else
                                                                                {
                                                                                    // End:0x2B3
                                                                                    if(Letter == "w")
                                                                                    {
                                                                                        return altletters[20];                                                                                        
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        // End:0x2D4
                                                                                        if(Letter == "y")
                                                                                        {
                                                                                            return altletters[21];                                                                                            
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            // End:0x2F5
                                                                                            if(Letter == "z")
                                                                                            {
                                                                                                return altletters[22];                                                                                                
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                return altletters[0];
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //return ReturnValue;    
}

function Texture findletter(string Letter)
{
    // End:0x20
    if(Letter == "a")
    {
        return letters[0];        
    }
    else
    {
        // End:0x40
        if(Letter == "b")
        {
            return letters[1];            
        }
        else
        {
            // End:0x61
            if(Letter == "c")
            {
                return letters[2];                
            }
            else
            {
                // End:0x82
                if(Letter == "d")
                {
                    return letters[3];                    
                }
                else
                {
                    // End:0xA3
                    if(Letter == "e")
                    {
                        return letters[4];                        
                    }
                    else
                    {
                        // End:0xC4
                        if(Letter == "f")
                        {
                            return letters[5];                            
                        }
                        else
                        {
                            // End:0xE5
                            if(Letter == "g")
                            {
                                return letters[6];                                
                            }
                            else
                            {
                                // End:0x106
                                if(Letter == "h")
                                {
                                    return letters[7];                                    
                                }
                                else
                                {
                                    // End:0x127
                                    if(Letter == "i")
                                    {
                                        return letters[8];                                        
                                    }
                                    else
                                    {
                                        // End:0x148
                                        if(Letter == "j")
                                        {
                                            return letters[9];                                            
                                        }
                                        else
                                        {
                                            // End:0x169
                                            if(Letter == "k")
                                            {
                                                return letters[10];                                                
                                            }
                                            else
                                            {
                                                // End:0x18A
                                                if(Letter == "l")
                                                {
                                                    return letters[11];                                                    
                                                }
                                                else
                                                {
                                                    // End:0x1AB
                                                    if(Letter == "m")
                                                    {
                                                        return letters[12];                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x1CC
                                                        if(Letter == "n")
                                                        {
                                                            return letters[13];                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x1ED
                                                            if(Letter == "o")
                                                            {
                                                                return letters[14];                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x20E
                                                                if(Letter == "p")
                                                                {
                                                                    return letters[15];                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // End:0x22F
                                                                    if(Letter == "r")
                                                                    {
                                                                        return letters[16];                                                                        
                                                                    }
                                                                    else
                                                                    {
                                                                        // End:0x250
                                                                        if(Letter == "s")
                                                                        {
                                                                            return letters[17];                                                                            
                                                                        }
                                                                        else
                                                                        {
                                                                            // End:0x271
                                                                            if(Letter == "t")
                                                                            {
                                                                                return letters[18];                                                                                
                                                                            }
                                                                            else
                                                                            {
                                                                                // End:0x292
                                                                                if(Letter == "u")
                                                                                {
                                                                                    return letters[19];                                                                                    
                                                                                }
                                                                                else
                                                                                {
                                                                                    // End:0x2B3
                                                                                    if(Letter == "w")
                                                                                    {
                                                                                        return letters[20];                                                                                        
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        // End:0x2D4
                                                                                        if(Letter == "y")
                                                                                        {
                                                                                            return letters[21];                                                                                            
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            // End:0x2F5
                                                                                            if(Letter == "z")
                                                                                            {
                                                                                                return letters[22];                                                                                                
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                return letters[0];
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //return ReturnValue;    
}

function bool Start(optional bool StartPaused = false)
{
    GenerateText();
    SetTimer(0.2000000, true, 'ShowHelpLetters');
    SetTimer(1.0000000, true, 'PuzzleTimer');
    DrawCount = 0;
    bSuccess = true;
    CorrectCount = 0;
    LastFound = -1;
    DecryptTime = 100;
    bDecrypting = false;
    bFinalize = false;
    SelectionCount[0] = 0;
    SelectionCount[1] = 0;
    SelectionCount[2] = 0;
    SelectionCount[3] = 0;
    CurrentLine = 0;
    CurrentLetter = 0;
    return true;
    //return ReturnValue;    
}

function ShowHelpLetters()
{
    DrawCount++;
    // End:0x2E
    if(DrawCount >= 4)
    {
        SetTimer(0.0000000, true, 'ShowHelpLetters');
    }
    //return;    
}

function PuzzleTimer()
{
    // End:0x1A
    if(!bInfiniteTime)
    {
        PuzzleTime--;
    }
    // End:0x3F
    if(PuzzleTime <= 0)
    {
        bSuccess = false;
        EndPuzzle();
    }
    //return;    
}

function string GetSearchedLetter(int I)
{
    switch(CurrentLine)
    {
        // End:0x2E
        case 0:
            return SearchLetters1[I];
            // End:0x84
            break;
        // End:0x49
        case 1:
            return SearchLetters2[I];
            // End:0x84
            break;
        // End:0x65
        case 2:
            return SearchLetters3[I];
            // End:0x84
            break;
        // End:0x81
        case 3:
            return SearchLetters4[I];
            // End:0x84
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return ReturnValue;    
}

function DecryptTimer()
{
    DecryptTime -= 2;
    // End:0x51
    if(DecryptTime <= 0)
    {
        bDecrypting = false;
        bFinalize = true;
        SetTimer(0.0000000, false, 'DecryptTimer');
        EndSetup();
    }
    //return;    
}

function EndSetup()
{
    local Sequence GameSeq;
    local array<SequenceObject> ExecutionEvents;
    local SequenceObject ExecutionEvent;
    local SeqEvent_Activated FireEvent;
    local array<int> ActivateIndices;

    AdvGFxHudWrapper(EvilPlayerController(User.GetALocalPlayerController()).myHUD).bDrawTimer = false;
    AdvGFxHudWrapper(EvilPlayerController(User.GetALocalPlayerController()).myHUD).MagPuzzle = none;
    EvilPlayerController(User.GetALocalPlayerController()).Possess(User, false);
    User.SetHidden(false);
    User = none;
    EvilPlayerController(GetALocalPlayerController()).GotoState('PlayerWalking');
    GameSeq = WorldInfo.GetGameSequence();
    // End:0x276
    if(GameSeq != none)
    {
        // End:0x1B2
        if(PuzzleTime > 0)
        {
            ActivateIndices[0] = 0;            
        }
        else
        {
            ActivateIndices[0] = 1;
        }
        GameSeq.FindSeqObjectsByClass(Class'EvilGame.SeqEvent_Activated', true, ExecutionEvents);
        // End:0x275
        foreach ExecutionEvents(ExecutionEvent)
        {
            FireEvent = SeqEvent_Activated(ExecutionEvent);
            // End:0x274
            if(FireEvent.Originator == self)
            {
                FireEvent.CheckActivate(self, none, false, ActivateIndices);
            }            
        }        
    }
    //return;    
}

function bool LetterFound(string Letter, int R)
{
    local array<string> Search;

    switch(R)
    {
        // End:0x2D
        case 0:
            Search = SearchLetters1;
            // End:0x80
            break;
        // End:0x47
        case 1:
            Search = SearchLetters2;
            // End:0x80
            break;
        // End:0x62
        case 2:
            Search = SearchLetters3;
            // End:0x80
            break;
        // End:0x7D
        case 3:
            Search = SearchLetters4;
            // End:0x80
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0xCE
    if(Letter == Search[CurrentLetter])
    {
        PlaySound(LetterFoundSound);
        LastFound = R;
        return true;
    }
    return false;
    //return ReturnValue;    
}

function MoveMagnifyingGlass(float X, float Y)
{
    local Vector Move;
    local float speedmod;

    speedmod = 0.4000000;
    MagGlassPosition.X += (X * speedmod);
    MagGlassPosition.Y += (Y * speedmod);
    // End:0xEC
    if(MagGlassPosition.X > MagGlassOffsetMax.X)
    {
        MagGlassPosition.X = MagGlassOffsetMax.X;        
    }
    else
    {
        // End:0x162
        if(MagGlassPosition.X < MagGlassOffsetMin.X)
        {
            MagGlassPosition.X = MagGlassOffsetMin.X;
        }
    }
    // End:0x1DB
    if(MagGlassPosition.Y > MagGlassOffsetMax.Y)
    {
        MagGlassPosition.Y = MagGlassOffsetMax.Y;        
    }
    else
    {
        // End:0x251
        if(MagGlassPosition.Y < MagGlassOffsetMin.Y)
        {
            MagGlassPosition.Y = MagGlassOffsetMin.Y;
        }
    }
    // End:0x2F9
    if(RotationY == 0)
    {
        Move.Y = MagGlassPosition.X;
        Move.Z = -MagGlassPosition.Y;
        Move.X = -2.0000000;        
    }
    else
    {
        // End:0x3A3
        if(RotationY == 1)
        {
            Move.Z = -MagGlassPosition.Y;
            Move.X = -MagGlassPosition.X;
            Move.Y = -2.0000000;            
        }
        else
        {
            // End:0x44E
            if(RotationY == 2)
            {
                Move.Y = -MagGlassPosition.X;
                Move.Z = -MagGlassPosition.Y;
                Move.X = 2.0000000;                
            }
            else
            {
                // End:0x4F4
                if(RotationY == 3)
                {
                    Move.Z = -MagGlassPosition.Y;
                    Move.X = MagGlassPosition.X;
                    Move.Y = 2.0000000;
                }
            }
        }
    }
    MagGlassMesh.SetTranslation(Move);
    //return;    
}

function bool CheckIfInsideGlass(float X, float Y, float xradius, float yradius)
{
    local Vector2D Offset;
    local float xm, ym;

    xm = ((MagGlassPosition.X - MagGlassOffsetMin.X) * float(1050)) / (MagGlassOffsetMax.X - MagGlassOffsetMin.X);
    ym = ((MagGlassPosition.Y - MagGlassOffsetMin.Y) * float(550)) / (MagGlassOffsetMax.Y - MagGlassOffsetMin.Y);
    Offset.X = 50.0000000;
    Offset.Y = 150.0000000;
    // End:0x261
    if((((X < ((xm + xradius) + Offset.X)) && X > ((xm - xradius) + Offset.X)) && Y < ((ym + yradius) + Offset.Y)) && Y > ((ym - yradius) + Offset.Y))
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function GenerateText()
{
    local int I;
    local array<string> textTemplate;
    local MGText T;
    local int random1, random2, random3, random4, RandSeed, Position;

    RandSeed = Rand(4);
    LettersCount = ((Line1 + Line2) + Line3) + Line4;
    Position = Rand(LineLength);
    // End:0x96
    if(RandSeed == 0)
    {
        random1 = 8;
        random2 = 12;
        random3 = 16;
        random4 = 20;
    }
    // End:0xD5
    if(RandSeed == 1)
    {
        random1 = 20;
        random2 = 8;
        random3 = 12;
        random4 = 16;
    }
    // End:0x115
    if(RandSeed == 2)
    {
        random1 = 8;
        random2 = 16;
        random3 = 20;
        random4 = 12;
    }
    // End:0x155
    if(RandSeed == 3)
    {
        random1 = 16;
        random2 = 8;
        random3 = 12;
        random4 = 20;
    }
    textTemplate[0] = "a";
    textTemplate[1] = "a";
    textTemplate[2] = "b";
    textTemplate[3] = "c";
    textTemplate[4] = "d";
    textTemplate[5] = "e";
    textTemplate[6] = "f";
    textTemplate[7] = "g";
    textTemplate[8] = "h";
    textTemplate[9] = "i";
    textTemplate[10] = "j";
    textTemplate[11] = "k";
    textTemplate[12] = "l";
    textTemplate[13] = "m";
    textTemplate[14] = "n";
    textTemplate[15] = "o";
    textTemplate[16] = "p";
    textTemplate[17] = "r";
    textTemplate[18] = "s";
    textTemplate[19] = "t";
    textTemplate[20] = "u";
    textTemplate[21] = "w";
    textTemplate[22] = "y";
    textTemplate[23] = "z";
    // End:0x48D
    if(TextLine1.Length == 40)
    {
        I = 0;
        J0x2EF:

        // End:0x48A [Loop If]
        if(I < 40)
        {
            T.bSelected = false;
            T.bDecrypted = false;
            T.bVisibilityTime = 5;
            T.Letter = textTemplate[Rand(8)];
            TextLine1[I] = T;
            T.Letter = textTemplate[Rand(8)];
            TextLine2[I] = T;
            T.Letter = textTemplate[Rand(8)];
            TextLine3[I] = T;
            T.Letter = textTemplate[Rand(8)];
            TextLine4[I] = T;
            I++;
            // [Loop Continue]
            goto J0x2EF;
        }        
    }
    else
    {
        I = 0;
        J0x498:

        // End:0x617 [Loop If]
        if(I < 40)
        {
            T.bSelected = false;
            T.bDecrypted = false;
            T.bVisibilityTime = 5;
            T.Letter = textTemplate[Rand(8)];
            TextLine1.AddItem(T);            
            T.Letter = textTemplate[Rand(8)];
            TextLine2.AddItem(T);            
            T.Letter = textTemplate[Rand(8)];
            TextLine3.AddItem(T);            
            T.Letter = textTemplate[Rand(8)];
            TextLine4.AddItem(T);            
            I++;
            // [Loop Continue]
            goto J0x498;
        }
    }
    I = 0;
    J0x622:

    // End:0x679 [Loop If]
    if(I < Line1)
    {
        SearchLetters1[I] = textTemplate[random1 + I];
        I++;
        // [Loop Continue]
        goto J0x622;
    }
    I = 0;
    J0x684:

    // End:0x6DB [Loop If]
    if(I < Line2)
    {
        SearchLetters2[I] = textTemplate[random2 + I];
        I++;
        // [Loop Continue]
        goto J0x684;
    }
    I = 0;
    J0x6E6:

    // End:0x73D [Loop If]
    if(I < Line3)
    {
        SearchLetters3[I] = textTemplate[random3 + I];
        I++;
        // [Loop Continue]
        goto J0x6E6;
    }
    I = 0;
    J0x748:

    // End:0x79F [Loop If]
    if(I < Line4)
    {
        SearchLetters4[I] = textTemplate[random4 + I];
        I++;
        // [Loop Continue]
        goto J0x748;
    }
    I = 0;
    J0x7AA:

    // End:0x8B4 [Loop If]
    if(I < Line1)
    {
        // End:0x868
        if(!TextLine1[Position].bIsAnswer)
        {
            TextLine1[Position].Letter = SearchLetters1[I];
            TextLine1[Position].bIsAnswer = true;
            Position = Rand(LineLength);            
        }
        else
        {
            I--;
        }
        // End:0x89B
        if(Position < (LineLength - 1))
        {
            Position++;            
        }
        else
        {
            Position = 0;
        }
        I++;
        // [Loop Continue]
        goto J0x7AA;
    }
    I = 0;
    J0x8BF:

    // End:0x9C9 [Loop If]
    if(I < Line2)
    {
        // End:0x97D
        if(!TextLine2[Position].bIsAnswer)
        {
            TextLine2[Position].Letter = SearchLetters2[I];
            TextLine2[Position].bIsAnswer = true;
            Position = Rand(LineLength);            
        }
        else
        {
            I--;
        }
        // End:0x9B0
        if(Position < (LineLength - 1))
        {
            Position++;            
        }
        else
        {
            Position = 0;
        }
        I++;
        // [Loop Continue]
        goto J0x8BF;
    }
    I = 0;
    J0x9D4:

    // End:0xADE [Loop If]
    if(I < Line3)
    {
        // End:0xA92
        if(!TextLine3[Position].bIsAnswer)
        {
            TextLine3[Position].Letter = SearchLetters3[I];
            TextLine3[Position].bIsAnswer = true;
            Position = Rand(LineLength);            
        }
        else
        {
            I--;
        }
        // End:0xAC5
        if(Position < (LineLength - 1))
        {
            Position++;            
        }
        else
        {
            Position = 0;
        }
        I++;
        // [Loop Continue]
        goto J0x9D4;
    }
    I = 0;
    J0xAE9:

    // End:0xBF3 [Loop If]
    if(I < Line4)
    {
        // End:0xBA7
        if(!TextLine4[Position].bIsAnswer)
        {
            TextLine4[Position].Letter = SearchLetters4[I];
            TextLine4[Position].bIsAnswer = true;
            Position = Rand(LineLength);            
        }
        else
        {
            I--;
        }
        // End:0xBDA
        if(Position < (LineLength - 1))
        {
            Position++;            
        }
        else
        {
            Position = 0;
        }
        I++;
        // [Loop Continue]
        goto J0xAE9;
    }
    //return;    
}

function int GetFreePlace(array<MGText> Text, array<string> Search)
{
    local int I, Index;
    local bool Free;

    Free = false;
    J0x0C:

    // End:0x14A [Loop If]
    if(true)
    {
        Index = 1 + Rand(LineLength);
        Free = true;
        I = 0;
        J0x3F:

        // End:0x130 [Loop If]
        if(I < 4)
        {
            // End:0x122
            if(((Text[Index].Letter == Search[I]) || Text[Index - 1].Letter == Search[I]) || Text[Index + 1].Letter == Search[I])
            {
                Free = false;
                // [Explicit Break]
                goto J0x130;
            }
            I++;
            // [Loop Continue]
            goto J0x3F;
        }
        J0x130:

        // End:0x147
        if(Free)
        {
            return Index;
        }
        // [Loop Continue]
        goto J0x0C;
    }
    //return ReturnValue;    
}

function SelectLetter()
{
    local int I;

    // End:0x3CB
    if(LastFound > -1)
    {
        SelectionCount[LastFound]++;
        CurrentLetter++;
        I = 0;
        J0x3E:

        // End:0x3A1 [Loop If]
        if(I < 4)
        {
            // End:0x393
            if((SelectionCount[I] == 4) && CurrentLine == I)
            {
                PlaySound(LineDecryptedSound);
                // End:0x155
                if(CurrentLine == 0)
                {
                    I = 0;
                    J0xB3:

                    // End:0x152 [Loop If]
                    if(I < 40)
                    {
                        DecryptLine = CurrentLine;
                        TextLine1[I].Letter = FinalText1[I];
                        TextLine1[I].bDecrypted = true;
                        rotationcount = 0;
                        I++;
                        // [Loop Continue]
                        goto J0xB3;
                    }                    
                }
                else
                {
                    // End:0x211
                    if(CurrentLine == 1)
                    {
                        I = 0;
                        J0x16F:

                        // End:0x20E [Loop If]
                        if(I < 40)
                        {
                            DecryptLine = CurrentLine;
                            TextLine2[I].Letter = FinalText2[I];
                            TextLine2[I].bDecrypted = true;
                            rotationcount = 0;
                            I++;
                            // [Loop Continue]
                            goto J0x16F;
                        }                        
                    }
                    else
                    {
                        // End:0x2CE
                        if(CurrentLine == 2)
                        {
                            I = 0;
                            J0x22C:

                            // End:0x2CB [Loop If]
                            if(I < 40)
                            {
                                DecryptLine = CurrentLine;
                                TextLine3[I].Letter = FinalText3[I];
                                TextLine3[I].bDecrypted = true;
                                rotationcount = 0;
                                I++;
                                // [Loop Continue]
                                goto J0x22C;
                            }                            
                        }
                        else
                        {
                            // End:0x388
                            if(CurrentLine == 3)
                            {
                                I = 0;
                                J0x2E9:

                                // End:0x388 [Loop If]
                                if(I < 40)
                                {
                                    DecryptLine = CurrentLine;
                                    TextLine4[I].Letter = FinalText4[I];
                                    TextLine4[I].bDecrypted = true;
                                    rotationcount = 0;
                                    I++;
                                    // [Loop Continue]
                                    goto J0x2E9;
                                }
                            }
                        }
                    }
                }
                CurrentLine++;
            }
            I++;
            // [Loop Continue]
            goto J0x3E;
        }
        // End:0x3BC
        if(CurrentLetter >= 4)
        {
            CurrentLetter = 0;
        }
        LastFound = -1;
    }
    //return;    
}

function WrongLetter()
{
    // End:0x24
    if(PuzzleTime <= 0)
    {
        PuzzleTime = 0;
        EndPuzzle();
    }
    PlaySound(WrongSound);
    //return;    
}

exec function EndPuzzle()
{
    bDecrypting = true;
    // End:0x2A
    if(!bFinalize)
    {
        // End:0x2A
        if(PuzzleTime > 0)
        {
        }
    }
    PlaySound(VictorySound);
    MagGlassMesh.SetHidden(true);
    SetTimer(0.0000000, false, 'PuzzleTimer');
    SetTimer(0.1000000, true, 'DecryptTimer');
    //return;    
}

defaultproperties
{
    // Reference: EvilCaptionComponent'Default__AdvMagPuzzle_base.CaptionComp'
    begin object name=CaptionComp
    end object
    CaptionComponent=CaptionComp
    // Reference: DynamicLightEnvironmentComponent'Default__AdvMagPuzzle_base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: CylinderComponent'Default__AdvMagPuzzle_base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=none
    Components[1]=none
    Components[2]=CaptionComp
    Components[3]=MyLightEnvironment
    CollisionComponent=CollisionCylinder
}