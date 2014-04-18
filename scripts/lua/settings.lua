----------------------------------------------------------------------
-- Settings Example File.
-- The `Solstice/settings.lua` file will be read into a global table
-- OPT.  The file must be present or the system will throw an error.

-- The following are only those used by the Solstice library.
-- Those marked 'REQUIRED:' *must* be set.  Those marked 'OPTIONAL:'
-- are optional.  One can add any other server specific setting they
-- wish and have it available via the global table OPT.

-- REQUIRED: Log directory.
LOG_DIR = "/opt/nwn/logs.0"

-- REQUIRED: Consant loader.
CONSTANTS = "ta_constants"

-- my server related stuff.
TA = true

--JIT_DUMP = true

DISABLE_CIRCLE_KICK = true

DEVCRIT_DISABLE_ALL = true
