class TurokUIMenuItem extends UILabel
    native
    hidecategories(Object,UIRoot,Object);

var @NULL SubMenu;
var @NULL FadeParent;
var() bool bHasSubMenu;
var bool bGreyed;
var bool bDisabled;
var bool bAutoOpenSub;
var bool bHighlightComplete;
var bool bHighlighted;
var bool bPosSubMenuOnComplete;
var() bool bGrowOnOpenSub;
var() bool bShowValueOnUnHighlight;
var bool bFEMainmenu;
var bool bScroll;
var @NULL ValueLabel;
var @NULL InitPos;
var @NULL HighlightPos;
var @NULL UnHighlightPos;
var @NULL InitialSize;
var float InitScale;
var(Anims) float fHighlightScale;
var(Anims) float fUnHighlightScale;
var float fAnimTime;
var() @NULL Offset;
var() @NULL GreyedColor;
var @NULL NormalColor;
var @NULL HighColor;
//var delegate<@NULL> __Act__Delegate;
//var delegate<@NULL> __OnHighlight__Delegate;
//var delegate<@NULL> __OnUnhighlight__Delegate;

delegate Act()
{
    //return;    
}

delegate OnHighlight()
{
    //return;    
}

delegate OnUnhighlight()
{
    //return;    
}

// Export UTurokUIMenuItem::execSelectable(FFrame&, void* const)
native function bool Selectable();

// Export UTurokUIMenuItem::execTick(FFrame&, void* const)
native function Tick();

// Export UTurokUIMenuItem::execPositionValueLabel(FFrame&, void* const)
native function PositionValueLabel(bool half_offset);

// Export UTurokUIMenuItem::execSetHighlightedForRestoreSelection(FFrame&, void* const)
native function SetHighlightedForRestoreSelection();

function RemoveChildren()
{
    // End:0x1E
    if(SubMenu != none)
    {
        SubMenu.RemoveAllItems();
    }
    //return;    
}

event OpenSubMenu(optional bool counter_parent_highlight = false)
{
    local float x_pos, y_pos;
    local @NULL script, Key;

    // End:0x6D
    if(SubMenu != none)
    {
        SubMenu.AdjustItemPositions();
        SubMenu.SetMenuVisibility(true);
        SubMenu.StartFadeIn();
        // End:0x6D
        if(!bAutoOpenSub && bShowValueOnUnHighlight)
        {
            ValueLabel.bHidden = true;
        }
    }
    // End:0x2C9
    if(counter_parent_highlight && SubMenu.bSlide)
    {
        script = TurokUIScriptController(SubMenu.ScriptCtrl).GetScript("highlight");
        Key = script.GetPositionKey(0.0000000);
        // End:0x17A
        if(Key != none)
        {
            SubMenu.CalcMenuSlidePosition(x_pos, y_pos);
            Key.Position.X = x_pos - (UnHighlightPos.X - HighlightPos.X);
            Key.Position.Y = y_pos - (UnHighlightPos.Y - HighlightPos.Y);
        }
        Key = script.GetPositionKey(fAnimTime);
        // End:0x2A3
        if(Key != none)
        {
            SubMenu.CalcMenuSlidePosition(x_pos, y_pos);
            // End:0x267
            if(bGrowOnOpenSub)
            {
                Key.Position.X = x_pos + (InitPos.X - (InitPos.X * 0.7000000));
                Key.Position.Y = y_pos + ((((InitialSize.Y * fHighlightScale) * 1.5000000) - (InitialSize.Y * fHighlightScale)) / 2.0000000);                
            }
            else
            {
                Key.Position.X = x_pos;
                Key.Position.Y = y_pos;
            }
        }
        Class'TurokUI'.static.PlayScript(SubMenu, "highlight");        
    }
    else
    {
        x_pos = ((UnHighlightPos.X - HighlightPos.X) + InitialSize.X) + SubMenu.OffsetFromParent.X;
        y_pos = (UnHighlightPos.Y - HighlightPos.Y) + SubMenu.OffsetFromParent.Y;
        Class'TurokUI'.static.SetPosition(SubMenu, x_pos, y_pos);
    }
    //return;    
}

