import pygame

import battle_city.menu as menu
from battle_city import power_state


_original_check_input = menu.LevelSelection.check_input
_original_blit_screen = menu.Menu.blit_screen
_tab_was_pressed = False


def _change_power(delta):
    index = power_state.selected_player
    power_state.player_powers[index] = (
        power_state.player_powers[index] + delta
    ) % 4


def patched_check_input(self):
    global _tab_was_pressed

    keys = pygame.key.get_pressed()
    tab_pressed = bool(keys[pygame.K_TAB])
    if tab_pressed and not _tab_was_pressed:
        power_state.selected_player = 1 - power_state.selected_player
    _tab_was_pressed = tab_pressed

    if self.game.LEFT_KEY:
        _change_power(-1)
    if self.game.RIGHT_KEY:
        _change_power(1)

    _original_check_input(self)


def patched_blit_screen(self):
    if self.game.curr_menu is self.game.level_selection:
        selected = power_state.selected_player
        p1_prefix = '>' if selected == 0 else ' '
        p2_prefix = '>' if selected == 1 else ' '

        self.game.draw_text(
            f'{p1_prefix} P1 POWER: {power_state.player_powers[0] + 1}',
            10,
            self.game.DISPLAY_W / 2,
            self.game.DISPLAY_H - 34,
        )
        if menu.players_count == 2:
            self.game.draw_text(
                f'{p2_prefix} P2 POWER: {power_state.player_powers[1] + 1}',
                10,
                self.game.DISPLAY_W / 2,
                self.game.DISPLAY_H - 22,
            )
        self.game.draw_text(
            'TAB: PLAYER   LEFT/RIGHT: POWER',
            7,
            self.game.DISPLAY_W / 2,
            self.game.DISPLAY_H - 9,
        )

    _original_blit_screen(self)


menu.LevelSelection.check_input = patched_check_input
menu.Menu.blit_screen = patched_blit_screen
