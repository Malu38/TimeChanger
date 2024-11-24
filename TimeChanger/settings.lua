data:extend({
    {
        type = "int-setting",
        name = "timechanger-max-game-speed",
        setting_type = "runtime-global",
        default_value = 64,
        allowed_values = {2, 4, 8, 16, 32, 64, 128, 256}
    },
    {
        type = "int-setting",
        name = "timechanger-min-game-speed",
        setting_type = "runtime-global",
        default_value = 8,
        allowed_values = {2, 4, 8, 16}
    },
})