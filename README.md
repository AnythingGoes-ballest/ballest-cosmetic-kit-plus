# Cosmetic Kit Plus

A plugin for the [Ballest plugin manager](https://github.com/AnythingGoes-ballest/ballest-plugin-manager): new kinds of
cosmetics on top of [Cosmetic Kit](https://github.com/AnythingGoes-ballest/ballest-cosmetic-kit), starting with
**arms**. Plugins add them; you pick them on the **Customize** page; it remembers what you wear.

- Arms are worn with any ball and hat: pick a ball, pick a hat, and pick arms too.
- Find them on the Customize page's **arms** tab, after balls, hats and bfx. It shows in **local** mode (arms are worn
  on your own ball only). The first tile, **none**, takes them off.
- Like custom cosmetics, they're worn on your own ball only (the menu ball and the ball you race with).
- What you wear is saved and put back the next time you start the game.

Cosmetic Kit Plus adds nothing by itself. Install a plugin that uses it, such as
[Example Arms](https://github.com/AnythingGoes-ballest/ballest-example-arms).

## Install

In the game: footer **plugins** > **browse** > Cosmetic Kit Plus > **install**. Plugins that need it install it (and
Cosmetic Kit) for you. Needs the plugin manager host 0.19.0 or newer.

## Making arms

List `cosmetic-kit-plus` in your plugin's `[meta] dependencies` and import:

```angelscript
import bool AddArms(const string &in, const string &in, const string &in, const string &in) from "cosmetic-kit-plus";
```

`AddArms(id, name, preview, model)`:

- `id`: starting with your plugin's id (`my-arms.noodle`), so two plugins never clash.
- `name`: the name on its tile.
- `preview`: its tile picture, a PNG in your plugin's folder (`Plugins::Folder() + "noodle.png"`).
- `model`: a model text file in the host's
  [models format](https://anythinggoes-ballest.github.io/ballest-plugin-manager/guides/cosmetics/), or a 3D model file
  (`.glb`, `.gltf`, `.obj`). It's built on the ball like a ball's model: the ball's middle is the origin and its radius
  is 50.

Put the arms in a `travel` group so they stay upright and face where the ball goes (+x is forward and +y is the ball's
right, so arms hang at y = -50 and +50). To make them move as the ball rolls, give them swinging groups (built from
shapes), or a 3D model file's own animation (`anim=`, `run=`, `idle=`).
[Example Arms](https://github.com/AnythingGoes-ballest/ballest-example-arms) has both, and a script that cuts the arms
out of an animated character.

```angelscript
void Main()
{
    string f = Plugins::Folder();
    AddArms("my-arms.noodle", "Noodle Arms", f + "noodle.png", f + "noodle.txt");
}
```

More slots will follow; `AddExtra(slot, id, name, preview, model)` adds to any slot by name:

```angelscript
import bool AddExtra(const string &in, const string &in, const string &in, const string &in, const string &in) from "cosmetic-kit-plus";
```

## License

MIT
