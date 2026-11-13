-- Dark Magick multi-deck controller for Tabletop Simulator.
-- Paste this complete file into the Global script. TTS runs global scripts in
-- a sandbox, so expansion descriptors are embedded here rather than required
-- from the filesystem.

local DeckRegistry = {
    decks = {},
    active = {},
}

local PoisonLegacy = {
    id = "poison-legacy",
    name = "Poison Legacy",
    description = "The original 50-card Dark Magick deck.",
    custom_deck_id = 4,
    card_count = 50,
    first_card_index = 0,
    face_url = "http://cloud-3.steamusercontent.com/ugc/1679241899324398994/5C11A2D50C1A71340C770FB2C516286AC37727DF/",
    back_url = "http://cloud-3.steamusercontent.com/ugc/1679241899324400456/E8AE2EC481D8F64C4A78F4B5DB6FC0FF4A6BAC40/",
    num_width = 10,
    num_height = 7,
    back_is_hidden = true,
    unique_back = true,
}

local function announce(message, color)
    printToAll("[Dark Magick] " .. message, color or {0.75, 0.85, 1})
end

local function trim(value)
    return value:match("^%s*(.-)%s*$")
end

function DeckRegistry.register(deck)
    assert(deck.id and deck.id ~= "", "Deck id is required")
    assert(deck.card_count and deck.card_count > 0, "Deck card_count must be positive")
    assert(deck.custom_deck_id, "Deck custom_deck_id is required")
    assert(deck.face_url and deck.back_url, "Deck image URLs are required")
    DeckRegistry.decks[deck.id] = deck
end

function DeckRegistry.list()
    local ids = {}
    for id in pairs(DeckRegistry.decks) do
        table.insert(ids, id)
    end
    table.sort(ids)
    return ids
end

function DeckRegistry.setActive(ids)
    local selected = {}
    for _, id in ipairs(ids) do
        if not DeckRegistry.decks[id] then
            return false, "Unknown expansion: " .. id
        end
        table.insert(selected, id)
    end
    if #selected == 0 then
        return false, "Select at least one expansion."
    end
    DeckRegistry.active = selected
    return true
end

local function makeDeckJson(deck, position)
    local cardIds = {}
    for index = deck.first_card_index, deck.first_card_index + deck.card_count - 1 do
        -- Tabletop Simulator card ids are CustomDeck id * 100 plus slot index.
        table.insert(cardIds, deck.custom_deck_id * 100 + index)
    end

    return JSON.encode({
        Name = "Deck",
        Nickname = deck.name,
        Description = deck.description,
        Transform = {
            posX = position.x,
            posY = position.y,
            posZ = position.z,
            rotX = 0,
            rotY = 180,
            rotZ = 180,
            scaleX = 1,
            scaleY = 1,
            scaleZ = 1,
        },
        CustomDeck = {
            [tostring(deck.custom_deck_id)] = {
                FaceURL = deck.face_url,
                BackURL = deck.back_url,
                NumWidth = deck.num_width,
                NumHeight = deck.num_height,
                BackIsHidden = deck.back_is_hidden,
                UniqueBack = deck.unique_back,
                Type = 0,
            },
        },
        DeckIDs = cardIds,
    })
end

function DeckRegistry.spawn(id, position)
    local deck = DeckRegistry.decks[id]
    if not deck then
        return nil, "Unknown expansion: " .. id
    end

    local object = spawnObjectJSON({json = makeDeckJson(deck, position)})
    object.shuffle()
    return object
end

function DeckRegistry.spawnActive(position)
    local spawned = {}
    for offset, id in ipairs(DeckRegistry.active) do
        local object, errorMessage = DeckRegistry.spawn(id, {
            x = position.x + ((offset - 1) * 3),
            y = position.y,
            z = position.z,
        })
        if not object then
            return nil, errorMessage
        end
        table.insert(spawned, object)
    end
    return spawned
end

local function parseExpansionList(value)
    local ids = {}
    for id in value:gmatch("[^,]+") do
        table.insert(ids, trim(id))
    end
    return ids
end

function onLoad()
    DeckRegistry.register(PoisonLegacy)
    DeckRegistry.setActive({PoisonLegacy.id})
    announce("Loaded Poison Legacy. Type !darkmagick decks for available expansions.")
end

function onChat(message, player)
    if message == "!darkmagick decks" then
        announce("Available expansions: " .. table.concat(DeckRegistry.list(), ", "))
        return false
    end

    local deckId = message:match("^!darkmagick%s+deck%s+([%w_-]+)%s*$")
    if deckId then
        local object, errorMessage = DeckRegistry.spawn(deckId, player.getPointerPosition())
        if object then
            announce(player.steam_name .. " spawned " .. DeckRegistry.decks[deckId].name .. ".")
        else
            announce(errorMessage, {1, 0.35, 0.35})
        end
        return false
    end

    local requested = message:match("^!darkmagick%s+load%s+(.+)$")
    if requested then
        local selected = parseExpansionList(requested)
        local ok, errorMessage = DeckRegistry.setActive(selected)
        if not ok then
            announce(errorMessage, {1, 0.35, 0.35})
            return false
        end
        local objects, spawnError = DeckRegistry.spawnActive(player.getPointerPosition())
        if not objects then
            announce(spawnError, {1, 0.35, 0.35})
        else
            announce(player.steam_name .. " loaded " .. table.concat(selected, ", ") .. ".")
        end
        return false
    end
end