event CloseSubMenu(optional bool counter_parent_unhighlight = false)
{
    local float x_pos, y_pos;
    local @NULL script, Key;

    // End:0x23
    if(SubMenu != none)
    {
        SubMenu.StartFadeOut();
    }
    // End:0x1A2
    if(counter_parent_unhighlight && SubMenu.bSlide)
    {
        script = TurokUIScriptController(SubMenu.ScriptCtrl).GetScript("unhighlight");
        Key = script.GetPositionKey(fAnimTime);
        // End:0x17A
        if(Key != none)
        {
            SubMenu.CalcMenuSlidePosition(x_pos, y_pos);
            // End:0xFA
            if(bGrowOnOpenSub)
            {
                Key.Position.X = x_pos;
                Key.Position.Y = y_pos;                
            }
            else
            {
                Key.Position.X = x_pos - (UnHighlightPos.X - HighlightPos.X);
                Key.Position.Y = y_pos - (UnHighlightPos.Y - HighlightPos.Y);
            }
        }
        Class'TurokUI'.static.PlayScript(SubMenu, "unhighlight");        
    }
    else
    {
        UnHighlightComplete();
    }
    //return;    
}

event Highlight(optional bool position_sub_menu = false)
{
    bHighlightComplete = false;
    bPosSubMenuOnComplete = position_sub_menu;
    // End:0x69
    if(ScriptCtrl != none)
    {
        Class'TurokUI'.static.PlayScript(self, "highlight");
        // End:0x69
        if(bAutoOpenSub && bShowValueOnUnHighlight)
        {
            ValueLabel.bHidden = true;
        }
    }
    //return;    
}

event HighlightComplete()
{
    local float x_pos, y_pos;

    bHighlightComplete = true;
    // End:0x76
    if(((SubMenu != none) && bPosSubMenuOnComplete) && SubMenu.bSlide)
    {
        bPosSubMenuOnComplete = false;
        SubMenu.CalcMenuSlidePosition(x_pos, y_pos);
        Class'TurokUI'.static.SetPosition(SubMenu, x_pos, y_pos);
    }
    OnHighlight();
    SetCrisp();
    bHighlighted = true;
    //return;    
}

// Export UTurokUIMenuItem::execSetCrisp(FFrame&, void* const)
native function SetCrisp();

// Export UTurokUIMenuItem::execSetBlur(FFrame&, void* const)
native function SetBlur();

// Export UTurokUIMenuItem::execSetFontcolor(FFrame&, void* const)
native function SetFontcolor();

// Export UTurokUIMenuItem::execUnHighlightComplete(FFrame&, void* const)
native function UnHighlightComplete();

event UnHighlight()
{
    local @NULL tempScript, colourKey;

    // End:0xC8
    if(ScriptCtrl != none)
    {
        tempScript = TurokUIScriptController(ScriptCtrl).GetScript("unhighlight");
        // End:0xA7
        if(tempScript != none)
        {
            colourKey = tempScript.GetColorKey(fAnimTime);
            // End:0x88
            if(bGreyed && colourKey != none)
            {
                colourKey.TheColor = GreyedColor;                
            }
            else
            {
                // End:0xA7
                if(colourKey != none)
                {
                    colourKey.TheColor = NormalColor;
                }
            }
        }
        Class'TurokUI'.static.PlayScript(self, "unhighlight");
    }
    OnUnhighlight();
    //return;    
}

function SetGreyed(bool greyed)
{
    bGreyed = greyed;
    // End:0x24
    if(bGreyed)
    {
        mFontColor = GreyedColor;        
    }
    else
    {
        mFontColor = NormalColor;
    }
    //return;    
}

event Editor_UpdateHasSubMenu()
{
    local float label_width;

    // End:0xAF
    if(bHasSubMenu)
    {
        SubMenu = Class'TurokUI'.static.CreateWidgetInScene(Class'TurokUIMenu', name(string(WidgetTag) $ "_SubMenu"), GetScene(), self);
        // End:0xAC
        if(SubMenu != none)
        {
            SubMenu.bHorizontal = true;
            label_width = Class'TurokUI'.static.GetLabelWidth(self);
            Class'TurokUI'.static.SetPosition(SubMenu, label_width, 0.0000000);
            SubMenu.AdjustItemPositions();
        }        
    }
    else
    {
        RemoveChildren();
        RemoveChild(SubMenu);
        SubMenu = none;
    }
    //return;    
}

function SetupFadeScript(float anim_time, float fade_in_anim_offset, bool In)
{
    local @NULL script, fade_start, fade_end;

    // End:0x22
    if(bGreyed)
    {
        fade_start = GreyedColor;
        fade_end = GreyedColor;        
    }
    else
    {
        fade_start = NormalColor;
        fade_end = NormalColor;
    }
    // End:0x56
    if(In)
    {
        fade_start.A = 0;        
    }
    else
    {
        fade_end.A = 0;
    }
    // End:0x15F
    if(ScriptCtrl != none)
    {
        // End:0xA2
        if(In)
        {
            script = Class'TurokUI'.static.AddScript(self, "FadeIn");            
        }
        else
        {
            script = Class'TurokUI'.static.AddScript(self, "FadeOut", true);
        }
        // End:0x15F
        if(script != none)
        {
            script.AddColorKey(fade_in_anim_offset, fade_start, 0);
            // End:0x139
            if(In)
            {
                script.AddColorKey(anim_time + fade_in_anim_offset, fade_end, 0).SetDelegate(SetFontcolor);                
            }
            else
            {
                script.AddColorKey(anim_time + fade_in_anim_offset, fade_end, 0);
            }
        }
    }
    //return;    
}

