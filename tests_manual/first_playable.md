# First playable smoke checklist

## Previous baseline checks

The checks below were run before the current expansion to nine types, 600 flowers, and two floors. Repeat them for this updated build before treating it as verified.

- [x] Godot 4.7.2 headless editor import completed; no GDScript parse errors remain.
- [x] Main menu and gameplay scenes each started headless without runtime script errors.
- [x] Isolated QA copy passed inventory limit, wrong/correct basket, save/load, invalid-primary backup recovery, and reset checks (18 Nov 2026).
- [ ] Re-run import, menu/gameplay startup, and save-state checks for the expanded build.
- [ ] Open in the Godot GUI and inspect both floors, ramp, wall cabinets, flower batches, and HUD; headless startup does not check layout or feel.

## Desktop playthrough

- [ ] Main scene opens; player walks around without passing through walls, counter, shelf, or baskets.
- [ ] WASD/arrows move, captured mouse looks, E interacts, Esc releases the mouse.
- [ ] Camera pitch stays clamped; mouse clicks on menu/modal UI do not rotate the camera.
- [ ] Look at a flower within range; prompt names its type; interact picks it up and plays the pickup SFX.
- [ ] Inventory stops at five and shows the full-hands notice without removing the sixth flower.
- [ ] Correct basket accepts one matching flower; a wrong basket keeps the flower and plays the reject SFX.
- [ ] Progress increments once per successful placement; placed flowers appear in the basket.
- [ ] Walk up and down the ramp; check both levels are reachable and the player cannot fall off the upper floor.
- [ ] Check wall cabinets are attached to the walls and do not block the ramp, baskets, or flower pickups.
- [ ] Find and sort all 600 flowers across nine types; completion appears once, plays the completion cue, and Replay resets the level.
- [ ] Music and SFX sliders independently control their audio; zero volume mutes the corresponding bus.
- [ ] Pause, settings, reset confirmation, return to menu, Continue, New Game confirmation, and Credits work.
- [ ] Reset confirmation clears inventory and placed progress; canceling it preserves both.
- [ ] Quit/reopen restores inventory and placed flowers. Test a deliberately malformed save and backup recovery.

## Android device playthrough

- [ ] Install the debug build on a small landscape phone and a mid-range phone.
- [ ] Left thumb moves while right thumb looks; both work at the same time.
- [ ] Interact and pause buttons are reachable and do not also trigger camera drag.
- [ ] Check notches, system bars, text wrapping, modal sizes, and thumb reach in landscape.
- [ ] Open pause while moving, then resume; the player remains still until the joystick is touched again.
- [ ] Send the app to background while moving and while paused; resume without stuck input or lost saved progress.
- [ ] Complete pickup, wrong basket, correct basket, full inventory, floor transition, reset, and 600/600 completion on device.
- [ ] Run for 15 minutes; record FPS, load time, memory, temperature, OS version, and any crash.

Record device model, Android version, Godot version, build date, result, and reproduction steps for every issue.
