--
-- User: david.bigagli@gmail.com
-- Date: 03/04/18
-- Time: 23.05
--
-- Manage Relay
--
dofile('config_relay.lua')

relay = {

    relay_closed = {},

    init_all = function()
        if config_relay == nil then
            print('config_relay table is not defined')
            return
        end

        for r, _ in pairs(config_relay) do
            print(r)
            relay.init(r)
        end
    end,

    init = function(r)
        if config_relay[r] == nil or config_relay[r].id == nil then
            print('relay ' .. r .. ' not found')
            return
        end

        local id = config_relay[r].id
        gpio.mode(id, gpio.OUTPUT)
        print('init ' .. r .. ' (' .. id .. ')')

        if config_relay[r].default_close ~= nil and config_relay[r].default_close == true then
            relay.close(r)
        else
            relay.open(r)
        end
    end,

    open = function(r)
        if config_relay[r] == nil or config_relay[r].id == nil then
            print('relay ' .. r .. ' not found')
            return false
        end

        local id = config_relay[r].id
        gpio.write(id, gpio.HIGH)
        relay.relay_closed[r] = false
        print('open ' .. r .. ' (' .. id .. ')')
        return true
    end,

    close = function(r)
        if config_relay[r] == nil or config_relay[r].id == nil then
            print('relay ' .. r .. ' not found')
            return false
        end

        local id = config_relay[r].id
        gpio.write(id, gpio.LOW)
        relay.relay_closed[r] = true
        print('close ' .. r .. ' (' .. id .. ')')
        return true
    end
}

