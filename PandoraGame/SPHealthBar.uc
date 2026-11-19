class SPHealthBar extends MaterialInstanceConstant
    native
    collapsecategories;

enum HorizBaseEnum
{
    HorizBaseLeft,                  // 0
    HorizBaseRight,                 // 1
    HorizBaseCenter,                // 2
    HorizBaseFree,                  // 3
    HorizBaseEnum_MAX               // 4
};

enum VertBaseEnum
{
    VertBaseTop,                    // 0
    VertBaseBottom,                 // 1
    VertBaseCenter,                 // 2
    VertBaseFree,                   // 3
    VertBaseEnum_MAX                // 4
};

var private float HPMax;
var private float HPCurr;
var private float HPDest;
var private float HPChangeRate;
var private bool visible;
var private bool drawTextOnly;
var private Material HPBarMaterial;
var private MaterialInstanceConstant HPBarMaterialInstance;
var private SPHealthBar.HorizBaseEnum horizBase;
var private SPHealthBar.VertBaseEnum vertBase;
var private float horizOffset;
var private float vertOffset;

function int GetHPCurrInt()
{
    return int(HPCurr);
    //return ReturnValue;    
}

function float GetHP()
{
    return HPDest;
    //return ReturnValue;    
}

function SetHP(float HP)
{
    HPDest = HP;
    // End:0x25
    if(HPDest > HPMax)
    {
        HPDest = HPMax;
    }
    // End:0x3D
    if(HPDest < float(0))
    {
        HPDest = 0.0000000;
    }
    //return;    
}

function bool GetVisible()
{
    return visible;
    //return ReturnValue;    
}

function float GetHPMax()
{
    return HPMax;
    //return ReturnValue;    
}

function SetHPMax(float HP, bool scaleHP)
{
    local float Scale;

    // End:0x3F
    if(scaleHP)
    {
        Scale = HP / HPMax;
        HPCurr *= Scale;
        HPDest *= Scale;
        HPChangeRate *= Scale;
    }
    HPMax = HP;
    //return;    
}

function Reset(bool setToMax)
{
    // End:0x22
    if(setToMax)
    {
        HPCurr = HPMax;
        HPDest = HPMax;        
    }
    else
    {
        HPCurr = 0.0000000;
        HPDest = 0.0000000;
    }
    //return;    
}

function SetVisible(bool IsVisible)
{
    visible = IsVisible;
    //return;    
}

static function SPHealthBar CreateSPHealthBar(float maxHP, Material Material, float changeRate, SPHealthBar.HorizBaseEnum theHorizBase, float theHorizOffset, SPHealthBar.VertBaseEnum theVertBase, float theVertOffset, optional bool onlyDrawText)
{
    local SPHealthBar theSPHealthBar;

    theSPHealthBar = new (none) Class'SPHealthBar';
    theSPHealthBar.HPMax = maxHP;
    theSPHealthBar.HPCurr = maxHP;
    theSPHealthBar.HPDest = maxHP;
    theSPHealthBar.HPChangeRate = changeRate;
    theSPHealthBar.HPBarMaterial = Material;
    theSPHealthBar.horizBase = theHorizBase;
    theSPHealthBar.horizOffset = theHorizOffset;
    theSPHealthBar.vertBase = theVertBase;
    theSPHealthBar.vertOffset = theVertOffset;
    theSPHealthBar.drawTextOnly = onlyDrawText;
    return theSPHealthBar;
    //return ReturnValue;    
}

function Tick(float DeltaTime)
{
    AdjustHP(DeltaTime);
    //return;    
}

private final function AdjustHP(float DeltaTime)
{
    local float HPDelta;

    // End:0x14
    if(HPCurr == HPDest)
    {
        return;        
    }
    else
    {
        HPDelta = HPChangeRate * DeltaTime;
        // End:0x5E
        if(HPCurr < HPDest)
        {
            HPCurr += HPDelta;
            // End:0x5B
            if(HPCurr > HPDest)
            {
                HPCurr = HPDest;
            }            
        }
        else
        {
            HPCurr -= HPDelta;
            // End:0x84
            if(HPCurr < HPDest)
            {
                HPCurr = HPDest;
            }
        }
    }
    //return;    
}

function Draw(HUD H)
{
    local float DrawX, DrawY;

    // End:0x1A
    if(!visible || HPBarMaterial == none)
    {
        return;
    }
    // End:0x44
    if(int(horizBase) == int(0))
    {
        DrawX = float(H.OverscanX);        
    }
    else
    {
        // End:0x9B
        if(int(horizBase) == int(1))
        {
            DrawX = float(H.Canvas.SizeX - H.OverscanX) - HPBarMaterial.GetSurfaceWidth();            
        }
        else
        {
            // End:0xB9
            if(int(horizBase) == int(3))
            {
                DrawX = horizOffset;                
            }
            else
            {
                DrawX = ((float(H.Canvas.SizeX) - HPBarMaterial.GetSurfaceWidth()) / float(2)) + horizOffset;
            }
        }
    }
    // End:0x123
    if(int(vertBase) == int(0))
    {
        DrawY = float(H.OverscanY);        
    }
    else
    {
        // End:0x17A
        if(int(vertBase) == int(1))
        {
            DrawY = float(H.Canvas.SizeY - H.OverscanY) - HPBarMaterial.GetSurfaceHeight();            
        }
        else
        {
            // End:0x198
            if(int(vertBase) == int(3))
            {
                DrawY = vertOffset;                
            }
            else
            {
                DrawY = ((float(H.Canvas.SizeY) - HPBarMaterial.GetSurfaceHeight()) / float(2)) + vertOffset;
            }
        }
    }
    H.SetPos(DrawX, DrawY);
    // End:0x201
    if(drawTextOnly)
    {
        return;
    }
    return;
    //return;    
}

defaultproperties
{
    HPMax=100.0000000
    HPCurr=100.0000000
    HPDest=100.0000000
    HPChangeRate=150.0000000
    visible=true
    horizOffset=20.0000000
    vertOffset=20.0000000
}