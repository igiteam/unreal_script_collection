class KeyBindings extends Object
    transient
    native
    config(Input);

struct native CustomizableCommand
{
    var config name Command;
    var config string Exec;
    var config name DefaultKey;
    var config name DefaultAlternateKey;
    var native transient name Key;
    var native transient name AlternateKey;

    structdefaultproperties
    {
        Command="None"
        Exec=""
        DefaultKey="None"
        DefaultAlternateKey="None"
    }
};

var config array TurokCommands;
var globalconfig array DefaultBindings;
var globalconfig array UnbindableKeys;

// Export UKeyBindings::execResetToDefault(FFrame&, void* const)
native function bool ResetToDefault();

// Export UKeyBindings::execGetKey(FFrame&, void* const)
native function name GetKey(name Command, bool Alternate);

// Export UKeyBindings::execSetKey(FFrame&, void* const)
native function bool SetKey(name Command, name Key, bool Alternate);

// Export UKeyBindings::execApplyBindings(FFrame&, void* const)
native function ApplyBindings();

// Export UKeyBindings::execCanBindKey(FFrame&, void* const)
native function bool CanBindKey(name Key);
