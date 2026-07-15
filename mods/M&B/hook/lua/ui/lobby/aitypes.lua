----------------------------------------------------------------------------
-- M&B: lobby AI list replaced with M28 variants only.
-- Vanilla AI entries are removed; every entry routes to M28 (the hijack in
-- M28AI/hook/lua/aibrain.lua catches any personality starting with 'm28').
-- Subtype/cheat are handled by M28 itself (M28Chat.AssignAIPersonalityAndRating
-- and OnCreateBrain cheat-stripping).
----------------------------------------------------------------------------
aitypes = {
    { key = 'm28ai',          name = "M28 Adaptive" },
    { key = 'm28aie',         name = "M28 Easy" },
    { key = 'm28aiair',       name = "M28 Air" },
    { key = 'm28ailand',      name = "M28 Land" },
    { key = 'm28airush',      name = "M28 Rush" },
    { key = 'm28aitech',      name = "M28 Tech" },
    { key = 'm28aiturtle',    name = "M28 Turtle" },
    { key = 'm28ainavy',      name = "M28 Navy" },
    { key = 'm28airandom',    name = "M28 Random" },

    { key = 'm28aicheat',     name = "M28 Adaptive (AIx)" },
    { key = 'm28aiecheat',    name = "M28 Easy (AIx)" },
    { key = 'm28aiaircheat',  name = "M28 Air (AIx)" },
    { key = 'm28ailandcheat', name = "M28 Land (AIx)" },
    { key = 'm28airushcheat', name = "M28 Rush (AIx)" },
    { key = 'm28aitechcheat', name = "M28 Tech (AIx)" },
    { key = 'm28aiturtlecheat', name = "M28 Turtle (AIx)" },
    { key = 'm28ainavycheat', name = "M28 Navy (AIx)" },
    { key = 'm28airandomcheat', name = "M28 Random (AIx)" },
}
