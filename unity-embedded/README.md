[![Eco by Strange Loop Games](https://cdn.cloudflare.steamstatic.com/steam/apps/382310/header.jpg)](https://store.steampowered.com/app/382310/Eco/)

<sub>Banner: Steam header for Eco by [Strange Loop Games](https://strangeloopgames.com/). Used here for attribution; not my artwork.</sub>

# eco-mods-assets-embeded

Embedded Unity assets (Icons, Prefabs, Scenes) referenced by my [Eco](https://play.eco/) mods at runtime. These are distinct from the built asset bundles in [eco-mods-assets](https://github.com/coilysiren/eco-mods-assets); the files here ship alongside the C# mod source and are loaded directly by the game client.

Unity manages the `.meta` files next to each asset. Do not edit them by hand. Copy operations into mod repos are driven by the Unity project in eco-mods-assets and by `invoke copy-assets` in [eco-mods-public](https://github.com/coilysiren/eco-mods-public).

See also [StrangeLoopGames/EcoModKit](https://github.com/StrangeLoopGames/EcoModKit) for the official Unity modkit package and asset layout conventions.
