from pathlib import Path

import pygame

import battle_city.menu as menu
import game as game_module
from battle_city.level import Level


MAPS_DIR = Path(__file__).resolve().parent.parent / 'maps'
LEVELS_PER_PAGE = 10


def available_levels():
    levels = []
    if MAPS_DIR.exists():
        for path in MAPS_DIR.glob('*.txt'):
            try:
                levels.append(int(path.stem))
            except ValueError:
                continue
    return sorted(set(levels)) or [1]


def _ensure_selection(screen):
    levels = available_levels()
    if not hasattr(screen, 'selected_level_index'):
        current = 1
        try:
            current = int(str(screen.state).split()[0])
        except (TypeError, ValueError, IndexError):
            pass
        screen.selected_level_index = (
            levels.index(current) if current in levels else 0
        )
    screen.selected_level_index %= len(levels)
    return levels


def dynamic_display_menu(self):
    self.run_display = True
    while self.run_display:
        self.game.check_events()
        self.check_input()
        if not self.run_display:
            break

        levels = _ensure_selection(self)
        selected = self.selected_level_index
        page = selected // LEVELS_PER_PAGE
        start = page * LEVELS_PER_PAGE
        visible = levels[start:start + LEVELS_PER_PAGE]

        self.game.small_display.fill(self.game.BLACK)
        self.game.draw_text(
            'SELECT LEVEL', 16,
            self.game.DISPLAY_W / 2,
            20,
        )

        for row, level_number in enumerate(visible):
            absolute_index = start + row
            marker = '>' if absolute_index == selected else ' '
            self.game.draw_text(
                f'{marker} LEVEL {level_number}', 11,
                self.game.DISPLAY_W / 2,
                42 + row * 13,
            )

        total_pages = max(1, (len(levels) + LEVELS_PER_PAGE - 1) // LEVELS_PER_PAGE)
        self.game.draw_text(
            f'PAGE {page + 1}/{total_pages}  LEVELS: {len(levels)}',
            7,
            self.game.DISPLAY_W / 2,
            178,
        )
        self.blit_screen()


def dynamic_check_input(self):
    levels = _ensure_selection(self)

    if self.game.BACK_KEY:
        self.game.curr_menu = self.game.main_menu
        self.run_display = False
        return

    if self.game.DOWN_KEY:
        self.selected_level_index = (self.selected_level_index + 1) % len(levels)
    elif self.game.UP_KEY:
        self.selected_level_index = (self.selected_level_index - 1) % len(levels)

    if self.game.START_KEY:
        level_number = levels[self.selected_level_index]
        self.game.level = Level(level_number, menu.players_count, self.game)
        self.game.playing = True
        self.run_display = False


def dynamic_next_round(self):
    levels = available_levels()
    current = self.level.number
    following = [number for number in levels if number > current]

    if not following:
        self.win()
        return

    next_level = following[0]
    if next_level > self.unlocked_levels:
        self.unlocked_levels = next_level
    self.go_to_next_round()


menu.LevelSelection.display_menu = dynamic_display_menu
menu.LevelSelection.check_input = dynamic_check_input
game_module.Game.process_next_round_transition = dynamic_next_round
