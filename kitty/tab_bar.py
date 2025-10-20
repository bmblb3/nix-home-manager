def draw_title(draw_data):
    from kitty.fast_data_types import get_boss

    tab_title = draw_data.get("title", "")
    tab_accessor = draw_data.get("tab")
    if tab_accessor:
        boss = get_boss()
        kitty_tab = boss.tab_for_id(tab_accessor.tab_id)
        if kitty_tab and kitty_tab.active_window:
            active_window_title = kitty_tab.active_window.title
            return f"{tab_title}/{active_window_title}"

    return tab_title
