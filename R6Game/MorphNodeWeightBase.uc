class MorphNodeWeightBase extends MorphNodeBase
    abstract
    native
    hidecategories(Object,Object);

struct MorphNodeConn
{
    var array<MorphNodeBase> ChildNodes;
    var name ConnName;
    var int DrawY;

    structdefaultproperties
    {
        ChildNodes=none
        ConnName="None"
        DrawY=0
    }
};

var array<MorphNodeConn> NodeConns;
