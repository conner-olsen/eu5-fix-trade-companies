# EU5 Fix Trade Companies

A mod for Europa Universalis V that fixes the broken Trade Company system, making it fully functional as Paradox intended.

[![Steam Workshop](https://img.shields.io/badge/Steam%20Workshop-Subscribe-blue)](https://steamcommunity.com/sharedfiles/filedetails/?id=3610028078)

## Overview

EU5 trade companies were clearly not finished for release. Numerous issues make them completely non-functional. This mod fixes all the problems while keeping trade companies as Paradox "intended".

## Features

1. **Allows overlord to build Trade Company buildings** - Buildings get transferred to the Trade Company upon completion.

2. **Trade companies start with the Trade Company advance** - Paradox forgot to give them this, so they couldn't actually construct buildings.

3. **Attempts to make the AI build and expand Trade Companies more** - Added `AI_ignore_available_worker_flag` and `important_for_AI` flags to encourage AI building.

4. **Removes the broken market access preference requirement** - Trade Company buildings can now be constructed without market access preference (headquarters still requires this). The `own_or_overlord_relation_needed` check doesn't actually count for the overlord, and AI never requests market access preference on its own.

5. **Allows renaming Trade Companies**

6. **Fixes the "We can not build a [Company Building] in [Location] as there are already [Country Pops] there." error** - Created duplicate temporary buildings with temporary pop types. Once built, the temp building constructs the real building and destroys itself. Real buildings are hidden in the construction view via a modified production view.

7. **Fixes issues with multiple trade companies per region** - Only one trade company headquarters per overlord per region is now allowed. Previously, buildings would arbitrarily transfer to only one of multiple companies in the same region.

## Technical Details

### How the Pop Issue Workaround Works

The `is_foreign = yes` flag on buildings causes the game to reject construction if pops already exist at that location. Since we can't modify this behavior directly, the mod:

1. Creates "temp" versions of each trade company building (e.g., `trade_company_garrison_temp`)
2. These temp buildings use a temporary pop type (`ftc_temp_burghers`) with identical localization
3. When a temp building completes construction, it:
   - Instantly constructs the real building at zero cost
   - Destroys itself and any temporary pops
4. The real buildings are hidden from the overlord's construction menu via `ftc_hide_permanent_buildings_country_potential`
5. The production view is modified to support hiding specific buildings (also contributed to the [Community Mod Framework](https://github.com/Europa-Universalis-5-Modding-Co-op/community-mod-framework))

### How the Advance Fix Works

Trade companies need the `trade_companies_advance` to build anything. The mod:

1. Unlocks the advance when a Trade Company Headquarters is built via `research_advance = advance_type:trade_companies_advance`
2. Runs a sweeper on game start to grant the advance to any existing trade companies

### Region Restriction

To prevent the building transfer bug, the headquarters now checks:
- Whether the overlord already has a trade company in the target region via `trade_company_regions` variable list
- Blocks construction if one already exists in that region

## Planned Features

- Better encourage the AI controlling trade companies to expand

## Compatibility

- **Not Ironman Compatible**
- **Fully save game compatible**
- Works with any mod that doesn't modify:
  - Trade buildings
  - The trade company advance
  - The trade company subject type
- **UI Mods**: We overwrite the production view to hide duplicate buildings. Compatible with all UI mods, but load them **after** this mod.
- Compatibility patches available upon request

## Important Note

When using mods that overwrite the production view, you will see duplicate trade buildings:
- One titled "Build [Building Name]" (use this one)
- One titled just "[Building Name]"

This is a side effect of the pop issue workaround. Always use the "Build [Building Name]" variant to construct buildings.

## Installation

### Steam Workshop (Recommended)
Subscribe on the [Steam Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=3610028078).

### Manual Installation
1. Clone or download this repository
2. it to\Documents\Paradox Interactive\Europa Universalis V\mod
3. Enable as normal in game.

## Project Structure

```
eu5-fix-trade-companies/
├── in_game/                    # Active gameplay files
│   ├── common/
│   │   ├── advances/           # Trade company advance injection
│   │   ├── building_categories/# TC building category
│   │   ├── building_types/     # Modified trade buildings
│   │   ├── on_action/          # Advance sweeper and building hide logic
│   │   ├── pop_types/          # Temporary pop types
│   │   ├── script_values/      # Building caps
│   │   ├── scripted_effects/   # Building construction effects
│   │   ├── scripted_guis/      # Building visibility logic
│   │   ├── scripted_triggers/  # Building requirement checks
│   │   └── subject_types/      # Trade company subject modifications
│   └── gui/                    # Modified production view
└── main_menu/                  # Menu assets and localization
    ├── gfx/                    # Building icons
    └── localization/           # English localization
```

## Contributing

Contributions are welcome! If you're interested in helping with development:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

For discussion and coordination:
- Join the [EU5 Community Discord](https://discord.gg/EU5)
- Ping or add **@arealconner** on Discord

## Related Projects

A separate **Trade Company Overhaul** mod is in development that will completely rebalance trade companies to make them more worthwhile and interesting. Discussion and suggestions are welcome in the [overhaul discussion](https://steamcommunity.com/workshop/filedetails/discussion/3610028078/684112192553014814/) on Steam.

## Links

- [Steam Workshop Page](https://steamcommunity.com/sharedfiles/filedetails/?id=3610028078)
- [Fixes Discussion](https://steamcommunity.com/workshop/filedetails/discussion/3610028078/684112192553014734/)
- [Overhaul Discussion](https://steamcommunity.com/workshop/filedetails/discussion/3610028078/684112192553014814/)
- [EU5 Community Discord](https://discord.gg/EU5)
- [Community Mod Framework](https://github.com/Europa-Universalis-5-Modding-Co-op/community-mod-framework)

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.