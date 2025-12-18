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

## Fixes Explanation

Explanations of each fix in detail for those interested in the technical implementation or wanting to contribute.

### 1. Trade Companies Start with the Trade Company Advance

Trade companies need the `trade_companies_advance` to build anything, but Paradox never gave it to them.

**Solution:** The advance is unlocked when a Trade Company Headquarters is built:

```
research_advance = advance_type:trade_companies_advance
```

Additionally, a sweeper runs on game start (`ftc_trade_company_advance_sweeper`) to grant the advance to any existing trade companies for save game compatibility.

**Note:** Ideally, trade companies would inherit their overlord's technology, but this hasn't been figured out yet. Contributions welcome.

### 2. Allow Overlord to Build Trade Company Buildings

There was a limit to the number of Trade Company buildings that could be constructed via `number_of_satellite_trade_buildings`. The check allowed building if either the overlord's or the Trade Company's limit was sufficient. However, the only source of this modifier was the Trade Company Headquarters, which only applied to the Trade Company itself - the overlord never had any source of it.

Since Paradox explicitly checked against the overlord's limit, it seems they intended for overlords to have some source of this modifier. This was confirmed when they [accepted a bug report](https://forum.paradoxplaza.com/forum/threads/trade-company-buildings-cant-be-built.1869285/#post-30909723) on the issue.

**Why remove the limit entirely?**
- The limit never actually functioned. Despite theoretically limiting trade companies to 2 of each building type, you could build unlimited numbers as a Trade Company.
- The limit doesn't make much sense - company buildings are already weak, and you're naturally limited by Trade Company regions.
- The modifier is global, so you could bypass it by creating multiple trade companies per region anyway.

### 3. Attempted to Make the Trade Company AI Build More

The Trade Company AI is reluctant to build company buildings. To improve this, the following flags were added to each building:

```
AI_ignore_available_worker_flag = yes
important_for_AI = yes
```

This makes the AI ignore the Burghers requirement (since there likely won't be many where Trade Companies start) and prioritize these buildings more.

**Current Status:** Even with these changes, the AI still doesn't expand much, likely because base game Trade Company buildings are poor investments. Further improvements are being investigated.

### 4. Removing the Market Access Requirement

In the original files, all buildings used:

```
own_or_overlord_relation_needed = trade_access
```

Where `trade_access` is market access preference. However, the `own_or_overlord_relation_needed` check doesn't actually count for the overlord, and the AI never requests market access preference on its own - meaning Trade Companies could never build any buildings with this requirement.

**Why removal is acceptable:**
- The base acceptance chance for market access preference is already positive with no negative modifiers, so if the AI actually requested it, they'd get access to everyone with a market anyway.
- The only practical effect would have been preventing buildings in companies that don't own a market (within the same Trade Company Region), which isn't a major concern.

**Note:** The requirement still applies to constructing the headquarters. If a way is found to fix the `own_or_overlord_relation_needed` check, or if Paradox patches it, the requirement will be restored.

Attempts were made to add `+1000 wants_to_receive` reasons for Trade Companies, but they still don't request market access for unknown reasons.

### 5. Allows Renaming Trade Companies

Trade Companies can now be renamed through the standard country renaming interface.

### 6. The Pop Issue Workaround

**The Problem:** The error "We can not build a [Company Building] in [Location] as there are already [Country Pops] there." prevents overlords from building more than one Trade Company building per location once pops exist there. This only affects the overlord, not the Trade Company itself.

The requirement doesn't appear in the files except for its localization. After extensive testing, it stems from `is_foreign = yes`. Removing this flag allows building within existing borders but prevents expansion entirely, and would prevent overlords from building at all.

**The Workaround (credit to @Pickle):**

1. Created duplicate "temp" versions of each affected building (e.g., `trade_company_garrison_temp`)
2. These temp buildings use a temporary pop type (`ftc_temp_burghers`) with identical localization to the original
3. When the temp building completes construction:
   - It instantly constructs the real building at zero cost
   - Destroys itself and any temporary pops
   - No temp pop types ever persist in the game

**Hiding the Duplicates:**

- The real buildings have `country_potential` set to always fail for overlords via `ftc_hide_permanent_buildings_country_potential`
- For buildings you already own (where the above doesn't work), @Pickle modified the production view to support hiding specific buildings
- This modification was also committed to the [Community Mod Framework](https://github.com/Europa-Universalis-5-Modding-Co-op/community-mod-framework)

**Limitation:** If another mod overwrites the production view, duplicates will appear. Use the "Build [Building Name]" variant in this case.

### 7. Fix Issues with Multiple Trade Companies Per Region

**The Problem:** If you have multiple trade companies in the same Trade Company region, constructed buildings arbitrarily transfer to only one of them with no way to choose which.

**Solution:** Restricted to one trade company headquarters per region per overlord. The headquarters now checks:

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
2. Copy it to `Documents\Paradox Interactive\Europa Universalis V\mod`
3. Enable as normal in game

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
