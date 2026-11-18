# First playable smoke checklist

## Automated startup check

- [x] Godot 4.7.2 headless editor import completed; no GDScript parse errors remain.
- [x] Main menu and gameplay scenes each started headless without runtime script errors.
- [x] Isolated QA copy passed inventory limit, wrong/correct basket, save/load, invalid-primary backup recovery, and reset checks (18 Nov 2026).
- [ ] Repeat in the Godot GUI and visually inspect the room/HUD; headless startup does not check layout or feel.

## Desktop playthrough

- [ ] Main scene opens; player walks around without passing through walls, counter, shelf, or baskets.
- [ ] WASD/arrows move, captured mouse looks, E interacts, Esc releases the mouse.
- [ ] Camera pitch stays clamped; mouse clicks on menu/modal UI do not rotate the camera.
- [ ] Look at a flower within range; prompt names its type; interact picks it up and plays the pickup SFX.
- [ ] Inventory stops at five and shows the full-hands notice without removing the sixth flower.
- [ ] Correct basket accepts one matching flower; a wrong basket keeps the flower and plays the reject SFX.
- [ ] Progress increments once per successful placement; placed flowers appear in the basket.
- [ ] Place all 30 flowers; completion screen appears once, plays the completion cue, and Replay resets the level.
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
- [ ] Complete pickup, wrong basket, correct basket, full inventory, reset, and 30/30 completion on device.
- [ ] Run for 15 minutes; record FPS, load time, memory, temperature, OS version, and any crash.

Record device model, Android version, Godot version, build date, result, and reproduction steps for every issue.
