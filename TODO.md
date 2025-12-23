# MyHub TODO List

## High Priority

- [x] Implement ESP drawing logic (boxes, names, health bars, tracers)
- [x] Add ESP object pooling for performance
- [ ] Complete Aimbot target selection and aiming
- [ ] Implement Movement speed and jump modifications
- [ ] Add Fly functionality
- [x] Connect UI toggles to feature enable/disable
- [ ] Add panic key functionality to disable all features
- [ ] Implement config save/load properly
- [ ] Add error handling and fail-safes
- [ ] Add a SaveManger to save settings it autosaves when changes

## Medium Priority

- [ ] Optimize ESP for performance (lower update frequency for distant players)
- [ ] Add prediction to Aimbot
- [ ] Implement Silent Aim
- [ ] Add team color differentiation in ESP
- [ ] Implement Chams in ESP
- [ ] Add FOV circle visualization
- [ ] Implement auto-farm or other misc features
- [ ] Add UI animations and polish

## Low Priority

- [ ] Add advanced target prioritization (lowest health, etc.)
- [ ] Implement bunnyhop
- [ ] Add item autograb
- [ ] Server hop functionality
- [ ] Add performance stats display
- [ ] Implement undo functionality for actions
- [ ] Add confirmation dialogs for destructive actions

## Completed

- [x] Create skeleton UI with all tabs and elements
- [x] Set up modular structure (main.lua, core.lua, features/)
- [x] Create ESP module skeleton
- [x] Create Aimbot module skeleton
- [x] Create Movement module skeleton
- [x] Create Misc module skeleton
- [x] Create UI Helpers module skeleton
- [x] Set up global state management
- [x] Implement update loops (RenderStepped, Heartbeat)
- [x] Add safety checks and error handling in main.lua
- [x] Create README.md with usage instructions
- [x] Create TODO.md for tracking progress
- [x] Rename project to CloudyHub
- [x] Add creator credits and GitHub link in settings
- [x] Fix MouseButton2 keybind issue in aimbot.lua
- [x] Update module loading to use loadstring from GitHub
- [x] Update config folder name to CloudyHubConfigs

## Notes

- Skeleton is complete with all UI elements and modular structure
- Core functionality is set up but features need implementation
- Focus on implementing ESP and connecting UI toggles next
- Performance optimizations should be considered during implementation
- Test in multiple games to ensure compatibility
