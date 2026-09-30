// Cosmetic Kit Plus: new kinds of cosmetics on top of Cosmetic Kit. Balls, hats and goal explosions are the game's own
// three kinds (Cosmetic Kit adds custom ones of those); Cosmetic Kit Plus adds slots of its own, worn with them:
//
//   arms    arms on the ball: a model (with the ball, kept upright, swinging or animated as the ball rolls)
//
// Each slot gets a tab of its own on the Customize page, after balls, hats and bfx (in local mode, as custom cosmetics
// are only ever worn on the player's own ball), with a "none" tile first. It remembers what the player wears in each slot and
// puts it back on next launch.
//
// A plugin that adds them lists "cosmetic-kit-plus" in its [meta] dependencies and imports:
//
//   import bool AddArms(const string &in, const string &in, const string &in, const string &in) from "cosmetic-kit-plus";
//   import bool AddExtra(const string &in, const string &in, const string &in, const string &in, const string &in) from "cosmetic-kit-plus";
//
// AddArms(id, name, preview, model): an id starting with the adding plugin's id ("example-arms.buff"), the name on its
// tile, its tile picture, and the model: a model text file (the host's models format) or a 3D model file (.glb, .gltf,
// .obj), full paths inside that plugin's folder (Plugins::Folder() + "models/buff.txt"). Put the arms in a "travel"
// group to keep them upright and turned the way the ball goes, and give them swinging groups or an animation so they
// move as the ball rolls (see Example Arms).
//
// AddExtra(slot, id, name, preview, model) is the same for any slot name (lowercase letters, digits, dashes, spaces).

array<string> slots;              // the slots cosmetics have been added to
array<string> saved;              // per slot: what Storage holds
array<string> restoring;          // per slot: worn last session, put back once the plugin that adds it has

bool AddArms(const string &in id, const string &in name, const string &in preview, const string &in model)
{
    return AddExtra("arms", id, name, preview, model);
}

bool AddExtra(const string &in slot, const string &in id, const string &in name, const string &in preview, const string &in model)
{
    int k = Known(slot);
    if (!Cosmetics::AddExtra(slot, id, name, preview, model))
    {
        Log::Warn("could not add " + slot + " " + id);
        return false;
    }
    Log::Info("added " + slot + " " + id);
    if (restoring[k] == id)
    {
        Cosmetics::EquipExtra(slot, id);
        restoring[k] = "";
        Log::Info("wearing " + slot + " " + id + " again");
    }
    return true;
}

// A slot's index; its saved choice is read the first time something is added to it.
int Known(const string &in slot)
{
    int k = slots.find(slot);
    if (k >= 0)
        return k;
    string last = Storage::Get(slot, "");
    slots.insertLast(slot);
    saved.insertLast(last);
    restoring.insertLast(last);
    return int(slots.length()) - 1;
}

void Main()
{
    Known("arms");
}

// What the player wears is saved when it changes. While an extra from last session has not been added yet (its plugin
// loads later, or was removed), the saved choice is kept.
void Update(float dt)
{
    for (uint k = 0; k < slots.length(); k++)
    {
        string worn = Cosmetics::EquippedExtra(slots[k]);
        if (restoring[k] != "" && worn != "")
            restoring[k] = "";                      // the player chose another one meanwhile
        if (restoring[k] != "")
            continue;
        if (worn != saved[k])
        {
            saved[k] = worn;
            Storage::Set(slots[k], worn);
        }
    }
}
