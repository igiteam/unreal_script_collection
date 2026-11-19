class TurokUIMenu extends UIObject
    native
    hidecategories(Object,UIRoot,Object);

const MAX_MENU_ITEMS = 10;

var() int NumItems;
var int PrevNumItems;
var @NULL InitPos;
var() @NULL OffsetFromParent;
var bool bBlockInput;
var() bool bHorizontal;
var() bool bSlide;
var bool bIsOpen;
var() bool bAutoOpenSubs;
var() bool bScrollWrapped;
var() bool bFEMainmenu;
var(HighlightBar) bool bHasHighlightImage;
var @NULL UnHighlightOwner;
var(Anims) float fHighlightScale;
var(Anims) float fUnHighlightScale;
var(Anims) float fAnimTime;
var(Anims) float fFadeDelay;
var(Anims) float fSlideFactor;
var(HighlightBar) @NULL HighlightImageOffset;
var(HighlightBar) @NULL HighlightImageSize;
var(Anims) @NULL HighlightColor;
var(Anims) @NULL UnHighlightColor;
var @NULL SlideScript;
var @NULL HighlightImageSlideScript;
var @NULL CounterShrinkificationUnit;
var @NULL ShrinkificationScripts[10];
var @NULL PreShrinkPositions[10];
var float PreShrinkScales[10];
var @NULL PreShrinkColors[10];
var float SelectedShrinkMoveX;
var float SelectedShrinkMoveY;
var @NULL Items[10];
var int SelectedItemIndex;
var @NULL HighlightImage;
//var delegate<@NULL> __OnOpenSubMenu__Delegate;
//var delegate<@NULL> __OnCloseSubMenu__Delegate;
//var delegate<@NULL> __Act__Delegate;
//var delegate<@NULL> __OnHighlight__Delegate;
//var delegate<@NULL> __OnUnhighlight__Delegate;

// Export UTurokUIMenu::execTick(FFrame&, void* const)
native function Tick();

// Export UTurokUIMenu::execScroll(FFrame&, void* const)
native function Scroll(int Dir);

// Export UTurokUIMenu::execStartFadeIn(FFrame&, void* const)
native function StartFadeIn();

// Export UTurokUIMenu::execSetMenuVisibility(FFrame&, void* const)
native function SetMenuVisibility(bool Show);

// Export UTurokUIMenu::execCalcMenuSlidePosition(FFrame&, void* const)
native final function CalcMenuSlidePosition(out float out_x, out float out_y);

// Export UTurokUIMenu::execAdjustItemPositions(FFrame&, void* const)
native final function AdjustItemPositions();

// Export UTurokUIMenu::execMoveSelectedToFront(FFrame&, void* const)
native final function MoveSelectedToFront();

// Export UTurokUIMenu::execCalcMenuHeight(FFrame&, void* const)
native function float CalcMenuHeight();

// Export UTurokUIMenu::execCalcMenuWidth(FFrame&, void* const)
native function float CalcMenuWidth();

// Export UTurokUIMenu::execStartShrinkification(FFrame&, void* const)
native function StartShrinkification(bool shrink);

// Export UTurokUIMenu::execStartCounterShrinkification(FFrame&, void* const)
native function StartCounterShrinkification(bool shrink, float x_move, float y_move);

// Export UTurokUIMenu::execSelectIndex(FFrame&, void* const)
native function SelectIndex(int Index);

// Export UTurokUIMenu::execSetSlidePositionForCurrentSelection(FFrame&, void* const)
native function SetSlidePositionForCurrentSelection();

delegate OnOpenSubMenu()
{
    //return;    
}

delegate OnCloseSubMenu()
{
    //return;    
}

function @NULL GetSelectedItem()
{
    return Items[SelectedItemIndex];
    //return ReturnValue;    
}

event @NULL GetSubMenu(int item_index)
{
    // End:0x44
    if(((item_index >= 0) && item_index < NumItems) && Items[item_index] != none)
    {
        return Items[item_index].SubMenu;
    }
    return none;
    //return ReturnValue;    
}

