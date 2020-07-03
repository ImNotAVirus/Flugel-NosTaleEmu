# TODOLIST (bugs/refacto)

**Core**:

- Create Mnesia wrapper for tables, records, etc...
- Fix handle_init (`elven_gard` lib)

**WorldManager**:

- Fix World monitoring

**World**:

- Apply regex on character names before BD insertion (currently, the process crash)
- Check is character name already taken (currently, the process crash)
- Rename character_selection => authentication