event PostSetupInitialize(float anim_time, float high_scale, float unhigh_scale, @NULL high_color, @NULL unhigh_color, float fade_anim_start_time)
{
    local @NULL script;
    local float x_pos_start, y_pos_start, x_pos_end, y_pos_end, grow_pos_x, grow_pos_y;

    NormalColor = unhigh_color;
    HighColor = high_color;
    mFontColor = NormalColor;
    fAnimTime = anim_time;
    Class'TurokUI'.static.GetPosition(self, InitPos.X, InitPos.Y);
    InitScale = fUnHighlightScale;
    SetScale(fUnHighlightScale);
    Class'TurokUI'.static.GetLabelSize(self, InitialSize.X, InitialSize.Y);
    UnHighlightPos.X = InitPos.X;
    UnHighlightPos.Y = InitPos.Y;
    Class'TurokUI'.static.SetPosition(self, UnHighlightPos.X, UnHighlightPos.Y);
    HighlightPos.X = InitPos.X - (((InitialSize.X * (fHighlightScale / fUnHighlightScale)) - InitialSize.X) / 2.0000000);
    HighlightPos.Y = InitPos.Y - (((InitialSize.Y * (fHighlightScale / fUnHighlightScale)) - InitialSize.Y) / 2.0000000);
    Class'TurokUI'.static.InitScriptCtrl(self);
    // End:0xA29
    if(ScriptCtrl != none)
    {
        script = Class'TurokUI'.static.AddScript(self, "highlight", true);
        // End:0x339
        if(script != none)
        {
            script.SetChainScript("highlight_loop");
            script.AddSizeKey(0.0000000, fUnHighlightScale);
            script.AddSizeKey(fAnimTime, fHighlightScale).SetDelegate(HighlightComplete);
            script.AddColorKey(0.0000000, NormalColor);
            script.AddColorKey(fAnimTime, high_color);
            script.AddPositionKey(0.0000000, UnHighlightPos.X, UnHighlightPos.Y);
            script.AddPositionKey(anim_time, HighlightPos.X, HighlightPos.Y);
        }
        script = Class'TurokUI'.static.AddScript(self, "highlight2", true);
        // End:0x562
        if(script != none)
        {
            script.AddSizeKey(0.0000000, fUnHighlightScale);
            // End:0x3D3
            if(bGrowOnOpenSub)
            {
                script.AddSizeKey(fAnimTime, fHighlightScale * 1.1500000).SetDelegate(HighlightComplete);                
            }
            else
            {
                script.AddSizeKey(fAnimTime, fHighlightScale).SetDelegate(HighlightComplete);
            }
            script.AddColorKey(0.0000000, unhigh_color);
            script.AddColorKey(fAnimTime, high_color);
            script.AddPositionKey(0.0000000, UnHighlightPos.X, UnHighlightPos.Y);
            // End:0x52A
            if(bGrowOnOpenSub)
            {
                grow_pos_x = InitPos.X * 0.7000000;
                grow_pos_y = InitPos.Y - ((((InitialSize.Y * (fHighlightScale / fUnHighlightScale)) * 1.1500000) - (InitialSize.Y * (fHighlightScale / fUnHighlightScale))) / 2.0000000);
                script.AddPositionKey(anim_time, grow_pos_x, grow_pos_y);                
            }
            else
            {
                script.AddPositionKey(anim_time, HighlightPos.X, HighlightPos.Y);
            }
        }
        script = Class'TurokUI'.static.AddScript(self, "unhighlight", true);
        // End:0x6AD
        if(script != none)
        {
            script.AddSizeKey(0.0000000, fHighlightScale);
            script.AddSizeKey(fAnimTime, fUnHighlightScale).SetDelegate(SetBlur);
            script.AddColorKey(0.0000000, high_color);
            script.AddColorKey(fAnimTime, unhigh_color);
            script.AddPositionKey(0.0000000, HighlightPos.X, HighlightPos.Y);
            script.AddPositionKey(fAnimTime, UnHighlightPos.X, UnHighlightPos.Y).SetDelegate(UnHighlightComplete);
        }
        script = Class'TurokUI'.static.AddScript(self, "shrinkwhennotselected");
        // End:0x82F
        if(script != none)
        {
            script.AddSizeKey(0.0000000, fUnHighlightScale);
            script.AddSizeKey(fAnimTime, fUnHighlightScale * 0.8000000);
            script.AddColorKey(0.0000000, unhigh_color);
            script.AddColorKey(fAnimTime, GreyedColor);
            grow_pos_x = UnHighlightPos.X * 0.8000000;
            grow_pos_y = UnHighlightPos.Y + (InitialSize.Y - ((InitialSize.Y * (fHighlightScale / fUnHighlightScale)) * 0.8000000));
            script.AddPositionKey(0.0000000, UnHighlightPos.X, UnHighlightPos.Y);
            script.AddPositionKey(fAnimTime, grow_pos_x, grow_pos_y);
        }
        script = Class'TurokUI'.static.AddScript(self, "unshrinkwhennotselected");
        // End:0x9DF
        if(script != none)
        {
            script.AddSizeKey(0.0000000, fUnHighlightScale * 0.8000000);
            script.AddSizeKey(fAnimTime, fUnHighlightScale);
            script.AddColorKey(0.0000000, GreyedColor);
            // End:0x8FD
            if(!bGreyed)
            {
                script.AddColorKey(fAnimTime, unhigh_color);                
            }
            else
            {
                script.AddColorKey(fAnimTime, GreyedColor);
            }
            grow_pos_x = UnHighlightPos.X * 0.8000000;
            grow_pos_y = UnHighlightPos.Y + (InitialSize.Y - ((InitialSize.Y * (fHighlightScale / fUnHighlightScale)) * 0.8000000));
            script.AddPositionKey(0.0000000, grow_pos_x, grow_pos_y);
            script.AddPositionKey(fAnimTime, UnHighlightPos.X, UnHighlightPos.Y);
        }
        Class'TurokUI'.static.AddHighlightLoop(self);
        // End:0xA29
        if(!bDisabled)
        {
            SetupFadeScript(fAnimTime, fade_anim_start_time, true);
            SetupFadeScript(fAnimTime, fade_anim_start_time, false);
        }
    }
    // End:0xCA2
    if(SubMenu != none)
    {
        Class'TurokUI'.static.InitScriptCtrl(SubMenu);
        // End:0xC35
        if(SubMenu.ScriptCtrl != none)
        {
            SubMenu.CalcMenuSlidePosition(x_pos_end, y_pos_end);
            x_pos_end += SubMenu.OffsetFromParent.X;
            y_pos_end += SubMenu.OffsetFromParent.Y;
            x_pos_start = x_pos_end - (UnHighlightPos.X - HighlightPos.X);
            y_pos_start = y_pos_end - (UnHighlightPos.Y - HighlightPos.Y);
            script = Class'TurokUI'.static.AddScript(SubMenu, "highlight", true);
            // End:0xBA2
            if((script != none) && SubMenu.bSlide)
            {
                script.AddPositionKey(0.0000000, x_pos_start, y_pos_start);
                script.AddPositionKey(anim_time, x_pos_end, y_pos_end);
            }
            script = Class'TurokUI'.static.AddScript(SubMenu, "unhighlight", true);
            // End:0xC35
            if((script != none) && SubMenu.bSlide)
            {
                script.AddPositionKey(0.0000000, x_pos_end, y_pos_end);
                script.AddPositionKey(anim_time, x_pos_start, y_pos_start);
            }
        }
        Class'TurokUI'.static.SetPosition(SubMenu, x_pos_end, y_pos_end);
        SubMenu.PostSetupInitialize();
        Class'TurokUI'.static.SetPosition(SubMenu, x_pos_start, y_pos_start);
        SubMenu.SetMenuVisibility(false);
    }
    //return;    
}

function Deinitialize()
{
    Class'TurokUI'.static.SetLabelScale(self, InitScale);
    Class'TurokUI'.static.SetSize(self, InitialSize.X, InitialSize.Y);
    Class'TurokUI'.static.SetPosition(self, InitPos.X, InitPos.Y);
    ScriptCtrl = none;
    // End:0xA3
    if(SubMenu != none)
    {
        SubMenu.Deinitialize();
    }
    //return;    
}

defaultproperties
{
    fHighlightScale=1.0000000
    fUnHighlightScale=1.0000000
    Offset=(X=10.0000000,Y=10.0000000)
    GreyedColor=(R=128,G=128,B=128,A=255)
    NormalColor=(R=255,G=255,B=255,A=255)
    HighColor=(R=255,G=255,B=255,A=255)
    // Reference: UIComp_DrawString'Default__TurokUIMenuItem.LabelStringRenderer'
    begin object name=LabelStringRenderer
    end object
    StringRenderComponent=LabelStringRenderer
    mbOverrideFontDefaults=true
    Position=(Value[2]=200.0000000,Value[3]=25.0000000)
    // Reference: UIComp_Event'Default__TurokUIMenuItem.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}