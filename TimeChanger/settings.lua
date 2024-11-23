data:extend({
    {
        type = "int-setting",
        name = "time-changer-max-time-speed",
        setting_type = "runtime-global",
        default_value = 64,
        allowed_values = {2, 4, 8, 16, 32, 64, 128, 256}
    },
    {
        type = "int-setting",
        name = "time-changer-min-time-speed",
        setting_type = "runtime-global",
        default_value = 16,
        allowed_values = {2, 4, 8, 16}
    },
})