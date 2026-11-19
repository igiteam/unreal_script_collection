class TurokUIScript extends Object
    native;

var private string ScriptName;
var private string ChainScript;
var private bool bIsRunning;
var bool bMoveTo;
var private bool mColorDone;
var private bool mPositionDone;
var private bool mSizeDone;
var private bool mRotationDone;
var private float DeltaTime;
var private float StartTime;
var private float LastKeyTime;
var private array ColorKeys;
var private array PositionKeys;
var private array SizeKeys;
var private array RotationKeys;
var private @NULL MoveToColor;
var private @NULL MoveToPosition;
var private @NULL MoveToSize;
var private @NULL MoveToRotation;

// Export UTurokUIScript::execIsFinished(FFrame&, void* const)
native final function bool IsFinished();

// Export UTurokUIScript::execGetColorKey(FFrame&, void* const)
native final function @NULL GetColorKey(float key_time);

// Export UTurokUIScript::execGetPositionKey(FFrame&, void* const)
native final function @NULL GetPositionKey(float key_time);

// Export UTurokUIScript::execGetSizeKey(FFrame&, void* const)
native final function @NULL GetSizeKey(float key_time);

// Export UTurokUIScript::execGetRotationKey(FFrame&, void* const)
native final function @NULL GetRotationKey(float key_time);

function SetName(string script_name)
{
    ScriptName = script_name;
    //return;    
}

function string GetName()
{
    return ScriptName;
    //return ReturnValue;    
}

function bool HasName(string script_name)
{
    return script_name == ScriptName;
    //return ReturnValue;    
}

event SetChainScript(string script_name)
{
    ChainScript = script_name;
    //return;    
}

event @NULL AddColorKey(float key_time, @NULL the_color, optional byte mode = 0)
{
    local int I, Index;

    I = 0;
    J0x0D:

    // End:0x47 [Loop If]
    if(I < ColorKeys.Length)
    {
        // End:0x3D
        if(ColorKeys[I].KeyTime == key_time)
        {
            return none;
        }
        I++;
        // [Loop Continue]
        goto J0x0D;
    }
    Index = ColorKeys.Length;
    ColorKeys.Insert(Index, 1);
    ColorKeys[Index] = new (self) Class'TurokUIKeyColor';
    // End:0x177
    if(ColorKeys[Index] != none)
    {
        // End:0xA0
        if(LastKeyTime < key_time)
        {
            LastKeyTime = key_time;
        }
        ColorKeys[Index].KeyTime = key_time;
        ColorKeys[Index].TheColor = the_color;
        ColorKeys[Index].InterpMode = mode;
        // End:0x16B
        if((bMoveTo && ColorKeys.Length > 1) && MoveToColor == none)
        {
            MoveToColor = new (self) Class'TurokUIKeyColor';
            // End:0x16B
            if(MoveToColor != none)
            {
                MoveToColor.KeyTime = ColorKeys[0].KeyTime;
                MoveToColor.InterpMode = ColorKeys[0].InterpMode;
            }
        }
        return ColorKeys[Index];
    }
    return none;
    //return ReturnValue;    
}

event @NULL AddPositionKey(float key_time, float X, float Y, optional float Z = 0.0000000, optional byte mode = 0)
{
    local int I, Index;
    local @NULL V;

    V.X = X;
    V.Y = Y;
    I = 0;
    J0x40:

    // End:0x7A [Loop If]
    if(I < PositionKeys.Length)
    {
        // End:0x70
        if(PositionKeys[I].KeyTime == key_time)
        {
            return none;
        }
        I++;
        // [Loop Continue]
        goto J0x40;
    }
    Index = PositionKeys.Length;
    PositionKeys.Insert(Index, 1);
    PositionKeys[Index] = new (self) Class'TurokUIKeyPosition';
    // End:0x1AA
    if(PositionKeys[Index] != none)
    {
        // End:0xD3
        if(LastKeyTime < key_time)
        {
            LastKeyTime = key_time;
        }
        PositionKeys[Index].KeyTime = key_time;
        PositionKeys[Index].Position = V;
        PositionKeys[Index].InterpMode = mode;
        // End:0x19E
        if((bMoveTo && PositionKeys.Length > 1) && MoveToPosition == none)
        {
            MoveToPosition = new (self) Class'TurokUIKeyPosition';
            // End:0x19E
            if(MoveToPosition != none)
            {
                MoveToPosition.KeyTime = PositionKeys[0].KeyTime;
                MoveToPosition.InterpMode = PositionKeys[0].InterpMode;
            }
        }
        return PositionKeys[Index];
    }
    return none;
    //return ReturnValue;    
}

