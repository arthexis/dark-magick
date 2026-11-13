-- Fate Deck object script recovered from the original Dark Magic save.
-- It remains separate from Global.lua so it can be attached to a physical deck
-- object in Tabletop Simulator.

local INITIAL_HAND = 5
local INITIAL_WOUNDS = 7
local VOID_PILE_GUID = "45e3ae"

local function seatedPlayerColors()
    local colors = {}
    for _, player in ipairs(Player.getPlayers()) do
        if player.seated then
            table.insert(colors, player.color)
        end
    end
    return colors
end

function onLoad()
    self.createButton({
        click_function = "start_game",
        function_owner = self,
        label = "Start\nGame",
        position = {0, 0, -2.5},
        rotation = {180, 0, 0},
        width = 1000,
        height = 800,
        font_size = 340,
        color = {0.5, 0.5, 0.5},
        font_color = {1, 1, 1},
    })
    self.createButton({
        click_function = "draw_black",
        function_owner = self,
        label = "Draw",
        position = {2.5, 0, 0},
        rotation = {180, 270, 0},
        width = 1000,
        height = 800,
        font_size = 340,
        color = {0.5, 0.5, 0.5},
        font_color = {1, 1, 1},
    })
    self.createButton({
        click_function = "draw_white",
        function_owner = self,
        label = "Draw",
        position = {-2.5, 0, 0},
        rotation = {180, 90, 0},
        width = 1000,
        height = 800,
        font_size = 340,
        color = {0.5, 0.5, 0.5},
        font_color = {1, 1, 1},
    })
end

function start_game()
    local voidPile = getObjectFromGUID(VOID_PILE_GUID)
    if voidPile then
        for _, card in pairs(voidPile.getObjects()) do
            self.putObject(card)
        end
    end
    self.shuffle()

    for _, color in ipairs(seatedPlayerColors()) do
        self.deal(INITIAL_HAND, color)
        local wounds = add_wounds(self, INITIAL_WOUNDS, color)
        for _, woundDeck in ipairs(wounds) do
            woundDeck.setRotation({0, 0, 180})
        end
    end
end

function add_wounds(source, count, color)
    local wounds = {}
    for index = 1, count do
        wounds[index] = source.dealToColorWithOffset({12, 0, 4}, false, color)
    end
    return wounds
end

function draw_white()
    local colors = seatedPlayerColors()
    if colors[1] then
        self.deal(1, colors[1])
    end
end

function draw_black()
    local colors = seatedPlayerColors()
    if colors[2] then
        self.deal(1, colors[2])
    end
end
