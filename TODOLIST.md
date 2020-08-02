# TODOLIST (bugs/refacto)

**elvengard-network**:

- Fix handle_init
- Fix resolve macro
- Change handle_packet params order to `header, params, client`
- Automatically set `client.frontend_pid` when a client is created

**WorldManager**:

- Fix World monitoring

**World**:

- Apply regex on character names before BD insertion (currently, the process crash)
- Check is character name already taken (currently, the process crash)

---------

**NEXT STEP : ChannelLobby Service**
