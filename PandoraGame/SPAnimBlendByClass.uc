class SPAnimBlendByClass extends SPAnimBaseNode
    native;

struct native ClassInfo
{
    /** Variable Declaration */
    var() class<SPPawn> Class;

    structdefaultproperties
    {
        Class=none
    }
};

/** Class to switch off of. Functions CPP Text                Default Properties */
var() editfixedsize array<ClassInfo> ClassArray;
