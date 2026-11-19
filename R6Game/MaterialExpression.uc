class MaterialExpression extends Object within Material
    abstract
    native;

enum EActiveComponent
{
    NC_NoConstant,                  // 0
    NC_Constant,                    // 1
    NC_Constant2,                   // 2
    NC_Constant3,                   // 3
    NC_Constant4,                   // 4
    NC_MAX                          // 5
};

struct ExpressionInput
{
    var MaterialExpression Expression;
    var() MaterialExpression.EActiveComponent activeComponent;
    var() float ConstantR;
    var() float ConstantG;
    var() float ConstantB;
    var() float ConstantA;
    var int Mask;
    var int MaskR;
    var int MaskG;
    var int MaskB;
    var int MaskA;

    structdefaultproperties
    {
        Expression=none
        activeComponent=0
        ConstantR=0.0000000
        ConstantG=0.0000000
        ConstantB=0.0000000
        ConstantA=0.0000000
        Mask=0
        MaskR=0
        MaskG=0
        MaskB=0
        MaskA=0
    }
};

var int EditorX;
var int EditorY;
var transient bool Compiling;
var transient array<string> Errors;
var() string Desc;
