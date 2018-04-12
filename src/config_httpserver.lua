--
-- Http Configuration
--

config_httpserver = {

    port = 80,

    auth = {

        enabled = true,

        realm = 'espRemoteRelay',

        users = {

            user = 'password'

        }

    }


}