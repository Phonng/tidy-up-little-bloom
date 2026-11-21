# First playable smoke checklist

Current scope (21 Nov 2026): prototype 504 flowers, 56 per type, no first-person hands. The proposed 90-flower demo is not implemented. Track results against [KNOWN_ISSUES](../docs/KNOWN_ISSUES.md); record the exact commit and keep old baseline results separate.

Use isolated QA data for New Game/reset and malformed-save fixtures; do not overwrite personal progress. Continue restores flower state, not player position.

## Previous baseline checks

The checks below were run before the current expansion to nine types and two floors (currently 504 flowers). Repeat them for this updated build before treating it as verified.

- [x] Godot 4.7.2 headless editor import completed; no GDScript parse errors remain.
- [x] Main menu and gameplay scenes each started headless without runtime script errors.
- [x] Isolated QA copy passed inventory limit, wrong/correct basket, save/load, invalid-primary backup recovery, and reset checks (18 Nov 2026).
- [ ] Re-run import, menu/gameplay startup, and save-state checks for the expanded build.
- [ ] Open in the Godot GUI and inspect both floors, ramp, wall cabinets, flower batches, and HUD; headless startup does not check layout or feel.

## Automated staircase probe (D0, 21 Nov 2026)

Run `python3 tools/check_stairs.py` for the isolated physics check; see [results and limitations](../docs/STAIRCASE_CHECK.md). The patched build passed 140 round trips plus 12 stop/reversal legs with zero airborne ticks. Input is injected, so this does not check physical keyboard/touch behavior, rendering or Android devices. Keep the manual items below unchecked until actually performed.

## Desktop playthrough

- [ ] Main scene opens; player walks around without passing through walls, counter, shelf, or baskets.
- [ ] WASD/arrows move, captured mouse looks, E interacts, Esc releases the mouse.
- [ ] Camera pitch stays clamped; mouse clicks on menu/modal UI do not rotate the camera.
- [ ] First-person hands are absent; held-flower visuals do not cover the reticle, flowers, or touch buttons.
- [ ] Look at a flower within range; prompt names its type; interact picks it up and plays the pickup SFX.
- [ ] LB-002: Occluded flowers/baskets cannot be selected through a solid obstacle or floor; visible targets within reach still work.
- [ ] Inventory stops at five and shows the full-hands notice without removing the sixth flower.
- [ ] Correct basket accepts one matching flower; a wrong basket keeps the flower and plays the reject SFX.
- [ ] Progress increments once per successful placement; placed flowers appear in the basket.
- [ ] LB-001: Complete five consecutive up/down staircase round trips, including empty/full inventory and approaches near both rails. Reach all nine baskets. Record the extended 50-round-trip keyboard and 50-round-trip joystick checks separately; do not mark Android verified from desktop results.
- [ ] Check wall cabinets are attached to the walls and do not block the ramp, baskets, or flower pickups.
- [ ] Find and sort all 504 flowers across nine types; completion appears once, plays the completion cue, and Replay resets the level.
- [ ] LB-004: Complete from a valid QA save at 503 placed + the last flower carried; the completion label updates to 504 without reloading.
- [ ] Music and SFX sliders independently control their audio; zero volume mutes the corresponding bus.
- [ ] Pause, settings, reset confirmation, return to menu, Continue, New Game confirmation, and Credits work.
- [ ] Reset confirmation clears inventory and placed progress; canceling it preserves both.
- [ ] Quit/reopen restores inventory and placed flowers. Test a deliberately malformed save and backup recovery.

## Android device playthrough

- [ ] Install the debug build on a small landscape phone and a mid-range phone.
- [ ] Left thumb moves while right thumb looks; both work at the same time.
- [ ] LB-003: Keep move/look fingers held, add and release a third finger in the look region; the original look finger remains usable.
- [ ] Interact and pause buttons are reachable and do not also trigger camera drag.
- [ ] Check notches, system bars, text wrapping, modal sizes, and thumb reach in landscape.
- [ ] Open pause while moving, then resume; the player remains still until the joystick is touched again.
- [ ] Send the app to background while moving and while paused; resume without stuck input or lost saved progress.
- [ ] Complete pickup, wrong basket, correct basket, full inventory, floor transition, reset, and 504/504 completion on device.
- [ ] Run for 15 minutes; record FPS, load time, memory, temperature, OS version, and any crash.

Record device model, Android version, Godot version, build date, result, and reproduction steps for every issue.
