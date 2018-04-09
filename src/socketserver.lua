--
-- User: david.bigagli@gmail.com
-- Date: 04/04/18
-- Time: 21.41
--

dofile('config_socketserver.lua')

socketserver = {

    srv = nil,

    init = function()
        local srv = net.createServer(net.TCP)
        srv:listen(config_socketserver.port, function(conn)
            local with_credentials = false
            local authenticated = false
            local buffer = {}
            if config_socketserver.user ~= nil and config_socketserver.pwd ~= nil then
                with_credentials = true
            end
            conn:on("receive", function(conn, payload)
                local arr_payload = split(payload, "\n")
                buffer = array_concat( buffer, arr_payload )

                print('buffer: ')
                for _, v in ipairs(buffer) do print('-- ' .. v) end

                --
                -- check credentials socket server
                --
                if with_credentials and #buffer >= 2 and authenticated == false then
                    if not socketserver.check_credentials(buffer) then
                        conn:send(
                            socketserver.make_response('Bad socketserver credentials')
                        )
                        return
                    end
                    authenticated = true
                end

                --
                -- exec command
                --
                if ( not with_credentials and #buffer >= 1 ) or (with_credentials and #buffer >= 3 ) then
                    local command
                    if with_credentials then
                        command = trim(buffer[3])
                    else
                        command = trim(buffer[1])
                    end
                    conn:send(
                        socketserver.make_response(
                            socketserver.command_exec(command)
                        )
                    )
                    return
                end

            end)
            conn:on("sent", socketserver.sent)
        end)
    end,

    command_exec = function(payload)
        print(payload)
        local tokens = split(payload, ' ')
        local command = ''
        local arg1 = ''
        local response = ''

        if tokens ~= nil and tokens[1] ~= nil then
            command = tokens[1]
        end
        if tokens ~= nil and tokens[2] ~= nil then
            arg1 = tokens[2]
        end

        print( '-- command:' .. arg1 .. '--')
        print( '-- arg1:' .. arg1 .. '--')

        -- Command open
        -- Activate, close relay
        if command == 'open' then
            if arg1 then
                print 'open'
                if relay.close(arg1) == false then
                    response = 'open "' .. arg1 .. "' failed"
                end
            else
                response = 'Alias relay not specified' --socketserver.make_response('Alias relay not specified')
            end

        -- Command close
        -- Deactivate, open relay
        elseif command == 'close' then
            if arg1 then
                print 'close'
                if( relay.open(arg1) == false ) then
                    response = 'close "' .. arg1 .. "' failed"
                end
            else
                response = 'Alias relay not specified' --socketserver.make_response('Alias relay not specified')
            end

        else
            response = 'invalid command' --socketserver.make_response('invalid command')
        end

        return response
        -- conn:send(response)
    end,

    sent = function(conn)
        conn:close()
    end,

    --
    -- Build the response for then receive callback
    --
    make_response = function(m)
        return '{ "error": { "code": 0, "description": "' .. m .. '"} }'
    end,

    --
    -- Check credentials socket server
    --
    check_credentials = function(credentials)
        print( 'credentials: ' )
        for _, v in pairs(credentials) do print('-- ' .. v) end

        if trim(credentials[1]) == config_socketserver.user and trim(credentials[2]) == config_socketserver.pwd then
            return true
        end
        return false
    end
}

