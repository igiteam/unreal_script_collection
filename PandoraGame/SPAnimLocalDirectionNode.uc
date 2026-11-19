class SPAnimLocalDirectionNode extends SPAnimSwitchNode
    native;

struct native SPLocalDirectionAngularRange
{
    /** Enums */
    var() float MinAngle;
    /** Enums */
    var() float MaxAngle;

    structdefaultproperties
    {
        MinAngle=0.0000000
        MaxAngle=0.0000000
    }
};

/** Variable Declaration */
var() array<SPLocalDirectionAngularRange> AngularRanges;
var transient float EditorAngleToUse;