delegate Act()
{
    //return;    
}

function bool SetItemDelegate(int item_index, delegate<@NULL> del_func)
{
    // End:0x4B
    if(((item_index >= 0) && item_index < NumItems) && Items[item_index] != none)
    {
        Items[item_index].__Act__Delegate = del_func;
        return true;
    }
    return false;
    //return ReturnValue;    
}

delegate OnHighlight()
{
    //return;    
}

function bool SetItemHighlightDelegate(int item_index, delegate<@NULL> del_func)
{
    // End:0x4B
    if(((item_index >= 0) && item_index < NumItems) && Items[item_index] != none)
    {
        Items[item_index].__OnHighlight__Delegate = del_func;
        return true;
    }
    return false;
    //return ReturnValue;    
}

delegate OnUnhighlight()
{
    //return;    
}

function bool SetItemUnhighlightDelegate(int item_index, delegate<@NULL> del_func)
{
    // End:0x4B
    if(((item_index >= 0) && item_index < NumItems) && Items[item_index] != none)
    {
        Items[item_index].__OnUnhighlight__Delegate = del_func;
        return true;
    }
    return false;
    //return ReturnValue;    
}

// Export UTurokUIMenu::execRefreshMenuSelection(FFrame&, void* const)
native function RefreshMenuSelection();

