class SkyBTNode_Blend extends SkyBTNode
    abstract
    native;

struct native BTBlendChild
{
    var() name Name;
    var() export editinline SkyBTNode BTNode;
    var editoronly int DrawY;

    structdefaultproperties
    {
        Name="None"
        BTNode=none
        DrawY=0
    }
};

var export editinline array<export editinline BTBlendChild> Children;
var editoronly bool bFixNumChildren;
var editoronly bool bRenameChildrenOnRemove;
var int LastActivatedChildIndex;
