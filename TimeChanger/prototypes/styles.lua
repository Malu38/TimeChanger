data:extend({
    {
        type = "font",
        name = "timechanger_font_bold",
        from = "default-bold",
        border = false,
        size = 15
    },
    {
        type = "sprite",
        name = "sprite_timechanger_lock_closed",
        filename = "__TimeChanger__/graphics/padlock_closed.png",
        width = 22,
        height = 30
    },
    {
        type = "sprite",
        name = "sprite_timechanger_lock_open",
        filename = "__TimeChanger__/graphics/padlock_open.png",
        width = 22,
        height = 30
    }
})

local gui = data.raw["gui-style"].default

gui.timechanger_sprite_style =
{
    type="button_style",
	parent="button",
	top_padding = 1,
	right_padding = 0,
	bottom_padding = 0,
	left_padding = 0,
	width = 36,
	height = 36,
	scalable = false,
}

gui.timechanger_flow_style =
{
    type="horizontal_flow_style",
	parent="horizontal_flow",
	top_padding = 5,
	bottom_padding = 5,
	left_padding = 5,
	right_padding = 5,
	horizontal_spacing = 0,
	vertical_spacing = 0,
	max_on_row = 0,
	resize_row_to_width = true,
	graphical_set = { type = "none" }
}

gui.timechanger_button_style = 
{
	type="button_style",
	parent="button",
	font="timetools_font_bold",
	align = "center",
	top_padding = 1,
	bottom_padding = 0,
	left_padding = 0,
	right_padding = 0,
	height = 36,
	minimal_width = 36,
	scalable = false,
}

