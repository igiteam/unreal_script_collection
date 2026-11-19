class Input extends Interaction
    transient
    native
    config(Input);

struct KeyBind
{
    structcpptext
    {

	FKeyBind()
	: Name()
	, Control(0)
	, Shift(0)
//###+ lpseguin
    , Axis(0)
//###-
	, Alt(0)
	{}

    }

    var config name Name;
    var config string Command;
    var config bool Control;
    var config bool Shift;
    var config bool Axis;
    var config bool Alt;

    structdefaultproperties
    {
        Name="None"
        Command=""
        Control=false
        Shift=false
        Axis=false
        Alt=false
    }
};

var config array<config KeyBind> Bindings;
var const array<name> PressedKeys;
var const Object.EInputEvent CurrentEvent;
var const float CurrentDelta;
var const float CurrentDeltaTime;
var native const map{VOID,VOID} NameToPtr;
var native const array<Pointer> AxisArray;
var LocalPlayer m_LocalPlayerOwner;
var float m_LastInputCommandTime;

// Export UInput::execInitR6Bindings(FFrame&, void* const)
native final function InitR6Bindings();

// Export UInput::execCheckIsAxis(FFrame&, void* const)
native final function bool CheckIsAxis(string Command);

exec function SetBind(name BindName, string Command)
{
    local KeyBind NewBind;
    local int BindIndex;

    BindIndex = 0;
    J0x07:

    // End:0x73 [Loop If]
    if(BindIndex < Bindings.Length)
    {
        // End:0x69
        if(Bindings[BindIndex].Name == BindName)
        {
            Bindings[BindIndex].Command = Command;
            Bindings[BindIndex].Axis = CheckIsAxis(Command);
            SaveConfig();
            return;
        }
        BindIndex++;
        // [Loop Continue]
        goto J0x07;
    }
    NewBind.Name = BindName;
    NewBind.Command = Command;
    NewBind.Axis = CheckIsAxis(Command);
    Bindings[Bindings.Length] = NewBind;
    SaveConfig();
    return;
}
