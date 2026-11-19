class SPAnimConditionalSwitchNode extends SPAnimSwitchNode
    native;

struct native SPAnimEditorPreviewValues
{
    /** Variable Declaration */
    var() Rotator Rotation;
    /** Variable Declaration */
    var() Rotator rotationSpeed;
    /** Variable Declaration */
    var() float Speed;

    structdefaultproperties
    {
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        rotationSpeed=(Pitch=0,Yaw=0,Roll=0)
        Speed=0.0000000
    }
};

var() editfixedsize export editinline array<export editinline SPConditionEvaluate> Condition;
var() SPAnimEditorPreviewValues EditorPreview;
var() bool bInAnimTreeEditor;