event bool DisableItem(int item_index, bool greyed)
{
    // End:0x98
    if(((item_index >= 0) && item_index < NumItems) && Items[item_index] != none)
    {
        // End:0x5F
        if(greyed)
        {
            Items[item_index].SetGreyed(true);
            RefreshMenuSelection();            
        }
        else
        {
            Items[item_index].bDisabled = true;
            Items[item_index].SetVisibility(false);
            AdjustItemPositions();
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

event bool EnableItem(int item_index)
{
    // End:0xA7
    if(((item_index >= 0) && item_index < NumItems) && Items[item_index] != none)
    {
        // End:0x6E
        if(Items[item_index].bGreyed)
        {
            Items[item_index].SetGreyed(false);
            RefreshMenuSelection();            
        }
        else
        {
            Items[item_index].bDisabled = false;
            Items[item_index].SetVisibility(true);
            AdjustItemPositions();
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function RemoveAllItems()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3E [Loop If]
    if(I < NumItems)
    {
        RemoveChild(Items[I]);
        Items[I] = none;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

event bool ProcessInput(int ControllerId, name Key, byte Event, optional float AmountDepressed = 1.0000000)
{
    local @NULL selected_sub_menu, parent_item;
    local int I;

    selected_sub_menu = GetSubMenu(SelectedItemIndex);
    // End:0x57
    if(((NumItems <= 0) || (selected_sub_menu != none) && selected_sub_menu.bBlockInput) || bBlockInput)
    {
        return false;
    }
    // End:0x77
    if(!Items[SelectedItemIndex].Selectable())
    {
        return false;
    }
    // End:0xC2
    if((selected_sub_menu != none) && selected_sub_menu.bIsOpen)
    {
        // End:0xC2
        if(selected_sub_menu.ProcessInput(ControllerId, Key, Event, AmountDepressed))
        {
            return true;
        }
    }
    // End:0x578
    if((int(Event) == int(0)) || int(Event) == int(2))
    {
        switch(Key)
        {
            // End:0xF7
            case 'Gamepad_LeftStick_Left':
            // End:0x103
            case 'XboxTypeS_DPad_Left':
            // End:0x197
            case 'Left':
                // End:0x150
                if(bHorizontal && NumItems > 1)
                {
                    Items[SelectedItemIndex].bScroll = true;
                    Scroll(-1);
                    return true;                    
                }
                else
                {
                    // End:0x194
                    if(((GetOwner() != none) && GetOwner().IsA('TurokUIMenuItem')) && !TurokUIMenuItem(GetOwner()).bAutoOpenSub)
                    {
                        return true;
                    }
                }
                // End:0x36C
                break;
            // End:0x1A3
            case 'Gamepad_LeftStick_Up':
            // End:0x1AF
            case 'XboxTypeS_DPad_Up':
            // End:0x22E
            case 'Up':
                // End:0x1E7
                if(!bHorizontal && NumItems > 1)
                {
                    Scroll(-1);
                    return true;                    
                }
                else
                {
                    // End:0x22B
                    if(((GetOwner() != none) && GetOwner().IsA('TurokUIMenuItem')) && !TurokUIMenuItem(GetOwner()).bAutoOpenSub)
                    {
                        return true;
                    }
                }
                // End:0x36C
                break;
            // End:0x23A
            case 'Gamepad_LeftStick_Right':
            // End:0x246
            case 'XboxTypeS_DPad_Right':
            // End:0x2D6
            case 'Right':
                // End:0x28F
                if(bHorizontal && NumItems > 1)
                {
                    Items[SelectedItemIndex].bScroll = true;
                    Scroll(1);
                    return true;                    
                }
                else
                {
                    // End:0x2D3
                    if(((GetOwner() != none) && GetOwner().IsA('TurokUIMenuItem')) && !TurokUIMenuItem(GetOwner()).bAutoOpenSub)
                    {
                        return true;
                    }
                }
                // End:0x36C
                break;
            // End:0x2E2
            case 'Gamepad_LeftStick_Down':
            // End:0x2EE
            case 'XboxTypeS_DPad_Down':
            // End:0x369
            case 'Down':
                // End:0x322
                if(!bHorizontal && NumItems > 1)
                {
                    Scroll(1);
                    return true;                    
                }
                else
                {
                    // End:0x366
                    if(((GetOwner() != none) && GetOwner().IsA('TurokUIMenuItem')) && !TurokUIMenuItem(GetOwner()).bAutoOpenSub)
                    {
                        return true;
                    }
                }
                // End:0x36C
                break;
            // End:0xFFFF
            default:
                break;
        }
        // End:0x575
        if(int(Event) == int(0))
        {
            switch(Key)
            {
                // End:0x38F
                case 'XboxTypeS_A':
                // End:0x3AC
                case 'Enter':
                    ActivateSelectedItem(selected_sub_menu);
                    return true;
                // End:0x40B
                case 'LeftMouseButton':
                    // End:0x408
                    if(((selected_sub_menu == none) || !selected_sub_menu.bIsOpen) && Items[SelectedItemIndex].IsMouseOver())
                    {
                        ActivateSelectedItem(selected_sub_menu);
                        return true;
                    }
                    // End:0x575
                    break;
                // End:0x417
                case 'XboxTypeS_B':
                // End:0x423
                case 'MouseXButton1':
                // End:0x42F
                case 'BackSpace':
                // End:0x56F
                case 'Escape':
                    parent_item = TurokUIMenuItem(GetOwner());
                    // End:0x54A
                    if(((parent_item != none) && parent_item.IsA('TurokUIMenuItem')) && !parent_item.bAutoOpenSub)
                    {
                        bBlockInput = true;
                        Class'TurokUI'.static.PlayScript(parent_item, "highlight");
                        // End:0x4F4
                        if(HighlightImage != none)
                        {
                            Class'TurokUI'.static.PlayScript(TurokUIMenu(parent_item.GetOwner()).HighlightImage, "FadeIn");
                        }
                        Class'TurokUI'.static.PlayScript(Items[SelectedItemIndex], "highlight");
                        parent_item.CloseSubMenu(true);
                        StartFadeOut();
                        OnCloseSubMenu();
                    }
                    Class'TurokUI'.static.GetFEAudio().PlayFESound(6);
                    return false;
                // End:0xFFFF
                default:
                    // End:0x575
                    break;
                    break;
            }
        }        
    }
    else
    {
        // End:0x818
        if(int(Event) == int(4))
        {
            // End:0x5C7
            if(((SelectedItemIndex >= 0) && SelectedItemIndex < NumItems) && Items[SelectedItemIndex].IsMouseOver())
            {
                return true;                
            }
            else
            {
                I = 0;
                J0x5CE:

                // End:0x818 [Loop If]
                if(I < NumItems)
                {
                    // End:0x80E
                    if(((I != SelectedItemIndex) && Items[I].Selectable()) && Items[I].IsMouseOver())
                    {
                        // End:0x666
                        if((bHorizontal && SelectedItemIndex >= 0) && SelectedItemIndex < NumItems)
                        {
                            Items[SelectedItemIndex].bScroll = true;
                        }
                        // End:0x7F6
                        if((selected_sub_menu != none) && selected_sub_menu.bIsOpen)
                        {
                            parent_item = TurokUIMenuItem(selected_sub_menu.GetOwner());
                            // End:0x7D3
                            if(((parent_item != none) && parent_item.IsA('TurokUIMenuItem')) && !parent_item.bAutoOpenSub)
                            {
                                selected_sub_menu.bBlockInput = true;
                                Class'TurokUI'.static.PlayScript(parent_item, "highlight");
                                // End:0x759
                                if(selected_sub_menu.HighlightImage != none)
                                {
                                    Class'TurokUI'.static.PlayScript(TurokUIMenu(parent_item.GetOwner()).HighlightImage, "FadeIn");
                                }
                                Class'TurokUI'.static.PlayScript(selected_sub_menu.Items[selected_sub_menu.SelectedItemIndex], "highlight");
                                parent_item.CloseSubMenu(true);
                                selected_sub_menu.StartFadeOut();
                                selected_sub_menu.OnCloseSubMenu();
                            }
                            Class'TurokUI'.static.GetFEAudio().PlayFESound(6);
                        }
                        Scroll(I - SelectedItemIndex);
                        return true;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x5CE;
                }
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function ActivateSelectedItem(@NULL SubMenu)
{
    // End:0xC2
    if(((SubMenu != none) && !bAutoOpenSubs) && Items[SelectedItemIndex].bHighlightComplete)
    {
        SubMenu.bBlockInput = true;
        Class'TurokUI'.static.PlayScript(Items[SelectedItemIndex], "highlight2");
        // End:0x99
        if(HighlightImage != none)
        {
            Class'TurokUI'.static.PlayScript(HighlightImage, "FadeOut");
        }
        Items[SelectedItemIndex].OpenSubMenu(true);
        OnOpenSubMenu();
    }
    Class'TurokUI'.static.GetFEAudio().PlayFESound(5);
    Items[SelectedItemIndex].Act();
    //return;    
}

function StartFadeOut()
{
    local int I;

    I = 0;
    J0x07:

    // End:0xC0 [Loop If]
    if(I < NumItems)
    {
        // End:0x57
        if(!Items[I].bDisabled)
        {
            Class'TurokUI'.static.PlayScript(Items[I], "FadeOut");
        }
        // End:0xB6
        if((Items[I].SubMenu != none) && Items[I].SubMenu.bIsOpen)
        {
            Items[I].SubMenu.StartFadeOut();
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0xEC
    if(HighlightImage != none)
    {
        Class'TurokUI'.static.PlayScript(HighlightImage, "FadeOut");
    }
    //return;    
}

function CloseMenu()
{
    Items[SelectedItemIndex].UnHighlight();
    //return;    
}

function FadeInComplete()
{
    local @NULL last_enabled_menu_item;
    local int I;

    bBlockInput = false;
    bIsOpen = true;
    Items[SelectedItemIndex].Highlight(true);
    // End:0x93
    if((Items[SelectedItemIndex].SubMenu != none) && bAutoOpenSubs)
    {
        Class'TurokUI'.static.PlayScript(Items[SelectedItemIndex], "highlight2");
        Items[SelectedItemIndex].OpenSubMenu(true);
    }
    I = 0;
    J0x9A:

    // End:0xDE [Loop If]
    if(I < NumItems)
    {
        // End:0xD4
        if(!Items[I].bDisabled)
        {
            last_enabled_menu_item = Items[I];
        }
        I++;
        // [Loop Continue]
        goto J0x9A;
    }
    // End:0xFC
    if(last_enabled_menu_item != none)
    {
        last_enabled_menu_item.SetFontcolor();
    }
    MoveSelectedToFront();
    //return;    
}

function FadeOutComplete()
{
    local @NULL owner_parent;

    bBlockInput = false;
    bIsOpen = false;
    SetMenuVisibility(false);
    // End:0xBD
    if(UnHighlightOwner != none)
    {
        UnHighlightOwner.UnHighlight();
        owner_parent = TurokUIMenu(UnHighlightOwner.GetOwner());
        // End:0xB6
        if(owner_parent != none)
        {
            // End:0xB6
            if(!Class'TurokUI'.static.IsScriptSet(owner_parent.GetSelectedItem(), "highlight"))
            {
                owner_parent.GetSelectedItem().Highlight();
            }
        }
        UnHighlightOwner = none;
    }
    //return;    
}

event Editor_UpdateNumUIMenuItems()
{
    local int I;
    local @NULL Item;

    NumItems = Clamp(NumItems, 0, 10);
    // End:0x21
    if(NumItems == PrevNumItems)
    {
        return;
    }
    // End:0x172
    if(NumItems > PrevNumItems)
    {
        I = PrevNumItems;
        J0x3B:

        // End:0x16F [Loop If]
        if(I < NumItems)
        {
            Item = Class'TurokUI'.static.CreateWidgetInScene(Class'TurokUIMenuItem', name((string(WidgetTag) $ "_Item") $ string(I)), GetScene(), self);
            // End:0x165
            if(Item != none)
            {
                Item.SetDataStoreBinding("MenuItem" $ string(I));
                Item.bAutoOpenSub = bAutoOpenSubs;
                Class'TurokUI'.static.SetSize(Item, 200.0000000, 25.0000000);
                // End:0x128
                if(bHorizontal)
                {
                    Class'TurokUI'.static.SetPosition(Item, 200.0000000 * float(I), 0.0000000);                    
                }
                else
                {
                    Class'TurokUI'.static.SetPosition(Item, 0.0000000, 25.0000000 * float(I));
                }
                Items[I] = Item;
            }
            I++;
            // [Loop Continue]
            goto J0x3B;
        }        
    }
    else
    {
        // End:0x1DC
        if(NumItems < PrevNumItems)
        {
            I = PrevNumItems;
            J0x18C:

            // End:0x1DC [Loop If]
            if(I >= NumItems)
            {
                Items[I].RemoveChildren();
                RemoveChild(Items[I]);
                Items[I] = none;
                I--;
                // [Loop Continue]
                goto J0x18C;
            }
        }
    }
    AdjustItemPositions();
    // End:0x1FF
    if(SelectedItemIndex >= NumItems)
    {
        SelectedItemIndex = NumItems - 1;
    }
    PrevNumItems = NumItems;
    //return;    
}

// Export UTurokUIMenu::execSetHighlightImagePosition(FFrame&, void* const)
native function SetHighlightImagePosition();

// Export UTurokUIMenu::execSetMenuSlidePosition(FFrame&, void* const)
native function SetMenuSlidePosition();

event Editor_UpdateHasHighlightImage()
{
    // End:0x11A
    if(bHasHighlightImage)
    {
        HighlightImage = Class'TurokUI'.static.CreateWidgetInScene(Class'Engine.UIImage', name(string(WidgetTag) $ "_HighlightImage"), GetScene(), self);
        // End:0x117
        if(HighlightImage != none)
        {
            Class'TurokUI'.static.SetSize(HighlightImage, HighlightImageSize.X, HighlightImageSize.Y);
            HighlightImage.Position.ScaleType[0] = 3;
            HighlightImage.Position.ScaleType[1] = 3;
            HighlightImage.bUseOverrides = true;
            // End:0xF4
            if(Items[SelectedItemIndex] != none)
            {
                SetHighlightImagePosition();                
            }
            else
            {
                Class'TurokUI'.static.SetPosition(HighlightImage, 0.0000000, 0.0000000);
            }
        }        
    }
    else
    {
        RemoveChild(HighlightImage);
        HighlightImage = none;
    }
    //return;    
}

event Editor_UpdateAutoOpenSubs()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3C [Loop If]
    if(I < NumItems)
    {
        Items[I].bAutoOpenSub = bAutoOpenSubs;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

event Editor_UpdateOffsetFromParent()
{
    Class'TurokUI'.static.SetPosition(self, OffsetFromParent.X, OffsetFromParent.Y);
    //return;    
}

event Initialized()
{
    SetMenuVisibility(true);
    //return;    
}

event AddShrinkificationScripts()
{
    local int I;
    local @NULL dummy_color;

    dummy_color.R = byte(255);
    dummy_color.G = byte(255);
    dummy_color.B = byte(255);
    dummy_color.A = byte(255);
    I = 0;
    J0x57:

    // End:0x1A3 [Loop If]
    if(I < NumItems)
    {
        ShrinkificationScripts[I] = Class'TurokUI'.static.AddScript(Items[I], "shrinkify");
        // End:0x199
        if(ShrinkificationScripts[I] != none)
        {
            ShrinkificationScripts[I].AddPositionKey(0.0000000, 0.0000000, 0.0000000,, 1);
            ShrinkificationScripts[I].AddPositionKey(fAnimTime, 0.0000000, 0.0000000,, 1);
            ShrinkificationScripts[I].AddColorKey(0.0000000, dummy_color, 1);
            ShrinkificationScripts[I].AddColorKey(fAnimTime, dummy_color, 1);
            ShrinkificationScripts[I].AddSizeKey(0.0000000, 0.0000000,, 1);
            ShrinkificationScripts[I].AddSizeKey(fAnimTime, 0.0000000,, 1);
        }
        I++;
        // [Loop Continue]
        goto J0x57;
    }
    //return;    
}

event AddCounterShrinkificationScript()
{
    CounterShrinkificationUnit = Class'TurokUI'.static.AddScript(self, "countershrinkify");
    // End:0x8A
    if(CounterShrinkificationUnit != none)
    {
        CounterShrinkificationUnit.AddPositionKey(0.0000000, 0.0000000, 0.0000000, 0.0000000, 1);
        CounterShrinkificationUnit.AddPositionKey(fAnimTime, 0.0000000, 0.0000000, 0.0000000, 1);
    }
    //return;    
}

// Export UTurokUIMenu::execPostSetupInitialize(FFrame&, void* const)
native function PostSetupInitialize();

// Export UTurokUIMenu::execSetSelection(FFrame&, void* const)
native function bool SetSelection(int Index);

function Deinitialize()
{
    local int I;

    ScriptCtrl = none;
    Class'TurokUI'.static.SetPosition(self, InitPos.X, InitPos.Y);
    I = 0;
    J0x41:

    // End:0x73 [Loop If]
    if(I < NumItems)
    {
        Items[I].Deinitialize();
        I++;
        // [Loop Continue]
        goto J0x41;
    }
    // End:0x8E
    if(HighlightImage != none)
    {
        HighlightImage.ScriptCtrl = none;
    }
    //return;    
}

defaultproperties
{
    fHighlightScale=2.0000000
    fUnHighlightScale=1.0000000
    fAnimTime=0.1250000
    fFadeDelay=0.0625000
    fSlideFactor=0.2500000
    HighlightImageSize=(X=47.0000000,Y=4.0000000)
    HighlightColor=(R=255,G=255,B=255,A=255)
    UnHighlightColor=(R=100,G=100,B=100,A=255)
    Position=(Value[2]=200.0000000,Value[3]=300.0000000)
    // Reference: UIComp_Event'Default__TurokUIMenu.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}