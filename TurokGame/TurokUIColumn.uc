class TurokUIColumn extends TurokUIList
    native
    hidecategories(Object,UIRoot,Object);

const UICBGI_NUM_BG_IMAGES = 9;

enum eUIColumnBGImage
{
    UICBGI_TOP_LEFT,                // 0
    UICBGI_TOP_MIDDLE,              // 1
    UICBGI_TOP_RIGHT,               // 2
    UICBGI_MIDDLE_LEFT,             // 3
    UICBGI_MIDDLE_MIDDLE,           // 4
    UICBGI_MIDDLE_RIGHT,            // 5
    UICBGI_BOTTOM_LEFT,             // 6
    UICBGI_BOTTOM_MIDDLE,           // 7
    UICBGI_BOTTOM_RIGHT,            // 8
    UICBGI_MAX                      // 9
};

var @NULL Heading;
var() bool bHasHeading;
var() bool bSelectable;
var() private bool bHasBGImage;
var private @NULL BGImages[9];
var() private float BGWidth;
var() private float BGHeight;
var() private float DataOffsetX;
var() private float DataOffsetY;
var(Anims) private @NULL HeadHighlightColor;
var(Anims) private @NULL HeadUnHighlightColor;

// Export UTurokUIColumn::execTick(FFrame&, void* const)
native function Tick();

// Export UTurokUIColumn::execGetItemID(FFrame&, void* const)
native function int GetItemID(int Index);

// Export UTurokUIColumn::execPositionBGImages(FFrame&, void* const)
native function PositionBGImages();

// Export UTurokUIColumn::execEditor_SetBGWidth(FFrame&, void* const)
native function Editor_SetBGWidth(float Width);

// Export UTurokUIColumn::execEditor_SetBGHeight(FFrame&, void* const)
native function Editor_SetBGHeight(float Height);

// Export UTurokUIColumn::execEditor_SetDataOffsetX(FFrame&, void* const)
native function Editor_SetDataOffsetX(float X);

// Export UTurokUIColumn::execEditor_SetDataOffsetY(FFrame&, void* const)
native function Editor_SetDataOffsetY(float Y);

function Editor_SetHasHeading(bool has_heading)
{
    bHasHeading = has_heading;
    Editor_UpdateHasHeading();
    //return;    
}

function Editor_SetHasBGImage(bool has_bg)
{
    bHasBGImage = has_bg;
    Editor_UpdateHasBGImages();
    //return;    
}

event StartFadeInScripts()
{
    //return;    
}

function StartFadeOut()
{
    //return;    
}

event PostSetupInitialize_Column(optional int Index = 0)
{
    PostSetupInitialize(Index);
    //return;    
}

function PostSetupInitialize(optional int Index = 0)
{
    local @NULL script;

    super.PostSetupInitialize(Index);
    // End:0x129
    if(bHasHeading)
    {
        Class'TurokUI'.static.InitScriptCtrl(Heading);
        // End:0x129
        if(Heading.ScriptCtrl != none)
        {
            script = Class'TurokUI'.static.AddScript(Heading, "highlight", true);
            // End:0xB6
            if(script != none)
            {
                script.AddColorKey(0.0000000, HeadUnHighlightColor);
                script.AddColorKey(fAnimTime, HeadHighlightColor);
            }
            script = Class'TurokUI'.static.AddScript(Heading, "unhighlight", true);
            // End:0x129
            if(script != none)
            {
                script.AddColorKey(0.0000000, HeadHighlightColor);
                script.AddColorKey(fAnimTime, HeadUnHighlightColor);
            }
        }
    }
    //return;    
}

function Editor_RemoveChildren()
{
    super.Editor_RemoveChildren();
    bHasBGImage = false;
    Editor_UpdateHasHeading();
    bHasHeading = false;
    Editor_UpdateHasHeading();
    //return;    
}

event HighlightColumn()
{
    Class'TurokUI'.static.PlayScript(Heading, "highlight");
    //return;    
}

event UnHighlightColumn()
{
    Class'TurokUI'.static.PlayScript(Heading, "unhighlight");
    //return;    
}

event Deinitialize()
{
    super.Deinitialize();
    // End:0x37
    if((Heading != none) && Heading.ScriptCtrl != none)
    {
        Heading.ScriptCtrl = none;
    }
    //return;    
}

event Editor_UpdateHasHeading()
{
    local @NULL Item;

    // End:0x106
    if(bHasHeading)
    {
        Item = Class'TurokUI'.static.CreateWidgetInScene(Class'Engine.UILabel', name(string(WidgetTag) $ "_Heading"), GetScene(), self);
        // End:0x103
        if(Item != none)
        {
            Item.SetDataStoreBinding(string(WidgetTag) $ "_Heading");
            Item.Position.ScaleType[0] = 3;
            Item.Position.ScaleType[1] = 3;
            Item.Position.ScaleType[2] = 3;
            Item.Position.ScaleType[3] = 3;
            Heading = Item;
            Heading.mbOverrideFontDefaults = true;
        }        
    }
    else
    {
        RemoveChild(Heading);
        Heading = none;
    }
    //return;    
}

event Editor_UpdateHasBGImages()
{
    local int I;
    local @NULL Item;

    // End:0x120
    if(bHasBGImage)
    {
        I = 0;
        J0x10:

        // End:0x113 [Loop If]
        if(I <= 8)
        {
            Item = Class'TurokUI'.static.CreateWidgetInScene(Class'Engine.UIImage', name((string(WidgetTag) $ "_BGImage_") $ string(I)), GetScene(), self);
            // End:0x109
            if(Item != none)
            {
                Item.Position.ScaleType[0] = 3;
                Item.Position.ScaleType[1] = 3;
                Item.Position.ScaleType[2] = 3;
                Item.Position.ScaleType[3] = 3;
                BGImages[I] = Item;
                BGImages[I].bUseOverrides = true;
            }
            I++;
            // [Loop Continue]
            goto J0x10;
        }
        PositionBGImages();        
    }
    else
    {
        I = 0;
        J0x127:

        // End:0x15B [Loop If]
        if(I <= 8)
        {
            RemoveChild(BGImages[I]);
            BGImages[I] = none;
            I++;
            // [Loop Continue]
            goto J0x127;
        }
    }
    //return;    
}

defaultproperties
{
    bSelectable=true
    BGWidth=200.0000000
    BGHeight=400.0000000
    Position=(Value[3]=300.0000000)
    // Reference: UIComp_Event'Default__TurokUIColumn.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}