event @NULL AddSizeKey(float key_time, float Width, optional float Height = 0.0000000, optional byte mode = 0)
{
    local int I, Index;
    local @NULL Size;

    Size.X = Width;
    Size.Y = Height;
    I = 0;
    J0x40:

    // End:0x7A [Loop If]
    if(I < SizeKeys.Length)
    {
        // End:0x70
        if(SizeKeys[I].KeyTime == key_time)
        {
            return none;
        }
        I++;
        // [Loop Continue]
        goto J0x40;
    }
    Index = SizeKeys.Length;
    SizeKeys.Insert(Index, 1);
    SizeKeys[Index] = new (self) Class'TurokUIKeySize';
    // End:0x1AA
    if(SizeKeys[Index] != none)
    {
        // End:0xD3
        if(LastKeyTime < key_time)
        {
            LastKeyTime = key_time;
        }
        SizeKeys[Index].KeyTime = key_time;
        SizeKeys[Index].Size = Size;
        SizeKeys[Index].InterpMode = mode;
        // End:0x19E
        if((bMoveTo && SizeKeys.Length > 1) && MoveToSize == none)
        {
            MoveToSize = new (self) Class'TurokUIKeySize';
            // End:0x19E
            if(MoveToSize != none)
            {
                MoveToSize.KeyTime = SizeKeys[0].KeyTime;
                MoveToSize.InterpMode = SizeKeys[0].InterpMode;
            }
        }
        return SizeKeys[Index];
    }
    return none;
    //return ReturnValue;    
}

event @NULL AddRotationKey(float key_time, float Yaw, float Pitch, float Roll, float X, float Y, float Z, optional byte mode = 0)
{
    local int I, Index;
    local @NULL Rot, Pivot;

    Rot.Yaw = int(Yaw);
    Rot.Pitch = int(Pitch);
    Rot.Roll = int(Roll);
    Pivot.X = X;
    Pivot.Y = Y;
    Pivot.Z = Z;
    I = 0;
    J0x91:

    // End:0xCB [Loop If]
    if(I < RotationKeys.Length)
    {
        // End:0xC1
        if(RotationKeys[I].KeyTime == key_time)
        {
            return none;
        }
        I++;
        // [Loop Continue]
        goto J0x91;
    }
    Index = RotationKeys.Length;
    RotationKeys.Insert(Index, 1);
    RotationKeys[Index] = new (self) Class'TurokUIKeyRotation';
    // End:0x215
    if(RotationKeys[Index] != none)
    {
        // End:0x124
        if(LastKeyTime < key_time)
        {
            LastKeyTime = key_time;
        }
        RotationKeys[Index].KeyTime = key_time;
        RotationKeys[Index].Rotation = Rot;
        RotationKeys[Index].Pivot = Pivot;
        RotationKeys[Index].InterpMode = mode;
        // End:0x209
        if((bMoveTo && RotationKeys.Length > 1) && MoveToRotation == none)
        {
            MoveToRotation = new (self) Class'TurokUIKeyRotation';
            // End:0x209
            if(MoveToRotation != none)
            {
                MoveToRotation.KeyTime = RotationKeys[0].KeyTime;
                MoveToRotation.InterpMode = RotationKeys[0].InterpMode;
            }
        }
        return RotationKeys[Index];
    }
    return none;
    //return ReturnValue;    
}

// Export UTurokUIScript::execTick(FFrame&, void* const)
native function Tick();

// Export UTurokUIScript::execStart(FFrame&, void* const)
native function Start(optional float start_time, optional @NULL move_to);

// Export UTurokUIScript::execStop(FFrame&, void* const)
native function Stop();

function Pause()
{
    bIsRunning = false;
    //return;    
}

function UnPause()
{
    bIsRunning = true;
    //return;    
}
