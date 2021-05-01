local handler = require("event_handler")
handler.add_lib(require("freeplay"))
handler.add_lib(require("silo-script"))

global.pause_limit = 3
local function create_paused_frame(player)
    if player.gui.center.paused_frame then
        player.gui.center.paused_frame.destroy()
    end

    local outer_frame = player.gui.center.add {
        name = "paused_frame",
        type = "frame",
        direction = "vertical",
        caption = "The game is paused",
    }
    local inner_frame = outer_frame.add {
        name = "paused_inner_frame",
        type = "frame",
        direction = "vertical",
        style = "inside_shallow_frame_with_padding",
    }
    local label = inner_frame.add {
        type = "label",
        caption =
            "The game has been paused for a lack of players, waiting for " ..
            #game.connected_players ..  "/" .. global.pause_limit .. " players to join."
        ,
    }
end

local function pause_check()
    local paused = #game.connected_players < global.pause_limit
    game.tick_paused = paused

    if paused then
        for _, player in pairs(game.players) do
            create_paused_frame(player)
        end
    else
        for _, player in pairs(game.players) do
            if player.gui.center.paused_frame then
                player.gui.center.paused_frame.destroy()
            end
        end
    end
end

handler.add_lib({
    events = {
        [defines.events.on_player_joined_game] = pause_check,
        [defines.events.on_player_left_game] = pause_check,
    },
})