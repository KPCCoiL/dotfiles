require("vis")
local plug = require("plugins/vis-plug")

local plugins = {
    { "KPCCoiL/vis-tmux-repl", file = "tmux-repl", ref="mac-sed" },
}

plug.init(plugins, true)

function setOption(...)
    local optstrs = table.pack(...)
    local command = "set"
    for _, s in ipairs(optstrs) do
        command = command .. " " .. s
    end
    vis:command(command)
end

vis.events.subscribe(vis.events.INIT, function()
    local modes = {
        vis.modes.NORMAL,
        vis.modes.OPERATOR_PENDING,
        vis.modes.INSERT,
        vis.modes.REPLACE,
        vis.modes.VISUAL,
        vis.modes.VISUAL_LINE,
    }
    for _, mode in ipairs(modes) do
        vis:map(mode, "<C-l>", "<Escape>")
    end

    local motion = {
        vis.modes.NORMAL,
        vis.modes.VISUAL,
        vis.modes.VISUAL_LINE,
    }
    for _, mode in ipairs(motion) do
        vis:map(mode, "j", "gj")
        vis:map(mode, "k", "gk")
    end
    setOption("autoindent")
    setOption("ignorecase")
    vis:map(vis.modes.NORMAL, " -", "<C-w>s")
    vis:map(vis.modes.NORMAL, " |", "<C-w>v")
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
    setOption("number")
    local indents = {
        ansi_c = "tab8", go = "tab4",
    }
    indent = indents[win.syntax]
    if indent and indent:sub(1, 3) == "tab" then
        setOption("expandtab off")
        setOption("tabwidth", tonumber(indent:sub(4)))
    else
        setOption("expandtab")
        setOption("tabwidth", 4)
    end
    local repls = {
        ansi_c = "cling",
        cpp = "cling",
        python = "python",
        haskell = "ghci",
        lua = "lua",
        scheme = "guile",
    }
    win:map(vis.modes.NORMAL, " r", ":repl-new " .. (repls[win.syntax] or "") .. "<Enter>")
    win:map(vis.modes.VISUAL, " e", ":repl-send<Enter><vis-mode-normal>")

    local formatters = {
        ansi_c = "indent -linux",
    }

    if formatters[win.syntax] then
        win:map(vis.modes.VISUAL, "=", ":|" .. formatters[win.syntax] .. "<Enter>")
    end
end)
